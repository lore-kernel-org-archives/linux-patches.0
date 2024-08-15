Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392F91AC896;
	Thu, 15 Aug 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731719; cv=none; b=j3KfLu6UyP+d7dOj0kL71EBztH+4J4sKcGzAE1JTAa6wciV6TlafRAaBtq7kT3YzAUxiWyz2uzwCLw3APtPKIiSDaZtrWt5lUQItGIe9Om/q3AvYxJ90B1CwnhgseF5UPphYKB/JcOq4Vh7WXgQ5TWHuyTQhucDNoyLXhf4+iwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731719; c=relaxed/simple;
	bh=y9BSpmUKiIIjJptnHQRx7aTwyuR/L8/3xrwFqFnUNc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEHTJJ/OmALGLM4bmlOPD92pjIbApo+f0YAUhIsCrJJqOdM0u8GVbPuhQV+TMGPDQJ+oqYc+jo9UrOyt9uv5zLOD4EuntSIADsjP5HF9EU7f3W1F3rRRzmQSttvIHjr2wodhJQPn5QoNJhLy48jIJ1B4Dt2i3lsws+MO78YBVvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12n5E63o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12n5E63o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6B2C32786;
	Thu, 15 Aug 2024 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731719;
	bh=y9BSpmUKiIIjJptnHQRx7aTwyuR/L8/3xrwFqFnUNc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12n5E63o4n+olY+ZE4Up5FlQXcd8PDB/SnWdvW4URyyXaq4pvTL9w8faytE+HH/M6
	 4EjEm4ugBvJ74nJzaN94joOUvg8CTqd7QgbhS/WZeLcGkOQ1XSK/gzSfv0RjXDPTa4
	 zUV3cyY94nwxmJEk3bGHGA0FlSYFhzhl8bD1KJ+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/259] arm64: errata: Unify speculative SSBS errata logic
Date: Thu, 15 Aug 2024 15:25:49 +0200
Message-ID: <20240815131911.112483290@linuxfoundation.org>
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
 Documentation/arm64/silicon-errata.rst |  2 +-
 arch/arm64/Kconfig                     | 28 ++++----------------------
 arch/arm64/kernel/cpu_errata.c         | 10 +++------
 3 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 003424286dda4..b2db2492bd131 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -96,7 +96,7 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1542419        | ARM64_ERRATUM_1542419       |
 +----------------+-----------------+-----------------+-----------------------------+
-| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3312417       |
+| ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 122f2b068e28d..1455a81ee8687 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -590,34 +590,14 @@ config ARM64_ERRATUM_1742098
 
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
index dd8be391e595d..5e77a7595059b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -382,7 +382,7 @@ void arm64_set_ssbd_mitigation(bool state)
 		 * CPUs could mis-speculate branches and bypass a conditional
 		 * barrier.
 		 */
-		if (IS_ENABLED(CONFIG_ARM64_WORKAROUND_SPECULATIVE_SSBS))
+		if (IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386))
 			spec_bar();
 
 		return;
@@ -841,14 +841,10 @@ static struct midr_range broken_aarch32_aes[] = {
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
@@ -1042,7 +1038,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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



