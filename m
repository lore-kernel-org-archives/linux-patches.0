Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BFC3DB310;
	Mon, 17 Aug 2026 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974689; cv=none; b=omYqtxd96BjHHF7M6N0qsFDjZdr44Hx0h64svBrDFnz3C5pCohJizx6YiPKpglDGYO+ZbIfXYXg2dF89umXkkCKUZlgpJ24G686yRAQGJXFKKO1btPdCV6XlQRUHzB5wCaQyDxRwFgZrjffS+1W4hutJtzxecRlTHUboi1IP1r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974689; c=relaxed/simple;
	bh=PukP4mB/5QM4xX7eU6TpDAsxE/A/JyWtmPvaPuenAxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSDDnQpqIe+LPc6hcTYmEzKnncpJbeV3p3Nh2EKViupOZqjNixF+Y6ygVhSEkhWeA6b4syIuDc+ulX27KRf0wKWXsZs69/u2lpHe7QTetWeypOSxzvJ+TFXW8OSUJoP4ut7JymOPou36snWrFco/s5vkCERiDmt9Fpel2MT2SzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsenwiOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsenwiOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FCC1F00A3D;
	Mon, 17 Aug 2026 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974678;
	bh=DKAgX9vLQfbv21p/o2U7e14MI9qkjby15FgY49rCAQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsenwiOABWSpqQtEEKtNxPORoeHmVA/2++j011w2JBgEqE00B5TAWYspjqCp1Rg/h
	 TX2WdCTGIDSJTqMDcxjElQo2azRuaoaBwiVy37J9EGtqMsoj3xA3R4LKi9iXiSGEOR
	 XTBUc4Lzj0kJJutl3ZyYzAlb7E56+DhpU+0/lWHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/250] selftests/sched_ext: Handle sleeping task affinity changes in numa test
Date: Mon, 17 Aug 2026 15:29:38 +0200
Message-ID: <20260817132537.153572304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuba Piecuch <jpiecuch@google.com>

[ Upstream commit d4a00d61a5c2c24973175ace5368d1f6acf9bb0a ]

When a sleeping task's affinity is changed, task_cpu(p) can be outside
of p->cpus_ptr until after select_task_rq() selects a new runqueue for
the task during wakeup.

Thus, the task's NUMA node determined by numa_select_cpu() can be
completely outside of the task's cpumask, leading to
scx_pick_{idle,any}_cpu_node() failing to find an eligible CPU and
returning -EBUSY. This leads to the numa.bpf.c scheduler abnormally
exiting with the following message in dmesg:

sched_ext: numa: invalid CPU -16
   scx_bpf_cpu_node+0x120/0x190
   bpf_prog_0a34b8e0f515771f_numa_select_cpu+0x108/0x14e
   bpf__sched_ext_ops_select_cpu+0x4f/0xb4
   select_task_rq_scx+0xb0/0x210
   select_task_rq+0xa0/0xd0
   __try_to_wake_up+0x196/0x650
   complete_all+0x76/0x100
   migration_cpu_stop+0x22b/0x300
   cpu_stopper_thread+0xc1/0x180
   smpboot_thread_fn+0x16b/0x230
   kthread+0x2d7/0x350
   ret_from_fork+0x1c2/0x350
   ret_from_fork_asm+0x1a/0x30

Make numa_select_cpu() robust against this case by returning @prev_cpu
if no CPU could be found in the selected NUMA node _and_ we have reason
to believe that the task's affinity was changed while it was sleeping.

Fixes: 5ae5161820e5 ("selftests/sched_ext: Add NUMA-aware scheduler test")
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/numa.bpf.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sched_ext/numa.bpf.c b/tools/testing/selftests/sched_ext/numa.bpf.c
index a79d86ed54a1b..0ebb6170331bf 100644
--- a/tools/testing/selftests/sched_ext/numa.bpf.c
+++ b/tools/testing/selftests/sched_ext/numa.bpf.c
@@ -34,7 +34,8 @@ static bool is_cpu_idle(s32 cpu, int node)
 s32 BPF_STRUCT_OPS(numa_select_cpu,
 		   struct task_struct *p, s32 prev_cpu, u64 wake_flags)
 {
-	int node = __COMPAT_scx_bpf_cpu_node(scx_bpf_task_cpu(p));
+	s32 task_cpu = scx_bpf_task_cpu(p);
+	int node = __COMPAT_scx_bpf_cpu_node(task_cpu);
 	s32 cpu;
 
 	/*
@@ -48,6 +49,16 @@ s32 BPF_STRUCT_OPS(numa_select_cpu,
 		cpu = __COMPAT_scx_bpf_pick_any_cpu_node(p->cpus_ptr, node,
 						__COMPAT_SCX_PICK_IDLE_IN_NODE);
 
+	/*
+	 * @task_cpu may be outside of p->cpus_ptr if @p's affinity
+	 * changed while it was sleeping. This means it's possible for
+	 * p->cpus_ptr to not include any CPUs from @node.
+	 * If we failed to find a cpu in @node, check if @task_cpu
+	 * is outside of p->cpus_ptr and just return @prev_cpu if it is.
+	 */
+	if (cpu < 0 && !bpf_cpumask_test_cpu(task_cpu, p->cpus_ptr))
+		return prev_cpu;
+
 	if (is_cpu_idle(cpu, node))
 		scx_bpf_error("CPU %d should be marked as busy", cpu);
 
-- 
2.53.0



