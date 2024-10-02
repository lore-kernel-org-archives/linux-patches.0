Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6D1D0164;
	Wed,  2 Oct 2024 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876957; cv=none; b=EtsCmlslol/nDGtl4NPfgtZR7Byc77GuaEa9+fsTdqDquNSSYJ0OGjuhOENO8x+5/W7YLk9ckKzZfO6AzuT72lHxNk2AOSOlofCzygXAGPXu5hbQeKPeICFDZBkakz0boTj09X412j6iTCy88Ry5SFTiKPAzvHV7FJP5f1MoMdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876957; c=relaxed/simple;
	bh=VxWWHEzaBAt68IJE3cV11H3J8LdZi0eMj2P9GmUgMTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj88T7xtY1t1bmOH79YDA4Wztfx0HsbRnEs+NWLUCJsPmdrdEcovL+yZYG6QK/8JYLttErgrZbQB6ANxWnQiimnCD2Ttyk0EG2Tf83S6BhrBOruBgCn2KTx03nw0YwczO3KKcIlDv3egMmaHFakwaNr6sPkxD7MHrVvUBRPqkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfAeS5am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfAeS5am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6E3C4CEC2;
	Wed,  2 Oct 2024 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876957;
	bh=VxWWHEzaBAt68IJE3cV11H3J8LdZi0eMj2P9GmUgMTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfAeS5amLj3KZtdqjo3oLYpnyOOM48BmRUTgqzaINUb6pEMMqKq7Ut7cHNjwcD6XI
	 LHXvOjMdM2i4TmBX2hl3xYoFvQkm/xYieQau7AUksjjb14R+7oxzqStWvgjYp/ruLp
	 ZF1Q9pTQSlGbVMyLV1BUjmj+FiekbIayWz351+5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.11 617/695] idpf: fix netdev Tx queue stop/wake
Date: Wed,  2 Oct 2024 15:00:15 +0200
Message-ID: <20241002125847.141501536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubiak <michal.kubiak@intel.com>

commit e4b398dd82f5d5867bc5f442c43abc8fba30ed2c upstream.

netif_txq_maybe_stop() returns -1, 0, or 1, while
idpf_tx_maybe_stop_common() says it returns 0 or -EBUSY. As a result,
there sometimes are Tx queue timeout warnings despite that the queue
is empty or there is at least enough space to restart it.
Make idpf_tx_maybe_stop_common() inline and returning true or false,
handling the return of netif_txq_maybe_stop() properly. Use a correct
goto in idpf_tx_maybe_stop_splitq() to avoid stopping the queue or
incrementing the stops counter twice.

Fixes: 6818c4d5b3c2 ("idpf: add splitq start_xmit")
Fixes: a5ab9ee0df0b ("idpf: add singleq start_xmit and napi poll")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c |    4 ++
 drivers/net/ethernet/intel/idpf/idpf_txrx.c         |   35 +++++---------------
 drivers/net/ethernet/intel/idpf/idpf_txrx.h         |    9 ++++-
 3 files changed, 21 insertions(+), 27 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -371,6 +371,10 @@ netdev_tx_t idpf_tx_singleq_frame(struct
 				      IDPF_TX_DESCS_FOR_CTX)) {
 		idpf_tx_buf_hw_update(tx_q, tx_q->next_to_use, false);
 
+		u64_stats_update_begin(&tx_q->stats_sync);
+		u64_stats_inc(&tx_q->q_stats.q_busy);
+		u64_stats_update_end(&tx_q->stats_sync);
+
 		return NETDEV_TX_BUSY;
 	}
 
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2158,29 +2158,6 @@ void idpf_tx_splitq_build_flow_desc(unio
 }
 
 /**
- * idpf_tx_maybe_stop_common - 1st level check for common Tx stop conditions
- * @tx_q: the queue to be checked
- * @size: number of descriptors we want to assure is available
- *
- * Returns 0 if stop is not needed
- */
-int idpf_tx_maybe_stop_common(struct idpf_tx_queue *tx_q, unsigned int size)
-{
-	struct netdev_queue *nq;
-
-	if (likely(IDPF_DESC_UNUSED(tx_q) >= size))
-		return 0;
-
-	u64_stats_update_begin(&tx_q->stats_sync);
-	u64_stats_inc(&tx_q->q_stats.q_busy);
-	u64_stats_update_end(&tx_q->stats_sync);
-
-	nq = netdev_get_tx_queue(tx_q->netdev, tx_q->idx);
-
-	return netif_txq_maybe_stop(nq, IDPF_DESC_UNUSED(tx_q), size, size);
-}
-
-/**
  * idpf_tx_maybe_stop_splitq - 1st level check for Tx splitq stop conditions
  * @tx_q: the queue to be checked
  * @descs_needed: number of descriptors required for this packet
@@ -2191,7 +2168,7 @@ static int idpf_tx_maybe_stop_splitq(str
 				     unsigned int descs_needed)
 {
 	if (idpf_tx_maybe_stop_common(tx_q, descs_needed))
-		goto splitq_stop;
+		goto out;
 
 	/* If there are too many outstanding completions expected on the
 	 * completion queue, stop the TX queue to give the device some time to
@@ -2210,10 +2187,12 @@ static int idpf_tx_maybe_stop_splitq(str
 	return 0;
 
 splitq_stop:
+	netif_stop_subqueue(tx_q->netdev, tx_q->idx);
+
+out:
 	u64_stats_update_begin(&tx_q->stats_sync);
 	u64_stats_inc(&tx_q->q_stats.q_busy);
 	u64_stats_update_end(&tx_q->stats_sync);
-	netif_stop_subqueue(tx_q->netdev, tx_q->idx);
 
 	return -EBUSY;
 }
@@ -2236,7 +2215,11 @@ void idpf_tx_buf_hw_update(struct idpf_t
 	nq = netdev_get_tx_queue(tx_q->netdev, tx_q->idx);
 	tx_q->next_to_use = val;
 
-	idpf_tx_maybe_stop_common(tx_q, IDPF_TX_DESC_NEEDED);
+	if (idpf_tx_maybe_stop_common(tx_q, IDPF_TX_DESC_NEEDED)) {
+		u64_stats_update_begin(&tx_q->stats_sync);
+		u64_stats_inc(&tx_q->q_stats.q_busy);
+		u64_stats_update_end(&tx_q->stats_sync);
+	}
 
 	/* Force memory writes to complete before letting h/w
 	 * know there are new descriptors to fetch.  (Only
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -1064,7 +1064,6 @@ void idpf_tx_dma_map_error(struct idpf_t
 			   struct idpf_tx_buf *first, u16 ring_idx);
 unsigned int idpf_tx_desc_count_required(struct idpf_tx_queue *txq,
 					 struct sk_buff *skb);
-int idpf_tx_maybe_stop_common(struct idpf_tx_queue *tx_q, unsigned int size);
 void idpf_tx_timeout(struct net_device *netdev, unsigned int txqueue);
 netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
 				  struct idpf_tx_queue *tx_q);
@@ -1073,4 +1072,12 @@ bool idpf_rx_singleq_buf_hw_alloc_all(st
 				      u16 cleaned_count);
 int idpf_tso(struct sk_buff *skb, struct idpf_tx_offload_params *off);
 
+static inline bool idpf_tx_maybe_stop_common(struct idpf_tx_queue *tx_q,
+					     u32 needed)
+{
+	return !netif_subqueue_maybe_stop(tx_q->netdev, tx_q->idx,
+					  IDPF_DESC_UNUSED(tx_q),
+					  needed, needed);
+}
+
 #endif /* !_IDPF_TXRX_H_ */


