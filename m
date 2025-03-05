Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D056E155A2F;
	Wed,  5 Mar 2025 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197615; cv=none; b=um72FDz66CD8KMDVEEDiv/WnS7UQoBa9FGNFiWeVvQWuZQ9zygUTLyBfYfypk+q/u50mIRJBO7d8eFfEiJck9eTTMfpOAgyL76SNP9N/8eT8zYfbg0WlwI+/C2kaQzeud9fC8g/qCwLfB8Ejsqpa+fpSkYhNjJaFMOpc6lxua48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197615; c=relaxed/simple;
	bh=de6LnVaABz71WFYw7emDjkxawK4xzN7/UshgI51W+Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ15/gCXWzB4l3DiLWLAmCL+itudN1sezugw6TL8bcYQo6V/Odj8iabJDckEfXL5OFZeNr6YTPWmzjQsvQUlIIDks7VlcZW49I1Bkk9uceOCldLzn7r+BL6ckSs+lFB6RPaKcbRsI1qf+iZvHCp9dV9O0XuGqrlrDExuw/AEKj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqUkDmiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqUkDmiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B04CC4CED1;
	Wed,  5 Mar 2025 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197615;
	bh=de6LnVaABz71WFYw7emDjkxawK4xzN7/UshgI51W+Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqUkDmiLZfmAGg6sJC2JmWEF9XxQ2530+pRletp8OOA+t/2Xbg+5T6sDw8alju0wA
	 0iUR3uoPPPeBSXaPtEN+XJ4WNPoEcGiE06FpcbmcDiphzs4M+2TIqwpgBIGxsM1YIw
	 jvbv/9QiLYto3hTmLQbGK1Dc0C2yLd5b7iKE4KfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/142] SUNRPC: Prevent looping due to rpc_signal_task() races
Date: Wed,  5 Mar 2025 18:47:09 +0100
Message-ID: <20250305174500.750236696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f80b90aca380a..a220b28904ca5 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -147,7 +147,6 @@ enum {
 	RPC_TASK_NEED_XMIT,
 	RPC_TASK_NEED_RECV,
 	RPC_TASK_MSG_PIN_WAIT,
-	RPC_TASK_SIGNALLED,
 };
 
 #define rpc_test_and_set_running(t) \
@@ -160,7 +159,7 @@ enum {
 
 #define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
 
-#define RPC_SIGNALLED(t)	test_bit(RPC_TASK_SIGNALLED, &(t)->tk_runstate)
+#define RPC_SIGNALLED(t)	(READ_ONCE(task->tk_rpc_status) == -ERESTARTSYS)
 
 /*
  * Task priorities.
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 6beb38c1dcb5e..9eba2ca0a6ff8 100644
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



