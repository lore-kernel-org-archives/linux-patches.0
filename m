Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF61C3A6F00;
	Sat, 17 Oct 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259940; cv=none; b=u/9V2Bbp1Lyc+ZEJqxYVJZ8iaJZh4l7tIULyNQqTyONuNuS6eVwM6FIq+DWUPjQTI7mEUtzsBeGR+Fy0Xjjrx0Qd8ny6Asf9E3dLcmTKFQHgLI2lS+jvRFBOJ/hfbpeTuCLdI301YfXYfuv3rx1yy/HrhSr3uPBfSPlOuD4x2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259940; c=relaxed/simple;
	bh=EpIKm9jCwrB3Df6N5IEyr0ic0CYxPFO9OlgtCK+TARg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHWdmzWuUcraW8ItyxI1OOshWxXiGtyKTG4i6ffIn3ZnOgZmAVbvyo71s8Pnax+7cbKRyW+34DKMypRGJo6IcCQZHOmsiSjfslvg1PoyZNUUOdShdWbhSXL4zuyOX4+ohX4E17+u04LItIJ9iqXALKXcH1PCKKjZU4qujX5oQIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3BHgApM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3BHgApM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA62B1F000C4;
	Sat, 17 Oct 2026 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259939;
	bh=5cWJSZp63PdLP+Ne79fJMm0zIuD33VZafFg4wAanPII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3BHgApM+eWuSIun9kE9WUhFgnWWd+sTxmL0t8MUxFEPCmAYQIgwlT/8yimI/Nf2U
	 dDSzLtFiOX+AWlN163pXfqjn69o+y9ARyFVT9PTqFu2U5IfU8P44233CojIHTfanUI
	 XIPSLsyC5UJp/QrhrZsZzWrBXgvt+0lnR4IB49CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1381/1674] vxlan: fix reading neigh ha
Date: Sat, 17 Oct 2026 18:00:53 +0200
Message-ID: <20261017160506.612026164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit b824059a673b2283e78c7aae2c7d257aad7f0e1d ]

Currently arp/neigh_reduce read neigh ha directly which can lead to
partial reads while the neigh is being updated. Use neigh_ha_snapshot to
take a stable snapshot of the address similar to route_shortcircuit which
already does the right thing.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260818150756.890025-3-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index fd7859f72a124..93940ea5cf9c8 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1899,6 +1899,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
@@ -1907,7 +1908,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		neigh_ha_snapshot(ha, n, n->dev);
+
+		f = vxlan_find_mac(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -1917,7 +1920,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		reply = arp_create(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
-				n->ha, sha);
+				   ha, sha);
 
 		neigh_release(n);
 
@@ -1950,7 +1953,8 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct sk_buff *vxlan_na_create(struct sk_buff *request,
-	struct neighbour *n, bool isrouter)
+				       struct neighbour *n, u8 *ha,
+				       bool isrouter)
 {
 	struct net_device *dev = request->dev;
 	struct sk_buff *reply;
@@ -1998,7 +2002,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	/* Ethernet header */
 	ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
-	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
+	ether_addr_copy(eth_hdr(reply)->h_source, ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
 
@@ -2027,7 +2031,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	na->icmph.icmp6_override = 1;
 	na->icmph.icmp6_solicited = 1;
 	na->target = ns->target;
-	ether_addr_copy(&na->opt[2], n->ha);
+	ether_addr_copy(&na->opt[2], ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
 	na->opt[1] = na_olen >> 3;
 
@@ -2070,6 +2074,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
@@ -2078,7 +2083,8 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		neigh_ha_snapshot(ha, n, n->dev);
+		f = vxlan_find_mac(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -2087,7 +2093,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		reply = vxlan_na_create(skb, n,
+		reply = vxlan_na_create(skb, n, ha,
 					!!(f ? f->flags & NTF_ROUTER : 0));
 
 		neigh_release(n);
-- 
2.53.0



