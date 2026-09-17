Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CA556B8B;
	Thu, 17 Sep 2026 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658843; cv=none; b=FExn0R0FcOrcFeSPTmVgev3C4Wb5YxwHm+/ojJGfxDrRi3d0Jq5hiNZ8hZvdQtYy3Q42Rvn3dcf60cy11pHb4Enc2Y52XlY6O5nd6UWCKsY4/EVpvanHnnC+5/b9L63cWfXtDtVcaUGQdTgMCqpGCEcnrMzdp6PdSxQ8qoSucgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658843; c=relaxed/simple;
	bh=1mCngvLazbweyPgmh6u6xJZNA8po5Q7n9dq3lq9Hed0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLx8Z/+JUzi1ywMDV3NnFg21CT/Qbqk7l7plz7QbTfMNz69OxJP3IQO2GH6mEnyOzv65CJ+bt1KY5/aOhQXAIeSewkF3yuTXH7XAjVqPoMyQDINsQy7gHpBUr4URpti9W5+cU3kPk0TozzI2lb86+ZAZ7YxSyU3IzLnR1bV7UF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSjUesyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSjUesyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CDA1F00898;
	Thu, 17 Sep 2026 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658829;
	bh=SzFaqTxE97QjQmvyhby46puCyLsdbbf+6cb5Hoxq7lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSjUesyrGaKNdODEoGX4krc1tbqk8+S7Ptn7/uvXG6nKdNQHkaOqVSRqeQ8T92YoI
	 KsH4xQ3aID77RXoK8E0bmyva6FiAvRKh60xGssOcp5SGNwi2fy8cCpwGuE42g7XiW2
	 tLXYTu+Fc4qEK7wzsP0n/sxJa0by9jdeWglEUjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 054/733] net: stmmac: fix dma mapping leak in stmmac_tso_xmit()
Date: Thu, 17 Sep 2026 16:06:02 +0100
Message-ID: <20260917151352.142033974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 53 ++++++++++++-------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3a437409f78ae..1946361081fc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4319,6 +4319,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 /**
  *  stmmac_tso_allocator - close entry point of the driver
  *  @priv: driver private structure
+ *  @entry: TX queue buffer index
  *  @des: buffer start address
  *  @total_len: total length to fill in descriptors
  *  @last_segment: condition for the last descriptor
@@ -4327,8 +4328,9 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
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
@@ -4340,14 +4342,13 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
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
@@ -4486,7 +4487,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dma_desc *desc, *first, *mss_desc = NULL;
 	struct stmmac_priv *priv = netdev_priv(dev);
-	unsigned int first_entry, tx_packets;
+	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
 	struct stmmac_tx_queue *tx_q;
 	bool set_ic, is_last_segment;
@@ -4549,22 +4550,24 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -4579,8 +4582,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * this DMA buffer right after the DMA engine completely finishes the
 	 * full buffer transmission.
 	 */
-	stmmac_set_tx_skb_dma_entry(tx_q, tx_q->cur_tx, des, skb_headlen(skb),
-				    false);
+	stmmac_set_tx_skb_dma_entry(tx_q, entry, des, skb_headlen(skb), false);
 
 	/* Prepare fragments */
 	for (i = 0; i < nfrags; i++) {
@@ -4590,14 +4592,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 				       skb_frag_size(frag),
 				       DMA_TO_DEVICE);
 		if (dma_mapping_error(priv->device, des))
-			goto dma_map_err;
+			goto error_dma_unmap;
 
-		stmmac_tso_allocator(priv, des, skb_frag_size(frag),
+		stmmac_tso_allocator(priv, &entry, des, skb_frag_size(frag),
 				     (i == nfrags - 1), queue);
 
-		stmmac_set_tx_skb_dma_entry(tx_q, tx_q->cur_tx, des,
+		stmmac_set_tx_skb_dma_entry(tx_q, entry, des,
 					    skb_frag_size(frag), true);
 	}
+	tx_q->cur_tx = entry;
 
 	stmmac_set_tx_dma_last_segment(tx_q, tx_q->cur_tx);
 
@@ -4700,7 +4703,19 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	return NETDEV_TX_OK;
 
-dma_map_err:
+error_dma_unmap:
+	for (;;) {
+		desc = stmmac_get_tx_desc(priv, tx_q, first_entry);
+		stmmac_release_tx_desc(priv, desc, priv->descriptor_mode);
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



