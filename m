Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042791;
	b=cKwJ6auWpVIYhrwF4z2GvzHX/qo4ffASvVbMLzNU+MneTUBqbMnlkGfJjuWZZ1NZ2WZ5
	 q1Ld4eW+RA9rzN0aFo8sx25MY1wat+UmSieu15hLvQaVZ2qq+/XBoVqquTLxTV5Fghn3l
	 WYeQtTbAuzUo9WyAnb/gtyTz0A4AWwPodcLArQJ18k9uU0Wzb4FU441UyJUIS6mxavfMj
	 QG3LBwPSJeZrvThFLYimHnRSE9Os2ngDXU9Wl3PnINb1tjzTjH9ACqru7tRfRQC7xdfRK
	 bPV7qVM6Ek4h5OIta1fncaaqMBOFCT0iQNwZBZzbYVBdk/0jU4mPZ6H1N/T+lT8CQHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ocf+W6as2/UVQB26U/1Y3ApYIFaIC0zsXKbw5GhKnEo=;
	b=OYuK2BBZDaXcfXkeW2pGkEF8JGu+DL9YXTpNYNxo+0VmXywnFRx4QVy/uwWieyLIf2dx
	 jBRNyQXbE07l/PBBfkYahYA0y2yytwcvxcbhbp5nSjW5TQC7+pAeFsZ09lQwr6RUQ3DF4
	 g8z7jVvXXZ7t+oFh9/nP7FZxr9jNS8ZdSHoPPK3x0TOUncYyRn/rAYAyiByMyT+VdXTNf
	 iNdidf6f4LVhaiNvv+HjDAgezPhPAWGEOkCwldrsIyFYh6e3PDFVXC95+wjawwfOccnyc
	 a6l3UOljhr5NXOZGeOsiUIJhf9rsndIJrEF1wfyD69A6f7Xm/jueVqQaA+jyFw/+07A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bRG/U3tA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C8F606A320;
	Wed, 18 Nov 2026 22:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRG/U3tA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3674C1F000C4;
	Wed, 18 Nov 2026 22:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042790;
	bh=ocf+W6as2/UVQB26U/1Y3ApYIFaIC0zsXKbw5GhKnEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRG/U3tAQeSiXxZIPf7ekigZL9QBKNAIbDg+MnXXgfmJqjCY3Dbly6ysLhNmzJCvW
	 IQRt5Z8Gyees3dsSeFQHWyXjzKUX6HuvXNZMIg34ik6LoGQlbImk8eI8pp4llw49sw
	 NXgA3tnpVStDWQD37E71BsrkCTwZkhLZDH9BztO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3297/3318] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Wed, 18 Nov 2026 16:05:19 +0100
Message-ID: <20261118150458.503305384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]

Locked QP and CQ lookups from EQ interrupts can deadlock with
create-path XArray updates. If an interrupt arrives while the create
path holds the plain xa_lock, the lookup spins forever trying to
acquire the same lock.

Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
including the GSI QP store and error paths. Initialize both arrays with
XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.

[ The GSI QP create path is not present in 6.6.y, so omit that hunk. ]

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_main.c  |  4 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 0880c79a978c2..6dc6c7f4fb2e0 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -519,8 +519,8 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	INIT_LIST_HEAD(&dev->cep_list);
 
 	spin_lock_init(&dev->lock);
-	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
 	dev->next_alloc_cqn = 1;
 	dev->next_alloc_qpn = 1;
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index a9b2d0890570f..94b3d4aea1236 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -945,9 +945,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	kref_init(&qp->ref);
 	init_completion(&qp->safe_free);
 
-	ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
-			      XA_LIMIT(1, dev->attrs.max_qp - 1),
-			      &dev->next_alloc_qpn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
+				  XA_LIMIT(1, dev->attrs.max_qp - 1),
+				  &dev->next_alloc_qpn, GFP_KERNEL);
 	if (ret < 0) {
 		ret = -ENOMEM;
 		goto err_out;
@@ -1003,7 +1003,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	else
 		free_kernel_qp(qp);
 err_out_xa:
-	xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
 err_out:
 	return ret;
 }
@@ -1682,9 +1682,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 
-	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
-			      XA_LIMIT(1, dev->attrs.max_cq - 1),
-			      &dev->next_alloc_cqn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
+				  XA_LIMIT(1, dev->attrs.max_cq - 1),
+				  &dev->next_alloc_cqn, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -1731,7 +1731,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 err_out_xa:
-	xa_erase(&dev->cq_xa, cq->cqn);
+	xa_erase_irq(&dev->cq_xa, cq->cqn);
 
 	return ret;
 }
-- 
2.53.0



