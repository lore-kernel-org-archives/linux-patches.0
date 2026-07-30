Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E743E4BA;
	Thu, 30 Jul 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421219; cv=none; b=gRW/YMI7xMTS49RcVoochwK/9jdHGfStfjBiJ8/efpl6B4TxbeLqYtZ+fEbIO7SsPS2liyWsSyonIFm7PwOpB+HrTMncu6E9F9useXblch76k/ijY6wjQa8N4jiYb155bROuhauDPsfHa5BIi2eAT6yGZ7FGpGi/HbgF05cLVoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421219; c=relaxed/simple;
	bh=lQ/TE4GEOVt+wEYflIVRdXS5dyl0l/G/RaBfTZdfpxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJ7VjfDvFBh9mXhWqvRbfyyXaJUzou310R0jY8VshPrHM+s+td3cfXWH1YsCQygk9IsFWAuJPon1wHBPeR1YQxs22bL3TNI6wZi5DNYQ3lz+L1+JnFTKOdpRklnT7DcUwAu5ZDf2z9jrwv27sHMyJM9hLlHTdqa3pWpbAffv+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm3BOy0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm3BOy0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A1B1F00A3D;
	Thu, 30 Jul 2026 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421218;
	bh=qGq4eIdKl7MQ3gPlmnCi+CEXwfp9Nuhz/h4mLCOZwVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm3BOy0uvZs31rN80EZ+pGiYpBf3hvOQxM6wahJQdz5Akb3CLnQeXcGuuUe2ddQV0
	 wSMGXIm3xaWKvrJqJpMxJqW4L9bh1cnyBMSOfdlWYOC6Uq6+9cxyWitehjLTokqpDr
	 nacZlKgEcY4qAdaQUK2xjp/Xe2vEqYhlM1rEXQnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	James Houghton <jthoughton@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH 7.1 006/744] KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN
Date: Thu, 30 Jul 2026 16:04:39 +0200
Message-ID: <20260730141444.414783791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Venkatesh Srinivas <venkateshs@chromium.org>

commit e800decd9c0ac4349bcd8f8f9b29fd21fe93165e upstream.

On Intel platforms with a VMX preemption timer and APICv, if a VMM
calls KVM_GET_LAPIC before KVM_GET_MSRS to save the vCPU state, it is
possible to lose a pending timer interrupt.

If the thread running these ioctls is migrated to another core after
calling KVM_GET_LAPIC but before KVM_GET_MSRS and the guest is using
their LAPIC timer in TSC-deadline mode, not only does the save LAPIC
state not carry the pending interrupt, the TSCDEADLINE MSR will be
zeroed.

After migration across CPUs, KVM_GET_MSRS calls vcpu_load, posting the
interrupt and clearing the MSR:
vcpu_load() ->
  kvm_arch_vcpu_load() ->
    kvm_lapic_restart_hv_timer() ->
      start_hv_timer() ->
        apic_timer_expired() ->
          kvm_apic_inject_pending_timer_irqs()
            . post interrupt into the LAPIC state
            . clear IA32_TSCDEADLINE

The saved LAPIC state will be missing the pending interrupt and the saved
MSR will be zero. Oops.

Fix by only posting an interrupt when we're attempting to enter the guest
(vcpu->wants_to_run == true), not for vcpu_load from other paths.

Assisted-by: gemini:gemini-3.1-pro-preview
Debugged-by: David Matlack <dmatlack@google.com>
Debugged-by: Sean Christopherson <seanjc@google.com>
Debugged-by: Jim Mattson <jmattson@google.com>
Debugged-by: James Houghton <jthoughton@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Message-ID: <20260715234234.15382-2-venkateshs@chromium.org>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Cc: stable@vger.kernel.org
Fixes: ae95f566b3d2 ("KVM: X86: TSCDEADLINE MSR emulation fastpath", 2020-05-15)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2052,7 +2052,7 @@ static void apic_timer_expired(struct kv
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
-	if (!from_timer_fn && apic->apicv_active) {
+	if (!from_timer_fn && apic->apicv_active && vcpu->wants_to_run) {
 		WARN_ON(kvm_get_running_vcpu() != vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;


