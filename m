Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD28255E47;
	Mon, 12 May 2025 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072315; cv=none; b=rIoDN/yW/4Bx/oE2iY2Z1/a9pSffegd2c1SRH5+PuL8alyFz5/EiwCsKdfKIw+O3G2vlmmGXigCUJozXfAg0HuguIu7yvCywTmI5zoZj0/07qpC1moIjdeJacHCSqDi698nYwpegqvSjMuH+8UHjr7Rd814LXyKhGmsAG2xur5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072315; c=relaxed/simple;
	bh=6pO5EYx/ppeLnms5NokARCcJHGlxQH2tv6wChQzAcBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p16qP+XhPEbh3T/Z79QaB0dQFJKr3NtpdEChIGUK/ksCqomxV5HY2mfVaMt2x+GoLrXg47Mh1LryOF6xyZJx/hRbnnKcr+5Gfpz4Dy02MtSb1gv8H0VwZwwQCI3ktowOUt/CPeCGPJ050DoXRnsBlPHOZPX1TokK2DWYAjeLEh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si/nf2na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si/nf2na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376FCC4CEE7;
	Mon, 12 May 2025 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072314;
	bh=6pO5EYx/ppeLnms5NokARCcJHGlxQH2tv6wChQzAcBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=si/nf2nacVkOc5OdG9cfNauz4p+Xlabc3Akl+MAQAMUerrv1FGr+gKiRawq8zir7s
	 lfD+C45dmd/8QPX+15o/HqJzxy067DAz3n/s8xZPUBeqbzL2bKRrrCHHT7M3wBZFmx
	 +zg5b3MmVcmmJT0GUVhRNwtKEwgu8/Ynq32IwRRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.14 192/197] x86/its: Add "vmexit" option to skip mitigation on some CPUs
Date: Mon, 12 May 2025 19:40:42 +0200
Message-ID: <20250512172052.231184060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 2665281a07e19550944e8354a2024635a7b2714a upstream.

Ice Lake generation CPUs are not affected by guest/host isolation part of
ITS. If a user is only concerned about KVM guests, they can now choose a
new cmdline option "vmexit" that will not deploy the ITS mitigation when
CPU is not affected by guest/host isolation. This saves the performance
overhead of ITS mitigation on Ice Lake gen CPUs.

When "vmexit" option selected, if the CPU is affected by ITS guest/host
isolation, the default ITS mitigation is deployed.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    2 ++
 arch/x86/include/asm/cpufeatures.h              |    1 +
 arch/x86/kernel/cpu/bugs.c                      |   11 +++++++++++
 arch/x86/kernel/cpu/common.c                    |   19 ++++++++++++-------
 4 files changed, 26 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2186,6 +2186,8 @@
 			off:    Disable mitigation.
 			force:	Force the ITS bug and deploy default
 				mitigation.
+			vmexit: Only deploy mitigation if CPU is affected by
+				guest/host isolation part of ITS.
 
 			For details see:
 			Documentation/admin-guide/hw-vuln/indirect-target-selection.rst
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -536,4 +536,5 @@
 #define X86_BUG_BHI			X86_BUG(1*32 + 3) /* "bhi" CPU is affected by Branch History Injection */
 #define X86_BUG_IBPB_NO_RET	   	X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
 #define X86_BUG_ITS			X86_BUG(1*32 + 5) /* "its" CPU is affected by Indirect Target Selection */
+#define X86_BUG_ITS_NATIVE_ONLY		X86_BUG(1*32 + 6) /* "its_native_only" CPU is affected by ITS, VMX is not affected */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1189,16 +1189,19 @@ do_cmd_auto:
 enum its_mitigation_cmd {
 	ITS_CMD_OFF,
 	ITS_CMD_ON,
+	ITS_CMD_VMEXIT,
 };
 
 enum its_mitigation {
 	ITS_MITIGATION_OFF,
+	ITS_MITIGATION_VMEXIT_ONLY,
 	ITS_MITIGATION_ALIGNED_THUNKS,
 	ITS_MITIGATION_RETPOLINE_STUFF,
 };
 
 static const char * const its_strings[] = {
 	[ITS_MITIGATION_OFF]			= "Vulnerable",
+	[ITS_MITIGATION_VMEXIT_ONLY]		= "Mitigation: Vulnerable, KVM: Not affected",
 	[ITS_MITIGATION_ALIGNED_THUNKS]		= "Mitigation: Aligned branch/return thunks",
 	[ITS_MITIGATION_RETPOLINE_STUFF]	= "Mitigation: Retpolines, Stuffing RSB",
 };
