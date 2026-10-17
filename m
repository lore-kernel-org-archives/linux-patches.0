Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA4036B93B;
	Sat, 17 Oct 2026 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254476; cv=none; b=FAAsI1CEYS7sCD/ubjWyOwyLNT7kUwu4EA7Y00BepYRWfCZVZVfwzGQwEMYmhTnUGp3F7TalxzhPcmu9uHCQMoI22hP4nRXrn163SYrdVpWY5r4MarOZdNJGszQjA3Uh8Q5OhtP+xCwXq0BO8iekDQ5lx2jiBGXPVKdqG4CQ9uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254476; c=relaxed/simple;
	bh=LCGW+Q2jOY3OGQaLN1quEkSoLJ13QC8sjzgbyBhT2L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA3FwcWJPp70kny8V8wej2JYY5wae6nLHKUC2mOSxirgkTSm7pNVH7AicUi17kezcmh2gY4015Dt9/7kY9kNQReq2xICnFjVhP7phUaueNnWfm4BNkT/j37oq5gK0nfC8ZlKFzx9jFHb/ltZFGMYYNM8HnpjHaFTiQr/S0FKMpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wulCE1GS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wulCE1GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8433D1F000C4;
	Sat, 17 Oct 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254475;
	bh=FNJkaZ7zfvyyqDmwzM11bmf3f1E6vvABRYVdppyygzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wulCE1GSSNkUMMkB60BttD4VZZg27EI+V8f8BLQEAx3jZkblyaluh9GDYn7CJM6p6
	 nDcTIY7mIuvZrts5znsDyHxfL1wh1p+BXyFfU6mYPah8/zihYelnPKUddEkySKfRYI
	 PIJ8Y3CsqF/K/R4eidm4XVBhvAe4PsEvc555bOSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 458/869] RDMA/bnxt_re: Free CQ toggle page after firmware teardown
Date: Sat, 17 Oct 2026 17:54:59 +0200
Message-ID: <20261017160048.877982429@linuxfoundation.org>
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

[ Upstream commit bb45e06f9914ca64ac95341a80a0c20bb8dd46a9 ]

Free the toggle page only after firmware teardown completes so that
an NQ interrupt arriving during bnxt_qplib_destroy_cq() won't write
the toggle value to an already-freed page. Move free_page() after
bnxt_qplib_destroy_cq.

Fixes: e275919d9669 ("RDMA/bnxt_re: Share a page to expose per CQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-4-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 86de1d9bca6b2..324825ecf6b2c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2987,11 +2987,11 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	nq = cq->qplib_cq.nq;
 	cctx = rdev->chip_ctx;
 
-	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
-		free_page((unsigned long)cq->uctx_cq_page);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
 		hash_del(&cq->hash_entry);
-	}
 	bnxt_qplib_destroy_cq(&rdev->qplib_res, &cq->qplib_cq);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
+		free_page((unsigned long)cq->uctx_cq_page);
 	ib_umem_release(cq->umem);
 
 	atomic_dec(&rdev->stats.res.cq_count);
-- 
2.53.0



