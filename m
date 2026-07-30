Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C47544D01F;
	Thu, 30 Jul 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425504; cv=none; b=rXVEmGQil14Kf737pekluJeobjSLzIKde+tVk0b1g5D58dqmpKFZ9TCnSikznrstE3FEEzIpOVXFeGlBEKzJOmTiiXJmLmfCN38wBaWLEVligwyCJ/Lb78JK2KCEbHeZsd083Qz3ID7TqyAMUYZCVJGe9rgPxJxLjdagBOCytFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425504; c=relaxed/simple;
	bh=1UGIDn+aHni12AdCXDlpdRyV1OsFZbsC4JXoH+2qmdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poSy4C49S5lBk5dxgFJ4sgv08iqjMwq2D/yGQqi0xio6pB/joBH8IwxmNHAhJcM2gv6vu8nFXg9p5Jlh6ZfdR91l9tPDsBaE7osL9kQpH0rG7suGo8G3rNFAWGwn5XeGaZO21ugHN8AY02P4LTp6YePvz5hZVFd6Nok1asbjVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afo4u+Nk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afo4u+Nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBFB1F000E9;
	Thu, 30 Jul 2026 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425503;
	bh=svsZH+wG5nY2+vJyRvFbGgkeKEFL0a73m/xoV7Foqwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afo4u+NkwGgb+grWvCCuxjcCEKECfkj/93CLRQEz1KZzs1w48aOopNakqWeq7iPsh
	 8ztoj3oO6caNLSMW5NZEemSa+2E6hOAR3zUk+rAcSFnM3WND1k3kzzLNjBtp25ROb8
	 0BX1xhli5bw1Dx5DXZHsitHBANTivuyLPpwCh1Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/602] RDMA/erdma: initialize ret for empty receive WR lists
Date: Thu, 30 Jul 2026 16:07:19 +0200
Message-ID: <20260730141436.994626404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 2815a277c53e9a84784d6410cd55a9da5b33068d ]

erdma_post_recv() returns ret after walking the receive work request list.
If the caller passes an empty list, the loop is skipped and ret is not
assigned.

Initialize ret to 0 so an empty receive work request list returns success
instead of stack data.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Link: https://patch.msgid.link/r/20260618041752.481193-1-ruoyuw560@gmail.com
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
index 4d1f9114cd97c5..4dfab0c49e5192 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -573,7 +573,7 @@ int erdma_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *recv_wr,
 	const struct ib_recv_wr *wr = recv_wr;
 	struct erdma_qp *qp = to_eqp(ibqp);
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	spin_lock_irqsave(&qp->lock, flags);
 
-- 
2.53.0



