Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AB2ED846;
	Mon, 24 Nov 2025 08:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971626; cv=none; b=VbyWnpQUuILWL8MHoumcDYuD4cqGTrgomVUUhe/skY+jSC1kqHXspFSgkvIcpVXmJmBJd1ZoPlV9QWXhdGVC+hdEWVsh3jwKX8DH0JXFZ/gQRXU7JVwQg6iAs45YFp/mXnMiznMBKBtUw/xqffCLWWdE3TKuHPgldqSJF3sIkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971626; c=relaxed/simple;
	bh=DSATK1uPZBocRZED2xN65djjVz1+Zb2O/in0y1YltZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+jB5LQQ0lOmGyrwlvjjXT1a4f6HZ9ASLFFUlwVpG8vFa6TadJqk0tH/7unrdIwrVrbzMpPgSPlck1oNoMlhi2z99ZgFdAoONmxH85T4jCpESDEHlWEwhD7wcqZfyxhBRHViVFDYD9I0ugbOgrOn/zvh5zAkeJjW9isLkpKL/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMVgSLoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMVgSLoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0024C116D0;
	Mon, 24 Nov 2025 08:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971626;
	bh=DSATK1uPZBocRZED2xN65djjVz1+Zb2O/in0y1YltZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMVgSLoLE9c4uh20tjEDVBYmoGHPjWGBaASBcAsw3hp6V8jxYwlWWWdPM8yQE6ITN
	 RduulTYv/NVM9tCKJMosgreJRKcVdj8N+sc9se/bPk4q+nV6f1lswM4DXHX1Z2RYLw
	 Nxd8H/9r4fbLrUx96zYcvygobahxIc2frlQ16DF/vyhgQ89nADa5egaT3Bh12uIK+n
	 RFDYoA7JixjK9PUA4KIMOMFwXV9PuDqBcc9/IfgEQrhKxzorXUOlC7itE3AAcTP3ob
	 5wt8Cl//g6IGl54fSMJV1KfWSPFvMG6utSrFaCEsJHj/GaiGeZdbakZLlb5SvBr1tu
	 5GMyIhoMjNtFQ==
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
Subject: [PATCH AUTOSEL 6.17] sched_ext: Use IRQ_WORK_INIT_HARD() to initialize rq->scx.kick_cpus_irq_work
Date: Mon, 24 Nov 2025 03:06:26 -0500
Message-ID: <20251124080644.3871678-12-sashal@kernel.org>
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

[ Upstream commit 36c6f3c03d104faf1aa90922f2310549c175420f ]

For PREEMPT_RT kernels, the kick_cpus_irq_workfn() be invoked in
the per-cpu irq_work/* task context and there is no rcu-read critical
section to protect. this commit therefore use IRQ_WORK_INIT_HARD() to
initialize the per-cpu rq->scx.kick_cpus_irq_work in the
init_sched_ext_class().

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

1. **Commit Message Analysis**
    - **Problem:** On `PREEMPT_RT` kernels, `irq_work` initialized with
      `init_irq_work()` executes in a threaded context where RCU read-
      side critical sections are not implicit. The function
      `kick_cpus_irq_workfn` accesses per-CPU request queues
      (`rq->scx`), which requires RCU protection or preemption disabling
      to be safe.
    - **Solution:** The commit changes the initialization to
      `IRQ_WORK_INIT_HARD()`. This macro sets the `IRQ_WORK_HARD_IRQ`
      flag, forcing the work item to execute in hard interrupt context
      even on `PREEMPT_RT` kernels.
    - **Keywords:** "PREEMPT_RT", "RCU-read critical section",
      "initialize".
    - **Tags:** No explicit `Cc: stable` or `Fixes` tag in the provided
      text, but the nature of the fix (correctness on RT) is a strong
      candidate for stable.

2. **Deep Code Research**
    - **Code Context:** The affected file `kernel/sched/ext.c` belongs
      to the `sched_ext` (Extensible Scheduler Class) subsystem.
    - **Technical Mechanism:** In standard kernels, `irq_work` usually
      runs in contexts where RCU is safe. In `PREEMPT_RT`, the default
      behavior changes to threaded IRQs to reduce latency, but this
      removes the implicit RCU protection. Accessing scheduler runqueues
      (`rq`) without this protection can lead to Use-After-Free (UAF)
      bugs or data corruption if a CPU goes offline or the task
      structure changes.
    - **The Fix:** `IRQ_WORK_INIT_HARD` is the standard mechanism to
      opt-out of threaded execution for specific work items that require
      hard IRQ semantics (atomic execution, implicit RCU protection).
      This is a well-understood pattern in the kernel.
    - **Subsystem Status:** `sched_ext` was merged in v6.12. Therefore,
      this fix is applicable to stable kernels v6.12 and newer.

3. **Stable Kernel Rules Evaluation**
    - **Fixes a real bug?** Yes. It fixes a race condition/correctness
      issue on `PREEMPT_RT` kernels which could lead to crashes.
    - **Obviously correct?** Yes. The fix uses standard kernel
      primitives to enforce the required execution context.
    - **Small and contained?** Yes. It is a one-line change to an
      initialization function.
    - **No new features?** Yes. It only corrects the behavior of
      existing code.
    - **Regression Risk:** Low. It forces hard IRQ context, which is
      generally safe for `irq_work` provided the work function is fast
      (which `kick_cpus` typically is).

4. **Conclusion**
  This commit is a text-book example of a stable backport candidate. It
  addresses a correctness issue in the interaction between a specific
  subsystem (`sched_ext`) and the `PREEMPT_RT` configuration. The fix is
  minimal, surgical, and necessary to prevent potential crashes. While
  it applies only to kernels containing `sched_ext` (6.12+), it is
  critical for users running that configuration.

**YES**

 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index fa64fdb6e9796..6f8ef62c8216c 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5281,7 +5281,7 @@ void __init init_sched_ext_class(void)
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_preempt, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_wait, GFP_KERNEL, n));
 		rq->scx.deferred_irq_work = IRQ_WORK_INIT_HARD(deferred_irq_workfn);
-		init_irq_work(&rq->scx.kick_cpus_irq_work, kick_cpus_irq_workfn);
+		rq->scx.kick_cpus_irq_work = IRQ_WORK_INIT_HARD(kick_cpus_irq_workfn);
 
 		if (cpu_online(cpu))
 			cpu_rq(cpu)->scx.flags |= SCX_RQ_ONLINE;
-- 
2.51.0

