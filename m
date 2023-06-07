Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B037325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA16AC433D2;
	Wed,  7 Jun 2023 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170832;
	bh=bRFdt0d/QR5eR0BeRNtRyqsTKcyc3WracKJOwPvIEp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDorIdL5ag+1YWjGpUVLtGtOc8OxYshl0B1vev+cE/IX7KCDcrFNYmfMTeuaOCHx7
	 cVi383WB1vjrchU7Sd6cc7H93jH6elkTe3SpjKGJ11qlWwiyzAFB7TjOE8Uc1v3/tt
	 iGu9dINRD9peYVlhe/qNLCHMOBY5dgQ/rHt5M9NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devesh Sharma <devesh.sharma@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/120] RDMA/bnxt_re: Code refactor while populating user MRs
Date: Wed,  7 Jun 2023 22:15:17 +0200
Message-ID: <20230607200900.965826263@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit f6919d56388c95dba2e630670a77c380e4616c50 ]

Refactor code that populates MR page buffer list. Instead of allocating a
pbl_tbl to hold the buffer list, pass the struct ib_umem directly to
bnxt_qplib_alloc_init_hwq() as done for other user space memories.  Fix
the PBL level to handle the above mentioned change.

Also, remove an unwanted flag from the input to bnxt_qplib_reg_mr()
function.

Link: https://lore.kernel.org/r/1610012608-14528-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 08c7f09356e4 ("RDMA/bnxt_re: Fix the page_size used during the MR creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 41 ++++--------------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 17 ++++------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |  2 +-
 3 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 10d77f50f818b..85fecb432aa00 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -469,7 +469,6 @@ static int bnxt_re_create_fence_mr(struct bnxt_re_pd *pd)
 	struct bnxt_re_mr *mr = NULL;
 	dma_addr_t dma_addr = 0;
 	struct ib_mw *mw;
-	u64 pbl_tbl;
 	int rc;
 
 	dma_addr = dma_map_single(dev, fence->va, BNXT_RE_FENCE_BYTES,
@@ -504,9 +503,8 @@ static int bnxt_re_create_fence_mr(struct bnxt_re_pd *pd)
 	mr->ib_mr.lkey = mr->qplib_mr.lkey;
 	mr->qplib_mr.va = (u64)(unsigned long)fence->va;
 	mr->qplib_mr.total_size = BNXT_RE_FENCE_BYTES;
-	pbl_tbl = dma_addr;
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, &pbl_tbl,
-			       BNXT_RE_FENCE_PBL_SIZE, false, PAGE_SIZE);
+	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, NULL,
+			       BNXT_RE_FENCE_PBL_SIZE, PAGE_SIZE);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to register fence-MR\n");
 		goto fail;
@@ -3588,7 +3586,6 @@ struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags)
 	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
 	struct bnxt_re_dev *rdev = pd->rdev;
 	struct bnxt_re_mr *mr;
-	u64 pbl = 0;
 	int rc;
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
@@ -3607,7 +3604,7 @@ struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags)
 
 	mr->qplib_mr.hwq.level = PBL_LVL_MAX;
 	mr->qplib_mr.total_size = -1; /* Infinte length */
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, &pbl, 0, false,
+	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, NULL, 0,
 			       PAGE_SIZE);
 	if (rc)
 		goto fail_mr;
@@ -3778,19 +3775,6 @@ int bnxt_re_dealloc_mw(struct ib_mw *ib_mw)
 	return rc;
 }
 
-static int fill_umem_pbl_tbl(struct ib_umem *umem, u64 *pbl_tbl_orig,
-			     int page_shift)
-{
-	u64 *pbl_tbl = pbl_tbl_orig;
-	u64 page_size =  BIT_ULL(page_shift);
-	struct ib_block_iter biter;
-
-	rdma_umem_for_each_dma_block(umem, &biter, page_size)
-		*pbl_tbl++ = rdma_block_iter_dma_address(&biter);
-
-	return pbl_tbl - pbl_tbl_orig;
-}
-
 /* uverbs */
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
@@ -3800,7 +3784,6 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	struct bnxt_re_dev *rdev = pd->rdev;
 	struct bnxt_re_mr *mr;
 	struct ib_umem *umem;
-	u64 *pbl_tbl = NULL;
 	unsigned long page_size;
 	int umem_pgs, rc;
 
