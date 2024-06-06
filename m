Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDBA198A3B;
	Thu,  6 Jun 2024 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683405; cv=none; b=kCJmYN3e/uTdpWK6pw38QRjE/OEmoRtLEHPsc17ABmLsQJKf67Rij6UjVc67vTvz5zTDjkFwi5OdST3CjmmcRDSyKLCLQbWKuJPimR/5QTkv38S9J9Q0nPuAKUoRRH2ikLcwsV/o2sAoJlXIhOFE6EAtq4nCzLLMPiihexBWJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683405; c=relaxed/simple;
	bh=geedD676MrdwoHXh28mk/KWLorJhH19Jy3fqfP1zzto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxYEONO+CjPDDKgHLR5FmNDDDjdw4azd60g45+tz85rm6X234jNhiRsZZIQ6EtN784nwEuIuCf95gKo7ZWD4x0cdbGZhFfeNkR13MkkVbl84cq/MuyYkCAMyj3QVTvmDj5w2XvcGVBbjTT+LfaUT37KcEnOl+9fAN6QZXVIOzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmTii+P4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmTii+P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5B4C2BD10;
	Thu,  6 Jun 2024 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683405;
	bh=geedD676MrdwoHXh28mk/KWLorJhH19Jy3fqfP1zzto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmTii+P45rdaLdO03cDJACMRWvcMDg/uoIW4721fMMvH32P2A3QjKE4m4+nXv7YnM
	 RmO0qNifHaOf0mlVOGQxZdziUHWRhLOdmlHib6d9eEIqtPf4hV0MBrRU6GotHz3gCa
	 b5BWUVJLcTTJQ2HHQur4QadX5zCrAYxleCTSG0rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/744] RDMA/rxe: Allow good work requests to be executed
Date: Thu,  6 Jun 2024 16:00:21 +0200
Message-ID: <20240606131743.665710112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit b703374837a8f8422fa3f1edcf65505421a65a6a ]

A previous commit incorrectly added an 'if(!err)' before scheduling the
requester task in rxe_post_send_kernel(). But if there were send wrs
successfully added to the send queue before a bad wr they might never get
executed.

This commit fixes this by scheduling the requester task if any wqes were
successfully posted in rxe_post_send_kernel() in rxe_verbs.c.

Link: https://lore.kernel.org/r/20240329145513.35381-5-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Fixes: 5bf944f24129 ("RDMA/rxe: Add error messages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 48f86839d36a8..0930350522e38 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -888,6 +888,7 @@ static int rxe_post_send_kernel(struct rxe_qp *qp,
 {
 	int err = 0;
 	unsigned long flags;
+	int good = 0;
 
 	spin_lock_irqsave(&qp->sq.sq_lock, flags);
 	while (ibwr) {
@@ -895,12 +896,15 @@ static int rxe_post_send_kernel(struct rxe_qp *qp,
 		if (err) {
 			*bad_wr = ibwr;
 			break;
+		} else {
+			good++;
 		}
 		ibwr = ibwr->next;
 	}
 	spin_unlock_irqrestore(&qp->sq.sq_lock, flags);
 
-	if (!err)
+	/* kickoff processing of any posted wqes */
+	if (good)
 		rxe_sched_task(&qp->req.task);
 
 	spin_lock_irqsave(&qp->state_lock, flags);
-- 
2.43.0



