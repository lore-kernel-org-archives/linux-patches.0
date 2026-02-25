Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BD22D063E;
	Wed, 25 Feb 2026 06:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002608; cv=none; b=oF8ADeo7sVnZhBYa8O1MRb7uDpeD3eHAwC6p3fSPmGYFzZndF9Ln9QhuMYw/PrtoC1X2zsXFW1qyuCw68oeZDDl/fwQzkF+7cbxk2p+Qj+fF+WJ4fa5nOzOj8sptyI4+PzG99BL6Z5mcLpIDUuYgXbV4/ztf314/mDcICmI4rZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002608; c=relaxed/simple;
	bh=Jwcz3hRADV13+aQiAx6q0/Wox2/152N7huxsMnMY6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbBuhegO+B9h9NYFWZ/9n+ikYsUrzcGYGHn1Za/PkvNsvprXCkPgaSZaUbDW3/iXtVxTIPVw0Xg3cMT/vlt+I84bRXV391NtESCaQ4O31dqicweNItdBv9Adw53eKOB4nAU7ySxjypb4nc0CVCuXowc/QTVA9QJ6SW9FGmcQxbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPK60Ij2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPK60Ij2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE46C116D0;
	Wed, 25 Feb 2026 06:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002608;
	bh=Jwcz3hRADV13+aQiAx6q0/Wox2/152N7huxsMnMY6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPK60Ij2xs1kFt1TRJC639gI4R20QrhJu3byZMtbyaR/SGezGoembF+fNSBVQebup
	 6TzOnv/rm4MKSdOUUKJWOmuvJEKpeSkZ3w2QGK3hV2pRMCN0lss9UMKZHp/GgrOQyt
	 eFDlW6E5stLP0KDiSVM+y3IstWutdBunP+shvwso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Zhu Yanjun <yanjun.Zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/641] RDMA/rxe: Fix double free in rxe_srq_from_init
Date: Tue, 24 Feb 2026 17:21:24 -0800
Message-ID: <20260225012357.300489441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 ]

In rxe_srq_from_init(), the queue pointer 'q' is assigned to
'srq->rq.queue' before copying the SRQ number to user space.
If copy_to_user() fails, the function calls rxe_queue_cleanup()
to free the queue, but leaves the now-invalid pointer in
'srq->rq.queue'.

The caller of rxe_srq_from_init() (rxe_create_srq) eventually
calls rxe_srq_cleanup() upon receiving the error, which triggers
a second rxe_queue_cleanup() on the same memory, leading to a
double free.

The call trace looks like this:
   kmem_cache_free+0x.../0x...
   rxe_queue_cleanup+0x1a/0x30 [rdma_rxe]
   rxe_srq_cleanup+0x42/0x60 [rdma_rxe]
   rxe_elem_release+0x31/0x70 [rdma_rxe]
   rxe_create_srq+0x12b/0x1a0 [rdma_rxe]
   ib_create_srq_user+0x9a/0x150 [ib_core]

Fix this by moving 'srq->rq.queue = q' after copy_to_user.

Fixes: aae0484e15f0 ("IB/rxe: avoid srq memory leak")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20260112015412.29458-1-jiashengjiangcool@gmail.com
Reviewed-by: Zhu Yanjun <yanjun.Zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 2a234f26ac104..c9a7cd38953d3 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -77,9 +77,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		goto err_free;
 	}
 
-	srq->rq.queue = q;
-	init->attr.max_wr = srq->rq.max_wr;
-
 	if (uresp) {
 		if (copy_to_user(&uresp->srq_num, &srq->srq_num,
 				 sizeof(uresp->srq_num))) {
@@ -88,6 +85,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
+	srq->rq.queue = q;
+	init->attr.max_wr = srq->rq.max_wr;
+
 	return 0;
 
 err_free:
-- 
2.51.0



