Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686F3AFAE3;
	Sat, 17 Oct 2026 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255633; cv=none; b=J0dhtyZ197W60sBLA/73besl5n2Kp6sIoPcYa5GjHulfkOAAJB0T9qgM7Wlqx3lIHoF2NiJMN9WH91p1t4Rn81/3/SK5r00jNqPLsDKBLzWgSSuO/Xt4H4KlTnj4HoiEpi0DPHL2ihD6vyc4b1GosUo77VO0B88vv62IUuIfk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255633; c=relaxed/simple;
	bh=yZc5DrwjSaiptEETM9lARjAcAWTeCbsxoiQsxASSSfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr+r1xQhhFPZzrXmoPfnTDMbDKKym32YXEIT4javt8mHm8IZCFL14KK1vVEdPMNEW9Vn6f5rVJUXgyTag0W/KaCraE3WlIP0F9glQEbqUXwr7f7SLv/qQLrkAx6Q//byfew9RMyNi6cnVIqub4qM4maLtNU4ALyZ5JTm+5ArGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p625NDf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p625NDf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE6D1F000C4;
	Sat, 17 Oct 2026 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255631;
	bh=MYRHkvnar6/LmK4Z/nWh7riSayCq43iABLL8Hyxitl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p625NDf7iO5ikBaowlaInHgSxLuqrZx5AvqPOfpTyWDUAQ8K5p9OqL1xVaCWMsAkF
	 nUy4+cpADBj4CBfPxRC9hs0CHFBQhDGOgK2brijj2OD93SFB8I13pMhKuRXpZ2YMsR
	 +Po7obmUQqkiFI31i26Dwnj6suItN78CbgLnx2OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 797/869] net: stmmac: fix dma mapping leak in stmmac_tso_xmit()
Date: Sat, 17 Oct 2026 18:00:38 +0200
Message-ID: <20261017160057.337598103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit a5d946466a95621fa2769720d59ea336003aa1a5 ]

In stmmac_tso_xmit(), if the DMA mapping of an skb fragment fails, the
frame is dropped but the DMA mappings already created for the linear
part and for the fragments mapped before the failure are never
unmapped, leaking DMA mappings.

Fix the leak by walking back over the descriptors used by the frame and
releasing each of them with stmmac_free_tx_buffer(). Moreover, release
the descriptors with stmmac_release_tx_desc() unmapping the DMA buffers.

Fixes: f748be531d70 ("stmmac: support new GMAC4")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260826-stmmac_dma_unmap_tso-v1-1-a2753d1576ba@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 67 ++++++++++++-------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73f079a7cb537..057d23c8d8906 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4087,6 +4087,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 /**
  *  stmmac_tso_allocator - close entry point of the driver
  *  @priv: driver private structure
+ *  @entry: TX queue buffer index
  *  @des: buffer start address
  *  @total_len: total length to fill in descriptors
  *  @last_segment: condition for the last descriptor
@@ -4095,8 +4096,9 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
  *  This function fills descriptor and request new descriptors according to
  *  buffer length to fill
  */
