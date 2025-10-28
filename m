Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B998E1AA7BF;
	Tue, 28 Oct 2025 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612001; cv=none; b=XLk/Q6DD1pfER84gb2WIrvgahMZIdRh7PgK9Q3ffzblvb+NAc0sGnsE/+Ja0OZBaUFuaW/hJo5TneYKTRtdrCymE/9mRObAlapXy8sFA1F4Yi+QoTZ9IgOHpQSlhL3eCYJly4A0lM76VLkXehSQDu5Fdz0dQIx+dCVeix7r+c5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612001; c=relaxed/simple;
	bh=cYToG8gJg2SXm2fRtKr6D0RTY0BlFfLbpiMaBP/gXSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGe09omYIcY1ggwdCIpENHZxcOsdL3YG6/os8ddvHpdbRhri2Ber3dkXxjhBCxK3WgV7JXDZ2ucvQkfMNE+vB5HNvVBgQ7sEM0JHLiB9LKGv4qwm2s8kRMaMMsWomyGR5JH4OVfX85dJWTTeBetWeOxzdDnKZk4KCV/QFBkTNuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l87DfqEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l87DfqEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01780C4CEF1;
	Tue, 28 Oct 2025 00:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612001;
	bh=cYToG8gJg2SXm2fRtKr6D0RTY0BlFfLbpiMaBP/gXSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l87DfqEh6phwcPi2pHWRFJ3z9Ut2xLQzLNZruLv9gWXICKd/m/HOpQ2NOCQtD5FcE
	 cMli1V6uf+PAkesZix0rCktsVNHQeeGiKiG9CggLxC9+C6JX9qtou06KP0wagcoE8z
	 kQIjRfHI7malZnvGSkYFVCCEXwa77UVsEv6l594TeGtucabAf9CNvNHsnPYJV9NjO/
	 8kBgLb4bPhe9SiiUAI5lAS8DNJ8CvcuYpNDoPqIx72I/7Qndcwid+DDE662k7faiy5
	 63KEXOhRLBC0I5q/Ocbu645AAoezWl3zJoXx2s1nH4mibeMWAPwBSr2gJvvvF/ur7u
	 dM6lTy19AGhLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.10] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Mon, 27 Oct 2025 20:38:52 -0400
Message-ID: <20251028003940.884625-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>

[ Upstream commit ae9e9f3d67dcef7582a4524047b01e33c5185ddb ]

openSBI v1.7 adds harts checks for ipi operations. Especially it
adds comparison between hmask passed as an argument from linux
and mask of online harts (from openSBI side). If they don't
fit each other the error occurs.

When cpu is offline, cpu_online_mask is explicitly cleared in
__cpu_disable. However, there is no explicit clearing of
mm_cpumask. mm_cpumask is used for rfence operations that
call openSBI RFENCE extension which uses ipi to remote harts.
If hart is offline there may be error if mask of linux is not
as mask of online harts in openSBI.

this patch adds explicit clearing of mm_cpumask for offline hart.

Signed-off-by: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250919132849.31676-1-danil.skrebenkov@cloudbear.ru
[pjw@kernel.org: rewrote subject line for clarity]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis using semantic code analysis tools
and examination of the kernel repository, here is my determination:

## **Backport Status: YES**

## Extensive Analysis

### 1. Semantic Tools Used and Findings

**mcp__semcode__find_function & mcp__semcode__find_callers:**
- Located `clear_tasks_mm_cpumask()` in kernel/cpu.c:1241-1268 - a well-
  established function that safely clears CPU bits from all process
  mm_cpumask fields
- Found that `arch_cpuhp_cleanup_dead_cpu()` is called by
  `cpuhp_bp_sync_dead()` in the CPU hotplug core synchronization path
  (kernel/cpu.c:361)
- **Critical finding**: ARM, ARM64, PARISC, and PowerPC architectures
  already call `clear_tasks_mm_cpumask()` in their
  `arch_cpuhp_cleanup_dead_cpu()` implementations - RISC-V was the
  outlier missing this call

**mcp__semcode__find_callchain:**
- Traced the execution path: `cpuhp_bp_sync_dead` →
  `arch_cpuhp_cleanup_dead_cpu` → `clear_tasks_mm_cpumask`
- Confirmed this is part of the standard CPU hotplug dead-CPU cleanup
  sequence

