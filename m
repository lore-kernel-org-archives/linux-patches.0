Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D22EC0A8;
	Wed, 17 Sep 2025 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114016; cv=none; b=MnDzzvfsbKduTP693rgW1eNb7FtPJyxVHL78hZTR4tohtRbX1vp01gRDjdXlylhtzAjRX652oyJ4hw9RoNcT5FGuD7s93yJ7oME5HB8mEo2iEotU8WhSGEWCwMzDEvI1TDVTIx4DtAQKAcUbyzzVODq4WiWerYMSdt8eI9vwZIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114016; c=relaxed/simple;
	bh=TRAHE91HxiIBCI5FjFupYv6QL7ooMtT1BDVvQJxuY8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhQVcdmUGvZCjmgFdBUdmJxJGUdXE8cul+RxMdIU/3pwksy7hBGl5qbjiD8y882qe1GhyTo3kfn+dwXMRqvCxOMVNbqCWD2PDQgnscIVI/iPEfZL6rkjgj/mp8w6mRhEzFBuupDmFpusByD3YBG1YnsqPmcD80LHQb3W1EqHU8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0FTeAdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0FTeAdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8523C4CEF0;
	Wed, 17 Sep 2025 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114014;
	bh=TRAHE91HxiIBCI5FjFupYv6QL7ooMtT1BDVvQJxuY8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0FTeAdGN0aVlEThc+ezE15xw2V7wLojaoYKg6+h2LglgybuM0d9Z70uXpdulDlfk
	 HMAhP1mFSoKLRaxunBK9Acv8gFfovEjYLSaOVBvQRDxU/NYkL5BkK7+ad7vdj3U+Q2
	 ZOS7B5K/1aGlmPzkUEQ0n03w0T6omt6/0yGroMJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 6.1 20/78] KVM: x86: Move open-coded CPUID leaf 0x80000021 EAX bit propagation code
Date: Wed, 17 Sep 2025 14:34:41 +0200
Message-ID: <20250917123330.057087896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

Commit c35ac8c4bf600ee23bacb20f863aa7830efb23fb upstream

Move code from __do_cpuid_func() to kvm_set_cpu_caps() in preparation for adding
the features in their native leaf.

Also drop the bit description comments as it will be more self-describing once
the individual features are added.

Whilst there, switch to using the more efficient cpu_feature_enabled() instead
of static_cpu_has().

Note, LFENCE_RDTSC and "NULL selector clears base" are currently synthetic,
Linux-defined feature flags as Linux tracking of the features predates AMD's
definition.  Keep the manual propagation of the flags from their synthetic
counterparts until the kernel fully converts to AMD's definition, otherwise KVM
would stop synthesizing the flags as intended.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230124163319.2277355-3-kim.phillips@amd.com

Move setting of VERW_CLEAR bit to the new
kvm_cpu_cap_mask(CPUID_8000_0021_EAX, ...) site.

Cc: <stable@vger.kernel.org> # 6.1.y
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -749,6 +749,18 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+		BIT(0) /* NO_NESTED_DATA_BP */ |
+		BIT(2) /* LFENCE Always serializing */ | 0 /* SmmPgCfgLock */ |
+		BIT(5) /* The memory form of VERW mitigates TSA */ |
+		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
+	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
+	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -758,8 +770,6 @@ void kvm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))
 		kvm_cpu_cap_set(X86_FEATURE_SRSO_NO);
 
-	kvm_cpu_cap_mask(CPUID_8000_0021_EAX, F(VERW_CLEAR));
-
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
 		F(TSA_SQ_NO) | F(TSA_L1_NO)
 	);
@@ -1249,23 +1259,8 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->edx = 0;
-		/*
-		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
-		 *    EAX      2      LAS, LFENCE always serializing
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
-		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
+		entry->ebx = entry->ecx = entry->edx = 0;
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:


