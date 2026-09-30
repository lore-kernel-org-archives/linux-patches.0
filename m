Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BF336E467;
	Wed, 30 Sep 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787130; cv=none; b=j+xldnMcMWvUDg5LgttM6Ptgq9lWbcZuQyxgR+EsFSCXGy2C5vddLmbqtJB1HOhA27hE1hrYExgvAsAv42I2e/tY5lbxB625uCa0TOcXByAHbkLkoepCtNJ+iS8m5kWQ2DS+9C9etRIsnZKioxh3+hTMCx+6i4r/Z8VlT259mh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787130; c=relaxed/simple;
	bh=d2kBlKzUw7g9WQ65gWb0sOB0OSDhW/EZ2mzSl+zz4k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhBMo1ZcpTP1LQL8mT8ktxl3OhcLj7uJVfEJjzClEy6cKAk043GkwWhRusabjrm/otiN1TQSKn9idJXT59daiNK6q/mrDrjBzf4xRQh9D6pcgL6agfoeYewf3YmFzIXGzSxVKpONnh+rp0WYyEZKk6BP6oDeo8mA2NR/HWhfQm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YICbo42g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YICbo42g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAEB1F000FF;
	Wed, 30 Sep 2026 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787129;
	bh=Qi6Vut4a91LzKYj91Cq/X7HKxYjQyYLK87/HDZWfvvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YICbo42gPFFcg2IruxsoUiVHdgSpKxb7sdoahm0e4fdD/KfeVjY6orPwwoNX68rFT
	 lVf8Us4s6yCjDy036q2uq+ZA18YjSX1rGmvTCynZcxiuNDx1a1Vd2bLigPmyrzpDSM
	 SaPB8MarB8VIFsP4K+q6T4fCjKCX2g9Acisi6L1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 123/457] ovpn: reject duplicate peer VPN addresses
Date: Wed, 30 Sep 2026 17:23:48 +0200
Message-ID: <20260930152348.706012654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2ba762082acc1..e23f7d1f49e01 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -480,8 +480,10 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 
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
@@ -528,28 +530,47 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
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
index bbd9e17fb0bfa..2067825bb5b61 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -488,7 +488,7 @@ static struct ovpn_peer *ovpn_peer_get_by_vpn_addr4(struct ovpn_priv *ovpn,
  * Return: the peer if found or NULL otherwise
  */
 static struct ovpn_peer *ovpn_peer_get_by_vpn_addr6(struct ovpn_priv *ovpn,
-						    struct in6_addr *addr)
+						    const struct in6_addr *addr)
 {
 	struct hlist_nulls_head *nhead;
 	struct hlist_nulls_node *ntmp;
@@ -513,6 +513,64 @@ static struct ovpn_peer *ovpn_peer_get_by_vpn_addr6(struct ovpn_priv *ovpn,
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
@@ -1040,6 +1098,13 @@ static int ovpn_peer_add_mp(struct ovpn_priv *ovpn, struct ovpn_peer *peer)
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
index 063535699ecd8..1879bfb76992d 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -164,6 +164,12 @@ struct ovpn_peer *ovpn_peer_get_by_transp_addr(struct ovpn_priv *ovpn,
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



