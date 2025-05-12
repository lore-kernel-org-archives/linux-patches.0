Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8EC29ACF0;
	Mon, 12 May 2025 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073531; cv=none; b=ayPfIhNImhwBHspKBkF1NG7c6pDC7shgH0ejUhbFrhpjHFuKGi/Jma44JgvjjEv3tl5t+eAq2GaimaqFm/VUoRqD0dGL66skTKVTo4nIsM6neDgFLBFT/y5aNiMHFdHeejT6amkiNB/GWgCU50+tbkRkzfG888RiseA0bXjQzeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073531; c=relaxed/simple;
	bh=bdSLftr0bzllr4uu3zCOXdhCBQSv+N1GX0JX2z+yYCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m50YblTOBxqwcfLXgvQuStHNLa4TLZHHCu5+Lkfz9AoDfrvZ/E6g3nJWAj8dOTmJg6ZTppWqKZTzK5aK02HTnSZQg82e7dt17tn8vP8SdmUCSa9aD2/nY71ZZmEIU5d+0+jQf2bAkn4UmOe0KdrX9h1mJCnXQjEPkg/+y2Y08Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iesXqYDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iesXqYDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A39EC4CEE7;
	Mon, 12 May 2025 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073530;
	bh=bdSLftr0bzllr4uu3zCOXdhCBQSv+N1GX0JX2z+yYCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iesXqYDWgwFjem2mgk/Eh4yv2P+4qv/jda4IYBwGvWZ4mNrScO18WGvnnO7EUoZvJ
	 aYj7E48emb8pN/h0LHeWyH9AdNVlbt8d1TNoLclxnCjgMezvpcQc4hKqmdxT6iEbEw
	 EpRBJbvg984krb56CyOBr4QjZD1Hw/8FErgf98FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.6 105/113] x86/its: Enumerate Indirect Target Selection (ITS) bug
Date: Mon, 12 May 2025 19:46:34 +0200
Message-ID: <20250512172031.951312661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 159013a7ca18c271ff64192deb62a689b622d860 upstream.

ITS bug in some pre-Alderlake Intel CPUs may allow indirect branches in the
first half of a cache line get predicted to a target of a branch located in
the second half of the cache line.

Set X86_BUG_ITS on affected CPUs. Mitigation to follow in later commits.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 
 arch/x86/include/asm/msr-index.h   |    8 +++++
 arch/x86/kernel/cpu/common.c       |   58 +++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c                 |    4 +-
 4 files changed, 58 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -518,4 +518,5 @@
 #define X86_BUG_RFDS			X86_BUG(1*32 + 2) /* CPU is vulnerable to Register File Data Sampling */
 #define X86_BUG_BHI			X86_BUG(1*32 + 3) /* CPU is affected by Branch History Injection */
 #define X86_BUG_IBPB_NO_RET		X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
+#define X86_BUG_ITS			X86_BUG(1*32 + 5) /* CPU is affected by Indirect Target Selection */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -180,6 +180,14 @@
 						 * VERW clears CPU Register
 						 * File.
 						 */
+#define ARCH_CAP_ITS_NO			BIT_ULL(62) /*
+						     * Not susceptible to
+						     * Indirect Target Selection.
+						     * This bit is not set by
+						     * HW, but is synthesized by
+						     * VMMs for guests to know
+						     * their affected status.
+						     */
 
 #define ARCH_CAP_XAPIC_DISABLE		BIT(21)	/*
 						 * IA32_XAPIC_DISABLE_STATUS MSR
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1272,6 +1272,8 @@ static const __initconst struct x86_cpu_
 #define GDS		BIT(6)
 /* CPU is affected by Register File Data Sampling */
 #define RFDS		BIT(7)
+/* CPU is affected by Indirect Target Selection */
+#define ITS		BIT(8)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1283,22 +1285,25 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(BROADWELL_G,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPINGS(0x0, 0x5),	MMIO | RETBLEED | GDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | ITS),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x0, 0xb),	MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS | ITS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x0, 0xc),	MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS | ITS),
 	VULNBL_INTEL_STEPPINGS(CANNONLAKE_L,	X86_STEPPING_ANY,		RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO | GDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO | GDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS),
-	VULNBL_INTEL_STEPPINGS(TIGERLAKE_L,	X86_STEPPING_ANY,		GDS),
-	VULNBL_INTEL_STEPPINGS(TIGERLAKE,	X86_STEPPING_ANY,		GDS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED | ITS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(TIGERLAKE_L,	X86_STEPPING_ANY,		GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(TIGERLAKE,	X86_STEPPING_ANY,		GDS | ITS),
 	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | ITS),
 	VULNBL_INTEL_STEPPINGS(ALDERLAKE,	X86_STEPPING_ANY,		RFDS),
 	VULNBL_INTEL_STEPPINGS(ALDERLAKE_L,	X86_STEPPING_ANY,		RFDS),
 	VULNBL_INTEL_STEPPINGS(RAPTORLAKE,	X86_STEPPING_ANY,		RFDS),
@@ -1362,6 +1367,32 @@ static bool __init vulnerable_to_rfds(u6
 	return cpu_matches(cpu_vuln_blacklist, RFDS);
 }
 
+static bool __init vulnerable_to_its(u64 x86_arch_cap_msr)
+{
+	/* The "immunity" bit trumps everything else: */
+	if (x86_arch_cap_msr & ARCH_CAP_ITS_NO)
+		return false;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+
+	/* None of the affected CPUs have BHI_CTRL */
+	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
+		return false;
+
+	/*
+	 * If a VMM did not expose ITS_NO, assume that a guest could
+	 * be running on a vulnerable hardware or may migrate to such
+	 * hardware.
+	 */
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return true;
+
+	if (cpu_matches(cpu_vuln_blacklist, ITS))
+		return true;
+
+	return false;
+}
+
 static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 x86_arch_cap_msr = x86_read_arch_cap_msr();
@@ -1489,6 +1520,9 @@ static void __init cpu_set_bug_bits(stru
 	if (cpu_has(c, X86_FEATURE_AMD_IBPB) && !cpu_has(c, X86_FEATURE_AMD_IBPB_RET))
 		setup_force_cpu_bug(X86_BUG_IBPB_NO_RET);
 
+	if (vulnerable_to_its(x86_arch_cap_msr))
+		setup_force_cpu_bug(X86_BUG_ITS);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1621,7 +1621,7 @@ static bool kvm_is_immutable_feature_msr
 	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
 	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
 	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | ARCH_CAP_GDS_NO | \
-	 ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO)
+	 ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO | ARCH_CAP_ITS_NO)
 
 static u64 kvm_get_arch_capabilities(void)
 {
@@ -1655,6 +1655,8 @@ static u64 kvm_get_arch_capabilities(voi
 		data |= ARCH_CAP_MDS_NO;
 	if (!boot_cpu_has_bug(X86_BUG_RFDS))
 		data |= ARCH_CAP_RFDS_NO;
+	if (!boot_cpu_has_bug(X86_BUG_ITS))
+		data |= ARCH_CAP_ITS_NO;
 
 	if (!boot_cpu_has(X86_FEATURE_RTM)) {
 		/*


