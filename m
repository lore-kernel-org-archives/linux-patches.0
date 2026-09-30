Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2033AD539;
	Wed, 30 Sep 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793017; cv=none; b=MJYEorAGgZ0Uz8+79NrMJOXZeNG3t1LNUK1Ky9rWAchxlflHVV2MOAYzH1igvjwbh0CFIRpKFENVPqrB151sT/wkEVMQSMeYso5BwrM4UFi54kVDRPAuT0HR83oJDkRH0HyxM57/j9BdFTeVVIt4aNVlbEsouhBFvv3y1hfV4pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793017; c=relaxed/simple;
	bh=H/rqWsBpg7A+GOfZjNH5GtfleTzAW9nSP5GG/HVxKH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTmEqMLJM74WG8G2e74KxUA0Yw+UWjOixonDZ0H2P/LNIrXcEHWs7S5n5sS66rqVgLbHjUSjHFvXmP875DyoO3vaK7F7NK9Y0vBvKBm0raq2ILqHBMV4SV456o+PZ3ajf3V3mmBb0ftBu6FeTzh6R/8YgGHeg3gvrby+GiEhxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah+3Eh38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah+3Eh38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFBB1F000FF;
	Wed, 30 Sep 2026 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793016;
	bh=yr015bSSM2KiIfrGiyXSR6S1Q1GoTCaKmjyGVFYhfag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ah+3Eh38Va/QV9SF3cE4aT0LKYQXcuDAOxFDRx6QCd9OhfL/uLwA3XtuRFSOQBu7U
	 d4bDJxVrh790cHNv9E0cPgfeUeOHQvjhtdmMC9sP5YP/New51kvrLTJXmmYFbqv1cO
	 n3UZS18HpHWD/Oap+ZpZzaCcgv6MHbx2/aX5N1QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/395] ovpn: reject duplicate peer VPN addresses
Date: Wed, 30 Sep 2026 17:26:07 +0200
Message-ID: <20260930152342.913955672@linuxfoundation.org>
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

[ Upstream commit d25e885b31a0f2808d936f95c9a558a8a792669b ]

In MP mode, ovpn uses the peer VPN addresses as lookup keys for
selecting the peer that should receive an outgoing tunnel packet.
However, the netlink peer configuration path does not currently reject
duplicate VPN addresses.

If two peers are configured with the same VPN address, both can be
inserted in the VPN address hash table and lookups return whichever peer
is found first. This makes peer selection ambiguous and dependent on
hash insertion order.

Reject peer creation or update when the resulting VPN address is already
assigned to another peer. Ignore unspecified addresses because those are
not inserted in the VPN address hash tables.

This changes such configurations from being accepted to being rejected,
but they have never worked reliably because peer selection is ambiguous.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c | 37 ++++++++++++++++-----
 drivers/net/ovpn/peer.c    | 67 +++++++++++++++++++++++++++++++++++++-
 drivers/net/ovpn/peer.h    |  6 ++++
 3 files changed, 101 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index deddf8e1e81ef..67542b811ba11 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -473,8 +473,10 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 
 int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *attrs[OVPN_A_PEER_MAX + 1];
 	struct ovpn_priv *ovpn = info->user_ptr[0];
+	struct nlattr *attrs[OVPN_A_PEER_MAX + 1];
+	struct in6_addr vpn_addr6;
+	struct in_addr vpn_addr4;
 	struct ovpn_socket *sock;
 	struct ovpn_peer *peer;
 	u32 peer_id;
@@ -521,28 +523,47 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 	rcu_read_unlock();
 
 	spin_lock_bh(&ovpn->lock);