-static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
-				 int total_len, bool last_segment, u32 queue)
+static void stmmac_tso_allocator(struct stmmac_priv *priv, u32 *entry,
+				 dma_addr_t des, int total_len,
+				 bool last_segment, u32 queue)
 {
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct dma_desc *desc;
@@ -4108,14 +4110,13 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 	while (tmp_len > 0) {
 		dma_addr_t curr_addr;
 
-		tx_q->cur_tx = STMMAC_NEXT_ENTRY(tx_q->cur_tx,
-						priv->dma_conf.dma_tx_size);
-		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
+		*entry = STMMAC_NEXT_ENTRY(*entry, priv->dma_conf.dma_tx_size);
+		WARN_ON(tx_q->tx_skbuff[*entry]);
 
 		if (tx_q->tbs & STMMAC_TBS_AVAIL)
-			desc = &tx_q->dma_entx[tx_q->cur_tx].basic;
+			desc = &tx_q->dma_entx[*entry].basic;
 		else
-			desc = &tx_q->dma_tx[tx_q->cur_tx];
+			desc = &tx_q->dma_tx[*entry];
 
 		curr_addr = des + (total_len - tmp_len);
 		stmmac_set_desc_addr(priv, desc, curr_addr);
@@ -4240,7 +4241,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dma_desc *desc, *first, *mss_desc = NULL;
 	struct stmmac_priv *priv = netdev_priv(dev);
-	unsigned int first_entry, tx_packets;
+	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
 	int i, first_tx, nfrags, ndesc;
 	struct stmmac_tx_queue *tx_q;
@@ -4315,22 +4316,24 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	first_entry = tx_q->cur_tx;
-	WARN_ON(tx_q->tx_skbuff[first_entry]);
+	entry = first_entry;
+
+	WARN_ON(tx_q->tx_skbuff[entry]);
 
 	if (tx_q->tbs & STMMAC_TBS_AVAIL)
-		desc = &tx_q->dma_entx[first_entry].basic;
+		desc = &tx_q->dma_entx[entry].basic;
 	else
-		desc = &tx_q->dma_tx[first_entry];
+		desc = &tx_q->dma_tx[entry];
 	first = desc;
 
 	/* first descriptor: fill Headers on Buf1 */
 	des = dma_map_single(priv->device, skb->data, skb_headlen(skb),
 			     DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->device, des))
-		goto dma_map_err;
+		goto error;
 
 	stmmac_set_desc_addr(priv, first, des);
-	stmmac_tso_allocator(priv, des + proto_hdr_len, pay_len,
+	stmmac_tso_allocator(priv, &entry, des + proto_hdr_len, pay_len,
 			     (nfrags == 0), queue);
 
 	/* In case two or more DMA transmit descriptors are allocated for this
@@ -4345,10 +4348,10 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * this DMA buffer right after the DMA engine completely finishes the
 	 * full buffer transmission.
 	 */
-	tx_q->tx_skbuff_dma[tx_q->cur_tx].buf = des;
-	tx_q->tx_skbuff_dma[tx_q->cur_tx].len = skb_headlen(skb);
-	tx_q->tx_skbuff_dma[tx_q->cur_tx].map_as_page = false;
-	tx_q->tx_skbuff_dma[tx_q->cur_tx].buf_type = STMMAC_TXBUF_T_SKB;
+	tx_q->tx_skbuff_dma[entry].buf = des;
+	tx_q->tx_skbuff_dma[entry].len = skb_headlen(skb);
+	tx_q->tx_skbuff_dma[entry].map_as_page = false;
+	tx_q->tx_skbuff_dma[entry].buf_type = STMMAC_TXBUF_T_SKB;
 
 	/* Prepare fragments */
 	for (i = 0; i < nfrags; i++) {
@@ -4358,16 +4361,17 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 				       skb_frag_size(frag),
 				       DMA_TO_DEVICE);
 		if (dma_mapping_error(priv->device, des))
-			goto dma_map_err;
+			goto error_dma_unmap;
 
-		stmmac_tso_allocator(priv, des, skb_frag_size(frag),
+		stmmac_tso_allocator(priv, &entry, des, skb_frag_size(frag),
 				     (i == nfrags - 1), queue);
 
-		tx_q->tx_skbuff_dma[tx_q->cur_tx].buf = des;
-		tx_q->tx_skbuff_dma[tx_q->cur_tx].len = skb_frag_size(frag);
-		tx_q->tx_skbuff_dma[tx_q->cur_tx].map_as_page = true;
-		tx_q->tx_skbuff_dma[tx_q->cur_tx].buf_type = STMMAC_TXBUF_T_SKB;
+		tx_q->tx_skbuff_dma[entry].buf = des;
+		tx_q->tx_skbuff_dma[entry].len = skb_frag_size(frag);
+		tx_q->tx_skbuff_dma[entry].map_as_page = true;
+		tx_q->tx_skbuff_dma[entry].buf_type = STMMAC_TXBUF_T_SKB;
 	}
+	tx_q->cur_tx = entry;
 
 	tx_q->tx_skbuff_dma[tx_q->cur_tx].last_segment = true;
 
@@ -4464,7 +4468,22 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	return NETDEV_TX_OK;
 
-dma_map_err:
+error_dma_unmap:
+	for (;;) {
+		if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			desc = &tx_q->dma_entx[first_entry].basic;
+		else
+			desc = &tx_q->dma_tx[first_entry];
+		stmmac_release_tx_desc(priv, desc, priv->mode);
+		stmmac_free_tx_buffer(priv, &priv->dma_conf, queue,
+				      first_entry);
+		if (first_entry == entry)
+			break;
+
+		first_entry = STMMAC_NEXT_ENTRY(first_entry,
+						priv->dma_conf.dma_tx_size);
+	}
+error:
 	dev_err(priv->device, "Tx dma map failed\n");
 	dev_kfree_skb(skb);
 	priv->xstats.tx_dropped++;
-- 
2.53.0



