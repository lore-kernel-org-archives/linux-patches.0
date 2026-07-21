Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0047127A;
	Tue, 21 Jul 2026 18:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659987; cv=none; b=GdQ87JuzDAnOVJXL5i03HvsQ9je5PAtEKfkBgCW2ih6Fx/LWDp+5VUq+Dq1xM4vcYZlnhdPcpoQtq8dAH3YregYrVgQQ2wh6vAqOQdzASacEh/6nNOUzsSIqqY9BkoYDkVsiVsITLO5tY1UfpXN1BbjmEnGiVjSLJyI4RDSr37E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659987; c=relaxed/simple;
	bh=QFR9RmRmYfBw4kXyIUcq6JoXAlaA/kg3EJKpnZUkmvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv0IbupeWXmV9wyAjY3QQf0lhZKNU7WhxS3dWjDPeQEbBoqf16WoQ5IyzvAM0DzJAg9Hss0tCYK+AvB6bExkWLOa8Bit00RQob+QOPXGyX63Pvp7OEQ9Sc1xaFn9EtZHBgAE8iKgVbEKEPgUGDuAR7uuVpRGUlt+ajSYG45AVHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KS0FhEmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KS0FhEmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5991F00A3D;
	Tue, 21 Jul 2026 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659982;
	bh=9CVwYUpgvRUVKkAcoIUBotzYLRB9DXlSfVsqlu5VIZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KS0FhEmpY3GEZGZw0SphCnuGU1GQycdsEqPROrG/yaSYvtF1uKeUZwdbsoJqItQYP
	 CHg1jsze5J256fwirBnnZ3+lyYwCio2QLnU5mErxl39zkh7cZEgSUTiZT+z/+Hnxm7
	 c3l4W0wltqhHS9GdwJpVIOz0ntrkDZQ9TDNcZNVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0807/2077] RDMA/bnxt_re: Refactor bnxt_re_init_user_qp()
Date: Tue, 21 Jul 2026 17:08:00 +0200
Message-ID: <20260721152611.828377723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

[ Upstream commit 9a79dcbedcc7a0330a227f23fbd220515c61d54c ]

The umem changes for CQ added a helper - bnxt_re_setup_sginfo().
Use the same helper for QP creation since we support only 4K
pages for QP ring memory too.

Add a new helper function bnxt_re_get_psn_bytes() to improve
readability as this code will be updated in subsequent patches.

