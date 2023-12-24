#!/bin/sh
set -e -u

hostname="lugos-live"
echo $hostname > /etc/hostname

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
# echo -e 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen

# sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
pacman-key --init
pacman-key --populate

grub-mkconfig -o /boot/grub/grub.cfg
# rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
usermod -aG wheel,input,video,audio,kvm stig
sed -E -i '/^#\s*%wheel.*NOPASSWD/{s/^#\s*//}' /etc/sudoers

systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable bluetooth
ln -s /usr/lib/systemd/system/gdm.service /etc/systemd/system/display-manager.service
usermod -aG audio,network,optical,rfkill,storage,power,input,wheel lug
groupadd -r autologin
gpasswd -a lug autologin
systemctl set-default graphical.target
# systemctl enable libvirtd
# sed -i 's/^#unix_sock_group/unix_sock_group/;s/^#unix_sock_rw_perms/unix_sock_rw_perms/' /etc/libvirt/libvirtd.conf
# usermod -aG libvirt lug
