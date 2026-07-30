Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CCC445ACE;
	Thu, 30 Jul 2026 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423468; cv=none; b=BDhDoatG0wBG1v6H3DMM3ggL/zuvGmENTPlHFQDL29fcUzNU/qrpppcCxq81efXB6XDsubFecM3/xRnuyoiH8L4rbMfm+O2oAgrc6mcC56sePc/SSMRK5IegarhstGeHTsbv5FftvRNhPPT/QKkZacpyAr8UnuopoXV9JmjGA8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423468; c=relaxed/simple;
	bh=hsgj02+xW0GEpPKXU05vv6eFrZtxU3dRJmCEMGuJec0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3u7YUzDbQT/8qBAmwzNI2ZdQ7J5JNRjWRE/cqEgejU90ecSOSuKSRKc87Dg2Z3Jo7fIdL+c46pacUrdu6JWCFuJBwcPjGYehI4yyNs3jh8eqck6G3z/YPo+d4LZMyYt9zGEDo6R5wGjUlOl37zACNvwktkJhjcQdxEEFNC1RSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAL4sd79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAL4sd79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5502A1F000E9;
	Thu, 30 Jul 2026 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423466;
	bh=xFNOAE9AT6gdSy7IeObqYTn2P5Gs4iA2o+sWwhI1Kqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAL4sd79pcaFHWFC70s5HrxnfwhXSHusfFCLZOV2oBLUP0WQat6NR8k68ULmlo8Ga
	 6y2RVIUP7LYJVyJn+butZdDnk7MM5Oqgg6OZzivSWovZ0LStOL1Rd9jOkffHWPmhO6
	 lfgk7Ryqy9/98cTOteMBqCVUh6NldXHSLsZaILjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/675] RDMA/erdma: initialize ret for empty receive WR lists
Date: Thu, 30 Jul 2026 16:06:24 +0200
Message-ID: <20260730141446.266503844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 25f6c49aec7798..e002343832f74d 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -734,7 +734,7 @@ int erdma_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *recv_wr,
 	const struct ib_recv_wr *wr = recv_wr;
 	struct erdma_qp *qp = to_eqp(ibqp);
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	spin_lock_irqsave(&qp->lock, flags);
 
-- 
2.53.0



