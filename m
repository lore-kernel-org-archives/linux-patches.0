Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7E2ED159;
	Tue, 17 Jun 2025 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177530; cv=none; b=R7CpV1Y3fCZ6JnBYT4rgQVu6YVQb/3lRiKBXfNu0SrE3bma2BmYOERctGoC3GxNECMDxvYTMLb4xvZL7+CcX8Jd+2btlAtTXxSbctSxD6yrbd8x8nJj5H7Dlo578tAOv4Rz2kAbvCijLjMkmKmrk6HfbcddEVyMZXoKUtBVRho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177530; c=relaxed/simple;
	bh=YM4fXmvQoinkrBIFZAceHMg9+ubZvNfsB2tgMnw07Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag3RqPHdgjs5nLPTNJZdPGc/WY9A68E1KGQZTUc4mnFkciSvRbsf8Y1trf/0AvL2raYlZXo0Pdd/eVX6rWlH4H2XI6Tzoj0FkVdghok5w1JiEPekTorzhBO2cpMIaA0EnradlruUUQJutuCa6lq5wRH/vA68loHi4emhcAzikC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeRucCPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeRucCPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C921C4CEE3;
	Tue, 17 Jun 2025 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177529;
	bh=YM4fXmvQoinkrBIFZAceHMg9+ubZvNfsB2tgMnw07Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeRucCPO4szMqt1LtSa5nwbET09FctyT6c0H88wA6ptrVgoLRFLR+dbJlY3l4I5lJ
	 po7NlH8yBpuQM1CgdGshboYH06HuC8GQYTjgceU+G/6XyEp3Tk7PaxrM9DFIYsOkW1
	 4r1ZwKzCFsa0tzK8AtrOsIMw1DkzK8Qop5mUCB6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Josh Hay <joshua.a.hay@intel.com>,
	Brian Vazquez <brianvv@google.com>,
	Luigi Rizzo <lrizzo@google.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/512] idpf: fix a race in txq wakeup
Date: Tue, 17 Jun 2025 17:25:25 +0200
Message-ID: <20250617152434.130169204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit 7292af042bcf22e2c18b96ed250f78498a5b28ab ]

Add a helper function to correctly handle the lockless
synchronization when the sender needs to block. The paradigm is

        if (no_resources()) {
                stop_queue();
                barrier();
                if (!no_resources())
                        restart_queue();
        }

netif_subqueue_maybe_stop already handles the paradigm correctly, but
the code split the check for resources in three parts, the first one
(descriptors) followed the protocol, but the other two (completions and
tx_buf) were only doing the first part and so race prone.

Luckily netif_subqueue_maybe_stop macro already allows you to use a
function to evaluate the start/stop conditions so the fix only requires
the right helper function to evaluate all the conditions at once.

The patch removes idpf_tx_maybe_stop_common since it's no longer needed
and instead adjusts separately the conditions for singleq and splitq.

Note that idpf_tx_buf_hw_update doesn't need to check for resources
since that will be covered in idpf_tx_splitq_frame.

To reproduce:

Reduce the threshold for pending completions to increase the chances of
hitting this pause by changing your kernel:

drivers/net/ethernet/intel/idpf/idpf_txrx.h

-#define IDPF_TX_COMPLQ_OVERFLOW_THRESH(txcq)   ((txcq)->desc_count >> 1)
+#define IDPF_TX_COMPLQ_OVERFLOW_THRESH(txcq)   ((txcq)->desc_count >> 4)

Use pktgen to force the host to push small pkts very aggressively:

./pktgen_sample02_multiqueue.sh -i eth1 -s 100 -6 -d $IP -m $MAC \
  -p 10000-10000 -t 16 -n 0 -v -x -c 64

Fixes: 6818c4d5b3c2 ("idpf: add splitq start_xmit")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Josh Hay <joshua.a.hay@intel.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   |  9 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 45 +++++++------------
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  8 ----
 3 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
