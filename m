Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8E34F93D6;
	Tue, 13 Oct 2026 12:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894337; cv=none; b=pnvWwZ9J5ycdIlY55Ayxc7edjBLQsHDoXQharo0imRL1MO4SZXFXXH/J5qza6+SIT7Jqj3ADst4bQ7hKDMk9tnBG0h8TDsKu4sHh4NH4FM9kVT+RFzkzUSdETgxrU5p7XOzvm8VjIzEOEJq4C0o2khmtGgQ0Z8Wz965SYNGk+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894337; c=relaxed/simple;
	bh=7SuW8Rh8DYI5BtpHoICJSmhrkJWJcPG4NSMpNDOxXzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGx9t00RW7Il+e+bzYzd1LzNlqhs/xBHDrW79He1mEgBMU2Js3ER/sYvVKl0QToXKlMfgJ/xOAN43WdVeLHBSRim+JJ/qN+BwrkNmda+5IHDa0D48jl073lCCv9+1xbU37x3GYIs92FNM5mzjS1r/MCCohaLFFS3QdQLB15wzTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zeg6h0bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zeg6h0bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE31F000FF;
	Tue, 13 Oct 2026 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894335;
	bh=Orhd10FNG5jv+81+OZSqpauuE/Tr9Z82hJdXQB/kRBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zeg6h0bi8F13r5NsoafCA1F+yaUulv+RjjSGoR4K1B8EYppddk5iBL68Lap6gYpaX
	 NPJcmG3s0KWCBNXK4zP58kmux40h9CkkR2vZp25nyT6V02fh0q1ieTZdqQMLY3Lc7V
	 2et6qe2GB/4KWpDxzgLHhldV5rrV25DsUao0GnPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/621] net: stmmac: fix dma mapping leak in stmmac_tso_xmit()
Date: Tue, 13 Oct 2026 13:38:39 +0200
Message-ID: <20261013112933.256312802@linuxfoundation.org>
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
index 8fa378bd591da..63c045616c9b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4100,6 +4100,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 /**
  *  stmmac_tso_allocator - close entry point of the driver
  *  @priv: driver private structure
+ *  @entry: TX queue buffer index
  *  @des: buffer start address
  *  @total_len: total length to fill in descriptors
  *  @last_segment: condition for the last descriptor
@@ -4108,8 +4109,9 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
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
@@ -4121,14 +4123,13 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
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
@@ -4253,7 +4254,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dma_desc *desc, *first, *mss_desc = NULL;
 	struct stmmac_priv *priv = netdev_priv(dev);
-	unsigned int first_entry, tx_packets;
+	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
 	int i, first_tx, nfrags, ndesc;
 	struct stmmac_tx_queue *tx_q;
@@ -4328,22 +4329,24 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -4358,10 +4361,10 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -4371,16 +4374,17 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -4477,7 +4481,22 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
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



