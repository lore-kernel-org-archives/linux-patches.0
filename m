Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D29E1DACBE;
	Mon,  6 Jan 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177427; cv=none; b=lJ9A0B8TIURoYu4iVPxP9PcaznRDu3HOM0esCmJPu6sz89FyYx4qqcaZmfoKSSDkeQzxQSlEM9FwfKjYlKmRkYWhdzkdpqqHjsvxjSpZ+nM5Dqiwks8CKgWyNdDvFgujcdS2rqQUu4opyDq1Mi/vI+GZoYmAQNLrQ/Doec6A8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177427; c=relaxed/simple;
	bh=PdCbs0dDKhuRwxEXpfNMgP+lSTjKnlNLAPFzy7mEC8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLpTkMvTtL6KZWCWQGxdf0OgRBqsG0RHKTij+Yf3x/FE0kXFph74+HOOERDZUb5WJlwwvLW9F3ngT/Ke2nO3itLk4iRmaeP6Nqc20N5+zjGE5cdOErzr7+cqoarcKefhafVzdhwLR1rDBazjRU7gozZftqPYRgftjHV27DTWPFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocf8GjeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocf8GjeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5258C4CED2;
	Mon,  6 Jan 2025 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177427;
	bh=PdCbs0dDKhuRwxEXpfNMgP+lSTjKnlNLAPFzy7mEC8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocf8GjeLjDvsfPhAzPcNtH4T87cynG2B9m3OfM35R9rE97PieWdizVOL1GlqLVKuw
	 jqPQR+rtGqQCYgR0uBcfMI/nuC3H89xqGxYXoHubwaZzccYeRrlGLwzielVoZzPCe6
	 LbVzcPYnAJkg1aEd8buxl/kJq0wNzyKvulTeH0Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/222] RDMA/bnxt_re: Avoid initializing the software queue for user queues
Date: Mon,  6 Jan 2025 16:15:34 +0100
Message-ID: <20250106151155.691176546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 5effcacc8a8f3eb2a9f069d7e81a9ac793598dfb ]

Software Queues to hold the WRs needs to be created
for only kernel queues. Avoid allocating the unnecessary
memory for user Queues.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Fixes: 159fb4ceacd7 ("RDMA/bnxt_re: introduce a function to allocate swq")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241204075416.478431-3-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 42 +++++++++++++-----------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 4098e01666d1..d38e7880cebb 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -639,13 +639,6 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	rc = bnxt_qplib_alloc_init_hwq(&srq->hwq, &hwq_attr);
 	if (rc)
 		return rc;
-
-	srq->swq = kcalloc(srq->hwq.max_elements, sizeof(*srq->swq),
-			   GFP_KERNEL);
-	if (!srq->swq) {
-		rc = -ENOMEM;
-		goto fail;
-	}
 	srq->dbinfo.flags = 0;
 	bnxt_qplib_rcfw_cmd_prep((struct cmdq_base *)&req,
 				 CMDQ_BASE_OPCODE_CREATE_SRQ,
@@ -674,9 +667,17 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	spin_lock_init(&srq->lock);
 	srq->start_idx = 0;
 	srq->last_idx = srq->hwq.max_elements - 1;
-	for (idx = 0; idx < srq->hwq.max_elements; idx++)
-		srq->swq[idx].next_idx = idx + 1;
-	srq->swq[srq->last_idx].next_idx = -1;
+	if (!srq->hwq.is_user) {
+		srq->swq = kcalloc(srq->hwq.max_elements, sizeof(*srq->swq),
+				   GFP_KERNEL);
+		if (!srq->swq) {
+			rc = -ENOMEM;
+			goto fail;
+		}
+		for (idx = 0; idx < srq->hwq.max_elements; idx++)
+			srq->swq[idx].next_idx = idx + 1;
+		srq->swq[srq->last_idx].next_idx = -1;
+	}
 
 	srq->id = le32_to_cpu(resp.xid);
 	srq->dbinfo.hwq = &srq->hwq;
@@ -1022,13 +1023,14 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	if (rc)
 		return rc;
 
-	rc = bnxt_qplib_alloc_init_swq(sq);
-	if (rc)
-		goto fail_sq;
-
-	if (psn_sz)
-		bnxt_qplib_init_psn_ptr(qp, psn_sz);
+	if (!sq->hwq.is_user) {
+		rc = bnxt_qplib_alloc_init_swq(sq);
+		if (rc)
+			goto fail_sq;
 
+		if (psn_sz)
+			bnxt_qplib_init_psn_ptr(qp, psn_sz);
+	}
 	req.sq_size = cpu_to_le32(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
 	pbl = &sq->hwq.pbl[PBL_LVL_0];
 	req.sq_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
@@ -1054,9 +1056,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		rc = bnxt_qplib_alloc_init_hwq(&rq->hwq, &hwq_attr);
 		if (rc)
 			goto sq_swq;
-		rc = bnxt_qplib_alloc_init_swq(rq);
-		if (rc)
-			goto fail_rq;
+		if (!rq->hwq.is_user) {
+			rc = bnxt_qplib_alloc_init_swq(rq);
+			if (rc)
+				goto fail_rq;
+		}
 
 		req.rq_size = cpu_to_le32(rq->max_wqe);
 		pbl = &rq->hwq.pbl[PBL_LVL_0];
-- 
2.39.5