index dfd7cf1d9aa0a..a986dd5725559 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -362,17 +362,18 @@ netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
 {
 	struct idpf_tx_offload_params offload = { };
 	struct idpf_tx_buf *first;
+	int csum, tso, needed;
 	unsigned int count;
 	__be16 protocol;
-	int csum, tso;
 
 	count = idpf_tx_desc_count_required(tx_q, skb);
 	if (unlikely(!count))
 		return idpf_tx_drop_skb(tx_q, skb);
 
-	if (idpf_tx_maybe_stop_common(tx_q,
-				      count + IDPF_TX_DESCS_PER_CACHE_LINE +
-				      IDPF_TX_DESCS_FOR_CTX)) {
+	needed = count + IDPF_TX_DESCS_PER_CACHE_LINE + IDPF_TX_DESCS_FOR_CTX;
+	if (!netif_subqueue_maybe_stop(tx_q->netdev, tx_q->idx,
+				       IDPF_DESC_UNUSED(tx_q),
+				       needed, needed)) {
 		idpf_tx_buf_hw_update(tx_q, tx_q->next_to_use, false);
 
 		u64_stats_update_begin(&tx_q->stats_sync);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 623bf17f87f9c..c6c36de58b9d1 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2132,6 +2132,19 @@ void idpf_tx_splitq_build_flow_desc(union idpf_tx_flex_desc *desc,
 	desc->flow.qw1.compl_tag = cpu_to_le16(params->compl_tag);
 }
 
+/* Global conditions to tell whether the txq (and related resources)
+ * has room to allow the use of "size" descriptors.
+ */
+static int idpf_txq_has_room(struct idpf_tx_queue *tx_q, u32 size)
+{
+	if (IDPF_DESC_UNUSED(tx_q) < size ||
+	    IDPF_TX_COMPLQ_PENDING(tx_q->txq_grp) >
+		IDPF_TX_COMPLQ_OVERFLOW_THRESH(tx_q->txq_grp->complq) ||
+	    IDPF_TX_BUF_RSV_LOW(tx_q))
+		return 0;
+	return 1;
+}
+
 /**
  * idpf_tx_maybe_stop_splitq - 1st level check for Tx splitq stop conditions
  * @tx_q: the queue to be checked
@@ -2142,29 +2155,11 @@ void idpf_tx_splitq_build_flow_desc(union idpf_tx_flex_desc *desc,
 static int idpf_tx_maybe_stop_splitq(struct idpf_tx_queue *tx_q,
 				     unsigned int descs_needed)
 {
-	if (idpf_tx_maybe_stop_common(tx_q, descs_needed))
-		goto out;
-
-	/* If there are too many outstanding completions expected on the
-	 * completion queue, stop the TX queue to give the device some time to
-	 * catch up
-	 */
-	if (unlikely(IDPF_TX_COMPLQ_PENDING(tx_q->txq_grp) >
-		     IDPF_TX_COMPLQ_OVERFLOW_THRESH(tx_q->txq_grp->complq)))
-		goto splitq_stop;
-
-	/* Also check for available book keeping buffers; if we are low, stop
-	 * the queue to wait for more completions
-	 */
-	if (unlikely(IDPF_TX_BUF_RSV_LOW(tx_q)))
-		goto splitq_stop;
-
-	return 0;
-
-splitq_stop:
-	netif_stop_subqueue(tx_q->netdev, tx_q->idx);
+	if (netif_subqueue_maybe_stop(tx_q->netdev, tx_q->idx,
+				      idpf_txq_has_room(tx_q, descs_needed),
+				      1, 1))
+		return 0;
 
-out:
 	u64_stats_update_begin(&tx_q->stats_sync);
 	u64_stats_inc(&tx_q->q_stats.q_busy);
 	u64_stats_update_end(&tx_q->stats_sync);
@@ -2190,12 +2185,6 @@ void idpf_tx_buf_hw_update(struct idpf_tx_queue *tx_q, u32 val,
 	nq = netdev_get_tx_queue(tx_q->netdev, tx_q->idx);
 	tx_q->next_to_use = val;
 
-	if (idpf_tx_maybe_stop_common(tx_q, IDPF_TX_DESC_NEEDED)) {
-		u64_stats_update_begin(&tx_q->stats_sync);
-		u64_stats_inc(&tx_q->q_stats.q_busy);
-		u64_stats_update_end(&tx_q->stats_sync);
-	}
-
 	/* Force memory writes to complete before letting h/w
 	 * know there are new descriptors to fetch.  (Only
 	 * applicable for weak-ordered memory model archs,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 9c1fe84108ed2..ffeeaede6cf8f 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -1052,12 +1052,4 @@ bool idpf_rx_singleq_buf_hw_alloc_all(struct idpf_rx_queue *rxq,
 				      u16 cleaned_count);
 int idpf_tso(struct sk_buff *skb, struct idpf_tx_offload_params *off);
 
-static inline bool idpf_tx_maybe_stop_common(struct idpf_tx_queue *tx_q,
-					     u32 needed)
-{
-	return !netif_subqueue_maybe_stop(tx_q->netdev, tx_q->idx,
-					  IDPF_DESC_UNUSED(tx_q),
-					  needed, needed);
-}
-
 #endif /* !_IDPF_TXRX_H_ */
-- 
2.39.5



