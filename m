Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6892676D5;
	Tue, 25 Mar 2025 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905776; cv=none; b=FPOmYNjbspMhELJuxAkiXNUf5RAPbo8rTXpB8LVP8lY4GSQ8LWg/Icl71yovqUWxcE4mA9uF09qPBi2igKbRhR04j9jPwTKDgs3WLF+dO+Uw1GJCM8eHMOw57qsDzoROixkRUMJzphravywba2qZDGfWilUI6G6due8af73CkmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905776; c=relaxed/simple;
	bh=zMkUjy3U/+G4tOGe7aajwFz15m8L3WAi2Zt81EuqYoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTvecNb99ERT3A2FciLXyCMxdwWeQeURLDawbAu6FNHQGeHamP1XZDcdxJvTIdudsimNRuypJd+6DgKXT41EXojqiSXWCh0yAfJTYySVbUZW2NopUpryAFRCh1pNnqB8ZxU6xhoaL632cBsNHItmuocgp2nJCeS2FMm0FBrgVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgn3oec2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgn3oec2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EFDC4CEE9;
	Tue, 25 Mar 2025 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905776;
	bh=zMkUjy3U/+G4tOGe7aajwFz15m8L3WAi2Zt81EuqYoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgn3oec2RE0WIuIAOw2ItLLCGiuEPDQXFETKZBs/S+t2oamz7txzFvrI1y4OhTJZG
	 NNmTT/b5zGJT7uji18S5iu/jRTrJcDKZ8a8w+codi1mjXOjUwx3iywlGZONl4Ewvph
	 UFSxGU0ceO2zrNkfQ5xAA7C0DGfEmAD9w+vaqViA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/198] RDMA/hns: Fix soft lockup during bt pages loop
Date: Tue, 25 Mar 2025 08:21:59 -0400
Message-ID: <20250325122200.775287490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 25655580136de59ec89f09089dd28008ea440fc9 ]

Driver runs a for-loop when allocating bt pages and mapping them with
buffer pages. When a large buffer (e.g. MR over 100GB) is being allocated,
it may require a considerable loop count. This will lead to soft lockup:

        watchdog: BUG: soft lockup - CPU#27 stuck for 22s!
        ...
        Call trace:
         hem_list_alloc_mid_bt+0x124/0x394 [hns_roce_hw_v2]
         hns_roce_hem_list_request+0xf8/0x160 [hns_roce_hw_v2]
         hns_roce_mtr_create+0x2e4/0x360 [hns_roce_hw_v2]
         alloc_mr_pbl+0xd4/0x17c [hns_roce_hw_v2]
         hns_roce_reg_user_mr+0xf8/0x190 [hns_roce_hw_v2]
         ib_uverbs_reg_mr+0x118/0x290

        watchdog: BUG: soft lockup - CPU#35 stuck for 23s!
        ...
        Call trace:
         hns_roce_hem_list_find_mtt+0x7c/0xb0 [hns_roce_hw_v2]
         mtr_map_bufs+0xc4/0x204 [hns_roce_hw_v2]
         hns_roce_mtr_create+0x31c/0x3c4 [hns_roce_hw_v2]
         alloc_mr_pbl+0xb0/0x160 [hns_roce_hw_v2]
         hns_roce_reg_user_mr+0x108/0x1c0 [hns_roce_hw_v2]
         ib_uverbs_reg_mr+0x120/0x2bc

Add a cond_resched() to fix soft lockup during these loops. In order not
to affect the allocation performance of normal-size buffer, set the loop
count of a 100GB MR as the threshold to call cond_resched().

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index f1de497fc977c..173ab794fa780 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1416,6 +1416,11 @@ static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+/* This is the bottom bt pages number of a 100G MR on 4K OS, assuming
+ * the bt page size is not expanded by cal_best_bt_pg_sz()
+ */
+#define RESCHED_LOOP_CNT_THRESHOLD_ON_4K 12800
+
 /* construct the base address table and link them by address hop config */
 int hns_roce_hem_list_request(struct hns_roce_dev *hr_dev,
 			      struct hns_roce_hem_list *hem_list,
@@ -1424,6 +1429,7 @@ int hns_roce_hem_list_request(struct hns_roce_dev *hr_dev,
 {
 	const struct hns_roce_buf_region *r;
 	int ofs, end;
+	int loop;
 	int unit;
 	int ret;
 	int i;
@@ -1441,7 +1447,10 @@ int hns_roce_hem_list_request(struct hns_roce_dev *hr_dev,
 			continue;
 
 		end = r->offset + r->count;
-		for (ofs = r->offset; ofs < end; ofs += unit) {
+		for (ofs = r->offset, loop = 1; ofs < end; ofs += unit, loop++) {
+			if (!(loop % RESCHED_LOOP_CNT_THRESHOLD_ON_4K))
+				cond_resched();
+
 			ret = hem_list_alloc_mid_bt(hr_dev, r, unit, ofs,
 						    hem_list->mid_bt[i],
 						    &hem_list->btm_bt);
@@ -1498,9 +1507,14 @@ void *hns_roce_hem_list_find_mtt(struct hns_roce_dev *hr_dev,
 	struct list_head *head = &hem_list->btm_bt;
 	struct hns_roce_hem_item *hem, *temp_hem;
 	void *cpu_base = NULL;
+	int loop = 1;
 	int nr = 0;
 
 	list_for_each_entry_safe(hem, temp_hem, head, sibling) {
+		if (!(loop % RESCHED_LOOP_CNT_THRESHOLD_ON_4K))
+			cond_resched();
+		loop++;
+
 		if (hem_list_page_is_in_range(hem, offset)) {
 			nr = offset - hem->start;
 			cpu_base = hem->addr + nr * BA_BYTE_LEN;
-- 
2.39.5



