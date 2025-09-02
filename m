Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6AA3081B8;
	Tue,  2 Sep 2025 13:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819463; cv=none; b=bFcxi2SkGJLvSMN1VzD+Efh6UgJPbfRMTjtbLlM3QFXn4jyUzPDcfL0Kg+JVbBWWtFE2zWuar34k1FCSrieVluoH+x3AmMjACN9HxHTyXLui/1RbdfZRwzHCHr9+hNxoH8ba991MgTCVW/iupjsnaFSBenCdPq3koF6qBD7jSiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819463; c=relaxed/simple;
	bh=E4p4Q+9gIKaVTbY3jAHX6XIf5u02e71rFpyOSWgs4qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB6wTKCvbppE6LstVLbR/Pun/T3JDURSCzqS6hEgmg6rlBbqnb1Qg5SpL/S7cMIk0cmsgYi50yKw2n0SGszCZeoI8sBI/lPOkZ1wEYj683Ncso8/x+twT/HpaV6fI82wHhquiLNQ/ecJ/apxZfC1tx7ZM/DSAG1mhLOwdA/70oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydLcQZFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydLcQZFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72987C4CEED;
	Tue,  2 Sep 2025 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819462;
	bh=E4p4Q+9gIKaVTbY3jAHX6XIf5u02e71rFpyOSWgs4qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydLcQZFt8n/kRL0bjfqPoo/g2IxaO2Od/rsv/rlj6UUaqzEVwgSUosISYh4CUmWkK
	 H7OrjTVDo+HuMS/Lxk955C2DxAumYR08SC2ImFWN9r4X6tKIGiEoWbWfeLVKGCZ+YO
	 xUkajA2j74LhEuYbB5gZahi42iJhl67uEdOUga0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 042/142] idpf: simplify and fix splitq Tx packet rollback error path
Date: Tue,  2 Sep 2025 15:19:04 +0200
Message-ID: <20250902131949.858688621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit b61dfa9bc4430ad82b96d3a7c1c485350f91b467 ]

Move (and rename) the existing rollback logic to singleq.c since that
will be the only consumer. Create a simplified splitq specific rollback
function to loop through and unmap tx_bufs based on the completion tag.
This is critical before replacing the Tx buffer ring with the buffer
pool since the previous rollback indexing will not work to unmap the
chained buffers from the pool.

Cache the next_to_use index before any portion of the packet is put on
the descriptor ring. In case of an error, the rollback will bump tail to
the correct next_to_use value. Because the splitq path now supports
different types of context descriptors (and potentially multiple in the
future), this will take care of rolling back any and all context
descriptors encoded on the ring for the erroneous packet. The previous
rollback logic was broken for PTP packets since it would not account for
the PTP context descriptor.

Fixes: 1a49cf814fe1 ("idpf: add Tx timestamp flows")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 57 +++++++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 91 ++++++++-----------
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  5 +-
 3 files changed, 95 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
index 993c354aa27ad..a3b3261bbdfa7 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -179,6 +179,58 @@ static int idpf_tx_singleq_csum(struct sk_buff *skb,
 	return 1;
 }
 
