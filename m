Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D025B17E90E;
	Mon, 27 May 2024 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837227; cv=none; b=ZKpNbk0oCP0qN5/QMIhHtXZHzbU/9i0hO4PjY8fYQZWzWejCJHHBU5zOc3xAoUlvQKVuSmfY/pMJ8ewnoMeavnTgkenp2+HlMXlhqtc8NxrT9qYESwI5uNj0pEsjMeZ0TjXDgWQsqTpSWPJcudrxVQdGYWv2HJzNlPvrOHQ9qyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837227; c=relaxed/simple;
	bh=BPvyz3XTYiCbcyBrVS9kXwhs4l0158vhZ4LtuivgxDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsiezPRVGCHm+u7Fkd3Fw5wN9ljZEgjwND6Tk7Lo62qTAisaOkMZ4jDcWQsNZwaHJqeILowVB61Mot6julTn1lAwF6wENN+sFQzfKqL5zspk+H7b1weOYssSPivrHe4PYnFMDr4k5K0I4pOSu23h3Im3Y+Xni+rt2h5DIPg+qfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tb3CSdko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tb3CSdko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64070C2BBFC;
	Mon, 27 May 2024 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837227;
	bh=BPvyz3XTYiCbcyBrVS9kXwhs4l0158vhZ4LtuivgxDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tb3CSdkocLAUXgg7hM/h9XIUUiEEiHhzf7RYxrK+2kOyv2/2ooFIdZrm3v5z7aWyN
	 0hrgP5s++UAgPoRnUCE5+7C36ml2uHYe9WAmPas9MMUrG2+kyC26bUJfNj10jkXLP8
	 ZCtxOYU4MHMxDH4KbDshDX8TQfUj8VQsIzCmzA7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 357/427] RDMA/hns: Fix UAF for cq async event
Date: Mon, 27 May 2024 20:56:44 +0200
Message-ID: <20240527185633.738348566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 7250d0643b5c5..68e22f368d43a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -149,7 +149,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		return ret;
 	}
 
-	ret = xa_err(xa_store(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to xa_store CQ, ret = %d.\n", ret);
 		goto err_put;
@@ -163,7 +163,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	return 0;
 
 err_xa:
-	xa_erase(&cq_table->array, hr_cq->cqn);
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 err_put:
 	hns_roce_table_put(hr_dev, &cq_table->table, hr_cq->cqn);
 
@@ -182,7 +182,7 @@ static void free_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 		dev_err(dev, "DESTROY_CQ failed (%d) for CQN %06lx\n", ret,
 			hr_cq->cqn);
 
-	xa_erase(&cq_table->array, hr_cq->cqn);
+	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 
 	/* Waiting interrupt process procedure carried out */
 	synchronize_irq(hr_dev->eq_table.eq[hr_cq->vector].irq);
@@ -476,13 +476,6 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
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
@@ -491,7 +484,16 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
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



