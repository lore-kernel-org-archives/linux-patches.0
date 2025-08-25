Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77529276020;
	Mon, 25 Aug 2025 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124115; cv=none; b=QdNzkFTmBVt06hu13W3lVsF2oBOlpYkSaikVhyOMv/kMkRtF7q2wMGAWjf3cvBYXgNHltEdmjh6PSqctmilABrW3OjbecdryZSYpwdthip1BjypPgiAacYXImOApMBNhm0XKycGO0q+vdy722ezUhq1fJ/ep7EVG3CqLOHY73Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124115; c=relaxed/simple;
	bh=eRL5BpSGnT9fCcnX9NFUgspntWq7x1rnMVtoETm4x4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHDciKX+gsWn/i2pjMrxFU2ahDJPEKPH1kdAJWc1BHynnYYJDcv64E7tUouUspX7px9Uri6kDyzzayAKgLKfmwuNExOE/LlIbhN3CNOYeMRuChlUvmUzurlD4NLRNOk7t8Cf89NLEU7uP4CNdaRbvSCMMALFbBR1xjqQZ+XOsDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxlUufWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxlUufWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40861C4CEED;
	Mon, 25 Aug 2025 12:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124115;
	bh=eRL5BpSGnT9fCcnX9NFUgspntWq7x1rnMVtoETm4x4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxlUufWbV6irgoMYRDCxVXmmzmAn26IvL1BXHyf8OyZCEyQ9Oqkrpr6p0bC681Mjr
	 ORNe/jZuxFk0fdw2n8TrvtAZGd7BsFLoV5eBEzUqIbW1ZIwMwAJ5aVGhGJoHjbO4rs
	 poMMKkS/RRaXoL8jhDqYJ2bTDk1BcY67SjpedXfOi7DbzFcd1dUCXle7SBw3C9wUMq
	 6h2Zt7dKguv0hQp+2+Urqff1bjMlLkXvqVJoMoBjQ02nwJ+QQlAmrDDhW+D11cHjFz
	 hfKOVqXfK75PyiRHpyf/U6afVFNGS+udreJ7aE/pq829MRuevdfvn+hx9+PDeRMRce
	 Ti2U01KDU4eoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	chenhuacai@kernel.org,
	jiaxun.yang@flygoat.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16] LoongArch: Add cpuhotplug hooks to fix high cpu usage of vCPU threads
Date: Mon, 25 Aug 2025 08:14:55 -0400
Message-ID: <20250825121505.2983941-6-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Transfer-Encoding: 8bit

From: Xianglai Li <lixianglai@loongson.cn>

[ Upstream commit 8ef7f3132e4005a103b382e71abea7ad01fbeb86 ]

When the CPU is offline, the timer of LoongArch is not correctly closed.
This is harmless for real machines, but resulting in an excessively high
cpu usage rate of the offline vCPU thread in the virtual machines.

To correctly close the timer, we have made the following modifications:

Register the cpu hotplug event (CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING)
for LoongArch. This event's hooks will be called to close the timer when
the CPU is offline.

Clear the timer interrupt when the timer is turned off. Since before the
timer is turned off, there may be a timer interrupt that has already been
in the pending state due to the interruption of the disabled, which also
affects the halt state of the offline vCPU.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and its context, here is my
assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix for Real User Impact

1. **Fixes a concrete bug affecting virtual machines**: The commit
   addresses a problem where offline vCPUs consume excessive CPU
   resources in virtual machines. This is a real performance bug that
   affects users running LoongArch VMs.

2. **Clear problem statement**: The commit message clearly describes the
   issue - when a CPU is offlined, the LoongArch timer is not properly
   disabled, leading to high CPU usage by offline vCPU threads in
   virtual environments.

## Small and Contained Change

The commit is relatively small and well-contained:
- Adds ~20 lines of code for timer management hooks
- Registers CPU hotplug callbacks using existing infrastructure
  (CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING)
- The changes are isolated to the LoongArch timer subsystem

## Follows Established Patterns

1. **Uses standard kernel infrastructure**: The fix properly uses the
   cpuhotplug framework that other architectures already use (ARM, MIPS,
   RISCV all have similar CPUHP_AP_*_TIMER_STARTING entries).

2. **Similar to previous fixes**: Commit 355170a7ecac ("LoongArch:
   Implement constant timer shutdown interface") addressed a related
   issue with timer shutdown, and this commit completes the proper timer
   management during CPU hotplug.

## Minimal Risk of Regression

1. **Architecture-specific**: Changes are confined to LoongArch
   architecture code, with no impact on other architectures.

2. **Clear timer interrupt handling**: The fix properly clears pending
   timer interrupts when disabling the timer, preventing interrupt
   storms.

3. **Protected by proper locking**: Uses existing state_lock for
   synchronization.

## Virtual Machine Support is Important

With increasing use of virtualization, proper vCPU management is
critical for production environments. High CPU usage by offline vCPUs
can significantly impact VM performance and host resource utilization.

## Technical Correctness

The implementation correctly:
- Enables timer interrupts on CPU startup (`set_csr_ecfg(ECFGF_TIMER)`)
- Shuts down the timer on CPU dying (`constant_set_state_shutdown()`)
- Clears pending timer interrupts
  (`write_csr_tintclear(CSR_TINTCLR_TI)`)

This is a straightforward bug fix that addresses a clear performance
issue in virtual machine environments without introducing new features
or architectural changes, making it an ideal candidate for stable
backport.

 arch/loongarch/kernel/time.c | 22 ++++++++++++++++++++++
 include/linux/cpuhotplug.h   |  1 +
 2 files changed, 23 insertions(+)

diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index 367906b10f81..f3092f2de8b5 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
 #include <linux/clockchips.h>
+#include <linux/cpuhotplug.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/init.h>
@@ -102,6 +103,23 @@ static int constant_timer_next_event(unsigned long delta, struct clock_event_dev
 	return 0;
 }
 
+static int arch_timer_starting(unsigned int cpu)
+{
+	set_csr_ecfg(ECFGF_TIMER);
+
+	return 0;
+}
+
+static int arch_timer_dying(unsigned int cpu)
+{
+	constant_set_state_shutdown(this_cpu_ptr(&constant_clockevent_device));
+
+	/* Clear Timer Interrupt */
+	write_csr_tintclear(CSR_TINTCLR_TI);
+
+	return 0;
+}
+
 static unsigned long get_loops_per_jiffy(void)
 {
 	unsigned long lpj = (unsigned long)const_clock_freq;
@@ -172,6 +190,10 @@ int constant_clockevent_init(void)
 	lpj_fine = get_loops_per_jiffy();
 	pr_info("Constant clock event device register\n");
 
+	cpuhp_setup_state(CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING,
+			  "clockevents/loongarch/timer:starting",
+			  arch_timer_starting, arch_timer_dying);
+
 	return 0;
 }
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index df366ee15456..e62064cb9e08 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -169,6 +169,7 @@ enum cpuhp_state {
 	CPUHP_AP_QCOM_TIMER_STARTING,
 	CPUHP_AP_TEGRA_TIMER_STARTING,
 	CPUHP_AP_ARMADA_TIMER_STARTING,
+	CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING,
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_ARC_TIMER_STARTING,
 	CPUHP_AP_REALTEK_TIMER_STARTING,
-- 
2.50.1

