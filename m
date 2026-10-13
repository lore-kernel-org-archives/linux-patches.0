Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9A44F85D0;
	Tue, 13 Oct 2026 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893736; cv=none; b=YgYDsD+FUjTWs1nTIvnVxA37MOk5Z63xIz5pHR7vA+Ix4yJs0njjiu2WmS0r/xJ2FZOkxl6BFB4h7L5kgeyCgSfEeuJFjQf8b2DTR+4fb/BQ0/9hkDbiFqVdDm3R8nZB/av9zvsbwlprgR21tVX4Vq+h8VgRdJD0YbdRopFliwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893736; c=relaxed/simple;
	bh=AhvvxyHZexGBC9gRQqZSDqnYWB5iItjNGy3hzdzOjM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nf2S67UTzmgkmOQdqvt7L/AVnClqIArjM8GajWEtwekLHjRooXqY/U1lWxAXY1rIRSjffNOwdBwz4YiecL0Jnv5KRFqFQUG12C3w4KiPzt3kd5HOtlHApPFu9aoeDL7Ctsw8jWx47cwzGn9bWVcXLaEZzMYbPt3yCj6TGtaa6jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu0WvJ4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu0WvJ4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6842F1F00893;
	Tue, 13 Oct 2026 12:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893735;
	bh=AZV/4m1/d9ARgcDvV3lTh4PdpVS7l4wS/WmZUFCcyYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iu0WvJ4rEL2gFUcDjUwsBL8MH1bIlaYwzAQTAGeilWkoxoCUK5924l2ET7Nay9Mvw
	 J4bRjvkvPOr1oCu6Yr28G9zv4UixKxllUIffsPHEgpLPS9s+pIRq1Mqyg+ePKL2orl
	 fOd9oG+BWZ99P1OoxhfvByALxGSr0N+GsxN6JFhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/621] RDMA/bnxt_re: Free CQ toggle page after firmware teardown
Date: Tue, 13 Oct 2026 13:34:53 +0200
Message-ID: <20261013112927.926106105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 48d5133671c4b..fcd57d34ee072 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3105,11 +3105,11 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
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
 
 	bnxt_re_put_nq(rdev, nq);
 	ib_umem_release(cq->umem);
-- 
2.53.0