+/**
+ * idpf_tx_singleq_dma_map_error - handle TX DMA map errors
+ * @txq: queue to send buffer on
+ * @skb: send buffer
+ * @first: original first buffer info buffer for packet
+ * @idx: starting point on ring to unwind
+ */
+static void idpf_tx_singleq_dma_map_error(struct idpf_tx_queue *txq,
+					  struct sk_buff *skb,
+					  struct idpf_tx_buf *first, u16 idx)
+{
+	struct libeth_sq_napi_stats ss = { };
+	struct libeth_cq_pp cp = {
+		.dev	= txq->dev,
+		.ss	= &ss,
+	};
+
+	u64_stats_update_begin(&txq->stats_sync);
+	u64_stats_inc(&txq->q_stats.dma_map_errs);
+	u64_stats_update_end(&txq->stats_sync);
+
+	/* clear dma mappings for failed tx_buf map */
+	for (;;) {
+		struct idpf_tx_buf *tx_buf;
+
+		tx_buf = &txq->tx_buf[idx];
+		libeth_tx_complete(tx_buf, &cp);
+		if (tx_buf == first)
+			break;
+		if (idx == 0)
+			idx = txq->desc_count;
+		idx--;
+	}
+
+	if (skb_is_gso(skb)) {
+		union idpf_tx_flex_desc *tx_desc;
+
+		/* If we failed a DMA mapping for a TSO packet, we will have
+		 * used one additional descriptor for a context
+		 * descriptor. Reset that here.
+		 */
+		tx_desc = &txq->flex_tx[idx];
+		memset(tx_desc, 0, sizeof(*tx_desc));
+		if (idx == 0)
+			idx = txq->desc_count;
+		idx--;
+	}
+
+	/* Update tail in case netdev_xmit_more was previously true */
+	idpf_tx_buf_hw_update(txq, idx, false);
+}
+
 /**
  * idpf_tx_singleq_map - Build the Tx base descriptor
  * @tx_q: queue to send buffer on
@@ -219,8 +271,9 @@ static void idpf_tx_singleq_map(struct idpf_tx_queue *tx_q,
 	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
 		unsigned int max_data = IDPF_TX_MAX_DESC_DATA_ALIGNED;
 
-		if (dma_mapping_error(tx_q->dev, dma))
-			return idpf_tx_dma_map_error(tx_q, skb, first, i);
+		if (unlikely(dma_mapping_error(tx_q->dev, dma)))
+			return idpf_tx_singleq_dma_map_error(tx_q, skb,
+							     first, i);
 
 		/* record length, and DMA address */
 		dma_unmap_len_set(tx_buf, len, size);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index b26d054013354..7c758e7281ab5 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2337,57 +2337,6 @@ unsigned int idpf_tx_desc_count_required(struct idpf_tx_queue *txq,
 	return count;
 }
 
