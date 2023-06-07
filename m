Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342C13922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E83C433EF;
	Wed,  7 Jun 2023 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171414;
	bh=Uv8bA0kQy+2cnX7Ytg4uQ9Hv5Sl8d17ax+D6XsFribo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/AWsFAHDuN4UwK0n2UdGocPhr80y2XcM3kwBSUQxrexTQAS6ChvhVUHlm7St+ACa
	 he7FaMkOSPqsi4xLhWGWYNXwHL20MA/6Qr3vUSF5GB0J3TlxI4QCVJY1dL69609vYE
	 83ad/29csENJe8yV8rYeBC1TeRemBXsqBZEyICcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/159] RDMA/bnxt_re: Fix the page_size used during the MR creation
Date: Wed,  7 Jun 2023 22:15:04 +0200
Message-ID: <20230607200903.706359803@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
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

[ Upstream commit 08c7f09356e45d093d1867c7a3c6ac6526e2f98b ]

Driver populates the list of pages used for Memory region wrongly when
page size is more than system page size. This is causing a failure when
some of the applications that creates MR with page size as 2M.  Since HW
can support multiple page sizes, pass the correct page size while creating
the MR.

Also, driver need not adjust the number of pages when HW Queues are
created with user memory. It should work with the number of dma blocks
returned by ib_umem_num_dma_blocks. Fix this calculation also.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Fixes: f6919d56388c ("RDMA/bnxt_re: Code refactor while populating user MRs")
Link: https://lore.kernel.org/r/1683484169-9539-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 12 ++----------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c  |  7 +++----
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 44282a8cdd4f2..384d41072c63c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -215,17 +215,9 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			return -EINVAL;
 		hwq_attr->sginfo->npages = npages;
 	} else {
-		unsigned long sginfo_num_pages = ib_umem_num_dma_blocks(
-			hwq_attr->sginfo->umem, hwq_attr->sginfo->pgsize);
-
+		npages = ib_umem_num_dma_blocks(hwq_attr->sginfo->umem,
+						hwq_attr->sginfo->pgsize);
 		hwq->is_user = true;
-		npages = sginfo_num_pages;
-		npages = (npages * PAGE_SIZE) /
-			  BIT_ULL(hwq_attr->sginfo->pgshft);
-		if ((sginfo_num_pages * PAGE_SIZE) %
-		     BIT_ULL(hwq_attr->sginfo->pgshft))
-			if (!npages)
-				npages++;
 	}
 
 	if (npages == MAX_PBL_LVL_0_PGS) {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 3d9259632eb3d..a161e0d3cb444 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -680,16 +680,15 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 		/* Free the hwq if it already exist, must be a rereg */
 		if (mr->hwq.max_elements)
 			bnxt_qplib_free_hwq(res, &mr->hwq);
-		/* Use system PAGE_SIZE */
 		hwq_attr.res = res;
 		hwq_attr.depth = pages;
-		hwq_attr.stride = buf_pg_size;
+		hwq_attr.stride = sizeof(dma_addr_t);
 		hwq_attr.type = HWQ_TYPE_MR;
 		hwq_attr.sginfo = &sginfo;
 		hwq_attr.sginfo->umem = umem;
 		hwq_attr.sginfo->npages = pages;
-		hwq_attr.sginfo->pgsize = PAGE_SIZE;
-		hwq_attr.sginfo->pgshft = PAGE_SHIFT;
+		hwq_attr.sginfo->pgsize = buf_pg_size;
+		hwq_attr.sginfo->pgshft = ilog2(buf_pg_size);
 		rc = bnxt_qplib_alloc_init_hwq(&mr->hwq, &hwq_attr);
 		if (rc) {
 			dev_err(&res->pdev->dev,
-- 
2.39.2



