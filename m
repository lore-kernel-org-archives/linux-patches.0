Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8EA14374F;
	Thu, 13 Jun 2024 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282115; cv=none; b=cxI+db8N9QBKuuIsBmPKU1TOiZDIIZOg5Xs1y72jYUwxJoP872Jt/1WpIPxmQEaBCs4WiBl3EUIy+pbr/z0cSTWLRatuJfmJ8Py68iWIW7+BQ8n3N1oWhP3kJcFAqPqbdTr2OVrLppv5B6AfWf7A+zzHt4OC2XDBwF4npMa5+24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282115; c=relaxed/simple;
	bh=cru/ZOCuNRNj/tnQn/u9r38188JQaZEwH8G7+xJY21c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPB5EelLF8yu6k2JZ82SeasyjBOprkh8mpNKJ0bwKd1eOjcGsM3xR59pRMIWuJMuS0UUZKFIbql6xmZc0b9Xw1vkImV/VOMwKwm4kGGe/XqHQy5dsKLxkJ/5vGbz+3lON0i9s1wbkANX6BwuQsCEhYcGjMHYlqk65jgteNeFo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BA0eLkM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BA0eLkM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD1FC4AF4D;
	Thu, 13 Jun 2024 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282114;
	bh=cru/ZOCuNRNj/tnQn/u9r38188JQaZEwH8G7+xJY21c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BA0eLkM0+PO9V+aWRJX4nOQti5UuC5Zysj0/7jOB9QxeMxrDy+niV4uSDIHMJ2giM
	 LdmVr6zurzpa3dwOM8pUBbUnROea1f9tqDzbwgOOW6UggICxxI+u6UBUUvIGBfEqLm
	 9Ak8WrbqDSmJ+1hBbus9UPflYqYz3Yjs1KTPwy6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/402] RDMA/hns: Fix return value in hns_roce_map_mr_sg
Date: Thu, 13 Jun 2024 13:31:47 +0200
Message-ID: <20240613113307.987016297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 12c482f4a1c48..7106e51d5fad1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -444,18 +444,18 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
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
 
@@ -466,17 +466,16 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
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



