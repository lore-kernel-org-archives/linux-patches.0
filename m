Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98F18D65C;
	Mon, 28 Oct 2024 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097537; cv=none; b=E/hMU4mATeQuBYwxiQnQq7wqAeyGUNSnY27OKBp0cRfZANtYXx1FaaUW6jv9dHEKL62YoXdn81820jw4qeMMK7f0+iMbMIu1KDNGuAlLymf/8ohszEyexf4FCQq3BWyXdJhfDRZRo9Gahi6yQzqRSdVlx8E3PW4HZ81jvVCSkWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097537; c=relaxed/simple;
	bh=09R2YyoCvL27kvJF1XsjmP6ch1ECH+F8Q/UF0fGszmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrg/qnUUCGRIZegLKJZ/Pnv9lgmFeMBL17ZZuSXqUyoFYBfRV/Qqz0riqjFm+ugH5t7ciRUaBy+1y+iUFcJ/WK1m/d9i+yvV+LtRMVY120y/Lccb4rdIaEkfQvDEK/2mSWIICwn5q/wUrN/voO6E4P43gz2l/7FPLu3Ag0JEDm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilUbxJSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilUbxJSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D53AC4CEC3;
	Mon, 28 Oct 2024 06:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097537;
	bh=09R2YyoCvL27kvJF1XsjmP6ch1ECH+F8Q/UF0fGszmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilUbxJSuXYQaZUoAi/LInKD6k5IyKanL1GKVOBTvSGo4aTxmU2Aj/l/ocl6FXIAjm
	 MRwc1dM83vVLfuMgbWQN6IlB9y8slE35JmGWglAbVuw4NrIeypcP9t9d3UmSLceyq/
	 UpJv23we3qWshVcRBsJuljj88Ei9uF2gb6ZMJtZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/208] RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages
Date: Mon, 28 Oct 2024 07:23:37 +0100
Message-ID: <20241028062307.571221084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index 1fdffd6a0f480..96ceec1e8199a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -257,22 +257,9 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
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



