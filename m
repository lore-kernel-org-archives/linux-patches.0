Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4BD1E526;
	Thu, 15 Aug 2024 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731703; cv=none; b=fcYy2hIc6v714g91G+l9vUz4jWyUEyVF/DKJgR3eBmqndry//HUwR7jehFkHBWNriXHU8y8V2FbgojBilt335ItJeaARNFanxkGZvE8afjrsGkdp+9Uz65c/0kr5X3+Mx64M7PHdnsebbKUgLvo49raKzEkxKi22b5qC7DEgUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731703; c=relaxed/simple;
	bh=pWTasDln+21MFBYKIkvk542T6Lk+/C0LMPuRYynCqNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG9jQxr7gSN81dRXEOVNF/fs9lkHEDtLHhyLY9UCO4c55ikxGJSx3TPJLUXX009qi3hpQUxaRMXmcV3eKRseeWlxiKIdb1fjjaWKsw/BZI4xg1R5PIPD0ZVTJ3eNkQUm9Us1BosRHHO2ye4WB2bMgL0byjfc13yD9UoFe2Q5wdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAMyUKRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAMyUKRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22CEC4AF0A;
	Thu, 15 Aug 2024 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731703;
	bh=pWTasDln+21MFBYKIkvk542T6Lk+/C0LMPuRYynCqNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAMyUKRXQ8TLoYhGkJ0S7U4sDQUY/3bte6HKt45xF75M7F1a+Ah3mPyDL7wHHNxBr
	 fqC2s5ri4AX5d4FGS7VxGB3ZCr/+aHub2femR8TyDyLeh8shrRmMmxF1eMx8324y16
	 1C/wZl+jR/zYu6SPuzzsrD2leFOA2jIXHeOBCDAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/259] arm64: errata: Add workaround for Arm errata 3194386 and 3312417
Date: Thu, 15 Aug 2024 15:25:45 +0200
Message-ID: <20240815131910.960671916@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 7187bb7d0b5c7dfa18ca82e9e5c75e13861b1d88 ]

Cortex-X4 and Neoverse-V3 suffer from errata whereby an MSR to the SSBS
special-purpose register does not affect subsequent speculative
instructions, permitting speculative store bypassing for a window of
time. This is described in their Software Developer Errata Notice (SDEN)
documents:

* Cortex-X4 SDEN v8.0, erratum 3194386:
  https://developer.arm.com/documentation/SDEN-2432808/0800/

* Neoverse-V3 SDEN v6.0, erratum 3312417:
  https://developer.arm.com/documentation/SDEN-2891958/0600/

To workaround these errata, it is necessary to place a speculation
barrier (SB) after MSR to the SSBS special-purpose register. This patch
adds the requisite SB after writes to SSBS within the kernel, and hides
the presence of SSBS from EL0 such that userspace software which cares
about SSBS will manipulate this via prctl(PR_GET_SPECULATION_CTRL, ...).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-5-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: fix conflicts & renames, drop unneeded cpucaps.h, fold in user_feature_fixup() ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  4 +++
 arch/arm64/Kconfig                     | 41 ++++++++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 +-
 arch/arm64/kernel/cpu_errata.c         | 32 ++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 12 ++++++++
 5 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 6b70b6aabcffe..003424286dda4 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -88,12 +88,16 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X4       | #3194386        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1542419        | ARM64_ERRATUM_1542419       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3312417       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 384b1bf56667c..122f2b068e28d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -590,6 +590,47 @@ config ARM64_ERRATUM_1742098
 
 	  If unsure, say Y.
 
