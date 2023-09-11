Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486A1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4BAC433C7;
	Mon, 11 Sep 2023 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441714;
	bh=lnNhVrebl8HAgHgAnzLtyN/KGhTVc5ZXXCtBSvePSNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg6aQCCii8GaUUR9HVEwBZLyt7yynHEmQQlDKp7qb2/Luod02ZDIp7HBLkeM2pqeQ
	 +V/jIx0bMpe0wuIM332e6439ftOR8RhcRjsqf22+nRsO62rRAMpOTTjX+d7B01atAt
	 M3OEtaEonpLKQYXuSwXdU3l9/mRsoRLtGXvJ2Jn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 493/739] RDMA/rxe: Fix rxe_modify_srq
Date: Mon, 11 Sep 2023 15:44:52 +0200
Message-ID: <20230911134704.898008077@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit cc28f351155def8db209647f2e20a59a7080825b ]

This patch corrects an error in rxe_modify_srq where if the
caller changes the srq size the actual new value is not returned
to the caller since it may be larger than what is requested.
Additionally it open codes the subroutine rcv_wqe_size() which
adds very little value, and makes some whitespace changes.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20230620140142.9452-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h |  6 ---
 drivers/infiniband/sw/rxe/rxe_srq.c | 60 +++++++++++++++++------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 666e06a82bc9e..4d2a8ef52c850 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -136,12 +136,6 @@ static inline int qp_mtu(struct rxe_qp *qp)
 		return IB_MTU_4096;
 }
 
-static inline int rcv_wqe_size(int max_sge)
-{
-	return sizeof(struct rxe_recv_wqe) +
-		max_sge * sizeof(struct ib_sge);
-}
-
 void free_rd_atomic_resource(struct resp_res *res);
 
 static inline void rxe_advance_resp_resource(struct rxe_qp *qp)
diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 27ca82ec0826b..3661cb627d28a 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -45,40 +45,41 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		      struct ib_srq_init_attr *init, struct ib_udata *udata,
 		      struct rxe_create_srq_resp __user *uresp)
 {
-	int err;
-	int srq_wqe_size;
 	struct rxe_queue *q;
-	enum queue_type type;
+	int wqe_size;
+	int err;
 
-	srq->ibsrq.event_handler	= init->event_handler;
-	srq->ibsrq.srq_context		= init->srq_context;
-	srq->limit		= init->attr.srq_limit;
-	srq->srq_num		= srq->elem.index;
-	srq->rq.max_wr		= init->attr.max_wr;
-	srq->rq.max_sge		= init->attr.max_sge;
+	srq->ibsrq.event_handler = init->event_handler;
+	srq->ibsrq.srq_context = init->srq_context;
+	srq->limit = init->attr.srq_limit;
+	srq->srq_num = srq->elem.index;
+	srq->rq.max_wr = init->attr.max_wr;
+	srq->rq.max_sge = init->attr.max_sge;
 
-	srq_wqe_size		= rcv_wqe_size(srq->rq.max_sge);
+	wqe_size = sizeof(struct rxe_recv_wqe) +
+			srq->rq.max_sge*sizeof(struct ib_sge);
 
 	spin_lock_init(&srq->rq.producer_lock);
 	spin_lock_init(&srq->rq.consumer_lock);
 
-	type = QUEUE_TYPE_FROM_CLIENT;
-	q = rxe_queue_init(rxe, &srq->rq.max_wr, srq_wqe_size, type);
+	q = rxe_queue_init(rxe, &srq->rq.max_wr, wqe_size,
+			   QUEUE_TYPE_FROM_CLIENT);
 	if (!q) {
 		rxe_dbg_srq(srq, "Unable to allocate queue\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_out;
 	}
 
-	srq->rq.queue = q;
-
 	err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, udata, q->buf,
 			   q->buf_size, &q->ip);
 	if (err) {
-		vfree(q->buf);
-		kfree(q);
-		return err;
+		rxe_dbg_srq(srq, "Unable to init mmap info for caller\n");
+		goto err_free;
 	}
 
+	srq->rq.queue = q;
+	init->attr.max_wr = srq->rq.max_wr;
+
 	if (uresp) {
 		if (copy_to_user(&uresp->srq_num, &srq->srq_num,
 				 sizeof(uresp->srq_num))) {
@@ -88,6 +89,12 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 	}
 
 	return 0;
+
+err_free:
+	vfree(q->buf);
+	kfree(q);
+err_out:
+	return err;
 }
 
 int rxe_srq_chk_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
@@ -145,9 +152,10 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 		      struct ib_srq_attr *attr, enum ib_srq_attr_mask mask,
 		      struct rxe_modify_srq_cmd *ucmd, struct ib_udata *udata)
 {
-	int err;
 	struct rxe_queue *q = srq->rq.queue;
 	struct mminfo __user *mi = NULL;
+	int wqe_size;
+	int err;
 
 	if (mask & IB_SRQ_MAX_WR) {
 		/*
@@ -156,12 +164,16 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 		 */
 		mi = u64_to_user_ptr(ucmd->mmap_info_addr);
 
-		err = rxe_queue_resize(q, &attr->max_wr,
-				       rcv_wqe_size(srq->rq.max_sge), udata, mi,
-				       &srq->rq.producer_lock,
+		wqe_size = sizeof(struct rxe_recv_wqe) +
+				srq->rq.max_sge*sizeof(struct ib_sge);
+
+		err = rxe_queue_resize(q, &attr->max_wr, wqe_size,
+				       udata, mi, &srq->rq.producer_lock,
 				       &srq->rq.consumer_lock);
 		if (err)
-			goto err2;
+			goto err_free;
+
+		srq->rq.max_wr = attr->max_wr;
 	}
 
 	if (mask & IB_SRQ_LIMIT)
@@ -169,7 +181,7 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 
 	return 0;
 
-err2:
+err_free:
 	rxe_queue_cleanup(q);
 	srq->rq.queue = NULL;
 	return err;
-- 
2.40.1



