Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892AA297B95;
	Mon, 12 May 2025 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073181; cv=none; b=A5G+SyYs7Jf37YzREwdx1qyYGonw2aAEjPEujRFGXVgj/aJ/Ry0VZeAn/K1aRZMB8ATIfmbDdopjZRothn/HreOWjvF/TH4IcCt+fji+lh31jeXmPro0Q+ABWQpQ9/Q+fjg9fFexoumQxFuVWdQWazkXE3RM0zoKOZpJEYnM6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073181; c=relaxed/simple;
	bh=ltfQ1PrXUpUvYgP0X7xK9JNAy5iYJk4kUeT+nw/IJPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwDEfbzD+2yMt2YfF6QQQO/GAsuz0qJiAef+DELmQ6KYFDO0EO6savar3XR9l5Kjlt7rANJ9hjQHTJ3N34yK6nazXhf7BWkc4m/tRn9PgZUH/tIyORvgsdUE7k7xLmLdsTOl0mv/kQy2cucUmqR8k8ezwk2UfH9klD1YnXhyckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAKDzKyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAKDzKyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A09C4CEE7;
	Mon, 12 May 2025 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073179;
	bh=ltfQ1PrXUpUvYgP0X7xK9JNAy5iYJk4kUeT+nw/IJPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAKDzKybfBxY19EGuuU8+GEqyoOXCg773/81jxsjapBjwzjjAn8B+IoVI/l/mBK2F
	 Rarf/r0noe4+gtZEcq3RgXu9Lpt6SDMtgT87o8n2A/P/zDGRPVxa5cdaVX0JP5z5gj
	 Pyg8rp19hlmOqQN0+lUNosbLplL/7mIJv//sXyF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 179/184] x86/its: Add "vmexit" option to skip mitigation on some CPUs
Date: Mon, 12 May 2025 19:46:20 +0200
Message-ID: <20250512172049.096920755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2157,6 +2157,8 @@
 			off:    Disable mitigation.
 			force:	Force the ITS bug and deploy default
 				mitigation.
+			vmexit: Only deploy mitigation if CPU is affected by
+				guest/host isolation part of ITS.
 
 			For details see:
 			Documentation/admin-guide/hw-vuln/indirect-target-selection.rst
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -528,4 +528,5 @@
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
@@ -1230,6 +1230,8 @@ static const __initconst struct x86_cpu_
 #define RFDS		BIT(7)
 /* CPU is affected by Indirect Target Selection */
 #define ITS		BIT(8)
+/* CPU is affected by Indirect Target Selection, but guest-host isolation is not affected */
+#define ITS_NATIVE_ONLY	BIT(9)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(INTEL_IVYBRIDGE,		X86_STEPPING_ANY,		SRBDS),
@@ -1250,16 +1252,16 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(INTEL_KABYLAKE,		X86_STEPPINGS(0x0, 0xc),	MMIO | RETBLEED | GDS | SRBDS),
 	VULNBL_INTEL_STEPPINGS(INTEL_KABYLAKE,		X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS | ITS),
 	VULNBL_INTEL_STEPPINGS(INTEL_CANNONLAKE_L,	X86_STEPPING_ANY,		RETBLEED),
-	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_L,		X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
-	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_D,		X86_STEPPING_ANY,		MMIO | GDS | ITS),
-	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_X,		X86_STEPPING_ANY,		MMIO | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_L,		X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_D,		X86_STEPPING_ANY,		MMIO | GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPPINGS(INTEL_ICELAKE_X,		X86_STEPPING_ANY,		MMIO | GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPPINGS(INTEL_COMETLAKE,		X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
 	VULNBL_INTEL_STEPPINGS(INTEL_COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED | ITS),
 	VULNBL_INTEL_STEPPINGS(INTEL_COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS | ITS),
-	VULNBL_INTEL_STEPPINGS(INTEL_TIGERLAKE_L,	X86_STEPPING_ANY,		GDS | ITS),
-	VULNBL_INTEL_STEPPINGS(INTEL_TIGERLAKE,		X86_STEPPING_ANY,		GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(INTEL_TIGERLAKE_L,	X86_STEPPING_ANY,		GDS | ITS | ITS_NATIVE_ONLY),
+	VULNBL_INTEL_STEPPINGS(INTEL_TIGERLAKE,		X86_STEPPING_ANY,		GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPPINGS(INTEL_LAKEFIELD,		X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(INTEL_ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | ITS),
+	VULNBL_INTEL_STEPPINGS(INTEL_ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPPINGS(INTEL_ALDERLAKE,		X86_STEPPING_ANY,		RFDS),
 	VULNBL_INTEL_STEPPINGS(INTEL_ALDERLAKE_L,	X86_STEPPING_ANY,		RFDS),
 	VULNBL_INTEL_STEPPINGS(INTEL_RAPTORLAKE,	X86_STEPPING_ANY,		RFDS),
@@ -1481,8 +1483,11 @@ static void __init cpu_set_bug_bits(stru
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


