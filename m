Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38683EDAB8;
	Mon, 17 Aug 2026 13:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973922; cv=none; b=WAXU1wSQJs5W/CN8D2HwWv/iAsZASen33MO5g6qNMqpevb97sn0KVQobYyLB49MmhYoVRQ60RuqAel1S5OQntDAiz17XsLdQJ69ryqcKzjwZLLnmoQNLyp0OXtbDeEAi8nJ5o4rpaObvSlRpKFPc06wDJIN0LNMrB3Nb8NNnPrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973922; c=relaxed/simple;
	bh=WGIAYVZlqsz8CH1XK4eFbev5P9FkTJi9t1AWBUFx9Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+JgQtvTewfgSRkaWOaQDlx7wCOvKUP2bEDbe7eK00SNqJdIcSQSn5A8W1KUEfVu2GFvZmeKjRn8/5Vnk3AtCbg1jDFPEpc8Mn+8rbfqppcmEPeABWQKWvceHVurmJh0JWM6YhPJCZtSGd9iKn4+IKrut24o6nIhfNMKZ8S3kks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emPEUYnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emPEUYnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B371F000E9;
	Mon, 17 Aug 2026 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973920;
	bh=zydg50CWDyzIuoXrR8E9nKAzu+SP4XrxwRaZU7SKd6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emPEUYnp8QqoclE0Cf8VWpmA0b+/TKjk5sUZUYSdk87DmaOxZZmhl9gSu3Xs1Qsb8
	 k/kzRAW4ES3NX8QFCIbARKf05HYSf/bzMXJwuA0C0GQOjphnVxfpVNsFlNciM6BOEE
	 RXeRcdr+yxsNAloFDCO8er19DAcXO4RPVvcrztoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 027/271] ovpn: skip rehash for peers already removed from by_id
Date: Mon, 17 Aug 2026 15:29:12 +0200
Message-ID: <20260817132537.868130726@linuxfoundation.org>
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

[ Upstream commit 33ec10567fe14456063daf549fdf1a4f53448e4c ]

ovpn_nl_peer_set_doit() resolves the target peer via
ovpn_peer_get_by_id() before taking ovpn->lock. In the window between
the lookup (which only takes a refcount) and the subsequent
spin_lock_bh(&ovpn->lock), a concurrent OVPN_CMD_PEER_DEL, keepalive
expiry, or socket teardown can take ovpn->lock first, run
ovpn_peer_remove() to unhash the peer from all four tables (by_id,
by_vpn_addr4/6, by_transp_addr) and release the lock. set_doit then
acquires ovpn->lock and calls ovpn_peer_hash_vpn_ip(), which
re-inserts the now-removed peer back into the rehashing tables.

The same race affects the float path: ovpn_peer_endpoints_update()
holds only a refcount and acquires ovpn->lock very late (after async
AEAD decrypt and a netlink notification), then rehashes the peer
in the by_transp_addr table.

The resurrected peer becomes reachable again from the RX lookup
(ovpn_peer_get_by_transp_addr) and the TX VPN-IP lookup, even though
userspace believes it is gone. Once the data-path refcount drops the
peer is freed via call_rcu while the hash entries embedded in it
remain linked, opening a UAF window.

Bail out of the rehash when hash_entry_id is unhashed, mirroring
the sentinel already used by ovpn_peer_remove() to detect the
already-removed state. The check is safe under ovpn->lock, which
serializes every mutation of hash_entry_id, and is a no-op for the
add path because ovpn_peer_add_mp() inserts hash_entry_id before
calling ovpn_peer_hash_vpn_ip().

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 73 ++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index a21d02ac715e0..68021c0c17830 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -297,40 +297,46 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 	/* rehashing is required only in MP mode as P2P has one peer
 	 * only and thus there is no hashtable
 	 */
-	if (peer->ovpn->mode == OVPN_MODE_MP) {
-		spin_lock_bh(&peer->ovpn->lock);
-		spin_lock_bh(&peer->lock);
-		bind = rcu_dereference_protected(peer->bind,
-						 lockdep_is_held(&peer->lock));
-		if (unlikely(!bind)) {
-			spin_unlock_bh(&peer->lock);
-			spin_unlock_bh(&peer->ovpn->lock);
-			return;
-		}
+	if (peer->ovpn->mode != OVPN_MODE_MP)
+		return;
 
-		/* This function may be invoked concurrently, therefore another
-		 * float may have happened in parallel: perform rehashing
-		 * using the peer->bind->remote directly as key
-		 */
+	spin_lock_bh(&peer->ovpn->lock);
+	spin_lock_bh(&peer->lock);
+	bind = rcu_dereference_protected(peer->bind,
+					 lockdep_is_held(&peer->lock));
+	if (unlikely(!bind))
+		goto unlock2;
 
-		switch (bind->remote.in4.sin_family) {
-		case AF_INET:
-			salen = sizeof(*sa);
-			break;
-		case AF_INET6:
-			salen = sizeof(*sa6);
-			break;
-		}
+	/* peer may have been concurrently removed between the caller's
+	 * initial lookup and our acquisition of ovpn->lock; skip the
+	 * rehash so we don't re-insert a removed peer
+	 */
+	if (unlikely(hlist_unhashed(&peer->hash_entry_id)))
+		goto unlock2;
 
-		/* remove old hashing */
-		hlist_nulls_del_init_rcu(&peer->hash_entry_transp_addr);
-		/* re-add with new transport address */
-		nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr,
-					   &bind->remote, salen);
-		hlist_nulls_add_head_rcu(&peer->hash_entry_transp_addr, nhead);
-		spin_unlock_bh(&peer->lock);
-		spin_unlock_bh(&peer->ovpn->lock);
+	/* This function may be invoked concurrently, therefore another
+	 * float may have happened in parallel: perform rehashing
+	 * using the peer->bind->remote directly as key
+	 */
+
+	switch (bind->remote.in4.sin_family) {
+	case AF_INET:
+		salen = sizeof(*sa);
+		break;
+	case AF_INET6:
+		salen = sizeof(*sa6);
+		break;
 	}
+
+	/* remove old hashing */
+	hlist_nulls_del_init_rcu(&peer->hash_entry_transp_addr);
+	/* re-add with new transport address */
+	nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr,
+				   &bind->remote, salen);
+	hlist_nulls_add_head_rcu(&peer->hash_entry_transp_addr, nhead);
+unlock2:
+	spin_unlock_bh(&peer->lock);
+	spin_unlock_bh(&peer->ovpn->lock);
 	return;
 unlock:
 	spin_unlock_bh(&peer->lock);
@@ -906,6 +912,13 @@ void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
 	if (peer->ovpn->mode != OVPN_MODE_MP)
 		return;
 
+	/* peer may have been concurrently removed between the caller's
+	 * initial lookup and our acquisition of ovpn->lock; skip the
+	 * rehash so we don't re-insert a removed peer
+	 */
+	if (hlist_unhashed(&peer->hash_entry_id))
+		return;
+
 	if (peer->vpn_addrs.ipv4.s_addr != htonl(INADDR_ANY)) {
 		/* remove potential old hashing */
 		hlist_nulls_del_init_rcu(&peer->hash_entry_addr4);
-- 
2.53.0



