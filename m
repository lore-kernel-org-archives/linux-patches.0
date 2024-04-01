Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A0E1E525;
	Mon,  1 Apr 2024 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989474; cv=none; b=I/oDXzmY5b4FEHVTAjZ8SFuPyQ6/h8cpiLWmwthEeVqtICjr75Swq+harSOGuIfSFM57rGTEBxruTfilEJD8aQ1kPqSxg83al6W1c2jwFUy6dE9t7PhhP+EWI31cZegSXgDqbAHXC1NuDaR321yghArhiy2KQvaWfD/jW0a7tiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989474; c=relaxed/simple;
	bh=Ai1fCukQ5nTAYgkRQdnKdAOLAA0EkgJzLIsn77eyOGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLL5UyQ4W5dDOg417QrwWYOulYxNF/lue/JtbNZd+CU8LqGG/sCvbX4WD51BvWzsPb0pqkjEgb20TuSE1zx4+E+aPmkr9H2aW9rtUJ/6yjATRKLHZf4YKPinTK0vxC+1WJC97+PtAfDM13XPKy3OONs1iir+iZoEeKC8/PhLPdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8wAynga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8wAynga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A20C433C7;
	Mon,  1 Apr 2024 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989474;
	bh=Ai1fCukQ5nTAYgkRQdnKdAOLAA0EkgJzLIsn77eyOGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8wAyngaOIyzlsdQIEiWMR/+frUG+YXk2graP9mWUQ8aVj6jaQjaoxe3zZ/XFzD/1
	 lhdrrs+ssV1ZLxSpXxvbnDgbXTAlmCD7a9maAU92wt1ofgayx0RqNERvK9OAA4+mDm
	 lDoxbHt10v/+IBKLuyul9EsgwXAs4tuPAnJsNJ7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/396] sched: Simplify tg_set_cfs_bandwidth()
Date: Mon,  1 Apr 2024 17:41:20 +0200
Message-ID: <20240401152548.834357513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 6fb45460615358157a6d3c990e74f9c1395247e2 ]

Use guards to reduce gotos and simplify control flow.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: 1aa09b9379a7 ("powercap: intel_rapl: Fix locking in TPMI RAPL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpu.h |  2 ++
 kernel/sched/core.c | 38 +++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 59dd421a8e35d..e990c180282e7 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -157,6 +157,8 @@ static inline int remove_cpu(unsigned int cpu) { return -EPERM; }
 static inline void smp_shutdown_nonboot_cpus(unsigned int primary_cpu) { }
 #endif	/* !CONFIG_HOTPLUG_CPU */
 
+DEFINE_LOCK_GUARD_0(cpus_read_lock, cpus_read_lock(), cpus_read_unlock())
+
 #ifdef CONFIG_PM_SLEEP_SMP
 extern int freeze_secondary_cpus(int primary);
 extern void thaw_secondary_cpus(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a854b71836dd5..1f91e2c12731e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10868,11 +10868,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota,
 	 * Prevent race between setting of cfs_rq->runtime_enabled and
 	 * unthrottle_offline_cfs_rqs().
 	 */
-	cpus_read_lock();
-	mutex_lock(&cfs_constraints_mutex);
+	guard(cpus_read_lock)();
+	guard(mutex)(&cfs_constraints_mutex);
+
 	ret = __cfs_schedulable(tg, period, quota);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	runtime_enabled = quota != RUNTIME_INF;
 	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
@@ -10882,39 +10883,38 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota,
 	 */
 	if (runtime_enabled && !runtime_was_enabled)
 		cfs_bandwidth_usage_inc();
-	raw_spin_lock_irq(&cfs_b->lock);
-	cfs_b->period = ns_to_ktime(period);
-	cfs_b->quota = quota;
-	cfs_b->burst = burst;
 
-	__refill_cfs_bandwidth_runtime(cfs_b);
+	scoped_guard (raw_spinlock_irq, &cfs_b->lock) {
+		cfs_b->period = ns_to_ktime(period);
+		cfs_b->quota = quota;
+		cfs_b->burst = burst;
 
-	/* Restart the period timer (if active) to handle new period expiry: */
-	if (runtime_enabled)
-		start_cfs_bandwidth(cfs_b);
+		__refill_cfs_bandwidth_runtime(cfs_b);
 
-	raw_spin_unlock_irq(&cfs_b->lock);
+		/*
+		 * Restart the period timer (if active) to handle new
+		 * period expiry:
+		 */
+		if (runtime_enabled)
+			start_cfs_bandwidth(cfs_b);
+	}
 
 	for_each_online_cpu(i) {
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
 		struct rq *rq = cfs_rq->rq;
-		struct rq_flags rf;
 
-		rq_lock_irq(rq, &rf);
+		guard(rq_lock_irq)(rq);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 
 		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
-		rq_unlock_irq(rq, &rf);
 	}
+
 	if (runtime_was_enabled && !runtime_enabled)
 		cfs_bandwidth_usage_dec();
-out_unlock:
-	mutex_unlock(&cfs_constraints_mutex);
-	cpus_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
-- 
2.43.0



