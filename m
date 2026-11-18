Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021919;
	b=sa9PMvthZ9vtzaDE8iCzm3sBO95QosfYtMeo+IEZcpwqO7QdNHYzjvafa1wovsE/Wb9d
	 xa6Bn/LxP08Z41eGhV19HCvDcu/MkCbQgHIsLgBAK2vYf0zhPYFc9YQjCNSt0suWQtrHX
	 blUeBTJM/v+gPX0yZTC4/aiJz8wfBZzeFQ2fMRhvllcYMvqmvBm4h5E48awCtgy02kAHF
	 Wo1vtxraOGr6Kz+LxL/6fo36sBIgMD/eKN9isuk1v+H6TSEwuG0pYSwfwYbnBJgrEZ2Qr
	 pm3vObqalgzix8zELITUQYkHVDbAokWX4W7dSjzbZRH5hIS3dktmd3FONa0y1gu3XGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8LVhnIjvu9UgM9/qSJbc3o95k5RsZJQjeSCZE4yLwU=;
	b=cjeezV9D8XrtcWlWfo2RhNjd9dIjY1ukPOG/xIhhCoJG2AzaHP2Lw93A1rMoV0MZxADS
	 VBXuuNVomyRjwh0y9Oy054KJm+ifVXeFhQOLLJ0Y0sxG2fOJk+rZiRXyr6MxLJfUy4xOf
	 rtwFV18qBXCZmEeb5jlX+P/1Zk1/ghP8IBE4QyDGQy6SueY36P2eiG8y+jYVPWaT+DMHY
	 VOyr+5iicSd1Ei7Ok0NFKahVBO+EHUq/1MO3DSNOoKBwMT4UwFdXrPSOGJMKLls/dclbm
	 +pWvmE6skFDLNd20egpH0vuR6OonnVS9coxULDBWXtCJL9IgIV+a+L7UiNdoKt7kuKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfAC+ZRq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878ED606A32F;
	Wed, 18 Nov 2026 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfAC+ZRq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD13F1F000C8;
	Wed, 18 Nov 2026 17:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021919;
	bh=I8LVhnIjvu9UgM9/qSJbc3o95k5RsZJQjeSCZE4yLwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfAC+ZRqLrLl7CjfA+NUpIt33Qn87KkF5ncsvtMxVGueDkAz71zlXST8tJV6MuKam
	 izMoZ7EpZbB7phBBAaQ5Hx0naYSkvgYTEyJxSUye0P5IDPFfGczs2RVN4909r7nQqw
	 lLof5X4199ZBnfLzG0bdpzdGwM3X9Pe9ke/Y3Rro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junbin Zhang <sprooc69@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2477/2651] sched_ext: Reject rq-lock-taking kfuncs in tracing programs
Date: Wed, 18 Nov 2026 16:01:57 +0100
Message-ID: <20261118150414.122327953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junbin Zhang <sprooc69@gmail.com>

[ Upstream commit b07a7450f6ef98c79ebd450a92fc4bb6b8f1e02e ]

scx_bpf_cpuperf_set() and scx_bpf_cidperf_set() are members of
scx_kfunc_ids_any, which is registered for BPF_PROG_TYPE_TRACING.
A tracing program can run in a context which already holds the target
rq lock, in which case scx_cpuperf_set() attempts to acquire the same
lock again:

  __schedule()
    rq_lock(rq);                          /* rq->__lock is held */
    trace_sched_switch();
      BPF tracing program
        scx_bpf_cpuperf_set(smp_processor_id(), 1024);
          scx_cpuperf_set();
            locked_rq = scx_locked_rq(); /* NULL */
            rq_lock_irqsave(rq, &rf);    /* same lock */

scx_locked_rq() only tracks rq locks held during SCX callback
invocations, so it cannot detect an rq lock held by the surrounding
kernel code.

The deadlock can be reproduced with two BPF programs. The first is a
minimal SCX scheduler, which only needs to be registered and enabled:

  SEC(".struct_ops.link")
  struct sched_ext_ops minimal_ops = {
          .name = "minimal",
  };

The second is a tracing program attached to tp_btf/sched_switch,
which fires from __schedule() with rq->__lock already held:

  SEC("tp_btf/sched_switch")
  int BPF_PROG(on_sched_switch, bool preempt, struct task_struct *prev,
               struct task_struct *next, unsigned int prev_state)
  {
          scx_bpf_cpuperf_set(bpf_get_smp_processor_id(), 1024);
          return 0;
  }

