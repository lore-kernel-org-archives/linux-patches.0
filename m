Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E878FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9B6C4339E;
	Mon, 15 May 2023 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172734;
	bh=04447L49oRns11iP+ZnF4u6Xb2qCCEjWtaUMZPnAUhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLA4GO2Psx3IVq+XLKdM/Nh1ak8wgLRKcLUS13MOFOUlNACBXdcd282l2MGDrSkIC
	 MHrr9oOXAW2QnuCMTo29KRfh2i4ypK1ga2SHB5u8EatuOmBTx04n/1oJ6xDkF1FueA
	 MBPCOC0r/YMjJSZukBVvUBcPvTHlff8sMdKpy5uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaike Wan <kaike.wan@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/381] IB/hfi1: Add AIP tx traces
Date: Mon, 15 May 2023 18:28:20 +0200
Message-Id: <20230515161747.952619905@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

[ Upstream commit 4bd00b55c978017aad10f0ff3e45525cd62cca07 ]

Add traces to allow for debugging issues with AIP tx.

Link: https://lore.kernel.org/r/1617026056-50483-2-git-send-email-dennis.dalessandro@cornelisnetworks.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 00cbce5cbf88 ("IB/hfi1: Fix bugs with non-PAGE_SIZE-end multi-iovec user SDMA requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c |  18 ++++-
 drivers/infiniband/hw/hfi1/trace_tx.h | 104 ++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index ab1eefffc14b3..ec187ec746749 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -15,6 +15,7 @@
 #include "verbs.h"
 #include "trace_ibhdrs.h"
 #include "ipoib.h"
+#include "trace_tx.h"
 
 /* Add a convenience helper */
 #define CIRC_ADD(val, add, size) (((val) + (add)) & ((size) - 1))
@@ -63,12 +64,14 @@ static u64 hfi1_ipoib_used(struct hfi1_ipoib_txq *txq)
 
 static void hfi1_ipoib_stop_txq(struct hfi1_ipoib_txq *txq)
 {
+	trace_hfi1_txq_stop(txq);
 	if (atomic_inc_return(&txq->stops) == 1)
 		netif_stop_subqueue(txq->priv->netdev, txq->q_idx);
 }
 
 static void hfi1_ipoib_wake_txq(struct hfi1_ipoib_txq *txq)
 {
+	trace_hfi1_txq_wake(txq);
 	if (atomic_dec_and_test(&txq->stops))
 		netif_wake_subqueue(txq->priv->netdev, txq->q_idx);
 }
@@ -89,8 +92,10 @@ static void hfi1_ipoib_check_queue_depth(struct hfi1_ipoib_txq *txq)
 {
 	++txq->sent_txreqs;
 	if (hfi1_ipoib_used(txq) >= hfi1_ipoib_ring_hwat(txq) &&
-	    !atomic_xchg(&txq->ring_full, 1))
+	    !atomic_xchg(&txq->ring_full, 1)) {
+		trace_hfi1_txq_full(txq);
 		hfi1_ipoib_stop_txq(txq);
+	}
 }
 
 static void hfi1_ipoib_check_queue_stopped(struct hfi1_ipoib_txq *txq)
@@ -112,8 +117,10 @@ static void hfi1_ipoib_check_queue_stopped(struct hfi1_ipoib_txq *txq)
 	 * to protect against ring overflow.
 	 */
 	if (hfi1_ipoib_used(txq) < hfi1_ipoib_ring_lwat(txq) &&
-	    atomic_xchg(&txq->ring_full, 0))
+	    atomic_xchg(&txq->ring_full, 0)) {
+		trace_hfi1_txq_xmit_unstopped(txq);
 		hfi1_ipoib_wake_txq(txq);
+	}
 }
 
 static void hfi1_ipoib_free_tx(struct ipoib_txreq *tx, int budget)
@@ -405,6 +412,7 @@ static struct ipoib_txreq *hfi1_ipoib_send_dma_common(struct net_device *dev,
 				sdma_select_engine_sc(priv->dd,
 						      txp->flow.tx_queue,
 						      txp->flow.sc5);
+			trace_hfi1_flow_switch(txp->txq);
 		}
 
 		return tx;
