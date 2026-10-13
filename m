Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C33CB2EA;
	Tue, 13 Oct 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893970; cv=none; b=hVw32w6K1fWWmnLosMff9gXwxaZELPpyAndATt3ek/5Fn0zdEoyjs3Z10g6C8bfKcGCpOu0GCTL7iLfYhgJxG4YLt4kdGaS6S0YxxF0rriyWnTQg4s3cwLpM3j2kPl+QLnjktfZPd7ze4hjWFPn9OL3JIdns3/Tqfq+xzXiqdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893970; c=relaxed/simple;
	bh=ryeqykVPIjDdnA4BRhNqX+caXwLNQIx9+m2BpkBnJdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOu+x2OlXUnvdFuZMWpNPAGKPB+HV4RYMwB8wMZU/iEAxZ80dQlOq/VMGwAv3fxzZjD0+HGXKywuxB56wBDLjzQHtBkaBdrxEXLpviXOUgEjr8PCJJazzgXLYClI48VPuuFBFyCXQAtZT6fhKndM1zD/PX1yajB/hn48NF6Js5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRX3f83c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRX3f83c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032421F000FF;
	Tue, 13 Oct 2026 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893968;
	bh=CSQdeDY+16W4nGylI6xNRmoeLlNHI9s4RN7dj72t36k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRX3f83cJHaZcncMrKhC98znOTqbxVk3vP0UDHPbK1d4yaXuH2WwCdyDx/iHiZVWR
	 CU5MijiVyfmnqZPHP+ZKgKfvqDubj8bS9yuvQZyh89t7J/52GYQEMwWnRvsX64NuZr
	 RRCg15DjzqW/Cnu96rZdhO2O+70EiZWhlF+CD3Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 404/621] net: bridge: arp/nd proxy: fix reading neigh ha
Date: Tue, 13 Oct 2026 13:36:39 +0200
Message-ID: <20261013112930.428076795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 4cd3470e5f56c..3203706d02b88 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -194,13 +194,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
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
@@ -210,10 +212,10 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			    br_is_neigh_suppress_enabled(dst, vid)) {
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
@@ -251,7 +253,7 @@ struct nd_msg *br_is_nd_neigh_msg(const struct sk_buff *skb, struct nd_msg *msg)
 }
 
 static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
-		       struct sk_buff *request, struct neighbour *n,
+		       struct sk_buff *request, struct neighbour *n, u8 *ha,
 		       __be16 vlan_proto, u16 vlan_tci)
 {
 	struct net_device *dev = request->dev;
@@ -309,7 +311,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		ipv6_eth_mc_map(&in6addr_linklocal_allnodes, eth_hdr(reply)->h_dest);
 	else
 		ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
-	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
+	ether_addr_copy(eth_hdr(reply)->h_source, ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
 
@@ -339,7 +341,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	na->icmph.icmp6_override = 1;
 	na->icmph.icmp6_solicited = dad ? 0 : 1;
 	na->target = ns->target;
-	ether_addr_copy(&na->opt[2], n->ha);
+	ether_addr_copy(&na->opt[2], ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
 	na->opt[1] = na_olen >> 3;
 
@@ -368,7 +370,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		__vlan_hwaccel_put_tag(reply, vlan_proto, vlan_tci);
 
 	netdev_dbg(dev, "nd send dev %s dst %pI6 dst_hw %pM src %pI6 src_hw %pM\n",
-		   dev->name, &pip6->daddr, daddr, &pip6->saddr, n->ha);
+		   dev->name, &pip6->daddr, daddr, &pip6->saddr, ha);
 
 	if (p) {
 		dev_queue_xmit(reply);
@@ -469,24 +471,26 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
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
 
 			if (br_is_neigh_suppress_enabled(dst, vid)) {
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



