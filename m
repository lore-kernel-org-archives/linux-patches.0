Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568981AA7;
	Thu, 13 Jun 2024 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282147; cv=none; b=SC421dcNJQ5iSx3m0X/kS/dOAFnsm+d2m6PpCcwswEdGbCREgAEJ65NlQ7JfBMAEov9YE+cO7hrDdIkP6Xyr6d3R4m5Gpb9kK/eG/C9YUUe1dH1sLKJZRJO8FgZmO0cV5BeQJendguU1SvJlkNrQ4UBwNIRvLGUVaPYQz58OBBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282147; c=relaxed/simple;
	bh=CmuhLatDumZWdadFC27igZ9Nli0A6V7+t3PX214UgW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb7ThZ5qRgdo92xNDIK3NkDpVTIzawhDvBRnbJrauKOD+OQ1a8/1s93Z66SsPN434B28mhkjNz3yR5aqdR1K2myHme55G+6Tg/OC841BA1HV2mnFWMdVkSIyudPLsEK4TwPILe6nZzcCXrxqpzYZEXo39mJGZuJiNfJFZm8Hv0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlEqE4uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlEqE4uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1ECC2BBFC;
	Thu, 13 Jun 2024 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282147;
	bh=CmuhLatDumZWdadFC27igZ9Nli0A6V7+t3PX214UgW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlEqE4uLXGq+KESkBi4sAiXsylir3JufhTNxQ1Z8Y1L3YK1vogCblYalJoyn6C6z2
	 J33EatWsszo5pIS9+tBL1xJg7Cnzci1oh1eX+Gtz3GZFpdHkXzftY/itlGCXdo2oJb
	 eIwe5ui8brBqtYJ+G4xNxNszMnJWN3kiOM8FdL1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/402] RDMA/hns: Fix deadlock on SRQ async events.
Date: Thu, 13 Jun 2024 13:31:48 +0200
Message-ID: <20240613113308.026316709@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit b46494b6f9c19f141114a57729e198698f40af37 ]

xa_lock for SRQ table may be required in AEQ. Use xa_store_irq()/
xa_erase_irq() to avoid deadlock.

Fixes: 81fce6291d99 ("RDMA/hns: Add SRQ asynchronous event support")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 1 +
 drivers/infiniband/hw/hns/hns_roce_srq.c  | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 80b9a9a45c68e..e2d2f8f2bdbcf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -38,6 +38,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
+#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index e64ef6903fb4f..35001fb99b944 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -100,7 +100,7 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 		goto err_out;
 	}
 
-	ret = xa_err(xa_store(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to store SRQC, ret = %d.\n", ret);
 		goto err_put;
@@ -132,7 +132,7 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 err_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 err_xa:
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 err_put:
 	hns_roce_table_put(hr_dev, &srq_table->table, srq->srqn);
 err_out:
@@ -151,7 +151,7 @@ static void free_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 		dev_err(hr_dev->dev, "DESTROY_SRQ failed (%d) for SRQN %06lx\n",
 			ret, srq->srqn);
 
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 
 	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
-- 
2.43.0



