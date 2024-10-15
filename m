Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06391C07E0;
	Tue, 15 Oct 2024 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997416; cv=none; b=NIu6yTpS1SYYLIpcJQX3noYQjk8tzjfg9ZRrrWOD7kcVANt4xJAYcRHgOI/02IHknHOzphSTEHzV3zRilLoweECbpxeSuOY0FgQaTDWmYt3t3kfKapnhI8P05gcDJC4mUY55gkGMfUQiw0am+nnu6m6fA72RRt8qKucSQeP0oEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997416; c=relaxed/simple;
	bh=WcdQe7MWO//di2sDU4BfJIwaHc41Pzi7qUbe1t5j0aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXQ5PCXRfipUBN7zqb6m5mfvth8y0RPd0ui8A0jmnc9S3/NR6Xgh+dWNWpGVRiXmaLBVYhGCb1HrfjK2+2eltGdaya0/6WUEL5lD4PJfeTyKpUqJfU17GlVFgK5Nzu53/qL9k2m8gAcpRLRz7/tnJHRTIxskjdgiX9Di3YH8FJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/gk3m2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/gk3m2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327E7C4CEC6;
	Tue, 15 Oct 2024 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997415;
	bh=WcdQe7MWO//di2sDU4BfJIwaHc41Pzi7qUbe1t5j0aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/gk3m2H/eRzICASC5qRFSHUF8DwZ5OhFPtNBKbFrrtNe3LgpsHzEE2kR+CXQx0Ng
	 LlWwmrQwHpEVzyCoOiqSVr7kVB9UMKWvAJwweDJNYadDWKPxVYyJWJEeICi3UOeUwi
	 3FcctQse1RNd778sixfk/K1/I7pZa+APv3TZ9SZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Wang <wangxi11@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/518] RDMA/hns: Refactor root BT allocation for MTR
Date: Tue, 15 Oct 2024 14:41:20 +0200
Message-ID: <20241015123923.784811087@linuxfoundation.org>
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

[ Upstream commit 1f704d8cc07269f31daf9bdafe84882ad7596a2c ]

Split the hem_list_alloc_root_bt() into serval small functions to make the
code flow more clear.

Link: https://lore.kernel.org/r/1621589395-2435-3-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d586628b169d ("RDMA/hns: Fix the overflow risk of hem_list_calc_ba_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 230 ++++++++++++++---------
 1 file changed, 146 insertions(+), 84 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index fa920a7621eef..120d299bfe2ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -959,7 +959,7 @@ void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev)
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtpt_table);
 }
 