@@ -3854,30 +3837,18 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	}
 
 	umem_pgs = ib_umem_num_dma_blocks(umem, page_size);
-	pbl_tbl = kcalloc(umem_pgs, sizeof(*pbl_tbl), GFP_KERNEL);
-	if (!pbl_tbl) {
-		rc = -ENOMEM;
-		goto free_umem;
-	}
-
-	/* Map umem buf ptrs to the PBL */
-	umem_pgs = fill_umem_pbl_tbl(umem, pbl_tbl, order_base_2(page_size));
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, pbl_tbl,
-			       umem_pgs, false, page_size);
+	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, umem,
+			       umem_pgs, page_size);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to register user MR");
-		goto fail;
+		goto free_umem;
 	}
 
-	kfree(pbl_tbl);
-
 	mr->ib_mr.lkey = mr->qplib_mr.lkey;
 	mr->ib_mr.rkey = mr->qplib_mr.lkey;
 	atomic_inc(&rdev->mr_count);
 
 	return &mr->ib_mr;
-fail:
-	kfree(pbl_tbl);
 free_umem:
 	ib_umem_release(umem);
 free_mrw:
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 64d44f51db4b6..4afa33f58b105 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -650,16 +650,15 @@ int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 }
 
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      u64 *pbl_tbl, int num_pbls, bool block, u32 buf_pg_size)
+		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size)
 {
 	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
 	struct bnxt_qplib_hwq_attr hwq_attr = {};
 	struct bnxt_qplib_sg_info sginfo = {};
 	struct creq_register_mr_resp resp;
 	struct cmdq_register_mr req;
-	int pg_ptrs, pages, i, rc;
 	u16 cmd_flags = 0, level;
-	dma_addr_t **pbl_ptr;
+	int pages, rc, pg_ptrs;
 	u32 pg_size;
 
 	if (num_pbls) {
@@ -683,9 +682,10 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 		/* Use system PAGE_SIZE */
 		hwq_attr.res = res;
 		hwq_attr.depth = pages;
-		hwq_attr.stride = PAGE_SIZE;
+		hwq_attr.stride = buf_pg_size;
 		hwq_attr.type = HWQ_TYPE_MR;
 		hwq_attr.sginfo = &sginfo;
+		hwq_attr.sginfo->umem = umem;
 		hwq_attr.sginfo->npages = pages;
 		hwq_attr.sginfo->pgsize = PAGE_SIZE;
 		hwq_attr.sginfo->pgshft = PAGE_SHIFT;
@@ -695,11 +695,6 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 				"SP: Reg MR memory allocation failed\n");
 			return -ENOMEM;
 		}
-		/* Write to the hwq */
-		pbl_ptr = (dma_addr_t **)mr->hwq.pbl_ptr;
-		for (i = 0; i < num_pbls; i++)
-			pbl_ptr[PTR_PG(i)][PTR_IDX(i)] =
-				(pbl_tbl[i] & PAGE_MASK) | PTU_PTE_VALID;
 	}
 
 	RCFW_CMD_PREP(req, REGISTER_MR, cmd_flags);
@@ -711,7 +706,7 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 		req.pbl = 0;
 		pg_size = PAGE_SIZE;
 	} else {
-		level = mr->hwq.level + 1;
+		level = mr->hwq.level;
 		req.pbl = cpu_to_le64(mr->hwq.pbl[PBL_LVL_0].pg_map_arr[0]);
 	}
 	pg_size = buf_pg_size ? buf_pg_size : PAGE_SIZE;
@@ -728,7 +723,7 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 	req.mr_size = cpu_to_le64(mr->total_size);
 
 	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req,
-					  (void *)&resp, NULL, block);
+					  (void *)&resp, NULL, false);
 	if (rc)
 		goto fail;
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 967890cd81f27..bc228340684f4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -254,7 +254,7 @@ int bnxt_qplib_alloc_mrw(struct bnxt_qplib_res *res,
 int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 			 bool block);
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      u64 *pbl_tbl, int num_pbls, bool block, u32 buf_pg_size);
+		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size);
 int bnxt_qplib_free_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr);
 int bnxt_qplib_alloc_fast_reg_mr(struct bnxt_qplib_res *res,
 				 struct bnxt_qplib_mrw *mr, int max);
-- 
2.39.2



