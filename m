Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14F145FFB;
	Thu, 11 Apr 2024 10:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830490; cv=none; b=A3PmLqprH16JQX1v7tFsOKrZGOZV0OzaStQgyKTNPsOS+N1n3+B9Usx0WIxCRBwCj49pCjUzdWqsZZyPQJQBTlDPLf8KpKTH3Z5C2Fp4GO6YgH8QAvdXSpLn+FCBG4dwu7xwGx3aQrriOEZuVJZIwaJxUMgymFbgqvGI79ShbMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830490; c=relaxed/simple;
	bh=/XqT85CCwNuol3hPgbEfQWz4WCkR43wPF4Ha7hThmXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT5I0xz2JP+ZO4X6IeA8FvhJklMIr37RR2XqQfkMUN3R20XBLvF1pyBlyKbi2xEKONHOYor3qbgqaeF4mS679smsyVH3NqlY1UgBV2VfsRfpruKvzp5DJarXTGZbIbkRZhNOjldI/RWQDgTyoa7Pxr+8iJYgHcxvhaXIH1K/YTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8Yputy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8Yputy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2D6C433C7;
	Thu, 11 Apr 2024 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830490;
	bh=/XqT85CCwNuol3hPgbEfQWz4WCkR43wPF4Ha7hThmXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8Yputy0/HZqF4z6kLorLQa+rEkIV0ODeFa+ajP/En+x97eYSve2PgiNyp9zHLLWy
	 SwRaATRXuQ6d/ccUwod4EFlM3wzdKlQ3Y/A3Jadn+DK+cBMzkglAVkmLBt9ykxktYe
	 UOe1Ol7dMqEQPmWboO0XnqnJligHG8I6qGnGcJ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.4 002/215] x86/cpu: Support AMD Automatic IBRS
Date: Thu, 11 Apr 2024 11:53:31 +0200
Message-ID: <20240411095424.952621944@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

commit e7862eda309ecfccc36bb5558d937ed3ace07f3f upstream.

The AMD Zen4 core supports a new feature called Automatic IBRS.

It is a "set-and-forget" feature that means that, like Intel's Enhanced IBRS,
h/w manages its IBRS mitigation resources automatically across CPL transitions.

The feature is advertised by CPUID_Fn80000021_EAX bit 8 and is enabled by
setting MSR C000_0080 (EFER) bit 21.

Enable Automatic IBRS by default if the CPU feature is present.  It typically
provides greater performance over the incumbent generic retpolines mitigation.

Reuse the SPECTRE_V2_EIBRS spectre_v2_mitigation enum.  AMD Automatic IBRS and
Intel Enhanced IBRS have similar enablement.  Add NO_EIBRS_PBRSB to
cpu_vuln_whitelist, since AMD Automatic IBRS isn't affected by PBRSB-eIBRS.

The kernel command line option spectre_v2=eibrs is used to select AMD Automatic
IBRS, if available.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20230124163319.2277355-8-kim.phillips@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   |    6 +++---
 Documentation/admin-guide/kernel-parameters.txt |    6 +++---
 arch/x86/include/asm/cpufeatures.h              |    2 ++
 arch/x86/include/asm/msr-index.h                |    2 ++
 arch/x86/kernel/cpu/bugs.c                      |   20 ++++++++++++--------
 arch/x86/kernel/cpu/common.c                    |   19 +++++++++++--------
 6 files changed, 33 insertions(+), 22 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -622,9 +622,9 @@ kernel command line.
                 retpoline,generic       Retpolines
                 retpoline,lfence        LFENCE; indirect branch
                 retpoline,amd           alias for retpoline,lfence
-                eibrs                   enhanced IBRS
-                eibrs,retpoline         enhanced IBRS + Retpolines
-                eibrs,lfence            enhanced IBRS + LFENCE
+                eibrs                   Enhanced/Auto IBRS
+                eibrs,retpoline         Enhanced/Auto IBRS + Retpolines
+                eibrs,lfence            Enhanced/Auto IBRS + LFENCE
                 ibrs                    use IBRS to protect kernel
 
 		Not specifying this option is equivalent to
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4600,9 +4600,9 @@
 			retpoline,generic - Retpolines
 			retpoline,lfence  - LFENCE; indirect branch
 			retpoline,amd     - alias for retpoline,lfence
-			eibrs		  - enhanced IBRS
-			eibrs,retpoline   - enhanced IBRS + Retpolines
-			eibrs,lfence      - enhanced IBRS + LFENCE
+			eibrs		  - Enhanced/Auto IBRS
+			eibrs,retpoline   - Enhanced/Auto IBRS + Retpolines
+			eibrs,lfence      - Enhanced/Auto IBRS + LFENCE
 			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -382,6 +382,8 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+#define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
+
 /*
  * BUG word(s)
  */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -30,6 +30,7 @@
 #define _EFER_SVME		12 /* Enable virtualization */
 #define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
+#define _EFER_AUTOIBRS		21 /* Enable Automatic IBRS */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
@@ -38,6 +39,7 @@
 #define EFER_SVME		(1<<_EFER_SVME)
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
+#define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
 /* Intel MSRs. Some also available on other CPUs */
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1187,9 +1187,9 @@ static const char * const spectre_v2_str
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
 	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
-	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
-	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
+	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced / Automatic IBRS + LFENCE",
+	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced / Automatic IBRS + Retpolines",
 	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
@@ -1258,7 +1258,7 @@ static enum spectre_v2_mitigation_cmd __
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
 		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
@@ -1436,8 +1436,12 @@ static void __init spectre_v2_select_mit
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		update_spec_ctrl(x86_spec_ctrl_base);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			update_spec_ctrl(x86_spec_ctrl_base);
+		}
 	}
 
 	switch (mode) {
@@ -1521,8 +1525,8 @@ static void __init spectre_v2_select_mit
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
-	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
-	 * enabled.
+	 * firmware calls only when IBRS / Enhanced / Automatic IBRS aren't
+	 * otherwise enabled.
 	 *
 	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
 	 * the user might select retpoline on the kernel command line and if
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1100,8 +1100,8 @@ static const __initconst struct x86_cpu_
 	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/* Zhaoxin Family 7 */
 	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_MMIO),
@@ -1220,8 +1220,16 @@ static void __init cpu_set_bug_bits(stru
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
-	if (ia32_cap & ARCH_CAP_IBRS_ALL)
+	/*
+	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
+	 * flag and protect from vendor-specific bugs via the whitelist.
+	 */
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+			setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+	}
 
 	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
 	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
@@ -1283,11 +1291,6 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	/*
 	 * Check if CPU is vulnerable to GDS. If running in a virtual machine on
 	 * an affected processor, the VMM may have disabled the use of GATHER by


