Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAAB20897E;
	Tue,  8 Apr 2025 11:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110942; cv=none; b=iUvEShYjpuefBDwJ1vRqS3j/b5kDRdJMQ+54OF7bzr0r6g0ypeO4wRD5mes6UkGt3+EpLTUfTMnDlE+NXGTUYXDZYZOwNJJ80RhuGZNajWwxl0mYsmOpPvGjRqz83Rj8821MFe3A4iId0p4QUwm8hG0GoJTg/Sc2DKnFltLiiLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110942; c=relaxed/simple;
	bh=M2AvPxsp1X5RLu2rF55e3L8zpVefJW9y4sD6F2LDx2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUM8n0UahM7hpx4h2RywTOXy0c8AF6AbyjLd0e5/rQ11sYQIRIynAcNUB/JCW9BI7kVOgaXjTHGyCkhm7jt7KQY0l1X1uByrW6FGonDMzCVDwpCQ5xnbGR/g+ngEr+xOhV0i/3YoPZ6u7CroGNQqRnBUXl1Ew7v17tB9u11VGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/ugNQWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/ugNQWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819CAC4CEE5;
	Tue,  8 Apr 2025 11:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110940;
	bh=M2AvPxsp1X5RLu2rF55e3L8zpVefJW9y4sD6F2LDx2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/ugNQWcCYGVw7h2qMu/fD6B75QWRv6W1NsdjyVkOGK17SxSJegSNkJOuWV+AqtYg
	 xwDit5Bbt43l90RGLkZeH/wUZbca4JYPOWXvzX5QK9sR5T+6SEy8VzlHHrJZg2M65X
	 jxFImtfYuubv8fO+hYrK6soHO/cPVBMRbdCf79qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jussi Maki <joamaki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 249/731] bonding: check xdp prog when set bond mode
Date: Tue,  8 Apr 2025 12:42:26 +0200
Message-ID: <20250408104920.075877316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 094ee6017ea09c11d6af187935a949df32803ce0 ]

Following operations can trigger a warning[1]:

    ip netns add ns1
    ip netns exec ns1 ip link add bond0 type bond mode balance-rr
    ip netns exec ns1 ip link set dev bond0 xdp obj af_xdp_kern.o sec xdp
    ip netns exec ns1 ip link set bond0 type bond mode broadcast
    ip netns del ns1

When delete the namespace, dev_xdp_uninstall() is called to remove xdp
program on bond dev, and bond_xdp_set() will check the bond mode. If bond
mode is changed after attaching xdp program, the warning may occur.

Some bond modes (broadcast, etc.) do not support native xdp. Set bond mode
with xdp program attached is not good. Add check for xdp program when set
bond mode.

    [1]
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 11 at net/core/dev.c:9912 unregister_netdevice_many_notify+0x8d9/0x930
    Modules linked in:
    CPU: 0 UID: 0 PID: 11 Comm: kworker/u4:0 Not tainted 6.14.0-rc4 #107
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
    Workqueue: netns cleanup_net
    RIP: 0010:unregister_netdevice_many_notify+0x8d9/0x930
    Code: 00 00 48 c7 c6 6f e3 a2 82 48 c7 c7 d0 b3 96 82 e8 9c 10 3e ...
    RSP: 0018:ffffc90000063d80 EFLAGS: 00000282
    RAX: 00000000ffffffa1 RBX: ffff888004959000 RCX: 00000000ffffdfff
    RDX: 0000000000000000 RSI: 00000000ffffffea RDI: ffffc90000063b48
    RBP: ffffc90000063e28 R08: ffffffff82d39b28 R09: 0000000000009ffb
    R10: 0000000000000175 R11: ffffffff82d09b40 R12: ffff8880049598e8
    R13: 0000000000000001 R14: dead000000000100 R15: ffffc90000045000
    FS:  0000000000000000(0000) GS:ffff888007a00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 000000000d406b60 CR3: 000000000483e000 CR4: 00000000000006f0
    Call Trace:
     <TASK>
     ? __warn+0x83/0x130
     ? unregister_netdevice_many_notify+0x8d9/0x930
     ? report_bug+0x18e/0x1a0
     ? handle_bug+0x54/0x90
     ? exc_invalid_op+0x18/0x70
     ? asm_exc_invalid_op+0x1a/0x20
     ? unregister_netdevice_many_notify+0x8d9/0x930
     ? bond_net_exit_batch_rtnl+0x5c/0x90
     cleanup_net+0x237/0x3d0
     process_one_work+0x163/0x390
     worker_thread+0x293/0x3b0
     ? __pfx_worker_thread+0x10/0x10
     kthread+0xec/0x1e0
     ? __pfx_kthread+0x10/0x10
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x2f/0x50
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    ---[ end trace 0000000000000000 ]---

Fixes: 9e2ee5c7e7c3 ("net, bonding: Add XDP support to the bonding driver")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Acked-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250321044852.1086551-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    | 8 ++++----
 drivers/net/bonding/bond_options.c | 3 +++
 include/net/bonding.h              | 1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e45bba240cbcd..4da5fcb7def47 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -322,9 +322,9 @@ static bool bond_sk_check(struct bonding *bond)
 	}
 }
 
-static bool bond_xdp_check(struct bonding *bond)
+bool bond_xdp_check(struct bonding *bond, int mode)
 {
-	switch (BOND_MODE(bond)) {
+	switch (mode) {
 	case BOND_MODE_ROUNDROBIN:
 	case BOND_MODE_ACTIVEBACKUP:
 		return true;
@@ -1937,7 +1937,7 @@ void bond_xdp_set_features(struct net_device *bond_dev)
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond) || !bond_has_slaves(bond)) {
+	if (!bond_xdp_check(bond, BOND_MODE(bond)) || !bond_has_slaves(bond)) {
 		xdp_clear_features_flag(bond_dev);
 		return;
 	}
@@ -5699,7 +5699,7 @@ static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond)) {
+	if (!bond_xdp_check(bond, BOND_MODE(bond))) {
 		BOND_NL_ERR(dev, extack,
 			    "No native XDP support for the current bonding mode");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index d1b095af253bd..91893c29b8995 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -868,6 +868,9 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
+	if (bond->xdp_prog && !bond_xdp_check(bond, newval->value))
+		return -EOPNOTSUPP;
+
 	if (!bond_mode_uses_arp(newval->value)) {
 		if (bond->params.arp_interval) {
 			netdev_dbg(bond->dev, "%s mode is incompatible with arp monitoring, start mii monitoring\n",
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 8bb5f016969f1..95f67b308c19a 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -695,6 +695,7 @@ void bond_debug_register(struct bonding *bond);
 void bond_debug_unregister(struct bonding *bond);
 void bond_debug_reregister(struct bonding *bond);
 const char *bond_mode_name(int mode);
+bool bond_xdp_check(struct bonding *bond, int mode);
 void bond_setup(struct net_device *bond_dev);
 unsigned int bond_get_num_tx_queues(void);
 int bond_netlink_init(void);
-- 
2.39.5



