Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A51631F981;
	Thu, 28 May 2026 20:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000063; cv=none; b=uni9AG3GH+ZyiHzSljiaHFW8Yzc3NtALd3l5oLXa3hbleHwSpa1tYIbfLtr4JGCQLrvyVHQuUdYG8Ov9bCFRoCoXLbILOYw8+wcRGnfSYfSXO8Mijn6EO7dg1+Le4RmGbPrl/+SA1MTuZwmOTB0piI27Xo9SnWt0KM+uqx79oHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000063; c=relaxed/simple;
	bh=RGuHEe49NqqU0rWsKEFYrEdlR4H3LFevwEMoy3pOrZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gb4kJUSQPZRRJz/3B2WLt5ET5E3WbuSJs0PD1Ht6haggp1g/ekRa3+O5mrBcTQVowWGY2Hd09pE0R5Idy4AEg8YYVj1Mh8aJcKO4w9QYWP0PHUEt+dBoSe6L92QFfunyW45566Dx1KaF7vYUQhh6gYrnCUwM9es6VQqcVzY3ius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWWjQvBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWWjQvBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75901F000E9;
	Thu, 28 May 2026 20:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000062;
	bh=B6k9FFSNlPad4OkCfP8kiMedvjf4HFCkxP6dmTik8co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWWjQvBM+vNvru/m+V8+f7Ce5XvXoIjR1lSV++GXSVpIpV8m03As+RpES7DQyge76
	 4bewYl59VQ2VgOFggY7eGkwVe0lRmpw1J8ee6hzghDUsP9DsfYl8YNMGPCkifQ8Fcr
	 5/Ui2hVdf/Qdo0pzm6xLLnb8dWGN7qyCjVvZ6Bno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/377] ovpn: disable BHs when updating device stats
Date: Thu, 28 May 2026 21:48:47 +0200
Message-ID: <20260528194646.717529699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 0c0dddc07d272a8d25922e48041e8e4d2434df7e ]

ovpn updates dev->dstats from both process and softirq contexts. In
particular, TCP paths may run from socket callbacks, workqueues or
strparser work, while UDP receive and ovpn's ndo_start_xmit path may
update the same per-device dstats from BH context.

Add ovpn device drop-stat helpers that disable BHs around
dev_dstats_rx_dropped() and dev_dstats_tx_dropped(), and use them for
drop accounting.

The successful RX dev_dstats_rx_add() update is already covered by the
BH-disabled section around gro_cells_receive(). For the successful TCP
TX dev_dstats_tx_add() update, replace the existing preempt-disabled
section with a BH-disabled one.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/io.c    | 12 ++++++------
 drivers/net/ovpn/stats.h | 16 ++++++++++++++++
 drivers/net/ovpn/tcp.c   | 10 +++++-----
 drivers/net/ovpn/udp.c   |  2 +-
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ovpn/io.c b/drivers/net/ovpn/io.c
index 955c9a37e1f8d..c03e58e28a860 100644
--- a/drivers/net/ovpn/io.c
+++ b/drivers/net/ovpn/io.c
@@ -196,7 +196,7 @@ void ovpn_decrypt_post(void *data, int ret)
 	skb = NULL;
 drop:
 	if (unlikely(skb))
-		dev_dstats_rx_dropped(peer->ovpn->dev);
+		ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 	kfree_skb(skb);
 drop_nocount:
 	if (likely(peer))
@@ -220,7 +220,7 @@ void ovpn_recv(struct ovpn_peer *peer, struct sk_buff *skb)
 		net_info_ratelimited("%s: no available key for peer %u, key-id: %u\n",
 				     netdev_name(peer->ovpn->dev), peer->id,
 				     key_id);
-		dev_dstats_rx_dropped(peer->ovpn->dev);
+		ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 		kfree_skb(skb);
 		ovpn_peer_put(peer);
 		return;
@@ -298,7 +298,7 @@ void ovpn_encrypt_post(void *data, int ret)
 	rcu_read_unlock();
 err:
 	if (unlikely(skb))
-		dev_dstats_tx_dropped(peer->ovpn->dev);
+		ovpn_dev_dstats_tx_dropped(peer->ovpn->dev);
 	if (likely(peer))
 		ovpn_peer_put(peer);
 	if (likely(ks))
