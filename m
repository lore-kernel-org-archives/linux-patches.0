Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227A46BA0;
	Mon,  4 Mar 2024 21:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589135; cv=none; b=a0sezBYnM7WM9apg8DZedcRJiiW2M6cx6lAfucfhGLdd8+P8to8AJgkTGqRNNU+c609KkO/JOdE3OKhj97GAtTb4NnzqfH1ocpPqfz5nKTmokU/S3q2/5L3wcUg/wk1BKg9DNepXaYlYqUwWdhHBGzSjjYZeefmR8DOdBiuayzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589135; c=relaxed/simple;
	bh=wOmCeOlEEzsaSXXuw+jOKxqV97bFbZlgb3UKhmMnOH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKvYodibtj6oKYFqtrQwAyaIFNXkxz8CHAhY9/xE9P/p0k/NQ4glpQOTgLx4d4b29DJaWHiIK0Tpq59HzJ7ImLxJF5ewWh1H3g3xPt65x1KQarU0LJ+WPnLCbVcFVrgbbHFJKQJBPw3KHFWBuuTvFWQEQByzb2QHXiYqRVe1dWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuqDmgSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuqDmgSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B4C433F1;
	Mon,  4 Mar 2024 21:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589135;
	bh=wOmCeOlEEzsaSXXuw+jOKxqV97bFbZlgb3UKhmMnOH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuqDmgSGGsB/2mmQw0J2eC64OsaPEac7WfbO3aPZcJQGSyUA9CTYQOCMlg9VL888E
	 20ZyInGO6mvKft/NJUKE3DCZgJkfmijD77Ip/C5pUOfYqEuicP4ICSNcdrpVKQbwhU
	 uyLIsXt0lsJjqQAp+KoiWawQI5zrQP+7h0gldhAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.1 209/215] x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key
Date: Mon,  4 Mar 2024 21:24:32 +0000
Message-ID: <20240304211603.625913976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 6613d82e617dd7eb8b0c40b2fe3acea655b1d611 upstream.

The VERW mitigation at exit-to-user is enabled via a static branch
mds_user_clear. This static branch is never toggled after boot, and can
be safely replaced with an ALTERNATIVE() which is convenient to use in
asm.

Switch to ALTERNATIVE() to use the VERW mitigation late in exit-to-user
path. Also remove the now redundant VERW in exc_nmi() and
arch_exit_to_user_mode().

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-4-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/x86/mds.rst            |   36 +++++++++++++++++++++++++----------
 arch/x86/include/asm/entry-common.h  |    1 
 arch/x86/include/asm/nospec-branch.h |   12 -----------
 arch/x86/kernel/cpu/bugs.c           |   15 +++++---------
 arch/x86/kernel/nmi.c                |    3 --
 arch/x86/kvm/vmx/vmx.c               |    2 -
 6 files changed, 33 insertions(+), 36 deletions(-)

--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -95,6 +95,9 @@ The kernel provides a function to invoke
 
     mds_clear_cpu_buffers()
 
+Also macro CLEAR_CPU_BUFFERS can be used in ASM late in exit-to-user path.
+Other than CFLAGS.ZF, this macro doesn't clobber any registers.
+
 The mitigation is invoked on kernel/userspace, hypervisor/guest and C-state
 (idle) transitions.
 
@@ -138,17 +141,30 @@ Mitigation points
 
    When transitioning from kernel to user space the CPU buffers are flushed
    on affected CPUs when the mitigation is not disabled on the kernel
-   command line. The migitation is enabled through the static key
-   mds_user_clear.
+   command line. The mitigation is enabled through the feature flag
+   X86_FEATURE_CLEAR_CPU_BUF.
 
