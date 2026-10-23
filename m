Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774814;
	b=ozsoE9QimV+3CBTKbTUfbCyFGlrjK7kHCzWNkE5pDakqHZDh8oSZ0Ek8qaXCss0tQLbi
	 JhsGRuu9JqMsIsRtQJdlccb/28dhkpcWr8b9qU7gYdaX6I4jHA0NNkhFrl4KhAiYYjZ4T
	 11L/+eiFu5NAXBBSJUdq5cRzg/GjTNUtJ8ynZ5oe6eK8mpLwFQKd98cAXMFXP0zJffrht
	 Tm80aXZnrRmPFI7Qc5cCcOHn3p+Ihj5uF3PR6+qEE/7HMmd9e05eqQEX0UW0r1Wz90QK4
	 OVNRm0/h4rUg0kSGzkWldnaU8A5tFyg+ea9hWQ8QRnIwCa37JEg1L3jeytvgv4fTWEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUW9pW/fuGRtkyUqneV5l3eWNswGRWheHd0Ixj0uC8M=;
	b=ZI1jqpR2LYdZq1+VA3RxbgH5Ox94Gx/T0w2PAyj5dSqvJ2IMwJkYAqigOK240eSPB2RB
	 DctambVJxIpJRFw4mmxhQ0iGX8AR1e+4y9cMUqhmuN2Pt9j6g2QyUeY9mKeBYSgLAsL2u
	 DGN9JlFpdlqAcfK9TZ+PS2M8DdEFqscKV9pb4S8AnHD6QpUnYe/jKjDoSi89xNl3X5e1+
	 WC4AzI5uXtxaQ8xYSsknGIhnyA3L4kLvCAfmkh+lzmBHVkOy48xVr2+JIc8wW3yE+LcnO
	 gnf1gqLkp0unVjSLeHeK1Aci3uVvmJ8Q1Buw/fsfmw5xVMmqTpsotkgfeKDSsFszVig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcSeBQt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237AF606A31F;
	Fri, 23 Oct 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcSeBQt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD521F01825;
	Fri, 23 Oct 2026 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774813;
	bh=rUW9pW/fuGRtkyUqneV5l3eWNswGRWheHd0Ixj0uC8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcSeBQt0smrUBqicnixUf06axz9oZdSrMtyazWCYKtQZALEqNbCCMJ3HLdN2LTed6
	 y5z/KEwN6IeXtUecar8hK6DH6E4CbIj+XkusXZXhIcTJdxGSeTg+A+KP2nZzDW6bZa
	 YzALf6+u9VNMe7hzvXHL069PYbHq4FIFEgRUHgIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 166/242] sched_ext: idle: Respect task affinity in restricted CPU selection
Date: Fri, 23 Oct 2026 18:40:08 +0200
Message-ID: <20261023163717.712017245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit 6ac4544eff796666ce6fbcc4be8181c81dfccc85 upstream.

The restricted select_cpu kfunc path handles single-CPU and
migration-disabled tasks without going through scx_select_cpu_dfl().

It currently uses prev_cpu as the candidate, even though prev_cpu is only a
hint and may no longer be usable after an affinity change. With a
caller-provided @allowed mask, this can also return an idle CPU outside
p->cpus_ptr.

Derive the candidate from task state instead: use the sole CPU in
p->cpus_ptr for single-CPU tasks and task_cpu(p) for migration-disabled
tasks. Validate it against p->cpus_ptr and @allowed before claiming its
idle state.

Since the derived candidate may be on a different NUMA node from
prev_cpu, also preserve SCX_PICK_IDLE_IN_NODE by rejecting cross-node
candidates.

Perform all checks before scx_idle_test_and_clear_cpu(), as a successful
call consumes the CPU's idle bit.

Fixes: 683d2d0faba1 ("sched_ext: idle: Introduce scx_bpf_select_cpu_and()")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/idle.c |   50 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

--- a/kernel/sched/ext/idle.c
+++ b/kernel/sched/ext/idle.c
@@ -907,12 +907,43 @@ static bool is_bpf_migration_disabled(co
 	return p->migration_disabled;
 }
 
+static s32 select_cpu_restricted(struct task_struct *p, s32 prev_cpu,
+				 const struct cpumask *allowed, u64 flags,
+				 bool migration_disabled)
+{
+	s32 cpu;
+
+	if (migration_disabled)
+		cpu = task_cpu(p);
+	else
+		cpu = cpumask_first(p->cpus_ptr);
+
+	if (!cpumask_test_cpu(cpu, p->cpus_ptr))
+		return -EBUSY;
+
+	if (allowed && !cpumask_test_cpu(cpu, allowed))
+		return -EBUSY;
+
+	if (flags & SCX_PICK_IDLE_IN_NODE) {
+		int node = scx_cpu_node_if_enabled(prev_cpu);
+
+		if (scx_cpu_node_if_enabled(cpu) != node)
+			return -EBUSY;
+	}
+
+	if (!scx_idle_test_and_clear_cpu(cpu))
+		return -EBUSY;
+
+	return cpu;
+}
+
 static s32 select_cpu_from_kfunc(struct scx_sched *sch, struct task_struct *p,
 				 s32 prev_cpu, u64 wake_flags,
 				 const struct cpumask *allowed, u64 flags)
 {
 	unsigned long irq_flags;
 	bool we_locked = false;
+	bool migration_disabled;
 	s32 cpu;
 
 	if (!scx_cpu_valid(sch, prev_cpu, NULL))
@@ -949,20 +980,17 @@ static s32 select_cpu_from_kfunc(struct
 
 	/*
 	 * This may also be called from ops.enqueue(), so we need to handle
-	 * per-CPU tasks as well. For these tasks, we can skip all idle CPU
-	 * selection optimizations and simply check whether the previously
-	 * used CPU is idle and within the allowed cpumask.
+	 * per-CPU tasks as well. For these tasks, skip general idle CPU
+	 * selection and validate the task's only usable CPU directly.
 	 */
-	if (p->nr_cpus_allowed == 1 || is_bpf_migration_disabled(p)) {
-		if (cpumask_test_cpu(prev_cpu, allowed ?: p->cpus_ptr) &&
-		    scx_idle_test_and_clear_cpu(prev_cpu))
-			cpu = prev_cpu;
-		else
-			cpu = -EBUSY;
-	} else {
+	migration_disabled = is_bpf_migration_disabled(p);
+
+	if (p->nr_cpus_allowed == 1 || migration_disabled)
+		cpu = select_cpu_restricted(p, prev_cpu, allowed, flags,
+					    migration_disabled);
+	else
 		cpu = scx_select_cpu_dfl(p, prev_cpu, wake_flags,
 					 allowed ?: p->cpus_ptr, flags);
-	}
 
 	if (we_locked)
 		raw_spin_unlock_irqrestore(&p->pi_lock, irq_flags);


