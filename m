Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A80C19CCF2;
	Thu,  6 Jun 2024 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683424; cv=none; b=Tlcho5/A7wvZ2xEJiL6H0j5RDshbLZGRudQdl+CQqH0W6cH90ubV1OjUvizIGOnUU/jaTEQw2rL+RDxBLtVMkFVz1t0jR418LswoHaemx7KCLio7wcD/pNefnKocsjA8WcQMxttPQgkxTYHYo0gyBpc3CVvkUZ6ckumGYUqXFvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683424; c=relaxed/simple;
	bh=/bMz8cEwwYkMlVm6yvs8hz4gV23Pjz2Dotsw6Wq3O1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guB5qXXGHVoeCNXbvqRGJfSd8aiQu94sE5UDIs0XFpod0bxheL+9n8Q/7Bo/XWu83HHp4VOZquusU4VLX7DwxagnzW0rf6Pz7VFHp3LBq5RPJIOhvMcxdCiSFR354cYu05gArRXhWYHAyaHXIobSZe9E0F+yj46ShVdwaIfUV08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3G2bSwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3G2bSwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C0FC32781;
	Thu,  6 Jun 2024 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683424;
	bh=/bMz8cEwwYkMlVm6yvs8hz4gV23Pjz2Dotsw6Wq3O1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3G2bSwFnRzla7XhU4DKKTW2KOqGkUD9iqHx94wQ7x9p6n4gp6Ja/Mn4thpLAsjs5
	 Q+au4dtJmO3H+/sXL27ovI37OO/LIM6rpKbFFoO0XS2K5Pc66+xuuSEOyJ9aGG1FV5
	 8EMgrKUDxhBseN4Ybq0EHJ0Mkhp1eWZL7yORtO9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/744] RDMA/bnxt_re: Remove roundup_pow_of_two depth for all hardware queue resources
Date: Thu,  6 Jun 2024 16:00:41 +0200
Message-ID: <20240606131744.323008449@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandramohan Akula <chandramohan.akula@broadcom.com>

[ Upstream commit 48f996d4adf15a0a0af8b8184d3ec6042a684ea4 ]

Rounding up the queue depth to power of two is not a hardware requirement.
In order to optimize the per connection memory usage, removing drivers
implementation which round up to the queue depths to the power of 2.

Implements a mask to maintain backward compatibility with older
library.

