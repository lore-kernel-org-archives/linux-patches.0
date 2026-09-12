Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C8E37E2E4;
	Sat, 12 Sep 2026 07:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199234; cv=none; b=cL8uj4c/f4bJiOpSkdkx33TBuDwZmiEtFnybLP3cQ9YeyHNumCq+ZPmKpkzSZOKuC92SPiwWHuvgzsdlOtfAsC3OZeyl7Xt/9rbHU/ngxe4hPZTlLJL/qfOz7QKX7G5dLXLQDrmC/t3q7MZJTrCGZ5geQlmzqnz0QFqA2x6/T4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199234; c=relaxed/simple;
	bh=eMuR/NwLf4YXsraosZDllowE+G0u5YtSMTIZyvJPoN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9oOCKUWtYw7xyfCydEF/YEOfDq0UM457VvimceDJpuMDHIu32J0/zdBB0sGofQmPfWfcYWAll3ANE6T5WOx157U+Uje4IPvCzlWHPK09koEBS3+n1Lsk4zUlwEGBzBMStS6uOtn/VrtUoodvOrFxezKFFjp/UhL5yf4ypP2W9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEeWfWpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEeWfWpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1396E1F000FF;
	Sat, 12 Sep 2026 07:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199233;
	bh=BFI6bA1gZI+gqMVVjhvtC6KW7RH+Vp0j8dM/n6Ija0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEeWfWpSw2QS+woyYvqIV9dXbTEDHLp2Wrz2LN4OfdTt6a3Y4eeBxKkUpvVW0Xu7r
	 iojske+H+Fj3JyoUoFA+tQi+1Guzv72LcSAurZdtYv62RRmToZiAJqzPNZipN6nI2X
	 4YXr6O7g1Dda57ZB0eTDywZ4caJSTci1QOPmNOxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0541/1815] RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]
Date: Sat, 12 Sep 2026 08:38:11 +0200
Message-ID: <20260912065701.582149222@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 126c757e4cd46f866ddc283143b58eb4d9bf52cd ]

For a user QP, qp->sq.queue is a ring the application writes directly,
so rxe_post_send() takes the is_user branch and only schedules send_task
without validating the WQE. rxe_requester() consumes it in place via
req_next_wqe() and calls copy_data(), which indexes
&wqe->dma.sge[cur_sge] with the attacker-controlled num_sge/cur_sge.
Only the kernel path bounds num_sge (validate_send_wr()); the user WQE
is never checked, so a local unprivileged user can post a WQE with an
out-of-range cur_sge or oversized num_sge and force an out-of-bounds
read of the per-WQE sge array in copy_data() (vmalloc OOB read, local
DoS).

Bound num_sge to qp->sq.max_sge in rxe_requester() before use, the way
get_srq_wqe() already guards SRQ entries, and bound cur_sge only when
the WQE carries payload (dma.resid): copy_data() returns early on a
zero-length copy before touching dma->sge[], so a zero-payload WQE --
the only kind a max_sge == 0 QP can post -- stays valid.

Reproduced under KASAN; the vmalloc-out-of-bounds in copy_data() is gone.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Link: https://patch.msgid.link/20260712122149.78142-1-security@auditcode.ai
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 12d03f390b097..24f5c044363f7 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -701,6 +701,21 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(!wqe))
 		goto exit;
 
+	/*
+	 * Don't trust user space data: a user QP's WQE comes from an mmap'd
+	 * ring, so num_sge/cur_sge are attacker-controlled. Bound num_sge like
+	 * get_srq_wqe(); bound cur_sge only when payload exists (dma.resid),
+	 * since copy_data() skips dma->sge[] on a zero-length copy (all a
+	 * max_sge == 0 QP can post).
+	 */
+	if (unlikely(wqe->dma.num_sge > qp->sq.max_sge ||
+		     (wqe->dma.resid &&
+		      wqe->dma.cur_sge >= qp->sq.max_sge))) {
+		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in send wqe\n");
+		wqe->status = IB_WC_LOC_QP_OP_ERR;
+		goto err;
+	}
+
 	if (rxe_wqe_is_fenced(qp, wqe)) {
 		qp->req.wait_fence = 1;
 		goto exit;
-- 
2.53.0



