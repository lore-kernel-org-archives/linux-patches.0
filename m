Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5368E1863F;
	Mon, 27 May 2024 19:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837352; cv=none; b=syxjLihzmkJUrf0NM7vkBc9iZFN8jiotUMtg1IZi8SpQ8hIcQRJjaxdT3dxoODE/31DreCdE9U8+M0lRPq4WCc+bgtHyQSAY8dEP4sbtduWiMQLolzXwt16O9GmSQUS/IdknBLUnG+BxLG4/B9k5hOjim2R3CfkCbf8YZCy5ww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837352; c=relaxed/simple;
	bh=yxWbgenmY2d94v43ffrSQ89ooME78WpjBhq+9/RV/FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z33/8K0Rs4bzr4qiT9xXOoB9I3qTYng5f3uaMjJimL6s5OJlx7X5Zo3axZR2T04IGQ6BkIAlf7KmPhQvVlQmZefG4E6g5LyZ1cXIvzwlXG8/mK+LtA4aXjRanU2RmG7NAwQO88fm4ehbJi4TafFtH5BAIVfukDDu1XO5yzcCIJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa7ZSyVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa7ZSyVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB02BC2BBFC;
	Mon, 27 May 2024 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837352;
	bh=yxWbgenmY2d94v43ffrSQ89ooME78WpjBhq+9/RV/FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa7ZSyVsBhZ0mjudlM3XEqN8gLAYrjxrj8SHoPayu1vpxvk/M2tRhHKgrMv47QcQp
	 iMoE+4cdkcqhc2nZtt2fC6mCjurBewOy9RVYgz53tAj3L/hkKxLBgJ3X0F3pMwJkux
	 4ziD645PzA140FBQaC6oqbVbMGVY44ofIzBisXhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 368/427] RDMA/rxe: Allow good work requests to be executed
Date: Mon, 27 May 2024 20:56:55 +0200
Message-ID: <20240527185634.117489888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 614581989b381..a49784e5156c5 100644
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



