Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEA4472F71;
	Tue, 21 Jul 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656139; cv=none; b=irbGf3ApSWjo/ftaAaOQZcBU/SLu6S1YyOrpPE6RCFDHO97fND8goIjgEMEoxb2qb0dtlkO66r8OfTeoWZbpZW9akS9bM7fWS9mHSsbnsI+se/SxXkhEzlCjILoHH+3XvTYlKrdUH/DHekhJmuL4AJrZDR6fUT3hp2TJVoO50Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656139; c=relaxed/simple;
	bh=kXzWNS1GUR+6MdREsIKltbWHcMjQfKjBu8h87ybxwLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywazw40vBEx6GTvdEtWf91vXxGn3MESyzAqN0iwfSZ6tACly/j+MiUMicakvDIXujJJBtkWSOl0jbfNYzArzYe3RDcvKwSEnW2uUhBYK0Y14z6kgmWT2xEJ9Ls277dwSwt14v/tUdG7+ZN78kOinLp6AlbOqXo0HRtq0/uNfl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLtvNZE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLtvNZE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DC81F00A3D;
	Tue, 21 Jul 2026 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656138;
	bh=gsvqclEAO18Yo7xINfiX1RkmQQb7SBL1X/2hHbiDbZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLtvNZE5enVhFm3olzIymwPRWGMmtJSO+Uk58uml74g/6aALJt2fgKdilBfpgAyHj
	 QwWfWaskLUPFG+h+DXaMmBTAs0KnEdaEudh4TRFdeNDJwvEEsRngZJ9xNeRgcJPtTO
	 Ywu0iRjxznKd6yTa/jD2EmaRcrGwctMznUuReu/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0273/1611] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Tue, 21 Jul 2026 17:06:29 +0200
Message-ID: <20260721152521.191319348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 09ba21d0f3c4fe..12669297468890 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -263,6 +263,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
 	unsigned int count;
+	unsigned int num_sge;
 	size_t size;
 	unsigned long flags;
 
@@ -278,12 +279,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
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



