Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E010137E2E4;
	Sat, 12 Sep 2026 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199245; cv=none; b=HSI4rN6OS2JfdXNiCjnJDEN+R9JjSMVfMeBn4fojHgMqGvGIuuBQ7AFjGQ83Jwk5EXCE1k29pR5zCEADL4pKVJ+gVmLPPz/71pV+OUWpBO5Rz6COeKECQ7NM7yHyQsMOjw/qVCGnofYTjr9gFKqCrqQoEJOxqMRJMc9uRNfhIAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199245; c=relaxed/simple;
	bh=TKeKNigE+m+f8ZRvnHa/+HqYxbReYQQxiVShtWNyUuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me8Y17mcnWGGpxUjF84UZw7VMgkTWWijiiTB2kJpK5FBy9TGocvZIynG+MQuUxcPhSdBE1PNIZ5f+T0oI5OBV+Q0S8Snqrt+D65B253PvGohvc9fW83GOBioWzbiDS69gPZED5SPlKUBJ204d+lIY7nifM3g0Yu3E4rZT9VhZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ch2UwCxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ch2UwCxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993101F000FF;
	Sat, 12 Sep 2026 07:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199243;
	bh=nD7uQpHkH6iwtzBqe0H/b0D7Tqo9AIKIREeninQDue4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ch2UwCxnwHcTtwcQKjf3F4QyDnh96WzmKwcs0+9VWK8NBLP2ySCdpg06/AofECJuS
	 bDlJ4dk0lCDesWzA5l1Um1d6YuUw0NmLQ7V5PwXSkpFjQVbhJ2jJpkic3EDh4VYEl/
	 PzntCcqQ0v7jBZ7JXqaQf7B1Do/JcY1j3aK54FRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0543/1815] RDMA/bnxt_re: Validate udata before executing commands
Date: Sat, 12 Sep 2026 08:38:13 +0200
Message-ID: <20260912065701.631537641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d38c835925d4a3bfdf0a85ff2829ee90c709c561 ]

The destroy callbacks currently zero the udata output after tearing down
driver resources. If the userspace access fails, uverbs preserves the
uobject and allows the destroy callback to run again, even though the
driver resource has already been freed.

Call ib_no_udata_io() before teardown so udata failures are detected
while the resource is still intact, then return success after teardown
completes.

As part of this change, move ib_respond_empty_udata() to the start of
the create and modify flows. While this is not strictly required for
general create flows, as the core layer unwinds uobjects on failure, it
is necessary for create AH. In _rdma_create_ah(), the HW object is
otherwise leaked.

Fixes: bed686d8dcd4 ("RDMA/bnxt_re: Use ib_respond_empty_udata()")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://patch.msgid.link/20260714-fix-destroy-no-udata-v2-1-734fdcf667d5@kernel.org
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 65 +++++++++++-------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 5657625290076..9918ecac464c0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -695,7 +695,7 @@ int bnxt_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata)
 	struct bnxt_re_dev *rdev = pd->rdev;
 	int ret;
 
-	ret = ib_is_udata_in_empty(udata);
+	ret = ib_no_udata_io(udata);
 	if (ret)
 		return ret;
 
@@ -712,7 +712,7 @@ int bnxt_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata)
 					   &pd->qplib_pd))
 			atomic_dec(&rdev->stats.res.pd_count);
 	}
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 int bnxt_re_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
@@ -844,7 +844,7 @@ int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
 	u8 nw_type;
 	int rc;
 
-	rc = ib_is_udata_in_empty(udata);
+	rc = ib_no_udata_io(udata);
 	if (rc)
 		return rc;
 
@@ -901,7 +901,7 @@ int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
 	if (active_ahs > rdev->stats.res.ah_watermark)
 		rdev->stats.res.ah_watermark = active_ahs;
 
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 int bnxt_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
@@ -1015,7 +1015,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 	unsigned int flags;
 	int rc;
 
-	rc = ib_is_udata_in_empty(udata);
+	rc = ib_no_udata_io(udata);
 	if (rc)
 		return rc;
 
