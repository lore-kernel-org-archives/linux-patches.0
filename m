Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727D349AFF;
	Wed, 20 May 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299189; cv=none; b=B51vrUXQSiEwWTFhIDsud/PzIR9VpAfVibe0bRqAg+qbRnzUlq75l3gP3H5CC7Xv/hl6FcKdr8Zh2k8nPIAARYgFBCP+z0DOFE67v3pV2L+Z2X5zrZ1X5NnDZ/uo90b+b4UEB56ThVnGgth4DomClfeZSNAjlI68IHG2XyRDxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299189; c=relaxed/simple;
	bh=NXQzTl2SmRJpZBAzXvWFqzB39aOnwSV62RLytGIwGFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9xmE5CMzmhuyI8HP32QSllZF/VkMMOfM9eY+WX/lYSt7JlZpN6Vysl46d3vaF+/A8EYJVM/LAO024UADwtrlF4kAjdbkIuJtStiJllTbewsbCx3oVgvopV4ZRGpyawNLAnl/57QY/T8D87HqKlQSWUzSB2ITzk49uHBZ4Kwvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJZyFflK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJZyFflK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA95E1F000E9;
	Wed, 20 May 2026 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299188;
	bh=LauGtPk/E5xq9EtBm90rNWQ+Pykq1H953yGGXfi8/oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJZyFflKhrFKH9aVH3aEHJIua/ArOba6f7pYlSfzHZoKURlENNSTP+UC3FetiEBsQ
	 sXkEfVutZuqjpI0tN8b/o6VUwfwT2mPB2vTX5GP7MK6lTgG7Gh+tR66qs+MCisR6eZ
	 6j3xSLIyz4IyF5uTbiRg3x3+H7UyJqYSylv96kSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuegang Lu <xuegang.lu@airoha.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 695/957] net: airoha: Add the capability to consume out-of-order DMA tx descriptors
Date: Wed, 20 May 2026 18:19:38 +0200
Message-ID: <20260520162149.612318752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3f47e67dff1f7266e112c50313d63824f6f17102 ]

EN7581 and AN7583 SoCs are capable of DMA mapping non-linear tx skbs on
non-consecutive DMA descriptors. This feature is useful when multiple
flows are queued on the same hw tx queue since it allows to fully utilize
the available tx DMA descriptors and to avoid the starvation of
high-priority flow we have in the current codebase due to head-of-line
blocking introduced by low-priority flows.

