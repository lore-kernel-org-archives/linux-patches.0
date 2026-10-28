Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215609;
	b=eV4dRwFbovGg+5fGGqSNi4A8VsSkjGQMTpcLWWNqv3Z7NuFhkzDnhgNcMvFg+4eFFK0d
	 VFk8EPs7RVo+BC3coLT2SyvX8M9RPJoA00NmWbrH8jUYi62bLz/2CSQq+prJ6ZYqMCb9F
	 W/BOkxQlJyExhBKn5KQQP6KdhIrXP7lpZOODpUGaMsa03/uFhzgf9bboFjnhTnwiFGv7j
	 JfrW7Ylwxq9fFtKmb+6+bmzpqqt1yDP0IXlHh0T+nug5NmEztlalo+1BlEv3737QudZrr
	 24heKjMD2lNzW821tFligumwv9nDj+h7d1SBn1igOxSkFZD4G0Sf+MmnfcZcy08sFSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzaXSjBosrQSK4KwWDr0aYVi22H5SOIkZT27rT+xsZk=;
	b=Evwk4wb+XodyhuOXB2cytrNgXMj4j83wZcXAIC/znWthmuBNXMtiMVC5vcTilgiqjkvX
	 G5yAQ1wSq7nKsM8HtSs5Pjl2saIOaxqBUuvwEhtJtT9NnJHxWPryVm8WjYH6rjrVeL+aJ
	 D5hTYT/KuWr9tQhw5adtrqE/bFr2yk54VjIJ+Pob1VA590Oy2iopl7FvE8ZQyuCHMuXQX
	 4zOw9+1lzEiBOQj0w9Y3z2qoHrzNBjerf19yjnW7wGy4MCXfKukZAyRlhV1x69Zjb2rgq
	 GGCYWhhaofgh41u2k+vvPSl5GPDGg1ur62NgoPChL/3MINGLIkDo8GsXmKB2uYcs+4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdemcDLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543CB606A31C;
	Wed, 28 Oct 2026 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdemcDLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A420A1F01825;
	Wed, 28 Oct 2026 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215609;
	bh=QzaXSjBosrQSK4KwWDr0aYVi22H5SOIkZT27rT+xsZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdemcDLARbNDqjD7g4BYtnUL9RxpWlzjUwfoOPqp5SQ2DwIBohWlacdxOqaf+IQwF
	 AzKh+rzWxAYipLNVHBjNzJayDhDdxiOb6+4p1gMeIjJGzFpR/EvAnkispP9f3NoK7k
	 YIAIIC0c7+kLSNgtzfe38eXneHptSfreiA+kOcIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianfa Weng <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1268/1887] RDMA/hns: Fix log flood after cmd_mbox failure
Date: Wed, 28 Oct 2026 17:56:04 +0100
Message-ID: <20261028170528.276251124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 122be4aae304d..1775120634745 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5852,9 +5852,9 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
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
@@ -5878,9 +5878,9 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
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
 
@@ -5981,9 +5981,9 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
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
index 408ef2a961492..105ebe4c8b9bf 100644
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
 
@@ -291,7 +291,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_MPT,
 				      mtpt_idx);
 	if (ret)
-		ibdev_warn(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
+		ibdev_warn_ratelimited(ib_dev, "failed to destroy MPT, ret = %d.\n", ret);
 
 	mr->enabled = 0;
 	mr->iova = virt_addr;
@@ -322,7 +322,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
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