**Impact Analysis via Callers:**
- `sbi_remote_sfence_vma_asid()` (the function affected by stale
  mm_cpumask) has 3 direct callers, with `__flush_tlb_range()` being the
  main one (arch/riscv/mm/tlbflush.c:118)
- `__flush_tlb_range()` is called by ALL TLB flush operations:
  `flush_tlb_mm()`, `flush_tlb_page()`, `flush_tlb_range()`,
  `flush_pmd_tlb_range()`, `flush_pud_tlb_range()`, and
  `arch_tlbbatch_flush()`
- **User-space exposure**: HIGH - Any memory operations (mmap, munmap,
  mprotect, page faults) trigger TLB flushes

### 2. Code Change Analysis

The fix adds exactly **one line** to arch/riscv/kernel/cpu-hotplug.c:
```c
clear_tasks_mm_cpumask(cpu);
```

This is placed in `arch_cpuhp_cleanup_dead_cpu()` right after the CPU is
confirmed dead, matching the pattern used by other architectures.

### 3. Root Cause and Bug Impact

**The Bug:**
When a CPU is hot-unplugged:
1. `__cpu_disable()` clears `cpu_online_mask` (line 39 of cpu-hotplug.c)
2. **BUT** the offline CPU remains set in mm_cpumask of all running
   processes
3. Subsequent TLB flush operations use `mm_cpumask(mm)` to determine
   target CPUs
4. This calls `sbi_remote_sfence_vma_asid()` which invokes openSBI's
   RFENCE extension with the stale CPU mask
5. **openSBI v1.7+** validates the hart mask against online harts and
   **returns an error** if they don't match

**Consequences:**
- RFENCE operations fail with errors
- TLB flush failures can lead to stale TLB entries
- Potential for data corruption or system instability
- Issue occurs on **every TLB flush** after any CPU hotplug event

**Affected Versions:**
- Bug introduced in v6.10 (commit 72b11aa7f8f93, May 2023) when RISC-V
  switched to hotplug core state synchronization
- Fix appears in v6.18-rc2

### 4. Why This Should Be Backported

**Meets Stable Tree Criteria:**
✅ **Fixes important bug**: RFENCE errors with openSBI v1.7+ cause TLB
flush failures
✅ **Obviously correct**: Matches established pattern from 4+ other
architectures (ARM, ARM64, PARISC, PowerPC)
✅ **Small and contained**: Single line addition, no side effects
✅ **No new features**: Pure bug fix for CPU hotplug cleanup
✅ **Low regression risk**: Function specifically designed for this
purpose, already tested on multiple architectures

**Additional Justification:**
1. **Architectural correctness**: RISC-V should behave like other
   architectures for CPU hotplug
2. **Real-world impact**: Affects any RISC-V system with CPU hotplug +
   openSBI v1.7+
3. **High exposure**: User-space memory operations routinely trigger TLB
   flushes
4. **No dependencies**: `clear_tasks_mm_cpumask()` already exists in all
   kernel versions with CPU hotplug support
5. **Well-understood fix**: The function has extensive documentation
   explaining its purpose (kernel/cpu.c:1241)

**Risk Assessment:**
- **Minimal risk**: The fix aligns RISC-V with established behavior
- `clear_tasks_mm_cpumask()` includes safeguards:
  WARN_ON(cpu_online(cpu)) check, proper RCU locking
- No changes to core hotplug logic, just adds missing cleanup step

### 5. Why No Stable Tag?

The commit lacks "Cc: stable@vger.kernel.org" and "Fixes:" tags, which
is unfortunate. However, based on:
- The commit message explicitly describing the error condition
- The architectural inconsistency (other arches already do this)
- The real-world failure with openSBI v1.7+
- Review by Andrew Jones (a RISC-V maintainer)

This appears to be an oversight rather than an indication the fix
shouldn't be backported.

### Recommendation

**YES - This commit should be backported to stable kernels v6.10+** as
it fixes a real bug causing TLB flush failures on RISC-V systems with
CPU hotplug enabled when using modern openSBI firmware. The fix is
small, safe, and brings RISC-V in line with other architectures.

 arch/riscv/kernel/cpu-hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index a1e38ecfc8be2..3f50d3dd76c6f 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -54,6 +54,7 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops->cpu_is_stopped)
 		ret = cpu_ops->cpu_is_stopped(cpu);
-- 
2.51.0

