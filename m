Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1102A3BCD04;
	Tue, 21 Jul 2026 21:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669474; cv=none; b=D5lwnc4lKYGSs7t6yx1lvJjoYIv5fvHvNswpbBd7eej1Sm1upJzKEcCSBZypHYbUiNWk2LtgDRlf6eeMmz93jVf/xvnXLbUvYvGTbNPzDpde00oUm+/Q8Sg/R93vEmfDKlyujay7Cf5OZW6Qny1YL870sK+VkVjxEkkQ1kAgCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669474; c=relaxed/simple;
	bh=0nb91AiPl4FJVfO6tGWmd4qSECHg9sPWNF43mMa1pNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj9Y6ZdaZ6JSkjZLtfdCf+5SSWRIkC0yZ0Yziz711l+XOkW3UZASfM+RPrCJFrzmh4tm+1rdLrRvU2B4l41AWUCtQt4P5W6Mnenp8MhQsm/Fdwq/vfDTX6gAtgSY6+05oMn9l2vak+iiaJsmiQK5kRnmt1cXOp6RJQXd1h8IOc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgxntcTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgxntcTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776B91F000E9;
	Tue, 21 Jul 2026 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669473;
	bh=y13/j7LsTiTyCymnCwjp67aDmN2ZxNm1e97r80qhIts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgxntcTXrGCuCB1MnZguc2HBuZrbsAVatbERn6zM1yr3Yt6O1ulzMSGhmwNyfQp69
	 u6zFtsztdxC40Zg3oPbJ0r4QGHzUZCa+8VLzZQB3oDCPH7sgsEVXIMdaJuDgxvTmaZ
	 VH1gmAthQbGRfis+/LZ0V+IIQ/61ByIIabzjmVkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0515/1067] xprtrdma: Close lost-wakeup race in xprt_rdma_alloc_slot
Date: Tue, 21 Jul 2026 17:18:36 +0200
Message-ID: <20260721152436.131799207@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 765bde47fe7f197dabeb12da76831f40d0b20377 ]

xprt_rdma_alloc_slot() and xprt_rdma_free_slot() lack serialization
between the buffer pool and the backlog queue.  A buffer freed
after rpcrdma_buffer_get() finds the pool empty but before
rpc_sleep_on() places the task on the backlog is returned to the
pool with no waiter to wake, leaving the task stuck on the backlog
indefinitely.

After joining the backlog, re-check the pool and route any
recovered buffer through xprt_wake_up_backlog(), whose queue lock
serializes with concurrent wakeups and avoids double-assignment
of slots.

Because xprt_rdma_free_slot() does not hold reserve_lock, the
XPRT_CONGESTED double-check in xprt_throttle_congested() is
ineffective: a task can join the backlog through that path after
free_slot has already found it empty and cleared the bit.  Avoid
this by using xprt_add_backlog_noncongested(), which queues the
task without setting XPRT_CONGESTED, so every allocation reaches
xprt_rdma_alloc_slot() and its post-sleep re-check.

Fixes: edb41e61a54e ("xprtrdma: Make rpc_rqst part of rpcrdma_req")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: e786233d2e0b ("xprtrdma: Decouple req recycling from RPC completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprt.h     |  2 ++
 net/sunrpc/xprt.c               | 16 ++++++++++++++++
 net/sunrpc/xprtrdma/transport.c | 15 ++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index b9f59aabee53bf..3a50fdbb024d00 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -378,6 +378,8 @@ struct rpc_xprt *	xprt_alloc(struct net *net, size_t size,
 				unsigned int max_req);
 void			xprt_free(struct rpc_xprt *);
 void			xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task);
+void			xprt_add_backlog_noncongested(struct rpc_xprt *xprt,
+					struct rpc_task *task);
 bool			xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req);
 void			xprt_cleanup_ids(void);
 
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index ab453ede54f0cd..562aa8beae0ecb 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1651,6 +1651,22 @@ void xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task)
 }
 EXPORT_SYMBOL_GPL(xprt_add_backlog);
 
+/**
+ * xprt_add_backlog_noncongested - queue task on backlog
+ * @xprt: transport whose backlog queue receives the task
+ * @task: task to queue
+ *
+ * Like xprt_add_backlog, but does not set XPRT_CONGESTED.
+ * For transports whose free_slot path does not synchronize
+ * with xprt_throttle_congested via reserve_lock.
+ */
+void xprt_add_backlog_noncongested(struct rpc_xprt *xprt,
+				   struct rpc_task *task)
+{
+	rpc_sleep_on(&xprt->backlog, task, xprt_complete_request_init);
+}
+EXPORT_SYMBOL_GPL(xprt_add_backlog_noncongested);
+
 static bool __xprt_set_rq(struct rpc_task *task, void *data)
 {
 	struct rpc_rqst *req = data;
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 80731cbb1365ee..44e7cd14af70b5 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -521,7 +521,20 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 
 out_sleep:
 	task->tk_status = -EAGAIN;
-	xprt_add_backlog(xprt, task);
+	xprt_add_backlog_noncongested(xprt, task);
+	/* A buffer freed between buffer_get and rpc_sleep_on
+	 * goes back to the pool with no waiter to wake.
+	 * Re-check after joining the backlog to close that gap.
+	 */
+	req = rpcrdma_buffer_get(&r_xprt->rx_buf);
+	if (req) {
+		struct rpc_rqst *rqst = &req->rl_slot;
+
+		if (!xprt_wake_up_backlog(xprt, rqst)) {
+			memset(rqst, 0, sizeof(*rqst));
+			rpcrdma_buffer_put(&r_xprt->rx_buf, req);
+		}
+	}
 }
 
 /**
-- 
2.53.0