Signed-off-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1698069803-1787-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 78cfd17142ef ("bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 57 ++++++++++++++++--------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  7 +++
 include/uapi/rdma/bnxt_re-abi.h          |  9 ++++
 3 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index cc466dfd792b0..fd69be982ce06 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1184,7 +1184,8 @@ static struct bnxt_re_qp *bnxt_re_create_shadow_qp
 }
 
 static int bnxt_re_init_rq_attr(struct bnxt_re_qp *qp,
-				struct ib_qp_init_attr *init_attr)
+				struct ib_qp_init_attr *init_attr,
+				struct bnxt_re_ucontext *uctx)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_qp *qplqp;
@@ -1213,7 +1214,7 @@ static int bnxt_re_init_rq_attr(struct bnxt_re_qp *qp,
 		/* Allocate 1 more than what's provided so posting max doesn't
 		 * mean empty.
 		 */
-		entries = roundup_pow_of_two(init_attr->cap.max_recv_wr + 1);
+		entries = bnxt_re_init_depth(init_attr->cap.max_recv_wr + 1, uctx);
 		rq->max_wqe = min_t(u32, entries, dev_attr->max_qp_wqes + 1);
 		rq->q_full_delta = 0;
 		rq->sg_info.pgsize = PAGE_SIZE;
@@ -1243,7 +1244,7 @@ static void bnxt_re_adjust_gsi_rq_attr(struct bnxt_re_qp *qp)
 
 static int bnxt_re_init_sq_attr(struct bnxt_re_qp *qp,
 				struct ib_qp_init_attr *init_attr,
-				struct ib_udata *udata)
+				struct bnxt_re_ucontext *uctx)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_qp *qplqp;
@@ -1272,7 +1273,7 @@ static int bnxt_re_init_sq_attr(struct bnxt_re_qp *qp,
 	/* Allocate 128 + 1 more than what's provided */
 	diff = (qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE) ?
 		0 : BNXT_QPLIB_RESERVED_QP_WRS;
-	entries = roundup_pow_of_two(entries + diff + 1);
+	entries = bnxt_re_init_depth(entries + diff + 1, uctx);
 	sq->max_wqe = min_t(u32, entries, dev_attr->max_qp_wqes + diff + 1);
 	sq->q_full_delta = diff + 1;
 	/*
@@ -1288,7 +1289,8 @@ static int bnxt_re_init_sq_attr(struct bnxt_re_qp *qp,
 }
 
 static void bnxt_re_adjust_gsi_sq_attr(struct bnxt_re_qp *qp,
-				       struct ib_qp_init_attr *init_attr)
+				       struct ib_qp_init_attr *init_attr,
+				       struct bnxt_re_ucontext *uctx)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_qp *qplqp;
@@ -1300,7 +1302,7 @@ static void bnxt_re_adjust_gsi_sq_attr(struct bnxt_re_qp *qp,
 	dev_attr = &rdev->dev_attr;
 
 	if (!bnxt_qplib_is_chip_gen_p5(rdev->chip_ctx)) {
-		entries = roundup_pow_of_two(init_attr->cap.max_send_wr + 1);
+		entries = bnxt_re_init_depth(init_attr->cap.max_send_wr + 1, uctx);
 		qplqp->sq.max_wqe = min_t(u32, entries,
 					  dev_attr->max_qp_wqes + 1);
 		qplqp->sq.q_full_delta = qplqp->sq.max_wqe -
@@ -1338,6 +1340,7 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 				struct ib_udata *udata)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
+	struct bnxt_re_ucontext *uctx;
 	struct bnxt_qplib_qp *qplqp;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_re_cq *cq;
@@ -1347,6 +1350,7 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 	qplqp = &qp->qplib_qp;
 	dev_attr = &rdev->dev_attr;
 
+	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 	/* Setup misc params */
 	ether_addr_copy(qplqp->smac, rdev->netdev->dev_addr);
 	qplqp->pd = &pd->qplib_pd;
@@ -1388,18 +1392,18 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 	}
 
 	/* Setup RQ/SRQ */
-	rc = bnxt_re_init_rq_attr(qp, init_attr);
+	rc = bnxt_re_init_rq_attr(qp, init_attr, uctx);
 	if (rc)
 		goto out;
 	if (init_attr->qp_type == IB_QPT_GSI)
 		bnxt_re_adjust_gsi_rq_attr(qp);
 
 	/* Setup SQ */
-	rc = bnxt_re_init_sq_attr(qp, init_attr, udata);
+	rc = bnxt_re_init_sq_attr(qp, init_attr, uctx);
 	if (rc)
 		goto out;
 	if (init_attr->qp_type == IB_QPT_GSI)
-		bnxt_re_adjust_gsi_sq_attr(qp, init_attr);
+		bnxt_re_adjust_gsi_sq_attr(qp, init_attr, uctx);
 
 	if (udata) /* This will update DPI and qp_handle */
 		rc = bnxt_re_init_user_qp(rdev, pd, qp, udata);
@@ -1715,6 +1719,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_nq *nq = NULL;
+	struct bnxt_re_ucontext *uctx;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_re_srq *srq;
 	struct bnxt_re_pd *pd;
@@ -1739,13 +1744,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 	srq->rdev = rdev;
 	srq->qplib_srq.pd = &pd->qplib_pd;
 	srq->qplib_srq.dpi = &rdev->dpi_privileged;
 	/* Allocate 1 more than what's provided so posting max doesn't
 	 * mean empty
 	 */
