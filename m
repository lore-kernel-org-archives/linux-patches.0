Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3951DE8A5;
	Tue,  3 Dec 2024 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241480; cv=none; b=HA0xdqfl0IfTaatmweatNmCmug/gaz9NqdF61wsUbrZRQ/dPuihLfwtpcl5IoVRNNpGImJCBVRy9hdoKDA1EMRlWrWboFAoYAlMEAHb885NZgjJEO2uFiqR3O9ADIp7+pSBXMaTkxLlINxT8yM8WvFYj3n/uUCA6zdP861LAAwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241480; c=relaxed/simple;
	bh=DQrwxCp5iE1M1VXG/xFFYfkZBEv+kezv5BCGHkAh0e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIO01uMrPUUhP1pTjpwoepyv8spzq5PygqFTpmsMvQ+HiCAMx07cuQOvbJ9qn1CCh9mW9uk45znPYzeRzQgbcBaorG6t7Quw/dpjjoTev6jWu4C5gHESaTGq24KqnzgITtLgVgKK24+EshPdzZqetehPFIJJDV61Jc/2y5sqaec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPwF1M5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPwF1M5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB19CC4CECF;
	Tue,  3 Dec 2024 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241480;
	bh=DQrwxCp5iE1M1VXG/xFFYfkZBEv+kezv5BCGHkAh0e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPwF1M5Am+J53oMZBiTnE+qtBpPjAtOzuPTqmj7MVNrinX0NTK6dsiRqYAMuVAzpH
	 MJMk9fLBfduK7AaUVb6ky19+eWeThGbhQRYOgVv4GQ/jLJP/Y3zo033/40E1BX8sFe
	 n017ZdPncNZwtjEap7TPW3QdpRfINW7NAI8rbo50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/826] RDMA/hns: Fix NULL pointer derefernce in hns_roce_map_mr_sg()
Date: Tue,  3 Dec 2024 15:42:36 +0100
Message-ID: <20241203144800.497627520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6b526d17eed850352d880b93b9bf20b93006bd92 ]

ib_map_mr_sg() allows ULPs to specify NULL as the sg_offset argument.
The driver needs to check whether it is a NULL pointer before
dereferencing it.

Fixes: d387d4b54eb8 ("RDMA/hns: Fix missing pagesize and alignment check in FRMR")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241108075743.2652258-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index b3f4327d0e64a..bf30b3a65a9ba 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -435,15 +435,16 @@ static int hns_roce_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		       unsigned int *sg_offset)
+		       unsigned int *sg_offset_p)
 {
+	unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibmr->device);
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_mr *mr = to_hr_mr(ibmr);
 	struct hns_roce_mtr *mtr = &mr->pbl_mtr;
 	int ret, sg_num = 0;
 
-	if (!IS_ALIGNED(*sg_offset, HNS_ROCE_FRMR_ALIGN_SIZE) ||
+	if (!IS_ALIGNED(sg_offset, HNS_ROCE_FRMR_ALIGN_SIZE) ||
 	    ibmr->page_size < HNS_HW_PAGE_SIZE ||
 	    ibmr->page_size > HNS_HW_MAX_PAGE_SIZE)
 		return sg_num;
@@ -454,7 +455,7 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 	if (!mr->page_list)
 		return sg_num;
 
-	sg_num = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, hns_roce_set_page);
+	sg_num = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset_p, hns_roce_set_page);
 	if (sg_num < 1) {
 		ibdev_err(ibdev, "failed to store sg pages %u %u, cnt = %d.\n",
 			  mr->npages, mr->pbl_mtr.hem_cfg.buf_pg_count, sg_num);
-- 
2.43.0



