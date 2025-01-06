Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE091487F4;
	Mon,  6 Jan 2025 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176985; cv=none; b=u1xtGt11SmtsPnZfVAPEfgOdSFrrLZKbz8VhuAPiR66kTQcPcL/Yw5CN3ssOVZglVLh82qp/y8jIfAVJfr3efeyEwAKlHUAroZxS+RqhS/XeTQngl5x7lmMxoWHZB50kpU9/akCTdd6f6p76AAHSc2BXnGY7luTFW6n7ecF7XW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176985; c=relaxed/simple;
	bh=t13Q8DUVPRuM714TwJ24N+HdgvX/9KAjxBF9cCvZKiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUpw7/1f2AcokUvUGASY1NaUJFTjLKY7UztnmTzsn8XleKmpOCsqF2wn3WyNs29+I8Tl7wH+S4LsbobmcLV0+RF82R8FipBc6WbnMbXTKTKn17oTigq1bPf/Uk1fn4z4iXvm5/HQzx2tdMuuxe0MwfBwk3WTgd3VHuvGXppLDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x59yQJm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x59yQJm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6824FC4CED2;
	Mon,  6 Jan 2025 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176984;
	bh=t13Q8DUVPRuM714TwJ24N+HdgvX/9KAjxBF9cCvZKiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x59yQJm1p5QAG+SonbXh+8I6lsm9wDwvVMeltGLhnM+/ypGgpKKj23iimTsvWOQbj
	 IhCvOrJALnmuljD3nGGZRmIYooPZJxKJOq9hJF1YUGc56dCTTjPYUtYBOUWyCSP8/D
	 jbHBXWFqAKVsUCRVu1ti4431I5CJ4NZsW+BWauGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/222] sched: Initialize idle tasks only once
Date: Mon,  6 Jan 2025 16:13:37 +0100
Message-ID: <20250106151151.102343441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b23decf8ac9102fc52c4de5196f4dc0a5f3eb80b ]

Idle tasks are initialized via __sched_fork() twice:

     fork_idle()
        copy_process()
	  sched_fork()
             __sched_fork()
	init_idle()
          __sched_fork()

Instead of cleaning this up, sched_ext hacked around it. Even when analyis
and solution were provided in a discussion, nobody cared to clean this up.

init_idle() is also invoked from sched_init() to initialize the boot CPU's
idle task, which requires the __sched_fork() invocation. But this can be
trivially solved by invoking __sched_fork() before init_idle() in
sched_init() and removing the __sched_fork() invocation from init_idle().

Do so and clean up the comments explaining this historical leftover.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241028103142.359584747@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 228f7c07da72..86606fb9e6bc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4488,7 +4488,8 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
  *
- * __sched_fork() is basic setup used by init_idle() too:
+ * __sched_fork() is basic setup which is also used by sched_init() to
+ * initialize the boot CPU's idle task.
  */
 static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
@@ -9257,8 +9258,6 @@ void __init init_idle(struct task_struct *idle, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	__sched_fork(0, idle);
-
 	raw_spin_lock_irqsave(&idle->pi_lock, flags);
 	raw_spin_rq_lock(rq);
 
@@ -9273,10 +9272,8 @@ void __init init_idle(struct task_struct *idle, int cpu)
 
 #ifdef CONFIG_SMP
 	/*
-	 * It's possible that init_idle() gets called multiple times on a task,
-	 * in that case do_set_cpus_allowed() will not do the right thing.
-	 *
-	 * And since this is boot we can forgo the serialization.
+	 * No validation and serialization required at boot time and for
+	 * setting up the idle tasks of not yet online CPUs.
 	 */
 	set_cpus_allowed_common(idle, &ac);
 #endif
@@ -10105,6 +10102,7 @@ void __init sched_init(void)
 	 * but because we are the idle thread, we just pick up running again
 	 * when this runqueue becomes "idle".
 	 */
+	__sched_fork(0, current);
 	init_idle(current, smp_processor_id());
 
 	calc_load_update = jiffies + LOAD_FREQ;
-- 
2.39.5



