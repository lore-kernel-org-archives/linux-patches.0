Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211200;
	b=U6zAZFPPykgQ24/TZaFSNYGjCD2fTv4rXwv8UbFcPJbzMASg46CpVswTvT413xH3jJK9
	 /6ZHhe0JsI2KAXk8QTm+wJ2iG/s6nEsTbR4MLm2ggBRhg2ddMzLAUckxTCtRvhd3XCVHK
	 Rk7iZ0v7CT6qZhHRM78t6XDOexWadDl1Scw+7SIAK7CduIU0qXsVP9NO+NXHdjCFHOTio
	 s0/A2CHWGVwV4jcLgbs7fw9bL77AlN5x5mO2OpyI8TlsDmBe2EsQCsPsJZqUPEE54fUX7
	 OuHu+smEYWZfEmAP/0nD2wJE7uIvtmvKSPL0yzt0Xi7BAXyJ5N/iGjZi2ZVtou+fQzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZltRCUljUcY0FjdNkNbloljtv7qWczhFyk9c1i8rCzo=;
	b=PwPx91+VDLt4ASrkarsjmI6KPVXbOJ0/aA18XN0N5wqqm/6uDFFACWbxFcSeXXSe87Sh
	 hAXoFqkNFUlYFFe3IPpr5ticUZjmZKWRkHrH4gh2Gcj9Tyzw7WgdcvhDq1MtiqAReLVR0
	 bfg/I9RXL4QNBChuYPGxpOBeA/JsM8e2nXap7OjpQI2ICKqeDTcpdnqf1A7bAm1t2O1+g
	 Iv/9eriqxkoH06BFHqQZ3vaPt+NV5coxDQ354z4HTZQpMu38wzQP/f8e+AmVHlvrVUGSL
	 HFWF5Twai5HPYfYcTfxSsgaZGh7I1BBTI5rRPMQIjDdFnt/FyR68JtjDjadWPi6wYcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrdaLX5i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29505606B451;
	Wed, 28 Oct 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrdaLX5i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E25A1F031E2;
	Wed, 28 Oct 2026 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211200;
	bh=ZltRCUljUcY0FjdNkNbloljtv7qWczhFyk9c1i8rCzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrdaLX5iaHxt81LfnIMHPiac6QIJE3IAoT2Ygsry1Rga/1wDHWLyCQyUMw32Ua5OJ
	 4PeyAqb7XH9MUKEJCUU3Qgj9/GiXoiqkcylqBLMhUsjqJR53MOv2qWqyMPI3cFgorb
	 AeaBIcbyKmzsOBH0cH4+QNxRxnIcOAgcXcHIoCMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/571] arm64: errata: Factor out broken AMU const counter cap
Date: Wed, 28 Oct 2026 17:57:21 +0100
Message-ID: <20261028170014.975657976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Beata: Skipped comment updated on amu_read_core_const_ctrs, as that functionality is not available here. Otherwise unmodified. ]
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig             |  8 ++++++++
 arch/arm64/kernel/cpu_errata.c | 20 ++++++++++++++------
 arch/arm64/kernel/cpufeature.c |  2 +-
 arch/arm64/kernel/topology.c   |  2 +-
 arch/arm64/tools/cpucaps       |  2 +-
 5 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 06ef732c0472c..27b5ef31e471d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -716,9 +716,17 @@ config ARM64_ERRATUM_2441009
 
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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e9f0b46e6f653..6da777e815d6b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -259,6 +259,16 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
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
@@ -660,14 +670,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
 	},
 #endif
-
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
index a2518ccc5e980..7fd2f014c4791 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1785,7 +1785,7 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
 
 		/* 0 reference values signal broken/disabled counters */
-		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT))
 			update_freq_counters_refs();
 	}
 }
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 877c68f472822..615efd611a873 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -285,7 +285,7 @@ static void cpu_read_constcnt(void *val)
 	 * the counter is disabled. A return value of 0 at counter read is
 	 * properly handled as an error case by the users of the counter.
 	 */
-	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_2457168) ?
+	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT) ?
 		      0UL : read_constcnt();
 }
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index e7f4ae17f31b0..84baf77e847a7 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -55,7 +55,6 @@ WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
 WORKAROUND_1742098
-WORKAROUND_2457168
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
@@ -71,3 +70,4 @@ WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
+WORKAROUND_BROKEN_AMU_CONSTCNT
-- 
2.53.0



