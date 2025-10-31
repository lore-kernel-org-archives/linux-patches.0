Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C13821FF25;
	Fri, 31 Oct 2025 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919477; cv=none; b=o0b8H+S4OghmGdGwrSQf4Am0SVf0ErV0RKd39i21+84YSGRWWbzVINYH8qFR/hkI0RUhzkkbBi1B/NINMAYOcdmBMLCDAmYTa/DdVSpcgcAkVHU1SDAhfIIJECtANKyJJYXtkL+eGKVjepiZ7TScfwq8wCOJobXHPWcrFW3Gglg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919477; c=relaxed/simple;
	bh=3gIx76+rgrHOdTvLFa/w5vxBGj6dchpqmQZmOYRcYtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0uEWQNBxFKdLYMAhLsYoym1MUXfvvkqGAG0PcNyU4kug3kMShn7P0oC8zOQX8epB1XgF1MF+PSYgjBWWNXPursOyeuNRCfUaA6S79ng8ZDjXxHKNHluCH71FDF3zNvPoO4RxaM89G0DM6TxbG4MeDZGY/o5bHllBNdiLzYdWJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emTf1ilB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emTf1ilB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFC5C4CEE7;
	Fri, 31 Oct 2025 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919477;
	bh=3gIx76+rgrHOdTvLFa/w5vxBGj6dchpqmQZmOYRcYtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emTf1ilBUkr/yc733Znr/uoFUY4yFWD2JHrt08KeQKtOMVXxPJLwYHwCu0AStfzOn
	 kBluaS/VnYaNUxVNtqiIAty62VOMhvQQkz4Xqz79RROD9+VMvyW7WtjsQqnloI4d8I
	 DysX4jIAmVwND8ndLwPOqzt7ZZmVNwr1DI4lCS1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jussi Maki <joamaki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.12 31/40] bonding: check xdp prog when set bond mode
Date: Fri, 31 Oct 2025 15:01:24 +0100
Message-ID: <20251031140044.774652749@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c    |    8 ++++----
 drivers/net/bonding/bond_options.c |    3 +++
 include/net/bonding.h              |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -322,9 +322,9 @@ static bool bond_sk_check(struct bonding
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
@@ -1930,7 +1930,7 @@ void bond_xdp_set_features(struct net_de
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond) || !bond_has_slaves(bond)) {
+	if (!bond_xdp_check(bond, BOND_MODE(bond)) || !bond_has_slaves(bond)) {
 		xdp_clear_features_flag(bond_dev);
 		return;
 	}
@@ -5699,7 +5699,7 @@ static int bond_xdp_set(struct net_devic
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond)) {
+	if (!bond_xdp_check(bond, BOND_MODE(bond))) {
 		BOND_NL_ERR(dev, extack,
 			    "No native XDP support for the current bonding mode");
 		return -EOPNOTSUPP;
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -868,6 +868,9 @@ static bool bond_set_xfrm_features(struc
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
+	if (bond->xdp_prog && !bond_xdp_check(bond, newval->value))
+		return -EOPNOTSUPP;
+
 	if (!bond_mode_uses_arp(newval->value)) {
 		if (bond->params.arp_interval) {
 			netdev_dbg(bond->dev, "%s mode is incompatible with arp monitoring, start mii monitoring\n",
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -695,6 +695,7 @@ void bond_debug_register(struct bonding
 void bond_debug_unregister(struct bonding *bond);
 void bond_debug_reregister(struct bonding *bond);
 const char *bond_mode_name(int mode);
+bool bond_xdp_check(struct bonding *bond, int mode);
 void bond_setup(struct net_device *bond_dev);
 unsigned int bond_get_num_tx_queues(void);
 int bond_netlink_init(void);


