Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DAB1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA419C433C8;
	Mon, 11 Sep 2023 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441762;
	bh=1/+UU/asGk0L4zNDLhASSlkOP8CgSTM3ZlaBCTwPTTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzQ0J8Z7F5NbEpmK/QmdL3+8+v4bwH/jvGNN+m70M/C/pUvFmRR77VQPCAE5Veh40
	 4JanVQ9RSW7sElLzZ4Dm4WSkIgv4fS/r332ka5S060S/wzUw2MgC14cAxbqJXnT9mT
	 FxO9qQ7nFHAlnWkv4v4aiDssc/AsAILaUbDjGf8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 491/739] RDMA/rxe: Move work queue code to subroutines
Date: Mon, 11 Sep 2023 15:44:50 +0200
Message-ID: <20230911134704.844503146@linuxfoundation.org>
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

[ Upstream commit e0ba8ff46704fc924e2ef0451ba196cbdc0d68f2 ]

This patch:
	- Moves code to initialize a qp send work queue to a
	  subroutine named rxe_init_sq.
	- Moves code to initialize a qp recv work queue to a
	  subroutine named rxe_init_rq.
	- Moves initialization of qp request and response packet
	  queues ahead of work queue initialization so that cleanup
	  of a qp if it is not fully completed can successfully
	  attempt to drain the packet queues without a seg fault.
	- Makes minor whitespace cleanups.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20230620135519.9365-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Acked-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 159 ++++++++++++++++++++---------
 1 file changed, 108 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index a569b111a9d2a..28e379c108bce 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -183,13 +183,63 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe, struct rxe_qp *qp,
 	atomic_set(&qp->skb_out, 0);
 }
 
+static int rxe_init_sq(struct rxe_qp *qp, struct ib_qp_init_attr *init,
+		       struct ib_udata *udata,
+		       struct rxe_create_qp_resp __user *uresp)
+{
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+	int wqe_size;
+	int err;
+
+	qp->sq.max_wr = init->cap.max_send_wr;
+	wqe_size = max_t(int, init->cap.max_send_sge * sizeof(struct ib_sge),
+			 init->cap.max_inline_data);
+	qp->sq.max_sge = wqe_size / sizeof(struct ib_sge);
+	qp->sq.max_inline = wqe_size;
+	wqe_size += sizeof(struct rxe_send_wqe);
+
+	qp->sq.queue = rxe_queue_init(rxe, &qp->sq.max_wr, wqe_size,
+				      QUEUE_TYPE_FROM_CLIENT);
+	if (!qp->sq.queue) {
+		rxe_err_qp(qp, "Unable to allocate send queue");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* prepare info for caller to mmap send queue if user space qp */
+	err = do_mmap_info(rxe, uresp ? &uresp->sq_mi : NULL, udata,
+			   qp->sq.queue->buf, qp->sq.queue->buf_size,
+			   &qp->sq.queue->ip);
+	if (err) {
+		rxe_err_qp(qp, "do_mmap_info failed, err = %d", err);
+		goto err_free;
+	}
+
+	/* return actual capabilities to caller which may be larger
+	 * than requested
+	 */
+	init->cap.max_send_wr = qp->sq.max_wr;
+	init->cap.max_send_sge = qp->sq.max_sge;
+	init->cap.max_inline_data = qp->sq.max_inline;
+
+	return 0;
+
+err_free:
+	vfree(qp->sq.queue->buf);
+	kfree(qp->sq.queue);
+	qp->sq.queue = NULL;
+err_out:
+	return err;
+}
+
 static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 			   struct ib_qp_init_attr *init, struct ib_udata *udata,
 			   struct rxe_create_qp_resp __user *uresp)
 {
 	int err;
-	int wqe_size;
-	enum queue_type type;
+
+	/* if we don't finish qp create make sure queue is valid */
+	skb_queue_head_init(&qp->req_pkts);
 
 	err = sock_create_kern(&init_net, AF_INET, SOCK_DGRAM, 0, &qp->sk);
 	if (err < 0)
@@ -204,32 +254,10 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	 * (0xc000 - 0xffff).
 	 */
 	qp->src_port = RXE_ROCE_V2_SPORT + (hash_32(qp_num(qp), 14) & 0x3fff);
-	qp->sq.max_wr		= init->cap.max_send_wr;
-
-	/* These caps are limited by rxe_qp_chk_cap() done by the caller */
-	wqe_size = max_t(int, init->cap.max_send_sge * sizeof(struct ib_sge),
-			 init->cap.max_inline_data);
-	qp->sq.max_sge = init->cap.max_send_sge =
-		wqe_size / sizeof(struct ib_sge);
-	qp->sq.max_inline = init->cap.max_inline_data = wqe_size;
-	wqe_size += sizeof(struct rxe_send_wqe);
 
-	type = QUEUE_TYPE_FROM_CLIENT;
-	qp->sq.queue = rxe_queue_init(rxe, &qp->sq.max_wr,
-				wqe_size, type);
-	if (!qp->sq.queue)
-		return -ENOMEM;
-
-	err = do_mmap_info(rxe, uresp ? &uresp->sq_mi : NULL, udata,
-			   qp->sq.queue->buf, qp->sq.queue->buf_size,
-			   &qp->sq.queue->ip);
-
-	if (err) {
-		vfree(qp->sq.queue->buf);
-		kfree(qp->sq.queue);
-		qp->sq.queue = NULL;
+	err = rxe_init_sq(qp, init, udata, uresp);
+	if (err)
 		return err;
-	}
 
 	qp->req.wqe_index = queue_get_producer(qp->sq.queue,
 					       QUEUE_TYPE_FROM_CLIENT);
@@ -248,36 +276,65 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	return 0;
 }
 
