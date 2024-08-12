Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E0417C7C8;
	Mon, 12 Aug 2024 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479422; cv=none; b=QDGWAPMGkR3KmySM90z1K1ulfIGUKzyIE+Ew+j4wKYRHeTZSHZ9WQ6TdHYgqWzAkCDsW5pLM4pdTXA79p27g6N3OSLvpPJgojbHs27PLknTvIsfksOer+YgW2qKt09DYj83UMcxoAV/bRLhprJrjod/NB9JJ7P1ULooknhcYzs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479422; c=relaxed/simple;
	bh=/pblsxj2MWxBm/D0H/GBt0q7nqU9BG3G4hV5F/JgXzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM7AfoEZNC5lMpK34W2YhI7S+UjkJ3l7/0XVYlRxJgMHOIA8DUdasFr24J/5qEZd42HGBr3sSRnZSo4rOPWxZLieV008ve/b28+mTadWCqQU6uZu5Qy9KKamN88Ur9PqWzUQzRhpVD/in/IjK2MX57hvgbLAa91A2t+P3LyMOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3o6EbA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3o6EbA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D0C32782;
	Mon, 12 Aug 2024 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479422;
	bh=/pblsxj2MWxBm/D0H/GBt0q7nqU9BG3G4hV5F/JgXzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3o6EbA3P1RXlWhOFzrEBTStmHmGPYxm3ItXWQkmtdwIqzgwMx9fp0V2KssPSTsir
	 Wg+QcEFSVvk2TNIrY9DlBLpkRzQn5nshni/turtEhxRJqkdjCqCyXZNdtQl/vME4V/
	 4d4eikeNHlZd+NaKTjUbGckjgzo3wqlKjK0owTOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/189] arm64: errata: Unify speculative SSBS errata logic
Date: Mon, 12 Aug 2024 18:02:18 +0200
Message-ID: <20240812160135.299251889@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ec768766608092087dfb5c1fc45a16a6f524dee2 ]

Cortex-X4 erratum 3194386 and Neoverse-V3 erratum 3312417 are identical,
with duplicate Kconfig text and some unsightly ifdeffery. While we try
to share code behind CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS, having
separate options results in a fair amount of boilerplate code, and this
will only get worse as we expand the set of affected CPUs.

To reduce this boilerplate, unify the two behind a common Kconfig
option. This removes the duplicate text and Kconfig logic, and removes
the need for the intermediate ARM64_WORKAROUND_SPECULATIVE_SSBS option.
The set of affected CPUs is described as a list so that this can easily
be extended.

I've used ARM64_ERRATUM_3194386 (matching the Neoverse-V3 erratum ID) as
the common option, matching the way we use ARM64_ERRATUM_1319367 to
cover Cortex-A57 erratum 1319537 and Cortex-A72 erratum 1319367.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-5-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: fix conflicts, drop unneeded cpucaps.h ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +-
 arch/arm64/Kconfig                          | 29 +++------------------
 arch/arm64/kernel/cpu_errata.c              |  8 ++----
 arch/arm64/kernel/proton-pack.c             |  2 +-
 4 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index f8e49ff9ab0d4..e7fc5e1664265 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -147,7 +147,7 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #2253138        | ARM64_ERRATUM_2253138       |
 +----------------+-----------------+-----------------+-----------------------------+
-| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3312417       |
+| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index db5560300df84..d9d84f716228b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1068,34 +1068,14 @@ config ARM64_ERRATUM_3117295
 
 	  If unsure, say Y.
 
-config ARM64_WORKAROUND_SPECULATIVE_SSBS
-	bool
-
 config ARM64_ERRATUM_3194386
-	bool "Cortex-X4: 3194386: workaround for MSR SSBS not self-synchronizing"
-	select ARM64_WORKAROUND_SPECULATIVE_SSBS
+	bool "Cortex-X4/Neoverse-V3: workaround for MSR SSBS not self-synchronizing"
 	default y
 	help
-	  This option adds the workaround for ARM Cortex-X4 erratum 3194386.
+	  This option adds the workaround for the following errata:
 
-	  On affected cores "MSR SSBS, #0" instructions may not affect
-	  subsequent speculative instructions, which may permit unexepected
-	  speculative store bypassing.
-
-	  Work around this problem by placing a speculation barrier after
-	  kernel changes to SSBS. The presence of the SSBS special-purpose
-	  register is hidden from hwcaps and EL0 reads of ID_AA64PFR1_EL1, such
-	  that userspace will use the PR_SPEC_STORE_BYPASS prctl to change
-	  SSBS.
-
-	  If unsure, say Y.
-
-config ARM64_ERRATUM_3312417
-	bool "Neoverse-V3: 3312417: workaround for MSR SSBS not self-synchronizing"
-	select ARM64_WORKAROUND_SPECULATIVE_SSBS
-	default y
-	help
-	  This option adds the workaround for ARM Neoverse-V3 erratum 3312417.
+	  * ARM Cortex-X4 erratum 3194386
+	  * ARM Neoverse-V3 erratum 3312417
 
 	  On affected cores "MSR SSBS, #0" instructions may not affect
 	  subsequent speculative instructions, which may permit unexepected
@@ -1109,7 +1089,6 @@ config ARM64_ERRATUM_3312417
 
 	  If unsure, say Y.
 
-
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3e1554a58209b..36d3f894f8637 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -448,14 +448,10 @@ static const struct midr_range erratum_spec_unpriv_load_list[] = {
 };
 #endif
 
-#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS
-static const struct midr_range erratum_spec_ssbs_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_3194386
+static const struct midr_range erratum_spec_ssbs_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_X4),
-#endif
-#ifdef CONFIG_ARM64_ERRATUM_3312417
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
-#endif
 	{}
 };
 #endif
@@ -758,7 +754,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.cpu_enable = cpu_clear_bf16_from_user_emulation,
 	},
 #endif
-#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS
+#ifdef CONFIG_ARM64_ERRATUM_3194386
 	{
 		.desc = "ARM errata 3194386, 3312417",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_SSBS,
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index e662c4d2856b6..57503dc4b22fa 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -567,7 +567,7 @@ static enum mitigation_state spectre_v4_enable_hw_mitigation(void)
 	 * Mitigate this with an unconditional speculation barrier, as CPUs
 	 * could mis-speculate branches and bypass a conditional barrier.
 	 */
-	if (IS_ENABLED(CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS))
+	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386))
 		spec_bar();
 
 	return SPECTRE_MITIGATED;
-- 
2.43.0



