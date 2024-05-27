Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EC262BE;
	Mon, 27 May 2024 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838533; cv=none; b=juB+uOkG1z7NHtDxkrytjWWfMiEBMoUfIHiHWiF3IseV15+qYWHz1fVorbieLmh+JK1wBoihZXu5vzWqEqaY0peC3ZC69lKVLJtuF7g1K4G7M2gdnSkh/FlwMxw+OGnDK3s4o6Pc7DyFLtU4tcsj2md/Sb/UW8erwSxqslMDh5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838533; c=relaxed/simple;
	bh=jl/kVG5ik7DVu5TEW+tV0hAVyaKJ2vv2KJ2eRr8vYgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3bh96rpDgX+XXLk+6ZuERyMH43H4cp/1Qi8Q4bhtvWpu4n7iY0UnMA2lPmRSdu74bA4l7w0MJAS0mZ7eMNINvDGSiu9t9AUcaUAMrKfsdcmdIWcn3OlTQmQZf4tmRpG702vgC5x6GlXXfcVBEtcP8Z+vT0uhJyLlFLlSpe3lm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8n4jKHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8n4jKHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA459C2BBFC;
	Mon, 27 May 2024 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838532;
	bh=jl/kVG5ik7DVu5TEW+tV0hAVyaKJ2vv2KJ2eRr8vYgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8n4jKHgSUi+AFvyabkdhC+mBMP0yiD/l/esHmRmkkNxNdUHUIzw2T1M6nFZIofxr
	 daWBnQ2wySer8/bcaGsh64kmohMz7/EjDVfd9YK/NcmHalE93377mlDMxzVp32/SYe
	 3iYier4XCYeTEJew2xegfFnOToIHOozFRjjOSBpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 428/493] RDMA/hns: Fix UAF for cq async event
Date: Mon, 27 May 2024 20:57:10 +0200
Message-ID: <20240527185644.282115144@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1b6d16af8c12b..2517c972c651a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -151,7 +151,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		return ret;
 	}
 
-	ret = xa_err(xa_store(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to xa_store CQ, ret = %d.\n", ret);
 		goto err_put;
@@ -164,7 +164,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	return 0;
 
 err_xa:
-	xa_erase(&cq_table->array, hr_cq->cqn);
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 err_put:
 	hns_roce_table_put(hr_dev, &cq_table->table, hr_cq->cqn);
 
@@ -183,7 +183,7 @@ static void free_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		dev_err(dev, "DESTROY_CQ failed (%d) for CQN %06lx\n", ret,
 			hr_cq->cqn);
 
-	xa_erase(&cq_table->array, hr_cq->cqn);
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 
 	/* Waiting interrupt process procedure carried out */
 	synchronize_irq(hr_dev->eq_table.eq[hr_cq->vector].irq);
@@ -477,13 +477,6 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
 	struct ib_event event;
 	struct ib_cq *ibcq;
 
-	hr_cq = xa_load(&hr_dev->cq_table.array,
-			cqn & (hr_dev->caps.num_cqs - 1));
-	if (!hr_cq) {
-		dev_warn(dev, "async event for bogus CQ 0x%06x\n", cqn);
-		return;
-	}
-
 	if (event_type != HNS_ROCE_EVENT_TYPE_CQ_ID_INVALID &&
 	    event_type != HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR &&
 	    event_type != HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW) {
@@ -492,7 +485,16 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
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



