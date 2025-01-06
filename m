Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975A136E09;
	Mon,  6 Jan 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176861; cv=none; b=RIhn81oTptB44QmhBRHT12AQgHSyYsuvLqZ6L7b/G9xW8DINyk4SAI0L376PlwN7Wg4fsChPI74GCpXCEni4v/hx1Q6qBMwF7UcnSlrSrNr94XKe+1DtgkLsPxtNErIcepIwS0OUy3udiwYQi+T5upVMvlmS8E04R85/Hkz/EpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176861; c=relaxed/simple;
	bh=KC+SwL+LzOjO/uklCV2yTQqV0NR0ReUlqfZ0vWnjDMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgmxeG1HKfFUt0XN7BRMJ7K+Giy9XWEyOA+YxIns8/DkJW2x7Ju3TAuapWODGIvUIFE6cjaImJJB+F0zxwkiGB+pXDwFTUc6J3fgaPMvVBEaUFNRzTGfJl1qsFPm9VtWHQQ5u1ygCVLQknkvnWN8Y94qh9OIIfOH0ApcaiNqXSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HziFxwT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HziFxwT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C96C4CED2;
	Mon,  6 Jan 2025 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176861;
	bh=KC+SwL+LzOjO/uklCV2yTQqV0NR0ReUlqfZ0vWnjDMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HziFxwT5W4DgmoqtUA1awpO4ahCiGRahgJHQxTzM0v9nCUHYkY44SRS0erU8FpZvb
	 qxz9d9xZwo2RITEw3KAsBf9jtCUlU+8KA04pw5ab6c5PODsiqsxiJ5126lCxlSF9F0
	 GHJJ3vbeGPW7U/FZfmdLsFH6oPn4NM7PzHQ0cnLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/81] RDMA/hns: Fix mapping error of zero-hop WQE buffer
Date: Mon,  6 Jan 2025 16:15:55 +0100
Message-ID: <20250106151130.312669961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 8673a6c2d9e483dfeeef83a1f06f59e05636f4d1 ]

Due to HW limitation, the three region of WQE buffer must be mapped
and set to HW in a fixed order: SQ buffer, SGE buffer, and RQ buffer.

Currently when one region is zero-hop while the other two are not,
the zero-hop region will not be mapped. This violate the limitation
above and leads to address error.

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 43 ++++++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_mr.c  |  5 ---
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 6e0ca8a4b2a8..f1de497fc977 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -986,6 +986,7 @@ struct hns_roce_hem_item {
 	size_t count; /* max ba numbers */
 	int start; /* start buf offset in this hem */
 	int end; /* end buf offset in this hem */
+	bool exist_bt;
 };
 
 /* All HEM items are linked in a tree structure */
@@ -1014,6 +1015,7 @@ hem_list_alloc_item(struct hns_roce_dev *hr_dev, int start, int end, int count,
 		}
 	}
 
+	hem->exist_bt = exist_bt;
 	hem->count = count;
 	hem->start = start;
 	hem->end = end;
@@ -1024,22 +1026,22 @@ hem_list_alloc_item(struct hns_roce_dev *hr_dev, int start, int end, int count,
 }
 
 static void hem_list_free_item(struct hns_roce_dev *hr_dev,
-			       struct hns_roce_hem_item *hem, bool exist_bt)
+			       struct hns_roce_hem_item *hem)
 {
-	if (exist_bt)
+	if (hem->exist_bt)
 		dma_free_coherent(hr_dev->dev, hem->count * BA_BYTE_LEN,
 				  hem->addr, hem->dma_addr);
 	kfree(hem);
 }
 
 static void hem_list_free_all(struct hns_roce_dev *hr_dev,
-			      struct list_head *head, bool exist_bt)
+			      struct list_head *head)
 {
 	struct hns_roce_hem_item *hem, *temp_hem;
 
 	list_for_each_entry_safe(hem, temp_hem, head, list) {
 		list_del(&hem->list);
-		hem_list_free_item(hr_dev, hem, exist_bt);
+		hem_list_free_item(hr_dev, hem);
 	}
 }
 
