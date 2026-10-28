Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216328;
	b=09FFJP5NuSN4LZ+oCFSHzc3SiMVsbUvVhsX+/yuznd8HcvInflfFINcLkyh0WefTMy68
	 MstMrJcCg6Xq4k95/5F9IwjJP2IIFGPLBtemJcUQKg5HexoI+ait+7dZ9UeWWrGs9lrwA
	 eACS+PGDxVmqL/nD/3G9KPOvZAkUNo91B3xyz0BP2hqJA4VvoOFRskjNwaLhf8IPzb4iH
	 N95eT6JY9wUpdVVEYsgO8awzZ3tqsQEL6OV4FixXL1M79BjY+ImIzgPfZfYzYcKrXEGDu
	 EUH6PKSrChLDZr+LZltt5SIYeGzcz5LvCDMYlWm6cxEOWLc06cplL048SKlSnevwkzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=reUopxDVczdFvVP2HP4Al7jT8LM9nz+urYENC4bU1LA=;
	b=Q97uh4hNm7qaBDEw+FY7gf/dbaRGDCf2i1XI/zx6bkqZVDQfkjLNo7I1ELMt4ac1yaEP
	 TeiHJRD2RAgsGSr2grF776wkxK7aKInjHcnojd++IUU4AWgw8l1SVvfjB5356AfMw7dcJ
	 lPK6uooXO2uKrV/xdQhi0YZnS6rJO1fSzmZVbjWO4JWpYLiH5kQzRotuCEtLy2RehtBuJ
	 ufkQhm7nIYSPylxsSm4y3aJ+nPOBGuD/hXpe6q/eSEExgpxA/nICCIQZdvI3JKCbcIU7+
	 sdiQcVKzJ9RXm/+/vAyN2YekYIvKhDpOzdQqu9fXHjnHODsrfvaH8SabeWdJQcVYUKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMKsNwzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A198606A31A;
	Wed, 28 Oct 2026 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMKsNwzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783611F01825;
	Wed, 28 Oct 2026 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216328;
	bh=reUopxDVczdFvVP2HP4Al7jT8LM9nz+urYENC4bU1LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMKsNwzml265jgwEPkl8ZmmBbaHCWVT57DyhFe1wq1k+7W6td7DB+C880WdfrP77s
	 llwJcif25ndlyVPEAydip9eiVSKAWAA/HbfRsrvG/SICd326VwyguwHBLdGSq/8HwR
	 +/HQT11IZz6l5QIQGSHH5xNE9cTaFefSzmuKVDBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1521/1887] net: bridge: arp/nd proxy: fix reading neigh ha
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028170534.076304000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 57549ab9079122991dfa0f8248ca00e101e8e69b ]

Currently neigh ha address is read directly, but that can result in
torn/partial reads if the neigh is being updated. Use neigh_ha_snapshot
to take a stable snapshot of the address.

Fixes: 057658cb33fb ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260818150756.890025-2-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_arp_nd_proxy.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 97d0349189aaf..9143bb51d83ab 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -191,13 +191,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 	n = neigh_lookup(&arp_tbl, &tip, vlandev);
 	if (n) {
 		struct net_bridge_fdb_entry *f;
+		u8 ha[ETH_ALEN] __aligned(2);
 
 		if (!(READ_ONCE(n->nud_state) & NUD_VALID)) {
 			neigh_release(n);
 			return;
 		}
 
-		f = br_fdb_find_rcu(br, n->ha, vid);
+		neigh_ha_snapshot(ha, n, n->dev);
+		f = br_fdb_find_rcu(br, ha, vid);
 		if (f) {
 			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
@@ -207,10 +209,10 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 						   BR_NEIGH_SUPPRESS)))) {
 				if (!vid)
 					br_arp_send(br, p, skb->dev, sip, tip,
-						    sha, n->ha, sha, 0, 0);
+						    sha, ha, sha, 0, 0);
 				else
 					br_arp_send(br, p, skb->dev, sip, tip,
-						    sha, n->ha, sha,
+						    sha, ha, sha,
 						    skb->vlan_proto,
 						    skb_vlan_tag_get(skb));
 				replied = true;
@@ -248,7 +250,7 @@ struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *msg)
 }
 
 static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
-		       struct sk_buff *request, struct neighbour *n,
+		       struct sk_buff *request, struct neighbour *n, u8 *ha,
 		       __be16 vlan_proto, u16 vlan_tci)
 {
 	struct net_device *dev = request->dev;
@@ -306,7 +308,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		ipv6_eth_mc_map(&in6addr_linklocal_allnodes, eth_hdr(reply)->h_dest);
 	else
 		ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
-	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
+	ether_addr_copy(eth_hdr(reply)->h_source, ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
 
@@ -336,7 +338,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	na->icmph.icmp6_override = 1;
 	na->icmph.icmp6_solicited = dad ? 0 : 1;
 	na->target = ns->target;
-	ether_addr_copy(&na->opt[2], n->ha);
+	ether_addr_copy(&na->opt[2], ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
 	na->opt[1] = na_olen >> 3;
 
@@ -365,7 +367,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		__vlan_hwaccel_put_tag(reply, vlan_proto, vlan_tci);
 
 	netdev_dbg(dev, "nd send dev %s dst %pI6 dst_hw %pM src %pI6 src_hw %pM\n",
-		   dev->name, &pip6->daddr, daddr, &pip6->saddr, n->ha);
+		   dev->name, &pip6->daddr, daddr, &pip6->saddr, ha);
 
 	if (p) {
 		dev_queue_xmit(reply);
@@ -462,24 +464,26 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	n = neigh_lookup(ipv6_stub->nd_tbl, &msg->target, vlandev);
 	if (n) {
 		struct net_bridge_fdb_entry *f;
+		u8 ha[ETH_ALEN] __aligned(2);
 
 		if (!(READ_ONCE(n->nud_state) & NUD_VALID)) {
 			neigh_release(n);
 			return;
 		}
 
-		f = br_fdb_find_rcu(br, n->ha, vid);
+		neigh_ha_snapshot(ha, n, n->dev);
+		f = br_fdb_find_rcu(br, ha, vid);
 		if (f) {
 			const struct net_bridge_port *dst = READ_ONCE(f->dst);
 			bool replied = false;
 
 			if (dst && (dst->flags & BR_NEIGH_SUPPRESS)) {
 				if (vid != 0)
-					br_nd_send(br, p, skb, n,
+					br_nd_send(br, p, skb, n, ha,
 						   skb->vlan_proto,
 						   skb_vlan_tag_get(skb));
 				else
-					br_nd_send(br, p, skb, n, 0, 0);
+					br_nd_send(br, p, skb, n, ha, 0, 0);
 				replied = true;
 			}
 
-- 
2.53.0



