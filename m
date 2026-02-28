Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EFF383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302076; cv=none; b=i4gtHB1rdj83/dsiNeEbcD8zbE6/cjRGIVOCwWbc5wBiO2sx7iZVU7e5wMCjLaqLBBzoMPsYlhGX0YQUQ2a0BIAu7QbUuzseI1pi6RkinX3iSKtoWMdWVPpY0WL2wOFV1rWzIa2i0PYCCKb26JBCKE53Ad0xcPpyTpyo5CX57no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302076; c=relaxed/simple;
	bh=T+Uq3OKaDL3aHteOJSUNNtHZxQOBaNAKSeUwSj+OoCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHs292F5+fnbQ6pRGLGqLp+5K8Vvb/Z7cikiYwFp4u0fq9k7/wU+BgHHvWYhkOkyTXQUB10JWxUAXoXiH2YYcB2lJNxI51NR3P/jOrXEDnihLpegDkok2JX8T1exnDdOCTNlnBhws9tlfjuCeujvEJrsKWn/SMtKTVIXqDR7aK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDd+CYA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDd+CYA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D62C19425;
	Sat, 28 Feb 2026 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302075;
	bh=T+Uq3OKaDL3aHteOJSUNNtHZxQOBaNAKSeUwSj+OoCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDd+CYA0eY6gFISXBotghAbxUohE//hrK1WEo/SFIFKIpbU1m0POZgl8U/rb0SrTl
	 cd7+GUPzlTpYdVzwzV7tKJfg5ADNzkITZjmnHAiqGIyYisDZ1ZDfVQuzdm7HpQsv0Q
	 4CpydfLSOBADPD1Cf30H1L8dUhiYr4AJ9qcb5bgVwBXB9xYulfGcP1zKgju23r5Mhh
	 JV5KM2+FFiwOrJr9BOT26VrkArGw7ZPEyfU01kEm457SS0nUGFCk+to+GjRfh8tUo9
	 ViV0+V7sC9X0tQ11UfdaUtyMyDBF7E3yrbPF3KLInPmvQliizfrVXmrwdXBdmP4X11
	 6bM0JnV1Pmrzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen Jinghuang <chenjinghuang2@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/283] sched/rt: Skip currently executing CPU in rto_next_cpu()
Date: Sat, 28 Feb 2026 13:03:18 -0500
Message-ID: <20260228180709.1583486-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen Jinghuang <chenjinghuang2@huawei.com>

[ Upstream commit 94894c9c477e53bcea052e075c53f89df3d2a33e ]

CPU0 becomes overloaded when hosting a CPU-bound RT task, a non-CPU-bound
RT task, and a CFS task stuck in kernel space. When other CPUs switch from
RT to non-RT tasks, RT load balancing (LB) is triggered; with
HAVE_RT_PUSH_IPI enabled, they send IPIs to CPU0 to drive the execution
of rto_push_irq_work_func. During push_rt_task on CPU0,
if next_task->prio < rq->donor->prio, resched_curr() sets NEED_RESCHED
and after the push operation completes, CPU0 calls rto_next_cpu().
Since only CPU0 is overloaded in this scenario, rto_next_cpu() should
ideally return -1 (no further IPI needed).

However, multiple CPUs invoking tell_cpu_to_push() during LB increments
rd->rto_loop_next. Even when rd->rto_cpu is set to -1, the mismatch between
rd->rto_loop and rd->rto_loop_next forces rto_next_cpu() to restart its
search from -1. With CPU0 remaining overloaded (satisfying rt_nr_migratory
&& rt_nr_total > 1), it gets reselected, causing CPU0 to queue irq_work to
itself and send self-IPIs repeatedly. As long as CPU0 stays overloaded and
other CPUs run pull_rt_tasks(), it falls into an infinite self-IPI loop,
which triggers a CPU hardlockup due to continuous self-interrupts.

The trigging scenario is as follows:

         cpu0                      cpu1                    cpu2
                                pull_rt_task
                              tell_cpu_to_push
                 <------------irq_work_queue_on
rto_push_irq_work_func
       push_rt_task
    resched_curr(rq)                                   pull_rt_task
    rto_next_cpu                                     tell_cpu_to_push
                      <-------------------------- atomic_inc(rto_loop_next)
rd->rto_loop != next
     rto_next_cpu
   irq_work_queue_on
rto_push_irq_work_func

Fix redundant self-IPI by filtering the initiating CPU in rto_next_cpu().
This solution has been verified to effectively eliminate spurious self-IPIs
and prevent CPU hardlockup scenarios.

Fixes: 4bdced5c9a29 ("sched/rt: Simplify the IPI based RT balancing logic")
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Chen Jinghuang <chenjinghuang2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://patch.msgid.link/20260122012533.673768-1-chenjinghuang2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2d0acdd32108a..0b420a65b31dc 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2219,6 +2219,7 @@ static void push_rt_tasks(struct rq *rq)
  */
 static int rto_next_cpu(struct root_domain *rd)
 {
+	int this_cpu = smp_processor_id();
 	int next;
 	int cpu;
 
@@ -2242,6 +2243,10 @@ static int rto_next_cpu(struct root_domain *rd)
 
 		rd->rto_cpu = cpu;
 
+		/* Do not send IPI to self */
+		if (cpu == this_cpu)
+			continue;
+
 		if (cpu < nr_cpu_ids)
 			return cpu;
 
-- 
2.51.0

