Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A462A353360;
	Tue, 26 Aug 2025 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217171; cv=none; b=CqOd6OoQFhFG6UP3fRdzWMNt+3Ffab8aVbdqnAnk7xZgFZsUHhquoif9Aatgi1HwBSA+xLe00IjSWiKgnXyHdawffAO6nGHPWRHKjTUwPefHG0QQvMj8hm5d7tS5K2wfzVmBFI3lvo+3rpkwsC25M/SpNvsqb9vxqPf9cNJpodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217171; c=relaxed/simple;
	bh=b8JS8xwhrEGuFBlXdEFpPwWZxtgaYNifW2Q4tDoq2wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5rMAFQ3Ki8p9XEKZ6t3cP9mlfX+2ptkEllY4dGHmZV6P3lOtV0VMJbj8WlWD6BcLlTIgcPVEBkprNuqwpHh90ar/pGZtk5wEIpP6MzxDkD4QOt1/ihDt2/PDE2oZyxSp1aaCf0DelRDLmPVymBTWujtycjEokmmlKRu+92no7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+cGgRAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+cGgRAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A19C19421;
	Tue, 26 Aug 2025 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217171;
	bh=b8JS8xwhrEGuFBlXdEFpPwWZxtgaYNifW2Q4tDoq2wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+cGgRAvqBuKP5B1E0jP7sbUcDf68z5f8IHIhCausdqh9MM51awLIKB4WNi8dYMDV
	 YrrhLHZyiOOB4IRgdmwOEyOe4upRi4tza0sRm9EIooQGZdYf3nYhB6xuG9q/7SuRfz
	 TLOYBeRbaV4aRcI0YOxNDYskN/I2qHJLmCk5FK1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8b046e462915c65b10b@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@idosch.org>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/523] net: vlan: fix VLAN 0 refcount imbalance of toggling filtering during runtime
Date: Tue, 26 Aug 2025 13:04:13 +0200
Message-ID: <20250826110925.665408909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 579d4f9ca9a9a605184a9b162355f6ba131f678d ]

Assuming the "rx-vlan-filter" feature is enabled on a net device, the
8021q module will automatically add or remove VLAN 0 when the net device
is put administratively up or down, respectively. There are a couple of
problems with the above scheme.

The first problem is a memory leak that can happen if the "rx-vlan-filter"
feature is disabled while the device is running:

 # ip link add bond1 up type bond mode 0
 # ethtool -K bond1 rx-vlan-filter off
 # ip link del dev bond1

When the device is put administratively down the "rx-vlan-filter"
feature is disabled, so the 8021q module will not remove VLAN 0 and the
memory will be leaked [1].

Another problem that can happen is that the kernel can automatically
delete VLAN 0 when the device is put administratively down despite not
adding it when the device was put administratively up since during that
time the "rx-vlan-filter" feature was disabled. null-ptr-unref or
bug_on[2] will be triggered by unregister_vlan_dev() for refcount
imbalance if toggling filtering during runtime:

$ ip link add bond0 type bond mode 0
$ ip link add link bond0 name vlan0 type vlan id 0 protocol 802.1q
$ ethtool -K bond0 rx-vlan-filter off
$ ifconfig bond0 up
$ ethtool -K bond0 rx-vlan-filter on
$ ifconfig bond0 down
$ ip link del vlan0

Root cause is as below:
step1: add vlan0 for real_dev, such as bond, team.
register_vlan_dev
    vlan_vid_add(real_dev,htons(ETH_P_8021Q),0) //refcnt=1
step2: disable vlan filter feature and enable real_dev
step3: change filter from 0 to 1
vlan_device_event
    vlan_filter_push_vids
        ndo_vlan_rx_add_vid //No refcnt added to real_dev vlan0
step4: real_dev down
vlan_device_event
    vlan_vid_del(dev, htons(ETH_P_8021Q), 0); //refcnt=0
        vlan_info_rcu_free //free vlan0
step5: delete vlan0
unregister_vlan_dev
    BUG_ON(!vlan_info); //vlan_info is null

Fix both problems by noting in the VLAN info whether VLAN 0 was
automatically added upon NETDEV_UP and based on that decide whether it
should be deleted upon NETDEV_DOWN, regardless of the state of the
"rx-vlan-filter" feature.

