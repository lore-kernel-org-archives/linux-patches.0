Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870B165F1F;
	Mon,  6 Jan 2025 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177748; cv=none; b=EyorG5pOe1k8vd0QjEL4U+8RGfk/t4E1YFMutfRyw+ndOoId/RchDvrhC4MqDoCcv7FX2BxuoeOINl3GMBa3tDfEYUyoaW3EDwyAcy7KPQnWZ1LDxlPhnWSNqNjieXnNyYCUyHEzWuqiX7KTp96LofzRP3TEAJbgMNEVbN0QlZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177748; c=relaxed/simple;
	bh=BCkBJwT5HxQehAA85/iMf0/72qXyh3d82LasBsKO7QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goCIZ+/gFt4qeaLEA9RRKB3svrsoZFFFYvVlDkkaI/wReeKfPdEXBQ0RQkcZK8+gVpz8GBESZ+up60/FdsRr3x+EFnqey/2ZnrYZsUJfp/d1FduzpnJLKsO0p3Ei63QdbJ9JuGbrwcK59UOO8+lAnht6FXIkz4xGleK9IVZ9TJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zajl3G5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zajl3G5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84251C4CED2;
	Mon,  6 Jan 2025 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177748;
	bh=BCkBJwT5HxQehAA85/iMf0/72qXyh3d82LasBsKO7QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zajl3G5ItS9L64SITeZELEjz3FFQdp/yNDEmHgTxTiM2/Nvd1c8t89gPpRalB/uI5
	 euUSvdVfBjftyhhMm9JqzL+l8W2Mt5tUFzZJefM+y5KBYjMJoT5X6RLz9PDey3Hbtc
	 7NzuYCWp/d6taE1lbt1vC/yKWohsOUWRKckr4pj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/156] RDMA/bnxt_re: Avoid initializing the software queue for user queues
Date: Mon,  6 Jan 2025 16:15:02 +0100
Message-ID: <20250106151142.355221876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be374d8ed430..5938db37220d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -658,13 +658,6 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
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
@@ -693,9 +686,17 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
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
@@ -1041,13 +1042,14 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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
@@ -1073,9 +1075,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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



