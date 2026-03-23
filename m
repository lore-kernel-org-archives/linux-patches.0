Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456043AC0D2;
	Mon, 23 Mar 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274590; cv=none; b=LKD+LuxsBGbT6Z3iD86lyg+/RNKxjwiE9NvgsO+LG/EODZ9+aN2Jf2JNOue8zpbGc4CQ9FhUq4ZDVup0fG2GQXCMA9Cwpg0+tpKGw4oyTsE6/zFfBcBFJBCOogkXgjqH+zZCR6RJma0K/gKHcHfmZzG7OTjPv0pNsmqLtMWy3RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274590; c=relaxed/simple;
	bh=MuZ7pG5CwJJHA16T1YuztN78P/FbArk6WDHcU0sdHcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow3ezr0349lFsRNd4QYcnbkERECnlAowZ25iGVi6e8LP49IHxqGvU1lJ3+siLd/JXkY1Y1OcYryheXIFQY2Y4WeTlGQvscNbdBMcqlbuviWFOAuI67S/glwpoSt9gxFVdywroNXQXTZTD0uAO6Sep0JuXrorQLHxNSF89vY0cxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnUyk9Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnUyk9Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD24FC2BC9E;
	Mon, 23 Mar 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274590;
	bh=MuZ7pG5CwJJHA16T1YuztN78P/FbArk6WDHcU0sdHcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnUyk9CwqH2U7Dl6dUIyheNc3mzvFuV7rJdhpbrP0ysQKSWimsL9A+crhWO9RYgw8
	 yfsuzlJtWA7e8b3U5CPnzdse1vy7H/bvOGO28iZVeKVsb3hxF78eKhBYeyi06FPL1i
	 bdNG8b4kdh1iDM8AAVLsykuCEShcppGpMtXeQDLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/212] sched_ext: Simplify breather mechanism with scx_aborting flag
Date: Mon, 23 Mar 2026 14:44:27 +0100
Message-ID: <20260323134505.222211679@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit a69040ed57f50156e5452474d25c79b9e62075d0 ]

The breather mechanism was introduced in 62dcbab8b0ef ("sched_ext: Avoid
live-locking bypass mode switching") and e32c260195e6 ("sched_ext: Enable the
ops breather and eject BPF scheduler on softlockup") to prevent live-locks by
injecting delays when CPUs are trapped in dispatch paths.

Currently, it uses scx_breather_depth (atomic_t) and scx_in_softlockup
(unsigned long) with separate increment/decrement and cleanup operations. The
breather is only activated when aborting, so tie it directly to the exit
mechanism. Replace both variables with scx_aborting flag set when exit is
claimed and cleared after bypass is enabled. Introduce scx_claim_exit() to
consolidate exit_kind claiming and breather enablement. This eliminates
scx_clear_softlockup() and simplifies scx_softlockup() and scx_bypass().

The breather mechanism will be replaced by a different abort mechanism in a
future patch. This simplification prepares for that change.

Reviewed-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 83236b2e43db ("sched_ext: Disable preemption between scx_claim_exit() and kicking helper work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   54 ++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -33,9 +33,8 @@ static DEFINE_MUTEX(scx_enable_mutex);
 DEFINE_STATIC_KEY_FALSE(__scx_enabled);
 DEFINE_STATIC_PERCPU_RWSEM(scx_fork_rwsem);
 static atomic_t scx_enable_state_var = ATOMIC_INIT(SCX_DISABLED);
-static unsigned long scx_in_softlockup;
-static atomic_t scx_breather_depth = ATOMIC_INIT(0);
 static int scx_bypass_depth;
+static bool scx_aborting;
 static bool scx_init_task_enabled;
 static bool scx_switching_all;
 DEFINE_STATIC_KEY_FALSE(__scx_switched_all);
@@ -1791,7 +1790,7 @@ static void scx_breather(struct rq *rq)
 
 	lockdep_assert_rq_held(rq);
 
-	if (likely(!atomic_read(&scx_breather_depth)))
+	if (likely(!READ_ONCE(scx_aborting)))
 		return;
 
 	raw_spin_rq_unlock(rq);
@@ -1800,9 +1799,9 @@ static void scx_breather(struct rq *rq)
 
 	do {
 		int cnt = 1024;
-		while (atomic_read(&scx_breather_depth) && --cnt)
+		while (READ_ONCE(scx_aborting) && --cnt)
 			cpu_relax();
-	} while (atomic_read(&scx_breather_depth) &&
+	} while (READ_ONCE(scx_aborting) &&
 		 time_before64(ktime_get_ns(), until));
 
 	raw_spin_rq_lock(rq);
@@ -3718,30 +3717,14 @@ void scx_softlockup(u32 dur_s)
 		goto out_unlock;
 	}
 
-	/* allow only one instance, cleared at the end of scx_bypass() */
-	if (test_and_set_bit(0, &scx_in_softlockup))
-		goto out_unlock;
-
 	printk_deferred(KERN_ERR "sched_ext: Soft lockup - CPU%d stuck for %us, disabling \"%s\"\n",
 			smp_processor_id(), dur_s, scx_root->ops.name);
 
-	/*
-	 * Some CPUs may be trapped in the dispatch paths. Enable breather
-	 * immediately; otherwise, we might even be able to get to scx_bypass().
-	 */
-	atomic_inc(&scx_breather_depth);
-
 	scx_error(sch, "soft lockup - CPU#%d stuck for %us", smp_processor_id(), dur_s);
 out_unlock:
 	rcu_read_unlock();
 }
 