+static int rxe_init_rq(struct rxe_qp *qp, struct ib_qp_init_attr *init,
+		       struct ib_udata *udata,
+		       struct rxe_create_qp_resp __user *uresp)
+{
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+	int wqe_size;
+	int err;
+
+	qp->rq.max_wr = init->cap.max_recv_wr;
+	qp->rq.max_sge = init->cap.max_recv_sge;
+	wqe_size = sizeof(struct rxe_recv_wqe) +
+				qp->rq.max_sge*sizeof(struct ib_sge);
+
+	qp->rq.queue = rxe_queue_init(rxe, &qp->rq.max_wr, wqe_size,
+				      QUEUE_TYPE_FROM_CLIENT);
+	if (!qp->rq.queue) {
+		rxe_err_qp(qp, "Unable to allocate recv queue");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* prepare info for caller to mmap recv queue if user space qp */
+	err = do_mmap_info(rxe, uresp ? &uresp->rq_mi : NULL, udata,
+			   qp->rq.queue->buf, qp->rq.queue->buf_size,
+			   &qp->rq.queue->ip);
+	if (err) {
+		rxe_err_qp(qp, "do_mmap_info failed, err = %d", err);
+		goto err_free;
+	}
+
+	/* return actual capabilities to caller which may be larger
+	 * than requested
+	 */
+	init->cap.max_recv_wr = qp->rq.max_wr;
+
+	return 0;
+
+err_free:
+	vfree(qp->rq.queue->buf);
+	kfree(qp->rq.queue);
+	qp->rq.queue = NULL;
+err_out:
+	return err;
+}
+
 static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 			    struct ib_qp_init_attr *init,
 			    struct ib_udata *udata,
 			    struct rxe_create_qp_resp __user *uresp)
 {
 	int err;
-	int wqe_size;
-	enum queue_type type;
+
+	/* if we don't finish qp create make sure queue is valid */
+	skb_queue_head_init(&qp->resp_pkts);
 
 	if (!qp->srq) {
-		qp->rq.max_wr		= init->cap.max_recv_wr;
-		qp->rq.max_sge		= init->cap.max_recv_sge;
-
-		wqe_size = rcv_wqe_size(qp->rq.max_sge);
-
-		type = QUEUE_TYPE_FROM_CLIENT;
-		qp->rq.queue = rxe_queue_init(rxe, &qp->rq.max_wr,
-					wqe_size, type);
-		if (!qp->rq.queue)
-			return -ENOMEM;
-
-		err = do_mmap_info(rxe, uresp ? &uresp->rq_mi : NULL, udata,
-				   qp->rq.queue->buf, qp->rq.queue->buf_size,
-				   &qp->rq.queue->ip);
-		if (err) {
-			vfree(qp->rq.queue->buf);
-			kfree(qp->rq.queue);
-			qp->rq.queue = NULL;
+		err = rxe_init_rq(qp, init, udata, uresp);
+		if (err)
 			return err;
-		}
 	}
 
 	rxe_init_task(&qp->resp.task, qp, rxe_responder);
@@ -307,10 +364,10 @@ int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp, struct rxe_pd *pd,
 	if (srq)
 		rxe_get(srq);
 
-	qp->pd			= pd;
-	qp->rcq			= rcq;
-	qp->scq			= scq;
-	qp->srq			= srq;
+	qp->pd = pd;
+	qp->rcq = rcq;
+	qp->scq = scq;
+	qp->srq = srq;
 
 	atomic_inc(&rcq->num_wq);
 	atomic_inc(&scq->num_wq);
-- 
2.40.1



