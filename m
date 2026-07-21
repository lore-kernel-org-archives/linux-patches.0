Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B22439322;
	Tue, 21 Jul 2026 22:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671769; cv=none; b=TzBEN7EYfYvYqS3/AGMh4TBPHL1OI6/OM2k/fKN8/cFhcaWRpTCR/28gg+QX2s9fstq9r68vRBVjiZ6fzBNFqIIPQdjUjQyFOCXSvM4RmRdPL4PyfLwqrHyf/7xj/j3EZ2lBaESaDunXjmqJxg4y0tjeFDoicH/q5NzovLahnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671769; c=relaxed/simple;
	bh=UEvcOtfqO/0laHNlI/QTM2AYT20BlMVFIhgTnddaOZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJDA5YAyK9jdPlc9kO0fAtSZxZzQdK6El97cPjyMhtt2aKx0jZhtIfZcRtW/heCl0EJoQHAGoK9YgkTc2tfTZVtvwC8+FjwlAsvg9qcSjiUXU61CNAP6RCeZKUvNmhWoPON9/cgWyGO6EvPk+n3jOjA2Wu5rWzeN4/M3iUh+b8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLQIvIpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLQIvIpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01951F000E9;
	Tue, 21 Jul 2026 22:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671767;
	bh=Pg9qBb1wMv2l2Vm2QHRzakdna5wX3Lq7WUGJ3kCDYaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLQIvIpa5Gu4NteZi91iqqxeyfTh9PdzPEefgEQu5LYdb4PtQGxIoseamAIbTSjXK
	 P0LBMATRAKoqBCUK7nVSqdbpjnSaEA2kxnV5htQ1jaMwcNJs38d5AlQhSok9dXVwzn
	 gPmCDoRGc1dgbSpvQHtAB/7Wzjsh+U4S/cumHtZ0=
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
Subject: [PATCH 5.15 372/843] net/9p: fix race condition on rdma->state in trans_rdma.c
Date: Tue, 21 Jul 2026 17:20:07 +0200
Message-ID: <20260721152414.401908276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e5bfe8d7ef4497..91a165c7f6bb11 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -243,25 +243,36 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
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
 
@@ -299,6 +310,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct p9_req_t *req;
 	int err = 0;
 	int16_t tag;
+	unsigned long flags;
 
 	req = NULL;
 	ib_dma_unmap_single(rdma->cm_id->device, c->busa, client->msize,
@@ -335,7 +347,10 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



