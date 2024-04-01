Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A473F8F4;
	Mon,  1 Apr 2024 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987844; cv=none; b=bEDuqh1GErsJqcf99BzZAiMmCTBqAhQTizK+5T7UL/jPp9i0/VBjCqpin7sLMVRD6afYCKFSTt2xnSWIGmjkgzvOqbhVDwoqeBeQCEsCrjyEXn5DsfCEZ2OQ9uok8y3ezsBYFt6ZGjkv1hAQ/0hbQaqWcj+S2YMtD3bTFL1azaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987844; c=relaxed/simple;
	bh=1W/oYUkierdNgqWUx6LMDEOPeB1387FxhfHmyfCxLnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIEC7F4czu1QSay50I/Abe5qFiNNJkuHWA+QwOmmxZRYJl/riHgQEsQ7RfMhw1xdGtwG6lpHFOhfjRFzMe5cYQd1Kfy/DO3fpSG9PnySxENvid0BlXs/JeqSi6VhCOgBYyufGBs886qJf8/IzyovPS8fdMr2+ALba/wyJl3jzXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGzrhLMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGzrhLMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5705C433F1;
	Mon,  1 Apr 2024 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987844;
	bh=1W/oYUkierdNgqWUx6LMDEOPeB1387FxhfHmyfCxLnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGzrhLMwlhvUpmCnZWp4ka27NNks5WDXglSRMiarDThXm4zJgmoJ2kQhwceHIn+9v
	 MZnXpvpaNuSz8HNSWrPNNjH8ageLvlNkzdGckUDVk8Z6p7Fhw2Fx8e1ift29ZtrAYq
	 vZvc9Xqajy2X0DLGcM4LNjyUNakzhN+a5o1Eb1EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 001/432] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
Date: Mon,  1 Apr 2024 17:39:48 +0200
Message-ID: <20240401152553.173474587@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit eefe5e6682099445f77f2d97d4c525f9ac9d9b07 upstream.

The low five bits {INTEL_PSFD, IPRED_CTRL, RRSBA_CTRL, DDPD_U, BHI_CTRL}
advertise the availability of specific bits in IA32_SPEC_CTRL. Since KVM
dynamically determines the legal IA32_SPEC_CTRL bits for the underlying
hardware, the hard work has already been done. Just let userspace know
that a guest can use these IA32_SPEC_CTRL bits.

The sixth bit (MCDT_NO) states that the processor does not exhibit MXCSR
Configuration Dependent Timing (MCDT) behavior. This is an inherent
property of the physical processor that is inherited by the virtual
CPU. Pass that information on to userspace.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20231024001636.890236-1-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c         |   21 ++++++++++++++++++---
 arch/x86/kvm/reverse_cpuid.h |   12 ++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -679,6 +679,11 @@ void kvm_set_cpu_caps(void)
 		F(AMX_COMPLEX)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
+		F(BHI_CTRL) | F(MCDT_NO)
+	);
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
@@ -960,13 +965,13 @@ static inline int __do_cpuid_func(struct
 		break;
 	/* function 7 has additional index. */
 	case 7:
-		entry->eax = min(entry->eax, 1u);
+		max_idx = entry->eax = min(entry->eax, 2u);
 		cpuid_entry_override(entry, CPUID_7_0_EBX);
 		cpuid_entry_override(entry, CPUID_7_ECX);
 		cpuid_entry_override(entry, CPUID_7_EDX);
 
-		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
-		if (entry->eax == 1) {
+		/* KVM only supports up to 0x7.2, capped above via min(). */
+		if (max_idx >= 1) {
 			entry = do_host_cpuid(array, function, 1);
 			if (!entry)
 				goto out;
@@ -976,6 +981,16 @@ static inline int __do_cpuid_func(struct
 			entry->ebx = 0;
 			entry->ecx = 0;
 		}
+		if (max_idx >= 2) {
+			entry = do_host_cpuid(array, function, 2);
+			if (!entry)
+				goto out;
+
+			cpuid_entry_override(entry, CPUID_7_2_EDX);
+			entry->ecx = 0;
+			entry->ebx = 0;
+			entry->eax = 0;
+		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		union cpuid10_eax eax;
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -16,6 +16,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
 	CPUID_8000_0022_EAX,
+	CPUID_7_2_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -46,6 +47,14 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
+#define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
+#define X86_FEATURE_IPRED_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 1)
+#define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+#define X86_FEATURE_DDPD_U		KVM_X86_FEATURE(CPUID_7_2_EDX, 3)
+#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
+#define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -80,6 +89,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
+	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 };
 
 /*
@@ -116,6 +126,8 @@ static __always_inline u32 __feature_tra
 		return KVM_X86_FEATURE_CONSTANT_TSC;
 	else if (x86_feature == X86_FEATURE_PERFMON_V2)
 		return KVM_X86_FEATURE_PERFMON_V2;
+	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
+		return KVM_X86_FEATURE_RRSBA_CTRL;
 
 	return x86_feature;
 }


