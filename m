Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C753836D4E1;
	Thu, 30 Jul 2026 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427207; cv=none; b=CZb5WDcrhbwXcp+GBRrWgmrTlm6r87zZqO7NB6MkE+pipu/itm3v760NZR4CxKork91IgxzM9Mn8Xs80KNQE3bGsEZXrfPv24JuTDZy5siIV8HSOmodqJYgVtgJsiRD5Ep4rGYrHuqII48MEzznXU5rTkwV63FXBnxoQJSgwQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427207; c=relaxed/simple;
	bh=6PKdiW6GtBs9dFfEHACaxNGHPRZKY4uPw2oXTjO5sRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMeVlWaUKkhv7/tPLxHYHFpRaMW1tGp+BH7iv1+fhlshJSC5fnCohyRGw7uzlVAep5vI7CG7Wt4Y35VnKBTqp4qhNaxFHxpso+D5aWsXX9Jy5Z16+0EzJXwp8pBc3tkcBYFrNyIlcPpFNCqSRn6E2WG47NMfUhjz7JeYdY3bvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkWy0T14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkWy0T14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7321F000E9;
	Thu, 30 Jul 2026 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427206;
	bh=te+HiZvdg+HXtlOroF5YPLPQK9kp9avskOSRg0PKvcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkWy0T14s6Vja1i4Gd9kgIDAIsMuj47xZmB5Apy3oJ54VHSa6VWJ6QXTRIGfr4mkU
	 nPs0Y6hoH5y1Jz+OJs42tzMylyO8b1/DUOFeYMIWoLnI10WXAuNXNpvc9+uzF+1Hlo
	 7Nuq0cCDG5txKf1Fz0OIhSTcuB8mSRgNwRqFfslY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/484] RDMA/erdma: initialize ret for empty receive WR lists
Date: Thu, 30 Jul 2026 16:09:01 +0200
Message-ID: <20260730141424.380586797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 6d0330badd68e8..e3a731a45e8861 100644
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



