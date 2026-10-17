Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E59935DA41;
	Sat, 17 Oct 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260209; cv=none; b=MEGsYU5coHvOWBDOetCY8fn1pflX6tiFudmO2/QCG+qosWoqutdQdCdT75/ahALTc4slLpdIvjOCI2nuzAgHhih5AKzpbtRjvKrtjRYAKscxidnAOeQ2iks3XyaUdT9+CWXoJJCWfZWMaKSTmQPvKt3VR9WNqUyrlPTikatNAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260209; c=relaxed/simple;
	bh=lSmLCM849eUHBBnqssFq3RPUAZM3vAgqlMJW5vhiVBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McaLO/USLSAW2HuVkfDTALrb9lSX4aauak9XDNJD91g48ZCljHgCIHtnZluTkP7TbOIwKx5CaMcE9hf71kDudiaVRHcF3c/VuqCCTiiIyGzlN3BsvftjaLzuUOSRpr9XZJUCa/2nlMd64sBweRq1zh+MFaje8l4SzzPI6tlzlvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgImYkdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgImYkdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E221F000C4;
	Sat, 17 Oct 2026 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260208;
	bh=+HyBjcLh1d4D+QGueN6Y7cSYHQmNEILfQZBTkkI+ENU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgImYkdRMvJFxVe33rKwIoG5AvzmGZXfW2Pf3bxH+w9+GLxRjjQ+R6KSjafG//jNv
	 Nv8a/t54v7gafpe7JigF8KBvV5H8OcVLWtv2V56x4IBxRXVROVdjsKdMGcspiaoEg6
	 vG7uq1JqVOfJd+46zfwLnS4Fa60KHpN/msuR5cDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1470/1674] RDMA/erdma: complete object teardown when the destroy command fails
Date: Sat, 17 Oct 2026 18:02:22 +0200
Message-ID: <20261017160508.899342562@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 652befcba956ef357f480525ccbe25c59bc81d4d ]

erdma_destroy_qp(), erdma_destroy_cq(), erdma_dereg_mr(), and
erdma_destroy_ah() returned early when erdma_post_cmd_wait() failed,
leaking the queue buffers, MTTs, doorbells and the STAG, QPN, CQN and AHN
identifiers. A command timeout clears ERDMA_CMDQ_STATE_OK_BIT and
permanently disables the command queue, so no retry can succeed; the RDMA
core keeps the object after a failed destructor and forced uverbs cleanup
then nulls the pointers, making the resources unreachable.

Warn on failure but release every software-owned resource and return
success, since during terminal destruction the hardware command result is
only diagnostic.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Link: https://patch.msgid.link/20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 047f5977c420b..a9b2d0890570f 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1211,8 +1211,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		  FIELD_PREP(ERDMA_CMD_MR_KEY_MASK, ibmr->lkey & 0xFF);
 
 	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL);
+	/*
+	 * A timeout disables the command queue, so retry cannot succeed.  Treat
+	 * terminal command failures as diagnostic; propagating them can make
+	 * forced uverbs cleanup discard the last software resource pointers.
+	 */
 	if (ret)
-		return ret;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to deregister MR 0x%x: %d\n",
+				       ibmr->lkey, ret);
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX], ibmr->lkey >> 8);
 
@@ -1238,7 +1245,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy CQ %u: %d\n",
+				       cq->cqn, err);
 
 	xa_lock_irqsave(&dev->cq_xa, flags);
 	__xa_erase(&dev->cq_xa, cq->cqn);
@@ -1283,7 +1292,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy QP %u: %d\n",
+				       QP_ID(qp), err);
 
 	xa_lock_irqsave(&dev->qp_xa, flags);
 	__xa_erase(&dev->qp_xa, QP_ID(qp));
-- 
2.53.0



