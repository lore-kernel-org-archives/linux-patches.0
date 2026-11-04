Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826799;
	b=Zs1RJg9a+5+aIs8YAXLCbVXxYh16f+d9q3Qg3jGvHCebl+MrXc3U+HshabU1ZCYnNgyS
	 YutRU0tcv5CEJFhG5YCt/0oly7xXrbhdWwYcLiReqktpbFcuDjqFPtgYzBWh172WN9e2V
	 Wo2C0Fy+/Hsiq633qAt4pJrZ6WAcfbAJMIppfkn5IfWlF4NM0p1T9bxfarUMdFK68KjzQ
	 WsnnU8q2tiCIGsGAG9JDCKjm9Giw6AHpvQps23Mu63WOXzUEG1dmAjMM1cVHFnufjmhL3
	 FkaYBxPr/zohhpnzgkdQ0iww+0HFmVWhZgoo0ChnviK8N2beuAT9NZB1QE+0pPIkb2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vva0MLppiMDR5XaVAhh6s55GcsbDa9naXFFw0GSnoAU=;
	b=snbnNDG2cMnVJtxdDovCopZuogy1jFe0FkwYj1vm1Hf4d/LyPAF31NXNShIynnoX7ecy
	 OmWjFP0hJXYdkicebsVE4Snn8VWZYi34fKzhobUWBIsHTl5VWYD84CKjEj07Rb6jAjBC5
	 HshON0WQBObonfN8VfuqZ8w7HoWtmQ6IcZiNp3BOy7h1vvm70YERdUml/aoyY3UQNUPMU
	 vFfTr8t8xy2q8IkGdk9gP4UN6lsbHfsCNFFUhhbN+KA6uCG65blJEKGUJ82LSd0PPg1lX
	 MTr8pGt3TvTPgkwjK7ZEAKfq8+e3VYqIh8r0msok2MHbTrXAkyKK7fY7ow5UMesCUrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3sJYdjb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1511606D810;
	Wed,  4 Nov 2026 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3sJYdjb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639841F00A02;
	Wed,  4 Nov 2026 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826798;
	bh=vva0MLppiMDR5XaVAhh6s55GcsbDa9naXFFw0GSnoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3sJYdjbOGRI9BzOfrAUocLClm8Ua90FK1feaTFb77Zp9+rgr3L0jdr4LQ13z9Wpb
	 0VbaYdK5SrM8UgBiuV5HcEmDRyptRdHhNCalz0Mda57Skw2FOqggtVyMTyfq5Hd8A6
	 ezte6F3FhigYehVGPU3EN0EkySVT/y/Ifg4NbDlM=
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
Subject: [PATCH 6.18 0013/1005] net: bonding: move bond_should_notify_peers, e.g. into rtnl lock block
Date: Wed,  4 Nov 2026 15:55:46 -0500
Message-ID: <20261104211043.911728049@linuxfoundation.org>
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

commit 70fc6649b36cf22167bbd7e2a6cc0960b746316e upstream.

This patch tries to avoid the possible peer notify event loss.

In bond_mii_monitor()/bond_activebackup_arp_mon(), when we hold the rtnl lock:
- check send_peer_notif again to avoid unconditionally reducing this value.
- send_peer_notif may have been reset. Therefore, it is necessary to check
  whether to send peer notify via bond_should_notify_peers() to avoid the
  loss of notification events.

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
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/78cef328822b94638c97638b89011c507b8bf19e.1768709239.git.tonghao@bamaicloud.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Struan Bartlett <struan.bartlett@newsnow.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2887,11 +2887,10 @@ static void bond_mii_monitor(struct work
 {
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
-	bool should_notify_peers;
-	bool commit;
-	unsigned long delay;
-	struct slave *slave;
 	struct list_head *iter;
+	struct slave *slave;
+	unsigned long delay;
+	bool commit;
 
 	delay = msecs_to_jiffies(bond->params.miimon);
 
@@ -2900,7 +2899,6 @@ static void bond_mii_monitor(struct work
 
 	rcu_read_lock();
 
-	should_notify_peers = bond_should_notify_peers(bond);
 	commit = !!bond_miimon_inspect(bond);
 
 	rcu_read_unlock();
@@ -2920,12 +2918,8 @@ static void bond_mii_monitor(struct work
 			bond_miimon_commit(bond);
 		}
 
-		if (bond->send_peer_notif) {
-			bond->send_peer_notif--;
-			if (should_notify_peers)
-				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
-							 bond->dev);
-		}
+		if (bond->send_peer_notif)
+			bond_peer_notify_may_events(bond, true);
 
 		rtnl_unlock();	/* might sleep, hold no other locks */
 	}
@@ -3839,7 +3833,6 @@ check_state:
 
 static void bond_activebackup_arp_mon(struct bonding *bond)
 {
-	bool should_notify_peers = false;
 	bool should_notify_rtnl = false;
 	int delta_in_ticks;
 
@@ -3850,15 +3843,12 @@ static void bond_activebackup_arp_mon(st
 
 	rcu_read_lock();
 
-	should_notify_peers = bond_should_notify_peers(bond);
-
 	if (bond_ab_arp_inspect(bond)) {
 		rcu_read_unlock();
 
 		/* Race avoidance with bond_close flush of workqueue */
 		if (!rtnl_trylock()) {
 			delta_in_ticks = 1;
-			should_notify_peers = false;
 			goto re_arm;
 		}
 
@@ -3875,15 +3865,13 @@ re_arm:
 	if (bond->params.arp_interval)
 		queue_delayed_work(bond->wq, &bond->arp_work, delta_in_ticks);
 
-	if (should_notify_peers || should_notify_rtnl) {
+	if (bond->send_peer_notif || should_notify_rtnl) {
 		if (!rtnl_trylock())
 			return;
 
-		if (should_notify_peers) {
-			bond->send_peer_notif--;
-			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
-						 bond->dev);
-		}
+		if (bond->send_peer_notif)
+			bond_peer_notify_may_events(bond, true);
+
 		if (should_notify_rtnl) {
 			bond_slave_state_notify(bond);
 			bond_slave_link_notify(bond);


