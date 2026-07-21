Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D5F47127E;
	Tue, 21 Jul 2026 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657756; cv=none; b=Pv4zg/OlL9EsZt/nl8QrQSPyONvm/5CyOUkcwra3kVnnHBl9deG3KGwJ5qsjOJ+FjgCAF/SHvYozlbmh+aY5KI15eZ8HzhSJ74MstomqQiw5odjcooW0hDiCAwzJOKwJJkcUDPzzN+2GED3ebSHI9NW8zi+5qJYI/yXbPmJEdG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657756; c=relaxed/simple;
	bh=3/TW3SsOU5wOhwcLiVWENJWKkmzYpIxHG7SAWiQO81s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbBjnXzfbll2XwEleHzuh/E97PNclPX+gBQESDxraoYJew0QGBGVkOdyMnRQPRcVQz6ceH7dbVaNN7GYhTwKns8hRIxPByEQwA+2Gp/DUTqKyFgJ8fcaUl/QfS2ZL1nwrmXdAuiqY6jBo8reMoaYtc3bFubjXjC2/9VKN7+RLsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA8G4cfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA8G4cfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222851F000E9;
	Tue, 21 Jul 2026 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657754;
	bh=oHwpaorW3TSEl+fEduU0+BUr0FVAXQ8osQpYsipJIAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XA8G4cfRdoyn/URFqMfAmvHA1qLI30jQy63xhLCKD3jAtLpqlGyDkodx8RySHsAdj
	 Ewfx44n9wN4L5Te0ESTxaWKTSb6TSyAsCyV/h4FS8QMMUB+12eQDUAwu6mN0RE5t/H
	 ykD0tUhUgWfUllaIExi9EQ2E8jwFvYlaghnghraw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0843/1611] netfilter: flowtable: move path discovery infrastructure to its own file
Date: Tue, 21 Jul 2026 17:15:59 +0200
Message-ID: <20260721152534.347721736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 93d7a7ed07342f5e3da2d250cfd67f899d0b5318 ]

This file contains the path discovery that is run from the forward chain
for the packet offloading the flow into the flowtable. This consists
of a series of calls to dev_fill_forward_path() for each device stack.

More topologies may be supported in the future, so move this code to its
own file to separate it from the nftables flow_offload expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: e409c23c2d06 ("netfilter: nft_flow_offload: zero device address for non-ether case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |   6 +
 net/netfilter/Makefile                |   1 +
 net/netfilter/nf_flow_table_path.c    | 274 ++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      | 259 ------------------------
 4 files changed, 281 insertions(+), 259 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_path.c

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c003cd194fa2ae..e9f72d2558e901 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -222,6 +222,12 @@ struct nf_flow_route {
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
 void flow_offload_free(struct flow_offload *flow);
 
+struct nft_flowtable;
+struct nft_pktinfo;
+int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
+		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
+		   struct nft_flowtable *ft);
+
 static inline int
 nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 			     flow_setup_cb_t *cb, void *cb_priv)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e43e20f529f871..6bfc250e474fe0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -141,6 +141,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
