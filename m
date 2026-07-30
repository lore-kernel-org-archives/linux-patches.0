Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753B43F4AB;
	Thu, 30 Jul 2026 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428306; cv=none; b=u20p1cnMttSjKBEYarFcxYscCWKD9v024JsyMl3qGn6CTP69JAz6zAGdo4Al0auM6PyLCOH8W81R4XeE2AtwLcbD4XpH8TFYcGmE4jNeIK38dNdK0szjoNbPwJg7HKlxrGqBuvHez+EypTOtxm4FlLM7dhva+Eo3lryYpuNqUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428306; c=relaxed/simple;
	bh=p8KOOoARF22dt4w5TSCgwK3Bja2iX7gxeR6jamHf+lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZF+wU5JrCxGojX4siy2oCTxu2gwo9IYIUkWeVgChdwp4E1g+W8uNoSSb9gzgN+kpqeGPcjLh58HfUPI0ji/f/nNuBn6uhOH4TvLJ1xzjbrxbNmeFLFAfkQ+NmNLmdyXnw2aaogODLz7XDoLFErZoJhbiSJFvyZ3xJ38LzuG0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bst/eEdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bst/eEdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786CF1F000E9;
	Thu, 30 Jul 2026 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428305;
	bh=sQ1AEIRjdBgSFw6Sa2SIbJkXkssbBhtBeuBZgt2o2NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bst/eEdYT9CmMkPNMDlSMzkm8CIoum/VlWmtf6kXujJth8nobjaAb1Yd7KeA++Bgk
	 oL68uoT1c5z1WnHHt4vRCC84RAqFd6702h8XU0BvJFeCAdNFrUEnTR2fMCLnbLqGLz
	 87YMwr35+ga5aqXAePec4imRdgHh1twrz7TgtmS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	James Houghton <jthoughton@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH 6.6 476/484] KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN
Date: Thu, 30 Jul 2026 16:16:13 +0200
Message-ID: <20260730141433.834232434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkatesh Srinivas <venkateshs@chromium.org>

[ Upstream commit e800decd9c0ac4349bcd8f8f9b29fd21fe93165e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1912,7 +1912,7 @@ static void apic_timer_expired(struct kv
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
-	if (!from_timer_fn && apic->apicv_active) {
+	if (!from_timer_fn && apic->apicv_active && vcpu->wants_to_run) {
 		WARN_ON(kvm_get_running_vcpu() != vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;


