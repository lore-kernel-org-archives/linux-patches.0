Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FB23644CA;
	Tue, 16 Dec 2025 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887925; cv=none; b=PFpbr0sDDiO4jGd47mu5kHMJ9eUydyKgHF3JwJ6elHRxGX4Q9AwhCaxE5JikGLm99dYREqFsy/JXdfTpK0YyFJ9jLv3uhlQm4WQXhDSDsXNeGRpXTmwSkI9hqY2q+f9s0G7v6dkxA6ZPTZnrYC1SY8TrqH1KCEs0Fc9jXdhn4sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887925; c=relaxed/simple;
	bh=XyPpxYFwRz11DRcM8gm7t838tTVhnONW+53Z1EUyrKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvpZXS5vnUXgiBBRpgQao6mZE6emwHr5Mjq9lW4kIP4Uc4ZxS93Y+y7kOdA+A1qPKSzs0Jj5j25yk9Y7UEi+8YeMu70ATVhmR7dwXiM82erO/j9oyqicZccqYb+F4QmQiurCeoEWBvcWA7ZBdWcI7iMNK2EwJQjI7NNT0kSJIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G72OwZbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G72OwZbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE18EC4CEF1;
	Tue, 16 Dec 2025 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887925;
	bh=XyPpxYFwRz11DRcM8gm7t838tTVhnONW+53Z1EUyrKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G72OwZbL7ifdI50QiCM9s6Xs9I+y+hRYvNYLYYuju1/RUIs7MA2bfnCjIMLCcB3y4
	 Bt1EfFSZUu1f4Dg6U9q4XD5jYX4jgL2vKeSlO9crJJcGgL21OjdS1+t94FplwTujVB
	 P4GXxazSV93Y/bANlQh/B9R70uPbaEoXnOLhTQbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/614] RDMA/bnxt_re: Pass correct flag for dma mr creation
Date: Tue, 16 Dec 2025 12:12:25 +0100
Message-ID: <20251216111415.057517912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit a26c4c7cdb50247b8486f1caa1ea8ab5e5c37edf ]

DMA MR doesn't use the unified MR model. So the lkey passed
on to the reg_mr command to FW should contain the correct
lkey. Driver is incorrectly over writing the lkey with pdid
and firmware commands fails due to this.

Avoid passing the wrong key for cases where the unified MR
registration is not used.

Fixes: f786eebbbefa ("RDMA/bnxt_re: Avoid an extra hwrm per MR creation")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1763624215-10382-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 +++++---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 6 +++---
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 84ce3fce2826b..f19b55c13d580 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -601,7 +601,8 @@ static int bnxt_re_create_fence_mr(struct bnxt_re_pd *pd)
 	mr->qplib_mr.va = (u64)(unsigned long)fence->va;
 	mr->qplib_mr.total_size = BNXT_RE_FENCE_BYTES;
 	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, NULL,
-			       BNXT_RE_FENCE_PBL_SIZE, PAGE_SIZE);
+			       BNXT_RE_FENCE_PBL_SIZE, PAGE_SIZE,
+			       _is_alloc_mr_unified(rdev->dev_attr->dev_cap_flags));
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to register fence-MR\n");
 		goto fail;
@@ -4027,7 +4028,7 @@ struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags)
 	mr->qplib_mr.hwq.level = PBL_LVL_MAX;
 	mr->qplib_mr.total_size = -1; /* Infinte length */
 	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, NULL, 0,
-			       PAGE_SIZE);
+			       PAGE_SIZE, false);
 	if (rc)
 		goto fail_mr;
 
@@ -4257,7 +4258,8 @@ static struct ib_mr *__bnxt_re_user_reg_mr(struct ib_pd *ib_pd, u64 length, u64
 
 	umem_pgs = ib_umem_num_dma_blocks(umem, page_size);
 	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, umem,
-			       umem_pgs, page_size);
+			       umem_pgs, page_size,
+			       _is_alloc_mr_unified(rdev->dev_attr->dev_cap_flags));
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to register user MR - rc = %d\n", rc);
 		rc = -EIO;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index a9afac2cbb7cf..408a34df26672 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -578,7 +578,7 @@ int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 }
 
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size)
+		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size, bool unified_mr)
 {
 	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
 	struct bnxt_qplib_hwq_attr hwq_attr = {};
@@ -640,7 +640,7 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 	req.access = (mr->access_flags & BNXT_QPLIB_MR_ACCESS_MASK);
 	req.va = cpu_to_le64(mr->va);
 	req.key = cpu_to_le32(mr->lkey);
-	if (_is_alloc_mr_unified(res->dattr->dev_cap_flags))
+	if (unified_mr)
 		req.key = cpu_to_le32(mr->pd->id);
 	req.flags = cpu_to_le16(mr->flags);
 	req.mr_size = cpu_to_le64(mr->total_size);
@@ -651,7 +651,7 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 	if (rc)
 		goto fail;
 
-	if (_is_alloc_mr_unified(res->dattr->dev_cap_flags)) {
+	if (unified_mr) {
 		mr->lkey = le32_to_cpu(resp.xid);
 		mr->rkey = mr->lkey;
 	}
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 147b5d9c03138..5a45c55c6464c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -341,7 +341,7 @@ int bnxt_qplib_alloc_mrw(struct bnxt_qplib_res *res,
 int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 			 bool block);
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size);
+		      struct ib_umem *umem, int num_pbls, u32 buf_pg_size, bool unified_mr);
 int bnxt_qplib_free_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr);
 int bnxt_qplib_alloc_fast_reg_mr(struct bnxt_qplib_res *res,
 				 struct bnxt_qplib_mrw *mr, int max);
-- 
2.51.0



