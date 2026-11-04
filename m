Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826802;
	b=jkY5e+OPWJl864hTsvV32orKA2Kjs1cZbHreCEE9QkAUFLk4NiIZ1AfY9gQkoftb6oea
	 B6CcmU5gqBloCoNa0Y55QY3aopsYQcNrhVhd/8y+mZChjYSyu8SrWltM4PZUzlRpBFsYA
	 k9Fn4+cDmyvOqo9uLahmRK/Ixy/oNcKOdIU+5EWdgLkqxHJ4eBu2wakKUY0W4TWRX/0B6
	 aINu/KdKhKXCEQG+a2cu5oGlbFd7/o2pRy647rCsJw9bJL/QC1tLQXj6Li2imSzYlolb4
	 KxSK7tvt0E532wdePN1fsVEgO+8yIIoF5JnX66CPybJSqNCpvLkzZ1K2xzIgAVxRz+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bNNDvIWX6SlTOuMGdOxsalaGNMAXJJdoIwRcrQoSD14=;
	b=UbEijJgHzcdvTy5nWg0s0/hQE0MnwLuJbNE7QeFtdz3PAQEJtnXANRCGz4Tk4qy9tkgH
	 s7Sqe1uDPB+8tKTwgLt7w3J4xkjrquCfzPJlE9tkx6CbBtGSuVw6WhUgV6aEKeSAvExAl
	 ZfQrTQRxXiTdaARi1GM63wV4kG0CDWyyg5ClDqxR4VnjDc+RgVn6RiQvpK67nz0VJ3xMN
	 RyKJkyZ/FW9/0BRGtY1cdZEAvnuuCeZkzt+6F92yuArWiTEvPXoQ1VJkfFLFViXuNNso2
	 JPhuTFVPEshsQXbahs2T3w+ujNBeCjS9AVtY+LUs8BUV/8Vl6LIZzAPOWRdM/X0hEFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJMKfYeB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591586071AC4;
	Wed,  4 Nov 2026 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJMKfYeB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86901F000C1;
	Wed,  4 Nov 2026 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826802;
	bh=bNNDvIWX6SlTOuMGdOxsalaGNMAXJJdoIwRcrQoSD14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJMKfYeBZl35y+lTQ+Y54axOhsYVyhxwXA3505cJhmgAAN178DuWRPpofcNKDEJLk
	 F/+Rv9ck6hAVA8WqPjuSOrFPzB9QUxU1fdV037mTagczd7NN6izAkgso6oJlTJJh5X
	 PJd5pW4w7BUKplwRYJ78lu4WzvHP+6l4ln+bJZEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Tonghao Zhang <tonghao@bamaicloud.com>,
	Struan Bartlett <struan.bartlett@newsnow.co.uk>
Subject: [PATCH 6.18 0012/1005] net: bonding: use workqueue to make sure peer notify updated in lacp mode
Date: Wed,  4 Nov 2026 15:55:45 -0500
Message-ID: <20261104211043.883924307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tonghao Zhang <tonghao@bamaicloud.com>

commit 11ea9b8a88dd7524c23dffc22d8173504273a9db upstream.

The rtnl lock might be locked, preventing ad_cond_set_peer_notif() from
acquiring the lock and updating send_peer_notif. This patch addresses
the issue by using a workqueue. Since updating send_peer_notif does
not require high real-time performance, such delayed updates are entirely
acceptable.

In fact, checking this value and using it in multiple places, all operations
are protected at the same time by rtnl lock, such as
- read send_peer_notif
- send_peer_notif--
- bond_should_notify_peers

By the way, rtnl lock is still required, when accessing bond.params.* for
updating send_peer_notif. In lacp mode, resetting send_peer_notif in
workqueue is safe, simple and effective way.

Additionally, this patch introduces bond_peer_notify_may_events(), which
is used to check whether an event should be sent. This function will be
used in both patch 1 and 2.

