Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB299824B3;
	Mon, 15 Apr 2024 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191858; cv=none; b=jUh7PxfU0GRoFeinQ+t1ehUJr67oCKGj//KtngwCz7g+MGHd8f/vWPnhAIVG5QsLI8ruOB2AIpP3CkUxFQsmRcKmej5eM/vthd6Xb5qFpNvSlbcyFqjtC58U0w7HFvKmaqsAUoL0eSETuUJSmYdcPDjah8QIIciuCqS1Hq1tw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191858; c=relaxed/simple;
	bh=ZauY8dF6RYaXiFHRPKnDTaNY2LkEk6rJ9N0AFNvlB/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5d68WYv+uUBNwVYvcxNw01h9DZMT0Q1zXhZOsRu/kTzvWheutHwKj0s4n+LmvtGn+nNwsrihqN/r3UwiR7Ew8JtrYfdMti3AqLrYb2UdG7VsR+1kaWcaf1Rv2047COoB+UnLxSwrCFb7z3gH9vI4+JGP1pZYlGAeAREPwaadrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z80QKmys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z80QKmys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D32C113CC;
	Mon, 15 Apr 2024 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191858;
	bh=ZauY8dF6RYaXiFHRPKnDTaNY2LkEk6rJ9N0AFNvlB/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z80QKmysYQiOFmhxviawjHHY7rlmkvC9XppZQrXe1FRoJ24lYqH1Zpc4Pmf21gVT+
	 V9rLAxvN+yhrH5WW1a/9nBiYtCt9r/uIcOaUrAzlWygW1leupgW0/KHHuWc2AsWmIp
	 HqGYPdRaaHCtjXs7keLizo/jlYnq139MfyOyfQro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 109/122] x86/bugs: Cache the value of MSR_IA32_ARCH_CAPABILITIES
Date: Mon, 15 Apr 2024 16:21:14 +0200
Message-ID: <20240415141956.643592447@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit cb2db5bb04d7f778fbc1a1ea2507aab436f1bff3 upstream.

There's no need to keep reading MSR_IA32_ARCH_CAPABILITIES over and
over.  It's even read in the BHI sysfs function which is a big no-no.
Just read it once and cache it.

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/9592a18a814368e75f8f4b9d74d3883aa4fd1eaf.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -61,6 +61,8 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_current)
 u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
 EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
+static u64 __ro_after_init ia32_cap;
+
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
 void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
@@ -144,6 +146,8 @@ void __init cpu_select_mitigations(void)
 		x86_spec_ctrl_base &= ~SPEC_CTRL_MITIGATIONS_MASK;
 	}
 
+	ia32_cap = x86_read_arch_cap_msr();
+
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
@@ -301,8 +305,6 @@ static const char * const taa_strings[]
 
 static void __init taa_select_mitigation(void)
 {
-	u64 ia32_cap;
-
 	if (!boot_cpu_has_bug(X86_BUG_TAA)) {
 		taa_mitigation = TAA_MITIGATION_OFF;
 		return;
@@ -341,7 +343,6 @@ static void __init taa_select_mitigation
 	 * On MDS_NO=1 CPUs if ARCH_CAP_TSX_CTRL_MSR is not set, microcode
 	 * update is required.
 	 */
-	ia32_cap = x86_read_arch_cap_msr();
 	if ( (ia32_cap & ARCH_CAP_MDS_NO) &&
 	    !(ia32_cap & ARCH_CAP_TSX_CTRL_MSR))
 		taa_mitigation = TAA_MITIGATION_UCODE_NEEDED;
@@ -401,8 +402,6 @@ static const char * const mmio_strings[]
 
 static void __init mmio_select_mitigation(void)
 {
-	u64 ia32_cap;
-
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
 	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
 	     cpu_mitigations_off()) {
@@ -413,8 +412,6 @@ static void __init mmio_select_mitigatio
 	if (mmio_mitigation == MMIO_MITIGATION_OFF)
 		return;
 
-	ia32_cap = x86_read_arch_cap_msr();
-
 	/*
 	 * Enable CPU buffer clear mitigation for host and VMM, if also affected
 	 * by MDS or TAA. Otherwise, enable mitigation for VMM only.
@@ -508,7 +505,7 @@ static void __init rfds_select_mitigatio
 	if (rfds_mitigation == RFDS_MITIGATION_OFF)
 		return;
 
-	if (x86_read_arch_cap_msr() & ARCH_CAP_RFDS_CLEAR)
+	if (ia32_cap & ARCH_CAP_RFDS_CLEAR)
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 	else
 		rfds_mitigation = RFDS_MITIGATION_UCODE_NEEDED;
@@ -659,8 +656,6 @@ void update_srbds_msr(void)
 
 static void __init srbds_select_mitigation(void)
 {
-	u64 ia32_cap;
-
 	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
 		return;
 
@@ -669,7 +664,6 @@ static void __init srbds_select_mitigati
 	 * are only exposed to SRBDS when TSX is enabled or when CPU is affected
 	 * by Processor MMIO Stale Data vulnerability.
 	 */
-	ia32_cap = x86_read_arch_cap_msr();
 	if ((ia32_cap & ARCH_CAP_MDS_NO) && !boot_cpu_has(X86_FEATURE_RTM) &&
 	    !boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		srbds_mitigation = SRBDS_MITIGATION_TSX_OFF;
@@ -813,7 +807,7 @@ static void __init gds_select_mitigation
 	/* Will verify below that mitigation _can_ be disabled */
 
 	/* No microcode */
-	if (!(x86_read_arch_cap_msr() & ARCH_CAP_GDS_CTRL)) {
+	if (!(ia32_cap & ARCH_CAP_GDS_CTRL)) {
 		if (gds_mitigation == GDS_MITIGATION_FORCE) {
 			/*
 			 * This only needs to be done on the boot CPU so do it
@@ -1907,8 +1901,6 @@ static void update_indir_branch_cond(voi
 /* Update the static key controlling the MDS CPU buffer clear in idle */
 static void update_mds_branch_idle(void)
 {
-	u64 ia32_cap = x86_read_arch_cap_msr();
-
 	/*
 	 * Enable the idle clearing if SMT is active on CPUs which are
 	 * affected only by MSBDS and not any other MDS variant.
@@ -2817,7 +2809,7 @@ static const char *spectre_bhi_state(voi
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
 		return "; BHI: SW loop, KVM: SW loop";
 	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
-		 !(x86_read_arch_cap_msr() & ARCH_CAP_RRSBA))
+		 !(ia32_cap & ARCH_CAP_RRSBA))
 		return "; BHI: Retpoline";
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
 		return "; BHI: Syscall hardening, KVM: SW loop";


