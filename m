Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB092EA172;
	Tue, 15 Jul 2025 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587959; cv=none; b=P7BdNti6w4i69rLnllFs42JMqW9ZUa2/J/qClGKBuGRteSSdLxGdx0+B+it+Fxe3/qiWEx0MmC0RQt4RwKwIqurGwn3PnC+PZOagdogLNwodhgYujhVJGU4A0P3Ek60iLOGWrIJKi20tNw122WkEjsVWX8KvsJq2FAhzg+LyvUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587959; c=relaxed/simple;
	bh=xvA1fXLdTqMMG0RZg7oJlTyy3mcKg0awW2eX1KsRYNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njIyUfoT/XUaU2zBTVo4OKnQfZ+4G0ev76CvPHgJwAqJehJf37hf2rGdktyaBobswhD2u6TDcDtZ9gfotF5JdgFMSRCEbtnshAYmWE0VeuZdRQSPhlI9tn/JGpMea4a1Ly8cBlrOppVtUslqoGetFM6ac7Q/QPNXlDQt8a0NI2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJRPSRB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJRPSRB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8702FC4CEF1;
	Tue, 15 Jul 2025 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587957;
	bh=xvA1fXLdTqMMG0RZg7oJlTyy3mcKg0awW2eX1KsRYNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJRPSRB8+fZeTG4wZ/avDtsiBQDDVMl6lt5nzoR7Tr+J00jKKPz6AmjWpfpYRC+IR
	 CVGOpGv7/Ol2gJY3ybrT4NGZnRDdCWH7Eel1Aphin7+jqrKg4N8UYKM3rAQNnE5yn6
	 Kns9UxJ5Et8J3NrG7L9Dm6+Ic66lNkXLRwygycBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 207/208] KVM: SVM: Advertise TSA CPUID bits to guests
Date: Tue, 15 Jul 2025 15:15:16 +0200
Message-ID: <20250715130819.219825685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@kernel.org>

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 31272abd5974b38ba312e9cf2ec2f09f9dd7dcba upstream.

Synthesize the TSA CPUID feature bits for guests. Set TSA_{SQ,L1}_NO on
unaffected machines.

  [ backporting notes: 5.10 doesn't have the KVM-only CPUID leafs so
    allocate a separate capability leaf for CPUID_8000_0021_ECX to avoid
    backporting the world and more. ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h        |    5 +++--
 arch/x86/include/asm/cpufeatures.h       |    8 ++++----
 arch/x86/include/asm/disabled-features.h |    2 +-
 arch/x86/include/asm/required-features.h |    2 +-
 arch/x86/kernel/cpu/scattered.c          |    2 --
 arch/x86/kvm/cpuid.c                     |   16 ++++++++++++++--
 arch/x86/kvm/cpuid.h                     |    1 +
 7 files changed, 24 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -34,6 +34,7 @@ enum cpuid_leafs
 	CPUID_8000_001F_EAX,
 	CPUID_8000_0021_EAX,
 	CPUID_LNX_5,
+	CPUID_8000_0021_ECX,
 	NR_CPUID_WORDS,
 };
 
@@ -97,7 +98,7 @@ extern const char * const x86_bug_flags[
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 20, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 21, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 22))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 23))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -123,7 +124,7 @@ extern const char * const x86_bug_flags[
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 20, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 21, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 22))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 23))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			22	   /* N 32-bit words worth of info */
+#define NCAPINTS			23	   /* N 32-bit words worth of info */
 #define NBUGINTS			2	   /* N 32-bit bug flags */
 
 /*
@@ -412,9 +412,9 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* "" MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* "" CPU is not affected by SRSO */
 
-#define X86_FEATURE_TSA_SQ_NO          (21*32+11) /* "" AMD CPU not vulnerable to TSA-SQ */
-#define X86_FEATURE_TSA_L1_NO          (21*32+12) /* "" AMD CPU not vulnerable to TSA-L1 */
-#define X86_FEATURE_CLEAR_CPU_BUF_VM   (21*32+13) /* "" Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_TSA_SQ_NO          (22*32+11) /* "" AMD CPU not vulnerable to TSA-SQ */
+#define X86_FEATURE_TSA_L1_NO          (22*32+12) /* "" AMD CPU not vulnerable to TSA-L1 */
+#define X86_FEATURE_CLEAR_CPU_BUF_VM   (22*32+13) /* "" Clear CPU buffers using VERW before VMRUN */
 
 /*
  * BUG word(s)
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -104,6 +104,6 @@
 #define DISABLED_MASK19	0
 #define DISABLED_MASK20	0
 #define DISABLED_MASK21	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 22)
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 23)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -104,6 +104,6 @@
 #define REQUIRED_MASK19	0
 #define REQUIRED_MASK20	0
 #define REQUIRED_MASK21	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 22)
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 23)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -42,8 +42,6 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
-	{ X86_FEATURE_TSA_SQ_NO,	CPUID_ECX,  1, 0x80000021, 0 },
-	{ X86_FEATURE_TSA_L1_NO,	CPUID_ECX,  2, 0x80000021, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -500,6 +500,15 @@ void kvm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
 
+	if (cpu_feature_enabled(X86_FEATURE_VERW_CLEAR))
+		kvm_cpu_cap_set(X86_FEATURE_VERW_CLEAR);
+
+	if (cpu_feature_enabled(X86_FEATURE_TSA_SQ_NO))
+		kvm_cpu_cap_set(X86_FEATURE_TSA_SQ_NO);
+
+	if (cpu_feature_enabled(X86_FEATURE_TSA_L1_NO))
+		kvm_cpu_cap_set(X86_FEATURE_TSA_L1_NO);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -879,18 +888,21 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		entry->ebx = entry->edx = 0;
 		/*
 		 * Pass down these bits:
 		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
 		 *    EAX      2      LAS, LFENCE always serializing
+		 *    EAX      5      VERW_CLEAR, mitigate TSA
 		 *    EAX      6      NSCB, Null selector clear base
 		 *
 		 * Other defined bits are for MSRs that KVM does not expose:
 		 *   EAX      3      SPCL, SMM page configuration lock
 		 *   EAX      13     PCMSR, Prefetch control MSR
 		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+		entry->eax &= BIT(0) | BIT(2) | BIT(5) | BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -64,6 +64,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
+	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 };
 
 /*


