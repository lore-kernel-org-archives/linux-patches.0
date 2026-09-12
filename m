Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FCA2AD03;
	Sat, 12 Sep 2026 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241956; cv=none; b=iqf8EkHGuhcoy8IndNC8l0CDjYWSWyQLtTOw3UWegc8VLLbxyfs7/Bt+wIeKwvtPIJYQNXHPcGkRbabIFpVP3fgV4RblKP0Cm7mBx4K89I11nS+3tdSI58uQh56RiNg3vgqDdLMsIWmkxa8h1XPhSDlZs7KLM+hYHpuLk+IORiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241956; c=relaxed/simple;
	bh=8Mnh13TLb0pvAzmoUyCl5R6Mk01ZoN5KmrzOgFwCJg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/sfVjyStL4tnLS+Zl6vC2/g32XQiqnYkynEK/jrQGopk1CNh8uA1lahAHTG/X8RDEBGeoybT+xac8SbX2n+lV8WU/XCveG2uh38RFGYwE02jAi5XyI2Gxjucy+ON5clLFLLC3Wne8zhM0484d4OO/TH+5tN18KCd6K4u1WztMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6g7DXJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6g7DXJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E34E1F000FF;
	Sat, 12 Sep 2026 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241955;
	bh=7Swk+lIvEPeO0/PAiPMIeDZ+hCaHpSuhosey3q9orKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6g7DXJR/pIwCQVq52B6ZuerApzWRjscj7vN1KsFopR5IKHtT6J1YWICXjjwQlRlc
	 skx9rCGu0FDZMMksgFIz/WX1CRvpGz3chflp2hMgo3EyQwQzI7AX3P72BJR9ZCHQbd
	 xPjYQy6uUdMXvvj6DZQ0ceD7okGWa2TDnHuu0oUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/798] RDMA/rxe: Use the correct size of wqe when processing SRQ
Date: Sat, 12 Sep 2026 08:57:07 +0200
Message-ID: <20260912065521.639457449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit e2a05339fa1188b6b37540f4611893ac4c534fa2 ]

The memcpy() that copies a WQE from a SRQ the QP uses an incorrect size.
The size should have been the size of the rxe_send_wqe struct not the size
of a pointer to it. The result is that IO operations using a SRQ on the
responder side will fail.

Fixes: ec0fa2445c18 ("RDMA/rxe: Fix over copying in get_srq_wqe")
Link: https://lore.kernel.org/r/20210729220039.18549-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: Clean cherry-pick. Needed as a prerequisite for
 "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 207889332b963..55b5146424e61 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -311,7 +311,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.53.0



