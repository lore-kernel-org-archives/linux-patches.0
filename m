Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128E3EC831;
	Mon, 17 Aug 2026 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974856; cv=none; b=CxG7Uo8gBlNcJlbj77qTICdmwds//U1iz074pimtpBeNYPNwLK5KozFMJvmk7p2YALE0C2eKVlWgTltGEzB1UiChZrq2jxEbbm5VN7CeboT7ICp0n2DvqPV4TWQ5Q+qM0XRKrNfWOX8qGqpr0Qwd3hC7eUC8UXrEPRlY7dEKa0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974856; c=relaxed/simple;
	bh=aGoN+DayLwLNMlQ0Z0ToaqIos6rhAjxfn6SW0cXSUpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvBWQc3ZWvMgHZJfeex7Uiut2a2eeg2ylI31rD8bfh4jnhhzh7bP4HelALJGCZThHkp04dZXmqeTOW1fk/oNkJZ+ujeaxfryb/DA2CYTCtaW4aS3Ph+AxvRxwcZGrJ+tg3WhRUy3zRApqYb5GSIA5u7+vowPpDi2koVqJKMkyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8qpLfuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8qpLfuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34B41F000E9;
	Mon, 17 Aug 2026 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974850;
	bh=mNrHfGPMxdz0n7e+cq8EFOVi7SqTV5qDY4+Wj0C/D0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8qpLfuCJr2CkGgJZzgLlTm80GzfC4gcg457Y1CoX35Acn9H6/f6rdS+FX5kS9ils
	 y48y938jpCuQ1msVWYL49POzInZ9J9C5/vmu5wYvd9OcjE/ntVTwN60efmr3e0KGt2
	 axiUvDPf15oFCioh+nN+waRFOxfJnhgFdfEwJqYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/250] ovpn: hash floated peer by transport identity only
Date: Mon, 17 Aug 2026 15:29:47 +0200
Message-ID: <20260817132537.526075027@linuxfoundation.org>
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

[ Upstream commit b47a52dcd598a50207a33df304acdf45348a690f ]

The by_transp_addr table is keyed on the peer's remote transport
address, but the float rehash hashed bind->remote directly, while the
two other sites that touch the table build a clean key first:
ovpn_peer_add_mp() and the lookup in ovpn_peer_get_by_transp_addr()
both hash a sockaddr holding only family/address/port.

For a link-local IPv6 peer, bind->remote carries sin6_scope_id (set
from ipv6_iface_scope_id() when the endpoint is learned), and that
field is folded into the jhash() over sizeof(struct sockaddr_in6).
The lookup never sets sin6_scope_id, so after such a peer floats it is
rehashed into a scope_id-dependent bucket that lookups (scope_id 0)
never visit, making the peer unreachable through the by_transp_addr
fallback. ovpn_peer_transp_match() only compares address and port, so
the hash was keying on a field the match ignores.

sin6_scope_id must stay in bind->remote because the TX path uses it as
flowi6_oif, so it cannot just be cleared there. Instead build the hash
key from family/address/port only, exactly like ovpn_peer_add_mp() and
the lookup, so all three sites agree on the bucket.

Fixes: f0281c1d3732 ("ovpn: add support for updating local or remote UDP endpoint")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 3824ee1c2e40a..9b647a327c468 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -899,7 +899,10 @@ bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
 static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
 					 const struct ovpn_bind *bind)
 {
+	struct sockaddr_storage sa = {};
 	struct hlist_nulls_head *nhead;
+	struct sockaddr_in6 *sa6;
+	struct sockaddr_in *sa4;
 	size_t salen;
 
 	lockdep_assert_held(&peer->ovpn->lock);
@@ -915,12 +918,26 @@ static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
 	if (unlikely(hlist_unhashed(&peer->hash_entry_id)))
 		return;
 
+	/* Build the hash key from the transport identity only
+	 * (family/address/port), matching ovpn_peer_add_mp() and the lookup
+	 * in ovpn_peer_get_by_transp_addr(). Hashing bind->remote directly
+	 * would fold in sin6_scope_id (set on the float path but never by the
+	 * lookup), scattering the peer into a bucket lookups cannot reach.
+	 */
 	switch (bind->remote.in4.sin_family) {
 	case AF_INET:
-		salen = sizeof(struct sockaddr_in);
+		sa4 = (struct sockaddr_in *)&sa;
+		sa4->sin_family = AF_INET;
+		sa4->sin_addr.s_addr = bind->remote.in4.sin_addr.s_addr;
+		sa4->sin_port = bind->remote.in4.sin_port;
+		salen = sizeof(*sa4);
 		break;
 	case AF_INET6:
-		salen = sizeof(struct sockaddr_in6);
+		sa6 = (struct sockaddr_in6 *)&sa;
+		sa6->sin6_family = AF_INET6;
+		sa6->sin6_addr = bind->remote.in6.sin6_addr;
+		sa6->sin6_port = bind->remote.in6.sin6_port;
+		salen = sizeof(*sa6);
 		break;
 	default:
 		return;
@@ -929,8 +946,8 @@ static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
 	/* remove old hashing (no-op if entry is not currently linked) */
 	hlist_nulls_del_init_rcu(&peer->hash_entry_transp_addr);
 	/* re-add with current transport address */
-	nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr,
-				   &bind->remote, salen);
+	nhead = ovpn_get_hash_head(peer->ovpn->peers->by_transp_addr, &sa,
+				   salen);
 	hlist_nulls_add_head_rcu(&peer->hash_entry_transp_addr, nhead);
 }
 
-- 
2.53.0



