Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C21E1EEF7;
	Mon, 27 May 2024 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838568; cv=none; b=lGc9xFki3K+puy97yZKez5zR8e404mp1aA0hpfVZ6LqJvMmT50wUiriIpKH4zXV3jweNw0p57URoBGIPnVtRY7MErQBBDfssDkyKQCNjlW/0LL6da2AQKKzQLDQkPfA2ynmy/DpmRcKJLjdmEO0TpVLccRiA5DIxKRLZJ7XZvmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838568; c=relaxed/simple;
	bh=VfucMVUdu6u5OHe9C3esFkpdSBE8I3eT5kYxrqtBCy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXPVparXhZT1Sh0G/fH4oI1xX52/FA/ubujDr2rSPrDz8uTvPZI5+o0jObE5aDOvPVWrtpznu7gsrerUh8MPL20mcBZK8S9oA5O8pMykAzigaFKESpPpbEnDjj1B0j8IZWkLH9R4wBw87izgS2K6hfncEbJHkU6fXEhTtTbgAWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBfjEsAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBfjEsAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE10C2BBFC;
	Mon, 27 May 2024 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838568;
	bh=VfucMVUdu6u5OHe9C3esFkpdSBE8I3eT5kYxrqtBCy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBfjEsAgw0mvQwE3aCh+trEtpYeuzCeXo+7f+CbdtLwzX2pFFYsZOoT/pQDE5Ts+G
	 MN8KUYAHeH8v7JaFh21hGs/As15eP61HT2Qund4Ziz9RGr3P7imJIIzRCwHAKWLtCa
	 HR5aSVvJYJeoDHwjGdwpdYj1WRPcpfouMqGP+YFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 436/493] RDMA/rxe: Allow good work requests to be executed
Date: Mon, 27 May 2024 20:57:18 +0200
Message-ID: <20240527185644.535812638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



