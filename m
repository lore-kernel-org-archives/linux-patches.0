Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C743DC4D8;
	Mon, 17 Aug 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974899; cv=none; b=mUUfYxMEI1EUctMJOiv/yTeQALrshVlpJIybu/p/DL+AJqPcs6y4mjIgxHIfiDVldj+ABB6ty1/XHmO2jQShaYk7EN1VsF0067NePcgf7TPd7iLnguSghecvR3dJTL4PqjDn/ltL86qUY5WyNBYrW18KuYaFzSjj8e5Mc50D8JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974899; c=relaxed/simple;
	bh=Dpo74xK7TEFDkH5k0bqsr8E+96FKmZrlQgiW4ZiYpNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdMp8wy8wJ504R+XfwPeIDKXC+Yx1lJA+ZX8ORb6imQ2d3zEo8b87k3HtAYzrBiqDHOsdTX4XI63r9EK24SXIwdzsFxPod2F33liZBPMDl2Jfm7ceZMKay9e0TI74p7/cZ7xsIOX6jvH/FwvWB+8YYGg0qGR24mzkYcyFU5gCdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQ7aMgWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQ7aMgWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B875C1F000E9;
	Mon, 17 Aug 2026 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974895;
	bh=cTqX2xhzmOBeNo3arBfMnpHjBWfUDYF/2284AhN6Ul4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQ7aMgWdLcudiuWh1vJ6dDuVzhPD++LPrBSVxmhutovrPY8HKfjOMdO7EgPKH3hFF
	 0TfYstNAt3o/ZnFPmlU/BR1toqmr0tVCpYiSpL+5m68P7xRfNwoW3whcF5NazPxUOa
	 kvCZC7msA8Rcc0te77/l7pKiJOEZ6YM7Qgc4xxS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/250] netfilter: flowtable: consolidate xmit path
Date: Mon, 17 Aug 2026 15:30:52 +0200
Message-ID: <20260817132540.201689620@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b5964aac51e0c286a50e68225e0dfcf11fb554cb ]

Use dev_queue_xmit() for the XMIT_NEIGH case. Store the interface index
of the real device behind the vlan/pppoe device, this introduces  an
extra lookup for the real device in the xmit path because rt->dst.dev
provides the vlan/pppoe device.

XMIT_NEIGH now looks more similar to XMIT_DIRECT but the check for stale
dst and the neighbour lookup still remain in place which is convenient
to deal with network topology changes.

Note that nft_flow_route() needs to relax the check for _XMIT_NEIGH so
the existing basic xfrm offload (which only works in one direction) does
not break.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 8aecf0bbcc72 ("netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 87 ++++++++++++++++-----------
 net/netfilter/nf_flow_table_path.c    |  7 +--
 4 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e9f72d2558e90..7c330caae52bf 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -141,6 +141,7 @@ struct flow_offload_tuple {
 	union {
 		struct {
 			struct dst_entry *dst_cache;
+			u32		ifidx;
 			u32		dst_cookie;
 		};
 		struct {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d3104816b7f71..595a0f19d15e7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8cd4cf7ae2112..eb4f6a11e779f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -333,19 +333,18 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 	}
 }
 
+struct nf_flow_xmit {
+	const void		*dest;
+	const void		*source;
+	struct net_device	*outdev;
+};
+
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
-				       const struct flow_offload_tuple_rhash *tuplehash,
-				       unsigned short type)
+				       struct nf_flow_xmit *xmit)
 {
-	struct net_device *outdev;
-
-	outdev = dev_get_by_index_rcu(net, tuplehash->tuple.out.ifidx);
-	if (!outdev)
-		return NF_DROP;
-
-	skb->dev = outdev;
-	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
-			tuplehash->tuple.out.h_source, skb->len);
+	skb->dev = xmit->outdev;
+	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+			xmit->dest, xmit->source, skb->len);
 	dev_queue_xmit(skb);
 
 	return NF_STOLEN;
@@ -424,10 +423,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
 	};
+	struct nf_flow_xmit xmit = {};
 	struct flow_offload *flow;
-	struct net_device *outdev;
+	struct neighbour *neigh;
 	struct rtable *rt;
-	__be32 nexthop;
 	int ret;
 
 	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
@@ -454,25 +453,34 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		outdev = rt->dst.dev;
-		skb->dev = outdev;
-		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr));
+		if (IS_ERR(neigh)) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = neigh->ha;
 		skb_dst_set_noref(skb, &rt->dst);
-		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
-		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
-		if (ret == NF_DROP)
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = tuplehash->tuple.out.h_dest;
+		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		ret = NF_DROP;
-		break;
+		return NF_DROP;
 	}
 
-	return ret;
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -719,9 +727,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
 	};
-	const struct in6_addr *nexthop;
+	struct nf_flow_xmit xmit = {};
 	struct flow_offload *flow;
-	struct net_device *outdev;
+	struct neighbour *neigh;
 	struct rt6_info *rt;
 	int ret;
 
@@ -749,24 +757,33 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		outdev = rt->dst.dev;
-		skb->dev = outdev;
-		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6));
+		if (IS_ERR(neigh)) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = neigh->ha;
 		skb_dst_set_noref(skb, &rt->dst);
-		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
-		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
-		if (ret == NF_DROP)
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = tuplehash->tuple.out.h_dest;
+		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		ret = NF_DROP;
-		break;
+		return NF_DROP;
 	}
 
-	return ret;
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 76d4ff1454398..da56fda2c2b39 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -213,11 +213,11 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	}
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+	route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
@@ -265,11 +265,10 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
 
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
-	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH)
 		nft_dev_forward_path(route, ct, dir, ft);
+	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
 		nft_dev_forward_path(route, ct, !dir, ft);
-	}
 
 	return 0;
 }
-- 
2.53.0



