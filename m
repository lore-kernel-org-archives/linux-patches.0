Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964888F5B;
	Tue,  8 Jul 2025 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992218; cv=none; b=GGKBbQX5ZIVHr8oIqSYs+AUDs0tr96Wlh9g8/0hiQJJSHb8oBeXfsLhvdqXN1BFK2qFe77NlzKBN87mJy7EZEaux8zy58KGJ9F1uA0vUaez1dNgK5X7OtVpDz82veMuNm9CnK1wWGeFMVB8APrCdU31ML8tWfNod56g4y2pfy7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992218; c=relaxed/simple;
	bh=Ug28S8cYTJlmwJZY274CLuBZI2Obz+7NqWIbcWZ9ikE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WacSNX1Alv39kPJxckPip9xsv9sgIfZ82f1o7rtRymckknXVUHV7gbSqXt4PEUiFSZyWG0JSwAWaG6dY5DAs3mqs0CRh5rSAQKWXDMVhaxf2+RJo5y3dly9Xzt39DOz3oRv8zQRUxIB8wVppxtjMO4dAJUdhz8FBaPNr9sNUfpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BASGgyMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BASGgyMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86FEC4CEED;
	Tue,  8 Jul 2025 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992218;
	bh=Ug28S8cYTJlmwJZY274CLuBZI2Obz+7NqWIbcWZ9ikE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BASGgyMF5RuvTtapXMrEfnwbmo4wLPfNHdowYwAXw/G02hGW/MtdBtW98iQ/vBVG4
	 gJmeoY6q0rFFaIFg5zfkHDnZIQiD5jBfWf8oqxr2Lqa3iNOvrtwm/qFVklURespG5y
	 cfqpa3gjsGQqDWGV9s/70mGrYBok9s8E/h6DcwY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 80/81] KVM: SVM: Advertise TSA CPUID bits to guests
Date: Tue,  8 Jul 2025 18:24:12 +0200
Message-ID: <20250708162227.470987642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 31272abd5974b38ba312e9cf2ec2f09f9dd7dcba upstream.

Synthesize the TSA CPUID feature bits for guests. Set TSA_{SQ,L1}_NO on
unaffected machines.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c         |    9 ++++++++-
 arch/x86/kvm/reverse_cpuid.h |    8 ++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -758,6 +758,12 @@ void kvm_set_cpu_caps(void)
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
@@ -1243,7 +1249,7 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		entry->ebx = entry->edx = 0;
 		/*
 		 * Pass down these bits:
 		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
@@ -1259,6 +1265,7 @@ static inline int __do_cpuid_func(struct
 			entry->eax |= BIT(2);
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
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


