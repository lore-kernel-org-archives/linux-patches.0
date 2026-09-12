Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9628E0;
	Sat, 12 Sep 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229826; cv=none; b=I/c/DD3IYs4p0gJW0OlQnCDZgASyDF7zMpzIne/cLxbY9HHayKem+kNCZ42jnL2LW298JXcsA9CoJRqnYuvuf6nGZZc7SUijU5YK/90gU/wcC8lFyP+eVtrLIwj4qcvVatj1H0jkKZPa7roiRtet2jrI8JsBDAqucDWxw3T1M9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229826; c=relaxed/simple;
	bh=RgLFAYETOPyFhZb+NhugpVuoaJK1KCSPv7KJoHy0uqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwPUrqB3G0qOyEQUb7uSU61HYprA8FSqcXL4sPzZlt+Z/h14g4wpfMTyV/487D5bsjitnmYgxu8VwrlXorSBTgxD7CMswt539/Ufh9s9O9N8e8jaQUZ9wBSCPDxtfP1RHps/yK1h0chK0W3DW/+OBjZZw5wXmhxH+v5p/LFxjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hj2cdjW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hj2cdjW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0361F000FF;
	Sat, 12 Sep 2026 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229825;
	bh=KWt92Y7q957PWTqDQpa5UUxiLvBDnkrC2jy0d3mfHmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hj2cdjW4ECgpZSyAzkNqJVuUH3gyXnx9Q4tg42OzKlHmgxt+3x4HiNJ9CnwmeMmv0
	 6kRUMi83+Muw+glyTSvGymCkSTm4d0c83IsTd9CZHvTcbi9fKoDQbrMOC7DS26D+k8
	 sr9nOVTc6ECu/K2Jf5onpdBJ2m9M3c7r46tWUaso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0669/1191] RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]
Date: Sat, 12 Sep 2026 08:56:37 +0200
Message-ID: <20260912065603.281411363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1ef5819e75fff..55accb4a42980 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -680,6 +680,21 @@ int rxe_requester(void *arg)
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



