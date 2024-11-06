Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3900B1E767B;
	Wed,  6 Nov 2024 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896664; cv=none; b=NUG1P8+boI29Mo/maCGcXS8xCPE2j9GySw7YL0N/3qogKqg7GhFPOOM+GBTpJi7BxfcJWhRTtyYvCk/+ftF+AkEbINts0iclgyronFwfwvJRceBOESBIbKTsP/gj70JhpWN4ZyhTx8EyoYx//fHXxxL3eSajwlQgFaoi0QpVFuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896664; c=relaxed/simple;
	bh=CsVd1JK/fPP/FWMlXxIW17RMoht1myFM6rz7w2oMt/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvjjHh6MIA9n2vaxR46l/V8HsnUA+IQb6FIuUVW1uFtlDRNxXQwLbcg0D12Vh8AaOughM9IJIferRwi7XfUoGDYtdd/zN9fqvCjKMtd0bssKYoSQqEkHM5OuwY4CaudcPYEWaVlUy0zcpncsdHa7cl0UJhH0xd0Tgd4SPrt7qG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKZXSm1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKZXSm1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBC8C4CECD;
	Wed,  6 Nov 2024 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896663;
	bh=CsVd1JK/fPP/FWMlXxIW17RMoht1myFM6rz7w2oMt/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKZXSm1xZ8gj7NUG4xLxKcDf1o/w1NaR+bB6p7JXhMj3XHcjViHOPOgKqv1RyJHHK
	 a3I92ud1RlMuahtqnFy0T3hWc2/2cB+kYPNpXVc91cZWh0d9tixIJ4OxX4TvjNzFgL
	 AOcz7uT2aOh+z6zILKYiHX3TqqI7jPLkHvtjAE10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/110] RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages
Date: Wed,  6 Nov 2024 13:03:33 +0100
Message-ID: <20241106120303.351523467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2861a2bbea6e4..af23e57fc78ed 100644
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