Tested-by: Xuegang Lu <xuegang.lu@airoha.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106-airoha-tx-linked-list-v2-1-0706d4a322bd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3309965fe44c ("net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 85 +++++++++++-------------
 drivers/net/ethernet/airoha/airoha_eth.h |  7 +-
 2 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 55de295e3acf2..9f6f517b5fdf9 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -952,19 +952,13 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 
 		dma_unmap_single(eth->dev, e->dma_addr, e->dma_len,
 				 DMA_TO_DEVICE);
-		memset(e, 0, sizeof(*e));
+		e->dma_addr = 0;
+		list_add_tail(&e->list, &q->tx_list);
+
 		WRITE_ONCE(desc->msg0, 0);
 		WRITE_ONCE(desc->msg1, 0);
 		q->queued--;
 
-		/* completion ring can report out-of-order indexes if hw QoS
-		 * is enabled and packets with different priority are queued
-		 * to same DMA ring. Take into account possible out-of-order
-		 * reports incrementing DMA ring tail pointer
-		 */
-		while (q->tail != q->head && !q->entry[q->tail].dma_addr)
-			q->tail = (q->tail + 1) % q->ndesc;
-
 		if (skb) {
 			u16 queue = skb_get_queue_mapping(skb);
 			struct netdev_queue *txq;
@@ -1018,6 +1012,7 @@ static int airoha_qdma_init_tx_queue(struct airoha_queue *q,
 	q->ndesc = size;
 	q->qdma = qdma;
 	q->free_thr = 1 + MAX_SKB_FRAGS;
+	INIT_LIST_HEAD(&q->tx_list);
 
 	q->entry = devm_kzalloc(eth->dev, q->ndesc * sizeof(*q->entry),
 				GFP_KERNEL);
@@ -1030,9 +1025,9 @@ static int airoha_qdma_init_tx_queue(struct airoha_queue *q,
 		return -ENOMEM;
 
 	for (i = 0; i < q->ndesc; i++) {
-		u32 val;
+		u32 val = FIELD_PREP(QDMA_DESC_DONE_MASK, 1);
 
-		val = FIELD_PREP(QDMA_DESC_DONE_MASK, 1);
+		list_add_tail(&q->entry[i].list, &q->tx_list);
 		WRITE_ONCE(q->desc[i].ctrl, cpu_to_le32(val));
 	}
 
@@ -1042,9 +1037,9 @@ static int airoha_qdma_init_tx_queue(struct airoha_queue *q,
 
 	airoha_qdma_wr(qdma, REG_TX_RING_BASE(qid), dma_addr);
 	airoha_qdma_rmw(qdma, REG_TX_CPU_IDX(qid), TX_RING_CPU_IDX_MASK,
-			FIELD_PREP(TX_RING_CPU_IDX_MASK, q->head));
+			FIELD_PREP(TX_RING_CPU_IDX_MASK, 0));
 	airoha_qdma_rmw(qdma, REG_TX_DMA_IDX(qid), TX_RING_DMA_IDX_MASK,
-			FIELD_PREP(TX_RING_DMA_IDX_MASK, q->head));
+			FIELD_PREP(TX_RING_DMA_IDX_MASK, 0));
 
 	return 0;
 }
@@ -1100,17 +1095,21 @@ static int airoha_qdma_init_tx(struct airoha_qdma *qdma)
 static void airoha_qdma_cleanup_tx_queue(struct airoha_queue *q)
 {
 	struct airoha_eth *eth = q->qdma->eth;
+	int i;
 
 	spin_lock_bh(&q->lock);
-	while (q->queued) {
-		struct airoha_queue_entry *e = &q->entry[q->tail];
+	for (i = 0; i < q->ndesc; i++) {
+		struct airoha_queue_entry *e = &q->entry[i];
+
+		if (!e->dma_addr)
+			continue;
 
 		dma_unmap_single(eth->dev, e->dma_addr, e->dma_len,
 				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(e->skb);
+		e->dma_addr = 0;
 		e->skb = NULL;
-
-		q->tail = (q->tail + 1) % q->ndesc;
+		list_add_tail(&e->list, &q->tx_list);
 		q->queued--;
 	}
 	spin_unlock_bh(&q->lock);
@@ -1939,20 +1938,6 @@ static u32 airoha_get_dsa_tag(struct sk_buff *skb, struct net_device *dev)
 #endif
 }
 
-static bool airoha_dev_tx_queue_busy(struct airoha_queue *q, u32 nr_frags)
-{
-	u32 tail = q->tail <= q->head ? q->tail + q->ndesc : q->tail;
-	u32 index = q->head + nr_frags;
-
-	/* completion napi can free out-of-order tx descriptors if hw QoS is
-	 * enabled and packets with different priorities are queued to the same
-	 * DMA ring. Take into account possible out-of-order reports checking
-	 * if the tx queue is full using circular buffer head/tail pointers
-	 * instead of the number of queued packets.
-	 */
-	return index >= tail;
-}
-
 static int airoha_get_fe_port(struct airoha_gdm_port *port)
 {
 	struct airoha_qdma *qdma = port->qdma;
@@ -1975,8 +1960,10 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	struct airoha_gdm_port *port = netdev_priv(dev);
 	struct airoha_qdma *qdma = port->qdma;
 	u32 nr_frags, tag, msg0, msg1, len;
+	struct airoha_queue_entry *e;
 	struct netdev_queue *txq;
 	struct airoha_queue *q;
+	LIST_HEAD(tx_list);
 	void *data;
 	int i, qid;
 	u16 index;
@@ -2022,7 +2009,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	txq = netdev_get_tx_queue(dev, qid);
 	nr_frags = 1 + skb_shinfo(skb)->nr_frags;
 
-	if (airoha_dev_tx_queue_busy(q, nr_frags)) {
+	if (q->queued + nr_frags >= q->ndesc) {
 		/* not enough space in the queue */
 		netif_tx_stop_queue(txq);
 		q->txq_stopped = true;
@@ -2032,11 +2019,13 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 
 	len = skb_headlen(skb);
 	data = skb->data;
-	index = q->head;
+
+	e = list_first_entry(&q->tx_list, struct airoha_queue_entry,
+			     list);
+	index = e - q->entry;
 
 	for (i = 0; i < nr_frags; i++) {
 		struct airoha_qdma_desc *desc = &q->desc[index];
-		struct airoha_queue_entry *e = &q->entry[index];
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		dma_addr_t addr;
 		u32 val;
@@ -2046,7 +2035,14 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 		if (unlikely(dma_mapping_error(dev->dev.parent, addr)))
 			goto error_unmap;
 
-		index = (index + 1) % q->ndesc;
+		list_move_tail(&e->list, &tx_list);
+		e->skb = i ? NULL : skb;
+		e->dma_addr = addr;
+		e->dma_len = len;
+
+		e = list_first_entry(&q->tx_list, struct airoha_queue_entry,
+				     list);
+		index = e - q->entry;
 
 		val = FIELD_PREP(QDMA_DESC_LEN_MASK, len);
 		if (i < nr_frags - 1)
@@ -2059,15 +2055,9 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 		WRITE_ONCE(desc->msg1, cpu_to_le32(msg1));
 		WRITE_ONCE(desc->msg2, cpu_to_le32(0xffff));
 
-		e->skb = i ? NULL : skb;
-		e->dma_addr = addr;
-		e->dma_len = len;
-
 		data = skb_frag_address(frag);
 		len = skb_frag_size(frag);
 	}
-
-	q->head = index;
 	q->queued += i;
 
 	skb_tx_timestamp(skb);
@@ -2076,7 +2066,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	if (netif_xmit_stopped(txq) || !netdev_xmit_more())
 		airoha_qdma_rmw(qdma, REG_TX_CPU_IDX(qid),
 				TX_RING_CPU_IDX_MASK,
-				FIELD_PREP(TX_RING_CPU_IDX_MASK, q->head));
+				FIELD_PREP(TX_RING_CPU_IDX_MASK, index));
 
 	if (q->ndesc - q->queued < q->free_thr) {
 		netif_tx_stop_queue(txq);
@@ -2088,10 +2078,13 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 error_unmap:
-	for (i--; i >= 0; i--) {
-		index = (q->head + i) % q->ndesc;
-		dma_unmap_single(dev->dev.parent, q->entry[index].dma_addr,
-				 q->entry[index].dma_len, DMA_TO_DEVICE);
+	while (!list_empty(&tx_list)) {
+		e = list_first_entry(&tx_list, struct airoha_queue_entry,
+				     list);
+		dma_unmap_single(dev->dev.parent, e->dma_addr, e->dma_len,
+				 DMA_TO_DEVICE);
+		e->dma_addr = 0;
+		list_move_tail(&e->list, &q->tx_list);
 	}
 
 	spin_unlock_bh(&q->lock);
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 203e6ce29dbe0..28dfa35a3abed 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -169,7 +169,10 @@ enum trtcm_param {
 struct airoha_queue_entry {
 	union {
 		void *buf;
-		struct sk_buff *skb;
+		struct {
+			struct list_head list;
+			struct sk_buff *skb;
+		};
 	};
 	dma_addr_t dma_addr;
 	u16 dma_len;
@@ -194,6 +197,8 @@ struct airoha_queue {
 	struct napi_struct napi;
 	struct page_pool *page_pool;
 	struct sk_buff *skb;
+
+	struct list_head tx_list;
 };
 
 struct airoha_tx_irq_queue {
-- 
2.53.0