With both programs attached, the next context switch on any CPU
deadlocks that CPU. Lockdep reports:

  WARNING: possible recursive locking detected
  7.3.0-rc7 #3 Not tainted
  swapper/3/0 is trying to acquire lock:
   (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x1e/0x30

  but task is already holding lock:
   (&rq->__lock){-.-.}-{2:2}, at: __schedule+0xeb/0x1430

   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&rq->__lock);
    lock(&rq->__lock);

    *** DEADLOCK ***

  Call Trace:
   <TASK>
   print_deadlock_bug.cold+0xc0/0xd0
   __lock_acquire+0x12fa/0x1b80
   lock_acquire+0xd1/0x2f0
   _raw_spin_lock_nested+0x32/0x40
   raw_spin_rq_lock_nested+0x1e/0x30
   scx_cpuperf_set+0x1e9/0x310
   scx_bpf_cpuperf_set+0x9b/0x230
   bpf_prog_..._on_sched_switch+0x3d/0x41
   bpf_trace_run4+0x125/0x450
   __traceiter_sched_switch+0x4b/0x70
   __schedule+0x94a/0x1430
   schedule_idle+0x26/0x50
   cpu_startup_entry+0x2d/0x30
   start_secondary+0xfc/0x100
   </TASK>

The CPU remains locked up with interrupts disabled.
scx_bpf_cidperf_set() is similarly affected, as it resolves the CID
through scx_cid_to_cpu() before reaching the same rq-locking path.

There is no reliable way for these kfuncs to determine whether the
surrounding tracing context already holds an rq lock. Reject calls to
both kfuncs from tracing programs at verification time, while
preserving their availability to SCX struct_ops and syscall programs.

Fixes: a11d6784d731 ("sched_ext: Fix missing rq lock in scx_bpf_cpuperf_set()")
Signed-off-by: Junbin Zhang <sprooc69@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index b1c28516ff2cb..996ebfca769c4 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -10992,6 +10992,22 @@ static const struct btf_kfunc_id_set scx_kfunc_set_any = {
 	.filter			= scx_kfunc_context_filter,
 };
 
+/*
+ * Kfuncs which may take the rq lock on their unlocked path.
+ *
+ * A tracing program can execute in any kernel context, including ones which
+ * already hold the rq lock (e.g. sched_switch). scx_locked_rq() only tracks
+ * rq locks taken for SCX callbacks, so from such a context it returns NULL
+ * and these kfuncs would acquire the already held rq lock again and deadlock
+ * the CPU. They cannot be made safe for tracing programs, so keep them off
+ * the tracing hook. Members must also stay in scx_kfunc_ids_any so that
+ * struct_ops and syscall programs keep their access.
+ */
+BTF_KFUNCS_START(scx_kfunc_ids_no_tracing)
+BTF_ID_FLAGS(func, scx_bpf_cpuperf_set, KF_IMPLICIT_ARGS)
+BTF_ID_FLAGS(func, scx_bpf_cidperf_set, KF_IMPLICIT_ARGS)
+BTF_KFUNCS_END(scx_kfunc_ids_no_tracing)
+
 /*
  * cpu-form kfuncs that are forbidden from cid-form schedulers
  * (bpf_sched_ext_ops_cid). Programs targeting the cid struct_ops type must
@@ -11099,6 +11115,7 @@ int scx_kfunc_context_filter(const struct bpf_prog *prog, u32 kfunc_id)
 	bool in_any = btf_id_set8_contains(&scx_kfunc_ids_any, kfunc_id);
 	bool in_cpu_only = btf_id_set8_contains(&scx_kfunc_ids_cpu_only, kfunc_id);
 	bool in_cid = btf_id_set8_contains(&scx_kfunc_ids_cid, kfunc_id);
+	bool in_no_tracing = btf_id_set8_contains(&scx_kfunc_ids_no_tracing, kfunc_id);
 	u32 moff, flags;
 
 	/* Not an SCX kfunc - allow. */
@@ -11111,7 +11128,7 @@ int scx_kfunc_context_filter(const struct bpf_prog *prog, u32 kfunc_id)
 		return (in_unlocked || in_select_cpu || in_idle || in_any || in_cid) ? 0 : -EACCES;
 
 	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS)
-		return (in_any || in_idle || in_cid) ? 0 : -EACCES;
+		return (!in_no_tracing && (in_any || in_idle || in_cid)) ? 0 : -EACCES;
 
 	/*
 	 * add_subprog_and_kfunc() collects all kfunc calls, including dead code
-- 
2.53.0



