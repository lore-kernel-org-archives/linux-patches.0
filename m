Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C24415F14;
	Tue, 21 Jul 2026 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661679; cv=none; b=JyablPy2tDhlPSmwCXGdrpvBV83DPwnEgEIlXUWzQPkPKidMcAMi6V6N1ERsQP8cwp6pz70LPcaoeXuerm58tAwGf/5KipfKDrpUfaWx96o3H6lY8+q4cKQqoCyLuJIPBkJ+EtCHFYQSsFSprOx4q6e/ldAfsPEJwtPi+b/0vvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661679; c=relaxed/simple;
	bh=8qOXvJJ1Hgqq2Ke1fLIrRn7BNZbCB1YHAvzz4IU7IkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjEAv9Fx7iYmJ+/3cNGCjJPoIcZL/vvzO8tsAqr6hTK1tzWNK899bLrSxHUq5NlDJuSy4+nX5WIG0S1jF1DHgntxr+V93J3AS2IbRwyGV3HRx/i5ys5TOuoAZv6B3de4P+MoNg5nBwFxrxPu1h5NKws8Opcv0KfeCXJyAV1Wmqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulEbOONp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulEbOONp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5213C1F000E9;
	Tue, 21 Jul 2026 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661677;
	bh=92iULYjT8L/u3BT1mz+7T84wugaR/KMw3AWpGjjcbJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulEbOONpvYRsjV6tWxJqBaL3j1gkMX4218jM3hSFSgaeUSNoDFCXnbOIX9sBRgCwT
	 4sN3IeIRzGecKK9vxQbtOeo0ktEz/RT++02xJsHJeK1Mk9DKORvtntLHr+NwXxgT+8
	 nKWcQXhLKK5gBjp2Swu2qZw9f5+izqjXyboSgOLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianfa Weng <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0157/1276] RDMA/hns: Fix log flood after cmd_mbox failure
Date: Tue, 21 Jul 2026 17:10:00 +0200
Message-ID: <20260721152449.614062548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianfa Weng <wenglianfa@huawei.com>

[ Upstream commit bbd97d71e53e551890e4115ad9de46b5f2ac0858 ]

hns_roce_cmd_mbox() is the command interface between driver and
hardware. When hardware is abnormal, the unlimited error printings
after hns_roce_cmd_mbox() failure will cause log flood and even
system crash.

Replace ibdev_err() and ibdev_warn() with their ratelimited versions
in the error handling path after hns_roce_cmd_mbox() (and its wrappers
hns_roce_create_hw_ctx/hns_roce_destroy_hw_ctx) fails.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://patch.msgid.link/r/20260520055759.2354037-4-huangjunxian6@hisilicon.com
Signed-off-by: Lianfa Weng <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c    |  6 +++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 18 +++++++++---------
 drivers/infiniband/hw/hns/hns_roce_mr.c    |  6 +++---
 drivers/infiniband/hw/hns/hns_roce_srq.c   |  2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 6aa82fe9dd3dfb..150f5052d0b019 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -171,9 +171,9 @@ static int hns_roce_create_cqc(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_CQC,
 				     hr_cq->cqn);
 	if (ret)
-		ibdev_err(ibdev,
-			  "failed to send create cmd for CQ(0x%lx), ret = %d.\n",
-			  hr_cq->cqn, ret);
+		ibdev_err_ratelimited(ibdev,
+				      "failed to send create cmd for CQ(0x%lx), ret = %d.\n",
+				      hr_cq->cqn, ret);
 
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5e1ea6335c1130..a54f86468b0530 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5972,9 +5972,9 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 					HNS_ROCE_CMD_MODIFY_SRQC, srq->srqn);
 		hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 		if (ret)
-			ibdev_err(&hr_dev->ib_dev,
-				  "failed to handle cmd of modifying SRQ, ret = %d.\n",
-				  ret);
+			ibdev_err_ratelimited(&hr_dev->ib_dev,
+					      "failed to handle cmd of modifying SRQ, ret = %d.\n",
+					      ret);
 	}
 
 out:
@@ -6000,9 +6000,9 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma,
 				HNS_ROCE_CMD_QUERY_SRQC, srq->srqn);
 	if (ret) {
-		ibdev_err(&hr_dev->ib_dev,
-			  "failed to process cmd of querying SRQ, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(&hr_dev->ib_dev,
+				      "failed to process cmd of querying SRQ, ret = %d.\n",
+				      ret);
 		goto out;
 	}
 
@@ -6108,9 +6108,9 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
 	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma, HNS_ROCE_CMD_QUERY_MPT,
 				key_to_hw_index(key));
 	if (ret) {
-		ibdev_err(&hr_dev->ib_dev,
-			  "failed to process cmd when querying MPT, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(&hr_dev->ib_dev,
+				      "failed to process cmd when querying MPT, ret = %d.\n",
+				      ret);
 		goto err_mailbox;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index f86859ffb413ec..4ce9b46eb6bd83 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -171,7 +171,7 @@ static int hns_roce_mr_enable(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx & (hr_dev->caps.num_mtpts - 1));
 	if (ret) {
-		dev_err(dev, "failed to create mpt, ret = %d.\n", ret);
+		dev_err_ratelimited(dev, "failed to create mpt, ret = %d.\n", ret);
 		goto err_page;
 	}
 
@@ -311,7 +311,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_MPT,
 				      mtpt_idx);
 	if (ret)
-		ibdev_warn(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
+		ibdev_warn_ratelimited(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
 
 	mr->enabled = 0;
 	mr->iova = virt_addr;
@@ -342,7 +342,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx);
 	if (ret) {
-		ibdev_err(ib_dev, "failed to create MPT, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ib_dev, "failed to create MPT, ret = %d.\n", ret);
 		goto free_cmd_mbox;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 70c06ef65603d8..314a879f1c5e71 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -104,7 +104,7 @@ static int hns_roce_create_srqc(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_SRQ,
 				     srq->srqn);
 	if (ret)
-		ibdev_err(ibdev, "failed to config SRQC, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ibdev, "failed to config SRQC, ret = %d.\n", ret);
 
 err_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
-- 
2.53.0



