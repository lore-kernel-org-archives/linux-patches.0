Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D04AEE0;
	Mon,  1 Apr 2024 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990641; cv=none; b=Y8f2mUWDGZCTbpesxS4O4a46Fopa+uifbe/FeN8B1fO2VqMFySbyifNnqQaYvjkC6QC2o3fGTouyX11z7eAUkv9VG3OTwuLckErPOUqaU6qXEvwNRmUhYbbtuVoXDkmUNRV6JsA19Eg7/ej64kZzIHjP3qcNG6EOA6hajkfpvo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990641; c=relaxed/simple;
	bh=MaQkGzn/vlMMKsaQBIfPjq6rFbT/1Hv6BI1uPZ1sk/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQLKAKKGIOWvz1vrGlwhEafp5UVT6kqw7RI6PY0hPxQCOARSjxgVUgQkqNb/LXvdTkDUNJFk69IUatwjNjqqOX/2HFP+TKU3UOE6kx3sDPrvYXaJhQgrrMjjd8N6RxNuFLCNmUMstdvfrqXkRrnpknkZyYSZBlRAx31K3xuDJfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CngWA4CG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CngWA4CG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5306DC433C7;
	Mon,  1 Apr 2024 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990640;
	bh=MaQkGzn/vlMMKsaQBIfPjq6rFbT/1Hv6BI1uPZ1sk/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CngWA4CG5nVGOLKHIyV83uAQ6IzGfwjnddY1tY0xcUW41Mto2oMR99SB3Swa884gQ
	 qSMBIQNvY0w9ozolMz5hRiYuIyZ2FcGt+jmn6Fp7RBbYmoWJs3EhA1l29x2aR+WiWV
	 OSfQ8XtlyexFzJ0fL+VxK6p+Q+HzWXEQBi4l/65M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 004/272] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
Date: Mon,  1 Apr 2024 17:43:14 +0200
Message-ID: <20240401152530.398243514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -652,6 +652,11 @@ void kvm_set_cpu_caps(void)
 		F(AVX_VNNI) | F(AVX512_BF16)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
+		F(BHI_CTRL) | F(MCDT_NO)
+	);
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
@@ -902,13 +907,13 @@ static inline int __do_cpuid_func(struct
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
@@ -918,6 +923,16 @@ static inline int __do_cpuid_func(struct
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
 		union cpuid10_eax eax;
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


