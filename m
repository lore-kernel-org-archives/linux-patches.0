Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742D231829;
	Tue, 21 Jul 2026 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660052; cv=none; b=WmJ7fbVqBnUZQFi/p7+vIZvRp2BxJC2mtXL61S+1TFDWnKTEt/rss+/+ikVyvK95viJL+K5C/xMo9wDumUIHUtKpwBoc8gpriYF6qrRe6TbxJR8bMrmkaedXefNwVEYdZH/OT7jHoZz9xLilsvvAgvWhChxdh9YkRpN2Ib6J1NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660052; c=relaxed/simple;
	bh=iroDmxlPvieLCJhahRdz0auFtG77O04Q+qNgU7dqrs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIy3/FKn24ojZGONx4kZWIXcdWh18w0FSj1quOotPpLjETMh2L2wDr+JwhIjBRWA+ko/S8LCK9p8aQQNSba84GWLmXNxfS/TAEZwQrITo5qo919MVtdxv9D1JYrzDsT/OTeyPIiEY+xnwcjmOFFtN36TtDDP1cHurYQrGokNCGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCZdAIlY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCZdAIlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDBD1F000E9;
	Tue, 21 Jul 2026 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660051;
	bh=GfUz7hUBOppktsuIBYhIAWv8+ucReE6RCuZpRSXrFMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCZdAIlYdypvXoZ4sR8vid4KBYi0GvVB1RA32uzvzbHnrF6bEVBEpoMsP8SgfMgQe
	 uN/iWc0Lvv9yLUG0HtQzUo3iy5Q5sjL+SPSCris+ufeVNa8mza3oR9Ewcx05kFv30B
	 X7g2Xoo3oBp559G+/JygSZwHN2yKIeDgPfaDr4os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0826/2077] net/9p: fix race condition on rdma->state in trans_rdma.c
Date: Tue, 21 Jul 2026 17:08:19 +0200
Message-ID: <20260721152612.270193686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 7d54894a1ee265a72d70f7cae1da6cc774cccc71 ]

The rdma->state field is modified without holding req_lock in both
recv_done() and p9_cm_event_handler(), while rdma_request() accesses
the same field under the req_lock spinlock. This inconsistent locking
creates a race condition:

- recv_done() running in softirq completion context sets
  rdma->state = P9_RDMA_FLUSHING without acquiring req_lock

- p9_cm_event_handler() modifies rdma->state at multiple points
  (ADDR_RESOLVED, ROUTE_RESOLVED, ESTABLISHED, CLOSED) without
  req_lock

- rdma_request() uses spin_lock_irqsave(&rdma->req_lock, flags) to
  protect the read-modify-write of rdma->state

The race can cause lost state transitions: recv_done() or the CM
event handler could set state to FLUSHING/CLOSED while rdma_request()
is concurrently checking or modifying state under the lock, leading to
the FLUSHING transition being silently overwritten by CLOSING. This
corrupts the connection state machine and can cause use-after-free on
RDMA request objects during teardown.

Fix by adding req_lock protection to all rdma->state modifications in
recv_done() and p9_cm_event_handler(), matching the pattern already
used in rdma_request(). Use spin_lock_irqsave/spin_unlock_irqrestore
in the CM event handler since it can race with recv_done() which runs
in softirq context.

Tested with a kernel module that races two threads (simulating
rdma_request and recv_done/CM handler) on rdma->state with proper
locking: 5.5M+ FLUSHING writes over 27M iterations with 0 lost
transitions.

Fixes: 473c7dd1d7b5 ("9p/rdma: remove useless check in cm_event_handler")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260529073933.77315-1-zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_rdma.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index aa5bd74d333f3b..b4274f10fa4487 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -128,25 +128,36 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
 	struct p9_client *c = id->context;
 	struct p9_trans_rdma *rdma = c->trans;
+	unsigned long flags;
+
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
+		spin_lock_irqsave(&rdma->req_lock, flags);
 		BUG_ON(rdma->state != P9_RDMA_INIT);
 		rdma->state = P9_RDMA_ADDR_RESOLVED;
+		spin_unlock_irqrestore(&rdma->req_lock, flags);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
+		spin_lock_irqsave(&rdma->req_lock, flags);
 		BUG_ON(rdma->state != P9_RDMA_ADDR_RESOLVED);
 		rdma->state = P9_RDMA_ROUTE_RESOLVED;
+		spin_unlock_irqrestore(&rdma->req_lock, flags);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
+		spin_lock_irqsave(&rdma->req_lock, flags);
 		BUG_ON(rdma->state != P9_RDMA_ROUTE_RESOLVED);
 		rdma->state = P9_RDMA_CONNECTED;
+		spin_unlock_irqrestore(&rdma->req_lock, flags);
 		break;
 
 	case RDMA_CM_EVENT_DISCONNECTED:
-		if (rdma)
+		if (rdma) {
+			spin_lock_irqsave(&rdma->req_lock, flags);
 			rdma->state = P9_RDMA_CLOSED;
+			spin_unlock_irqrestore(&rdma->req_lock, flags);
+		}
 		c->status = Disconnected;
 		break;
 
@@ -184,6 +195,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct p9_req_t *req;
 	int err = 0;
 	int16_t tag;
+	unsigned long flags;
 
 	req = NULL;
 	ib_dma_unmap_single(rdma->cm_id->device, c->busa, client->msize,
@@ -220,7 +232,10 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
  err_out:
 	p9_debug(P9_DEBUG_ERROR, "req %p err %d status %d\n",
 			req, err, wc->status);
-	rdma->state = P9_RDMA_FLUSHING;
+	spin_lock_irqsave(&rdma->req_lock, flags);
+	if (rdma->state < P9_RDMA_FLUSHING)
+		rdma->state = P9_RDMA_FLUSHING;
+	spin_unlock_irqrestore(&rdma->req_lock, flags);
 	client->status = Disconnected;
 	goto out;
 }
-- 
2.53.0



