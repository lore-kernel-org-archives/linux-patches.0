Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681FE424D79;
	Thu, 16 Jul 2026 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211436; cv=none; b=Rt8Kv+0M1i6F1QnDphc95ziSaZQOTtk7hcm2HVMIrx0tKySdSqp2ZFWkXO12jgd+VPnIvkdXpXOJPbb8EnffYM6WtN4utflSULd9dD5dPHDE8bePWETV11c7QCt215lEaq2m8hL6gQpaSU3LsUB+LkWrcGV7rNgrntYqGcgNRIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211436; c=relaxed/simple;
	bh=QSAPNI9jvCqe7qQRwbUY3NrrE4FyZ/fgI7FNitUkI5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIQt/tj0DF/UAsqLk5llEusDGMV8hoLpq85GYWM2zQI1IKrPR7aL25PsNa9U+V+1gtuBbC4dDXMuJssagnw3Wb+jO12DizhJKdHnuj/hd8J7B1ELlzjr1KhWQYmA62DDLUGF6t0dC0iUxPXNkiQHmzDrbw0fS3hscE00OPC1UI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeW7k3Ta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeW7k3Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7181F000E9;
	Thu, 16 Jul 2026 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211435;
	bh=qUEFpyKH3il2/TSbQc4HO7Yp4LNZ/en+WAuS5OJEV64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qeW7k3Ta9vGSIUDSaO8GLlBHVaShuqnnybVtMNfaOBte4ej3U3MbuJntsFnNNsp6U
	 MU8NP7zX2MMavvwB5h2G/sw8Co2DJ0X+8bjGOhWohpj4xD8jo0lARMpr8LNIkzAgfK
	 9DB0Y/K/DGQikatEnDDj0kKnxoe5+nGchU2cKDiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 428/480] KVM: x86: Add dedicated API for getting mask of accelerated x2APIC MSRs
Date: Thu, 16 Jul 2026 15:32:55 +0200
Message-ID: <20260716133054.073248560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1745,7 +1745,7 @@ static inline struct kvm_lapic *to_lapic
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
+static u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 {
 	/* Leave bits '0' for reserved and write-only registers. */
 	u64 valid_reg_mask =
@@ -1781,7 +1781,24 @@ u64 kvm_lapic_readable_reg_mask(struct k
 
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
@@ -150,7 +150,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcp
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
+u64 kvm_x2apic_disable_read_intercept_reg_mask(struct kvm_vcpu *vcpu);
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4080,7 +4080,7 @@ static void vmx_update_msr_bitmap_x2apic
 	 * mode, only the current timer count needs on-demand emulation by KVM.
 	 */
 	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
-		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
+		msr_bitmap[read_idx] = ~kvm_x2apic_disable_read_intercept_reg_mask(vcpu);
 	else
 		msr_bitmap[read_idx] = ~0ull;
 	msr_bitmap[write_idx] = ~0ull;
@@ -4093,7 +4093,6 @@ static void vmx_update_msr_bitmap_x2apic
 				  !(mode & MSR_BITMAP_MODE_X2APIC));
 
 	if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		if (enable_ipiv)


