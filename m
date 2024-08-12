Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4641F134AC;
	Mon, 12 Aug 2024 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479963; cv=none; b=cNPK6ffSFwGxSvaRPdarF6vrf086xh5jNah0cSNhla0gWGPTuqf8EhC9q9lZGmevEVMsgLNMO4rOtxZifLE4l0lOY9ujsF5ipi22+aZaIgvJLERPdmFzQgp2geaU6j+IgJLdmN0cjIUVVCkum3hxM6zg6HvE0wYbcxIjSiAVSBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479963; c=relaxed/simple;
	bh=R2A2K5VPuQ44IUQigd9Ev3mANQ/72RHmY20iLQXWKKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYkftA8yk5Q7Nz7P+4TzVL5ct2tzFTpjwR8lzVJ03C7pSJvR4AE5zyZnzi/Tx1powYc+8eq1QpaH1gtJWsIwIGl2NddwedoRYVyyy2Z5GjVWGQEqKyX9q+WFifN6XslqU4nnETvd68iunRZdYxLMPRgRFh0HZ5YEovT7CmPmarM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojirCayd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojirCayd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7935C32782;
	Mon, 12 Aug 2024 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479963;
	bh=R2A2K5VPuQ44IUQigd9Ev3mANQ/72RHmY20iLQXWKKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojirCaydps2R9hnaCYaMmnpmG/xRFj7IssmH/P2qqmxPScF139PxT9fglHixz83fc
	 hH2D9yXXgtQIiaM9dU0pPFn9ccyI9onSDTZ5LRmO+DHtlyZhRCdxvwJkVE2HYGgyzP
	 YoSTMMQQZUzXZvDj7V6o0l/RgXbR9WEwQl8v21g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.10 013/263] perf/x86: Fix smp_processor_id()-in-preemptible warnings
Date: Mon, 12 Aug 2024 18:00:14 +0200
Message-ID: <20240812160147.048710240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit f73cefa3b72eaa90abfc43bf6d68137ba059d4b1 ]

The following bug was triggered on a system built with
CONFIG_DEBUG_PREEMPT=y:

 # echo p > /proc/sysrq-trigger

 BUG: using smp_processor_id() in preemptible [00000000] code: sh/117
 caller is perf_event_print_debug+0x1a/0x4c0
 CPU: 3 UID: 0 PID: 117 Comm: sh Not tainted 6.11.0-rc1 #109
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x4f/0x60
  check_preemption_disabled+0xc8/0xd0
  perf_event_print_debug+0x1a/0x4c0
  __handle_sysrq+0x140/0x180
  write_sysrq_trigger+0x61/0x70
  proc_reg_write+0x4e/0x70
  vfs_write+0xd0/0x430
  ? handle_mm_fault+0xc8/0x240
  ksys_write+0x9c/0xd0
  do_syscall_64+0x96/0x190
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

This is because the commit d4b294bf84db ("perf/x86: Hybrid PMU support
for counters") took smp_processor_id() outside the irq critical section.
If a preemption occurs in perf_event_print_debug() and the task is
migrated to another cpu, we may get incorrect pmu debug information.
Move smp_processor_id() back inside the irq critical section to fix this
issue.

Fixes: d4b294bf84db ("perf/x86: Hybrid PMU support for counters")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-and-tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20240729220928.325449-1-lihuafei1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 0c51cfdf76092..83d12dd3f831a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1521,20 +1521,23 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 void perf_event_print_debug(void)
 {
 	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
+	unsigned long *cntr_mask, *fixed_cntr_mask;
+	struct event_constraint *pebs_constraints;
+	struct cpu_hw_events *cpuc;
 	u64 pebs, debugctl;
-	int cpu = smp_processor_id();
-	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	unsigned long *cntr_mask = hybrid(cpuc->pmu, cntr_mask);
-	unsigned long *fixed_cntr_mask = hybrid(cpuc->pmu, fixed_cntr_mask);
-	struct event_constraint *pebs_constraints = hybrid(cpuc->pmu, pebs_constraints);
-	unsigned long flags;
-	int idx;
+	int cpu, idx;
+
+	guard(irqsave)();
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_events, cpu);
+	cntr_mask = hybrid(cpuc->pmu, cntr_mask);
+	fixed_cntr_mask = hybrid(cpuc->pmu, fixed_cntr_mask);
+	pebs_constraints = hybrid(cpuc->pmu, pebs_constraints);
 
 	if (!*(u64 *)cntr_mask)
 		return;
 
-	local_irq_save(flags);
-
 	if (x86_pmu.version >= 2) {
 		rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 		rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
@@ -1578,7 +1581,6 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
 			cpu, idx, pmc_count);
 	}
-	local_irq_restore(flags);
 }
 
 void x86_pmu_stop(struct perf_event *event, int flags)
-- 
2.43.0



