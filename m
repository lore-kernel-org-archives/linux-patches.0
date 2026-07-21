Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCAF3B1034;
	Tue, 21 Jul 2026 20:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665970; cv=none; b=KvErgAzPp4MUr2exTo5it7zgSiDnH0jApyDGyYCv+JgMvvujryCCLf6ZSUox0UdRdNBNNoNdgRDzY2kHA8H6WWEAFxAYvylnH2H8IDkiws1Ne20L9oOoeUMmOBhZd0rLAvOK+yEGrJQ+4nflD+G7NddHgnSaNgoCtWlhvUT+bu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665970; c=relaxed/simple;
	bh=L5coU4+LELxoEISCLT86SHMdSpKEdabHBtAfaHn83B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m18nIqyVM0blS7faJ/n21SoncX9xO2EmZPw5aWH+b3X9UG3uYsl7fZBMnwz1c6hwXO638vQ4H8KO1UqKrmOaE45SYnNy/nESv2wtMKIg+qeB5gGfBAYSD5ghlkS4NTFKPNXTc9poiFkvtZaEtcI9Wo7iAAoMyv/Nh8WP6Mt/r1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGA/oy5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGA/oy5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D591F00A3A;
	Tue, 21 Jul 2026 20:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665969;
	bh=qvgutLDAXUchfoleC49SGxUFmaTxU9o+XPkFdFEZibw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGA/oy5TLj4TK/N9Qgh/haYeeA7jDkhxbdSV37T3qU+Kv1V6r5yAd672hd6zHRnZp
	 RF5tDbE863Vjmpa8qvzuDGcSr/E2G6zzCWKFZiwnV0NwMjXowQUyUFDeOFvwW8fom3
	 4PHCaCwiBEqQVkDD854A+v0ym9H6Sls1HHoXhTlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0462/1266] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Tue, 21 Jul 2026 17:14:59 +0200
Message-ID: <20260721152452.171443434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristmd@gmail.com>

[ Upstream commit 22b8fbded65b8c441b634a185f8da67657df6c50 ]

get_srq_wqe() reads wqe->dma.num_sge from the shared receive queue
buffer, which is mapped into userspace. It validates num_sge against
max_sge, but then re-reads the same field to calculate the memcpy
size. A concurrent userspace thread can modify num_sge between
validation and use, causing a heap buffer overflow when copying the
WQE into qp->resp.srq_wqe.

Read num_sge into a local variable and use it for both the bounds
check and the size calculation.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260518215040.1598586-2-tristan@talencesecurity.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 70e9bf3a704225..c7bdc3d22053eb 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -273,6 +273,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
 	unsigned int count;
+	unsigned int num_sge;
 	size_t size;
 	unsigned long flags;
 
@@ -288,12 +289,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 
 	/* don't trust user space data */
-	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > srq->rq.max_sge)) {
 		spin_unlock_irqrestore(&srq->rq.consumer_lock, flags);
 		rxe_dbg_qp(qp, "invalid num_sge in SRQ entry\n");
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.53.0



