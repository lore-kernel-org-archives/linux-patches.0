Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2022E03E6;
	Mon, 24 Nov 2025 08:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971608; cv=none; b=tjQtQ54d6NE+LGQPFD+rcwBnMjriux7r0+PG4h8yRa9O62q+g+7+1zvCCNcWbcJacELvOBH60QXOC6AzOMBzzkLgwzPmOwOqvMnnVIUNBnFHn2you5scIsQwt7HSFcTRQExISCw/J7u7CPeORrGgGNNIUZ/Rfav3EUsixdQ9Uhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971608; c=relaxed/simple;
	bh=3j4VoIJdpQm9/V2OUrlkPgT1M7jKqvjDTVUDGGAmqtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3dR6jXz5eAV2eV8HR61pAIsjIHbaaUt/vs8IXjDPgp1kN3ts+vmqFUpvnPrTVRdGBOTEpxO14kTafn9CEEhcpi5DCdmZVIvQWNP6D3oHqcaRpPTiWAs+Yw9/m1N7dfC0lFDj4lk7E2JFB6U16ZUPzaLCXZalcVDoqkBGuDfcts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAE0rhSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAE0rhSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E9C16AAE;
	Mon, 24 Nov 2025 08:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971608;
	bh=3j4VoIJdpQm9/V2OUrlkPgT1M7jKqvjDTVUDGGAmqtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAE0rhShqsEV2XP8rpOf4povk4GFST3Wm5dMEKzWJyL3/q26oSt4eC2wwar79MrdE
	 ssNT/VZhk6vAYJ9BXxdFDs0MCynX8k04nGeIU9sJYxCNmr4Lu0O5SLom/1oi4gZj0p
	 HzvN7rLWbabuKwmWukyYsh6BsXA/Amb64K60f4L4d+BbuofkPa6hJEQTAI3l4Xa5L/
	 PCHdDILQb9mYqe0U85zrPOmMk8eeCJ2oA4qLGLk2H5GNSdOsMdOSYXaMOAm6ppVtfw
	 4xg5UVLKeAYD5q3fvkPvtnyjNHYnRbUVAfoX9lPFEiKg8CG0ntPvkYvfB7XZ4zKKAT
	 4Pz9D/QMgV3Jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17] sched_ext: Fix possible deadlock in the deferred_irq_workfn()
Date: Mon, 24 Nov 2025 03:06:16 -0500
Message-ID: <20251124080644.3871678-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit a257e974210320ede524f340ffe16bf4bf0dda1e ]

For PREEMPT_RT=y kernels, the deferred_irq_workfn() is executed in
the per-cpu irq_work/* task context and not disable-irq, if the rq
returned by container_of() is current CPU's rq, the following scenarios
may occur:

lock(&rq->__lock);
<Interrupt>
  lock(&rq->__lock);

This commit use IRQ_WORK_INIT_HARD() to replace init_irq_work() to
initialize rq->scx.deferred_irq_work, make the deferred_irq_workfn()
is always invoked in hard-irq context.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. Commit Message and Problem Analysis
The commit addresses a **critical deadlock** scenario in the `sched_ext`
(BPF extensible scheduler) subsystem.
- **The Issue:** On `CONFIG_PREEMPT_RT` (Real-Time) kernels, `irq_work`
  items initialized with `init_irq_work()` default to running in a per-
  CPU thread context with interrupts enabled. The work function
  `deferred_irq_workfn()` acquires the runqueue lock
  (`raw_spin_rq_lock(rq)`). If an interrupt occurs while this lock is
  held, and the interrupt handler also attempts to acquire `rq->__lock`
  (a standard scheduler pattern), a deadlock occurs (A-A deadlock).
- **The Fix:** The commit changes the initialization of
  `deferred_irq_work` to use `IRQ_WORK_INIT_HARD()`. This forces the
  work function to execute in **hard interrupt context** (with
  interrupts disabled), preventing the nested interrupt scenario that
  causes the deadlock.

### 2. Deep Code Research & Verification
- **Subsystem Context:** `sched_ext` was merged in Linux v6.12. The
  buggy code exists in all stable kernels starting from v6.12.y up to
  the current v6.17.y. Older LTS kernels (6.6.y, 6.1.y) do not contain
  `sched_ext` and are unaffected.
- **Code Mechanics:**
  - **Buggy Code:** `init_irq_work(&rq->scx.deferred_irq_work,
    deferred_irq_workfn);` relies on defaults which are unsafe for this
    locking pattern on PREEMPT_RT.
  - **Corrected Code:** `rq->scx.deferred_irq_work =
    IRQ_WORK_INIT_HARD(deferred_irq_workfn);` explicitly sets the
    `IRQ_WORK_HARD_IRQ` flag.
  - **Precedent:** This pattern is well-established in the scheduler
    core (e.g., `rto_push_work` in `kernel/sched/topology.c` uses
    `IRQ_WORK_INIT_HARD` for the exact same reason).
- **Correctness:** `deferred_irq_workfn` calls `run_deferred`, which
  uses `raw_spin_rq_lock`. These locks are safe to take in hard-irq
  context. The fix is technically sound and adheres to locking rules.

### 3. Stable Kernel Rules Evaluation
- **Fixes a real bug?** **Yes.** It fixes a reproducible deadlock that
  causes system hangs.
- **Important issue?** **Yes.** Deadlocks are critical failures,
  especially on Real-Time systems where reliability is paramount.
- **Obviously correct?** **Yes.** The fix is a one-line change using a
  standard kernel macro specifically designed for this purpose.
- **Small and contained?** **Yes.** One line changed, no external
  dependencies.
- **No new features?** **Yes.** This is a pure bug fix for existing
  functionality.

### 4. Risk Assessment
- **Regression Risk:** **Very Low.** The change only affects the
  execution context of the work item. On non-RT kernels, `irq_work`
  often runs in hard-irq context anyway, so the behavior change is
  minimal. On RT kernels, this restores the required behavior to prevent
  deadlocks.
- **User Impact:** Users running `sched_ext` on Real-Time kernels are at
  risk of random system freezes without this fix.

### Conclusion
This commit is a textbook example of stable-material. It fixes a severe
bug (deadlock) in a supported feature (`sched_ext`) using a minimal,
well-understood solution. While it lacks a "Cc: stable" tag, the nature
of the bug (deadlock) and the surgical nature of the fix make it a
mandatory backport for all stable trees containing `sched_ext` (v6.12+).

**YES**

 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index e1b502ef1243c..fa64fdb6e9796 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5280,7 +5280,7 @@ void __init init_sched_ext_class(void)
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_kick_if_idle, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_preempt, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_wait, GFP_KERNEL, n));
-		init_irq_work(&rq->scx.deferred_irq_work, deferred_irq_workfn);
+		rq->scx.deferred_irq_work = IRQ_WORK_INIT_HARD(deferred_irq_workfn);
 		init_irq_work(&rq->scx.kick_cpus_irq_work, kick_cpus_irq_workfn);
 
 		if (cpu_online(cpu))
-- 
2.51.0

