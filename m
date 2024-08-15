Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4917DA78;
	Thu, 15 Aug 2024 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728929; cv=none; b=bbFr1d94hmcWdDlEVZwOXQS/c3tRvM+8VSGM06kwlf8kG5xMmFfyhIgTFENH8wSJA/83fEdS5NJtdxzUHTWoTex+eB4HKXZtWVM3blzRDrseQMNDSnI4RWp7T0B5mZpXmCj2i5MiNidulEKGJMpastQV7eIAaBtqZcUjSQtKOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728929; c=relaxed/simple;
	bh=2FeguZdaZSLluhFBHtmwWFg/Jp3RGYAshNTZTaZSuxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeJ1lGgDbFBzxRaOnPEykQ9MrbxO3ynqs7y4mchfXnM42umEB2nbxTuw0i662zwoiXBwwP3jPVHYC0+xBq9GRwYsgKQAgFLrVJCPuJ9EOHxjYj04AHJSfp4Eof55BoCvVpb8p7bmSKA6ZNsPmBe3Z1HB6KR8p4bkJEmY6ITyBoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttgD+m2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttgD+m2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3BFC4AF0A;
	Thu, 15 Aug 2024 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728928;
	bh=2FeguZdaZSLluhFBHtmwWFg/Jp3RGYAshNTZTaZSuxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttgD+m2+eH2hDMAzT3zPu8shaP1o8sL7WrGv9p18qOL+3vna8xPAGyzgMMvrONs24
	 W8uUq2YLhSWAVy+mEb5/L2Lo4wGln7vrOWhmgvAEL80U5zdQURL6yID8K9sfzYGkn6
	 fkUY2K9bH3qx1y0KfHSugGKWuu3z9HSUgG96MeRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/196] arm64: errata: Unify speculative SSBS errata logic
Date: Thu, 15 Aug 2024 15:24:33 +0200
Message-ID: <20240815131858.042848465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
[ Mark: fix conflicts & renames, drop unneeded cpucaps.h ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.txt |  2 +-
 arch/arm64/Kconfig                     | 28 ++++----------------------
 arch/arm64/kernel/cpu_errata.c         | 10 +++------
 3 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index e242e96648ed7..c7bdac13e3071 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -63,7 +63,7 @@ stable kernels.
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 | ARM            | Cortex-X4       | #3194386        | ARM64_ERRATUM_3194386       |
 | ARM            | Neoverse-N1     | #1542419        | ARM64_ERRATUM_1542419       |
-| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3312417       |
+| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2816ee3bfd989..747d055627362 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -531,34 +531,14 @@ config ARM64_ERRATUM_1742098
 
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
-
-	  On affected cores "MSR SSBS, #0" instructions may not affect
-	  subsequent speculative instructions, which may permit unexepected
-	  speculative store bypassing.
-
-	  Work around this problem by placing a speculation barrier after
-	  kernel changes to SSBS. The presence of the SSBS special-purpose
-	  register is hidden from hwcaps and EL0 reads of ID_AA64PFR1_EL1, such
-	  that userspace will use the PR_SPEC_STORE_BYPASS prctl to change
-	  SSBS.
+	  This option adds the workaround for the following errata:
 
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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 667ee52e8cb0f..61d3929fafae4 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -354,7 +354,7 @@ void arm64_set_ssbd_mitigation(bool state)
 		 * CPUs could mis-speculate branches and bypass a conditional
 		 * barrier.
 		 */
-		if (IS_ENABLED(CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS))
+		if (IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386))
 			spec_bar();
 
 		return;
@@ -707,14 +707,10 @@ static struct midr_range broken_aarch32_aes[] = {
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
@@ -928,7 +924,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 	},
 #endif
-#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS
+#ifdef CONFIG_ARM64_ERRATUM_3194386
 	{
 		.desc = "ARM errata 3194386, 3312417",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_SSBS,
-- 
2.43.0