-struct roce_hem_item {
+struct hns_roce_hem_item {
 	struct list_head list; /* link all hems in the same bt level */
 	struct list_head sibling; /* link all hems in last hop for mtt */
 	void *addr;
@@ -969,12 +969,18 @@ struct roce_hem_item {
 	int end; /* end buf offset in this hem */
 };
 
-static struct roce_hem_item *hem_list_alloc_item(struct hns_roce_dev *hr_dev,
-						   int start, int end,
-						   int count, bool exist_bt,
-						   int bt_level)
+/* All HEM items are linked in a tree structure */
+struct hns_roce_hem_head {
+	struct list_head branch[HNS_ROCE_MAX_BT_REGION];
+	struct list_head root;
+	struct list_head leaf;
+};
+
+static struct hns_roce_hem_item *
+hem_list_alloc_item(struct hns_roce_dev *hr_dev, int start, int end, int count,
+		    bool exist_bt, int bt_level)
 {
-	struct roce_hem_item *hem;
+	struct hns_roce_hem_item *hem;
 
 	hem = kzalloc(sizeof(*hem), GFP_KERNEL);
 	if (!hem)
@@ -999,7 +1005,7 @@ static struct roce_hem_item *hem_list_alloc_item(struct hns_roce_dev *hr_dev,
 }
 
 static void hem_list_free_item(struct hns_roce_dev *hr_dev,
-			       struct roce_hem_item *hem, bool exist_bt)
+			       struct hns_roce_hem_item *hem, bool exist_bt)
 {
 	if (exist_bt)
 		dma_free_coherent(hr_dev->dev, hem->count * BA_BYTE_LEN,
@@ -1010,7 +1016,7 @@ static void hem_list_free_item(struct hns_roce_dev *hr_dev,
 static void hem_list_free_all(struct hns_roce_dev *hr_dev,
 			      struct list_head *head, bool exist_bt)
 {
-	struct roce_hem_item *hem, *temp_hem;
+	struct hns_roce_hem_item *hem, *temp_hem;
 
 	list_for_each_entry_safe(hem, temp_hem, head, list) {
 		list_del(&hem->list);
@@ -1026,24 +1032,24 @@ static void hem_list_link_bt(struct hns_roce_dev *hr_dev, void *base_addr,
 
 /* assign L0 table address to hem from root bt */
 static void hem_list_assign_bt(struct hns_roce_dev *hr_dev,
-			       struct roce_hem_item *hem, void *cpu_addr,
+			       struct hns_roce_hem_item *hem, void *cpu_addr,
 			       u64 phy_addr)
 {
 	hem->addr = cpu_addr;
 	hem->dma_addr = (dma_addr_t)phy_addr;
 }
 
-static inline bool hem_list_page_is_in_range(struct roce_hem_item *hem,
+static inline bool hem_list_page_is_in_range(struct hns_roce_hem_item *hem,
 					     int offset)
 {
 	return (hem->start <= offset && offset <= hem->end);
 }
 
-static struct roce_hem_item *hem_list_search_item(struct list_head *ba_list,
-						    int page_offset)
+static struct hns_roce_hem_item *hem_list_search_item(struct list_head *ba_list,
+						      int page_offset)
 {
-	struct roce_hem_item *hem, *temp_hem;
-	struct roce_hem_item *found = NULL;
+	struct hns_roce_hem_item *hem, *temp_hem;
+	struct hns_roce_hem_item *found = NULL;
 
 	list_for_each_entry_safe(hem, temp_hem, ba_list, list) {
 		if (hem_list_page_is_in_range(hem, page_offset)) {
@@ -1133,9 +1139,9 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 				 int offset, struct list_head *mid_bt,
 				 struct list_head *btm_bt)
 {
-	struct roce_hem_item *hem_ptrs[HNS_ROCE_MAX_BT_LEVEL] = { NULL };
+	struct hns_roce_hem_item *hem_ptrs[HNS_ROCE_MAX_BT_LEVEL] = { NULL };
 	struct list_head temp_list[HNS_ROCE_MAX_BT_LEVEL];
-	struct roce_hem_item *cur, *pre;
+	struct hns_roce_hem_item *cur, *pre;
 	const int hopnum = r->hopnum;
 	int start_aligned;
 	int distance;
@@ -1213,56 +1219,96 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
-				  struct hns_roce_hem_list *hem_list, int unit,
-				  const struct hns_roce_buf_region *regions,
-				  int region_cnt)
+static struct hns_roce_hem_item *
+alloc_root_hem(struct hns_roce_dev *hr_dev, int unit, int *max_ba_num,
+	       const struct hns_roce_buf_region *regions, int region_cnt)
 {
-	struct list_head temp_list[HNS_ROCE_MAX_BT_REGION];
-	struct roce_hem_item *hem, *temp_hem, *root_hem;
 	const struct hns_roce_buf_region *r;
-	struct list_head temp_root;
-	struct list_head temp_btm;
-	void *cpu_base;
-	u64 phy_base;
-	int ret = 0;
+	struct hns_roce_hem_item *hem;
 	int ba_num;
 	int offset;
-	int total;
-	int step;
-	int i;
-
-	r = &regions[0];
-	root_hem = hem_list_search_item(&hem_list->root_bt, r->offset);
-	if (root_hem)
-		return 0;
 
 	ba_num = hns_roce_hem_list_calc_root_ba(regions, region_cnt, unit);
 	if (ba_num < 1)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (ba_num > unit)
-		return -ENOBUFS;
+		return ERR_PTR(-ENOBUFS);
 
-	ba_num = min_t(int, ba_num, unit);
-	INIT_LIST_HEAD(&temp_root);
-	offset = r->offset;
+	offset = regions[0].offset;
 	/* indicate to last region */
 	r = &regions[region_cnt - 1];
-	root_hem = hem_list_alloc_item(hr_dev, offset, r->offset + r->count - 1,
-				       ba_num, true, 0);
-	if (!root_hem)
+	hem = hem_list_alloc_item(hr_dev, offset, r->offset + r->count - 1,
+				  ba_num, true, 0);
+	if (!hem)
+		return ERR_PTR(-ENOMEM);
+
+	*max_ba_num = ba_num;
+
+	return hem;
+}
+
+static int alloc_fake_root_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
+			      u64 phy_base, const struct hns_roce_buf_region *r,
+			      struct list_head *branch_head,
+			      struct list_head *leaf_head)
+{
+	struct hns_roce_hem_item *hem;
+
+	hem = hem_list_alloc_item(hr_dev, r->offset, r->offset + r->count - 1,
+				  r->count, false, 0);
+	if (!hem)
 		return -ENOMEM;
-	list_add(&root_hem->list, &temp_root);
 
-	hem_list->root_ba = root_hem->dma_addr;
+	hem_list_assign_bt(hr_dev, hem, cpu_base, phy_base);
+	list_add(&hem->list, branch_head);
+	list_add(&hem->sibling, leaf_head);
 
-	INIT_LIST_HEAD(&temp_btm);
-	for (i = 0; i < region_cnt; i++)
-		INIT_LIST_HEAD(&temp_list[i]);
+	return r->count;
+}
+
+static int setup_middle_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
+			   int unit, const struct hns_roce_buf_region *r,
+			   const struct list_head *branch_head)
+{
+	struct hns_roce_hem_item *hem, *temp_hem;
+	int total = 0;
+	int offset;
+	int step;
+
+	step = hem_list_calc_ba_range(r->hopnum, 1, unit);
+	if (step < 1)
+		return -EINVAL;
+
+	/* if exist mid bt, link L1 to L0 */
+	list_for_each_entry_safe(hem, temp_hem, branch_head, list) {
+		offset = (hem->start - r->offset) / step * BA_BYTE_LEN;
+		hem_list_link_bt(hr_dev, cpu_base + offset, hem->dma_addr);
+		total++;
+	}
+
+	return total;
+}
+
+static int
+setup_root_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem_list *hem_list,
+	       int unit, int max_ba_num, struct hns_roce_hem_head *head,
+	       const struct hns_roce_buf_region *regions, int region_cnt)
+{
+	const struct hns_roce_buf_region *r;
+	struct hns_roce_hem_item *root_hem;
+	void *cpu_base;
+	u64 phy_base;
+	int i, total;
+	int ret;
+
+	root_hem = list_first_entry(&head->root,
+				    struct hns_roce_hem_item, list);
+	if (!root_hem)
+		return -ENOMEM;
 
 	total = 0;
-	for (i = 0; i < region_cnt && total < ba_num; i++) {
+	for (i = 0; i < region_cnt && total < max_ba_num; i++) {
 		r = &regions[i];
 		if (!r->count)
 			continue;
@@ -1274,48 +1320,64 @@ static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
 		/* if hopnum is 0 or 1, cut a new fake hem from the root bt
 		 * which's address share to all regions.
 		 */
-		if (hem_list_is_bottom_bt(r->hopnum, 0)) {
-			hem = hem_list_alloc_item(hr_dev, r->offset,
-						  r->offset + r->count - 1,
-						  r->count, false, 0);
-			if (!hem) {
-				ret = -ENOMEM;
-				goto err_exit;
-			}
-			hem_list_assign_bt(hr_dev, hem, cpu_base, phy_base);
-			list_add(&hem->list, &temp_list[i]);
-			list_add(&hem->sibling, &temp_btm);
-			total += r->count;
-		} else {
-			step = hem_list_calc_ba_range(r->hopnum, 1, unit);
-			if (step < 1) {
-				ret = -EINVAL;
-				goto err_exit;
-			}
-			/* if exist mid bt, link L1 to L0 */
-			list_for_each_entry_safe(hem, temp_hem,
-					  &hem_list->mid_bt[i][1], list) {
-				offset = (hem->start - r->offset) / step *
-					  BA_BYTE_LEN;
-				hem_list_link_bt(hr_dev, cpu_base + offset,
-						 hem->dma_addr);
-				total++;
-			}
-		}
+		if (hem_list_is_bottom_bt(r->hopnum, 0))
+			ret = alloc_fake_root_bt(hr_dev, cpu_base, phy_base, r,
+						 &head->branch[i], &head->leaf);
+		else
+			ret = setup_middle_bt(hr_dev, cpu_base, unit, r,
+					      &hem_list->mid_bt[i][1]);
+
+		if (ret < 0)
+			return ret;
+
+		total += ret;
 	}
 
-	list_splice(&temp_btm, &hem_list->btm_bt);
-	list_splice(&temp_root, &hem_list->root_bt);
+	list_splice(&head->leaf, &hem_list->btm_bt);
+	list_splice(&head->root, &hem_list->root_bt);
 	for (i = 0; i < region_cnt; i++)
-		list_splice(&temp_list[i], &hem_list->mid_bt[i][0]);
+		list_splice(&head->branch[i], &hem_list->mid_bt[i][0]);
 
 	return 0;
+}
 
-err_exit:
+static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
+				  struct hns_roce_hem_list *hem_list, int unit,
+				  const struct hns_roce_buf_region *regions,
+				  int region_cnt)
+{
+	struct hns_roce_hem_item *root_hem;
+	struct hns_roce_hem_head head;
+	int max_ba_num;
+	int ret;
+	int i;
+
+	root_hem = hem_list_search_item(&hem_list->root_bt, regions[0].offset);
+	if (root_hem)
+		return 0;
+
+	max_ba_num = 0;
+	root_hem = alloc_root_hem(hr_dev, unit, &max_ba_num, regions,
+				  region_cnt);
+	if (IS_ERR(root_hem))
+		return PTR_ERR(root_hem);
+
+	/* List head for storing all allocated HEM items */
+	INIT_LIST_HEAD(&head.root);
+	INIT_LIST_HEAD(&head.leaf);
 	for (i = 0; i < region_cnt; i++)
-		hem_list_free_all(hr_dev, &temp_list[i], false);
+		INIT_LIST_HEAD(&head.branch[i]);
 
-	hem_list_free_all(hr_dev, &temp_root, true);
+	hem_list->root_ba = root_hem->dma_addr;
+	list_add(&root_hem->list, &head.root);
+	ret = setup_root_hem(hr_dev, hem_list, unit, max_ba_num, &head, regions,
+			     region_cnt);
+	if (ret) {
+		for (i = 0; i < region_cnt; i++)
+			hem_list_free_all(hr_dev, &head.branch[i], false);
+
+		hem_list_free_all(hr_dev, &head.root, true);
+	}
 
 	return ret;
 }
@@ -1401,7 +1463,7 @@ void *hns_roce_hem_list_find_mtt(struct hns_roce_dev *hr_dev,
 				 int offset, int *mtt_cnt, u64 *phy_addr)
 {
 	struct list_head *head = &hem_list->btm_bt;
-	struct roce_hem_item *hem, *temp_hem;
+	struct hns_roce_hem_item *hem, *temp_hem;
 	void *cpu_base = NULL;
 	u64 phy_base = 0;
 	int nr = 0;
-- 
2.43.0



