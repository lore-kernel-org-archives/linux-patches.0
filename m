Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277FF2AE68;
	Mon, 30 Dec 2024 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573980; cv=none; b=NdeA9tgLAtYIdXMntRdIDWS7iZwzNCgds272Gi3S9LIW98GFPnwe4Cjn7PsPiT7NTaOP2M1xmX0hEgalGBN3n9UEf7BlKEM+7cFb4AK0yLxebiofAGAR0qe9MKNLIdo1OlRCOMcCdtInG9tYfSQ0iogeB5KZRyVXPcOzpwnvRBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573980; c=relaxed/simple;
	bh=iUaxw51qva3X3pf1QqT2m/x2Ma+f01wG1c6sIpD6X9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXLTLSiqCmOfFDatVY8eBeHHyD2ersfDqOh4KF5AmzPrwLTBcxEs6ZYP8fOuBSWZsgBKh1TE+kj6+nC/zvCkigByqy1u5Eaq2ikcRmdOw0pVyC1NnaNRLKMbRnkPjlMz9AXsgiV8FFxiq0YUr0Roxny1H/xX+fXpqk+pzUSlLQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpTVnQfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpTVnQfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A81C4CED0;
	Mon, 30 Dec 2024 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573980;
	bh=iUaxw51qva3X3pf1QqT2m/x2Ma+f01wG1c6sIpD6X9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpTVnQfd3J9h+Pqx3RlM2ssFcDn54Z9nRtjGDuHlts/ebW5p+QdCNeTTrvTkUq3R7
	 Vz6LHlTmWl7UUm3DTKY3yjoWT1eS46JWRHBPma7p0v7BZOV06a4mVNfLVItyARR5U/
	 NXIWy7L18FT8p5ebkNMwe99yMeT0Al87LPbUcoRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 66/86] x86/cpu/intel: Switch to new Intel CPU model defines
