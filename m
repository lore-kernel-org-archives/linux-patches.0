Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774238;
	b=1LFfPXZABOJZ4Ras4IrZ8ZHzl4POTNbSvps4zbmXNcK+FMbmtruVYH2EeZYUknGdm9rm
	 X4tI4Bmv8encYwctLX0scsPqkmH9DgbKdsYuG8F504QaTPbOrElv2LYocPpPCWUK5ttb8
	 o8UHsaGaEZqfUYmtsIX8kd9AVIA+tQobgaFJrvLCNVekCUQbFZZlMTB3u4EJwudcb4kZT
	 KhRY9Palquv9NE18pv63vUgmez9v5BCdl3ebCLkPf9geIFOMKfqf5+ZwvFmKCgRXqbkkm
	 Z1vGks5nZ0N51Rn1E3D7N75pTf65YyD8hsfX4SnfdDQPtWmtPBVO5MpxOCw/aEOnviQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A2tEy8/xIXps3jllUVmDG4PghL3f2nYXguUyQjDsLuA=;
	b=Raht1amzHd+oNHdT8kilBj/5lx9Q5NZkkS55vsgIwNcjgVFSCcA3E8CLrUXOOpROtEqV
	 LI3kDKlbsxlqmI9DXHnu45cFbV+IsiMJJG+HLbaNU/RnLgEd12xSnnih/FOCSAllYhiJ6
	 jEEcDcYhB4bSj7S2iNY9hkja2HI4wtY6wfsGA2ib+bL/oq66ZgSIDpdLup8QuSpbgBz3/
	 H9rxcgfxiSBuXpakjHgJfBr8znO3Qf8ZHAkh6t9/zRcmkDsgSn6y5ppDKLqRcL4AwZKNq
	 8FkuGMQ68jv4CXLhxGILLw2p+/daigBtaHrChBBYa8uuMpeHhLrLe6G/93luh2qnPOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCaDFQgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6EC606A31B;
	Fri, 23 Oct 2026 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCaDFQgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595541F01825;
	Fri, 23 Oct 2026 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774237;
	bh=A2tEy8/xIXps3jllUVmDG4PghL3f2nYXguUyQjDsLuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCaDFQgO2ifw5aTtbfnpCtvfOLxX3IIF4rq77HQnRFCw7PWsIYSaNkrA/7Bg9mrGX
	 qHL+pTQBZZwB/fTJ2ZZrCSHaGRl+YDZzEemA4lI5og9Ups6KMkHykNi1RZLgEN1+mN
	 1aEYPXx+d2//G5HWA6MJexfUJhMPEyV1jVQzWLsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/193] sched_ext: idle: Respect task affinity in restricted CPU selection
Date: Fri, 23 Oct 2026 18:37:23 +0200
Message-ID: <20261023163718.138538635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 6ac4544eff796666ce6fbcc4be8181c81dfccc85 ]

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
[ sashal: Adjusted declaration context to retain rq and rf for the existing task_rq_lock() locking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c |   50 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -889,12 +889,43 @@ static bool is_bpf_migration_disabled(co
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
 	struct rq *rq;
 	struct rq_flags rf;
+	bool migration_disabled;
 	s32 cpu;
 
 	if (!ops_cpu_valid(sch, prev_cpu, NULL))
@@ -928,20 +959,17 @@ static s32 select_cpu_from_kfunc(struct
 
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
 
 	if (scx_kf_allowed_if_unlocked())
 		task_rq_unlock(rq, p, &rf);


