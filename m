Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D504F3ACF1C;
	Wed, 23 Sep 2026 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173691; cv=none; b=LQn1lv6m2Xt4KfxtricXKQcRVeEgPOOEK1WPxaPzghhj6axNnPvmsmsI7NCMEtRIVBCtmwjafmPxWZEAqa00135eQx3puH4hpo5dluxhbzzMpPdQa8CU1Ei23f3/MFi1X+Vsagf/XfAfIFpyAFhJz8o5C80otoJfnOzuTPdVN+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173691; c=relaxed/simple;
	bh=FRj4C67kdXGyo5hpgXx7ULRq661bHgWbn504pd7Ge3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfhuTP9AUNqYus9DhCnQ1mkp51QOZswDTmfKzQsrpd0h6JAOg2EMZqDkKbtM+o3Rtck4z1T/EljWslKKr9Zynr7AlDkNRA6fBW8KhaS2WyqRDSFMujkbDsEZ8Og5oXaV0HC4ZBlLPtY+8u2GCUy6ARclbFJs4eESvMuBeol0aRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YNgURk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YNgURk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEEA1F00893;
	Wed, 23 Sep 2026 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173689;
	bh=6KXkrXQ+HWHR/jzIvp85p1SIjg+lJ3ikBVDOIocXvP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YNgURk2i3aNynA4wNYX++tkZ0QSDxuIeYLqSRI4MHgXdLclGxFKnyQzBF4nFaPa7
	 0QU4nZSF+nATEJdiHJd9n5JqaQqogpxXozxr+WomGUTXrHHBQTSrPfHYXlxWE+rvaC
	 lopHbDZiJbOgDL1R1C4PNKZnKkchJLOH6tbm3xjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 323/438] sched_ext: Fix NULL sched deref in kfunc sub-sched error paths
Date: Wed, 23 Sep 2026 16:05:44 +0200
Message-ID: <20260923140653.171243259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanwu Li <liwanwu@kylinos.cn>

commit 0a85182723b65ad8bee8131bc38fcf0347d6679b upstream.

When the root scheduler has sub-scheds attached, the COMPAT kfunc
wrappers scx_bpf_select_cpu_and() and scx_bpf_dsq_insert_vtime() refuse
the call and report to @p's scheduler:

	scx_error(scx_task_sched(p), "... must be used");

The wrappers are reachable with tasks that have no scheduler.
scx_bpf_select_cpu_and() is in the select_cpu kfunc group, which
scx_kfunc_context_filter() opens to BPF_PROG_TYPE_SYSCALL programs;
scx_bpf_dsq_insert_vtime() is in the enqueue_dispatch group, which
ops.enqueue() and ops.dispatch() may call with any KF_RCU task -- the
group has no kf_tasks validation, and scx_dsq_insert_preamble() checks
task ownership with scx_task_on_sched() precisely because @p may be an
arbitrary task.

scx_task_sched(p) is p->scx.sched, which is NULL for tasks past
sched_ext_dead() -- which clears it via scx_disable_and_exit_task() on
exit -- and for idle tasks, which the enable paths skip as they are
never scheduled through SCX. It is also an rcu_dereference_protected()
that expects @p's pi_lock or rq lock, which neither wrapper holds.
Passing NULL to scx_error() reaches scx_vexit(), which dereferences
sch->exit_info, oopsing the kernel.