@@ -525,6 +533,7 @@ static int hfi1_ipoib_send_dma_list(struct net_device *dev,
 	if (txq->flow.as_int != txp->flow.as_int) {
 		int ret;
 
+		trace_hfi1_flow_flush(txq);
 		ret = hfi1_ipoib_flush_tx_list(dev, txq);
 		if (unlikely(ret)) {
 			if (ret == -EBUSY)
@@ -635,8 +644,10 @@ static int hfi1_ipoib_sdma_sleep(struct sdma_engine *sde,
 			/* came from non-list submit */
 			list_add_tail(&txreq->list, &txq->tx_list);
 		if (list_empty(&txq->wait.list)) {
-			if (!atomic_xchg(&txq->no_desc, 1))
+			if (!atomic_xchg(&txq->no_desc, 1)) {
+				trace_hfi1_txq_queued(txq);
 				hfi1_ipoib_stop_txq(txq);
+			}
 			iowait_queue(pkts_sent, wait->iow, &sde->dmawait);
 		}
 
@@ -659,6 +670,7 @@ static void hfi1_ipoib_sdma_wakeup(struct iowait *wait, int reason)
 	struct hfi1_ipoib_txq *txq =
 		container_of(wait, struct hfi1_ipoib_txq, wait);
 
+	trace_hfi1_txq_wakeup(txq);
 	if (likely(txq->priv->netdev->reg_state == NETREG_REGISTERED))
 		iowait_schedule(wait, system_highpri_wq, WORK_CPU_UNBOUND);
 }
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index 769e5e4710c64..847654196dd34 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -53,6 +53,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "sdma.h"
+#include "ipoib.h"
 
 const char *parse_sdma_flags(struct trace_seq *p, u64 desc0, u64 desc1);
 
@@ -858,6 +859,109 @@ DEFINE_EVENT(
 	TP_ARGS(qp, flag)
 );
 
+DECLARE_EVENT_CLASS(/* AIP  */
+	hfi1_ipoib_txq_template,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq),
+	TP_STRUCT__entry(/* entry */
+		DD_DEV_ENTRY(txq->priv->dd)
+		__field(struct hfi1_ipoib_txq *, txq)
+		__field(struct sdma_engine *, sde)
+		__field(ulong, head)
+		__field(ulong, tail)
+		__field(uint, used)
+		__field(uint, flow)
+		__field(int, stops)
+		__field(int, no_desc)
+		__field(u8, idx)
+		__field(u8, stopped)
+	),
+	TP_fast_assign(/* assign */
+		DD_DEV_ASSIGN(txq->priv->dd)
+		__entry->txq = txq;
+		__entry->sde = txq->sde;
+		__entry->head = txq->tx_ring.head;
+		__entry->tail = txq->tx_ring.tail;
+		__entry->idx = txq->q_idx;
+		__entry->used =
+			txq->sent_txreqs -
+			atomic64_read(&txq->complete_txreqs);
+		__entry->flow = txq->flow.as_int;
+		__entry->stops = atomic_read(&txq->stops);
+		__entry->no_desc = atomic_read(&txq->no_desc);
+		__entry->stopped =
+		 __netif_subqueue_stopped(txq->priv->netdev, txq->q_idx);
+	),
+	TP_printk(/* print  */
+		"[%s] txq %llx idx %u sde %llx head %lx tail %lx flow %x used %u stops %d no_desc %d stopped %u",
+		__get_str(dev),
+		(unsigned long long)__entry->txq,
+		__entry->idx,
+		(unsigned long long)__entry->sde,
+		__entry->head,
+		__entry->tail,
+		__entry->flow,
+		__entry->used,
+		__entry->stops,
+		__entry->no_desc,
+		__entry->stopped
+	)
+);
+
+DEFINE_EVENT(/* queue stop */
+	hfi1_ipoib_txq_template, hfi1_txq_stop,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* queue wake */
+	hfi1_ipoib_txq_template, hfi1_txq_wake,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* flow flush */
+	hfi1_ipoib_txq_template, hfi1_flow_flush,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* flow switch */
+	hfi1_ipoib_txq_template, hfi1_flow_switch,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* wakeup */
+	hfi1_ipoib_txq_template, hfi1_txq_wakeup,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* full */
+	hfi1_ipoib_txq_template, hfi1_txq_full,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* queued */
+	hfi1_ipoib_txq_template, hfi1_txq_queued,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* xmit_stopped */
+	hfi1_ipoib_txq_template, hfi1_txq_xmit_stopped,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
+DEFINE_EVENT(/* xmit_unstopped */
+	hfi1_ipoib_txq_template, hfi1_txq_xmit_unstopped,
+	TP_PROTO(struct hfi1_ipoib_txq *txq),
+	TP_ARGS(txq)
+);
+
 #endif /* __HFI1_TRACE_TX_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.39.2



