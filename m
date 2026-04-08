Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7256432A3FD;
	Wed,  8 Apr 2026 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673735; cv=none; b=X5beo7ggWRUPHoHn16NlSslCjHgpaei/0PLekIYvWQS1fEeJ6ZjybLbSvGWli3yl6omuy4Zdi802DRWpO/xLVNKPaahCT5Xhhpb5YPNSrqCb3JKIqBAp9+OzHLwVpF3oxhUOP1EgW433cUJXOjUS1m5FU4qHH0cQE/TGmWlyIV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673735; c=relaxed/simple;
	bh=l3URORevZOpxqrvrKhG4yLHDgitJ+73xeBYTa0QZawM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POVgfugMQdy1rRyCnAz8zjNrNRj3hMfVMp10s4ROmR1heaamvxXkir1mY/iYvHg/1qDnLADPzKbzm4Tai9Mbb3Vwp9kl8QyaFSTPnjGEMgx1vJFoxUbLDel3ErHRR1ctNndmr70c1jNmM3ZlUIUGHtj9wp3jpiTvEpvek8mvBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9Xk519K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9Xk519K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C3DC19421;
	Wed,  8 Apr 2026 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673735;
	bh=l3URORevZOpxqrvrKhG4yLHDgitJ+73xeBYTa0QZawM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9Xk519KYku5DjXDzYhFV8WOUTfWWmSkKltKryccJvX5W9qYobDuh9K5ejt8naYzY
	 QpNvaX2GB+fsyPN6hYqwgAUw4sM2hw05WX3HJy2WiwH5BnqN9KV+lsee0UgDf+zb5J
	 R/aJRwEQM4Q5Fv83TDd6uStMFHg1EmA9jrKsePQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/242] netfilter: flowtable: strictly check for maximum number of actions
Date: Wed,  8 Apr 2026 20:01:48 +0200
Message-ID: <20260408175929.629680758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 76522fcdbc3a02b568f5d957f7e66fc194abb893 ]

The maximum number of flowtable hardware offload actions in IPv6 is:

* ethernet mangling (4 payload actions, 2 for each ethernet address)
* SNAT (4 payload actions)
* DNAT (4 payload actions)
* Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
  for QinQ.
* Redirect (1 action)

Which makes 17, while the maximum is 16. But act_ct supports for tunnels
actions too. Note that payload action operates at 32-bit word level, so
mangling an IPv6 address takes 4 payload actions.

Update flow_action_entry_next() calls to check for the maximum number of
supported actions.

While at it, rise the maximum number of actions per flow from 16 to 24
so this works fine with IPv6 setups.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 196 +++++++++++++++++---------
 1 file changed, 130 insertions(+), 66 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe7..4f346f51d7d74 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -13,6 +13,8 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+#define NF_FLOW_RULE_ACTION_MAX	24
+
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
@@ -215,7 +217,12 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 static inline struct flow_action_entry *
 flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
-	int i = flow_rule->rule->action.num_entries++;
+	int i;
+
+	if (unlikely(flow_rule->rule->action.num_entries >= NF_FLOW_RULE_ACTION_MAX))
+		return NULL;
+
+	i = flow_rule->rule->action.num_entries++;
 
 	return &flow_rule->rule->action.entries[i];
 }
