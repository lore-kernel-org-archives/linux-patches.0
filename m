Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F336654F;
	Sat, 12 Sep 2026 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199665; cv=none; b=QX0E1IS7m8SyHjtOYMHYSr3ql8zcXgcp4na1QEfWrGzdpMd+ZP8WSUlHVM9HM829imVVyTkPMNcJSp3sa1leJNq13FQvl/OjjiJ/Fbv2lO34xzRlvCQA2S4nYH3HVohmuQZQKok46lEcOUSqtLQ5OdTKMBbghGR/iyN6t9znUa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199665; c=relaxed/simple;
	bh=pqUPyS7Wey6R1RXFiU7xv4gXPfRp8gAPq1rwHfdzM4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKIb309NQ4284dB5gwGdw1Kda4NtsUfTW60QHmWy6qF8jJXey5hyCre58KyA8dpXhgcfvlnaQ2VdubzWrZ9rkzESWCfMWo541SXrnF2FYjWicblBw/ewhSMfqH9UxLOfICEet93qqVaJxDAncb8tG+Sojox+x6zlkalUyROAnL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czViJuCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czViJuCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791A11F000FF;
	Sat, 12 Sep 2026 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199664;
	bh=CAr2GvpLTKsv7jMEazXKyZWs4Y27hAhN7TBPE79KWas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czViJuCafB1DRi9glqwmiAn7VLfSmYL/dOGM/pJQysGg/oB7oo1QPvrAHg6LK5b+6
	 Q3GL63hzc5GwraAtSXw2NlpLqm/zxtsNPu+tD41mZtX28sc8VJwZ5LjNcSV2zCHfiu
	 YQOCYFGjRvIJAzTHkx8LZ+1kCrVCEoV7GdSOSNL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0630/1815] RDMA/erdma: complete object teardown when the destroy command fails
Date: Sat, 12 Sep 2026 08:39:40 +0200
Message-ID: <20260912065703.669684162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 74afe6eb18b0b..58bcae0e0fadd 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1304,8 +1304,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
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
 
@@ -1331,7 +1338,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy CQ %u: %d\n",
+				       cq->cqn, err);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
@@ -1379,7 +1388,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy QP %u: %d\n",
+				       QP_ID(qp), err);
 
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
@@ -2281,7 +2292,9 @@ int erdma_destroy_ah(struct ib_ah *ibah, u32 flags)
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



