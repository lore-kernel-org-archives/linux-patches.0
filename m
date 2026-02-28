Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FBB32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301262; cv=none; b=NT8flYpbWDvzSwO6yt8b+XC4gd8kOT4arMBHIJHdH4NdZDmUtHuWTQqGlg0mKzPjUErAesGMWclXz46IEqXx+PuGl5cdJ8pJxqj3xWWW4+/Xn4vcrslgLmXpK3mKo/VqU8nI0BUoen2BPw8VpTE6dlfG96HfPGuj1wV4boGO4gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301262; c=relaxed/simple;
	bh=E419lU17SR2cobJz6tieblMKpyzRNJc7+8LizYxdkhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd74IzzJY0AymB9sUrfAhEz7qSidKYsjCam3RVgMj29Nd4PDu0BA5jeT6QkXq1HtAL+UAI8awYwsHA7HJtPkC5DuCatzS54UJd5o+VMS81zo5CMvqzgfn+3aG0QsStXY16Gho15Oioy0bPCW0iKY9ZmnWEoMo/b/op2zau9z6gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BH4EI/zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BH4EI/zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5427C19423;
	Sat, 28 Feb 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301262;
	bh=E419lU17SR2cobJz6tieblMKpyzRNJc7+8LizYxdkhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH4EI/zCjNqE78MSzOMI1ztC6am9eJLiT4AelHxuDPYhwhw9LcEjBGYDqSeXOJhvV
	 YqLBmbGbOjO15QJonrD6VUOWNUNz0VcBYp2Zmpb/n4fvvV+ES+4fNFOSJQATkv2Otc
	 HwOIcFtwfLtuBp4IuO8ze4w+hsKaZXrrA5nGU/qWr3Ih+81stUzPNLGGZwCg0hRm+z
	 cokY0Ia1rx8ceyB8WE80Qwe27BDvEdqLbElgv/+mnoNBR/+yYjlU28Jbxw5POJGASh
	 aRWl+jGy1Xq/+1gdybSPoyOVTg9nyRVRQD1BFplNcWCEdrWBVC56a0QqEldnXCJ7ab
	 UmvYMNTGivpJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/752] team: avoid NETDEV_CHANGEMTU event when unregistering slave
Date: Sat, 28 Feb 2026 12:42:37 -0500
Message-ID: <20260228174750.1542406-446-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit bb4c698633c0e19717586a6524a33196cff01a32 ]

syzbot is reporting

  unregister_netdevice: waiting for netdevsim0 to become free. Usage count = 3
  ref_tracker: netdev@ffff88807dcf8618 has 1/2 users at
       __netdev_tracker_alloc include/linux/netdevice.h:4400 [inline]
       netdev_hold include/linux/netdevice.h:4429 [inline]
       inetdev_init+0x201/0x4e0 net/ipv4/devinet.c:286
       inetdev_event+0x251/0x1610 net/ipv4/devinet.c:1600
       notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
       call_netdevice_notifiers_mtu net/core/dev.c:2318 [inline]
       netif_set_mtu_ext+0x5aa/0x800 net/core/dev.c:9886
       netif_set_mtu+0xd7/0x1b0 net/core/dev.c:9907
       dev_set_mtu+0x126/0x260 net/core/dev_api.c:248
       team_port_del+0xb07/0xcb0 drivers/net/team/team_core.c:1333
       team_del_slave drivers/net/team/team_core.c:1936 [inline]
       team_device_event+0x207/0x5b0 drivers/net/team/team_core.c:2929
       notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
       call_netdevice_notifiers_extack net/core/dev.c:2281 [inline]
       call_netdevice_notifiers net/core/dev.c:2295 [inline]
       __dev_change_net_namespace+0xcb7/0x2050 net/core/dev.c:12592
       do_setlink+0x2ce/0x4590 net/core/rtnetlink.c:3060
       rtnl_changelink net/core/rtnetlink.c:3776 [inline]
       __rtnl_newlink net/core/rtnetlink.c:3935 [inline]
       rtnl_newlink+0x15a9/0x1be0 net/core/rtnetlink.c:4072
       rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:6958
       netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894

problem. Ido Schimmel found steps to reproduce

  ip link add name team1 type team
  ip link add name dummy1 mtu 1499 master team1 type dummy
  ip netns add ns1
  ip link set dev dummy1 netns ns1
  ip -n ns1 link del dev dummy1

and also found that the same issue was fixed in the bond driver in
commit f51048c3e07b ("bonding: avoid NETDEV_CHANGEMTU event when
unregistering slave").

Let's do similar thing for the team driver, with commit ad7c7b2172c3 ("net:
hold netdev instance lock during sysfs operations") and commit 303a8487a657
("net: s/__dev_set_mtu/__netif_set_mtu/") also applied.

Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260224125709.317574-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index d5da2f0774637..6ec6708c52e2d 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1291,7 +1291,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 
 static void __team_port_change_port_removed(struct team_port *port);
 
-static int team_port_del(struct team *team, struct net_device *port_dev)
+static int team_port_del(struct team *team, struct net_device *port_dev, bool unregister)
 {
 	struct net_device *dev = team->dev;
 	struct team_port *port;
@@ -1329,7 +1329,13 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	__team_port_change_port_removed(port);
 
 	team_port_set_orig_dev_addr(port);
-	dev_set_mtu(port_dev, port->orig.mtu);
+	if (unregister) {
+		netdev_lock_ops(port_dev);
+		__netif_set_mtu(port_dev, port->orig.mtu);
+		netdev_unlock_ops(port_dev);
+	} else {
+		dev_set_mtu(port_dev, port->orig.mtu);
+	}
 	kfree_rcu(port, rcu);
 	netdev_info(dev, "Port device %s removed\n", portname);
 	netdev_compute_master_upper_features(team->dev, true);
@@ -1633,7 +1639,7 @@ static void team_uninit(struct net_device *dev)
 	ASSERT_RTNL();
 
 	list_for_each_entry_safe(port, tmp, &team->port_list, list)
-		team_port_del(team, port->dev);
+		team_port_del(team, port->dev, false);
 
 	__team_change_mode(team, NULL); /* cleanup */
 	__team_options_unregister(team, team_options, ARRAY_SIZE(team_options));
@@ -1932,7 +1938,16 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 
 	ASSERT_RTNL();
 
-	return team_port_del(team, port_dev);
+	return team_port_del(team, port_dev, false);
+}
+
+static int team_del_slave_on_unregister(struct net_device *dev, struct net_device *port_dev)
+{
+	struct team *team = netdev_priv(dev);
+
+	ASSERT_RTNL();
+
+	return team_port_del(team, port_dev, true);
 }
 
 static netdev_features_t team_fix_features(struct net_device *dev,
@@ -2925,7 +2940,7 @@ static int team_device_event(struct notifier_block *unused,
 					       !!netif_oper_up(port->dev));
 		break;
 	case NETDEV_UNREGISTER:
-		team_del_slave(port->team->dev, dev);
+		team_del_slave_on_unregister(port->team->dev, dev);
 		break;
 	case NETDEV_FEAT_CHANGE:
 		if (!port->team->notifier_ctx) {
@@ -2998,3 +3013,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jiri Pirko <jpirko@redhat.com>");
 MODULE_DESCRIPTION("Ethernet team device driver");
 MODULE_ALIAS_RTNL_LINK(DRV_NAME);
+MODULE_IMPORT_NS("NETDEV_INTERNAL");
-- 
2.51.0

