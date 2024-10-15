Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6051EBA0A;
	Tue, 15 Oct 2024 12:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994361; cv=none; b=SiLm+Z3NAtYBdj4z8Wxzl6uxuzjLo20NHvVz0uJFdHtt5mKE3Y4GpTGh5dKd5DMcobnKEF+OHYrbWnVU5u+dhME/7rFE5AA6iw29P3vdKEsmWzQjlMvYqLS7xBt6zznBYiWvr3Ze/i2NmmKirW+zwDJCwashro5sY1k6iB+/uAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994361; c=relaxed/simple;
	bh=qm2AubWSnIoUG+IvsoT/2e4S2HKseSSnTwbgnBjCP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GArToUE1VeBbxwUleJGD4XnMpetgGTbbcp9+kEZWtlznZonzc/GHBdtERZ20EV6SxIDWlCEnGbEIGPjQHAlzPLBc00XrhD28NltDYmoXpdIxR8fAGWIZA3MVLbqGgvSQexVmp+2heRbnvOoQVe/FllslLhhd7CkAX6rHfyxQzo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzLkm6jG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzLkm6jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73BC4CED3;
	Tue, 15 Oct 2024 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994361;
	bh=qm2AubWSnIoUG+IvsoT/2e4S2HKseSSnTwbgnBjCP8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzLkm6jGOolcAwBMF0v8Xg71OIfKe25nfhImNUk2ZwPfeIMisAUjG6pMgOg+QjZa8
	 6T3RcDhIjZV0/8zJVqy8WqZxldXE9DUb9OGGvujDpctwAVs9hR0yiOYYHJ9vNBp7NA
	 HcT9GEYPeYmzlv+pwZk27MlX+/Rp9oBSp3ZIcNrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Haixiao Yan <haixiao.yan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 659/691] RDMA/hns: Fix UAF for cq async event
Date: Tue, 15 Oct 2024 13:30:07 +0200
Message-ID: <20241015112506.479312278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit a942ec2745ca864cd8512142100e4027dc306a42 ]

The refcount of CQ is not protected by locks. When CQ asynchronous
events and CQ destruction are concurrent, CQ may have been released,
which will cause UAF.

Use the xa_lock() to protect the CQ refcount.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Haixiao Yan <haixiao.yan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index d763f097599ff..5ecd4075de937 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -125,7 +125,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		goto err_out;
 	}
 
-	ret = xa_err(xa_store(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to xa_store CQ, ret = %d.\n", ret);
 		goto err_put;
@@ -160,8 +160,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	return 0;
 
 err_xa:
-	xa_erase(&cq_table->array, hr_cq->cqn);
-
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 err_put:
 	hns_roce_table_put(hr_dev, &cq_table->table, hr_cq->cqn);
 
@@ -182,7 +181,7 @@ static void free_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		dev_err(dev, "DESTROY_CQ failed (%d) for CQN %06lx\n", ret,
 			hr_cq->cqn);
 
-	xa_erase(&cq_table->array, hr_cq->cqn);
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 
 	/* Waiting interrupt process procedure carried out */
 	synchronize_irq(hr_dev->eq_table.eq[hr_cq->vector].irq);
@@ -478,13 +477,6 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
 	struct ib_event event;
 	struct ib_cq *ibcq;
 
-	hr_cq = xa_load(&hr_dev->cq_table.array,
-			cqn & (hr_dev->caps.num_cqs - 1));
-	if (!hr_cq) {
-		dev_warn(dev, "Async event for bogus CQ 0x%06x\n", cqn);
-		return;
-	}
-
 	if (event_type != HNS_ROCE_EVENT_TYPE_CQ_ID_INVALID &&
 	    event_type != HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR &&
 	    event_type != HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW) {
@@ -493,7 +485,16 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
 		return;
 	}
 
-	refcount_inc(&hr_cq->refcount);
+	xa_lock(&hr_dev->cq_table.array);
+	hr_cq = xa_load(&hr_dev->cq_table.array,
+			cqn & (hr_dev->caps.num_cqs - 1));
+	if (hr_cq)
+		refcount_inc(&hr_cq->refcount);
+	xa_unlock(&hr_dev->cq_table.array);
+	if (!hr_cq) {
+		dev_warn(dev, "async event for bogus CQ 0x%06x\n", cqn);
+		return;
+	}
 
 	ibcq = &hr_cq->ib_cq;
 	if (ibcq->event_handler) {
-- 
2.43.0