-static void scx_clear_softlockup(void)
-{
-	if (test_and_clear_bit(0, &scx_in_softlockup))
-		atomic_dec(&scx_breather_depth);
-}
-
 /**
  * scx_bypass - [Un]bypass scx_ops and guarantee forward progress
  * @bypass: true for bypass, false for unbypass
@@ -3802,8 +3785,6 @@ static void scx_bypass(bool bypass)
 				      ktime_get_ns() - bypass_timestamp);
 	}
 
-	atomic_inc(&scx_breather_depth);
-
 	/*
 	 * No task property is changing. We just need to make sure all currently
 	 * queued tasks are re-queued according to the new scx_rq_bypassing()
@@ -3860,10 +3841,8 @@ static void scx_bypass(bool bypass)
 		raw_spin_rq_unlock(rq);
 	}
 
-	atomic_dec(&scx_breather_depth);
 unlock:
 	raw_spin_unlock_irqrestore(&bypass_lock, flags);
-	scx_clear_softlockup();
 }
 
 static void free_exit_info(struct scx_exit_info *ei)
@@ -3958,6 +3937,7 @@ static void scx_disable_workfn(struct kt
 
 	/* guarantee forward progress by bypassing scx_ops */
 	scx_bypass(true);
+	WRITE_ONCE(scx_aborting, false);
 
 	switch (scx_set_enable_state(SCX_DISABLING)) {
 	case SCX_DISABLING:
@@ -4086,9 +4066,24 @@ done:
 	scx_bypass(false);
 }
 
-static void scx_disable(enum scx_exit_kind kind)
+static bool scx_claim_exit(struct scx_sched *sch, enum scx_exit_kind kind)
 {
 	int none = SCX_EXIT_NONE;
+
+	if (!atomic_try_cmpxchg(&sch->exit_kind, &none, kind))
+		return false;
+
+	/*
+	 * Some CPUs may be trapped in the dispatch paths. Enable breather
+	 * immediately; otherwise, we might not even be able to get to
+	 * scx_bypass().
+	 */
+	WRITE_ONCE(scx_aborting, true);
+	return true;
+}
+
+static void scx_disable(enum scx_exit_kind kind)
+{
 	struct scx_sched *sch;
 
 	if (WARN_ON_ONCE(kind == SCX_EXIT_NONE || kind == SCX_EXIT_DONE))
@@ -4097,7 +4092,7 @@ static void scx_disable(enum scx_exit_ki
 	rcu_read_lock();
 	sch = rcu_dereference(scx_root);
 	if (sch) {
-		atomic_try_cmpxchg(&sch->exit_kind, &none, kind);
+		scx_claim_exit(sch, kind);
 		kthread_queue_work(sch->helper, &sch->disable_work);
 	}
 	rcu_read_unlock();
@@ -4418,9 +4413,8 @@ static void scx_vexit(struct scx_sched *
 		      const char *fmt, va_list args)
 {
 	struct scx_exit_info *ei = sch->exit_info;
-	int none = SCX_EXIT_NONE;
 
-	if (!atomic_try_cmpxchg(&sch->exit_kind, &none, kind))
+	if (!scx_claim_exit(sch, kind))
 		return;
 
 	ei->exit_code = exit_code;
@@ -4645,6 +4639,8 @@ static void scx_enable_workfn(struct kth
 	 */
 	WARN_ON_ONCE(scx_set_enable_state(SCX_ENABLING) != SCX_DISABLED);
 	WARN_ON_ONCE(scx_root);
+	if (WARN_ON_ONCE(READ_ONCE(scx_aborting)))
+		WRITE_ONCE(scx_aborting, false);
 
 	atomic_long_set(&scx_nr_rejected, 0);
 