@@ -1225,6 +1228,8 @@ static int __init its_parse_cmdline(char
 	} else if (!strcmp(str, "force")) {
 		its_cmd = ITS_CMD_ON;
 		setup_force_cpu_bug(X86_BUG_ITS);
+	} else if (!strcmp(str, "vmexit")) {
+		its_cmd = ITS_CMD_VMEXIT;
 	} else {
 		pr_err("Ignoring unknown indirect_target_selection option (%s).", str);
 	}
@@ -1280,6 +1285,12 @@ static void __init its_select_mitigation
 	case ITS_CMD_OFF:
 		its_mitigation = ITS_MITIGATION_OFF;
 		break;
+	case ITS_CMD_VMEXIT:
+		if (boot_cpu_has_bug(X86_BUG_ITS_NATIVE_ONLY)) {
+			its_mitigation = ITS_MITIGATION_VMEXIT_ONLY;
+			goto out;
+		}
+		fallthrough;
 	case ITS_CMD_ON:
 		its_mitigation = ITS_MITIGATION_ALIGNED_THUNKS;
 		if (!boot_cpu_has(X86_FEATURE_RETPOLINE))
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1228,6 +1228,8 @@ static const __initconst struct x86_cpu_
 #define RFDS		BIT(7)
 /* CPU is affected by Indirect Target Selection */
 #define ITS		BIT(8)
+/* CPU is affected by Indirect Target Selection, but guest-host isolation is not affected */
+#define ITS_NATIVE_ONLY	BIT(9)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPS(INTEL_IVYBRIDGE,	     X86_STEP_MAX,	SRBDS),
@@ -1248,16 +1250,16 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPS(INTEL_KABYLAKE,		      0xc,	MMIO | RETBLEED | GDS | SRBDS),
 	VULNBL_INTEL_STEPS(INTEL_KABYLAKE,	     X86_STEP_MAX,	MMIO | RETBLEED | GDS | SRBDS | ITS),
 	VULNBL_INTEL_STEPS(INTEL_CANNONLAKE_L,	     X86_STEP_MAX,	RETBLEED),
-	VULNBL_INTEL_STEPS(INTEL_ICELAKE_L,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
-	VULNBL_INTEL_STEPS(INTEL_ICELAKE_D,	     X86_STEP_MAX,	MMIO | GDS | ITS),
-	VULNBL_INTEL_STEPS(INTEL_ICELAKE_X,	     X86_STEP_MAX,	MMIO | GDS | ITS),
+	VULNBL_INTEL_STEPS(INTEL_ICELAKE_L,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED | GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPS(INTEL_ICELAKE_D,	     X86_STEP_MAX,	MMIO | GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPS(INTEL_ICELAKE_X,	     X86_STEP_MAX,	MMIO | GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPS(INTEL_COMETLAKE,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
 	VULNBL_INTEL_STEPS(INTEL_COMETLAKE_L,		      0x0,	MMIO | RETBLEED | ITS),
 	VULNBL_INTEL_STEPS(INTEL_COMETLAKE_L,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
-	VULNBL_INTEL_STEPS(INTEL_TIGERLAKE_L,	     X86_STEP_MAX,	GDS | ITS),
-	VULNBL_INTEL_STEPS(INTEL_TIGERLAKE,	     X86_STEP_MAX,	GDS | ITS),
+	VULNBL_INTEL_STEPS(INTEL_TIGERLAKE_L,	     X86_STEP_MAX,	GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPS(INTEL_TIGERLAKE,	     X86_STEP_MAX,	GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPS(INTEL_LAKEFIELD,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPS(INTEL_ROCKETLAKE,	     X86_STEP_MAX,	MMIO | RETBLEED | GDS | ITS),
+	VULNBL_INTEL_STEPS(INTEL_ROCKETLAKE,	     X86_STEP_MAX,	MMIO | RETBLEED | GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPS(INTEL_ALDERLAKE,	     X86_STEP_MAX,	RFDS),
 	VULNBL_INTEL_STEPS(INTEL_ALDERLAKE_L,	     X86_STEP_MAX,	RFDS),
 	VULNBL_INTEL_STEPS(INTEL_RAPTORLAKE,	     X86_STEP_MAX,	RFDS),
@@ -1480,8 +1482,11 @@ static void __init cpu_set_bug_bits(stru
 	if (cpu_has(c, X86_FEATURE_AMD_IBPB) && !cpu_has(c, X86_FEATURE_AMD_IBPB_RET))
 		setup_force_cpu_bug(X86_BUG_IBPB_NO_RET);
 
-	if (vulnerable_to_its(x86_arch_cap_msr))
+	if (vulnerable_to_its(x86_arch_cap_msr)) {
 		setup_force_cpu_bug(X86_BUG_ITS);
+		if (cpu_matches(cpu_vuln_blacklist, ITS_NATIVE_ONLY))
+			setup_force_cpu_bug(X86_BUG_ITS_NATIVE_ONLY);
+	}
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;