-/**
- * idpf_tx_dma_map_error - handle TX DMA map errors
- * @txq: queue to send buffer on
- * @skb: send buffer
- * @first: original first buffer info buffer for packet
- * @idx: starting point on ring to unwind
- */
-void idpf_tx_dma_map_error(struct idpf_tx_queue *txq, struct sk_buff *skb,
-			   struct idpf_tx_buf *first, u16 idx)
-{
-	struct libeth_sq_napi_stats ss = { };
-	struct libeth_cq_pp cp = {
-		.dev	= txq->dev,
-		.ss	= &ss,
-	};
-
-	u64_stats_update_begin(&txq->stats_sync);
-	u64_stats_inc(&txq->q_stats.dma_map_errs);
-	u64_stats_update_end(&txq->stats_sync);
-
-	/* clear dma mappings for failed tx_buf map */
-	for (;;) {
-		struct idpf_tx_buf *tx_buf;
-
-		tx_buf = &txq->tx_buf[idx];
-		libeth_tx_complete(tx_buf, &cp);
-		if (tx_buf == first)
-			break;
-		if (idx == 0)
-			idx = txq->desc_count;
-		idx--;
-	}
-
-	if (skb_is_gso(skb)) {
-		union idpf_tx_flex_desc *tx_desc;
-
-		/* If we failed a DMA mapping for a TSO packet, we will have
-		 * used one additional descriptor for a context
-		 * descriptor. Reset that here.
-		 */
-		tx_desc = &txq->flex_tx[idx];
-		memset(tx_desc, 0, sizeof(*tx_desc));
-		if (idx == 0)
-			idx = txq->desc_count;
-		idx--;
-	}
-
-	/* Update tail in case netdev_xmit_more was previously true */
-	idpf_tx_buf_hw_update(txq, idx, false);
-}
-
 /**
  * idpf_tx_splitq_bump_ntu - adjust NTU and generation
  * @txq: the tx ring to wrap
@@ -2436,6 +2385,37 @@ static bool idpf_tx_get_free_buf_id(struct idpf_sw_queue *refillq,
 	return true;
 }
 
+/**
+ * idpf_tx_splitq_pkt_err_unmap - Unmap buffers and bump tail in case of error
+ * @txq: Tx queue to unwind
+ * @params: pointer to splitq params struct
+ * @first: starting buffer for packet to unmap
+ */
+static void idpf_tx_splitq_pkt_err_unmap(struct idpf_tx_queue *txq,
+					 struct idpf_tx_splitq_params *params,
+					 struct idpf_tx_buf *first)
+{
+	struct libeth_sq_napi_stats ss = { };
+	struct idpf_tx_buf *tx_buf = first;
+	struct libeth_cq_pp cp = {
+		.dev    = txq->dev,
+		.ss     = &ss,
+	};
+	u32 idx = 0;
+
+	u64_stats_update_begin(&txq->stats_sync);
+	u64_stats_inc(&txq->q_stats.dma_map_errs);
+	u64_stats_update_end(&txq->stats_sync);
+
+	do {
+		libeth_tx_complete(tx_buf, &cp);
+		idpf_tx_clean_buf_ring_bump_ntc(txq, idx, tx_buf);
+	} while (idpf_tx_buf_compl_tag(tx_buf) == params->compl_tag);
+
+	/* Update tail in case netdev_xmit_more was previously true. */
+	idpf_tx_buf_hw_update(txq, params->prev_ntu, false);
+}
+
 /**
  * idpf_tx_splitq_map - Build the Tx flex descriptor
  * @tx_q: queue to send buffer on
@@ -2480,8 +2460,9 @@ static void idpf_tx_splitq_map(struct idpf_tx_queue *tx_q,
 	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
 		unsigned int max_data = IDPF_TX_MAX_DESC_DATA_ALIGNED;
 
-		if (dma_mapping_error(tx_q->dev, dma))
-			return idpf_tx_dma_map_error(tx_q, skb, first, i);
+		if (unlikely(dma_mapping_error(tx_q->dev, dma)))
+			return idpf_tx_splitq_pkt_err_unmap(tx_q, params,
+							    first);
 
 		first->nr_frags++;
 		idpf_tx_buf_compl_tag(tx_buf) = params->compl_tag;
@@ -2922,7 +2903,9 @@ static void idpf_tx_set_tstamp_desc(union idpf_flex_tx_ctx_desc *ctx_desc,
 static netdev_tx_t idpf_tx_splitq_frame(struct sk_buff *skb,
 					struct idpf_tx_queue *tx_q)
 {
-	struct idpf_tx_splitq_params tx_params = { };
+	struct idpf_tx_splitq_params tx_params = {
+		.prev_ntu = tx_q->next_to_use,
+	};
 	union idpf_flex_tx_ctx_desc *ctx_desc;
 	struct idpf_tx_buf *first;
 	unsigned int count;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 6924bee6ff5bd..c4070806be05c 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -195,6 +195,7 @@ struct idpf_tx_offload_params {
  * @compl_tag: Associated tag for completion
  * @td_tag: Descriptor tunneling tag
  * @offload: Offload parameters
+ * @prev_ntu: stored TxQ next_to_use in case of rollback
  */
 struct idpf_tx_splitq_params {
 	enum idpf_tx_desc_dtype_value dtype;
@@ -205,6 +206,8 @@ struct idpf_tx_splitq_params {
 	};
 
 	struct idpf_tx_offload_params offload;
+
+	u16 prev_ntu;
 };
 
 enum idpf_tx_ctx_desc_eipt_offload {
@@ -1039,8 +1042,6 @@ void idpf_tx_buf_hw_update(struct idpf_tx_queue *tx_q, u32 val,
 			   bool xmit_more);
 unsigned int idpf_size_to_txd_count(unsigned int size);
 netdev_tx_t idpf_tx_drop_skb(struct idpf_tx_queue *tx_q, struct sk_buff *skb);
-void idpf_tx_dma_map_error(struct idpf_tx_queue *txq, struct sk_buff *skb,
-			   struct idpf_tx_buf *first, u16 ring_idx);
 unsigned int idpf_tx_desc_count_required(struct idpf_tx_queue *txq,
 					 struct sk_buff *skb);
 void idpf_tx_timeout(struct net_device *netdev, unsigned int txqueue);
-- 
2.50.1



