Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953D44AB7F;
	Tue, 21 Jul 2026 21:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668917; cv=none; b=UEfvcfzEz9O+ZwCH4BT4oMuKUMhMQ9S34r0M/4kooKSJC9ZcRQEbv9CcWCK7w9EYFlUsnghwGPpsnhJbZd1kTZS0xrcxwomdL3tJlQi+XCTp5IJ2+DHdUzHYRlWFI1G0qi3Dyvj04MR8VlzGwrQk8YTeAzOuMyY1Tc4iHtnvZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668917; c=relaxed/simple;
	bh=LRZEDstOszBge56o+vmRuHKSj/LAX9x2jE4FHYt1gUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp9F3iGkXrRz1Orr7sb7ixdGpY4gcQxxB2BLGJ4/xLCfZSPpZqHi8QLAKpac2pDP5uYTJEQVTM0E+aLnvGSDzvNnqapBinAvbSiwpUcrCzVr9QLWkqf3/wDQGEvN92MJO3iL/AaX/YcBb1PBeedeKJUljPWgQoUEzQ4nwKE0A88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAL3RphD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAL3RphD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC31F000E9;
	Tue, 21 Jul 2026 21:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668915;
	bh=ohn2QPKNTJHh8gHl3BmcchLYkduNhya9iEwroPR0CME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAL3RphDeg7euGwvxH0hjhTgNXjxucsywv9JYACvG2BRa6SuQzdZ8W9gqPT0NNFEH
	 qSz7SdMzoF3VMVQ2UtSVF2LCCYgX10I2Ar0VoSgYM8jJj1RGBVofWSMuFs7VnSMlyo
	 5jNLm5X8kJea8T+T3w1Wg0XiaJ0KSLym4YGa5BTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0357/1067] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Tue, 21 Jul 2026 17:15:58 +0200
Message-ID: <20260721152432.598359228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index a45202cecf2d7b..04d527453f975f 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -300,6 +300,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
 	unsigned int count;
+	unsigned int num_sge;
 	size_t size;
 	unsigned long flags;
 
@@ -315,12 +316,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 
 	/* don't trust user space data */
-	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > srq->rq.max_sge)) {
 		spin_unlock_irqrestore(&srq->rq.consumer_lock, flags);
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.53.0