-	entries = roundup_pow_of_two(srq_init_attr->attr.max_wr + 1);
+	entries = bnxt_re_init_depth(srq_init_attr->attr.max_wr + 1, uctx);
 	if (entries > dev_attr->max_srq_wqes + 1)
 		entries = dev_attr->max_srq_wqes + 1;
 	srq->qplib_srq.max_wqe = entries;
@@ -2102,6 +2108,9 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		qp->qplib_qp.max_dest_rd_atomic = qp_attr->max_dest_rd_atomic;
 	}
 	if (qp_attr_mask & IB_QP_CAP) {
+		struct bnxt_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+
 		qp->qplib_qp.modify_flags |=
 				CMDQ_MODIFY_QP_MODIFY_MASK_SQ_SIZE |
 				CMDQ_MODIFY_QP_MODIFY_MASK_RQ_SIZE |
@@ -2118,7 +2127,7 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 				  "Create QP failed - max exceeded");
 			return -EINVAL;
 		}
-		entries = roundup_pow_of_two(qp_attr->cap.max_send_wr);
+		entries = bnxt_re_init_depth(qp_attr->cap.max_send_wr, uctx);
 		qp->qplib_qp.sq.max_wqe = min_t(u32, entries,
 						dev_attr->max_qp_wqes + 1);
 		qp->qplib_qp.sq.q_full_delta = qp->qplib_qp.sq.max_wqe -
@@ -2131,7 +2140,7 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		qp->qplib_qp.sq.q_full_delta -= 1;
 		qp->qplib_qp.sq.max_sge = qp_attr->cap.max_send_sge;
 		if (qp->qplib_qp.rq.max_wqe) {
-			entries = roundup_pow_of_two(qp_attr->cap.max_recv_wr);
+			entries = bnxt_re_init_depth(qp_attr->cap.max_recv_wr, uctx);
 			qp->qplib_qp.rq.max_wqe =
 				min_t(u32, entries, dev_attr->max_qp_wqes + 1);
 			qp->qplib_qp.rq.q_full_delta = qp->qplib_qp.rq.max_wqe -
@@ -2919,9 +2928,11 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata)
 {
+	struct bnxt_re_cq *cq = container_of(ibcq, struct bnxt_re_cq, ib_cq);
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibcq->device, ibdev);
+	struct bnxt_re_ucontext *uctx =
+		rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 	struct bnxt_qplib_dev_attr *dev_attr = &rdev->dev_attr;
-	struct bnxt_re_cq *cq = container_of(ibcq, struct bnxt_re_cq, ib_cq);
 	int rc, entries;
 	int cqe = attr->cqe;
 	struct bnxt_qplib_nq *nq = NULL;
@@ -2940,7 +2951,7 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	cq->rdev = rdev;
 	cq->qplib_cq.cq_handle = (u64)(unsigned long)(&cq->qplib_cq);
 
-	entries = roundup_pow_of_two(cqe + 1);
+	entries = bnxt_re_init_depth(cqe + 1, uctx);
 	if (entries > dev_attr->max_cq_wqes + 1)
 		entries = dev_attr->max_cq_wqes + 1;
 
@@ -2948,8 +2959,6 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	cq->qplib_cq.sg_info.pgshft = PAGE_SHIFT;
 	if (udata) {
 		struct bnxt_re_cq_req req;
-		struct bnxt_re_ucontext *uctx = rdma_udata_to_drv_context(
-			udata, struct bnxt_re_ucontext, ib_uctx);
 		if (ib_copy_from_udata(&req, udata, sizeof(req))) {
 			rc = -EFAULT;
 			goto fail;
@@ -3071,12 +3080,11 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		return -EINVAL;
 	}
 
-	entries = roundup_pow_of_two(cqe + 1);
+	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+	entries = bnxt_re_init_depth(cqe + 1, uctx);
 	if (entries > dev_attr->max_cq_wqes + 1)
 		entries = dev_attr->max_cq_wqes + 1;
 
-	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext,
-					 ib_uctx);
 	/* uverbs consumer */
 	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
 		rc = -EFAULT;
