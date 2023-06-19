Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E823C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1C2C433C0;
	Mon, 19 Jun 2023 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171160;
	bh=U8cqqUwwZx1u9yAoqLL8HzTJq7jMDHptyOB6V5l+v3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI/OE1Che3XGy+N8qJkCXOsVB6jEec70paY+UTxV8FIFwt9itNenNQj+o1E3ekxHj
	 KvR2460vGYcNJguqRbgOKbBuA1+dF2LJHlGglDeCgbechw8NCEPuGOO3MO1EG6fQer
	 +6iTvXPBVK9TQl0ZpnWdF0bx+7R7trGc/TUXLR5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 169/187] RDMA/rxe: Fix rxe_cq_post
Date: Mon, 19 Jun 2023 12:29:47 +0200
Message-ID: <20230619102205.824964917@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 0c7e314a6352664e12ec465f576cf039e95f8369 ]

A recent patch replaced a tasklet execution of cq->comp_handler by a
direct call. While this made sense it let changes to cq->notify state be
unprotected and assumed that the cq completion machinery and the ulp done
callbacks were reentrant. The result is that in some cases completion
events can be lost. This patch moves the cq->comp_handler call inside of
the spinlock in rxe_cq_post which solves both issues. This is compatible
with the matching code in the request notify verb.

Fixes: 78b26a335310 ("RDMA/rxe: Remove tasklet call from rxe_cq.c")
Link: https://lore.kernel.org/r/20230612155032.17036-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
index 519ddec29b4ba..d6113329fee61 100644
--- a/drivers/infiniband/sw/rxe/rxe_cq.c
+++ b/drivers/infiniband/sw/rxe/rxe_cq.c
@@ -112,8 +112,6 @@ int rxe_cq_post(struct rxe_cq *cq, struct rxe_cqe *cqe, int solicited)
 
 	queue_advance_producer(cq->queue, QUEUE_TYPE_TO_CLIENT);
 
-	spin_unlock_irqrestore(&cq->cq_lock, flags);
-
 	if ((cq->notify == IB_CQ_NEXT_COMP) ||
 	    (cq->notify == IB_CQ_SOLICITED && solicited)) {
 		cq->notify = 0;
@@ -121,6 +119,8 @@ int rxe_cq_post(struct rxe_cq *cq, struct rxe_cqe *cqe, int solicited)
 		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 	}
 
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
 	return 0;
 }
 
-- 
2.39.2



