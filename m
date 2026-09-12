Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F8B340D9D;
	Sat, 12 Sep 2026 10:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208369; cv=none; b=R/fzRfTlPx3mtVM1qzivrIAkv8I8yd7yHsg9N3RVr5dF29jPY7vUQh2QuLWRT9KLldOKIpphBXVbv+TezOHxVYewBX8bWn7DI/3f/S8bfs0699e28hUTehqMVapCrOnn5P7vUYIetSbG8+XYAkxyIvLnlTQ+FrNvwY0EdMiNL/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208369; c=relaxed/simple;
	bh=aDXQb9z217rooYGOmBRnbVzh0T3cpQpdOWN8jWXninA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2PKndq8dzrzIFrX9F5DQJUWREqv7VEFf2FSG9JwSfJpua5kyQ1U7/WxMxmZJf2DzaCsmeWKuIkvSlsEJ0AijuoKCUOrhXjVexQ/dZIVjecG+SnnQy4YZU780uRC4Iks1zp4SLCmg8E1AECmYhMOehdP1rXOBCgh27w/0vjESOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma8Gzxg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma8Gzxg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D75B1F000FF;
	Sat, 12 Sep 2026 10:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208368;
	bh=ga2Ooz6yX2tpxzHghixZdx9ty7qTyPTr447pARd7wm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ma8Gzxg1O+jPUT7bjLQjg3SPDeuwxEgZkhEaU9nCP6Fe+Lj5/5B3EPdjzSO/ckZQ5
	 hPHIPXtLFF0Z33Kz8lSjBKPRNQSjRvgXzBBXWOyzptd1WxQgoupjjSFHa+0zBHGF7n
	 IvxERgwiUK40Hbjd5qoluGABZqxmiry2WxKt9tX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0559/1518] RDMA/erdma: complete object teardown when the destroy command fails
Date: Sat, 12 Sep 2026 08:45:28 +0200
Message-ID: <20260912065636.081512620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/hw/erdma/erdma_verbs.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 058edc42de58b..4c78013b056fa 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1303,8 +1303,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
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
 
@@ -1330,7 +1337,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy CQ %u: %d\n",
+				       cq->cqn, err);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
@@ -1378,7 +1387,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy QP %u: %d\n",
+				       QP_ID(qp), err);
 
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
@@ -2282,7 +2293,9 @@ int erdma_destroy_ah(struct ib_ah *ibah, u32 flags)
 	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  flags & RDMA_DESTROY_AH_SLEEPABLE);
 	if (ret)
-		return ret;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy AH %u: %d\n",
+				       ah->ahn, ret);
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_AH], ah->ahn);
 
-- 
2.53.0



