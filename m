Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5221C21773D;
	Tue,  8 Jul 2025 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992554; cv=none; b=GiDHso93r1XgtMqkqCqjcou/UTKe6xDNpRWja8PJjUo1Z+WuOD+UjcevHp7pBVTXexaf1fGeb8ouR6Az8L9wx8Q3J6uBKiarXiddjdiGnh9rjNADRkUv0U4KM0NRPgHwNJ4UhDXUUBhEapTZDa64xjSgNl+W94DLlLWxwMbgsz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992554; c=relaxed/simple;
	bh=2TaOWiuCp9lzeZQW4SOg1nDX8Ks+9g8uDiKFQ3Wr6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOg7x/waHWZap259NexFC8vPe16HU6P5FdjW0Hyhkx/o+k+xBbWoYP4s1rSesngwWt9+sM/E8ROhdUQYBYTkZSrOCS9sn7aJF9Qb9LpZmOLrhMZ2Qy9XhRH1DmkRRfew0bn7oJAGxFxeARbFA8S8Bo7kqlgrLzsCv7IWOUUabaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8B2y3f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8B2y3f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A3C4CEED;
	Tue,  8 Jul 2025 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992554;
	bh=2TaOWiuCp9lzeZQW4SOg1nDX8Ks+9g8uDiKFQ3Wr6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8B2y3f+5Wfzq52jP/A9xAjDG5I7yqbKHTOFLO4fblHOHbOY++bB2VIO4Hc+SC5of
	 sxT3fHcMla2lTLnzTDTiKHVMnhdiwm5nuKV8GyUUulm9ugLwwsvIBEieW2NtJ7gYyS
	 AveAMe2G67jWP3Iy3U9S+cu2g9svnuyUtH6OhPsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 130/132] KVM: SVM: Advertise TSA CPUID bits to guests
Date: Tue,  8 Jul 2025 18:24:01 +0200
Message-ID: <20250708162234.318242139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 31272abd5974b38ba312e9cf2ec2f09f9dd7dcba upstream.

Synthesize the TSA CPUID feature bits for guests. Set TSA_{SQ,L1}_NO on
unaffected machines.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c         |    8 +++++++-
 arch/x86/kvm/reverse_cpuid.h |    8 ++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -780,6 +780,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
+		F(VERW_CLEAR) |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 
@@ -790,6 +791,10 @@ void kvm_set_cpu_caps(void)
 		F(PERFMON_V2)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
+		F(TSA_SQ_NO) | F(TSA_L1_NO)
+	);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the
@@ -1296,8 +1301,9 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		entry->ebx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -17,6 +17,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_8000_0007_EDX,
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
+	CPUID_8000_0021_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -61,6 +62,10 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000022 (EAX) */
 #define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
 
+/* CPUID level 0x80000021 (ECX) */
+#define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
+#define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -90,6 +95,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
+	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 };
 
 /*
@@ -129,6 +135,8 @@ static __always_inline u32 __feature_tra
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
+	KVM_X86_TRANSLATE_FEATURE(TSA_SQ_NO);
+	KVM_X86_TRANSLATE_FEATURE(TSA_L1_NO);
 	default:
 		return x86_feature;
 	}


