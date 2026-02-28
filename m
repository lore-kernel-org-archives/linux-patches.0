Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEA39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302530; cv=none; b=H/uYoAwWaOr0KIBlUqoqlJ3GFD+v7GsL0PFqvWi+8EYoAjv99NYVvCPdrq1YnSnhvsPhfLHCJiV+SGjjNSoIs3OusCmKbWCbxhHWHMUr0qPbYvx9OIk7otdzdspDgqFYUggWwDNGiBVL3urglw1AwvY3nSXc4ZSCqAQnHBmTd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302530; c=relaxed/simple;
	bh=Trn3UBYMjM270TM+u6CCUhB/u7E2lWB6ibcaSf1Une0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzrYq+0CHu9z3vGc2+hxglv5nBqbcCCAd1M0dVXVull3S+U8SabjvuwUnGDDX6h3PcyZrbO6Enyfjp4KTh4wycC7RpzqU/MS/8Jj5Oa1v3FGx39q1wiamcdBNaLXJPZncCMqPKloXrObLrKFqLKJOSyYmYQWwHx4ucHspQCe5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXJioKv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXJioKv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BFCC19424;
	Sat, 28 Feb 2026 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302529;
	bh=Trn3UBYMjM270TM+u6CCUhB/u7E2lWB6ibcaSf1Une0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXJioKv3B+rtLd349Q5bDbeN/XnVcb2txNPDlTWGFxRg2ZPqKgigQmaX/nzUtCy4v
	 NxD+rLK117YpdCp2ygHVrdcxS+LWpOw5xcMZx8IoW3ZEici/CHHIMEh917KZM85xJ3
	 yqRdRts+1e9JGs8uLp7xYL5sTUX+jLGLH4IqmjBcKpiQcaT0n2rL1lMdfAe4JRTRPv
	 DqSR31IMoExsjHWAfCMfIg6R5Xxgaie3PIoPubtlRq6PTd6rbgjfxb7W8Ol89RzVdG
	 Q+E7QX5V8i0lOsn5i/BEu/q22Kh/K57q2T3O+mz40rDRmXdXNZ6IPoU4mU40kFO1Gf
	 oE24vZm8DMMww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen Jinghuang <chenjinghuang2@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/164] sched/rt: Skip currently executing CPU in rto_next_cpu()
Date: Sat, 28 Feb 2026 13:12:48 -0500
Message-ID: <20260228181505.1600663-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 9720b3c19ab97..c5122e5f258e4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2068,6 +2068,7 @@ static void push_rt_tasks(struct rq *rq)
  */
 static int rto_next_cpu(struct root_domain *rd)
 {
+	int this_cpu = smp_processor_id();
 	int next;
 	int cpu;
 
@@ -2091,6 +2092,10 @@ static int rto_next_cpu(struct root_domain *rd)
 
 		rd->rto_cpu = cpu;
 
+		/* Do not send IPI to self */
+		if (cpu == this_cpu)
+			continue;
+
 		if (cpu < nr_cpu_ids)
 			return cpu;
 
-- 
2.51.0

