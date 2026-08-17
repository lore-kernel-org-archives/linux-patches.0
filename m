Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2A43711C;
	Mon, 17 Aug 2026 13:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974706; cv=none; b=UflBQJuOnzD4HzxLuBgZJ7itUjwnfK5pTE6VlVQmxYkKy7lReBW6RcQ6zESpGqz4rgs09S/wTFsYgzp1rei4e0uWvUkgFR51d2sowDPY+vLoQRUK7l2shNHBOe5VW2RntNv77eqRoqkYcq4MnA/3egq1d6zhJPGEU7tdeV7eQXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974706; c=relaxed/simple;
	bh=f8H4teN2xkvdtP/It7Dmjknuu7NwLkX86PwXZ5r+2Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho88K0Apq9TXKve58HKWeoYHVG8JPqANMh1pYJusb4mWVKQHbVj0mEmSw8gq8o0qC3XsM7RPU1FQjI2q5jBECG/YBD4ucVz8t+43cWm1WglUIizL1kiqNSc8izRFLbc3k1g60BqZRJ81RoQ3n4PHa2ON0lmw9v7MW9keMuqAxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRV8SJjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRV8SJjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31A61F00AC4;
	Mon, 17 Aug 2026 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974698;
	bh=kc9mzOznk9N/xG+/r1gSD/bg4pjmpuddM6dDQfdqCQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRV8SJjGmcBeyGlIWzpxGomciyJThux5FA/MqFFaoRu/Uqz7bm79vTqgN+QQ87/OE
	 CGAVH4ymuy25ftK/fqtYV0KLsxI7rxP1TGBPNPhQ50CkyP1JgK5LQAfdYnw9Ba9Ww3
	 iMMK59xCmo+CL9bq1yNBvkB0CQ7JyTMT9p88PiSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/250] ovpn: rehash peer in by_transp_addr table on CMD_PEER_SET
Date: Mon, 17 Aug 2026 15:29:44 +0200
Message-ID: <20260817132537.402710486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit cc12f7240c8c4dee557749d33237542613992f14 ]

When userspace updates a peer's remote endpoint via OVPN_CMD_PEER_SET,
ovpn_nl_peer_modify() installs a new ovpn_bind through
ovpn_peer_reset_sockaddr(), but ovpn_nl_peer_set_doit() only calls
ovpn_peer_hash_vpn_ip() to refresh the VPN-IP hashtables. The peer is
left in the bucket of peers->by_transp_addr corresponding to its old
remote address.

As a consequence, datagrams arriving at the UDP RX path from the newly
configured remote hash to a different slot and the lockless lookup in
ovpn_peer_get_by_transp_addr() (called from ovpn_udp_encap_recv()) does
not find the peer, until either a float event or a peer re-add fixes
the bucket.

Introduce ovpn_peer_hash_transp_addr() (modeled after
ovpn_peer_hash_vpn_ip()) and invoke it from ovpn_nl_peer_set_doit()
whenever the request carried a new remote address. The helper bails
out in P2P mode and on peers without a bind (TCP), and relies on
hlist_nulls_del_init_rcu()'s pprev==NULL short-circuit to handle the
case of an entry not currently linked in the table.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c |   6 +++
 drivers/net/ovpn/peer.c    | 105 +++++++++++++++++++++++++------------
 drivers/net/ovpn/peer.h    |   1 +
 3 files changed, 79 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index bdb56ef0c9040..0051166c59c75 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -527,6 +527,12 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 	 */
 	if (ret > 0)
 		ovpn_peer_hash_vpn_ip(peer);
+	/* if the remote endpoint was updated, the by_transp_addr hash bucket
+	 * also needs to be refreshed, otherwise incoming packets from the new
+	 * remote address would fail the lockless lookup
+	 */
+	if (attrs[OVPN_A_PEER_REMOTE_IPV4] || attrs[OVPN_A_PEER_REMOTE_IPV6])
+		ovpn_peer_hash_transp_addr(peer);
 	spin_unlock_bh(&ovpn->lock);
 	ovpn_peer_put(peer);
 
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 6b7e368f63f3a..f502f9c576f8f 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -185,6 +185,9 @@ int ovpn_peer_reset_sockaddr(struct ovpn_peer *peer,
 	&(*__tbl1)[ovpn_get_hash_slot(*__tbl1, _key, _key_len)];\
 })
 
