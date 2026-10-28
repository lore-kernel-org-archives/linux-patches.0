Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208878;
	b=fv6taboNolSqK+3oLp5J124KB0lQIE9iKsjxhT/6rrjcTGqrJ7U8YxbkYhOQeM928mTt
	 De4fcIsGEFv7lCN/sQwuBLGH3xZ11i8Z5qW4YyLzCKiq44zGMaO0YRWok4Ci+bOwOj/EV
	 1QRhFxqlA8Oj/RCO5KGMT1WOtfMAkZeJSjLUhsqrBz+D00aRxABIg2qq/etvQ9/5z+m71
	 POuAVDcAtPADz4yGyTv17/3k8UERVfNX1jbfSPaucwOXnUggiZicUFbHRnt3ajHoMAoeC
	 o551M+U7gPII/WHAHibCfd1H+7ebbAusJ52jdwh8qLqLW9Kphq8Ued8gUkrflIJb4RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wvicJtUFP++8wfS6ng8VTrcUw5giHEH7IH2sYzqpmA=;
	b=LCCvmcJ0hi1bZOKjjvDEpNgIFTGCJZLE3tQhZL5FTBqqfMpbNcnf3YEXqTzK+ORG4PYX
	 Gyw+HiA6c/+uFjnSuAEN0/KGASsARxMQl6O8LrW7YYtpdkoy72lMG9Bah176SKU0Weam5
	 R9riHRn/C2nKte21YRrICqcyEPxi86xy2WUrnpxONAzvVXlx9lYcj73W+KXIjThhuinpe
	 DLnMIb1GfSEXEmNCBwtSuca9ieC3xX0CmG2F7as8xFvUlViUzXbeSNvoigLkoMvT3zAUi
	 YTiGESe1iO9JSBunLPnyrb1AqQTPqw7evyUzQaeiuZ45skKXjsUoiegLIJFvwXmWCFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pitrIYWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA0A606A31D;
	Wed, 28 Oct 2026 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pitrIYWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197E91F01825;
	Wed, 28 Oct 2026 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208877;
	bh=9wvicJtUFP++8wfS6ng8VTrcUw5giHEH7IH2sYzqpmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pitrIYWE8ojLSoO7LW1I7aGwxz1YcKvTufUD2w99lFrMvytXTaSVTH1hN9emuhHf6
	 eZRgZVSNbp/rJIcEr8Rjx4v93d9XJ6G+LuspTWBiJvJmT2VzwHNqtyxGfeGZwHAP5k
	 auKeuya9e4Zs4hY4yG0wDmLFMocOv0ProLXE2oiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/516] arm64: errata: Factor out broken AMU const counter cap
Date: Wed, 28 Oct 2026 17:57:05 +0100
Message-ID: <20261028170009.959656179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beata Michalska <beata.michalska@arm.com>

[ Upstream commit 573371caf7aea8582212da81dcead2c3f48fac4b ]

Move the workaround from the erratum 2457168-specific cpucap to a generic
broken AMU constant-counter one. This keeps the existing Cortex-A510
handling unchanged while allowing other errata with similar AMU constant
counter issue to share the capability bit and call sites.

Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

Dropped changes related to CPPC/FFH as support for that is not available
here. Additionally renamed define for WORKAROUND_2457168 to new one,
WORKAROUND_BROKEN_AMU_CONSTCNT to reuse it as this kernel still relies
on the cpucaps header file for the workaround/errata ids.

[ Beata: Dropped changes related to CPPC/FFH as support for that is not available here. Additionally renamed define for WORKAROUND_2457168 to new one, WORKAROUND_BROKEN_AMU_CONSTCNT to reuse it as this kernel still relies on the cpucaps header file for the workaround/errata ids. ]
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig               |  8 ++++++++
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/kernel/cpu_errata.c   | 19 ++++++++++++++-----
 arch/arm64/kernel/cpufeature.c   |  2 +-
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 15182435b7a4f..ae4036d549fc9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -673,9 +673,17 @@ config ARM64_ERRATUM_1508412
 
 	  If unsure, say Y.
 
+config ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
+	bool
+	# Targeting errata affecting AMEVCNTR01, the AMU constant counter.
+	# On affected CPUs the counter may not increment at the expected rate,
+	# making it unreliable. As a result, AMU users should treat it as
+	# unavailable rather than relying on misleading counter values.
+
 config ARM64_ERRATUM_2457168
 	bool "Cortex-A510: 2457168: workaround for AMEVCNTR01 incrementing incorrectly"
 	depends on ARM64_AMU_EXTN
+	select ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
 	default y
 	help
 	  This option adds the workaround for ARM Cortex-A510 erratum 2457168.
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 931c88182fb8b..419eb982335fb 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -67,7 +67,7 @@
 #define ARM64_MTE				57
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_SPECTRE_BHB			59
-#define ARM64_WORKAROUND_2457168		60
+#define ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT	60
 #define ARM64_WORKAROUND_1742098		61
 #define ARM64_WORKAROUND_SPECULATIVE_SSBS	62
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 201a7e29fa113..df83ff9a767d0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -260,6 +260,16 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
+static const struct midr_range workaround_amu_constcnt_list[] = {
+#ifdef CONFIG_ARM64_ERRATUM_2457168
+	/* Cortex-A510 r0p0-r1p1 */
+	MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+#endif
+	{}
+};
+#endif /* CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT */
+
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
 const struct midr_range cavium_erratum_27456_cpus[] = {
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
@@ -611,13 +621,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 				  1, 0),
 	},
 #endif
-#ifdef CONFIG_ARM64_ERRATUM_2457168
+#ifdef CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
 	{
-		.desc = "ARM erratum 2457168",
-		.capability = ARM64_WORKAROUND_2457168,
+		.desc = "Broken AMU AMEVCNTR01 (const counter)",
+		.capability = ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT,
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
-		/* Cortex-A510 r0p0-r1p1 */
-		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+		CAP_MIDR_RANGE_LIST(workaround_amu_constcnt_list)
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1742098
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e055ec3a5cfb8..63ffb1993dcd7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1608,7 +1608,7 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
 
 		/* 0 reference values signal broken/disabled counters */
-		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT))
 			init_cpu_freq_invariance_counters();
 	}
 }
-- 
2.53.0