+config ARM64_WORKAROUND_SPECULATIVE_SSBS
+	bool
+
+config ARM64_ERRATUM_3194386
+	bool "Cortex-X4: 3194386: workaround for MSR SSBS not self-synchronizing"
+	select ARM64_WORKAROUND_SPECULATIVE_SSBS
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-X4 erratum 3194386.
+
+	  On affected cores "MSR SSBS, #0" instructions may not affect
+	  subsequent speculative instructions, which may permit unexepected
+	  speculative store bypassing.
+
+	  Work around this problem by placing a speculation barrier after
+	  kernel changes to SSBS. The presence of the SSBS special-purpose
+	  register is hidden from hwcaps and EL0 reads of ID_AA64PFR1_EL1, such
+	  that userspace will use the PR_SPEC_STORE_BYPASS prctl to change
+	  SSBS.
+
+	  If unsure, say Y.
+
+config ARM64_ERRATUM_3312417
+	bool "Neoverse-V3: 3312417: workaround for MSR SSBS not self-synchronizing"
+	select ARM64_WORKAROUND_SPECULATIVE_SSBS
+	default y
+	help
+	  This option adds the workaround for ARM Neoverse-V3 erratum 3312417.
+
+	  On affected cores "MSR SSBS, #0" instructions may not affect
+	  subsequent speculative instructions, which may permit unexepected
+	  speculative store bypassing.
+
+	  Work around this problem by placing a speculation barrier after
+	  kernel changes to SSBS. The presence of the SSBS special-purpose
+	  register is hidden from hwcaps and EL0 reads of ID_AA64PFR1_EL1, such
+	  that userspace will use the PR_SPEC_STORE_BYPASS prctl to change
+	  SSBS.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 3b16cbc945cfa..dbf3ef949c1ed 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -57,7 +57,8 @@
 #define ARM64_WORKAROUND_1542419		47
 #define ARM64_SPECTRE_BHB			48
 #define ARM64_WORKAROUND_1742098		49
+#define ARM64_WORKAROUND_SPECULATIVE_SSBS	50
 
-#define ARM64_NCAPS				50
+#define ARM64_NCAPS				51
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 342cba2ae9820..dd8be391e595d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -372,6 +372,19 @@ void arm64_set_ssbd_mitigation(bool state)
 			asm volatile(SET_PSTATE_SSBS(0));
 		else
 			asm volatile(SET_PSTATE_SSBS(1));
+
+		/*
+		 * SSBS is self-synchronizing and is intended to affect
+		 * subsequent speculative instructions, but some CPUs can
+		 * speculate with a stale value of SSBS.
+		 *
+		 * Mitigate this with an unconditional speculation barrier, as
+		 * CPUs could mis-speculate branches and bypass a conditional
+		 * barrier.
+		 */
+		if (IS_ENABLED(CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS))
+			spec_bar();
+
 		return;
 	}
 
@@ -828,6 +841,18 @@ static struct midr_range broken_aarch32_aes[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS
+static const struct midr_range erratum_spec_ssbs_list[] = {
+#ifdef CONFIG_ARM64_ERRATUM_3194386
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_X4),
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_3312417
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
+#endif
+	{}
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -1016,6 +1041,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 	},
+#endif
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS
+	{
+		.desc = "ARM errata 3194386, 3312417",
+		.capability = ARM64_WORKAROUND_SPECULATIVE_SSBS,
+		ERRATA_MIDR_RANGE_LIST(erratum_spec_ssbs_list),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e4f426c4f2428..42e2c4d324708 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1303,6 +1303,17 @@ static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
 }
 #endif
 
+static void user_feature_fixup(void)
+{
+	if (cpus_have_cap(ARM64_WORKAROUND_SPECULATIVE_SSBS)) {
+		struct arm64_ftr_reg *regp;
+
+		regp = get_arm64_ftr_reg(SYS_ID_AA64PFR1_EL1);
+		if (regp)
+			regp->user_mask &= ~GENMASK(7, 4); /* SSBS */
+	}
+}
+
 static void elf_hwcap_fixup(void)
 {
 #ifdef CONFIG_ARM64_ERRATUM_1742098
@@ -2132,6 +2143,7 @@ void __init setup_cpu_features(void)
 
 	setup_system_capabilities();
 	mark_const_caps_ready();
+	user_feature_fixup();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
 	if (system_supports_32bit_el0()) {
-- 
2.43.0



