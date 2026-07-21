Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C01386C39;
	Tue, 21 Jul 2026 19:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662543; cv=none; b=PV+JVEJuzw9wAmCmOhEQ4weJvQX6JCu6q02L1EAQmcK/9US5Ci6nd15lB2DhptxpAHfI2RykTPGFrTC2+SLpQKu1U0fC4Mu3zjU+RhL+2msBYyi/wii+HGS2XQhlmPiwBvKZj2TGlavD95PHVXTsHW1jjJz15UZzyRKls+oDYHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662543; c=relaxed/simple;
	bh=V7GxGMHEPD3Jcpvgo9KUtDUsIpj1EJBsFaQJ0PwXCY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciU5Qcc9wi/W9jAl5tpCmFKrH6OoXBcvi3Ww8eiAE2LQe+zbbvpSov5sz474AUxyHxXW+1xhHjTxjCmUsuyjgUXPFJYcHz66zl/FlkxDKTFU3CFt3vMgfRxVTY+r41kSNMr1G5E1C+uhS3H8ymh5DhgpJyAm6v2Syc7edtyGl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpRnTxNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpRnTxNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240671F000E9;
	Tue, 21 Jul 2026 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662541;
	bh=K8r6389Cbwcje20r92GAoBT70zZKiebzpQNK0eLfOhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpRnTxNhLZalxdC/D5dDoMSe1IOuDydVrqDQeQPzPhdkAsnTTQaS7phsKIAk45pfX
	 YFAIlng7YUhXWOifoyP7jMeglEGVucoew9LcTeRdIaETppzOQMsIUPk8HARlLyf4e1
	 lEJALK9RvXBbeR0azAz/lnkmPtW+d8dpFK7eUwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0484/1276] xprtrdma: Close lost-wakeup race in xprt_rdma_alloc_slot
Date: Tue, 21 Jul 2026 17:15:27 +0200
Message-ID: <20260721152456.936078175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81b952649d35e3..af35131d8d710d 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -389,6 +389,8 @@ struct rpc_xprt *	xprt_alloc(struct net *net, size_t size,
 				unsigned int max_req);
 void			xprt_free(struct rpc_xprt *);
 void			xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task);
+void			xprt_add_backlog_noncongested(struct rpc_xprt *xprt,
+					struct rpc_task *task);
 bool			xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req);
 void			xprt_cleanup_ids(void);
 
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 09f245cda5262a..18ec0763ca21cd 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1663,6 +1663,22 @@ void xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task)
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
index ca079439f9cceb..61706df5e485ac 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -511,7 +511,20 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 
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