@@ -233,6 +240,9 @@ static int flow_offload_eth_src(struct net *net,
 	u32 mask, val;
 	u16 val16;
 
+	if (!entry0 || !entry1)
+		return -E2BIG;
+
 	this_tuple = &flow->tuplehash[dir].tuple;
 
 	switch (this_tuple->xmit_type) {
@@ -283,6 +293,9 @@ static int flow_offload_eth_dst(struct net *net,
 	u8 nud_state;
 	u16 val16;
 
+	if (!entry0 || !entry1)
+		return -E2BIG;
+
 	this_tuple = &flow->tuplehash[dir].tuple;
 
 	switch (this_tuple->xmit_type) {
@@ -324,16 +337,19 @@ static int flow_offload_eth_dst(struct net *net,
 	return 0;
 }
 
-static void flow_offload_ipv4_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4.s_addr;
@@ -344,23 +360,27 @@ static void flow_offload_ipv4_snat(struct net *net,
 		offset = offsetof(struct iphdr, daddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
 			    &addr, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv4_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4.s_addr;
@@ -371,14 +391,15 @@ static void flow_offload_ipv4_dnat(struct net *net,
 		offset = offsetof(struct iphdr, saddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
 			    &addr, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
+static int flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     unsigned int offset,
 				     const __be32 *addr, const __be32 *mask)
 {
@@ -387,15 +408,20 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 
 	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
 		entry = flow_action_entry_next(flow_rule);
+		if (!entry)
+			return -E2BIG;
+
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
 				    offset + i * sizeof(u32), &addr[i], mask);
 	}
+
+	return 0;
 }
 
-static void flow_offload_ipv6_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv6_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
 	const __be32 *addr;
@@ -411,16 +437,16 @@ static void flow_offload_ipv6_snat(struct net *net,
 		offset = offsetof(struct ipv6hdr, daddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
+	return flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
-static void flow_offload_ipv6_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv6_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
 	const __be32 *addr;
@@ -436,10 +462,10 @@ static void flow_offload_ipv6_dnat(struct net *net,
 		offset = offsetof(struct ipv6hdr, saddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
+	return flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
 static int flow_offload_l4proto(const struct flow_offload *flow)
@@ -461,15 +487,18 @@ static int flow_offload_l4proto(const struct flow_offload *flow)
 	return type;
 }
 
-static void flow_offload_port_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_port_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask, port;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
@@ -484,22 +513,26 @@ static void flow_offload_port_snat(struct net *net,
 		mask = ~htonl(0xffff);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
+	return 0;
 }
 
-static void flow_offload_port_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_port_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask, port;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port);
@@ -514,20 +547,24 @@ static void flow_offload_port_dnat(struct net *net,
 		mask = ~htonl(0xffff0000);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv4_checksum(struct net *net,
-				       const struct flow_offload *flow,
-				       struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_checksum(struct net *net,
+				      const struct flow_offload *flow,
+				      struct nf_flow_rule *flow_rule)
 {
 	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 
+	if (!entry)
+		return -E2BIG;
+
 	entry->id = FLOW_ACTION_CSUM;
 	entry->csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR;
 
@@ -539,12 +576,14 @@ static void flow_offload_ipv4_checksum(struct net *net,
 		entry->csum_flags |= TCA_CSUM_UPDATE_FLAG_UDP;
 		break;
 	}
+
+	return 0;
 }
 
-static void flow_offload_redirect(struct net *net,
-				  const struct flow_offload *flow,
-				  enum flow_offload_tuple_dir dir,
-				  struct nf_flow_rule *flow_rule)
+static int flow_offload_redirect(struct net *net,
+				 const struct flow_offload *flow,
+				 enum flow_offload_tuple_dir dir,
+				 struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *this_tuple, *other_tuple;
 	struct flow_action_entry *entry;
@@ -562,21 +601,28 @@ static void flow_offload_redirect(struct net *net,
 		ifindex = other_tuple->iifidx;
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	dev = dev_get_by_index(net, ifindex);
 	if (!dev)
-		return;
+		return -ENODEV;
 
 	entry = flow_action_entry_next(flow_rule);
+	if (!entry) {
+		dev_put(dev);
+		return -E2BIG;
+	}
+
 	entry->id = FLOW_ACTION_REDIRECT;
 	entry->dev = dev;
+
+	return 0;
 }
 
-static void flow_offload_encap_tunnel(const struct flow_offload *flow,
-				      enum flow_offload_tuple_dir dir,
-				      struct nf_flow_rule *flow_rule)
+static int flow_offload_encap_tunnel(const struct flow_offload *flow,
+				     enum flow_offload_tuple_dir dir,
+				     struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *this_tuple;
 	struct flow_action_entry *entry;
@@ -584,7 +630,7 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 
 	this_tuple = &flow->tuplehash[dir].tuple;
 	if (this_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
-		return;
+		return 0;
 
 	dst = this_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
@@ -593,15 +639,19 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 		tun_info = lwt_tun_info(dst->lwtstate);
 		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -E2BIG;
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
 			entry->tunnel = tun_info;
 		}
 	}
+
+	return 0;
 }
 
-static void flow_offload_decap_tunnel(const struct flow_offload *flow,
-				      enum flow_offload_tuple_dir dir,
-				      struct nf_flow_rule *flow_rule)
+static int flow_offload_decap_tunnel(const struct flow_offload *flow,
+				     enum flow_offload_tuple_dir dir,
+				     struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
 	struct flow_action_entry *entry;
@@ -609,7 +659,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
-		return;
+		return 0;
 
 	dst = other_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
@@ -618,9 +668,13 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 		tun_info = lwt_tun_info(dst->lwtstate);
 		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -E2BIG;
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		}
 	}
+
+	return 0;
 }
 
 static int
@@ -632,8 +686,9 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	const struct flow_offload_tuple *tuple;
 	int i;
 
-	flow_offload_decap_tunnel(flow, dir, flow_rule);
-	flow_offload_encap_tunnel(flow, dir, flow_rule);
+	if (flow_offload_decap_tunnel(flow, dir, flow_rule) < 0 ||
+	    flow_offload_encap_tunnel(flow, dir, flow_rule) < 0)
+		return -1;
 
 	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
@@ -649,6 +704,8 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 
 		if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -1;
 			entry->id = FLOW_ACTION_VLAN_POP;
 		}
 	}
@@ -662,6 +719,8 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			continue;
 
 		entry = flow_action_entry_next(flow_rule);
+		if (!entry)
+			return -1;
 
 		switch (other_tuple->encap[i].proto) {
 		case htons(ETH_P_PPP_SES):
@@ -687,18 +746,22 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 		return -1;
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
-		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
-		flow_offload_port_snat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv4_snat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
-		flow_offload_ipv4_dnat(net, flow, dir, flow_rule);
-		flow_offload_port_dnat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv4_dnat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_dnat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) ||
 	    test_bit(NF_FLOW_DNAT, &flow->flags))
-		flow_offload_ipv4_checksum(net, flow, flow_rule);
+		if (flow_offload_ipv4_checksum(net, flow, flow_rule) < 0)
+			return -1;
 
-	flow_offload_redirect(net, flow, dir, flow_rule);
+	if (flow_offload_redirect(net, flow, dir, flow_rule) < 0)
+		return -1;
 
 	return 0;
 }
@@ -712,22 +775,23 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 		return -1;
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
-		flow_offload_ipv6_snat(net, flow, dir, flow_rule);
-		flow_offload_port_snat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv6_snat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
-		flow_offload_ipv6_dnat(net, flow, dir, flow_rule);
-		flow_offload_port_dnat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv6_dnat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_dnat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 
-	flow_offload_redirect(net, flow, dir, flow_rule);
+	if (flow_offload_redirect(net, flow, dir, flow_rule) < 0)
+		return -1;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv6);
 
-#define NF_FLOW_RULE_ACTION_MAX	16
-
 static struct nf_flow_rule *
 nf_flow_offload_rule_alloc(struct net *net,
 			   const struct flow_offload_work *offload,
-- 
2.53.0



