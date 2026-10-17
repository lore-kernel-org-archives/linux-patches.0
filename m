Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47B3A8753;
	Sat, 17 Oct 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259341; cv=none; b=KJ+pkPCyhVrSZcZpZsNQm2sCxdqYxOkfPNLLeGeo3bQxXsEmDVVCQ7gWaTL6UJZk9xjg9W5paNVuYj+IVFczhn9yyMHgd2q5tBkmYxghTINOLYmsD8dpVxsyPownSSDTzB/KGp+paKUOYSySkp0U5Hz9E06wXufs8Q7T6NUJ9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259341; c=relaxed/simple;
	bh=DrMK5yUKOeJMzTomGrp74BTRuFlNTlg++cclAAPHMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9RIsrImlsnB+HUCQ7bXUcFSwdJLQnFEnFwbdV66CxWjUMLnaIW7Mg+rMIENnbkzUjqw4gchuVKzphCEjJ3xWx1+U2S8P8gBwcWPmpi/wED61IWI+X5VCDkTNqqbo+vR5eZFC6UDTeY6594qpY4oOUqhM5xH83liALwJwcVKdsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/gmvrC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/gmvrC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB61F000C8;
	Sat, 17 Oct 2026 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259339;
	bh=jZr0cm8lMN9cshQHbvBhIgq7W4w8O24xzv/iwWYCilE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/gmvrC42yNTmKZdmiLnmB8PmbxLBVOtFBly69fuoRpLDpBOCPNW3w80jAidKYWA+
	 HQruGuNCfEDT0KdzQdWm9dzyrhfFFSBbDyHB1KtL2hFJViS0yAFNetv+4DEoVM6WGF
	 NUFUoyYpto1Kc6i/GVqpenuDSq0kyVE5gg1holC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianfa Weng <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1180/1674] RDMA/hns: Fix log flood after cmd_mbox failure
Date: Sat, 17 Oct 2026 17:57:32 +0200
Message-ID: <20261017160501.435856559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5e0d78f4e5454..c72bbf21f1aeb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -119,9 +119,9 @@ static int hns_roce_create_cqc(struct hns_roce_dev *hr_dev,
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
index a4f6f6db80b90..ef702fd9854b7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5713,9 +5713,9 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 					HNS_ROCE_CMD_MODIFY_SRQC, srq->srqn);
 		hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 		if (ret) {
-			ibdev_err(&hr_dev->ib_dev,
-				  "failed to handle cmd of modifying SRQ, ret = %d.\n",
-				  ret);
+			ibdev_err_ratelimited(&hr_dev->ib_dev,
+					      "failed to handle cmd of modifying SRQ, ret = %d.\n",
+					      ret);
 			return ret;
 		}
 	}
@@ -5739,9 +5739,9 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
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
 
@@ -5842,9 +5842,9 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
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
index aca079c120fbc..6ecc292f25e93 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -163,7 +163,7 @@ static int hns_roce_mr_enable(struct hns_roce_dev *hr_dev,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx & (hr_dev->caps.num_mtpts - 1));
 	if (ret) {
-		dev_err(dev, "failed to create mpt, ret = %d.\n", ret);
+		dev_err_ratelimited(dev, "failed to create mpt, ret = %d.\n", ret);
 		goto err_page;
 	}
 
@@ -295,7 +295,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_MPT,
 				      mtpt_idx);
 	if (ret)
-		ibdev_warn(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
+		ibdev_warn_ratelimited(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
 
 	mr->enabled = 0;
 	mr->iova = virt_addr;
@@ -326,7 +326,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_create_hw_ctx(hr_dev, mailbox, HNS_ROCE_CMD_CREATE_MPT,
 				     mtpt_idx);
 	if (ret) {
-		ibdev_err(ib_dev, "failed to create MPT, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ib_dev, "failed to create MPT, ret = %d.\n", ret);
 		goto free_cmd_mbox;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 80fcb1b0e8fdc..c699bf48adb47 100644
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



