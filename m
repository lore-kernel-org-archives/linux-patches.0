Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35928376A0B;
	Tue, 21 Jul 2026 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669298; cv=none; b=SG9e4VGF1VnqtYixY9L4KjzACxXICj88dKhZnsrsfVTMBhlnwZ/npmdbbXJloo3mjSbN0ceP4XjKpPtVrlce6XqTnSGr6W/58f3BKdM5J6pI6feWjWzb/T9Xm9knUAyi3WnUTK4sX29YGTzewiyvsoZ79eUFJSiWAkQgM1bpqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669298; c=relaxed/simple;
	bh=OHAV/zKOLXwcf1SIIlD1eYBuytWT4keziATZzAuuybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sW0ykHKmf1UTJRWllnpxtoPuZ6sWRUNAG1uoa4UzJbIBLKZL+jklU2Ziaq1sdCCSmJMPuKZ6YKzjTNQTOEnEW6bvxf/f0G+b0vuqcPCWDUkSXcilE0uul69mnkdULDeGtVKHkl+t2Zm9gzvOCOSsdtT+Y2/yVlzlWjM15k+PbRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJdDRdXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJdDRdXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F0C1F00A3D;
	Tue, 21 Jul 2026 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669287;
	bh=AcHtB7jtWpxjXWOfCME2074Qbdx9LTtz2Hjq1dsAo3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJdDRdXWVLz2mlXH60joYYTpYyt8oexRb/3wiRk/EbGJ3H6espOYoDRp0oo8msBAy
	 iaq9tZ3ZB+gCj8if74d64v8zAjvDiY/GZqiw3+h+nRjnGiMeLDM4KyWTRdrsV0GvBF
	 0U0cQnD1+ge7x1MD9JXFHnh4w94dHuoziR6RARhw=
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
Subject: [PATCH 6.1 0471/1067] net/9p: fix race condition on rdma->state in trans_rdma.c
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152435.152109117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29a9292303ea30..e3ee21bbe389a5 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -241,25 +241,36 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
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
 
@@ -297,6 +308,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct p9_req_t *req;
 	int err = 0;
 	int16_t tag;
+	unsigned long flags;
 
 	req = NULL;
 	ib_dma_unmap_single(rdma->cm_id->device, c->busa, client->msize,
@@ -333,7 +345,10 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



