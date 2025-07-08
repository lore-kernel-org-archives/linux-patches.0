Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CAC2DC34C;
	Tue,  8 Jul 2025 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994201; cv=none; b=Za+AboCNLKvcfe7kbXFH6sAxIku6DOPzsuwmnLAzTU7qF3M+KbcAt9SM0XlfPDUgQlzdEQ+M90pv/rOu3hVg27R8V6KMnHXrdh+d5nntFHU/0+RDZtWa6v4YUEeBTsf+fEcm2WD26QHkdaQiCJxk0Bo70G9WkU/mnnX8VcUunC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994201; c=relaxed/simple;
	bh=9A6Z44vjYawAITmSWqKpWbN4ltzUqG01vBEzET9fgt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHNYC01ZcN/08NS7avowvzeBEXRvfgXpDVzHyS5MbTWNUPlRVPtlc//94JcP2IkvgJTXHvo7Cur2VQJzwCFKXq5X2N1u89SbHe/kI/C7DN8tGTQVagtqYLoclGaTiPHZVT5L1dmfoXw6F3VetdXzUY4OMqAiFzlCmbGQq//1JOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi+93dXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi+93dXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37380C4CEED;
	Tue,  8 Jul 2025 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994200;
	bh=9A6Z44vjYawAITmSWqKpWbN4ltzUqG01vBEzET9fgt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bi+93dXI1IL8W6v1HI1H+lHf3n4Ub5QtHzJvyDiqPf25hwGp7/luDhyqSv1/cDuXw
	 16oVX8hBO1/pt9hgYFgLTxFm08GDJX9DXmJTG8OjLVy02i1kqHX1dVpkVbtGo9CGdQ
	 bim+RHuvQe/IBxW78LPTwzyE7klCP8eTDy4y3Sss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 159/160] KVM: SVM: Advertise TSA CPUID bits to guests
Date: Tue,  8 Jul 2025 18:23:16 +0200
Message-ID: <20250708162235.694118689@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 31272abd5974b38ba312e9cf2ec2f09f9dd7dcba upstream.

Synthesize the TSA CPUID feature bits for guests. Set TSA_{SQ,L1}_NO on
unaffected machines.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c         |    6 ++++++
 arch/x86/kvm/reverse_cpuid.h |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -553,6 +553,12 @@ void kvm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))
 		kvm_cpu_cap_set(X86_FEATURE_SRSO_NO);
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX, F(VERW_CLEAR));
+
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
+		F(TSA_SQ_NO) | F(TSA_L1_NO)
+	);
+
 	/*
 	 * Hide RDTSCP and RDPID if either feature is reported as supported but
 	 * probing MSR_TSC_AUX failed.  This is purely a sanity check and
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -14,6 +14,7 @@
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_2_EDX,
+	CPUID_8000_0021_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -45,6 +46,10 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_BHI_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
 #define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
 
+/* CPUID level 0x80000021 (ECX) */
+#define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
+#define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -71,6 +76,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
+	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 };
 
 /*
@@ -107,6 +113,8 @@ static __always_inline u32 __feature_tra
 	KVM_X86_TRANSLATE_FEATURE(SGX2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
+	KVM_X86_TRANSLATE_FEATURE(TSA_SQ_NO);
+	KVM_X86_TRANSLATE_FEATURE(TSA_L1_NO);
 	default:
 		return x86_feature;
 	}


