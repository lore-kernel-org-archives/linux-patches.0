Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3040322301;
	Thu, 16 Jul 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210144; cv=none; b=rkwXddjmpDEDjOFju5Pj+QicRYjcAp341mnJXsPLSA8+zzpi0cA2AAVQl+/4x+f3hlU7rT5RoV6Z2h1Hnfq4f27o6wr5/Dwh06TRMMFp/xpUvEfdyamE4lFVxVLKr7vBbJW+WzjxCeq1IHYjvvSUrc55ZcJ5CeG/EWyvplEHofI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210144; c=relaxed/simple;
	bh=ddqzTer13eNifYtjcMsAzmoBKzQDKlOaAVPyx03Cftk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYQrT9SLaMOR3S6bGhaPuoEZPezegXurcsiz1gXRUujkyehGRHnTDT8MfAJ6xLj/qFxC5wMC8hZVL0j+5D1xQYPUl3yG1wOTLd370mBw3SfBh/wvkoFECVaI6EqfkA/xfNi5iTVkDsOrw4aZasw/FFo8ezlWe9/dORXUDUI0bfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNunUIym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNunUIym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9555B1F000E9;
	Thu, 16 Jul 2026 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210143;
	bh=HR1wvLDZraZZTvcVjWhloypwuPhPQ42z4pqH8Y0a8Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNunUIymiDqvU22JFHRgx3xxPXs5i0cz6PVWPy1CMmG53ID8dYX6W6wC6V3/xtg5O
	 ScT3ZTCf9H6E2vYLIAsREvObZnyL+wZklDEcBBsGXaZ1qMkB5rB+hmHWvZrhqaN0Aa
	 X/0NDo3LJxXuqgD6rDxAKUxlqlgQOm+1maSlNIX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 455/518] KVM: SVM: Disable x2AVIC RDMSR interception for MSRs KVM actually supports
Date: Thu, 16 Jul 2026 15:32:03 +0200
Message-ID: <20260716133057.800219080@linuxfoundation.org>
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

commit 7f4b7092d9a173a4271e28c0ed1fc235994e309b upstream.

When toggling x2AVIC on/off, use KVM's curated mask of x2APIC MSRs that
can/should be passed through to the guest (or not) when 2AVIC is enabled.
Using the effective list provided by the local APIC emulation fixes
multiple (classes of) bugs, as the existing hand-coded list of MSRs is
wrong on multiple fronts:

 - ARBPRI isn't supported by KVM, isn't accelerated by AVIC (for read or
   write), and its #VMEXIT is fault-like, i.e. requires decoding the
   instruction.  Disabling interception is nonsensical and suboptimal.

 - DFR and ICR2 aren't supported by x2APIC and so don't need their
   intercepts disabled for performance reasons.  While the #GP due to
   x2APIC being abled has higher priority than the trap-like #VMEXIT,
   disabling interception of unsupported MSRs is confusing and unnecessary.

 - RRR is completely unsupported.

 - AVIC currently fails to pass through the "range of vectors" registers,
   IRR, ISR, and TMR, as e.g. X2APIC_MSR(APIC_IRR) only affects IRR0, and
   thus only disables intercept for vectors 31:0 (which are the *least*
   interesting registers).

 - TMCCT (the current APIC timer count) isn't accelerated by hardware, and
   generates a fault-like AVIC_UNACCELERATED_ACCESS #VMEXIT, i.e. requires
   KVM to decode the instruction to figure out what the guest was trying to
   access.  Note, the only reason this isn't a fatal bug is that the AVIC
   architecture had the foresight to guard against buggy hypervisors.  E.g.
   if hardware simply read from the virtual APIC page, the guest would get
   garbage (because the timer is emulated in software).

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://patch.msgid.link/20260514213115.1637082-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -122,6 +122,9 @@ static u32 x2avic_max_physical_id;
 static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
 					     bool intercept)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u64 rd_regs;
+
 	static const u32 x2avic_passthrough_msrs[] = {
 		X2APIC_MSR(APIC_ID),
 		X2APIC_MSR(APIC_LVR),
@@ -162,9 +165,15 @@ static void avic_set_x2apic_msr_intercep
 	if (!x2avic_enabled)
 		return;
 
+	rd_regs = kvm_x2apic_disable_read_intercept_reg_mask(vcpu);
+
+	for_each_set_bit(i, (unsigned long *)&rd_regs, BITS_PER_TYPE(rd_regs))
+		svm_set_intercept_for_msr(vcpu, APIC_BASE_MSR + i,
+					  MSR_TYPE_R, intercept);
+
 	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
-		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
-					  MSR_TYPE_RW, intercept);
+		svm_set_intercept_for_msr(vcpu, x2avic_passthrough_msrs[i],
+					  MSR_TYPE_W, intercept);
 
 	svm->x2avic_msrs_intercepted = intercept;
 }