One concrete trigger exercised while developing the fix: a
BPF_PROG_TYPE_SYSCALL program calling the select_cpu_and wrapper on an
exited-but-not-reaped task while a sub-scheduler was attached (its pid
stays findable while the zombie is unreaped; faulting instruction is
the scx_vexit() prologue "mov r15,[rdi+0x398]" with RDI=NULL and 0x398
the offset of sch->exit_info):

  sched_ext: BPF scheduler "kfunc_subsched_null" enabled
  sched_ext: BPF sub-scheduler "kfunc_subsched_null" enabled
  sched_ext: Unassociated program run_select_cpu_ (id 76)
  BUG: kernel NULL pointer dereference, address: 0000000000000398
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 7 UID: 0 PID: 8201 Comm: kfunc_test_runn Tainted: G W
  RIP: 0010:scx_vexit+0x25/0xa0
  Code: ... <4c> 8b bf 98 03 00 00 ...
  CR2: 0000000000000398
  Call Trace:
   <TASK>
   __scx_exit+0x4f/0x70
   scx_bpf_select_cpu_and+0xab/0xb0
   bpf_prog_430ed61a7b66e03a_run_select_cpu_and+0x9c/0xe7
   ? __x64_sys_bpf+0x2c/0x40
   bpf_prog_test_run_syscall+0x130/0x2f0
   __sys_bpf+0x930/0x10d0
   ? __x64_sys_bpf+0x2c/0x40
   __x64_sys_bpf+0x2c/0x40
   do_syscall_64+0xbc/0x460
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Read @p's scheduler under RCU instead, which the wrappers can do from
their guard(rcu)(): fault it when it can be determined, and when it
can't be determined -- @p is a task past sched_ext_dead() or an idle
task -- there is nothing obviously wrong to report, so just refuse the
call as before without faulting any scheduler.

These COMPAT wrappers are scheduled for eventual removal once the
deprecation grace period elapses, but until then -- and regardless of
their removal timeline -- they must not oops the kernel on a task they
are handed.

Cc: stable@vger.kernel.org # v7.1+
Fixes: a5fa0708cbfd ("sched_ext: Enforce scheduling authority in dispatch and select_cpu operations")
Suggested-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Wanwu Li <liwanwu@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c  |   11 +++++++++--
 kernel/sched/ext/idle.c |   11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -8964,10 +8964,17 @@ __bpf_kfunc void scx_bpf_dsq_insert_vtim
 #ifdef CONFIG_EXT_SUB_SCHED
 	/*
 	 * Disallow if any sub-scheds are attached. There is no way to tell
-	 * which scheduler called us, just error out @p's scheduler.
+	 * which scheduler called us, so error out @p's scheduler -- read it
+	 * under RCU as @p's locks aren't necessarily held here. @p may be a
+	 * task past sched_ext_dead() or an idle task, in which case its
+	 * scheduler can't be determined and there is nothing obviously wrong
+	 * to report; just refuse the call.
 	 */
 	if (unlikely(!list_empty(&sch->children))) {
-		scx_error(scx_task_sched(p), "__scx_bpf_dsq_insert_vtime() must be used");
+		struct scx_sched *tsch = scx_task_sched_rcu(p);
+
+		if (tsch)
+			scx_error(tsch, "__scx_bpf_dsq_insert_vtime() must be used");
 		return;
 	}
 #endif
--- a/kernel/sched/ext/idle.c
+++ b/kernel/sched/ext/idle.c
@@ -1097,10 +1097,17 @@ __bpf_kfunc s32 scx_bpf_select_cpu_and(s
 #ifdef CONFIG_EXT_SUB_SCHED
 	/*
 	 * Disallow if any sub-scheds are attached. There is no way to tell
-	 * which scheduler called us, just error out @p's scheduler.
+	 * which scheduler called us, so error out @p's scheduler -- read it
+	 * under RCU as @p's locks aren't necessarily held here. @p may be a
+	 * task past sched_ext_dead() or an idle task, in which case its
+	 * scheduler can't be determined and there is nothing obviously wrong
+	 * to report; just refuse the call.
 	 */
 	if (unlikely(!list_empty(&sch->children))) {
-		scx_error(scx_task_sched(p), "__scx_bpf_select_cpu_and() must be used");
+		struct scx_sched *tsch = scx_task_sched_rcu(p);
+
+		if (tsch)
+			scx_error(tsch, "__scx_bpf_select_cpu_and() must be used");
 		return -EINVAL;
 	}
 #endif


