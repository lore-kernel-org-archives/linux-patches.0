Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957CA47CA9C;
	Thu, 20 Aug 2026 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247135; cv=none; b=S0lShYH13J5mHvnk7Yde7bogfPsyAr7telQjiuBQHnQ+6nJg35h3G4XhGOAqFnzEZDANWrebixHElAF8SyGOKZibsmpkE5ZSleJv8ueFbvvCCdvccnS9ezkDaAnAK1ry+UxK5Mgwqgb3DqvJXlMsKH+phlU5e0Ji/Pm5HLHKH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247135; c=relaxed/simple;
	bh=4PRJD9eX2VQsdiMdCiChcLiJchBiyRzPlVSJsvuY8M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0YJQ6sw0WTpvXwnHB53aXQY4TI21N+HC24c40Cw3UVNsBbESsPB2xTir0lbH5G1jPEeo3jNpq9V3Yzjh5g+uzDLXlGinuvMTE7cHeghLN80sFO6MZfr1QWi1RdMt3rs+Zy5o7OVd5Afq1LWeqW9qWlU0wCNk8Gv02R/l82y2tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0IohITd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0IohITd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C761F000E9;
	Thu, 20 Aug 2026 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247134;
	bh=WHyJyIWngB0LYjuRm1igzfgiPVwhixAfh9QOZ26z8nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0IohITdCFtHpU6k3X7r7ASYSP6Kzi8vLvRv49YdSRSPSdWvNrXEswHdgekoUy23l
	 OvNJdSXc8opupCo9zHF0/jMGJUTGL4XowKqHPWqC/J8kDpWzpUBMhPm9vwBybzD3Pw
	 +lgyZne2aN8mnOnqX4EdLi8OZH/1qDrkVU5uHd1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/220] vxlan: Handle stats using NETDEV_PCPU_STAT_DSTATS.
Date: Thu, 20 Aug 2026 16:55:51 +0200
Message-ID: <20260820145228.313175560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit be226352e8dc77d3313c096b2d8e7f69bf6980fc ]

VXLAN uses the TSTATS infrastructure (dev_sw_netstats_*()) for RX and
TX packet counters. It also uses the device core stats
(dev_core_stats_*()) for RX and TX drops.

Let's consolidate that using the DSTATS infrastructure, which can
handle both packet counters and packet drops. Statistics that don't
fit DSTATS are still updated atomically with DEV_STATS_INC().

While there, convert the "len" variable of vxlan_encap_bypass() to
unsigned int, to respect the types of skb->len and
dev_dstats_[rt]x_add().

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/145558b184b3cda77911ca5682b6eb83c3ffed8e.1733313925.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b9553558b48d ("vxlan: use pskb_network_may_pull() for transmit path header pulls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1814,14 +1814,14 @@ static int vxlan_rcv(struct sock *sk, st
 
 	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
 		rcu_read_unlock();
-		dev_core_stats_rx_dropped_inc(vxlan->dev);
+		dev_dstats_rx_dropped(vxlan->dev);
 		vxlan_vnifilter_count(vxlan, vni, vninode,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 		reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
 	}
 
-	dev_sw_netstats_rx_add(vxlan->dev, skb->len);
+	dev_dstats_rx_add(vxlan->dev, skb->len);
 	vxlan_vnifilter_count(vxlan, vni, vninode, VXLAN_VNI_STATS_RX, skb->len);
 	gro_cells_receive(&vxlan->gro_cells, skb);
 
@@ -1876,7 +1876,7 @@ static int arp_reduce(struct net_device
 		goto out;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
-		dev_core_stats_tx_dropped_inc(dev);
+		dev_dstats_tx_dropped(dev);
 		vxlan_vnifilter_count(vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_TX_DROPS, 0);
 		goto out;
@@ -1940,7 +1940,7 @@ static int arp_reduce(struct net_device
 		reply->pkt_type = PACKET_HOST;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev_core_stats_rx_dropped_inc(dev);
+			dev_dstats_rx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2104,7 +2104,7 @@ static int neigh_reduce(struct net_devic
 			goto out;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev_core_stats_rx_dropped_inc(dev);
+			dev_dstats_rx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2289,8 +2289,8 @@ static void vxlan_encap_bypass(struct sk
 {
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	unsigned int len = skb->len;
 	struct net_device *dev;
-	int len = skb->len;
 
 	skb->pkt_type = PACKET_HOST;
 	skb->encapsulation = 0;
@@ -2317,16 +2317,16 @@ static void vxlan_encap_bypass(struct sk
 	if ((dst_vxlan->cfg.flags & VXLAN_F_LEARN) && snoop)
 		vxlan_snoop(dev, &loopback, eth_hdr(skb)->h_source, 0, vni);
 
-	dev_sw_netstats_tx_add(src_vxlan->dev, 1, len);
+	dev_dstats_tx_add(src_vxlan->dev, len);
 	vxlan_vnifilter_count(src_vxlan, vni, NULL, VXLAN_VNI_STATS_TX, len);
 
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
-		dev_sw_netstats_rx_add(dst_vxlan->dev, len);
+		dev_dstats_rx_add(dst_vxlan->dev, len);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL, VXLAN_VNI_STATS_RX,
 				      len);
 	} else {
 drop:
-		dev_core_stats_rx_dropped_inc(dev);
+		dev_dstats_rx_dropped(dev);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 	}
@@ -2630,7 +2630,7 @@ out_unlock:
 	return;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 	return;
@@ -2671,7 +2671,7 @@ static void vxlan_xmit_nh(struct sk_buff
 	return;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2709,7 +2709,7 @@ static netdev_tx_t vxlan_xmit_nhid(struc
 	return NETDEV_TX_OK;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2808,7 +2808,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 			    !is_multicast_ether_addr(eth->h_dest))
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
-			dev_core_stats_tx_dropped_inc(dev);
+			dev_dstats_tx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
@@ -3383,7 +3383,7 @@ static void vxlan_setup(struct net_devic
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
+	dev->pcpu_stat_type = NETDEV_PCPU_STAT_DSTATS;
 	INIT_LIST_HEAD(&vxlan->next);
 
 	timer_setup(&vxlan->age_timer, vxlan_cleanup, TIMER_DEFERRABLE);


