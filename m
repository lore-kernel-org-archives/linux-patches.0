Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290E63AE71C;
	Wed, 30 Sep 2026 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793000; cv=none; b=Wlq0hvOm1qQ6HIS+8V0ZB6IoTujl/24Hmua70rnH49wY3XZueZntKBM8UI3RTtsG/EuWQk+fx9YH+TxA4LYMROPLZYkpVHt959niK98QKrtvOofMmQjL8QyzSlDZuQGezmSSsOYnRnA6TivHSsqRDQMDaa1n78my+SE4HEUOJMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793000; c=relaxed/simple;
	bh=y24JdPMWo+orH/0KNkxhZ41m1S+LLyFlr07ncjaPsTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck0ftlnV2SvinaST/PYldE75OXnZ8F8DB9cfzEIpzEVtKxb3i0kiH2TkMxYO7Jy5ktwWT0fNlxIdbg3y9gW6n+CauNUjtCeuH7R7c4iw1Jm+zmf6BP6e2PyOxqqSOJ2EbxBeHKdcuNxwvOriDY/p9/TlnjiimgI3os4DmfWhTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBQXkfBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBQXkfBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1F1F000FF;
	Wed, 30 Sep 2026 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792999;
	bh=2s/QSiWtDmy4THC/yNEPNNfTyxkoDlv1F5yYwQNYbLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBQXkfBgPJ+4UjseV6dBylSeyUUmgADDgWipEVvE9kxVLw6kBZ2XmfF8NR0WMnhuw
	 NDx1Fo1MhabUpB+cIgYBrU4CkO/zc9ClmnRzuHXiGiQ4d+GQcMoatQT2P4faK0dOmo
	 rO0D+NmDiylGGNPbaGEETkWzIWB5iFcxaIYIMow4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/395] ovpn: track UDP socket route key for peer dst cache
Date: Wed, 30 Sep 2026 17:26:02 +0200
Message-ID: <20260930152342.803266458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

[ Upstream commit 7c66b7a4ae80a9309e6dc1d24b7b6b897e6348eb ]

ovpn stores the route used to transmit UDP packets in a per-peer dst
cache. A cached dst is only valid for the route lookup inputs used when
it was resolved.

Some of those inputs are mutable while userspace still owns the UDP
socket. In particular, changes to the socket mark or UDP source port do
not invalidate ovpn's peer dst cache, so ovpn can keep using a route
selected with an old socket route key.

Replace the cached mark with a route key containing the socket-owned
lookup inputs currently used by ovpn, and reset the peer dst cache when
the key changes. Before storing a newly looked-up dst, recheck the route
key under the peer lock so a dst resolved for stale socket state is not
published.

Fixes: 08857b5ec5d9 ("ovpn: implement basic TX path (UDP)")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c |  1 +
 drivers/net/ovpn/peer.h | 19 ++++++++-
 drivers/net/ovpn/udp.c  | 90 +++++++++++++++++++++++++++++++++++------
 3 files changed, 95 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 6b9f5f12fc5a8..58b0248ae3a7c 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -109,6 +109,7 @@ struct ovpn_peer *ovpn_peer_new(struct ovpn_priv *ovpn, u32 id)
 	RCU_INIT_POINTER(peer->bind, NULL);
 	ovpn_crypto_state_init(&peer->crypto);
 	spin_lock_init(&peer->lock);
+	seqcount_spinlock_init(&peer->route_key_seq, &peer->lock);
 	kref_init(&peer->refcount);
 	ovpn_peer_stats_init(&peer->vpn_stats);
 	ovpn_peer_stats_init(&peer->link_stats);
diff --git a/drivers/net/ovpn/peer.h b/drivers/net/ovpn/peer.h
index 9a05a278e1cd0..693175712f7af 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -10,6 +10,7 @@
 #ifndef _NET_OVPN_OVPNPEER_H_
 #define _NET_OVPN_OVPNPEER_H_
 
+#include <linux/seqlock.h>
 #include <net/dst_cache.h>
 #include <net/strparser.h>
 
@@ -17,6 +18,16 @@
 #include "socket.h"
 #include "stats.h"
 
