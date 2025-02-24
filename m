Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D79927701;
	Mon, 24 Feb 2025 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408251; cv=none; b=kbenSa4RGPU7eREJDSFx6X/BEKSrX2AaWcCcILkocdObwu1N7VSyn+lljNPWiIuR9PN2ucO1GpawHGb9nFmVB8VpF3PG3vube1t17+4uevpZ2vHIK1gnITME34DPFQAginWrebZ6XEjNsmQsWd4ZQYJ0/Cqqho+bssktH8TkUC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408251; c=relaxed/simple;
	bh=lA/QuMu77X2kbtTpe3xw3bROzIzw5BwaCo2H2uI96W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7DSYDouQq3zTgQc97A476Rpq3/uJXXrzYN0uzuwJaH9ipSV/aN8FWa4jMnn3r5eoTsFSJ8XCdNo0o1gmNq5+kzZ8wsnF8xfNsXOKIEG2XNhGm5lidx1mXfVjAKZoQBNkeDUz6IL2dCNaB92PVbQ5s9EwNqj+RvXJ2GwXZJ3Pjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIa9ZGdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIa9ZGdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEF2C4CED6;
	Mon, 24 Feb 2025 14:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408250;
	bh=lA/QuMu77X2kbtTpe3xw3bROzIzw5BwaCo2H2uI96W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIa9ZGdtLi7RC+XQzgwypyG6w7qyqV9reYEqAH/ALJR/KwBlJ23jZYvB2ZCQUEtaj
	 KYT2QlQNPE2Z3pAd6qKcDTAoMTenMPhOmkM44Tu0nUGaAog7/hh1oimx4zlA9W6aNz
	 NQK/6GBFL896wOXKWVZHeEDTaXsChjHSadYOFhJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 136/140] perf/x86/intel: Fix ARCH_PERFMON_NUM_COUNTER_LEAF
Date: Mon, 24 Feb 2025 15:35:35 +0100
Message-ID: <20250224142608.354228001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 47a973fd75639fe80d59f9e1860113bb2a0b112b upstream.

The EAX of the CPUID Leaf 023H enumerates the mask of valid sub-leaves.
To tell the availability of the sub-leaf 1 (enumerate the counter mask),
perf should check the bit 1 (0x2) of EAS, rather than bit 0 (0x1).

The error is not user-visible on bare metal. Because the sub-leaf 0 and
the sub-leaf 1 are always available. However, it may bring issues in a
virtualization environment when a VMM only enumerates the sub-leaf 0.

Introduce the cpuid35_e?x to replace the macros, which makes the
implementation style consistent.

Fixes: eb467aaac21e ("perf/x86/intel: Support Architectural PerfMon Extension leaf")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250129154820.3755948-3-kan.liang@linux.intel.com
[ The patch is not exactly the same as the upstream patch. Because in the 6.6
  stable kernel, the umask2/eq enumeration is not supported. The number of
  counters is used rather than the counter mask. But the change is
  straightforward, which utilizes the structured union to replace the macros
  when parsing the CPUID enumeration. It also fixed a wrong macros. ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c      |   17 ++++++++++-------
 arch/x86/include/asm/perf_event.h |   26 +++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 8 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4643,16 +4643,19 @@ static void intel_pmu_check_num_counters
 
 static void update_pmu_cap(struct x86_hybrid_pmu *pmu)
 {
-	unsigned int sub_bitmaps = cpuid_eax(ARCH_PERFMON_EXT_LEAF);
-	unsigned int eax, ebx, ecx, edx;
+	unsigned int cntr, fixed_cntr, ecx, edx;
+	union cpuid35_eax eax;
+	union cpuid35_ebx ebx;
 
-	if (sub_bitmaps & ARCH_PERFMON_NUM_COUNTER_LEAF_BIT) {
+	cpuid(ARCH_PERFMON_EXT_LEAF, &eax.full, &ebx.full, &ecx, &edx);
+
+	if (eax.split.cntr_subleaf) {
 		cpuid_count(ARCH_PERFMON_EXT_LEAF, ARCH_PERFMON_NUM_COUNTER_LEAF,
-			    &eax, &ebx, &ecx, &edx);
-		pmu->num_counters = fls(eax);
-		pmu->num_counters_fixed = fls(ebx);
+			    &cntr, &fixed_cntr, &ecx, &edx);
+		pmu->num_counters = fls(cntr);
+		pmu->num_counters_fixed = fls(fixed_cntr);
 		intel_pmu_check_num_counters(&pmu->num_counters, &pmu->num_counters_fixed,
-					     &pmu->intel_ctrl, ebx);
+					     &pmu->intel_ctrl, fixed_cntr);
 	}
 }
 
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -177,9 +177,33 @@ union cpuid10_edx {
  * detection/enumeration details:
  */
 #define ARCH_PERFMON_EXT_LEAF			0x00000023
-#define ARCH_PERFMON_NUM_COUNTER_LEAF_BIT	0x1
 #define ARCH_PERFMON_NUM_COUNTER_LEAF		0x1
 
+union cpuid35_eax {
+	struct {
+		unsigned int	leaf0:1;
+		/* Counters Sub-Leaf */
+		unsigned int    cntr_subleaf:1;
+		/* Auto Counter Reload Sub-Leaf */
+		unsigned int    acr_subleaf:1;
+		/* Events Sub-Leaf */
+		unsigned int    events_subleaf:1;
+		unsigned int	reserved:28;
+	} split;
+	unsigned int            full;
+};
+
+union cpuid35_ebx {
+	struct {
+		/* UnitMask2 Supported */
+		unsigned int    umask2:1;
+		/* EQ-bit Supported */
+		unsigned int    eq:1;
+		unsigned int	reserved:30;
+	} split;
+	unsigned int            full;
+};
+
 /*
  * Intel Architectural LBR CPUID detection/enumeration details:
  */


