Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80E4385D7B;
	Sat, 17 Oct 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259531; cv=none; b=k99UVMOuwt7QP88qrwtY17UpZaSvnTboVU6Y4kgcjXSkDNx3gy6MnXcbQZrwNWbnmZkPQU0G36J1BHH+7y4OteIvbI84GUxl+32CKPUwFfFrs0G9ZJJ7k79/moQrUGMGO7+mW/CSu0lGNYdrWLlMzPLlKPVRVA5lFqtAWgIVbec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259531; c=relaxed/simple;
	bh=rgofynVTeggC3YeOqrmLLO7CuWR5038z+4vDJeEHE1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=butl3N1ssNIihERN9i5BXt++oSpO14ajNJye/0Fv152oVpmWjxIimAPyiWwglV9H+v5gkUI1HT+EFvArM/6rnqt/llEzmAfaJqnnPgOxMIF11Iv/Hi+3Slj4v+1Rz9+Z7t0lqwoJn+qfEHm88euJj/f/Gn3YkdKXR1Rr58+E1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj/Wtcnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj/Wtcnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D096D1F000C4;
	Sat, 17 Oct 2026 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259530;
	bh=fTLYXCtOezb9OCCKa1Hu0tLGlcq/VPPm3MEpeivYh6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xj/Wtcnm8xatVv3b6+PlL9TxXrOXAIX1i+kLCkOTMjPOXeJhGTOOntv2sAMVUTEqX
	 VKwnQWy9HVSy+lARDCPXU10OeJqjrzOkaYHTswQJu4qsK16y5DXOySXfj+A40RWGGi
	 07cZySA0OojHrJcQkIVejMcI75OSo2+qKn0Ba5wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1246/1674] RDMA/rxe: Remove redundant scheduling of rxe_completer
Date: Sat, 17 Oct 2026 17:58:38 +0200
Message-ID: <20261017160503.116919181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit ff30e45376d2ea68e032e6430babc0df15c4fc39 ]

In rxe_post_send_kernel() if the qp is in the error state after posting
the work requests the rxe_completer() task is scheduled.

But, the only way to move the qp into the error state is to call
rxe_qp_error() which also schedules the rxe_completer() task to drain the
queues. Calling it a second time has no effect. This commit removes the
redundant call.

Link: https://lore.kernel.org/r/20240329145513.35381-6-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 6f7014237405 ("RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index a7bfa9532d697..fba7182c979e7 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -915,11 +915,6 @@ static int rxe_post_send_kernel(struct rxe_qp *qp,
 	if (good)
 		rxe_sched_task(&qp->req.task);
 
-	spin_lock_irqsave(&qp->state_lock, flags);
-	if (qp_state(qp) == IB_QPS_ERR)
-		rxe_sched_task(&qp->comp.task);
-	spin_unlock_irqrestore(&qp->state_lock, flags);
-
 	return err;
 }
 
-- 
2.53.0