Cc: Jay Vosburgh <jv@jvosburgh.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>
Suggested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/f95accb5db0b10ce3ed2f834fc70f716c9abbb9c.1768709239.git.tonghao@bamaicloud.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Struan Bartlett <struan.bartlett@newsnow.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_3ad.c  |    7 +---
 drivers/net/bonding/bond_main.c |   66 +++++++++++++++++++++++++++++++---------
 include/net/bonding.h           |    2 +
 3 files changed, 56 insertions(+), 19 deletions(-)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1014,11 +1014,8 @@ static void ad_cond_set_peer_notif(struc
 {
 	struct bonding *bond = port->slave->bond;
 
-	if (bond->params.broadcast_neighbor && rtnl_trylock()) {
-		bond->send_peer_notif = bond->params.num_peer_notif *
-			max(1, bond->params.peer_notif_delay);
-		rtnl_unlock();
-	}
+	if (bond->params.broadcast_neighbor)
+		bond_peer_notify_work_rearm(bond, 0);
 }
 
 /**
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1203,6 +1203,48 @@ static bool bond_should_notify_peers(str
 	return true;
 }
 
+/* Use this to update send_peer_notif when RTNL may be held in other places. */
+void bond_peer_notify_work_rearm(struct bonding *bond, unsigned long delay)
+{
+	queue_delayed_work(bond->wq, &bond->peer_notify_work, delay);
+}
+
+/* Peer notify update handler. Holds only RTNL */
+static void bond_peer_notify_reset(struct bonding *bond)
+{
+	bond->send_peer_notif = bond->params.num_peer_notif *
+		max(1, bond->params.peer_notif_delay);
+}
+
+static void bond_peer_notify_handler(struct work_struct *work)
+{
+	struct bonding *bond = container_of(work, struct bonding,
+					    peer_notify_work.work);
+
+	if (!rtnl_trylock()) {
+		bond_peer_notify_work_rearm(bond, 1);
+		return;
+	}
+
+	bond_peer_notify_reset(bond);
+
+	rtnl_unlock();
+}
+
+/* Peer notify events post. Holds only RTNL */
+static void bond_peer_notify_may_events(struct bonding *bond, bool force)
+{
+	bool notified = false;
+
+	if (bond_should_notify_peers(bond)) {
+		notified = true;
+		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, bond->dev);
+	}
+
+	if (notified || force)
+		bond->send_peer_notif--;
+}
+
 /**
  * bond_change_active_slave - change the active slave into the specified one
  * @bond: our bonding struct
@@ -1278,8 +1320,6 @@ void bond_change_active_slave(struct bon
 						      BOND_SLAVE_NOTIFY_NOW);
 
 		if (new_active) {
-			bool should_notify_peers = false;
-
 			bond_set_slave_active_flags(new_active,
 						    BOND_SLAVE_NOTIFY_NOW);
 
@@ -1287,19 +1327,11 @@ void bond_change_active_slave(struct bon
 				bond_do_fail_over_mac(bond, new_active,
 						      old_active);
 
-			if (netif_running(bond->dev)) {
-				bond->send_peer_notif =
-					bond->params.num_peer_notif *
-					max(1, bond->params.peer_notif_delay);
-				should_notify_peers =
-					bond_should_notify_peers(bond);
-			}
-
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
-			if (should_notify_peers) {
-				bond->send_peer_notif--;
-				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
-							 bond->dev);
+
+			if (netif_running(bond->dev)) {
+				bond_peer_notify_reset(bond);
+				bond_peer_notify_may_events(bond, false);
 			}
 		}
 	}
@@ -4288,6 +4320,10 @@ static u32 bond_xmit_hash_xdp(struct bon
 
 void bond_work_init_all(struct bonding *bond)
 {
+	/* ndo_stop, bond_close() will try to flush the work under
+	 * the rtnl lock. The workqueue must not block on rtnl lock
+	 * to avoid deadlock.
+	 */
 	INIT_DELAYED_WORK(&bond->mcast_work,
 			  bond_resend_igmp_join_requests_delayed);
 	INIT_DELAYED_WORK(&bond->alb_work, bond_alb_monitor);
@@ -4295,6 +4331,7 @@ void bond_work_init_all(struct bonding *
 	INIT_DELAYED_WORK(&bond->arp_work, bond_arp_monitor);
 	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
+	INIT_DELAYED_WORK(&bond->peer_notify_work, bond_peer_notify_handler);
 }
 
 void bond_work_cancel_all(struct bonding *bond)
@@ -4305,6 +4342,7 @@ void bond_work_cancel_all(struct bonding
 	cancel_delayed_work_sync(&bond->ad_work);
 	cancel_delayed_work_sync(&bond->mcast_work);
 	cancel_delayed_work_sync(&bond->slave_arr_work);
+	cancel_delayed_work_sync(&bond->peer_notify_work);
 }
 
 static int bond_open(struct net_device *bond_dev)
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -255,6 +255,7 @@ struct bonding {
 	struct   delayed_work ad_work;
 	struct   delayed_work mcast_work;
 	struct   delayed_work slave_arr_work;
+	struct   delayed_work peer_notify_work;
 #ifdef CONFIG_DEBUG_FS
 	/* debugging support via debugfs */
 	struct	 dentry *debug_dir;
@@ -712,6 +713,7 @@ struct bond_vlan_tag *bond_verify_device
 					      int level);
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave);
 void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay);
+void bond_peer_notify_work_rearm(struct bonding *bond, unsigned long delay);
 void bond_work_init_all(struct bonding *bond);
 void bond_work_cancel_all(struct bonding *bond);
 