+/**
+ * struct ovpn_route_key - route key used for the peer dst cache
+ * @mark: fwmark used for route lookup
+ * @sport: UDP source port used for route lookup
+ */
+struct ovpn_route_key {
+	u32 mark;
+	__be16 sport;
+};
+
 /**
  * struct ovpn_peer - the main remote peer object
  * @ovpn: main openvpn instance this peer belongs to
@@ -44,6 +55,8 @@
  * @tcp.sk_cb.ops: pointer to the original prot_ops object (TCP only)
  * @crypto: the crypto configuration (ciphers, keys, etc..)
  * @dst_cache: cache for dst_entry used to send to peer
+ * @route_key: route key matching the current dst cache contents
+ * @route_key_seq: seqcount protecting lockless route_key reads
  * @bind: remote peer binding
  * @keepalive_interval: seconds after which a new keepalive should be sent
  * @keepalive_xmit_exp: future timestamp when next keepalive should be sent
@@ -54,7 +67,7 @@
  * @vpn_stats: per-peer in-VPN TX/RX stats
  * @link_stats: per-peer link/transport TX/RX stats
  * @delete_reason: why peer was deleted (i.e. timeout, transport error, ..)
- * @lock: protects binding to peer (bind) and keepalive* fields
+ * @lock: protects binding to peer (bind), route_key and keepalive* fields
  * @refcount: reference counter
  * @rcu: used to free peer in an RCU safe way
  * @release_entry: entry for the socket release list
@@ -97,6 +110,8 @@ struct ovpn_peer {
 	} tcp;
 	struct ovpn_crypto_state crypto;
 	struct dst_cache dst_cache;
+	struct ovpn_route_key route_key;
+	seqcount_spinlock_t route_key_seq;
 	struct ovpn_bind __rcu *bind;
 	unsigned long keepalive_interval;
 	unsigned long keepalive_xmit_exp;
@@ -107,7 +122,7 @@ struct ovpn_peer {
 	struct ovpn_peer_stats vpn_stats;
 	struct ovpn_peer_stats link_stats;
 	enum ovpn_del_peer_reason delete_reason;
-	spinlock_t lock; /* protects bind  and keepalive* */
+	spinlock_t lock; /* protects bind, route_key and keepalive* */
 	struct kref refcount;
 	struct rcu_head rcu;
 	struct llist_node release_entry;
diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index a8185f39a8def..8be5f64e0a1fa 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -132,6 +132,48 @@ static int ovpn_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static bool ovpn_route_key_equal(const struct ovpn_route_key *a,
+				 const struct ovpn_route_key *b)
+{
+	return a->mark == b->mark && a->sport == b->sport;
+}
+
+/**
+ * ovpn_dst_cache_check_key - reset peer dst cache after key changes
+ * @peer: the peer owning the dst cache
+ * @cache: the cache that might need to be reset
+ * @key: the route key for the packet being transmitted
+ *
+ * Reset the peer dst cache if it was populated for a different route key.
+ */
+static void ovpn_dst_cache_check_key(struct ovpn_peer *peer,
+				     struct dst_cache *cache,
+				     const struct ovpn_route_key *key)
+{
+	struct ovpn_route_key old_key;
+	unsigned int seq;
+
+	/* snapshot the saved key before deciding whether the cache matches */
+	do {
+		seq = read_seqcount_begin(&peer->route_key_seq);
+		old_key = peer->route_key;
+	} while (read_seqcount_retry(&peer->route_key_seq, seq));
+
+	/* nothing changed: the current cache can be reused */
+	if (likely(ovpn_route_key_equal(&old_key, key)))
+		return;
+
+	/* recheck under lock because another path may have updated the key */
+	spin_lock_bh(&peer->lock);
+	if (!ovpn_route_key_equal(&peer->route_key, key)) {
+		write_seqcount_begin(&peer->route_key_seq);
+		peer->route_key = *key;
+		dst_cache_reset(cache);
+		write_seqcount_end(&peer->route_key_seq);
+	}
+	spin_unlock_bh(&peer->lock);
+}
+
 /**
  * ovpn_udp4_output - send IPv4 packet over udp socket
  * @peer: the destination peer
@@ -139,21 +181,23 @@ static int ovpn_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
  * @cache: dst cache
  * @sk: the socket to send the packet over
  * @skb: the packet to send
+ * @key: the route key snapshot used for cache validation and flow lookup
  *
  * Return: 0 on success or a negative error code otherwise
  */
 static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct dst_cache *cache, struct sock *sk,
-			    struct sk_buff *skb)
+			    struct sk_buff *skb,
+			    const struct ovpn_route_key *key)
 {
 	struct rtable *rt;
 	struct flowi4 fl = {
 		.saddr = bind->local.ipv4.s_addr,
 		.daddr = bind->remote.in4.sin_addr.s_addr,
-		.fl4_sport = inet_sk(sk)->inet_sport,
+		.fl4_sport = key->sport,
 		.fl4_dport = bind->remote.in4.sin_port,
 		.flowi4_proto = sk->sk_protocol,
-		.flowi4_mark = sk->sk_mark,
+		.flowi4_mark = key->mark,
 	};
 	int ret;
 
@@ -194,7 +238,12 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 				    ret);
 		goto err;
 	}
