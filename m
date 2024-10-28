Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D77618CC1F;
	Mon, 28 Oct 2024 06:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096845; cv=none; b=uT03tXUrAuQfnZJ22mx7J6qS+Hty/bZ283I6vwR043SLuZU0AfuEt/XztFt/pe1TIH1zNVlZ6F2sPsqe0UVTKQMU4hvwy2qVfirdmWBaEGyX1g0CKtykeA9L7WHoQXqlJ83XA5t6nJvkZvbmRaNig8DhQVnP9hjiODke4a88t5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096845; c=relaxed/simple;
	bh=dpR6QvW/Gi4HswdA9Enx/sYgecOsuZHWHTrySlANfaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suWZQz+6CF8cVMjdOarT/d/x6b3FoQS27u6QlO3VgyyR7JE5fsiUudJ+6spyA4Jdex4HL6U9sa+QPM5XSNSoHkLYF483pOw4QjdYi/Eqr76byap9Ozbt2m39roLPpyUlEkY3cBJLXEaG7BRmIBCpUtwII9efXKplPDw3ONz9vYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWvjKZij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWvjKZij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C43EC4CEC3;
	Mon, 28 Oct 2024 06:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096844;
	bh=dpR6QvW/Gi4HswdA9Enx/sYgecOsuZHWHTrySlANfaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWvjKZijAUBhNHPDseqFItwUnxgIpFnMA5ziDb4cwSjc1RGSrZtl7vp5SkWPPUALR
	 F2TQEnR2fYscj5lGDSkbiVEjW5KEy50Yk34zR7DZVud/yguifshISu4k/iESsd2+bF
	 pA5WIemIAlavwLdtcrqSqFJpSS7pD7ufHj7U0y54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/80] RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages
Date: Mon, 28 Oct 2024 07:24:52 +0100
Message-ID: <20241028062252.965407643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>

[ Upstream commit 7988bdbbb85ac85a847baf09879edcd0f70521dc ]

Avoid memory corruption while setting up Level-2 PBL pages for the non MR
resources when num_pages > 256K.

There will be a single PDE page address (contiguous pages in the case of >
PAGE_SIZE), but, current logic assumes multiple pages, leading to invalid
memory access after 256K PBL entries in the PDE.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Link: https://patch.msgid.link/r/1728373302-19530-10-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 00ef5f99929c4..401cb3e22f310 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -256,22 +256,9 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			dst_virt_ptr =
 				(dma_addr_t **)hwq->pbl[PBL_LVL_0].pg_arr;
 			src_phys_ptr = hwq->pbl[PBL_LVL_1].pg_map_arr;
-			if (hwq_attr->type == HWQ_TYPE_MR) {
-			/* For MR it is expected that we supply only 1 contigous
-			 * page i.e only 1 entry in the PDL that will contain
-			 * all the PBLs for the user supplied memory region
-			 */
-				for (i = 0; i < hwq->pbl[PBL_LVL_1].pg_count;
-				     i++)
-					dst_virt_ptr[0][i] = src_phys_ptr[i] |
-						flag;
-			} else {
-				for (i = 0; i < hwq->pbl[PBL_LVL_1].pg_count;
-				     i++)
-					dst_virt_ptr[PTR_PG(i)][PTR_IDX(i)] =
-						src_phys_ptr[i] |
-						PTU_PDE_VALID;
-			}
+			for (i = 0; i < hwq->pbl[PBL_LVL_1].pg_count; i++)
+				dst_virt_ptr[0][i] = src_phys_ptr[i] | flag;
+
 			/* Alloc or init PTEs */
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_2],
 					 hwq_attr->sginfo);
-- 
2.43.0



