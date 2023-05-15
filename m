Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD873101C9
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00520C433D2;
	Mon, 15 May 2023 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170984;
	bh=8JTf4oQ9cy4Rfm6uEf/QYhkVJ8UQx/V5Icc7bqmlG3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaw9gXSCIeOjkbsOuWoMd8HlrNoCHzYdO/mttr2zHJjbAm8MyTfY2viBK9lesIgRa
	 15+rzBjCwsTlDvOmjhYNAJTTX8Drx61RZtwmm39unVX9IfFaowEjyBsyQUv/gh2SNs
	 INSdGwkbpNNSveq7c8rWvz0zBCqFehg9SRywpdqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Felix Fietkau <nbd@nbd.name>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 063/242] net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging
Date: Mon, 15 May 2023 18:26:29 +0200
Message-Id: <20230515161723.794052802@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c6d96df9fa2c1d19525239d4262889cce594ce6c ]

Through testing I found out that hardware vlan rx offload support seems to
have some hardware issues. At least when using multiple MACs and when
receiving tagged packets on the secondary MAC, the hardware can sometimes
start to emit wrong tags on the first MAC as well.

In order to avoid such issues, drop the feature configuration and use
the offload feature only for DSA hardware untagging on MT7621/MT7622
devices where this feature works properly.

Fixes: 08666cbb7dd5 ("net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload")
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230426172153.8352-1-linux@fw-web.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 106 ++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |   1 -
 2 files changed, 40 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f56d4e7d4ae5d..4671d738a37c7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1870,9 +1870,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
-		bool has_hwaccel_tag = false;
 		struct net_device *netdev;
-		u16 vlan_proto, vlan_tci;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
 		int mac = 0;
@@ -2007,31 +2005,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
-					vlan_proto = RX_DMA_VPID(trxd.rxd4);
-					vlan_tci = RX_DMA_VID(trxd.rxd4);
-					has_hwaccel_tag = true;
-				}
-			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				vlan_proto = RX_DMA_VPID(trxd.rxd3);
-				vlan_tci = RX_DMA_VID(trxd.rxd3);
-				has_hwaccel_tag = true;
-			}
-		}
-
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
-		if (has_hwaccel_tag && netdev_uses_dsa(netdev)) {
-			unsigned int port = vlan_proto & GENMASK(2, 0);
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) &&
+		    (trxd.rxd2 & RX_DMA_VTAG) && netdev_uses_dsa(netdev)) {
+			unsigned int port = RX_DMA_VPID(trxd.rxd3) & GENMASK(2, 0);
 
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
 			    eth->dsa_meta[port])
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
-		} else if (has_hwaccel_tag) {
-			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
@@ -2859,29 +2842,11 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_eth *eth = mac->hw;
 	netdev_features_t diff = dev->features ^ features;
-	int i;
 
 	if ((diff & NETIF_F_LRO) && !(features & NETIF_F_LRO))
 		mtk_hwlro_netdev_disable(dev);
 
-	/* Set RX VLAN offloading */
-	if (!(diff & NETIF_F_HW_VLAN_CTAG_RX))
-		return 0;
-
-	mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX),
-		MTK_CDMP_EG_CTRL);
-
-	/* sync features with other MAC */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i] || eth->netdev[i] == dev)
-			continue;
-		eth->netdev[i]->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
-		eth->netdev[i]->features |= features & NETIF_F_HW_VLAN_CTAG_RX;
-	}
-
 	return 0;
 }
 
@@ -3184,30 +3149,6 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int i, err;
 
-	if (mtk_uses_dsa(dev) && !eth->prog) {
-		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
-			struct metadata_dst *md_dst = eth->dsa_meta[i];
-
-			if (md_dst)
-				continue;
-
-			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
-						    GFP_KERNEL);
-			if (!md_dst)
-				return -ENOMEM;
-
-			md_dst->u.port_info.port_id = i;
-			eth->dsa_meta[i] = md_dst;
-		}
-	} else {
-		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA.
-		 */
-		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
-		val &= ~MTK_CDMP_STAG_EN;
-		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
-	}
-
 	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
 	if (err) {
 		netdev_err(dev, "%s: could not attach PHY: %d\n", __func__,
@@ -3246,6 +3187,40 @@ static int mtk_open(struct net_device *dev)
 	phylink_start(mac->phylink);
 	netif_tx_start_all_queues(dev);
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return 0;
+
+	if (mtk_uses_dsa(dev) && !eth->prog) {
+		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
+			struct metadata_dst *md_dst = eth->dsa_meta[i];
+
+			if (md_dst)
+				continue;
+
+			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
+						    GFP_KERNEL);
+			if (!md_dst)
+				return -ENOMEM;
+
+			md_dst->u.port_info.port_id = i;
+			eth->dsa_meta[i] = md_dst;
+		}
+	} else {
+		/* Hardware special tag parsing needs to be disabled if at least
+		 * one MAC does not use DSA.
+		 */
+		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+
+		val &= ~MTK_CDMP_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
+
+		val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
+		val &= ~MTK_CDMQ_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMQ_IG_CTRL);
+
+		mtk_w32(eth, 0, MTK_CDMP_EG_CTRL);
+	}
+
 	return 0;
 }
 
@@ -3572,10 +3547,9 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
-	}
 
-	/* Enable RX VLan Offloading */
-	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
+		mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
+	}
 
 	/* set interrupt delays based on current Net DIM sample */
 	mtk_dim_rx(&eth->rx_dim.work);
@@ -4176,7 +4150,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
 	eth->netdev[id]->vlan_features = eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+		~NETIF_F_HW_VLAN_CTAG_TX;
 	eth->netdev[id]->features |= eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index d4b4f9eaa4419..79112bd3e952e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -48,7 +48,6 @@
 #define MTK_HW_FEATURES		(NETIF_F_IP_CSUM | \
 				 NETIF_F_RXCSUM | \
 				 NETIF_F_HW_VLAN_CTAG_TX | \
-				 NETIF_F_HW_VLAN_CTAG_RX | \
 				 NETIF_F_SG | NETIF_F_TSO | \
 				 NETIF_F_TSO6 | \
 				 NETIF_F_IPV6_CSUM |\
-- 
2.39.2



