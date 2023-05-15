Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661FFFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D2C4339B;
	Mon, 15 May 2023 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172737;
	bh=52xdA6zEr9MheCZJALq08FhgLfjwinqL36sEUxFZM+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZRMpZw74Et/bwPnG4ykYLP+HjQQ/EqeRpC+k8g7+rYOKPO+J9lff4lwTsAL26gJO
	 l7ZJIBIbveRk4OcQ7xa6ele5t2ZTWhd3kaysVjW0nc5X2pOsSDdHZnmZ1pPnDb10Yk
	 uldPMOJl8jg5bhUpExp9S2GPKu+L6ODb1dWRMEbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaike Wan <kaike.wan@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/381] IB/hfi1: Add additional usdma traces
Date: Mon, 15 May 2023 18:28:21 +0200
Message-Id: <20230515161747.999326743@linuxfoundation.org>
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

[ Upstream commit 6b13215df1d37f5be23fc4a01a915a287b25ce15 ]

Add traces that were vital in isolating an issue with pq waitlist in
commit fa8dac396863 ("IB/hfi1: Fix another case where pq is left on
waitlist")

Link: https://lore.kernel.org/r/1617026056-50483-8-git-send-email-dennis.dalessandro@cornelisnetworks.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 00cbce5cbf88 ("IB/hfi1: Fix bugs with non-PAGE_SIZE-end multi-iovec user SDMA requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/trace_tx.h  | 75 ++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c | 12 +++--
 drivers/infiniband/hw/hfi1/user_sdma.h |  1 +
 3 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index 847654196dd34..d44fc54858b90 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -54,6 +54,7 @@
 #include "mad.h"
 #include "sdma.h"
 #include "ipoib.h"
+#include "user_sdma.h"
 
 const char *parse_sdma_flags(struct trace_seq *p, u64 desc0, u64 desc1);
 
@@ -654,6 +655,80 @@ TRACE_EVENT(hfi1_sdma_user_completion,
 		      __entry->code)
 );
 
+TRACE_EVENT(hfi1_usdma_defer,
+	    TP_PROTO(struct hfi1_user_sdma_pkt_q *pq,
+		     struct sdma_engine *sde,
+		     struct iowait *wait),
+	    TP_ARGS(pq, sde, wait),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(pq->dd)
+			     __field(struct hfi1_user_sdma_pkt_q *, pq)
+			     __field(struct sdma_engine *, sde)
+			     __field(struct iowait *, wait)
+			     __field(int, engine)
+			     __field(int, empty)
+			     ),
+	     TP_fast_assign(DD_DEV_ASSIGN(pq->dd);
+			    __entry->pq = pq;
+			    __entry->sde = sde;
+			    __entry->wait = wait;
+			    __entry->engine = sde->this_idx;
+			    __entry->empty = list_empty(&__entry->wait->list);
+			    ),
+	     TP_printk("[%s] pq %llx sde %llx wait %llx engine %d empty %d",
+		       __get_str(dev),
+		       (unsigned long long)__entry->pq,
+		       (unsigned long long)__entry->sde,
+		       (unsigned long long)__entry->wait,
+		       __entry->engine,
+		       __entry->empty
+		)
+);
+
+TRACE_EVENT(hfi1_usdma_activate,
+	    TP_PROTO(struct hfi1_user_sdma_pkt_q *pq,
+		     struct iowait *wait,
+		     int reason),
+	    TP_ARGS(pq, wait, reason),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(pq->dd)
+			     __field(struct hfi1_user_sdma_pkt_q *, pq)
+			     __field(struct iowait *, wait)
+			     __field(int, reason)
+			     ),
+	     TP_fast_assign(DD_DEV_ASSIGN(pq->dd);
+			    __entry->pq = pq;
+			    __entry->wait = wait;
+			    __entry->reason = reason;
+			    ),
+	     TP_printk("[%s] pq %llx wait %llx reason %d",
+		       __get_str(dev),
+		       (unsigned long long)__entry->pq,
+		       (unsigned long long)__entry->wait,
+		       __entry->reason
+		)
+);
+
+TRACE_EVENT(hfi1_usdma_we,
+	    TP_PROTO(struct hfi1_user_sdma_pkt_q *pq,
+		     int we_ret),
+	    TP_ARGS(pq, we_ret),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(pq->dd)
+			     __field(struct hfi1_user_sdma_pkt_q *, pq)
+			     __field(int, state)
+			     __field(int, we_ret)
+			     ),
+	     TP_fast_assign(DD_DEV_ASSIGN(pq->dd);
+			    __entry->pq = pq;
+			    __entry->state = pq->state;
+			    __entry->we_ret = we_ret;
+			    ),
+	     TP_printk("[%s] pq %llx state %d we_ret %d",
+		       __get_str(dev),
+		       (unsigned long long)__entry->pq,
+		       __entry->state,
+		       __entry->we_ret
+		)
+);
+
 const char *print_u32_array(struct trace_seq *, u32 *, int);
 #define __print_u32_hex(arr, len) print_u32_array(p, arr, len)
 
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 4a4956f96a7eb..da5b2e37355ab 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -133,6 +133,7 @@ static int defer_packet_queue(
 		container_of(wait->iow, struct hfi1_user_sdma_pkt_q, busy);
 
 	write_seqlock(&sde->waitlock);
+	trace_hfi1_usdma_defer(pq, sde, &pq->busy);
 	if (sdma_progress(sde, seq, txreq))
 		goto eagain;
 	/*
@@ -157,7 +158,8 @@ static void activate_packet_queue(struct iowait *wait, int reason)
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait, struct hfi1_user_sdma_pkt_q, busy);
-	pq->busy.lock = NULL;
+
+	trace_hfi1_usdma_activate(pq, wait, reason);
 	xchg(&pq->state, SDMA_PKT_Q_ACTIVE);
 	wake_up(&wait->wait_dma);
 };
@@ -599,13 +601,17 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	while (req->seqsubmitted != req->info.npkts) {
 		ret = user_sdma_send_pkts(req, pcount);
 		if (ret < 0) {
+			int we_ret;
+
 			if (ret != -EBUSY)
 				goto free_req;
-			if (wait_event_interruptible_timeout(
+			we_ret = wait_event_interruptible_timeout(
 				pq->busy.wait_dma,
 				pq->state == SDMA_PKT_Q_ACTIVE,
 				msecs_to_jiffies(
-					SDMA_IOWAIT_TIMEOUT)) <= 0)
+					SDMA_IOWAIT_TIMEOUT));
+			trace_hfi1_usdma_we(pq, we_ret);
+			if (we_ret <= 0)
 				flush_pq_iowait(pq);
 		}
 	}
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 1e8c02fe8ad1d..fabe581399068 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -53,6 +53,7 @@
 #include "common.h"
 #include "iowait.h"
 #include "user_exp_rcv.h"
+#include "mmu_rb.h"
 
 /* The maximum number of Data io vectors per message/request */
 #define MAX_VECTORS_PER_REQ 8
-- 
2.39.2