-   The mitigation is invoked in prepare_exit_to_usermode() which covers
-   all but one of the kernel to user space transitions.  The exception
-   is when we return from a Non Maskable Interrupt (NMI), which is
-   handled directly in do_nmi().
-
-   (The reason that NMI is special is that prepare_exit_to_usermode() can
-    enable IRQs.  In NMI context, NMIs are blocked, and we don't want to
-    enable IRQs with NMIs blocked.)
+   The mitigation is invoked just before transitioning to userspace after
+   user registers are restored. This is done to minimize the window in
+   which kernel data could be accessed after VERW e.g. via an NMI after
+   VERW.
+
+   **Corner case not handled**
+   Interrupts returning to kernel don't clear CPUs buffers since the
+   exit-to-user path is expected to do that anyways. But, there could be
+   a case when an NMI is generated in kernel after the exit-to-user path
+   has cleared the buffers. This case is not handled and NMI returning to
+   kernel don't clear CPU buffers because:
+
+   1. It is rare to get an NMI after VERW, but before returning to userspace.
+   2. For an unprivileged user, there is no known way to make that NMI
+      less rare or target it.
+   3. It would take a large number of these precisely-timed NMIs to mount
+      an actual attack.  There's presumably not enough bandwidth.
+   4. The NMI in question occurs after a VERW, i.e. when user state is
+      restored and most interesting data is already scrubbed. Whats left
+      is only the data that NMI touches, and that may or may not be of
+      any interest.
 
 
 2. C-State transition
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -91,7 +91,6 @@ static inline void arch_exit_to_user_mod
 
 static __always_inline void arch_exit_to_user_mode(void)
 {
-	mds_user_clear_cpu_buffers();
 	amd_clear_divider();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -381,7 +381,6 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-DECLARE_STATIC_KEY_FALSE(mds_user_clear);
 DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
@@ -416,17 +415,6 @@ static __always_inline void mds_clear_cp
 }
 
 /**
- * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
- *
- * Clear CPU buffers if the corresponding static key is enabled
- */
-static __always_inline void mds_user_clear_cpu_buffers(void)
-{
-	if (static_branch_likely(&mds_user_clear))
-		mds_clear_cpu_buffers();
-}
-
-/**
  * mds_idle_clear_cpu_buffers - Mitigation for MDS vulnerability
  *
  * Clear CPU buffers if the corresponding static key is enabled
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -110,9 +110,6 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_i
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-/* Control MDS CPU buffer clear before returning to user space */
-DEFINE_STATIC_KEY_FALSE(mds_user_clear);
-EXPORT_SYMBOL_GPL(mds_user_clear);
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
 DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
@@ -251,7 +248,7 @@ static void __init mds_select_mitigation
 		if (!boot_cpu_has(X86_FEATURE_MD_CLEAR))
 			mds_mitigation = MDS_MITIGATION_VMWERV;
 
-		static_branch_enable(&mds_user_clear);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 
 		if (!boot_cpu_has(X86_BUG_MSBDS_ONLY) &&
 		    (mds_nosmt || cpu_mitigations_auto_nosmt()))
@@ -355,7 +352,7 @@ static void __init taa_select_mitigation
 	 * For guests that can't determine whether the correct microcode is
 	 * present on host, enable the mitigation for UCODE_NEEDED as well.
 	 */
-	static_branch_enable(&mds_user_clear);
+	setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 
 	if (taa_nosmt || cpu_mitigations_auto_nosmt())
 		cpu_smt_disable(false);
@@ -423,7 +420,7 @@ static void __init mmio_select_mitigatio
 	 */
 	if (boot_cpu_has_bug(X86_BUG_MDS) || (boot_cpu_has_bug(X86_BUG_TAA) &&
 					      boot_cpu_has(X86_FEATURE_RTM)))
-		static_branch_enable(&mds_user_clear);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 	else
 		static_branch_enable(&mmio_stale_data_clear);
 
@@ -483,12 +480,12 @@ static void __init md_clear_update_mitig
 	if (cpu_mitigations_off())
 		return;
 
-	if (!static_key_enabled(&mds_user_clear))
+	if (!boot_cpu_has(X86_FEATURE_CLEAR_CPU_BUF))
 		goto out;
 
 	/*
-	 * mds_user_clear is now enabled. Update MDS, TAA and MMIO Stale Data
-	 * mitigation, if necessary.
+	 * X86_FEATURE_CLEAR_CPU_BUF is now enabled. Update MDS, TAA and MMIO
+	 * Stale Data mitigation, if necessary.
 	 */
 	if (mds_mitigation == MDS_MITIGATION_OFF &&
 	    boot_cpu_has_bug(X86_BUG_MDS)) {
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -522,9 +522,6 @@ nmi_restart:
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
 		goto nmi_restart;
-
-	if (user_mode(regs))
-		mds_user_clear_cpu_buffers();
 }
 
 #if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7123,7 +7123,7 @@ static noinstr void vmx_vcpu_enter_exit(
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mds_user_clear))
+	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
 		mds_clear_cpu_buffers();
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))


