Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216603;
	b=ngrPj0PYs9Nb8zbl1ZjX9+hSTrFIsL1lh651aOYiqDSvlnq0s0x+63841Iy/skZszM3M
	 elHkKq+l4M/4skfpcdMbgYau1tTWWPXfCswg2pzZvcH+OSgDIODile/jIkOJ8dLX9iyrQ
	 BlKc/itvgScU+zbmVDueZrR/EFEpfHZbCJmXtFy3iLIDs6KcKNioTR9NXZ7J2tyJ+BmKO
	 hpKJrcuEu13H3xWo1eAlcNVm5eKX5uim1pu3T1JqlNKZWAObWCUX5Sv1uuxepJESjCJXV
	 d3CUliujDu0Xj3hmaPRJ5gL1jPCb7gwNtmi/3vJpcroWwO/jZlhivhja1IT9AfNlN/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u+StvlPK2MxiLnIud2lF3PYNuLhuBnHZWe1RpOVueUk=;
	b=YmHbZZkb/I2YPZclmwJtLd2Nyi7j+8SVvGA8r28CAvx2G4X7HZ+pUQC2hxCBCl2aTq2F
	 h8ixeQQ1y2OnCC64lkFOmbhJKJzwqGaDoyMT/7ltP+Mqy9xPd/G6hJX5lIiLlTgirx7wc
	 JF8PljyCDukgF0C+JwuyZAJdw1PZogbQf+lozeEkO5dCYDyf2shRWlzWdZw969wJWEI5V
	 E5wn1LHLgpY61idrHH4ljwT/SD5YfWGZx5QaMZFka3uzARXWKAjRQ9wVf+eKnsRY+2ULh
	 6jThSkyLYBo7KPw6rCXdYNZSQm6v0fjg93UpQ3GdMNUtw0x43JdPfiYWHuPkNU7YVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJqVmijr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A7F606A31C;
	Wed, 28 Oct 2026 19:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJqVmijr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8588A1F01825;
	Wed, 28 Oct 2026 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216603;
	bh=u+StvlPK2MxiLnIud2lF3PYNuLhuBnHZWe1RpOVueUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJqVmijr/VGd8313rDMhLvX2JY9TYhPpfHRi7Aut8MXeIuQKwUssJ1Yubjb/hjGZY
	 UAgMcNEPmQiQw+k+MtRIxMmnihtovqM27132920d80PaKB8BvfB1nHPkx0XFJexDtt
	 4c/W2N9VqXUZh9QYr5iBCDc9AqDD0QtctP0VyQFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1615/1887] RDMA/erdma: complete object teardown when the destroy command fails
Date: Wed, 28 Oct 2026 18:01:51 +0100
Message-ID: <20261028170536.218161056@linuxfoundation.org>
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
index d8f21f9d9101c..2ddc56335b9a6 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -971,8 +971,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
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
 
@@ -998,7 +1005,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy CQ %u: %d\n",
+				       cq->cqn, err);
 
 	xa_lock_irqsave(&dev->cq_xa, flags);
 	__xa_erase(&dev->cq_xa, cq->cqn);
@@ -1041,7 +1050,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
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



