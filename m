Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B302F7F19;
	Sat, 12 Sep 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204814; cv=none; b=HxCyGPrrGDD9Ni0l9awvOoB13BKHXFsiKWct25ONGI7QiWSLXvFaYhsHLva1A01PlytP8Om5OpYz7w8ckiZzLXMAbWNXattQisYOyHovqeYpNuxgA2gWEs9NK2Ux/Yye6A65tm/bMiDecsbYLMl9Pph0sI8nE7531vPHq/aPfDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204814; c=relaxed/simple;
	bh=yxck2jP4JDw7y9EZJ5f++zjhsJQHh8YXHxIfB0eHIeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn4NvJPAuuAPAuwt1jlsnpx5I29oBKAyhe7/vCtRWqO5JE/UA5GygbSQLBuUIpBiR5ifJuuebkFLBLAtyU8aZcrkpRAz+WaepfpQmDFKgiLX43GDBDmRjYE++2PnLHZwHA3hDZQLPKHHdWwwQIErPzpMb4BiDrZxPKx1pq7xWhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq0dqZ97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq0dqZ97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFBA1F000FF;
	Sat, 12 Sep 2026 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204813;
	bh=0X71847eXaTfaSsqh8nmfnSKWnO8eW7H6f4TTeOWD8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tq0dqZ97AR6VkR60vvlzRsRHOZlxaCh59X8cmaxM1yJKqGxKDaN9YWAO73eWSX3n4
	 UsUjMvlZ1YMMwAlJMBhmQUcsy9pdhbfihu+hXKP84g/t1PEgd9ankQ4w3ud2PwPRnT
	 /L/feIx77CGCuTlKupWdvEgUQYEtptFTIVTd1JF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1688/1815] vxlan: fix reading neigh ha
Date: Sat, 12 Sep 2026 08:57:18 +0200
Message-ID: <20260912065728.610101119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index fbb6ddbb7f89a..44ea8499e7877 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1881,6 +1881,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
@@ -1889,8 +1890,10 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
+		neigh_ha_snapshot(ha, n, n->dev);
+
 		rcu_read_lock();
-		f = vxlan_find_mac_tx(vxlan, n->ha, vni);
+		f = vxlan_find_mac_tx(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -1902,7 +1905,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		rcu_read_unlock();
 
 		reply = arp_create(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
-				n->ha, sha);
+				   ha, sha);
 
 		neigh_release(n);
 
@@ -1935,7 +1938,8 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct sk_buff *vxlan_na_create(struct sk_buff *request,
-	struct neighbour *n, bool isrouter)
+				       struct neighbour *n, u8 *ha,
+				       bool isrouter)
 {
 	struct net_device *dev = request->dev;
 	struct sk_buff *reply;
@@ -1981,7 +1985,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	/* Ethernet header */
 	ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
-	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
+	ether_addr_copy(eth_hdr(reply)->h_source, ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
 
@@ -2010,7 +2014,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	na->icmph.icmp6_override = 1;
 	na->icmph.icmp6_solicited = 1;
 	na->target = ns->target;
-	ether_addr_copy(&na->opt[2], n->ha);
+	ether_addr_copy(&na->opt[2], ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
 	na->opt[1] = na_olen >> 3;
 
@@ -2051,6 +2055,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
@@ -2059,7 +2064,8 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac_tx(vxlan, n->ha, vni);
+		neigh_ha_snapshot(ha, n, n->dev);
+		f = vxlan_find_mac_tx(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -2068,7 +2074,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		reply = vxlan_na_create(skb, n,
+		reply = vxlan_na_create(skb, n, ha,
 					!!(f ? f->flags & NTF_ROUTER : 0));
 
 		neigh_release(n);
-- 
2.53.0



