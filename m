Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D3198A35;
	Thu,  6 Jun 2024 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683395; cv=none; b=LUa5caFNqKLaI1wEumJekX9W5SSWqtx6LsI/KIQIxVY0WJZh7OLH1hKOzRaDWHZjIndL+Xz9WdLEiBNOaLx1/fuTHM8zrfJNYFoF+HP5kXgnMx6sxDITQTVQTE7WwW8+JrJtI/3f//ERyGDC1v70Ev9XmFDUVw8kFQ8R7WGQAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683395; c=relaxed/simple;
	bh=b8HBJz/y+mQ18Q3Um9C7nwqy3K7OFM//de6/DoPG7xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+x+jkTKvQ5WxglCFOQQHnPhDOfNBcMLI6d6hbfcu8PDrvCbfdiuc/SG9i7O1tTjZ6FwINmtJB98zMy7HAyUxMfMjjiIcUJ6fAyzJbR6hGDCRzWDnbEqsOEHGE8uU3hbVqbtQ3Qn4YEUboR3+55ynySSNbZ9c3JXB16sIRPDeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4o6iml/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4o6iml/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B09C2BD10;
	Thu,  6 Jun 2024 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683395;
	bh=b8HBJz/y+mQ18Q3Um9C7nwqy3K7OFM//de6/DoPG7xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4o6iml/IEDTWuLVerUrs2FO4uX6N77AhKt7BaDcwwuMYmTYzIGuMjvK7O04Jk1ei
	 2Ud0+JqVZryLCWut01HzGLtVQsJCNWolGbz+g0rsCUFjP3yvG1bmOZhop3FfKjTn7g
	 XkZ/8hS2FUjK1LsEf5llP1lSIOzGjdcq0YnpbMPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/744] RDMA/hns: Fix deadlock on SRQ async events.
Date: Thu,  6 Jun 2024 16:00:12 +0200
Message-ID: <20240606131743.372350853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a9cd4d21bc99..c8c49110a3378 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,6 +37,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
+#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 8dae98f827eb2..6a4923c21cbc6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -122,7 +122,7 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 		return ret;
 	}
 
-	ret = xa_err(xa_store(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to store SRQC, ret = %d.\n", ret);
 		goto err_put;
@@ -135,7 +135,7 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 	return 0;
 
 err_xa:
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 err_put:
 	hns_roce_table_put(hr_dev, &srq_table->table, srq->srqn);
 
@@ -153,7 +153,7 @@ static void free_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 		dev_err(hr_dev->dev, "DESTROY_SRQ failed (%d) for SRQN %06lx\n",
 			ret, srq->srqn);
 
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 
 	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
-- 
2.43.0



