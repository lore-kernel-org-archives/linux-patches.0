Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDAD1A7074;
	Thu, 15 Aug 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732874; cv=none; b=jfirIFRYxdqt3wXo6RdIpce4NYmMPK0XIqUAzfjbipKYfNKEiI74uiM0b3Tff6xgbH7g+1Os2EI7ZIUH1Gq3lRuHDhskbjECw9NMSEv+pogXj5bqxfKfRQ+FmkxP3Ggv5ukMcQEPe7L7GYSb9YhdnOJhtQ77HUP3WHf2/fJbGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732874; c=relaxed/simple;
	bh=uBBoPTGV2zor8M5mczdfX5GkKdjmWgr4GA5i6DlbJyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ0rnY66kdULZVcX44eydzED41G9GjSjGedV77VqU2amno5nMbcLnUdhId+vD57Y7bZmvEJVXeVM/mlMFI3K77wTGvnkj6s3PWvG/UwmZJhBWf/LhajQOv5Jo4+OP9kLgNWz/0MpYtwaoumXia0pznJJiEAWlKB2y6zonliIGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTncUN8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTncUN8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35305C4AF0E;
	Thu, 15 Aug 2024 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732873;
	bh=uBBoPTGV2zor8M5mczdfX5GkKdjmWgr4GA5i6DlbJyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTncUN8pGqDPM47vQooJzukepOCt5CDm7yJ2/NLU1NCjPfovWV6kCXV1CTvooahF1
	 MvEaAiE8TyL5NTayfKlKcm7BLrrI7GipDWzFyPlJoS+4NzBip7M+/XcZ6dD06LEN2Q
	 vpqILh0NZiqEAn5kJMf+Y1tTbxF8+DNhh66KnvC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/352] arm64: errata: Add workaround for Arm errata 3194386 and 3312417
Date: Thu, 15 Aug 2024 15:25:51 +0200
Message-ID: <20240815131930.464983587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
 arch/arm64/kernel/cpu_errata.c         | 19 ++++++++++++
 arch/arm64/kernel/cpufeature.c         | 12 ++++++++
 arch/arm64/kernel/proton-pack.c        | 12 ++++++++
 6 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 10a26d44ef4a9..0ecb714b2c426 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -98,12 +98,16 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
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
index 13cf137da999a..0d59e8ab27c88 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -691,6 +691,47 @@ config ARM64_ERRATUM_2457168
 
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
index d2080a41f6e6f..931c88182fb8b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -69,7 +69,8 @@
 #define ARM64_SPECTRE_BHB			59
 #define ARM64_WORKAROUND_2457168		60
 #define ARM64_WORKAROUND_1742098		61
+#define ARM64_WORKAROUND_SPECULATIVE_SSBS	62
 
-#define ARM64_NCAPS				62
+#define ARM64_NCAPS				63
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 5d6f19bc628c2..3eabd809aee4a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -364,6 +364,18 @@ static struct midr_range broken_aarch32_aes[] = {
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
@@ -570,6 +582,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
index 11a42fcf94bfc..dc92fd590f2f9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1753,6 +1753,17 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_MTE */
 
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
@@ -2764,6 +2775,7 @@ void __init setup_cpu_features(void)
 	u32 cwg;
 
 	setup_system_capabilities();
+	user_feature_fixup();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
 	if (system_supports_32bit_el0()) {
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 9c0e9d9eed6e2..b40310e0bdb90 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -574,6 +574,18 @@ static enum mitigation_state spectre_v4_enable_hw_mitigation(void)
 
 	/* SCTLR_EL1.DSSBS was initialised to 0 during boot */
 	asm volatile(SET_PSTATE_SSBS(0));
+
+	/*
+	 * SSBS is self-synchronizing and is intended to affect subsequent
+	 * speculative instructions, but some CPUs can speculate with a stale
+	 * value of SSBS.
+	 *
+	 * Mitigate this with an unconditional speculation barrier, as CPUs
+	 * could mis-speculate branches and bypass a conditional barrier.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS))
+		spec_bar();
+
 	return SPECTRE_MITIGATED;
 }
 
-- 
2.43.0



