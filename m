Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02DC1459FA;
	Mon, 23 Mar 2026 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276919; cv=none; b=JmyAB1AVwNM0ZunNrYxzfXnBFWG3OaUoLS56tTxArSvUxPVqxG/6gMLBWMiQYN5bb4UPnBZ/r3HNOkZqygTbfcql3WLG9T+7RFSnAR4fA6sF9CDWvQpn0HQKdM6UNgi3qWoz0pj1z3Sim4NgXynS1VhhBvaRHVYgngpZ2dECAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276919; c=relaxed/simple;
	bh=j5XL2fXCxlC6hBVLhEoFivFkk5LJw/w4mK3WC6Wa8pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6/l2iZj9vU6ye4XyGEq0Ug2Xo1b2YdfZcUSEPg2Fj9Z4rI6oWpqDS9TaKuqVfzWviHgBxMp4tFuVBAWdYr68dIk9TDupKTknufWTr7GXsxI8Lw+aeCksGnFi6nEliMMQ8GGfOAFzPAXODw/cCI/KJoVlz+b1orckdeu94RHbHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GB29z4Mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GB29z4Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35335C4CEF7;
	Mon, 23 Mar 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276919;
	bh=j5XL2fXCxlC6hBVLhEoFivFkk5LJw/w4mK3WC6Wa8pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GB29z4MgiSlfLgzhq+9OL8vMgqAj9v777lihTbv2cmh21oWH2r3r3L8Y6rimAeVYX
	 xQ40itwh4eFtgBs080aAfnA63t7Dg4/g/a/6gK02aWK+UE5JjRYuUsVChbWiJ4Y9Qt
	 0swFVFx0+/+DdbESOAJDimvNMvWvRncPnh4Px/sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/460] sched_ext: Disable preemption between scx_claim_exit() and kicking helper work
Date: Mon, 23 Mar 2026 14:44:11 +0100
Message-ID: <20260323134532.752583513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 83236b2e43dba00bee5b82eb5758816b1a674f6a ]

scx_claim_exit() atomically sets exit_kind, which prevents scx_error() from
triggering further error handling. After claiming exit, the caller must kick
the helper kthread work which initiates bypass mode and teardown.

If the calling task gets preempted between claiming exit and kicking the
helper work, and the BPF scheduler fails to schedule it back (since error
handling is now disabled), the helper work is never queued, bypass mode
never activates, tasks stop being dispatched, and the system wedges.

Disable preemption across scx_claim_exit() and the subsequent work kicking
in all callers - scx_disable() and scx_vexit(). Add
lockdep_assert_preemption_disabled() to scx_claim_exit() to enforce the
requirement.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ adapted per-scheduler struct (sch->exit_kind, scx_disable, scx_vexit) to global variables (scx_exit_kind, scx_ops_disable, scx_ops_exit_kind) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4775,14 +4775,29 @@ static void schedule_scx_ops_disable_wor
 		kthread_queue_work(helper, &scx_ops_disable_work);
 }
 
-static void scx_ops_disable(enum scx_exit_kind kind)
+/*
+ * Claim the exit. The caller must ensure that the helper kthread work
+ * is kicked before the current task can be preempted. Once exit_kind is
+ * claimed, scx_error() can no longer trigger, so if the current task gets
+ * preempted and the BPF scheduler fails to schedule it back, the helper work
+ * will never be kicked and the whole system can wedge.
+ */
+static bool scx_claim_exit(enum scx_exit_kind kind)
 {
 	int none = SCX_EXIT_NONE;
 
+	lockdep_assert_preemption_disabled();
+
+	return atomic_try_cmpxchg(&scx_exit_kind, &none, kind);
+}
+
+static void scx_ops_disable(enum scx_exit_kind kind)
+{
 	if (WARN_ON_ONCE(kind == SCX_EXIT_NONE || kind == SCX_EXIT_DONE))
 		kind = SCX_EXIT_ERROR;
 
-	atomic_try_cmpxchg(&scx_exit_kind, &none, kind);
+	guard(preempt)();
+	scx_claim_exit(kind);
 
 	schedule_scx_ops_disable_work();
 }
@@ -5082,10 +5097,11 @@ static __printf(3, 4) void scx_ops_exit_
 					     const char *fmt, ...)
 {
 	struct scx_exit_info *ei = scx_exit_info;
-	int none = SCX_EXIT_NONE;
 	va_list args;
 
-	if (!atomic_try_cmpxchg(&scx_exit_kind, &none, kind))
+	guard(preempt)();
+
+	if (!scx_claim_exit(kind))
 		return;
 
 	ei->exit_code = exit_code;


