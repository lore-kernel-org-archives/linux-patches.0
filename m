Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A280F7BB1F;
	Mon,  8 Apr 2024 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581292; cv=none; b=nU6m5GvyoQLabHYSFvCxtUHQ4tr7ywK4c8vP8r2Vn679lQzmcxBgnMuP6yhSV3Se1E2mjkeNwSkto5orWuxnGTPy7cETBl7CmSzOqhBvDan1rxN4hRB2LERMl0lst0Dflz+jLyS1kqL0+yL9Ys4ISnEGNr0idzzh3Qmj4rf4qHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581292; c=relaxed/simple;
	bh=K71eucy/Xo4fYgXKzCeOeQu2Fgvr66YBl/7534jttIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwv+dAdbzyZQW3vSxEMdZ5XmMIgP+5nepIx3lssKU8WYlFrBN+99sGx8OWzx/SNIWkYsQCv7XiWzIZX+PfRD0jvGViDGaqVor5oySIy6f1RWEj5bdkrrBBFqNP0SysDzq2SYOfLTe0tjpmMqDKhr47vAZrmHJLhAQMABNKj34Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlOQKtjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlOQKtjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1754C43390;
	Mon,  8 Apr 2024 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581291;
	bh=K71eucy/Xo4fYgXKzCeOeQu2Fgvr66YBl/7534jttIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlOQKtjMkaI+4sJksBmeniyyHwABwqzptmrBs/E0FFc5Z2G9BIFq0uPBXoggPgtH2
	 bgFoBWUpX0Ht/uAV0hicDpZEIWuS1VKIDyqgb8n/fyPpx9MBBi8QVMRTSK04onXqjX
	 J7zHAcYOQuUIIQci2Hh4cbf7CvuYzRRITOzttsjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 005/690] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
Date: Mon,  8 Apr 2024 14:47:51 +0200
Message-ID: <20240408125359.743894157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,6 +469,11 @@ void kvm_set_cpu_caps(void)
 		F(AVX_VNNI) | F(AVX512_BF16)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
+		F(BHI_CTRL) | F(MCDT_NO)
+	);
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
 	);
@@ -710,13 +715,13 @@ static inline int __do_cpuid_func(struct
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
@@ -726,6 +731,16 @@ static inline int __do_cpuid_func(struct
 			entry->ecx = 0;
 			entry->edx = 0;
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
 		struct x86_pmu_capability cap;
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_7_2_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -36,6 +37,14 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
+#define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
+#define X86_FEATURE_IPRED_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 1)
+#define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+#define X86_FEATURE_DDPD_U		KVM_X86_FEATURE(CPUID_7_2_EDX, 3)
+#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
+#define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -61,6 +70,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
+	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 };
 
 /*
@@ -91,6 +101,8 @@ static __always_inline u32 __feature_tra
 		return KVM_X86_FEATURE_SGX1;
 	else if (x86_feature == X86_FEATURE_SGX2)
 		return KVM_X86_FEATURE_SGX2;
+	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
+		return KVM_X86_FEATURE_RRSBA_CTRL;
 
 	return x86_feature;
 }