Date: Mon, 30 Dec 2024 16:43:14 +0100
Message-ID: <20241230154214.224088784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 6568fc18c2f62b4f35092e9680fe39f3500f4767 ]

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240520224620.9480-29-tony.luck%40intel.com
Stable-dep-of: c9a4b55431e5 ("x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel.c | 108 ++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index aa3e7ed0eb3d..78f34ff32c9b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -72,19 +72,19 @@ static bool cpu_model_supports_sld __ro_after_init;
  */
 static void check_memory_type_self_snoop_errata(struct cpuinfo_x86 *c)
 {
-	switch (c->x86_model) {
-	case INTEL_FAM6_CORE_YONAH:
-	case INTEL_FAM6_CORE2_MEROM:
-	case INTEL_FAM6_CORE2_MEROM_L:
-	case INTEL_FAM6_CORE2_PENRYN:
-	case INTEL_FAM6_CORE2_DUNNINGTON:
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_NEHALEM_G:
-	case INTEL_FAM6_NEHALEM_EP:
-	case INTEL_FAM6_NEHALEM_EX:
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_WESTMERE_EP:
-	case INTEL_FAM6_SANDYBRIDGE:
+	switch (c->x86_vfm) {
+	case INTEL_CORE_YONAH:
+	case INTEL_CORE2_MEROM:
+	case INTEL_CORE2_MEROM_L:
+	case INTEL_CORE2_PENRYN:
+	case INTEL_CORE2_DUNNINGTON:
+	case INTEL_NEHALEM:
+	case INTEL_NEHALEM_G:
+	case INTEL_NEHALEM_EP:
+	case INTEL_NEHALEM_EX:
+	case INTEL_WESTMERE:
+	case INTEL_WESTMERE_EP:
+	case INTEL_SANDYBRIDGE:
 		setup_clear_cpu_cap(X86_FEATURE_SELFSNOOP);
 	}
 }
@@ -106,9 +106,9 @@ static void probe_xeon_phi_r3mwait(struct cpuinfo_x86 *c)
 	 */
 	if (c->x86 != 6)
 		return;
-	switch (c->x86_model) {
-	case INTEL_FAM6_XEON_PHI_KNL:
-	case INTEL_FAM6_XEON_PHI_KNM:
+	switch (c->x86_vfm) {
+	case INTEL_XEON_PHI_KNL:
+	case INTEL_XEON_PHI_KNM:
 		break;
 	default:
 		return;
@@ -134,32 +134,32 @@ static void probe_xeon_phi_r3mwait(struct cpuinfo_x86 *c)
  * - Release note from 20180108 microcode release
  */
 struct sku_microcode {
-	u8 model;
+	u32 vfm;
 	u8 stepping;
 	u32 microcode;
 };
 static const struct sku_microcode spectre_bad_microcodes[] = {
-	{ INTEL_FAM6_KABYLAKE,		0x0B,	0x80 },
-	{ INTEL_FAM6_KABYLAKE,		0x0A,	0x80 },
-	{ INTEL_FAM6_KABYLAKE,		0x09,	0x80 },
-	{ INTEL_FAM6_KABYLAKE_L,	0x0A,	0x80 },
-	{ INTEL_FAM6_KABYLAKE_L,	0x09,	0x80 },
-	{ INTEL_FAM6_SKYLAKE_X,		0x03,	0x0100013e },
-	{ INTEL_FAM6_SKYLAKE_X,		0x04,	0x0200003c },
-	{ INTEL_FAM6_BROADWELL,		0x04,	0x28 },
-	{ INTEL_FAM6_BROADWELL_G,	0x01,	0x1b },
-	{ INTEL_FAM6_BROADWELL_D,	0x02,	0x14 },
-	{ INTEL_FAM6_BROADWELL_D,	0x03,	0x07000011 },
-	{ INTEL_FAM6_BROADWELL_X,	0x01,	0x0b000025 },
-	{ INTEL_FAM6_HASWELL_L,		0x01,	0x21 },
-	{ INTEL_FAM6_HASWELL_G,		0x01,	0x18 },
-	{ INTEL_FAM6_HASWELL,		0x03,	0x23 },
-	{ INTEL_FAM6_HASWELL_X,		0x02,	0x3b },
-	{ INTEL_FAM6_HASWELL_X,		0x04,	0x10 },
-	{ INTEL_FAM6_IVYBRIDGE_X,	0x04,	0x42a },
+	{ INTEL_KABYLAKE,	0x0B,	0x80 },
+	{ INTEL_KABYLAKE,	0x0A,	0x80 },
+	{ INTEL_KABYLAKE,	0x09,	0x80 },
+	{ INTEL_KABYLAKE_L,	0x0A,	0x80 },
+	{ INTEL_KABYLAKE_L,	0x09,	0x80 },
+	{ INTEL_SKYLAKE_X,	0x03,	0x0100013e },
+	{ INTEL_SKYLAKE_X,	0x04,	0x0200003c },
+	{ INTEL_BROADWELL,	0x04,	0x28 },
+	{ INTEL_BROADWELL_G,	0x01,	0x1b },
+	{ INTEL_BROADWELL_D,	0x02,	0x14 },
+	{ INTEL_BROADWELL_D,	0x03,	0x07000011 },
+	{ INTEL_BROADWELL_X,	0x01,	0x0b000025 },
+	{ INTEL_HASWELL_L,	0x01,	0x21 },
+	{ INTEL_HASWELL_G,	0x01,	0x18 },
+	{ INTEL_HASWELL,	0x03,	0x23 },
+	{ INTEL_HASWELL_X,	0x02,	0x3b },
+	{ INTEL_HASWELL_X,	0x04,	0x10 },
+	{ INTEL_IVYBRIDGE_X,	0x04,	0x42a },
 	/* Observed in the wild */
-	{ INTEL_FAM6_SANDYBRIDGE_X,	0x06,	0x61b },
-	{ INTEL_FAM6_SANDYBRIDGE_X,	0x07,	0x712 },
+	{ INTEL_SANDYBRIDGE_X,	0x06,	0x61b },
+	{ INTEL_SANDYBRIDGE_X,	0x07,	0x712 },
 };
 
 static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
@@ -173,11 +173,8 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
 		return false;
 
-	if (c->x86 != 6)
-		return false;
-
 	for (i = 0; i < ARRAY_SIZE(spectre_bad_microcodes); i++) {
-		if (c->x86_model == spectre_bad_microcodes[i].model &&
+		if (c->x86_vfm == spectre_bad_microcodes[i].vfm &&
 		    c->x86_stepping == spectre_bad_microcodes[i].stepping)
 			return (c->microcode <= spectre_bad_microcodes[i].microcode);
 	}
@@ -312,7 +309,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_stepping <= 2 &&
+	if (c->x86_vfm == INTEL_ATOM_BONNELL && c->x86_stepping <= 2 &&
 	    c->microcode < 0x20e) {
 		pr_warn("Atom PSE erratum detected, BIOS microcode update recommended\n");
 		clear_cpu_cap(c, X86_FEATURE_PSE);
@@ -345,11 +342,11 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
 	if (c->x86 == 6) {
-		switch (c->x86_model) {
-		case INTEL_FAM6_ATOM_SALTWELL_MID:
-		case INTEL_FAM6_ATOM_SALTWELL_TABLET:
-		case INTEL_FAM6_ATOM_SILVERMONT_MID:
-		case INTEL_FAM6_ATOM_AIRMONT_NP:
+		switch (c->x86_vfm) {
+		case INTEL_ATOM_SALTWELL_MID:
+		case INTEL_ATOM_SALTWELL_TABLET:
+		case INTEL_ATOM_SILVERMONT_MID:
+		case INTEL_ATOM_AIRMONT_NP:
 			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
 			break;
 		default:
@@ -393,7 +390,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * should be false so that __flush_tlb_all() causes CR3 instead of CR4.PGE
 	 * to be modified.
 	 */
-	if (c->x86 == 5 && c->x86_model == 9) {
+	if (c->x86_vfm == INTEL_QUARK_X1000) {
 		pr_info("Disabling PGE capability bit\n");
 		setup_clear_cpu_cap(X86_FEATURE_PGE);
 	}
@@ -663,12 +660,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && boot_cpu_has(X86_FEATURE_CLFLUSH) &&
-	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
+	if (boot_cpu_has(X86_FEATURE_CLFLUSH) &&
+	    (c->x86_vfm == INTEL_CORE2_DUNNINGTON ||
+	     c->x86_vfm == INTEL_NEHALEM_EX ||
+	     c->x86_vfm == INTEL_WESTMERE_EX))
 		set_cpu_bug(c, X86_BUG_CLFLUSH_MONITOR);
 
-	if (c->x86 == 6 && boot_cpu_has(X86_FEATURE_MWAIT) &&
-		((c->x86_model == INTEL_FAM6_ATOM_GOLDMONT)))
+	if (boot_cpu_has(X86_FEATURE_MWAIT) && c->x86_vfm == INTEL_ATOM_GOLDMONT)
 		set_cpu_bug(c, X86_BUG_MONITOR);
 
 #ifdef CONFIG_X86_64
@@ -1285,9 +1283,9 @@ void handle_bus_lock(struct pt_regs *regs)
  * feature even though they do not enumerate IA32_CORE_CAPABILITIES.
  */
 static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,	0),
 	{}
 };
 
-- 
2.39.5



