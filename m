Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87425B0AA;
	Sat, 12 Sep 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207779; cv=none; b=rzJLI2ApMGalx8Vx+WNcauZO2kvZ+zqMjr4x17klYklOEJ0M5L3p0c5YjZMsZSrYLd8DolB1uA7XBZiqSLNxQXaRupqn45lq90cEbh24tDVOsIbhhmCbZMyXX967Gqc9NmuLEWEbCxFweWKSWAs92ciG/RebbOg2ufhdqcu6t1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207779; c=relaxed/simple;
	bh=Znu4l1MP7mKcjZmo+l4xa3dmls7yHgfAyUh9yUaf2BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcbG8V5qvhFFcA911VAYVHy2CKqgDDNqq3qOmbk64l2dV+mrj3lexLhzyVGL8OFRstm9FokSFaUFAH8fnFxrvKy3r/3YgCItEoEJSzpQytpYDN39CyMRP8Y5u9ZsTVGePuBTsuiG5suFBriIiKlcKKXIPWx9x4SR0agb6zRT540=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnaNgJFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnaNgJFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867321F000FF;
	Sat, 12 Sep 2026 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207775;
	bh=NW0TpCpLcYHrnspVuOGMoDY6iCC5gCaLPz0B1XCL0eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnaNgJFK90vaDHHQNAIL4ml6RiIZeH5KvlE7Vb8dOMRRnG6l3jv2q4GJK884rQuUS
	 sL+FODq+ELdSpX1Cs2ptikjnCbMBmZmAiYmNyYxoDm44rvpFb4+fxFrkkOkcSQR+o/
	 9OsDPiiNOd/nBEm8D6PqgKmQl10CPUYCs3Oi5/Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0482/1518] RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]
Date: Sat, 12 Sep 2026 08:44:11 +0200
Message-ID: <20260912065634.350788270@linuxfoundation.org>
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



