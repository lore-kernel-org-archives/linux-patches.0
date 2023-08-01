Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1991FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DDBC433C8;
	Tue,  1 Aug 2023 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883085;
	bh=iBV6le6i09imLutKFBGvPpbEhDn7ZImugPfJnDAXfpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T1Aw2iHhCJt3lkYzWB/MXnlTp9iaynB682Id2NSF1UcVH2xDNhz+iyr+og0/9CAB
	 jA2bYsb41A6SSF9f9imWiNCRT+tKL4HB/gHWSJizW9AvPOTw60+La5cVNbOROvE0Sk
	 JNdigqYmBB4OYNyy20NlVaSFGe+UHdYAC8y3EASI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 110/239] RDMA/bnxt_re: Prevent handling any completions after qp destroy
Date: Tue,  1 Aug 2023 11:19:34 +0200
Message-ID: <20230801091929.695778119@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit b5bbc6551297447d3cca55cf907079e206e9cd82 ]

HW may generate completions that indicates QP is destroyed.
Driver should not be scheduling any more completion handlers
for this QP, after the QP is destroyed. Since CQs are active
during the QP destroy, driver may still schedule completion
handlers. This can cause a race where the destroy_cq and poll_cq
running simultaneously.

Snippet of kernel panic while doing bnxt_re driver load unload in loop.
This indicates a poll after the CQ is freed. 

[77786.481636] Call Trace:
[77786.481640]  <TASK>
[77786.481644]  bnxt_re_poll_cq+0x14a/0x620 [bnxt_re]
[77786.481658]  ? kvm_clock_read+0x14/0x30
[77786.481693]  __ib_process_cq+0x57/0x190 [ib_core]
[77786.481728]  ib_cq_poll_work+0x26/0x80 [ib_core]
[77786.481761]  process_one_work+0x1e5/0x3f0
[77786.481768]  worker_thread+0x50/0x3a0
[77786.481785]  ? __pfx_worker_thread+0x10/0x10
[77786.481790]  kthread+0xe2/0x110
[77786.481794]  ? __pfx_kthread+0x10/0x10
[77786.481797]  ret_from_fork+0x2c/0x50

To avoid this, complete all completion handlers before returning the
destroy QP. If free_cq is called soon after destroy_qp,  IB stack
will cancel the CQ work before invoking the destroy_cq verb and
this will prevent any race mentioned.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1689322969-25402-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 12 ++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 18 ++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 952811c40c54b..ebe6852c40e8c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -797,7 +797,10 @@ static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
+	struct bnxt_qplib_qp *qplib_qp = &qp->qplib_qp;
 	struct bnxt_re_dev *rdev = qp->rdev;
+	struct bnxt_qplib_nq *scq_nq = NULL;
+	struct bnxt_qplib_nq *rcq_nq = NULL;
 	unsigned int flags;
 	int rc;
 
@@ -831,6 +834,15 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 	ib_umem_release(qp->rumem);
 	ib_umem_release(qp->sumem);
 
+	/* Flush all the entries of notification queue associated with
+	 * given qp.
+	 */
+	scq_nq = qplib_qp->scq->nq;
+	rcq_nq = qplib_qp->rcq->nq;
+	bnxt_re_synchronize_nq(scq_nq);
+	if (scq_nq != rcq_nq)
+		bnxt_re_synchronize_nq(rcq_nq);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 55f092c2c8a88..e589b04f953c5 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -381,6 +381,24 @@ static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 	spin_unlock_bh(&hwq->lock);
 }
 
+/* bnxt_re_synchronize_nq - self polling notification queue.
+ * @nq      -     notification queue pointer
+ *
+ * This function will start polling entries of a given notification queue
+ * for all pending  entries.
+ * This function is useful to synchronize notification entries while resources
+ * are going away.
+ */
+
+void bnxt_re_synchronize_nq(struct bnxt_qplib_nq *nq)
+{
+	int budget = nq->budget;
+
+	nq->budget = nq->hwq.max_elements;
+	bnxt_qplib_service_nq(&nq->nq_tasklet);
+	nq->budget = budget;
+}
+
 static irqreturn_t bnxt_qplib_nq_irq(int irq, void *dev_instance)
 {
 	struct bnxt_qplib_nq *nq = dev_instance;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index a42820821c473..404b851091ca2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -553,6 +553,7 @@ int bnxt_qplib_process_flush_list(struct bnxt_qplib_cq *cq,
 				  struct bnxt_qplib_cqe *cqe,
 				  int num_cqes);
 void bnxt_qplib_flush_cqn_wq(struct bnxt_qplib_qp *qp);
+void bnxt_re_synchronize_nq(struct bnxt_qplib_nq *nq);
 
 static inline void *bnxt_qplib_get_swqe(struct bnxt_qplib_q *que, u32 *swq_idx)
 {
-- 
2.40.1