[1]
unreferenced object 0xffff8880068e3100 (size 256):
  comm "ip", pid 384, jiffies 4296130254
  hex dump (first 32 bytes):
    00 20 30 0d 80 88 ff ff 00 00 00 00 00 00 00 00  . 0.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 81ce31fa):
    __kmalloc_cache_noprof+0x2b5/0x340
    vlan_vid_add+0x434/0x940
    vlan_device_event.cold+0x75/0xa8
    notifier_call_chain+0xca/0x150
    __dev_notify_flags+0xe3/0x250
    rtnl_configure_link+0x193/0x260
    rtnl_newlink_create+0x383/0x8e0
    __rtnl_newlink+0x22c/0xa40
    rtnl_newlink+0x627/0xb00
    rtnetlink_rcv_msg+0x6fb/0xb70
    netlink_rcv_skb+0x11f/0x350
    netlink_unicast+0x426/0x710
    netlink_sendmsg+0x75a/0xc20
    __sock_sendmsg+0xc1/0x150
    ____sys_sendmsg+0x5aa/0x7b0
    ___sys_sendmsg+0xfc/0x180

[2]
kernel BUG at net/8021q/vlan.c:99!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 382 Comm: ip Not tainted 6.16.0-rc3 #61 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:unregister_vlan_dev (net/8021q/vlan.c:99 (discriminator 1))
RSP: 0018:ffff88810badf310 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810da84000 RCX: ffffffffb47ceb9a
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff88810e8b43c8
RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff6cefe80
R10: ffffffffb677f407 R11: ffff88810badf3c0 R12: ffff88810e8b4000
R13: 0000000000000000 R14: ffff88810642a5c0 R15: 000000000000017e
FS:  00007f1ff68c20c0(0000) GS:ffff888163a24000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ff5dad240 CR3: 0000000107e56000 CR4: 00000000000006f0
Call Trace:
 <TASK>
rtnl_dellink (net/core/rtnetlink.c:3511 net/core/rtnetlink.c:3553)
rtnetlink_rcv_msg (net/core/rtnetlink.c:6945)
netlink_rcv_skb (net/netlink/af_netlink.c:2535)
netlink_unicast (net/netlink/af_netlink.c:1314 net/netlink/af_netlink.c:1339)
netlink_sendmsg (net/netlink/af_netlink.c:1883)
____sys_sendmsg (net/socket.c:712 net/socket.c:727 net/socket.c:2566)
___sys_sendmsg (net/socket.c:2622)
__sys_sendmsg (net/socket.c:2652)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)

Fixes: ad1afb003939 ("vlan_dev: VLAN 0 should be treated as "no vlan tag" (802.1p packet)")
Reported-by: syzbot+a8b046e462915c65b10b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a8b046e462915c65b10b
Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250716034504.2285203-2-dongchenchen2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 42 +++++++++++++++++++++++++++++++++---------
 net/8021q/vlan.h |  1 +
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index b45b9c9b12684..07b829d19e01e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -356,6 +356,35 @@ static int __vlan_device_event(struct net_device *dev, unsigned long event)
 	return err;
 }
 
+static void vlan_vid0_add(struct net_device *dev)
+{
+	struct vlan_info *vlan_info;
+	int err;
+
+	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		return;
+
+	pr_info("adding VLAN 0 to HW filter on device %s\n", dev->name);
+
+	err = vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
+	if (err)
+		return;
+
+	vlan_info = rtnl_dereference(dev->vlan_info);
+	vlan_info->auto_vid0 = true;
+}
+
+static void vlan_vid0_del(struct net_device *dev)
+{
+	struct vlan_info *vlan_info = rtnl_dereference(dev->vlan_info);
+
+	if (!vlan_info || !vlan_info->auto_vid0)
+		return;
+
+	vlan_info->auto_vid0 = false;
+	vlan_vid_del(dev, htons(ETH_P_8021Q), 0);
+}
+
 static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 			     void *ptr)
 {
@@ -377,15 +406,10 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 			return notifier_from_errno(err);
 	}
 
-	if ((event == NETDEV_UP) &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
-		pr_info("adding VLAN 0 to HW filter on device %s\n",
-			dev->name);
-		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
-	}
-	if (event == NETDEV_DOWN &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-		vlan_vid_del(dev, htons(ETH_P_8021Q), 0);
+	if (event == NETDEV_UP)
+		vlan_vid0_add(dev);
+	else if (event == NETDEV_DOWN)
+		vlan_vid0_del(dev);
 
 	vlan_info = rtnl_dereference(dev->vlan_info);
 	if (!vlan_info)
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index c373492771146..2633b7616526f 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -33,6 +33,7 @@ struct vlan_info {
 	struct vlan_group	grp;
 	struct list_head	vid_list;
 	unsigned int		nr_vids;
+	bool			auto_vid0;
 	struct rcu_head		rcu;
 };
 
-- 
2.39.5



