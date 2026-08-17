Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03363DB324;
	Mon, 17 Aug 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973924; cv=none; b=ei49dxNdzlGylbqI9uJczlf0rpZS9YGr5cqWCB1IwE9zKWG179RS8pOGPsiPw8IpdJ4R6zhjx/b++nc9jLv5sf/JS5V8UyiMGiYn/DEfZmz6KoT6ddoz1L1obkaRsqBnV8JT7tecbIkBewrLBOJqdmu8j0W0uztMWHra4fqqNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973924; c=relaxed/simple;
	bh=cbZKfoznoGmRuJjRgwYuRb2FxeuwT0Qs400cSsLutWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPX56rmXZJUtVVWIDXlD1NJV0sjolwqSa3FDhL4cpLPyGw4UmMLb1bzp7aCXhZeAe9qbS88dfpqYVAXq8ax0qvhmL9FL20HPaEqvaurfPS2liBRx/rEZWyVu4yV2yhWazShzyv3unSdTCo1IK/CKvQWY4whvMtwrIKq8tRVRrEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1W3mJsjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1W3mJsjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D7D1F000E9;
	Mon, 17 Aug 2026 13:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973923;
	bh=uaH0C7f3mrnIigU173lwkDJMcrcNRoMn29gSrQPbQ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1W3mJsjzo5GJZDjhFbihwChT8y+1S/93wM7O9+r+025vHog3pc1VwY3ZB8qVoY5OX
	 32VoTZSlCBQhDZLNkRREbPx/0BgBPEY2Is3QTODLmBJW3JN3BZum4Zv3Kb8gefr7oC
	 dkLckYmwtq5Sd6un9br4Ylv5nxNmpdwNBfd+kQhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 028/271] ovpn: rehash peer in by_transp_addr table on CMD_PEER_SET
Date: Mon, 17 Aug 2026 15:29:13 +0200
Message-ID: <20260817132537.909590567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c66c1ec497ec..4dad852941982 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -534,6 +534,12 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
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
index 68021c0c17830..a330892e82bf7 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -189,6 +189,9 @@ int ovpn_peer_reset_sockaddr(struct ovpn_peer *peer,
 	&(*__tbl1)[ovpn_get_hash_slot(*__tbl1, _key, _key_len)];\
 })
 
+static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
+					 const struct ovpn_bind *bind);
+
 /**
  * ovpn_peer_endpoints_update - update remote or local endpoint for peer
  * @peer: peer to update the remote endpoint for
@@ -196,7 +199,6 @@ int ovpn_peer_reset_sockaddr(struct ovpn_peer *peer,
  */
 void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 {
-	struct hlist_nulls_head *nhead;
 	struct sockaddr_storage ss;
 	struct sockaddr_in6 *sa6;
 	bool reset_cache = false;
@@ -295,46 +297,23 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 	ovpn_nl_peer_float_notify(peer, &ss);
 
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
@@ -902,6 +881,66 @@ bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
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
index 86c8cffada6d4..dfa5c0037e02b 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -150,6 +150,7 @@ struct ovpn_peer *ovpn_peer_get_by_id(struct ovpn_priv *ovpn, u32 peer_id);
 struct ovpn_peer *ovpn_peer_get_by_dst(struct ovpn_priv *ovpn,
 				       struct sk_buff *skb);
 void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer);
+void ovpn_peer_hash_transp_addr(struct ovpn_peer *peer);
 bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
 			    struct ovpn_peer *peer);
 
-- 
2.53.0