@@ -1139,6 +1141,10 @@ int hns_roce_hem_list_calc_root_ba(const struct hns_roce_buf_region *regions,
 
 	for (i = 0; i < region_cnt; i++) {
 		r = (struct hns_roce_buf_region *)&regions[i];
+		/* when r->hopnum = 0, the region should not occupy root_ba. */
+		if (!r->hopnum)
+			continue;
+
 		if (r->hopnum > 1) {
 			step = hem_list_calc_ba_range(r->hopnum, 1, unit);
 			if (step > 0)
@@ -1232,7 +1238,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 
 err_exit:
 	for (level = 1; level < hopnum; level++)
-		hem_list_free_all(hr_dev, &temp_list[level], true);
+		hem_list_free_all(hr_dev, &temp_list[level]);
 
 	return ret;
 }
@@ -1273,16 +1279,26 @@ static int alloc_fake_root_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
 {
 	struct hns_roce_hem_item *hem;
 
+	/* This is on the has_mtt branch, if r->hopnum
+	 * is 0, there is no root_ba to reuse for the
+	 * region's fake hem, so a dma_alloc request is
+	 * necessary here.
+	 */
 	hem = hem_list_alloc_item(hr_dev, r->offset, r->offset + r->count - 1,
-				  r->count, false);
+				  r->count, !r->hopnum);
 	if (!hem)
 		return -ENOMEM;
 
-	hem_list_assign_bt(hem, cpu_base, phy_base);
+	/* The root_ba can be reused only when r->hopnum > 0. */
+	if (r->hopnum)
+		hem_list_assign_bt(hem, cpu_base, phy_base);
 	list_add(&hem->list, branch_head);
 	list_add(&hem->sibling, leaf_head);
 
-	return r->count;
+	/* If r->hopnum == 0, 0 is returned,
+	 * so that the root_bt entry is not occupied.
+	 */
+	return r->hopnum ? r->count : 0;
 }
 
 static int setup_middle_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
@@ -1326,7 +1342,7 @@ setup_root_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem_list *hem_list,
 		return -ENOMEM;
 
 	total = 0;
-	for (i = 0; i < region_cnt && total < max_ba_num; i++) {
+	for (i = 0; i < region_cnt && total <= max_ba_num; i++) {
 		r = &regions[i];
 		if (!r->count)
 			continue;
@@ -1392,9 +1408,9 @@ static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
 			     region_cnt);
 	if (ret) {
 		for (i = 0; i < region_cnt; i++)
-			hem_list_free_all(hr_dev, &head.branch[i], false);
+			hem_list_free_all(hr_dev, &head.branch[i]);
 
-		hem_list_free_all(hr_dev, &head.root, true);
+		hem_list_free_all(hr_dev, &head.root);
 	}
 
 	return ret;
@@ -1457,10 +1473,9 @@ void hns_roce_hem_list_release(struct hns_roce_dev *hr_dev,
 
 	for (i = 0; i < HNS_ROCE_MAX_BT_REGION; i++)
 		for (j = 0; j < HNS_ROCE_MAX_BT_LEVEL; j++)
-			hem_list_free_all(hr_dev, &hem_list->mid_bt[i][j],
-					  j != 0);
+			hem_list_free_all(hr_dev, &hem_list->mid_bt[i][j]);
 
-	hem_list_free_all(hr_dev, &hem_list->root_bt, true);
+	hem_list_free_all(hr_dev, &hem_list->root_bt);
 	INIT_LIST_HEAD(&hem_list->btm_bt);
 	hem_list->root_ba = 0;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index acdcd5c9f42f..408ef2a96149 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -767,11 +767,6 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 	for (i = 0, mapped_cnt = 0; i < mtr->hem_cfg.region_count &&
 	     mapped_cnt < page_cnt; i++) {
 		r = &mtr->hem_cfg.region[i];
-		/* if hopnum is 0, no need to map pages in this region */
-		if (!r->hopnum) {
-			mapped_cnt += r->count;
-			continue;
-		}
 
 		if (r->offset + r->count > page_cnt) {
 			ret = -EINVAL;
-- 
2.39.5



