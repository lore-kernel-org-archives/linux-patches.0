Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F69535A4;
	Mon, 27 May 2024 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838527; cv=none; b=t98TacRsGFhT6uN13S/Sxdt01hOO1kw3oPgv2KhwWSJQg8HwBwUR5MgOFbvLuO4cGDm0riPe83UEcUC8ARIRJAX0Ij2QXVPCVeeqFFS9iwVWUo2mRAh4+A6X4hL32ZYmIxqcUiYqtWAlHatbubHxUlAFvf2GDc6lecRlhklxXfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838527; c=relaxed/simple;
	bh=gbwGHU7KOtOS3SQNYBKyGhPWNWPyCL/1LmpEzjpq140=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ7b5bFQmgnbSUGoE+oh2KTzmmWfHdo0/M2Y7wIcmYKqoL+BrCTu6QgKTvmINnMqEln6/U6pHfbfJ8POt/NhX+9obGH6AuWwQ1+74DVNUPX92/pqOtzeYkA59sO6nVYDW4+rXmxieUJ9duQxdwP4pFwswUJqI1/V08dbKb+7zME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTGAjCgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTGAjCgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870EFC2BBFC;
	Mon, 27 May 2024 19:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838526;
	bh=gbwGHU7KOtOS3SQNYBKyGhPWNWPyCL/1LmpEzjpq140=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTGAjCgFVug7bN9fQkUx6pSfX10wEzYOEaQZjpj/QiF1V+Qf0+H1VWy+Dnrp/MTR+
	 kkR24fmTQKL7jeTGln8PmUuUXUkbXT0z+y9cjxxN8UigxfxMS8Ca8V8IKmtGM3if1Y
	 uSbrY4d1sbAG8LnVpV35H99QiiHimjho0RrcaFmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 426/493] RDMA/hns: Fix return value in hns_roce_map_mr_sg
Date: Mon, 27 May 2024 20:57:08 +0200
Message-ID: <20240527185644.225338052@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 203b70fda63425a4eb29f03f9074859afe821a39 ]

As described in the ib_map_mr_sg function comment, it returns the number
of sg elements that were mapped to the memory region. However,
hns_roce_map_mr_sg returns the number of pages required for mapping the
DMA area. Fix it.

Fixes: 9b2cf76c9f05 ("RDMA/hns: Optimize PBL buffer allocation process")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20240411033851.2884771-1-shaozhengchao@huawei.com
Reviewed-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 91cd580480fe2..0d42fd197c11e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -433,18 +433,18 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_mr *mr = to_hr_mr(ibmr);
 	struct hns_roce_mtr *mtr = &mr->pbl_mtr;
-	int ret = 0;
+	int ret, sg_num = 0;
 
 	mr->npages = 0;
 	mr->page_list = kvcalloc(mr->pbl_mtr.hem_cfg.buf_pg_count,
 				 sizeof(dma_addr_t), GFP_KERNEL);
 	if (!mr->page_list)
-		return ret;
+		return sg_num;
 
-	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, hns_roce_set_page);
-	if (ret < 1) {
+	sg_num = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, hns_roce_set_page);
+	if (sg_num < 1) {
 		ibdev_err(ibdev, "failed to store sg pages %u %u, cnt = %d.\n",
-			  mr->npages, mr->pbl_mtr.hem_cfg.buf_pg_count, ret);
+			  mr->npages, mr->pbl_mtr.hem_cfg.buf_pg_count, sg_num);
 		goto err_page_list;
 	}
 
@@ -455,17 +455,16 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 	ret = hns_roce_mtr_map(hr_dev, mtr, mr->page_list, mr->npages);
 	if (ret) {
 		ibdev_err(ibdev, "failed to map sg mtr, ret = %d.\n", ret);
-		ret = 0;
+		sg_num = 0;
 	} else {
 		mr->pbl_mtr.hem_cfg.buf_pg_shift = (u32)ilog2(ibmr->page_size);
-		ret = mr->npages;
 	}
 
 err_page_list:
 	kvfree(mr->page_list);
 	mr->page_list = NULL;
 
-	return ret;
+	return sg_num;
 }
 
 static void hns_roce_mw_free(struct hns_roce_dev *hr_dev,
-- 
2.43.0



