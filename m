Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81451AF0A9;
	Tue, 15 Oct 2024 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997412; cv=none; b=X3+6/tU6RJRfHA/fcpDaY7Tn23jIuv0UzpF0Wb1wzpIZSXbmQrhYm2y7+ral3zaHxEvRu4FkR9f/Zf1Pvzki2NFAS3eTzD5+suE5cqRiwDxr0Vjf0ZCU3itaxc52xzQUPWqauFGo67qckkd+VP1CyjjjSmBbGLFUPd+VcFl5Hr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997412; c=relaxed/simple;
	bh=272v4f9pb5w3mnLTIfHI/7/rNhuqiB0r4YIErZKbV+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0qKNrm0hO8e+wGF4r5hXxlyeJAtQMMcX2n/7ZviPgYipuN+UpXY7rG04PQcBiydeK2APOTU9GqyFapctYXvMgv7dXuAYQWsmseMwnx4kuhSxu5TLvDqe+V+2nNjMoKcMH3TiwgrLFNTiNhTCe4GTRAa4Un75yrJwQR21rc9fkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifSgTzVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifSgTzVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D9FC4CECE;
	Tue, 15 Oct 2024 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997412;
	bh=272v4f9pb5w3mnLTIfHI/7/rNhuqiB0r4YIErZKbV+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifSgTzVk+HwxzgpcHglljJKx0uAhi4eUa4dv11p0uQfK17ET8lqHKr0hr0oD7sxOa
	 MiJRgL17ts8FEaVnpdcuQssYiIe4Cyhn8Qg8dgjRoSJ5M1mZMeR4bhGQvtXbcCu1Xy
	 7M6Wxwj4rTEVrKnU4K8BDh3syyAQafhssTjWn5zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Wang <wangxi11@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/518] RDMA/hns: Add mapped page count checking for MTR
Date: Tue, 15 Oct 2024 14:41:19 +0200
Message-ID: <20241015123923.746426063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 9ea9a53ea93be1cc66729ceb920f0d07285d6bfd ]

Add the mapped page count checking flow to avoid invalid page size when
creating MTR.

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Link: https://lore.kernel.org/r/1612517974-31867-4-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d586628b169d ("RDMA/hns: Fix the overflow risk of hem_list_calc_ba_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c |  9 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c  | 56 ++++++++++++++----------
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 854b41c14774d..fa920a7621eef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -981,9 +981,8 @@ static struct roce_hem_item *hem_list_alloc_item(struct hns_roce_dev *hr_dev,
 		return NULL;
 
 	if (exist_bt) {
-		hem->addr = dma_alloc_coherent(hr_dev->dev,
-						   count * BA_BYTE_LEN,
-						   &hem->dma_addr, GFP_KERNEL);
+		hem->addr = dma_alloc_coherent(hr_dev->dev, count * BA_BYTE_LEN,
+					       &hem->dma_addr, GFP_KERNEL);
 		if (!hem->addr) {
 			kfree(hem);
 			return NULL;
@@ -1242,6 +1241,10 @@ static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
 	if (ba_num < 1)
 		return -ENOMEM;
 
+	if (ba_num > unit)
+		return -ENOBUFS;
+
+	ba_num = min_t(int, ba_num, unit);
 	INIT_LIST_HEAD(&temp_root);
 	offset = r->offset;
 	/* indicate to last region */
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 7e93c9b4a33f1..5fad718cfdbe3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -633,30 +633,26 @@ int hns_roce_dealloc_mw(struct ib_mw *ibmw)
 }
 
 static int mtr_map_region(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
-			  dma_addr_t *pages, struct hns_roce_buf_region *region)
+			  struct hns_roce_buf_region *region, dma_addr_t *pages,
+			  int max_count)
 {
+	int count, npage;
+	int offset, end;
 	__le64 *mtts;
-	int offset;
-	int count;
-	int npage;
 	u64 addr;
-	int end;
 	int i;
 
-	/* if hopnum is 0, buffer cannot store BAs, so skip write mtt */
-	if (!region->hopnum)
-		return 0;
-
 	offset = region->offset;
 	end = offset + region->count;
 	npage = 0;
-	while (offset < end) {
+	while (offset < end && npage < max_count) {
+		count = 0;
 		mtts = hns_roce_hem_list_find_mtt(hr_dev, &mtr->hem_list,
 						  offset, &count, NULL);
 		if (!mtts)
 			return -ENOBUFS;
 
-		for (i = 0; i < count; i++) {
+		for (i = 0; i < count && npage < max_count; i++) {
 			if (hr_dev->hw_rev == HNS_ROCE_HW_VER1)
 				addr = to_hr_hw_page_addr(pages[npage]);
 			else
@@ -668,7 +664,7 @@ static int mtr_map_region(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		offset += count;
 	}
 
-	return 0;
+	return npage;
 }
 
 static inline bool mtr_has_mtt(struct hns_roce_buf_attr *attr)
@@ -835,8 +831,8 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_buf_region *r;
-	unsigned int i;
-	int err;
+	unsigned int i, mapped_cnt;
+	int ret;
 
 	/*
 	 * Only use the first page address as root ba when hopnum is 0, this
@@ -847,26 +843,42 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		return 0;
 	}
 
-	for (i = 0; i < mtr->hem_cfg.region_count; i++) {
+	for (i = 0, mapped_cnt = 0; i < mtr->hem_cfg.region_count &&
+	     mapped_cnt < page_cnt; i++) {
 		r = &mtr->hem_cfg.region[i];
+		/* if hopnum is 0, no need to map pages in this region */
+		if (!r->hopnum) {
+			mapped_cnt += r->count;
+			continue;
+		}
+
 		if (r->offset + r->count > page_cnt) {
-			err = -EINVAL;
+			ret = -EINVAL;
 			ibdev_err(ibdev,
 				  "failed to check mtr%u end %u + %u, max %u.\n",
 				  i, r->offset, r->count, page_cnt);
-			return err;
+			return ret;
 		}
 
-		err = mtr_map_region(hr_dev, mtr, &pages[r->offset], r);
-		if (err) {
+		ret = mtr_map_region(hr_dev, mtr, r, &pages[r->offset],
+				     page_cnt - mapped_cnt);
+		if (ret < 0) {
 			ibdev_err(ibdev,
 				  "failed to map mtr%u offset %u, ret = %d.\n",
-				  i, r->offset, err);
-			return err;
+				  i, r->offset, ret);
+			return ret;
 		}
+		mapped_cnt += ret;
+		ret = 0;
 	}
 
-	return 0;
+	if (mapped_cnt < page_cnt) {
+		ret = -ENOBUFS;
+		ibdev_err(ibdev, "failed to map mtr pages count: %u < %u.\n",
+			  mapped_cnt, page_cnt);
+	}
+
+	return ret;
 }
 
 int hns_roce_mtr_find(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
-- 
2.43.0



