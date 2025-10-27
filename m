Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7B431E0FB;
	Mon, 27 Oct 2025 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591656; cv=none; b=D+CgO2ZkmCI2MF2bBA/ye+plF3+NDIoQjt7beF+b6Q4ymN3/6b9gIN+dawXuMcEDYnR7yxi5ul+DQZ16EIihjreY6tKNIfr4mXQZWxO8/7AAlLJM738ZlJma8F7YIqh8uN0HsdVWu3zxaMdVJy5SlQ6+YKwVQyk5La5rrXD050M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591656; c=relaxed/simple;
	bh=iRFId96aEn3z3K9bqctblBEVuW+NntP+5fe4moHDUb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONVh99ENWnB4k2yfpVwrWagxBcHwdqFYTencWjybT8xAhYhfV3jx61IeHsTlJ+i8rM8t00YpewbyR+9kez7aNjUT2DQy3K4uRLM0odnvssuuEOZtM3gfnReylIFUmt0yQthQfwgZ/jp/TuEd5KCX3VkTyDrP6NQYXk6AjrZyaco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWi/NW8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWi/NW8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FE9C4CEF1;
	Mon, 27 Oct 2025 19:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591656;
	bh=iRFId96aEn3z3K9bqctblBEVuW+NntP+5fe4moHDUb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWi/NW8vgI5u/4dOlKg7PKvK5GvBhKQPjpzL//hE/ppTi9CNVXN2koWo6EFECsttV
	 +OPg3Av+Zg+hmguQRLzQ6p4t3ab0WS3cLZ6CSvnUQV2Oi9Eore25LmEx0cDb1+9Mhf
	 oeLGQ+oAffgqqcR9LxyqLyuwiNd7GkWcGvUFJ9Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Vincent Bernat <vincent@bernat.ch>,
	Tonghao Zhang <tonghao@bamaicloud.com>
Subject: [PATCH 5.10 280/332] net: bonding: fix possible peer notify event loss or dup issue
Date: Mon, 27 Oct 2025 19:35:33 +0100
Message-ID: <20251027183532.254228518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tonghao Zhang <tonghao@bamaicloud.com>

commit 10843e1492e474c02b91314963161731fa92af91 upstream.

If the send_peer_notif counter and the peer event notify are not synchronized.
It may cause problems such as the loss or dup of peer notify event.

Before this patch:
- If should_notify_peers is true and the lock for send_peer_notif-- fails, peer
  event may be sent again in next mii_monitor loop, because should_notify_peers
  is still true.
- If should_notify_peers is true and the lock for send_peer_notif-- succeeded,
  but the lock for peer event fails, the peer event will be lost.

This patch locks the RTNL for send_peer_notif, events, and commit simultaneously.

Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Cc: Jay Vosburgh <jv@jvosburgh.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Vincent Bernat <vincent@bernat.ch>
Cc: <stable@vger.kernel.org>
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20251021050933.46412-1-tonghao@bamaicloud.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2617,7 +2617,7 @@ static void bond_mii_monitor(struct work
 {
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
-	bool should_notify_peers = false;
+	bool should_notify_peers;
 	bool commit;
 	unsigned long delay;
 	struct slave *slave;
@@ -2629,30 +2629,33 @@ static void bond_mii_monitor(struct work
 		goto re_arm;
 
 	rcu_read_lock();
+
 	should_notify_peers = bond_should_notify_peers(bond);
 	commit = !!bond_miimon_inspect(bond);
-	if (bond->send_peer_notif) {
-		rcu_read_unlock();
-		if (rtnl_trylock()) {
-			bond->send_peer_notif--;
-			rtnl_unlock();
-		}
-	} else {
-		rcu_read_unlock();
-	}
 
-	if (commit) {
+	rcu_read_unlock();
+
+	if (commit || bond->send_peer_notif) {
 		/* Race avoidance with bond_close cancel of workqueue */
 		if (!rtnl_trylock()) {
 			delay = 1;
-			should_notify_peers = false;
 			goto re_arm;
 		}
 
-		bond_for_each_slave(bond, slave, iter) {
-			bond_commit_link_state(slave, BOND_SLAVE_NOTIFY_LATER);
+		if (commit) {
+			bond_for_each_slave(bond, slave, iter) {
+				bond_commit_link_state(slave,
+						       BOND_SLAVE_NOTIFY_LATER);
+			}
+			bond_miimon_commit(bond);
+		}
+
+		if (bond->send_peer_notif) {
+			bond->send_peer_notif--;
+			if (should_notify_peers)
+				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
+							 bond->dev);
 		}
-		bond_miimon_commit(bond);
 
 		rtnl_unlock();	/* might sleep, hold no other locks */
 	}
@@ -2660,13 +2663,6 @@ static void bond_mii_monitor(struct work
 re_arm:
 	if (bond->params.miimon)
 		queue_delayed_work(bond->wq, &bond->mii_work, delay);
-
-	if (should_notify_peers) {
-		if (!rtnl_trylock())
-			return;
-		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, bond->dev);
-		rtnl_unlock();
-	}
 }
 
 static int bond_upper_dev_walk(struct net_device *upper,