+static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
+					 const struct ovpn_bind *bind);
+
 /**
  * ovpn_peer_endpoints_update - update remote or local endpoint for peer
  * @peer: peer to update the remote endpoint for
@@ -192,7 +195,6 @@ int ovpn_peer_reset_sockaddr(struct ovpn_peer *peer,
  */
 void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 {
-	struct hlist_nulls_head *nhead;
 	struct sockaddr_storage ss;
 	struct sockaddr_in6 *sa6;
 	bool reset_cache = false;
@@ -289,46 +291,23 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 	spin_unlock_bh(&peer->lock);
 
 	/* rehashing is required only in MP mode as P2P has one peer
-	 * only and thus there is no hashtable
+	 * only and thus there is no hashtable.
+	 *
+	 * This function may be invoked concurrently, so re-read peer->bind
+	 * under the proper locks and rehash against its current value.
 	 */
 	if (peer->ovpn->mode != OVPN_MODE_MP)
 		return;
 
+	/* This function may be invoked concurrently, therefore another
+	 * float may have happened in parallel: re-acquire the locks and
+	 * rehash using the peer->bind->remote directly as key
+	 */
 	spin_lock_bh(&peer->ovpn->lock);
 	spin_lock_bh(&peer->lock);
 	bind = rcu_dereference_protected(peer->bind,
 					 lockdep_is_held(&peer->lock));
-	if (unlikely(!bind))
-		goto unlock2;
-
-	/* peer may have been concurrently removed between the caller's
-	 * initial lookup and our acquisition of ovpn->lock; skip the
-	 * rehash so we don't re-insert a removed peer
-	 */
-	if (unlikely(hlist_unhashed(&peer->hash_entry_id)))
-		goto unlock2;
-
-	/* This function may be invoked concurrently, therefore another
-	 * float may have happened in parallel: perform rehashing
-	 * using the peer->bind->remote directly as key
-	 */
-
-	switch (bind->remote.in4.sin_family) {
-	case AF_INET:
-		salen = sizeof(*sa);
-		break;
-	case AF_INET6:
-		salen = sizeof(*sa6);
-		break;
-	}
-
-	/* remove old hashing */
-	hlist_nulls_del_init_rcu(&peer->hash_entry_transp_addr);
-	/* re-add with new transport address */
-	nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr,
-				   &bind->remote, salen);
-	hlist_nulls_add_head_rcu(&peer->hash_entry_transp_addr, nhead);
-unlock2:
+	__ovpn_peer_hash_transp_addr(peer, bind);
 	spin_unlock_bh(&peer->lock);
 	spin_unlock_bh(&peer->ovpn->lock);
 	return;
@@ -897,6 +876,66 @@ bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
 	return match;
 }
 
+/* Move @peer to the by_transp_addr bucket matching its current bind.
+ *
+ * Caller must hold both peer->ovpn->lock and peer->lock, and must have
+ * already dereferenced a valid (non-NULL) peer->bind, passed in as @bind.
+ */
+static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
+					 const struct ovpn_bind *bind)
+{
+	struct hlist_nulls_head *nhead;
+	size_t salen;
+
+	lockdep_assert_held(&peer->ovpn->lock);
+	lockdep_assert_held(&peer->lock);
+
+	if (WARN_ON_ONCE(!bind))
+		return;
+
+	/* peer may have been concurrently removed between the caller's
+	 * initial lookup and our acquisition of ovpn->lock; skip the
+	 * rehash so we don't re-insert a removed peer
+	 */
+	if (unlikely(hlist_unhashed(&peer->hash_entry_id)))
+		return;
+
+	switch (bind->remote.in4.sin_family) {
+	case AF_INET:
+		salen = sizeof(struct sockaddr_in);
+		break;
+	case AF_INET6:
+		salen = sizeof(struct sockaddr_in6);
+		break;
+	default:
+		return;
+	}
+
+	/* remove old hashing (no-op if entry is not currently linked) */
+	hlist_nulls_del_init_rcu(&peer->hash_entry_transp_addr);
+	/* re-add with current transport address */
+	nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr,
+				   &bind->remote, salen);
+	hlist_nulls_add_head_rcu(&peer->hash_entry_transp_addr, nhead);
+}
+
+void ovpn_peer_hash_transp_addr(struct ovpn_peer *peer)
+{
+	struct ovpn_bind *bind;
+
+	lockdep_assert_held(&peer->ovpn->lock);
+
+	/* rehashing makes sense only in multipeer mode */
+	if (peer->ovpn->mode != OVPN_MODE_MP)
+		return;
+
+	spin_lock_bh(&peer->lock);
+	bind = rcu_dereference_protected(peer->bind,
+					 lockdep_is_held(&peer->lock));
+	__ovpn_peer_hash_transp_addr(peer, bind);
+	spin_unlock_bh(&peer->lock);
+}
+
 void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
 {
 	struct hlist_nulls_head *nhead;
diff --git a/drivers/net/ovpn/peer.h b/drivers/net/ovpn/peer.h
index 4de5aeae33f7d..9a05a278e1cd0 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -148,6 +148,7 @@ struct ovpn_peer *ovpn_peer_get_by_id(struct ovpn_priv *ovpn, u32 peer_id);
 struct ovpn_peer *ovpn_peer_get_by_dst(struct ovpn_priv *ovpn,
 				       struct sk_buff *skb);
 void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer);
+void ovpn_peer_hash_transp_addr(struct ovpn_peer *peer);
 bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
 			    struct ovpn_peer *peer);
 
-- 
2.53.0



