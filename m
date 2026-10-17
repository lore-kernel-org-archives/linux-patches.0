Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584B836B93B;
	Sat, 17 Oct 2026 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254485; cv=none; b=q3iCDKlcAuZXOrOIV0SPwgG4ZQ7EmrFIUiSNOVV4OXYcIWvT+ZHWDppC3jUlcYS2q7lkHAtZXwJvJUre8cTsFJvsRGc8bT9mb4qcdWq9UJcb1zQNf5YcwaeQp11x3oQIxTQyyVCOVXAToFGmF63wL6/KoW+tC6yhCBTC6PVSzQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254485; c=relaxed/simple;
	bh=7Bkzd+lhKjLewFuoW6m7+hEIe70eiUNWIlwLl47N0Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByyT2cM60ikUZ/Ouq/1XOjaXP+dHDl2uNcK/gNxl+SJc4aDhPhj/eDji3gE14FZpjh3b2jk4KUBfbcopUQDtKH2b9fJUOEI30L2L441wnS7TBNvo1BXLAqRqSEfn+IeWJBv1+I9eyQoqgcT/2UG5kU9R0bZXfh1Qh6O4dMLoJCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5ieKPgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5ieKPgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A207D1F000C4;
	Sat, 17 Oct 2026 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254484;
	bh=Xvj7GJboD+QJ+JaT6GHHgPiOi44O/iXMDr8caI8yue4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5ieKPgbN/4KTf72Hq9sPi9UqPN5T7/oKBT1uSxTvFWtUNEffmCJYP3rWJDar4Vrh
	 6tMjnmywc5PEVyMxrv3tM3oVXXYC5K0TqJrh3kNf84DFYtstDYY/4LORDNdLPSSzNS
	 oemzwNdTb+mW5ewKrPMy69K2yHil28b6PJ+3Mes0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/869] RDMA/bnxt_re: Free SRQ toggle page after firmware teardown
Date: Sat, 17 Oct 2026 17:55:02 +0200
Message-ID: <20261017160048.953271343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 131e2918b9b0529687e67e2e58047304027f095a ]

Free the toggle page only after firmware teardown completes so that
an NQ interrupt arriving during bnxt_qplib_destroy_srq() won't write
the toggle values to an already-freed page. Move free_page() after
bnxt_qplib_destroy_srq().

Fixes: 181028a0d84c ("RDMA/bnxt_re: Share a page to expose per SRQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-3-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d2c3038aad69d..4e3086e6340ee 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1723,11 +1723,11 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	struct bnxt_re_dev *rdev = srq->rdev;
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
 
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
-		free_page((unsigned long)srq->uctx_srq_page);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
 		hash_del(&srq->hash_entry);
-	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
+		free_page((unsigned long)srq->uctx_srq_page);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
 	return 0;
-- 
2.53.0