+				   nf_flow_table_path.o \
 				   nf_flow_table_offload.o nf_flow_table_xdp.o
 nf_flow_table-$(CONFIG_NF_FLOW_TABLE_PROCFS) += nf_flow_table_procfs.o
 ifeq ($(CONFIG_NF_FLOW_TABLE),m)
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
new file mode 100644
index 00000000000000..e525e3745651d8
--- /dev/null
+++ b/net/netfilter/nf_flow_table_path.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/ip.h>
+#include <net/inet_dscp.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_flow_table.h>
+
+static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
+{
+	if (dst_xfrm(dst))
+		return FLOW_OFFLOAD_XMIT_XFRM;
+
+	return FLOW_OFFLOAD_XMIT_NEIGH;
+}
+
+static void nft_default_forward_path(struct nf_flow_route *route,
+				     struct dst_entry *dst_cache,
+				     enum ip_conntrack_dir dir)
+{
+	route->tuple[!dir].in.ifindex	= dst_cache->dev->ifindex;
+	route->tuple[dir].dst		= dst_cache;
+	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
+}
+
+static bool nft_is_valid_ether_device(const struct net_device *dev)
+{
+	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
+	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
+		return false;
+
+	return true;
+}
+
+static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
+				     const struct dst_entry *dst_cache,
+				     const struct nf_conn *ct,
+				     enum ip_conntrack_dir dir, u8 *ha,
+				     struct net_device_path_stack *stack)
+{
+	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
+	struct net_device *dev = dst_cache->dev;
+	struct neighbour *n;
+	u8 nud_state;
+
+	if (!nft_is_valid_ether_device(dev))
+		goto out;
+
+	n = dst_neigh_lookup(dst_cache, daddr);
+	if (!n)
+		return -1;
+
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	ether_addr_copy(ha, n->ha);
+	read_unlock_bh(&n->lock);
+	neigh_release(n);
+
+	if (!(nud_state & NUD_VALID))
+		return -1;
+
+out:
+	return dev_fill_forward_path(dev, ha, stack);
+}
+
+struct nft_forward_info {
+	const struct net_device *indev;
+	const struct net_device *outdev;
+	const struct net_device *hw_outdev;
+	struct id {
+		__u16	id;
+		__be16	proto;
+	} encap[NF_FLOW_TABLE_ENCAP_MAX];
+	u8 num_encaps;
+	u8 ingress_vlans;
+	u8 h_source[ETH_ALEN];
+	u8 h_dest[ETH_ALEN];
+	enum flow_offload_xmit_type xmit_type;
+};
+
+static void nft_dev_path_info(const struct net_device_path_stack *stack,
+			      struct nft_forward_info *info,
+			      unsigned char *ha, struct nf_flowtable *flowtable)
+{
+	const struct net_device_path *path;
+	int i;
+
+	memcpy(info->h_dest, ha, ETH_ALEN);
+
+	for (i = 0; i < stack->num_paths; i++) {
+		path = &stack->path[i];
+		switch (path->type) {
+		case DEV_PATH_ETHERNET:
+		case DEV_PATH_DSA:
+		case DEV_PATH_VLAN:
+		case DEV_PATH_PPPOE:
+			info->indev = path->dev;
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+
+			if (path->type == DEV_PATH_ETHERNET)
+				break;
+			if (path->type == DEV_PATH_DSA) {
+				i = stack->num_paths;
+				break;
+			}
+
+			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
+			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+				info->indev = NULL;
+				break;
+			}
+			if (!info->outdev)
+				info->outdev = path->dev;
+			info->encap[info->num_encaps].id = path->encap.id;
+			info->encap[info->num_encaps].proto = path->encap.proto;
+			info->num_encaps++;
+			if (path->type == DEV_PATH_PPPOE)
+				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			break;
+		case DEV_PATH_BRIDGE:
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+
+			switch (path->bridge.vlan_mode) {
+			case DEV_PATH_BR_VLAN_UNTAG_HW:
+				info->ingress_vlans |= BIT(info->num_encaps - 1);
+				break;
+			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
+				info->encap[info->num_encaps].id = path->bridge.vlan_id;
+				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
+				info->num_encaps++;
+				break;
+			case DEV_PATH_BR_VLAN_UNTAG:
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
+				break;
+			case DEV_PATH_BR_VLAN_KEEP:
+				break;
+			}
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+			break;
+		default:
+			info->indev = NULL;
+			break;
+		}
+	}
+	if (!info->outdev)
+		info->outdev = info->indev;
+
+	info->hw_outdev = info->indev;
+
+	if (nf_flowtable_hw_offload(flowtable) &&
+	    nft_is_valid_ether_device(info->indev))
+		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+}
+
+static bool nft_flowtable_find_dev(const struct net_device *dev,
+				   struct nft_flowtable *ft)
+{
+	struct nft_hook *hook;
+	bool found = false;
+
+	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
+		if (!nft_hook_find_ops_rcu(hook, dev))
+			continue;
+
+		found = true;
+		break;
+	}
+
+	return found;
+}
+
+static void nft_dev_forward_path(struct nf_flow_route *route,
+				 const struct nf_conn *ct,
+				 enum ip_conntrack_dir dir,
+				 struct nft_flowtable *ft)
+{
+	const struct dst_entry *dst = route->tuple[dir].dst;
+	struct net_device_path_stack stack;
+	struct nft_forward_info info = {};
+	unsigned char ha[ETH_ALEN];
+	int i;
+
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
+		nft_dev_path_info(&stack, &info, ha, &ft->data);
+
+	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
+		return;
+
+	route->tuple[!dir].in.ifindex = info.indev->ifindex;
+	for (i = 0; i < info.num_encaps; i++) {
+		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
+		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
+	}
+	route->tuple[!dir].in.num_encaps = info.num_encaps;
+	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+
+	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
+		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
+		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
+		route->tuple[dir].xmit_type = info.xmit_type;
+	}
+}
+
+int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
+		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
+		   struct nft_flowtable *ft)
+{
+	struct dst_entry *this_dst = skb_dst(pkt->skb);
+	struct dst_entry *other_dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(fl));
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
+		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
+		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
+		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
+		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
+		fl.u.ip4.flowi4_mark = pkt->skb->mark;
+		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	case NFPROTO_IPV6:
+		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
+		fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
+		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
+		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
+		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		fl.u.ip6.flowi6_mark = pkt->skb->mark;
+		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	}
+
+	if (!dst_hold_safe(this_dst))
+		return -ENOENT;
+
+	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
+	if (!other_dst) {
+		dst_release(this_dst);
+		return -ENOENT;
+	}
+
+	nft_default_forward_path(route, this_dst, dir);
+	nft_default_forward_path(route, other_dst, !dir);
+
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
+	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+		nft_dev_forward_path(route, ct, dir, ft);
+		nft_dev_forward_path(route, ct, !dir, ft);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_flow_route);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index e95e5f59a3d6a3..b8f76c9057fda6 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -20,265 +20,6 @@ struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
 
