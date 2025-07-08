Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA08202F70;
	Tue,  8 Jul 2025 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993757; cv=none; b=ayBsK09Avn4jbRkRj+N9bO0hVvMtD0UhWICqRjYZGmJLDrC07uJWo+hrJpKyV8cqyaE1F9jPqB7JuggAjxIWiaZELajlxYt8Ps1EKXkdjFDfHu2luUftNOFtF0GDv+Dxiuk0ojef/v0sqsRVFvnFmjGUnq6Kxkps2bWOQFs2V4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993757; c=relaxed/simple;
	bh=fpUbec1eP3B91S47SkGiVLKrT4SwRBMjM+UfsLakBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvwpcthntSqB68/lIOyo+i/yqcBYfcpq3ETh0EYjxQwGtewTt3RmEGgnd/foOdCHK5p3rj3h6QvDDFZbIV59HgLUjDZj6YSzWloizrTa510QGELZr9kE2pdyx4J8j9DiXcbRjQGE1gi7DLTad75Jr2hHe9uIpxyOZ1BDv8VjaE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTx14Os3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTx14Os3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA59DC4CEED;
	Tue,  8 Jul 2025 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993757;
	bh=fpUbec1eP3B91S47SkGiVLKrT4SwRBMjM+UfsLakBk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTx14Os3sU81z/yDjzh0Ge9eCvKiiogDf+BTNMLkQ1NA1587i8qpDwFPiNFc4KeJ7
	 iqfOY8RZ5xD67Y0D6Uz42GHpaJo4muYFUvI3mQq5GCHX+U73+s5nCr1AbCgB3xxjKF
	 RiX3oJZiEdUo5SUJxLq8HlEuOIfIA/737WjPvEkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.15 176/178] KVM: SVM: Advertise TSA CPUID bits to guests
Date: Tue,  8 Jul 2025 18:23:33 +0200
Message-ID: <20250708162241.039966573@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 31272abd5974b38ba312e9cf2ec2f09f9dd7dcba upstream.

Synthesize the TSA CPUID feature bits for guests. Set TSA_{SQ,L1}_NO on
unaffected machines.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |   10 +++++++++-
 arch/x86/kvm/reverse_cpuid.h    |    7 +++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -756,6 +756,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
 	CPUID_24_0_EBX,
+	CPUID_8000_0021_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1177,6 +1177,8 @@ void kvm_set_cpu_caps(void)
 		 */
 		SYNTHESIZED_F(LFENCE_RDTSC),
 		/* SmmPgCfgLock */
+		/* 4: Resv */
+		SYNTHESIZED_F(VERW_CLEAR),
 		F(NULL_SEL_CLR_BASE),
 		/* UpperAddressIgnore */
 		F(AUTOIBRS),
@@ -1190,6 +1192,11 @@ void kvm_set_cpu_caps(void)
 		F(SRSO_USER_KERNEL_NO),
 	);
 
+	kvm_cpu_cap_init(CPUID_8000_0021_ECX,
+		SYNTHESIZED_F(TSA_SQ_NO),
+		SYNTHESIZED_F(TSA_L1_NO),
+	);
+
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
 		F(PERFMON_V2),
 	);
@@ -1759,8 +1766,9 @@ static inline int __do_cpuid_func(struct
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
@@ -52,6 +52,10 @@
 /* CPUID level 0x80000022 (EAX) */
 #define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
 
+/* CPUID level 0x80000021 (ECX) */
+#define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
+#define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -82,6 +86,7 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
+	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 };
 
 /*
@@ -121,6 +126,8 @@ static __always_inline u32 __feature_tra
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
+	KVM_X86_TRANSLATE_FEATURE(TSA_SQ_NO);
+	KVM_X86_TRANSLATE_FEATURE(TSA_L1_NO);
 	default:
 		return x86_feature;
 	}


