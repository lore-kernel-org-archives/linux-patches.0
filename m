Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B314366052;
	Sat, 12 Sep 2026 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215991; cv=none; b=AEIEKYjsxoN2DQxqExYH02Hiqon6f/Y9ogsTwzBBDBsgpafHWCOOpFmhkAfXo/mSCBAAySFVo3mnoPG7u6dDJ/TsnT/OTYvNFFsNtXqpEDRBGkinixOfSvXsbeAPE2tPax6EkEGKSYZj7KaKQXz+AEEaxpr7rzordjfl41awYyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215991; c=relaxed/simple;
	bh=cutG1DFV1/y+FjWmXFUjeiP96xEK52To7SrPCL7Fx5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja6z9L1Q+pR78+HDwDHiAYUCURh86rEXDG98923Cf47KMLu8hP4SdGhaOVSCrNpeiLPneeoRN/YNTGkmr298RhIy9OWR4D0vBNHZMAZWQaP5owAPvUdEaIyxH1iL7ekPC2Na6kFqt4kc6vVuPASChh4/D2G78slnaMeoPDy2XJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJopbHu6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJopbHu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C091F000FF;
	Sat, 12 Sep 2026 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215990;
	bh=x9UcAsddH7POJu/pRwk8fNe3tDZgNz6jHCB/IEeFnE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJopbHu6OXPCynUIXhyIx+Ko/5i4OPK5/BSdzp6XP/t4lE+ygARgau+zCq+KV7LJ2
	 zsVW6C6HErtpDTmA7Z+NDwFeAoALNTTpilRK2+2bjUa/ULlcvhAk5B1gKTjvGKXOIR
	 AKa45UMfqzHvrUFT9VLBac/JQCxPDL9GQo4iqbao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0608/1376] RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]
Date: Sat, 12 Sep 2026 08:50:34 +0200
Message-ID: <20260912065621.090990948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d08ebb048cb0f..3a4fa0ca36a77 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -702,6 +702,21 @@ int rxe_requester(struct rxe_qp *qp)
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



