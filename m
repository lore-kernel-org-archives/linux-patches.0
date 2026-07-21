Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AEA31F99C;
	Tue, 21 Jul 2026 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648721; cv=none; b=TFAF2M44XbRBd4s5o7Ux+u1TrG9mGeSm0wl2KThOuh2XXik11u9lPl7X+KLU/1jV360S0QV/nolc2D3BX8KeNKAEyyIRE1Y7EdTBVc/7MbdiyM+ftS86LZsJiK3cHZR0FjTLVnjNMqcczT0XPz0TLPLZCABRAEloh1PtvU29m9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648721; c=relaxed/simple;
	bh=tmOZrSVQAAcDlumOl5SSSKCyFQbQ5DF9llk9jp+eK7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpO4/vVR9QXhH/q+nMwS2S93uZXVxek/w/prLAm4DTbYS7YEzruxUUSoVZ2Dji1lhEO0XEFmp0ezvBdCZLWZOdDNgQOBFZUYZtCvj+vzOq4QMjL6xqEuj3mvOtjmZMEngWsa125Gaj7HC0wV0fW6eiMvTph+wIxxP8P/bv69Cfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8nucq7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8nucq7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676D41F000E9;
	Tue, 21 Jul 2026 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648719;
	bh=M7LvgCEwAxE2CFQv2dyh+Nph3OG9Cukws1SgoIBtPMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8nucq7/JN7STQN2ceWRO5pe/Cn4erxYzDTIJotBvdyi5fhdrZXmEG3K/3L8vBIZB
	 8pA7edPLbYMDHDGbrLnVVXc8UBNxw7iSaaWBqSCqni/kZxfzsuMbFqXGjBsmslshw6
	 ICs9wzd5ds9sVk3FNgOfUMfgEfDTTKnGv38Esm/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianfa Weng <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0305/2077] RDMA/hns: Fix log flood after cmd_mbox failure
Date: Tue, 21 Jul 2026 16:59:38 +0200
Message-ID: <20260721152559.873028484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 621568e114054b..f7e220ab421981 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -174,9 +174,9 @@ static int hns_roce_create_cqc(struct hns_roce_dev *hr_dev,
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
index fa36700d0db2b6..8810fa0b659731 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6192,9 +6192,9 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
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
@@ -6220,9 +6220,9 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
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
 
@@ -6328,9 +6328,9 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
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
index 25bfd3970f5b6e..c13d29cd0897bf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -173,7 +173,7 @@ static int hns_roce_mr_enable(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx & (hr_dev->caps.num_mtpts - 1));
 	if (ret) {
-		dev_err(dev, "failed to create mpt, ret = %d.\n", ret);
+		dev_err_ratelimited(dev, "failed to create mpt, ret = %d.\n", ret);
 		goto err_page;
 	}
 
@@ -319,7 +319,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_MPT,
 				      mtpt_idx);
 	if (ret)
-		ibdev_warn(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
+		ibdev_warn_ratelimited(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
 
 	mr->enabled = 0;
 	mr->iova = virt_addr;
@@ -350,7 +350,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx);
 	if (ret) {
-		ibdev_err(ib_dev, "failed to create MPT, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ib_dev, "failed to create MPT, ret = %d.\n", ret);
 		goto free_cmd_mbox;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 8b94cbdfa54dfa..8feb5851067d82 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -103,7 +103,7 @@ static int hns_roce_create_srqc(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_SRQ,
 				     srq->srqn);
 	if (ret)
-		ibdev_err(ibdev, "failed to config SRQC, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ibdev, "failed to config SRQC, ret = %d.\n", ret);
 
 err_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
-- 
2.53.0



