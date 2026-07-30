Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CA3644C9;
	Thu, 30 Jul 2026 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421369; cv=none; b=UHpH6r3QCL2sWFwrCtE/GVpxLRalgzxHqfApdsu6AoD/1lR/0G+oZzxVsw813951DFxrxHJlBUgOXyBl9NHpbyUCGaffDZmzdfRM1L26eFSTR0FK6XwLojW5SeXTKiJr4djRV2MPqVFoKDOQVT4vJRlg3GjEEzSPABxAl5Yzk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421369; c=relaxed/simple;
	bh=kAreQQC+Um4GtiXaFpd+Drisry72m76u4Uu3wNgE+8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0+74wu6lfte5vhdK8BtXIg4ZGrxcD9DZ3f0u7H4ppZE/ek1TVM74hJ1m/dAlo1qrGFvun516b9kZe74JUoGJ0jxxd96xkOelaa1/AI04M7kAi38abKq+qrV9pUNlAtTUSyUkGyqmX52jXkoAZz3ZbBAMaxRuhqDsf6YIGBPvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVDsf1cO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVDsf1cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4990E1F000E9;
	Thu, 30 Jul 2026 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421367;
	bh=rBMf5OmVko6EPTPWyn5mSMiWYnVCg76JFZmqux7QWO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVDsf1cOkrFQArmgyEOcpVwPwaBujAl9Biu4bynlIz0taWBRBR5p6xos5sfp2pGVH
	 JBy8lmb4XxYtffGdLW5A3vs8SAUUvldBWiKR88p8zszaNwYn0yWFkONJii07K3Yh8m
	 OChEfd4qXXihWdIoiNmvuHzvxuJORSUWmOIPnbWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 036/744] RDMA/erdma: initialize ret for empty receive WR lists
Date: Thu, 30 Jul 2026 16:05:09 +0200
Message-ID: <20260730141445.050185748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