-static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
-{
-	if (dst_xfrm(dst))
-		return FLOW_OFFLOAD_XMIT_XFRM;
-
-	return FLOW_OFFLOAD_XMIT_NEIGH;
-}
-
-static void nft_default_forward_path(struct nf_flow_route *route,
-				     struct dst_entry *dst_cache,
-				     enum ip_conntrack_dir dir)
-{
-	route->tuple[!dir].in.ifindex	= dst_cache->dev->ifindex;
-	route->tuple[dir].dst		= dst_cache;
-	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
-}
-
-static bool nft_is_valid_ether_device(const struct net_device *dev)
-{
-	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
-	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
-		return false;
-
-	return true;
-}
-
-static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
-				     const struct dst_entry *dst_cache,
-				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir, u8 *ha,
-				     struct net_device_path_stack *stack)
-{
-	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
-	struct net_device *dev = dst_cache->dev;
-	struct neighbour *n;
-	u8 nud_state;
-
-	if (!nft_is_valid_ether_device(dev))
-		goto out;
-
-	n = dst_neigh_lookup(dst_cache, daddr);
-	if (!n)
-		return -1;
-
-	read_lock_bh(&n->lock);
-	nud_state = n->nud_state;
-	ether_addr_copy(ha, n->ha);
-	read_unlock_bh(&n->lock);
-	neigh_release(n);
-
-	if (!(nud_state & NUD_VALID))
-		return -1;
-
-out:
-	return dev_fill_forward_path(dev, ha, stack);
-}
-
-struct nft_forward_info {
-	const struct net_device *indev;
-	const struct net_device *outdev;
-	const struct net_device *hw_outdev;
-	struct id {
-		__u16	id;
-		__be16	proto;
-	} encap[NF_FLOW_TABLE_ENCAP_MAX];
-	u8 num_encaps;
-	u8 ingress_vlans;
-	u8 h_source[ETH_ALEN];
-	u8 h_dest[ETH_ALEN];
-	enum flow_offload_xmit_type xmit_type;
-};
-
-static void nft_dev_path_info(const struct net_device_path_stack *stack,
-			      struct nft_forward_info *info,
-			      unsigned char *ha, struct nf_flowtable *flowtable)
-{
-	const struct net_device_path *path;
-	int i;
-
-	memcpy(info->h_dest, ha, ETH_ALEN);
-
-	for (i = 0; i < stack->num_paths; i++) {
-		path = &stack->path[i];
-		switch (path->type) {
-		case DEV_PATH_ETHERNET:
-		case DEV_PATH_DSA:
-		case DEV_PATH_VLAN:
-		case DEV_PATH_PPPOE:
-			info->indev = path->dev;
-			if (is_zero_ether_addr(info->h_source))
-				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
-
-			if (path->type == DEV_PATH_ETHERNET)
-				break;
-			if (path->type == DEV_PATH_DSA) {
-				i = stack->num_paths;
-				break;
-			}
-
-			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
-			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-				info->indev = NULL;
-				break;
-			}
-			if (!info->outdev)
-				info->outdev = path->dev;
-			info->encap[info->num_encaps].id = path->encap.id;
-			info->encap[info->num_encaps].proto = path->encap.proto;
-			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
-				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
-			break;
-		case DEV_PATH_BRIDGE:
-			if (is_zero_ether_addr(info->h_source))
-				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
-
-			switch (path->bridge.vlan_mode) {
-			case DEV_PATH_BR_VLAN_UNTAG_HW:
-				info->ingress_vlans |= BIT(info->num_encaps - 1);
-				break;
-			case DEV_PATH_BR_VLAN_TAG:
-				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-					info->indev = NULL;
-					break;
-				}
-				info->encap[info->num_encaps].id = path->bridge.vlan_id;
-				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-				info->num_encaps++;
-				break;
-			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
-					info->indev = NULL;
-					break;
-				}
-				break;
-			case DEV_PATH_BR_VLAN_KEEP:
-				break;
-			}
-			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
-			break;
-		default:
-			info->indev = NULL;
-			break;
-		}
-	}
-	if (!info->outdev)
-		info->outdev = info->indev;
-
-	info->hw_outdev = info->indev;
-
-	if (nf_flowtable_hw_offload(flowtable) &&
-	    nft_is_valid_ether_device(info->indev))
-		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
-}
-
-static bool nft_flowtable_find_dev(const struct net_device *dev,
-				   struct nft_flowtable *ft)
-{
-	struct nft_hook *hook;
-	bool found = false;
-
-	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
-		if (!nft_hook_find_ops_rcu(hook, dev))
-			continue;
-
-		found = true;
-		break;
-	}
-
-	return found;
-}
-
-static void nft_dev_forward_path(struct nf_flow_route *route,
-				 const struct nf_conn *ct,
-				 enum ip_conntrack_dir dir,
-				 struct nft_flowtable *ft)
-{
-	const struct dst_entry *dst = route->tuple[dir].dst;
-	struct net_device_path_stack stack;
-	struct nft_forward_info info = {};
-	unsigned char ha[ETH_ALEN];
-	int i;
-
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
-		nft_dev_path_info(&stack, &info, ha, &ft->data);
-
-	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
-		return;
-
-	route->tuple[!dir].in.ifindex = info.indev->ifindex;
-	for (i = 0; i < info.num_encaps; i++) {
-		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
-		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
-	}
-	route->tuple[!dir].in.num_encaps = info.num_encaps;
-	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
-
-	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
-		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
-		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
-		route->tuple[dir].xmit_type = info.xmit_type;
-	}
-}
-
-static int nft_flow_route(const struct nft_pktinfo *pkt,
-			  const struct nf_conn *ct,
-			  struct nf_flow_route *route,
-			  enum ip_conntrack_dir dir,
-			  struct nft_flowtable *ft)
-{
-	struct dst_entry *this_dst = skb_dst(pkt->skb);
-	struct dst_entry *other_dst = NULL;
-	struct flowi fl;
-
-	memset(&fl, 0, sizeof(fl));
-	switch (nft_pf(pkt)) {
-	case NFPROTO_IPV4:
-		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
-		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
-		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
-		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
-		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
-		fl.u.ip4.flowi4_mark = pkt->skb->mark;
-		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	case NFPROTO_IPV6:
-		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
-		fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
-		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
-		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
-		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
-		fl.u.ip6.flowi6_mark = pkt->skb->mark;
-		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	}
-
-	if (!dst_hold_safe(this_dst))
-		return -ENOENT;
-
-	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
-	if (!other_dst) {
-		dst_release(this_dst);
-		return -ENOENT;
-	}
-
-	nft_default_forward_path(route, this_dst, dir);
-	nft_default_forward_path(route, other_dst, !dir);
-
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
-	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
-		nft_dev_forward_path(route, ct, dir, ft);
-		nft_dev_forward_path(route, ct, !dir, ft);
-	}
-
-	return 0;
-}
-
 static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
 	if (skb_sec_path(skb))
-- 
2.53.0