-	ret = ovpn_nl_peer_modify(peer, info, attrs);
-	if (ret < 0) {
-		spin_unlock_bh(&ovpn->lock);
-		ovpn_peer_put(peer);
-		return ret;
+
+	/* reject peer with conflicting VPN address */
+	if (attrs[OVPN_A_PEER_VPN_IPV4]) {
+		vpn_addr4.s_addr = nla_get_in_addr(attrs[OVPN_A_PEER_VPN_IPV4]);
+		if (ovpn_peer_vpn_addr_conflict4(ovpn, peer, &vpn_addr4))
+			goto addr_conflict;
 	}
+	if (attrs[OVPN_A_PEER_VPN_IPV6]) {
+		vpn_addr6 = nla_get_in6_addr(attrs[OVPN_A_PEER_VPN_IPV6]);
+		if (ovpn_peer_vpn_addr_conflict6(ovpn, peer, &vpn_addr6))
+			goto addr_conflict;
+	}
+
+	ret = ovpn_nl_peer_modify(peer, info, attrs);
+	if (ret < 0)
+		goto unlock;
 
 	/* ret == 1 means that VPN IPv4/6 has been modified and rehashing
 	 * is required
 	 */
-	if (ret > 0)
+	if (ret > 0) {
 		ovpn_peer_hash_vpn_ip(peer);
+		ret = 0;
+	}
 	/* if the remote endpoint was updated, the by_transp_addr hash bucket
 	 * also needs to be refreshed, otherwise incoming packets from the new
 	 * remote address would fail the lockless lookup
 	 */
 	if (attrs[OVPN_A_PEER_REMOTE_IPV4] || attrs[OVPN_A_PEER_REMOTE_IPV6])
 		ovpn_peer_hash_transp_addr(peer);
+
+unlock:
 	spin_unlock_bh(&ovpn->lock);
 	ovpn_peer_put(peer);
 
-	return 0;
+	return ret;
+addr_conflict:
+	NL_SET_ERR_MSG_FMT_MOD(info->extack,
+			       "VPN IP is already assigned to another peer");
+	ret = -EADDRINUSE;
+	goto unlock;
 }
 
 static int ovpn_nl_send_peer(struct sk_buff *skb, const struct genl_info *info,
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 03ec043a123b4..d07d91e35f5b4 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -482,7 +482,7 @@ static struct ovpn_peer *ovpn_peer_get_by_vpn_addr4(struct ovpn_priv *ovpn,
  * Return: the peer if found or NULL otherwise
  */
 static struct ovpn_peer *ovpn_peer_get_by_vpn_addr6(struct ovpn_priv *ovpn,
-						    struct in6_addr *addr)
+						    const struct in6_addr *addr)
 {
 	struct hlist_nulls_head *nhead;
 	struct hlist_nulls_node *ntmp;
@@ -507,6 +507,64 @@ static struct ovpn_peer *ovpn_peer_get_by_vpn_addr6(struct ovpn_priv *ovpn,
 	return NULL;
 }
 
+/**
+ * ovpn_peer_vpn_addr_conflict4 - check if the VPN v4 address is already in use
+ * @ovpn: the openvpn instance to search
+ * @peer: peer being added or updated, or NULL
+ * @addr: VPN IPv4 address to check
+ *
+ * Check whether @addr is already assigned to another peer. @peer is ignored
+ * when found, allowing peer updates that keep an existing address.
+ * Unspecified addresses are ignored.
+ *
+ * Note: the caller must hold @ovpn->lock.
+ *
+ * Return: true on conflict, false otherwise.
+ */
+bool ovpn_peer_vpn_addr_conflict4(struct ovpn_priv *ovpn,
+				  const struct ovpn_peer *peer,
+				  const struct in_addr *addr)
+{
+	struct ovpn_peer *tmp = NULL;
+
+	lockdep_assert_held(&ovpn->lock);
+
+	/* we don't hash INADDR_ANY, no conflict in that case */
+	if (addr->s_addr != htonl(INADDR_ANY))
+		tmp = ovpn_peer_get_by_vpn_addr4(ovpn, addr->s_addr);
+
+	return tmp && tmp != peer;
+}
+
+/**
+ * ovpn_peer_vpn_addr_conflict6 - check if the VPN v6 address is already in use
+ * @ovpn: the openvpn instance to search
+ * @peer: peer being added or updated, or NULL
+ * @addr: VPN IPv6 address to check
+ *
+ * Check whether @addr is already assigned to another peer. @peer is ignored
+ * when found, allowing peer updates that keep an existing address.
+ * Unspecified addresses are ignored.
+ *
+ * Note: the caller must hold @ovpn->lock.
+ *
+ * Return: true on conflict, false otherwise.
+ */
+bool ovpn_peer_vpn_addr_conflict6(struct ovpn_priv *ovpn,
+				  const struct ovpn_peer *peer,
+				  const struct in6_addr *addr)
+{
+	struct ovpn_peer *tmp = NULL;
+
+	lockdep_assert_held(&ovpn->lock);
+
+	/* we don't hash ::, no conflict in that case */
+	if (!ipv6_addr_any(addr))
+		tmp = ovpn_peer_get_by_vpn_addr6(ovpn, addr);
+
+	return tmp && tmp != peer;
+}
+
 /**
  * ovpn_peer_transp_match - check if sockaddr and peer binding match
  * @peer: the peer to get the binding from
@@ -1035,6 +1093,13 @@ static int ovpn_peer_add_mp(struct ovpn_priv *ovpn, struct ovpn_peer *peer)
 		goto out;
 	}
 
+	/* reject peer with conflicting VPN address */
+	if (ovpn_peer_vpn_addr_conflict4(ovpn, NULL, &peer->vpn_addrs.ipv4) ||
+	    ovpn_peer_vpn_addr_conflict6(ovpn, NULL, &peer->vpn_addrs.ipv6)) {
+		ret = -EADDRINUSE;
+		goto out;
+	}
+
 	bind = rcu_dereference_protected(peer->bind, true);
 	/* peers connected via TCP have bind == NULL */
 	if (bind) {
diff --git a/drivers/net/ovpn/peer.h b/drivers/net/ovpn/peer.h
index 693175712f7af..2306b84929bb1 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -162,6 +162,12 @@ struct ovpn_peer *ovpn_peer_get_by_transp_addr(struct ovpn_priv *ovpn,
 struct ovpn_peer *ovpn_peer_get_by_id(struct ovpn_priv *ovpn, u32 peer_id);
 struct ovpn_peer *ovpn_peer_get_by_dst(struct ovpn_priv *ovpn,
 				       struct sk_buff *skb);
+bool ovpn_peer_vpn_addr_conflict4(struct ovpn_priv *ovpn,
+				  const struct ovpn_peer *peer,
+				  const struct in_addr *addr);
+bool ovpn_peer_vpn_addr_conflict6(struct ovpn_priv *ovpn,
+				  const struct ovpn_peer *peer,
+				  const struct in6_addr *addr);
 void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer);
 void ovpn_peer_hash_transp_addr(struct ovpn_peer *peer);
 bool ovpn_peer_check_by_src(struct ovpn_priv *ovpn, struct sk_buff *skb,
-- 
2.53.0



