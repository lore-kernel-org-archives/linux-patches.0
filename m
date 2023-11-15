Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1C643AD9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrbBK8uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6623C4E777;
	Wed, 15 Nov 2023 20:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081739;
	bh=YDWFwLXQzSho5HAR3p8xRqBeFjTPCfkp3qI6yTGgraw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrbBK8uJ0X1F1eecGwn9h6VDjNmX8GJacZ/QECYRhr+/Sn07sHq6y2r5QfwhuvlK9
	 UV66oYFizPNNaklAiS+MkE6a1AojMpp/viWx1WZCI26/7LI99fa8m3SzjKmnQEPrJt
	 aSIcJd3ad5jI1HsAGeulNIUIDxuZtLc3s17j0HwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Bertrand Marquis <bertrand.marquis@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/191] arm64/arm: xen: enlighten: Fix KPTI checks
Date: Wed, 15 Nov 2023 15:45:52 -0500
Message-ID: <20231115204649.214287947@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 20f3b8eafe0ba5d3c69d5011a9b07739e9645132 ]

When KPTI is in use, we cannot register a runstate region as XEN
requires that this is always a valid VA, which we cannot guarantee. Due
to this, xen_starting_cpu() must avoid registering each CPU's runstate
region, and xen_guest_init() must avoid setting up features that depend
upon it.

We tried to ensure that in commit:

  f88af7229f6f22ce (" xen/arm: do not setup the runstate info page if kpti is enabled")

... where we added checks for xen_kernel_unmapped_at_usr(), which wraps
arm64_kernel_unmapped_at_el0() on arm64 and is always false on 32-bit
arm.

Unfortunately, as xen_guest_init() is an early_initcall, this happens
before secondary CPUs are booted and arm64 has finalized the
ARM64_UNMAP_KERNEL_AT_EL0 cpucap which backs
arm64_kernel_unmapped_at_el0(), and so this can subsequently be set as
secondary CPUs are onlined. On a big.LITTLE system where the boot CPU
does not require KPTI but some secondary CPUs do, this will result in
xen_guest_init() intializing features that depend on the runstate
region, and xen_starting_cpu() registering the runstate region on some
CPUs before KPTI is subsequent enabled, resulting the the problems the
aforementioned commit tried to avoid.

Handle this more robsutly by deferring the initialization of the
runstate region until secondary CPUs have been initialized and the
ARM64_UNMAP_KERNEL_AT_EL0 cpucap has been finalized. The per-cpu work is
moved into a new hotplug starting function which is registered later
when we're certain that KPTI will not be used.

Fixes: f88af7229f6f ("xen/arm: do not setup the runstate info page if kpti is enabled")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Bertrand Marquis <bertrand.marquis@arm.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c   | 25 ++++++++++++++++---------
 include/linux/cpuhotplug.h |  1 +
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8ad576ecd0f1d..3d25fd615250a 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -158,9 +158,6 @@ static int xen_starting_cpu(unsigned int cpu)
 	BUG_ON(err);
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
-	if (!xen_kernel_unmapped_at_usr())
-		xen_setup_runstate_info(cpu);
-
 after_register_vcpu_info:
 	enable_percpu_irq(xen_events_irq, 0);
 	return 0;
@@ -386,9 +383,6 @@ static int __init xen_guest_init(void)
 		return -EINVAL;
 	}
 
-	if (!xen_kernel_unmapped_at_usr())
-		xen_time_setup_guest();
-
 	if (xen_initial_domain())
 		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 
@@ -398,7 +392,13 @@ static int __init xen_guest_init(void)
 }
 early_initcall(xen_guest_init);
 
-static int __init xen_pm_init(void)
+static int xen_starting_runstate_cpu(unsigned int cpu)
+{
+	xen_setup_runstate_info(cpu);
+	return 0;
+}
+
+static int __init xen_late_init(void)
 {
 	if (!xen_domain())
 		return -ENODEV;
@@ -411,9 +411,16 @@ static int __init xen_pm_init(void)
 		do_settimeofday64(&ts);
 	}
 
-	return 0;
+	if (xen_kernel_unmapped_at_usr())
+		return 0;
+
+	xen_time_setup_guest();
+
+	return cpuhp_setup_state(CPUHP_AP_ARM_XEN_RUNSTATE_STARTING,
+				 "arm/xen_runstate:starting",
+				 xen_starting_runstate_cpu, NULL);
 }
-late_initcall(xen_pm_init);
+late_initcall(xen_late_init);
 
 
 /* empty stubs */
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index cb87247da5ba1..7cc2889608e0f 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -144,6 +144,7 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
+	CPUHP_AP_ARM_XEN_RUNSTATE_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
-- 
2.42.0