@@ -4107,6 +4115,7 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 	struct bnxt_qplib_dev_attr *dev_attr = &rdev->dev_attr;
 	struct bnxt_re_user_mmap_entry *entry;
 	struct bnxt_re_uctx_resp resp = {};
+	struct bnxt_re_uctx_req ureq = {};
 	u32 chip_met_rev_num = 0;
 	int rc;
 
@@ -4156,6 +4165,16 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 	if (rdev->pacing.dbr_pacing)
 		resp.comp_mask |= BNXT_RE_UCNTX_CMASK_DBR_PACING_ENABLED;
 
+	if (udata->inlen >= sizeof(ureq)) {
+		rc = ib_copy_from_udata(&ureq, udata, min(udata->inlen, sizeof(ureq)));
+		if (rc)
+			goto cfail;
+		if (ureq.comp_mask & BNXT_RE_COMP_MASK_REQ_UCNTX_POW2_SUPPORT) {
+			resp.comp_mask |= BNXT_RE_UCNTX_CMASK_POW2_DISABLED;
+			uctx->cmask |= BNXT_RE_UCNTX_CMASK_POW2_DISABLED;
+		}
+	}
+
 	rc = ib_copy_to_udata(udata, &resp, min(udata->outlen, sizeof(resp)));
 	if (rc) {
 		ibdev_err(ibdev, "Failed to copy user context");
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 84715b7e7a4e4..98baea98fc176 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -140,6 +140,7 @@ struct bnxt_re_ucontext {
 	void			*shpg;
 	spinlock_t		sh_lock;	/* protect shpg */
 	struct rdma_user_mmap_entry *shpage_mmap;
+	u64 cmask;
 };
 
 enum bnxt_re_mmap_flag {
@@ -167,6 +168,12 @@ static inline u16 bnxt_re_get_rwqe_size(int nsge)
 	return sizeof(struct rq_wqe_hdr) + (nsge * sizeof(struct sq_sge));
 }
 
+static inline u32 bnxt_re_init_depth(u32 ent, struct bnxt_re_ucontext *uctx)
+{
+	return uctx ? (uctx->cmask & BNXT_RE_UCNTX_CMASK_POW2_DISABLED) ?
+		ent : roundup_pow_of_two(ent) : ent;
+}
+
 int bnxt_re_query_device(struct ib_device *ibdev,
 			 struct ib_device_attr *ib_attr,
 			 struct ib_udata *udata);
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index 6e7c67a0cca3a..a1b896d6d9405 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -54,6 +54,7 @@ enum {
 	BNXT_RE_UCNTX_CMASK_HAVE_MODE = 0x02ULL,
 	BNXT_RE_UCNTX_CMASK_WC_DPI_ENABLED = 0x04ULL,
 	BNXT_RE_UCNTX_CMASK_DBR_PACING_ENABLED = 0x08ULL,
+	BNXT_RE_UCNTX_CMASK_POW2_DISABLED = 0x10ULL,
 };
 
 enum bnxt_re_wqe_mode {
@@ -62,6 +63,14 @@ enum bnxt_re_wqe_mode {
 	BNXT_QPLIB_WQE_MODE_INVALID	= 0x02,
 };
 
+enum {
+	BNXT_RE_COMP_MASK_REQ_UCNTX_POW2_SUPPORT = 0x01,
+};
+
+struct bnxt_re_uctx_req {
+	__aligned_u64 comp_mask;
+};
+
 struct bnxt_re_uctx_resp {
 	__u32 dev_id;
 	__u32 max_qp;
-- 
2.43.0



