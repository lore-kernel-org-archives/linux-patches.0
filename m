Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65991446060;
	Thu, 30 Jul 2026 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427085; cv=none; b=dpCGYp6EVx/VrAthmRepB771SopL8Hk3aHT2To140vaK8NMvY05Zn/BJlodCIv/BD1nm8m8MBUh7iUZ0mA6Z5iT0xnUcF1nyS1kdYYseERLqogzfyVy9Ez+yl0BL8XPLmRoGol6709zMwD2yOtcTMHR+dNtevvOvEfrP2jLcDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427085; c=relaxed/simple;
	bh=E61g8OeKaOLHNjfRUdrRFAav7zM4icRKnqJ/wDmgfBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaTp+3MR7dQQPDUwQvxjI4lpHZWJiq7ZjCbDoyAY2R/y6kXHnYzMzEy4PJzKTNN3QZakYikp3sIcQ5cqCTLoVgLLlZloQSVS3MGSYRREHvwJgbDmOgeDyLHx6XN0XEy0/MiO6GJl05ROTt6Ul0Od6SBFwRwBFsFnMiKkUS/HADM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=no6p5/0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="no6p5/0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19431F000E9;
	Thu, 30 Jul 2026 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427084;
	bh=U15WHsKB07UGvolh+wrFmjzeCkNbPLDtuSnudGYLL+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=no6p5/0S4gT9Bz9Bq59GCq/na1t5wDiw4HMQvOkUpDybRCBkb/LaLWt3gxz7RILN0
	 vjvGrFV9aLKcAoFVBMjfv4zZ4qlce8KWxWmV6Gqjq0Vtuk9pTj4hq/YPaAnHSt4b7c
	 O588PbpG0QiYatW9i1IrsMXaP3FEnWqCziX416Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/484] RDMA/siw: publish QP after initialization
Date: Thu, 30 Jul 2026 16:09:04 +0200
Message-ID: <20260730141424.445638452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit bb27fcc67c429d97f785c92c35a6c5adebb05d7f ]

siw_create_qp() currently calls siw_qp_add() before the queues, CQ
pointers, state, completion, and device list entry are ready. A QPN
lookup can therefore reach a QP that is still being constructed.

Move siw_qp_add() to the end of siw_create_qp(), after QP
initialization and before adding the QP to the siw device list.

Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
Link: https://patch.msgid.link/r/20260630060040.966461-1-ruoyuw560@gmail.com
Suggested-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 44 +++++++++++++++------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 75a7ad323c8230..40e0e0a2486db5 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -302,6 +302,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	struct siw_ucontext *uctx =
 		rdma_udata_to_drv_context(udata, struct siw_ucontext,
 					  base_ucontext);
+	struct siw_uresp_create_qp uresp = {};
 	unsigned long flags;
 	int num_sqe, num_rqe, rv = 0;
 	size_t length;
@@ -355,11 +356,6 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	spin_lock_init(&qp->rq_lock);
 	spin_lock_init(&qp->orq_lock);
 
-	rv = siw_qp_add(sdev, qp);
-	if (rv)
-		goto err_atomic;
-
-
 	/* All queue indices are derived from modulo operations
 	 * on a free running 'get' (consumer) and 'put' (producer)
 	 * unsigned counter. Having queue sizes at power of two
@@ -377,14 +373,14 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 
 	if (qp->sendq == NULL) {
 		rv = -ENOMEM;
-		goto err_out_xa;
+		goto err_out;
 	}
 	if (attrs->sq_sig_type != IB_SIGNAL_REQ_WR) {
 		if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
 			qp->attrs.flags |= SIW_SIGNAL_ALL_WR;
 		else {
 			rv = -EINVAL;
-			goto err_out_xa;
+			goto err_out;
 		}
 	}
 	qp->pd = pd;
@@ -410,7 +406,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 
 		if (qp->recvq == NULL) {
 			rv = -ENOMEM;
-			goto err_out_xa;
+			goto err_out;
 		}
 		qp->attrs.rq_size = num_rqe;
 	}
@@ -425,11 +421,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	qp->attrs.state = SIW_QP_STATE_IDLE;
 
 	if (udata) {
-		struct siw_uresp_create_qp uresp = {};
-
 		uresp.num_sqe = num_sqe;
 		uresp.num_rqe = num_rqe;
-		uresp.qp_id = qp_id(qp);
 
 		if (qp->sendq) {
 			length = num_sqe * sizeof(struct siw_sqe);
@@ -438,7 +431,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 						      length, &uresp.sq_key);
 			if (!qp->sq_entry) {
 				rv = -ENOMEM;
-				goto err_out_xa;
+				goto err_out;
 			}
 		}
 
@@ -450,9 +443,23 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 			if (!qp->rq_entry) {
 				uresp.sq_key = SIW_INVAL_UOBJ_KEY;
 				rv = -ENOMEM;
-				goto err_out_xa;
+				goto err_out;
 			}
 		}
+	}
+	qp->tx_cpu = siw_get_tx_cpu(sdev);
+	if (qp->tx_cpu < 0) {
+		rv = -EINVAL;
+		goto err_out;
+	}
+	init_completion(&qp->qp_free);
+
+	rv = siw_qp_add(sdev, qp);
+	if (rv)
+		goto err_out_tx;
+
+	if (udata) {
+		uresp.qp_id = qp_id(qp);
 
 		if (udata->outlen < sizeof(uresp)) {
 			rv = -EINVAL;
@@ -462,22 +469,19 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 		if (rv)
 			goto err_out_xa;
 	}
-	qp->tx_cpu = siw_get_tx_cpu(sdev);
-	if (qp->tx_cpu < 0) {
-		rv = -EINVAL;
-		goto err_out_xa;
-	}
+
 	INIT_LIST_HEAD(&qp->devq);
 	spin_lock_irqsave(&sdev->lock, flags);
 	list_add_tail(&qp->devq, &sdev->qp_list);
 	spin_unlock_irqrestore(&sdev->lock, flags);
 
-	init_completion(&qp->qp_free);
-
 	return 0;
 
 err_out_xa:
 	xa_erase(&sdev->qp_xa, qp_id(qp));
+err_out_tx:
+	siw_put_tx_cpu(qp->tx_cpu);
+err_out:
 	if (uctx) {
 		rdma_user_mmap_entry_remove(qp->sq_entry);
 		rdma_user_mmap_entry_remove(qp->rq_entry);
-- 
2.53.0