-	dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
+
+	/* avoid storing a stale cache */
+	spin_lock_bh(&peer->lock);
+	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+		dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
+	spin_unlock_bh(&peer->lock);
 
 transmit:
 	udp_tunnel_xmit_skb(rt, sk, skb, fl.saddr, fl.daddr, 0,
@@ -214,12 +263,14 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
  * @cache: dst cache
  * @sk: the socket to send the packet over
  * @skb: the packet to send
+ * @key: the route key snapshot used for cache validation and flow lookup
  *
  * Return: 0 on success or a negative error code otherwise
  */
 static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct dst_cache *cache, struct sock *sk,
-			    struct sk_buff *skb)
+			    struct sk_buff *skb,
+			    const struct ovpn_route_key *key)
 {
 	struct dst_entry *dst;
 	int ret;
@@ -227,10 +278,10 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 	struct flowi6 fl = {
 		.saddr = bind->local.ipv6,
 		.daddr = bind->remote.in6.sin6_addr,
-		.fl6_sport = inet_sk(sk)->inet_sport,
+		.fl6_sport = key->sport,
 		.fl6_dport = bind->remote.in6.sin6_port,
 		.flowi6_proto = sk->sk_protocol,
-		.flowi6_mark = sk->sk_mark,
+		.flowi6_mark = key->mark,
 		.flowi6_oif = bind->remote.in6.sin6_scope_id,
 	};
 
@@ -260,7 +311,12 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 				    &bind->remote.in6, ret);
 		goto err;
 	}
-	dst_cache_set_ip6(cache, dst, &fl.saddr);
+
+	/* avoid storing a stale cache */
+	spin_lock_bh(&peer->lock);
+	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+		dst_cache_set_ip6(cache, dst, &fl.saddr);
+	spin_unlock_bh(&peer->lock);
 
 transmit:
 	/* user IPv6 packets may be larger than the transport interface
@@ -289,6 +345,7 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
  * @cache: dst cache
  * @sk: the socket to send the packet over
  * @skb: the packet to send
+ * @key: route key snapshot used for cache validation and flow lookup
  *
  * rcu_read_lock should be held on entry.
  * On return, the skb is consumed.
@@ -296,7 +353,8 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
  * Return: 0 on success or a negative error code otherwise
  */
 static int ovpn_udp_output(struct ovpn_peer *peer, struct dst_cache *cache,
-			   struct sock *sk, struct sk_buff *skb)
+			   struct sock *sk, struct sk_buff *skb,
+			   struct ovpn_route_key *key)
 {
 	struct ovpn_bind *bind;
 	int ret;
@@ -316,11 +374,11 @@ static int ovpn_udp_output(struct ovpn_peer *peer, struct dst_cache *cache,
 
 	switch (bind->remote.in4.sin_family) {
 	case AF_INET:
-		ret = ovpn_udp4_output(peer, bind, cache, sk, skb);
+		ret = ovpn_udp4_output(peer, bind, cache, sk, skb, key);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		ret = ovpn_udp6_output(peer, bind, cache, sk, skb);
+		ret = ovpn_udp6_output(peer, bind, cache, sk, skb, key);
 		break;
 #endif
 	default:
@@ -342,15 +400,21 @@ static int ovpn_udp_output(struct ovpn_peer *peer, struct dst_cache *cache,
 void ovpn_udp_send_skb(struct ovpn_peer *peer, struct sock *sk,
 		       struct sk_buff *skb)
 {
+	struct ovpn_route_key key = {
+		.mark = READ_ONCE(sk->sk_mark),
+		.sport = READ_ONCE(inet_sk(sk)->inet_sport),
+	};
 	int ret;
 
 	skb->dev = peer->ovpn->dev;
-	skb->mark = READ_ONCE(sk->sk_mark);
+	skb->mark = key.mark;
 	/* no checksum performed at this layer */
 	skb->ip_summed = CHECKSUM_NONE;
 
+	ovpn_dst_cache_check_key(peer, &peer->dst_cache, &key);
+
 	/* crypto layer -> transport (UDP) */
-	ret = ovpn_udp_output(peer, &peer->dst_cache, sk, skb);
+	ret = ovpn_udp_output(peer, &peer->dst_cache, sk, skb, &key);
 	if (unlikely(ret < 0))
 		kfree_skb(skb);
 }
-- 
2.53.0