Link: https://patch.msgid.link/r/20260519150041.7251-2-sriharsha.basavapatna@broadcom.com
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: dc95931b7e13 ("RDMA/bnxt_re: Add a max slot check for SQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 127 +++++++++++++----------
 1 file changed, 73 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 7bea3bee434b8c..dac50fe6725aea 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1136,34 +1136,64 @@ static int bnxt_re_setup_swqe_size(struct bnxt_re_qp *qp,
 	return 0;
 }
 
+static int bnxt_re_setup_sginfo(struct bnxt_re_dev *rdev,
+				struct ib_umem *umem,
+				struct bnxt_qplib_sg_info *sginfo)
+{
+	unsigned long page_size;
+
+	if (!umem)
+		return -EINVAL;
+
+	page_size = ib_umem_find_best_pgsz(umem, SZ_4K, 0);
+	if (!page_size || page_size != SZ_4K)
+		return -EINVAL;
+
+	sginfo->umem = umem;
+	sginfo->npages = ib_umem_num_dma_blocks(umem, page_size);
+	sginfo->pgsize = page_size;
+	sginfo->pgshft = __builtin_ctz(page_size);
+	return 0;
+}
+
+static int bnxt_re_get_psn_bytes(struct bnxt_re_dev *rdev,
+				 struct bnxt_re_ucontext *cntx,
+				 struct bnxt_qplib_qp *qplib_qp,
+				 struct bnxt_re_qp_req *ureq)
+{
+	int psn_sz, psn_nume;
+
+	psn_sz = bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
+				sizeof(struct sq_psn_search_ext) :
+				sizeof(struct sq_psn_search);
+	if (cntx && bnxt_re_is_var_size_supported(rdev, cntx)) {
+		psn_nume = ureq->sq_slots;
+	} else {
+		psn_nume = (qplib_qp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC) ?
+		qplib_qp->sq.max_wqe : ((qplib_qp->sq.max_wqe * qplib_qp->sq.wqe_size) /
+			 sizeof(struct bnxt_qplib_sge));
+	}
+	if (_is_host_msn_table(rdev->qplib_res.dattr->dev_cap_flags2))
+		psn_nume = roundup_pow_of_two(psn_nume);
+
+	return psn_nume * psn_sz;
+}
+
 static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 				struct bnxt_re_qp *qp, struct bnxt_re_ucontext *cntx,
 				struct bnxt_re_qp_req *ureq)
 {
 	struct bnxt_qplib_qp *qplib_qp;
-	int bytes = 0, psn_sz;
 	struct ib_umem *umem;
-	int psn_nume;
+	int bytes;
+	int rc;
 
 	qplib_qp = &qp->qplib_qp;
 
 	bytes = (qplib_qp->sq.max_wqe * qplib_qp->sq.wqe_size);
 	/* Consider mapping PSN search memory only for RC QPs. */
-	if (qplib_qp->type == CMDQ_CREATE_QP_TYPE_RC) {
-		psn_sz = bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
-						   sizeof(struct sq_psn_search_ext) :
-						   sizeof(struct sq_psn_search);
-		if (cntx && bnxt_re_is_var_size_supported(rdev, cntx)) {
-			psn_nume = ureq->sq_slots;
-		} else {
-			psn_nume = (qplib_qp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC) ?
-			qplib_qp->sq.max_wqe : ((qplib_qp->sq.max_wqe * qplib_qp->sq.wqe_size) /
-				 sizeof(struct bnxt_qplib_sge));
-		}
-		if (_is_host_msn_table(rdev->qplib_res.dattr->dev_cap_flags2))
-			psn_nume = roundup_pow_of_two(psn_nume);
-		bytes += (psn_nume * psn_sz);
-	}
+	if (qplib_qp->type == CMDQ_CREATE_QP_TYPE_RC)
+		bytes += bnxt_re_get_psn_bytes(rdev, cntx, qplib_qp, ureq);
 
 	bytes = PAGE_ALIGN(bytes);
 	umem = ib_umem_get(&rdev->ibdev, ureq->qpsva, bytes,
@@ -1172,33 +1202,42 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 		return PTR_ERR(umem);
 
 	qp->sumem = umem;
-	qplib_qp->sq.sg_info.umem = umem;
-	qplib_qp->sq.sg_info.pgsize = PAGE_SIZE;
-	qplib_qp->sq.sg_info.pgshft = PAGE_SHIFT;
-	qplib_qp->qp_handle = ureq->qp_handle;
+	rc = bnxt_re_setup_sginfo(rdev, qp->sumem, &qplib_qp->sq.sg_info);
+	if (rc)
+		goto fail;
+
+	if (qp->qplib_qp.srq)
+		goto done;
 
-	if (!qp->qplib_qp.srq) {
-		bytes = (qplib_qp->rq.max_wqe * qplib_qp->rq.wqe_size);
-		bytes = PAGE_ALIGN(bytes);
-		umem = ib_umem_get(&rdev->ibdev, ureq->qprva, bytes,
-				   IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(umem))
-			goto rqfail;
-		qp->rumem = umem;
-		qplib_qp->rq.sg_info.umem = umem;
-		qplib_qp->rq.sg_info.pgsize = PAGE_SIZE;
-		qplib_qp->rq.sg_info.pgshft = PAGE_SHIFT;
+	bytes = (qplib_qp->rq.max_wqe * qplib_qp->rq.wqe_size);
+	bytes = PAGE_ALIGN(bytes);
+	umem = ib_umem_get(&rdev->ibdev, ureq->qprva, bytes,
+			   IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem)) {
+		rc = PTR_ERR(umem);
+		goto fail;
 	}
 
+	qp->rumem = umem;
+	rc = bnxt_re_setup_sginfo(rdev, qp->rumem, &qplib_qp->rq.sg_info);
+	if (rc)
+		goto rqfail;
+
+done:
+	qplib_qp->qp_handle = ureq->qp_handle;
 	qplib_qp->dpi = &cntx->dpi;
 	qplib_qp->is_user = true;
 	return 0;
+
 rqfail:
+	ib_umem_release(qp->rumem);
+	qp->rumem = NULL;
+	memset(&qplib_qp->rq.sg_info, 0, sizeof(qplib_qp->rq.sg_info));
+fail:
 	ib_umem_release(qp->sumem);
 	qp->sumem = NULL;
 	memset(&qplib_qp->sq.sg_info, 0, sizeof(qplib_qp->sq.sg_info));
-
-	return PTR_ERR(umem);
+	return rc;
 }
 
 static struct bnxt_re_ah *bnxt_re_create_shadow_qp_ah
@@ -3345,26 +3384,6 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	return ib_respond_empty_udata(udata);
 }
 
-static int bnxt_re_setup_sginfo(struct bnxt_re_dev *rdev,
-				struct ib_umem *umem,
-				struct bnxt_qplib_sg_info *sginfo)
-{
-	unsigned long page_size;
-
-	if (!umem)
-		return -EINVAL;
-
-	page_size = ib_umem_find_best_pgsz(umem, SZ_4K, 0);
-	if (!page_size || page_size != SZ_4K)
-		return -EINVAL;
-
-	sginfo->umem = umem;
-	sginfo->npages = ib_umem_num_dma_blocks(umem, page_size);
-	sginfo->pgsize = page_size;
-	sginfo->pgshft = __builtin_ctz(page_size);
-	return 0;
-}
-
 int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			   struct uverbs_attr_bundle *attrs)
 {
-- 
2.53.0



