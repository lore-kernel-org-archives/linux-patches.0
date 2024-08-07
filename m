Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2833B78B4C;
	Wed,  7 Aug 2024 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043271; cv=none; b=qfCi+6HU0P9X8yTHKffDwFsbEdp5f/c9GvN76yj3pVSeLzzl+0X68mKn4bbjqeWX32sUr5eRyzfN/Nggt7XSb+imbWXjw4yk0+u/HK0CJdOwKSMB7n4aFLl74GiKam2NCMjRymQlsrCrrcySj369viEVDm1QlEp6gkzLATNj6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043271; c=relaxed/simple;
	bh=PqUDXUoyNfymQ8tw9pWoHX9iTFOt/0yTgFHQeAMytFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aef83+byOHRmVhUbrf7Lj2qXODH1pAxlHIRLlJFGgJRvTpsGN02jAgOAM/8+8L6wlNmRhhX7RrPkiV1eREmGCR5XULS/KycD/F9jHFgy9wLSVpHBpIOXpnpEdmALuWsqMoGuGB6qKi7Gr+et9DnCWXCrcY7B3YcELBhPyfXGLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkXq9Cms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkXq9Cms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0F7C32781;
	Wed,  7 Aug 2024 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043271;
	bh=PqUDXUoyNfymQ8tw9pWoHX9iTFOt/0yTgFHQeAMytFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkXq9CmsZtXl7UvKvckWbzLl15C0rv+tCeo5iLr10P4km2EkqjGNN9WuksNJCAroB
	 wppvrQcp5Z5A41JNENwHg3+Fvum/VpEK+NqX/APPeMODJ+8vaxcM4V+BwerK9FoSAp
	 642CUwAdDRPTjCZu3GB0TVs8ao2JG3vwf4zrXUz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/121] KVM: nVMX: Check for pending posted interrupts when looking for nested events
Date: Wed,  7 Aug 2024 16:59:22 +0200
Message-ID: <20240807150020.324813712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 27c4fa42b11af780d49ce704f7fa67b3c2544df4 ]

Check for pending (and notified!) posted interrupts when checking if L2
has a pending wake event, as fully posted/notified virtual interrupt is a
valid wake event for HLT.

Note that KVM must check vmx->nested.pi_pending to avoid prematurely
waking L2, e.g. even if KVM sees a non-zero PID.PIR and PID.0N=1, the
virtual interrupt won't actually be recognized until a notification IRQ is
received by the vCPU or the vCPU does (nested) VM-Enter.

Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com
Link: https://lore.kernel.org/r/20240607172609.3205077-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5f85375f75b48..0ad66b9207e85 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3965,8 +3965,40 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
 static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	return nested_vmx_preemption_timer_pending(vcpu) ||
-	       to_vmx(vcpu)->nested.mtf_pending;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	void *vapic = vmx->nested.virtual_apic_map.hva;
+	int max_irr, vppr;
+
+	if (nested_vmx_preemption_timer_pending(vcpu) ||
+	    vmx->nested.mtf_pending)
+		return true;
+
+	/*
+	 * Virtual Interrupt Delivery doesn't require manual injection.  Either
+	 * the interrupt is already in GUEST_RVI and will be recognized by CPU
+	 * at VM-Entry, or there is a KVM_REQ_EVENT pending and KVM will move
+	 * the interrupt from the PIR to RVI prior to entering the guest.
+	 */
+	if (for_injection)
+		return false;
+
+	if (!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
+	    __vmx_interrupt_blocked(vcpu))
+		return false;
+
+	if (!vapic)
+		return false;
+
+	vppr = *((u32 *)(vapic + APIC_PROCPRI));
+
+	if (vmx->nested.pi_pending && vmx->nested.pi_desc &&
+	    pi_test_on(vmx->nested.pi_desc)) {
+		max_irr = pi_find_highest_vector(vmx->nested.pi_desc);
+		if (max_irr > 0 && (max_irr & 0xf0) > (vppr & 0xf0))
+			return true;
+	}
+
+	return false;
 }
 
 /*
-- 
2.43.0