@@ -340,7 +340,7 @@ static void ovpn_send(struct ovpn_priv *ovpn, struct sk_buff *skb,
 	 */
 	skb_list_walk_safe(skb, curr, next) {
 		if (unlikely(!ovpn_encrypt_one(peer, curr))) {
-			dev_dstats_tx_dropped(ovpn->dev);
+			ovpn_dev_dstats_tx_dropped(ovpn->dev);
 			kfree_skb(curr);
 		}
 	}
@@ -411,7 +411,7 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (unlikely(!curr)) {
 			net_err_ratelimited("%s: skb_share_check failed for payload packet\n",
 					    netdev_name(dev));
-			dev_dstats_tx_dropped(ovpn->dev);
+			ovpn_dev_dstats_tx_dropped(ovpn->dev);
 			continue;
 		}
 
@@ -437,7 +437,7 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 drop:
 	ovpn_peer_put(peer);
 drop_no_peer:
-	dev_dstats_tx_dropped(ovpn->dev);
+	ovpn_dev_dstats_tx_dropped(ovpn->dev);
 	skb_tx_error(skb);
 	kfree_skb_list(skb);
 	return NETDEV_TX_OK;
diff --git a/drivers/net/ovpn/stats.h b/drivers/net/ovpn/stats.h
index 53433d8b6c331..3a45b97c00568 100644
--- a/drivers/net/ovpn/stats.h
+++ b/drivers/net/ovpn/stats.h
@@ -11,6 +11,8 @@
 #ifndef _NET_OVPN_OVPNSTATS_H_
 #define _NET_OVPN_OVPNSTATS_H_
 
+#include <linux/netdevice.h>
+
 /* one stat */
 struct ovpn_peer_stat {
 	atomic64_t bytes;
@@ -44,4 +46,18 @@ static inline void ovpn_peer_stats_increment_tx(struct ovpn_peer_stats *stats,
 	ovpn_peer_stats_increment(&stats->tx, n);
 }
 
+static inline void ovpn_dev_dstats_tx_dropped(struct net_device *dev)
+{
+	local_bh_disable();
+	dev_dstats_tx_dropped(dev);
+	local_bh_enable();
+}
+
+static inline void ovpn_dev_dstats_rx_dropped(struct net_device *dev)
+{
+	local_bh_disable();
+	dev_dstats_rx_dropped(dev);
+	local_bh_enable();
+}
+
 #endif /* _NET_OVPN_OVPNSTATS_H_ */
diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 5f345ae7d59d2..505c2f214c9f1 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -152,7 +152,7 @@ static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	if (WARN_ON(!ovpn_peer_hold(peer)))
 		goto err_nopeer;
 	schedule_work(&peer->tcp.defer_del_work);
-	dev_dstats_rx_dropped(peer->ovpn->dev);
+	ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 err_nopeer:
 	kfree_skb(skb);
 }
@@ -298,9 +298,9 @@ static void ovpn_tcp_send_sock(struct ovpn_peer *peer, struct sock *sk)
 	} while (peer->tcp.out_msg.len > 0);
 
 	if (!peer->tcp.out_msg.len) {
-		preempt_disable();
+		local_bh_disable();
 		dev_dstats_tx_add(peer->ovpn->dev, skb->len);
-		preempt_enable();
+		local_bh_enable();
 	}
 
 	kfree_skb(peer->tcp.out_msg.skb);
@@ -331,7 +331,7 @@ static void ovpn_tcp_send_sock_skb(struct ovpn_peer *peer, struct sock *sk,
 		ovpn_tcp_send_sock(peer, sk);
 
 	if (peer->tcp.out_msg.skb) {
-		dev_dstats_tx_dropped(peer->ovpn->dev);
+		ovpn_dev_dstats_tx_dropped(peer->ovpn->dev);
 		kfree_skb(skb);
 		return;
 	}
@@ -353,7 +353,7 @@ void ovpn_tcp_send_skb(struct ovpn_peer *peer, struct sock *sk,
 	if (sock_owned_by_user(sk)) {
 		if (skb_queue_len(&peer->tcp.out_queue) >=
 		    READ_ONCE(net_hotdata.max_backlog)) {
-			dev_dstats_tx_dropped(peer->ovpn->dev);
+			ovpn_dev_dstats_tx_dropped(peer->ovpn->dev);
 			kfree_skb(skb);
 			goto unlock;
 		}
diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index 272b535ecaad4..367563d84472f 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -126,7 +126,7 @@ static int ovpn_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 
 drop:
-	dev_dstats_rx_dropped(ovpn->dev);
+	ovpn_dev_dstats_rx_dropped(ovpn->dev);
 drop_noovpn:
 	kfree_skb(skb);
 	return 0;
-- 
2.53.0



