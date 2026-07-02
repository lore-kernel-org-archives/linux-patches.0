Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E113A9870;
	Thu,  2 Jul 2026 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009976; cv=none; b=ob8RU+81TIK8fPRYetU7WVoJGnwl9XKuAC7Wsh7lA9iSYtL0ya7TcClltLiITZ6fhUWkNtmFrVDj727zRFuK2nlORQuI3lLsntofUjk0hDMiY8SRBKzK6U6O7+rsp7lrkxHs71f6XSEfHCnND68aPdif5UKIppYaa3hQGY9pDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009976; c=relaxed/simple;
	bh=NoqT1MEBZeicf6sAfnKnxP1pmr512bLnYq76ZRBUZe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTCPDJW/eduZoTptq7xgoM079sOuYwUXL25ixxnT2tbgAGunBWWJba2xg8rC5X1mXcEYCscUBnsnR5el0wy7JBI3Fz7g9estDQpcHc4LATTZEnXeDavEF9pW0BjQ0DRpe8wc9bW7gk923RfRXOQjoqKbwUOshE3SaK66c/kvcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdcUhvuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdcUhvuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B921F000E9;
	Thu,  2 Jul 2026 16:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009974;
	bh=YLgLkMgWOyyemDoC5UoK+EX0txWkvB2Ta4kzYgCnXe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdcUhvuYqe5LVYtUeZD0h3SPpYYB5OZbAb/Lcw65Z/bLzf5bPMtliVPpGW3iua0FL
	 T36aOxTVi8Wi3v4jHyEibZdB6mSafQn/oQNCwVToNh8CNMenLeooRzYz8rMXKv1Yfg
	 +sMYEeTa4RUi56n8A01VZHI7kL5lIGVFckSPHYjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/129] KVM: nVMX: Check for pending posted interrupts when looking for nested events
Date: Thu,  2 Jul 2026 18:18:58 +0200
Message-ID: <20260702155112.559832658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 27c4fa42b11af780d49ce704f7fa67b3c2544df4 upstream.

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
[ Nicholas Dudar: backport to 6.1.y. Prerequisite for the next patch, which
  folds its check into the vmx_has_nested_events() body this patch builds.
  Applies cleanly. The for_injection path still returns preemption_timer ||
  mtf, as the previous 6.1.y body did. ]
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8e18dbe8531b..ad07e83d2c1d5b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3953,8 +3953,40 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
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
2.53.0



