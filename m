Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2388C4EB852;
	Fri,  9 Oct 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557350; cv=none; b=OhvDzJlCH8bQt5sn0mnMWuChdmtmASuq78QSvtB3eK7hjAqqhH8P14QESn31b7XqawO2qWBoUU97lHZLvSQGWP8u0NlMdjq+Gptwt4eaW2LWg43BoC4NZ/qzZqYUH3w1cwE3rrdOXnlM7qbZvEMaqdvmO4pQo+02+Z15EIc69D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557350; c=relaxed/simple;
	bh=Xl1FFs4eHGG0k0CMHMhg1DtvarIopNuM2l5d4M2CKvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUmM8AFyvCxJrYzLq/w9hFr43BUgc7qbRuA3QEgFSfUzwypE9HcaCU6JD5ct/e4VXvRgL9VtVpt3cNTidtv2oQOmtVzWHeCccLPt9drLXpcxKdjbhnqu6dLnARdoGDf+kvCYt3ebXtn28P4K2fg847gF0gX2NiMmCzGUGwNba98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DBwBdy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DBwBdy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEDC1F000FF;
	Fri,  9 Oct 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557349;
	bh=jk6TRwzZTiOXGVlUy5tUqoMxagbhIam5x1VLCKK76TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DBwBdy45pTlVFh9xjpr/M1dOd32L4iDGOZa3BSYlTvsFaqzb8OoHLGocwrwe6eH+
	 W22aIafkxci+xxQmgKJvg2NCmpl59QefU6aFABxdXRCcBm5hb0woBMd0NT6s31Ly/d
	 scPk/HQF3tOIjI0Jd4S/Nmp6t9dS3q7axcmkWpf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 386/403] arm64: errata: Factor out broken AMU const counter cap
Date: Fri,  9 Oct 2026 16:12:27 +0200
Message-ID: <20261009141001.363771379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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

The paired CPPC FFH counter-read helper is absent here, so omit its
comment-only update. Retain the shared capability and MIDR range list,
and update the existing AMU initialization and constant-counter read
paths. This preserves Cortex-A510 handling and prepares the shared
workaround for Cortex-A725.

Stable-dep-of: 45f730467987 ("arm64: errata: Add Cortex-A725 erratum 3821522 workaround")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig             |    8 ++++++++
 arch/arm64/kernel/cpu_errata.c |   20 ++++++++++++++------
 arch/arm64/kernel/cpufeature.c |    2 +-
 arch/arm64/kernel/topology.c   |    2 +-
 arch/arm64/tools/cpucaps       |    2 +-
 5 files changed, 25 insertions(+), 9 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1049,9 +1049,17 @@ config ARM64_ERRATUM_1902691
 
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -353,6 +353,16 @@ static const struct arm64_cpu_capabiliti
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
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
 static const struct midr_range cavium_erratum_23154_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_THUNDERX),
@@ -869,14 +879,12 @@ const struct arm64_cpu_capabilities arm6
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
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
-
-		/* Cortex-A510 r0p0-r1p1 */
-		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+		CAP_MIDR_RANGE_LIST(workaround_amu_constcnt_list)
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2038923
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2054,7 +2054,7 @@ static void cpu_amu_enable(struct arm64_
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
 
 		/* 0 reference values signal broken/disabled counters */
-		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT))
 			update_freq_counters_refs();
 	}
 }
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -431,7 +431,7 @@ static void cpu_read_constcnt(void *val)
 	 * the counter is disabled. A return value of 0 at counter read is
 	 * properly handled as an error case by the users of the counter.
 	 */
-	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_2457168) ?
+	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT) ?
 		      0UL : read_constcnt();
 }
 
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -98,7 +98,6 @@ WORKAROUND_1902691
 WORKAROUND_2038923
 WORKAROUND_2064142
 WORKAROUND_2077057
-WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
 WORKAROUND_4193714
@@ -122,3 +121,4 @@ WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+WORKAROUND_BROKEN_AMU_CONSTCNT


