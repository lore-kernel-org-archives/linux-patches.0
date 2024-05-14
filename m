Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16591E4B0;
	Tue, 14 May 2024 11:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685787; cv=none; b=Qo1IlMnHU0DhtvgtfJG7xRSW8tpIrGD5STjFTPPkh38RBUOaBn76I7VlhI2q+6tG/Qw5SePVBF0u6UP3BPm8s/nJlqCsve7GcXpkJTnD6WcI8NPEZ7M5waEjOJpI4fd8sX/TlJFrvcUw+ldQ4y5cyotawm13LmqIhylpp4C9I8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685787; c=relaxed/simple;
	bh=lAQYZUZz/q/fdGb7FzqsczfGCHJzC2sss7XS9B+FWQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKxHiCOIJGn5YcixiJWeCPp4v5LeYcKoi9bSfIF02Ivgm3rH9k8nIkQoQZEAqYo5ftaKGNT7B4KaAburnAIziTbIxrnunwRnuBvAAusJc2ZPywG04mJjt7wh94cx71Ro9PQB0Nxa7Al4Ty4GKXNjpnLMuiJIcaPXmKDN4kWC9wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqpuLlKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqpuLlKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEE9C2BD10;
	Tue, 14 May 2024 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685787;
	bh=lAQYZUZz/q/fdGb7FzqsczfGCHJzC2sss7XS9B+FWQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqpuLlKMJs/NUu03ZpgSBhbdGNpK2VbS5H0uO5Ax7FiOKEMdcrJrxQYuuGzcZp3FS
	 n2GqXdDPJbmMsGKpnNS6J+vgOKJJ4YnhlBKplv5/mnMSpkNy8RzJR2tJStubhzMEMG
	 DO3q2gtZJEbdAZxkIcZPj89+NO5UlZLD81S2lSK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 247/301] workqueue: Fix selection of wake_cpu in kick_pool()
Date: Tue, 14 May 2024 12:18:38 +0200
Message-ID: <20240514101041.581732023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit 57a01eafdcf78f6da34fad9ff075ed5dfdd9f420 upstream.

With cpu_possible_mask=0-63 and cpu_online_mask=0-7 the following
kernel oops was observed:

smp: Bringing up secondary CPUs ...
smp: Brought up 1 node, 8 CPUs
Unable to handle kernel pointer dereference in virtual kernel address space
Failing address: 0000000000000000 TEID: 0000000000000803
[..]
 Call Trace:
arch_vcpu_is_preempted+0x12/0x80
select_idle_sibling+0x42/0x560
select_task_rq_fair+0x29a/0x3b0
try_to_wake_up+0x38e/0x6e0
kick_pool+0xa4/0x198
__queue_work.part.0+0x2bc/0x3a8
call_timer_fn+0x36/0x160
__run_timers+0x1e2/0x328
__run_timer_base+0x5a/0x88
run_timer_softirq+0x40/0x78
__do_softirq+0x118/0x388
irq_exit_rcu+0xc0/0xd8
do_ext_irq+0xae/0x168
ext_int_handler+0xbe/0xf0
psw_idle_exit+0x0/0xc
default_idle_call+0x3c/0x110
do_idle+0xd4/0x158
cpu_startup_entry+0x40/0x48
rest_init+0xc6/0xc8
start_kernel+0x3c4/0x5e0
startup_continue+0x3c/0x50

The crash is caused by calling arch_vcpu_is_preempted() for an offline
CPU. To avoid this, select the cpu with cpumask_any_and_distribute()
to mask __pod_cpumask with cpu_online_mask. In case no cpu is left in
the pool, skip the assignment.

tj: This doesn't fully fix the bug as CPUs can still go down between picking
the target CPU and the wake call. Fixing that likely requires adding
cpu_online() test to either the sched or s390 arch code. However, regardless
of how that is fixed, workqueue shouldn't be picking a CPU which isn't
online as that would result in unpredictable and worse behavior.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Fixes: 8639ecebc9b1 ("workqueue: Implement non-strict affinity scope for unbound workqueues")
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1135,8 +1135,12 @@ static bool kick_pool(struct worker_pool
 	    !cpumask_test_cpu(p->wake_cpu, pool->attrs->__pod_cpumask)) {
 		struct work_struct *work = list_first_entry(&pool->worklist,
 						struct work_struct, entry);
-		p->wake_cpu = cpumask_any_distribute(pool->attrs->__pod_cpumask);
-		get_work_pwq(work)->stats[PWQ_STAT_REPATRIATED]++;
+		int wake_cpu = cpumask_any_and_distribute(pool->attrs->__pod_cpumask,
+							  cpu_online_mask);
+		if (wake_cpu < nr_cpu_ids) {
+			p->wake_cpu = wake_cpu;
+			get_work_pwq(work)->stats[PWQ_STAT_REPATRIATED]++;
+		}
 	}
 #endif
 	wake_up_process(p);


