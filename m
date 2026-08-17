Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD73E025C;
	Mon, 17 Aug 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976661; cv=none; b=O1b6555ww8D8nfXfXzmRBuFpLnA49wJGS4AB5cwx9wsydVUo0qMHDG1qxF/ar64FPyKk2Zp+fhWirHFaUMa6b87R2NMp5DzsHv13IUQSDKA0kMlf+7pI3rRTSRGiJu0WtiMlrbE7yuYyCroyI+EF4bD0/wMxXr8fUkzijp3VeXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976661; c=relaxed/simple;
	bh=T08QUI/LxczwOnzBg+s96GdDSHG42y0sSfWVHalzNLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx0GYMJSIxEqkCj3+DsUTqnRfTSyT7cM3D4ZhUWh1N3CGZnSu0Rcfx4EKIAcq0VIzKGCntJQVDPe9qsH2Mn/67jH7sI0031GLqAp4eIeZWXL2H6U/DsPgMMJgTHqPD0B/MD/SJlKXeVNQKAwkBjwPCzBT5NrfKRZgRVQxNvcn+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3I7y5Se; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3I7y5Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02C21F00A3A;
	Mon, 17 Aug 2026 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976657;
	bh=tolt50Q+bnAmCScaz8janas2E4UFdEDkCX21U/nXuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3I7y5Se+qFSRBMln+Ih6p7ti7BD494N8RdW3uHrEf8hO//lPl7aXViX3tTqIa0zJ
	 CxvYkEhzoCZ/1+oSaBGfduG2ZA4n8pz9vk1AF0nxf7UT/xDrcVadnviVW9yFLdwRNF
	 QCvOrEvFtDKKirMANTjKqeF6INRznHAhESmiih0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/456] RDMA/siw: publish QP after initialization
Date: Mon, 17 Aug 2026 15:26:50 +0200
Message-ID: <20260817132540.726169616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 55a1357a636dcd..817970e3943132 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -300,6 +300,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	struct siw_ucontext *uctx =
 		rdma_udata_to_drv_context(udata, struct siw_ucontext,
 					  base_ucontext);
+	struct siw_uresp_create_qp uresp = {};
 	unsigned long flags;
 	int num_sqe, num_rqe, rv = 0;
 	size_t length;
@@ -353,11 +354,6 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
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
@@ -375,14 +371,14 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 
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
@@ -408,7 +404,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 
 		if (qp->recvq == NULL) {
 			rv = -ENOMEM;
-			goto err_out_xa;
+			goto err_out;
 		}
 		qp->attrs.rq_size = num_rqe;
 	}
@@ -423,11 +419,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	qp->attrs.state = SIW_QP_STATE_IDLE;
 
 	if (udata) {
-		struct siw_uresp_create_qp uresp = {};
-
 		uresp.num_sqe = num_sqe;
 		uresp.num_rqe = num_rqe;
-		uresp.qp_id = qp_id(qp);
 
 		if (qp->sendq) {
 			length = num_sqe * sizeof(struct siw_sqe);
@@ -436,7 +429,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 						      length, &uresp.sq_key);
 			if (!qp->sq_entry) {
 				rv = -ENOMEM;
-				goto err_out_xa;
+				goto err_out;
 			}
 		}
 
@@ -448,9 +441,23 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
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
@@ -460,22 +467,19 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
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



