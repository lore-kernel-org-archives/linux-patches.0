Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3236331717E;
	Thu, 16 Jul 2026 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210168; cv=none; b=YGzc/V4dABeDsN0Q7xCHNcN3Ayeki+1h5P94uzYFrv5jT/pLU8BK4BgPXcB+E67Tu+0nqsHhjFWlkGWJmZHMsYqBl36ZzHeuyiDtF+x4dVv01w+QueJ2qbpGdAdnaw4ZD8Vt+y4x2oS876IqYfYes6Z5SeZLfmMwYqpMaolanDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210168; c=relaxed/simple;
	bh=3R00/Qb/q99V0ukiDVMFheOBjuY5KYOPybtS49db7M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db9+t0B9Vdn1UWePMtnke09Q1M5SpsHIVlmPaImSWzJXovLZFBaFccGloTtG28Wt9+ag6bRxEe2ShsJogfrRoA4Bm4gQVrA7DxuHhGYqLUjjAT4ntwELGGb2deA+hPg0nw0/pSSyvYOhXw5gCrCBq7pWfHXfLEA2bvNkAzyj+mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTE5A/z5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTE5A/z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9101F00A3D;
	Thu, 16 Jul 2026 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210166;
	bh=+qrmkZYe7HE3fgdkS1Dje2574oxNYB/3/KaVgODCewY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTE5A/z58M2FHIFDD09arvq+DmG5V2fjtRnfOPANtR7tAoTJZ5gO/2TwIYqgtOcwN
	 K2tynN6JAmLTF1+xCfWUcFl0d1XiX2b4GsttSArvXJAlpdkjT85gTsu0lhJtt2x+bf
	 zgMKK24PaXxcoqeXaOE9JShrlEvKgXy1ns0Y+RBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 463/518] KVM: x86: Add dedicated API for getting mask of accelerated x2APIC MSRs
Date: Thu, 16 Jul 2026 15:32:11 +0200
Message-ID: <20260716133057.974727709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8ba621f335a519b47cb7d3e3f4f15b5101b3a56f upstream.

Add a dedicated local APIC API, kvm_x2apic_disable_intercept_reg_mask(),
to provide the mask of x2APIC registers whose MSRs can and should be passed
through to the guest when x2APIC virtualization is enable, and use it in
lieu of the open-coded equivalent VMX logic.  Providing a common helper
will allow sharing the logic with SVM (x2AVIC), and as a bonus eliminates
the somewhat confusing code where KVM enables interception for MSR_TYPE_RW,
even though only the READ case actually needs to be updated.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://patch.msgid.link/20260514213115.1637082-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c   |   21 +++++++++++++++++++--
 arch/x86/kvm/lapic.h   |    2 +-
 arch/x86/kvm/vmx/vmx.c |    3 +--
 3 files changed, 21 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1732,7 +1732,7 @@ static inline struct kvm_lapic *to_lapic
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
+static u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 {
 	/* Leave bits '0' for reserved and write-only registers. */
 	u64 valid_reg_mask =
@@ -1768,7 +1768,24 @@ u64 kvm_lapic_readable_reg_mask(struct k
 
 	return valid_reg_mask;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_readable_reg_mask);
+
+u64 kvm_x2apic_disable_read_intercept_reg_mask(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)))
+		return 0;
+
+	/*
+	 * TMMCT, a.k.a. the current APIC timer count, reads aren't accelerated
+	 * by hardware (Intel or AMD) as the timer is emulated in software (by
+	 * KVM), i.e. reads from the virtual APIC page would return garbage.
+	 * Intercept RDMSR, as handling the fault-like APIC-access VM-Exit is
+	 * more expensive than handling a RDMSR VM-Exit (the APIC-access exit
+	 * requires slow emulation of the code stream).
+	 */
+	return kvm_lapic_readable_reg_mask(vcpu->arch.apic) &
+	       ~APIC_REG_MASK(APIC_TMCCT);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x2apic_disable_read_intercept_reg_mask);
 
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -157,7 +157,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcp
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
+u64 kvm_x2apic_disable_read_intercept_reg_mask(struct kvm_vcpu *vcpu);
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4159,7 +4159,7 @@ static void vmx_update_msr_bitmap_x2apic
 	 * mode, only the current timer count needs on-demand emulation by KVM.
 	 */
 	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
-		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
+		msr_bitmap[read_idx] = ~kvm_x2apic_disable_read_intercept_reg_mask(vcpu);
 	else
 		msr_bitmap[read_idx] = ~0ull;
 	msr_bitmap[write_idx] = ~0ull;
@@ -4172,7 +4172,6 @@ static void vmx_update_msr_bitmap_x2apic
 				  !(mode & MSR_BITMAP_MODE_X2APIC));
 
 	if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		if (enable_ipiv)