@@ -1064,7 +1064,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 	if (scq_nq != rcq_nq)
 		bnxt_re_synchronize_nq(rcq_nq);
 
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 static u8 __from_ib_qp_type(enum ib_qp_type type)
@@ -2148,7 +2148,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
 	int ret;
 
-	ret = ib_is_udata_in_empty(udata);
+	ret = ib_no_udata_io(udata);
 	if (ret)
 		return ret;
 
@@ -2159,7 +2159,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 		free_page((unsigned long)srq->uctx_srq_page);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,
@@ -2297,34 +2297,25 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 {
 	struct bnxt_re_srq *srq = container_of(ib_srq, struct bnxt_re_srq,
 					       ib_srq);
-	struct bnxt_re_dev *rdev = srq->rdev;
 	int ret;
 
-	ret = ib_is_udata_in_empty(udata);
+	ret = ib_no_udata_io(udata);
 	if (ret)
 		return ret;
 
-	switch (srq_attr_mask) {
-	case IB_SRQ_MAX_WR:
-		/* SRQ resize is not supported */
+	if (srq_attr_mask != IB_SRQ_LIMIT)
 		return -EINVAL;
-	case IB_SRQ_LIMIT:
-		/* Change the SRQ threshold */
-		if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
-			return -EINVAL;
 
-		srq->qplib_srq.threshold = srq_attr->srq_limit;
-		bnxt_qplib_srq_arm_db(&srq->qplib_srq.dbinfo, srq->qplib_srq.threshold);
-
-		/* On success, update the shadow */
-		srq->srq_limit = srq_attr->srq_limit;
-		/* No need to Build and send response back to udata */
-		return ib_respond_empty_udata(udata);
-	default:
-		ibdev_err(&rdev->ibdev,
-			  "Unsupported srq_attr_mask 0x%x", srq_attr_mask);
+	if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
 		return -EINVAL;
-	}
+
+	srq->qplib_srq.threshold = srq_attr->srq_limit;
+	bnxt_qplib_srq_arm_db(&srq->qplib_srq.dbinfo, srq->qplib_srq.threshold);
+
+	/* On success, update the shadow */
+	srq->srq_limit = srq_attr->srq_limit;
+	/* No need to Build and send response back to udata */
+	return 0;
 }
 
 int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
@@ -2437,7 +2428,7 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 	unsigned int flags;
 	u8 nw_type;
 
-	rc = ib_is_udata_in_empty(udata);
+	rc = ib_no_udata_io(udata);
 	if (rc)
 		return rc;
 
@@ -2689,7 +2680,7 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		if (rc)
 			return rc;
 	}
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
@@ -3471,7 +3462,7 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	nq = cq->qplib_cq.nq;
 	cctx = rdev->chip_ctx;
 
-	ret = ib_is_udata_in_empty(udata);
+	ret = ib_no_udata_io(udata);
 	if (ret)
 		return ret;
 
@@ -3486,7 +3477,7 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	atomic_dec(&rdev->stats.res.cq_count);
 	kfree(cq->cql);
 	ib_umem_release(cq->umem);
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
@@ -3688,6 +3679,10 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe,
 	if (rc)
 		goto fail;
 
+	rc = ib_respond_empty_udata(udata);
+	if (rc)
+		goto fail;
+
 	cq->resize_umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
 					 entries * sizeof(struct cq_base),
 					 IB_ACCESS_LOCAL_WRITE);
@@ -3717,7 +3712,7 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe,
 	cq->ib_cq.cqe = cq->resize_cqe;
 	atomic_inc(&rdev->stats.res.resize_count);
 
-	return ib_respond_empty_udata(udata);
+	return 0;
 
 fail:
 	if (cq->resize_umem) {
@@ -4449,7 +4444,7 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	struct bnxt_re_dev *rdev = mr->rdev;
 	int rc;
 
-	rc = ib_is_udata_in_empty(udata);
+	rc = ib_no_udata_io(udata);
 	if (rc)
 		return rc;
 
@@ -4472,7 +4467,7 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	atomic_dec(&rdev->stats.res.mr_count);
 	if (rc)
 		return rc;
-	return ib_respond_empty_udata(udata);
+	return 0;
 }
 
 static int bnxt_re_set_page(struct ib_mr *ib_mr, u64 addr)
-- 
2.53.0



