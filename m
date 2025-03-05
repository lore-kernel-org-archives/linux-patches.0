Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4C11C5D4E;
	Wed,  5 Mar 2025 18:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198399; cv=none; b=kEHUbjp9Z3B4gY1ADeQR3XvCKTfLO45UwscvHQ1hLDLxtx26/uLwQf5sS6Avit1R9FIAIBiBWpQ3KtJhjpeM+aNlxqLQQUFUmMhoyitUOr6JZPYOpwXKIDeqNE0Ao1y41cbhkNkpMb+JcCVw6jF9M6pkFRqvK4DX3ZcBQYgBVpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198399; c=relaxed/simple;
	bh=09g19/rt4OuHwI4DEYUOxpKN6rvYtGRtURuJiLggqJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXd157j96PkCDaimKC9l1D9+AK3NgasNSkqKBisn5hRcRJqN6o+ZHK8P9yvIGqr5JBmqZkNbg2sAv4sxPzrTrXGVW/1/+syuaWELy3l8/5ygjK7TRgBClKd8L68goUI3pgPmfFfkE30+0fcFiQj0VbhIRXcXyz4wOzaUBCnvQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JItg/d6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JItg/d6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F2CC4CED1;
	Wed,  5 Mar 2025 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198398;
	bh=09g19/rt4OuHwI4DEYUOxpKN6rvYtGRtURuJiLggqJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JItg/d6qle3W/OpuTlgyDOcHq3jKM+Ne5V+S6Ge5SGOk3Z2e7sCsTFypWW5qUcCBC
	 AGiWWxn9MyiXCj03ZNPrYy0FCyeZBQyTZDfse2/y9jO6H2ipNxhNesWw8axJCbeODw
	 KnTANpvWazANdsBtuGdWuer7t1OoSruyTpgrWBQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 015/157] SUNRPC: Prevent looping due to rpc_signal_task() races
Date: Wed,  5 Mar 2025 18:47:31 +0100
Message-ID: <20250305174505.899182669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 5bbd6e863b15a85221e49b9bdb2d5d8f0bb91f3d ]

If rpc_signal_task() is called while a task is in an rpc_call_done()
callback function, and the latter calls rpc_restart_call(), the task can
end up looping due to the RPC_TASK_SIGNALLED flag being set without the
tk_rpc_status being set.
Removing the redundant mechanism for signalling the task fixes the
looping behaviour.

Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 39494194f93b ("SUNRPC: Fix races with rpc_killall_tasks()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h  | 3 +--
 include/trace/events/sunrpc.h | 3 +--
 net/sunrpc/sched.c            | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index fec1e8a1570c3..eac57914dcf32 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -158,7 +158,6 @@ enum {
 	RPC_TASK_NEED_XMIT,
 	RPC_TASK_NEED_RECV,
 	RPC_TASK_MSG_PIN_WAIT,
-	RPC_TASK_SIGNALLED,
 };
 
 #define rpc_test_and_set_running(t) \
@@ -171,7 +170,7 @@ enum {
 
 #define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
 
-#define RPC_SIGNALLED(t)	test_bit(RPC_TASK_SIGNALLED, &(t)->tk_runstate)
+#define RPC_SIGNALLED(t)	(READ_ONCE(task->tk_rpc_status) == -ERESTARTSYS)
 
 /*
  * Task priorities.
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index b13dc275ef4a7..851841336ee65 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -360,8 +360,7 @@ TRACE_EVENT(rpc_request,
 		{ (1UL << RPC_TASK_ACTIVE), "ACTIVE" },			\
 		{ (1UL << RPC_TASK_NEED_XMIT), "NEED_XMIT" },		\
 		{ (1UL << RPC_TASK_NEED_RECV), "NEED_RECV" },		\
-		{ (1UL << RPC_TASK_MSG_PIN_WAIT), "MSG_PIN_WAIT" },	\
-		{ (1UL << RPC_TASK_SIGNALLED), "SIGNALLED" })
+		{ (1UL << RPC_TASK_MSG_PIN_WAIT), "MSG_PIN_WAIT" })
 
 DECLARE_EVENT_CLASS(rpc_task_running,
 
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index cef623ea15060..9b45fbdc90cab 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -864,8 +864,6 @@ void rpc_signal_task(struct rpc_task *task)
 	if (!rpc_task_set_rpc_status(task, -ERESTARTSYS))
 		return;
 	trace_rpc_task_signalled(task, task->tk_action);
-	set_bit(RPC_TASK_SIGNALLED, &task->tk_runstate);
-	smp_mb__after_atomic();
 	queue = READ_ONCE(task->tk_waitqueue);
 	if (queue)
 		rpc_wake_up_queued_task(queue, task);
-- 
2.39.5



