Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8622517B0;
	Wed,  5 Mar 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197390; cv=none; b=uk+F/UXOyWCoaZnCZB1W50GwTqQgoatQGagADhPfOaJclyNVR5SHUwR749+lsF6kp+ADbHxdTbXeUeIGbvuCs9BeNS33O8HcCXktTHTUDxQ86T0/WHsyS2bxO8Vd4kE2jv+oOyj6FTWzePNU4yncIHoS3RcDGkHCZaBuaQVk7Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197390; c=relaxed/simple;
	bh=hGMfOxKuezrZUiJVf7DVOJyjyMpwQyTK9eo2BQzDylg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPxQAFxP+MGPGVQTxGb5s1HyePS+PITBkgFqmJI/+qg6nwWa8CKJOKFHVdXJzrcPKHySvRLwVLFyoMePGmH5Bb4GSIcc6chMU/bYwYcMMz8dp6DS9FyB5+spAOSM+W2r9iAAmr0iQXxyyJLxGdnZbXdEI6TIX7oVmWIEAYUThA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzM+sl1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzM+sl1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C838AC4CED1;
	Wed,  5 Mar 2025 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197390;
	bh=hGMfOxKuezrZUiJVf7DVOJyjyMpwQyTK9eo2BQzDylg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzM+sl1dbzN8oUvozppNkxv18vhx8h8A7Cv6B4yUI+kSXexYML7bMeUYc9rJEHWku
	 HKcDkHtkxN4iOQeFd8bSO7a3RZTFGEA18a6BqeAVjEctBqFX1wOK/0pcO12w907BSF
	 hTemJoa9unzdQyPHQEze8I54TmcM5rq5QJKs//Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/176] SUNRPC: Prevent looping due to rpc_signal_task() races
Date: Wed,  5 Mar 2025 18:47:57 +0100
Message-ID: <20250305174509.802756671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ffe2679a13ced..b70f47a57bf6d 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -328,8 +328,7 @@ TRACE_EVENT(rpc_request,
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



