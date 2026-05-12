Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2439336891;
	Tue, 12 May 2026 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609489; cv=none; b=MOd8RPb3uMH2gk33YxuZ3VauSH51LCjDVWla7EaV339+2wVwr8bAtLA15Spfqsf+0UAimkcxk6u05HqEOaho+uRTOY6dN/HoOQs6wSD0aXL6hM3Zx6MWQlQYDVxEu2uq+221rxQlETPKzGXVRQPhCmAXinBuP5sa+4zDelAUn3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609489; c=relaxed/simple;
	bh=s+FFLoxTZyV4KfClqb7sSGrduV7aMfsyttxhQ3UKPT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4RokHhUNwElpmsGhN7V8g9bmPVxqDzU1rY92PSdW5Eeo8T5Uue4tl7DeH3Y7eIcCpw4KEIanj+SMZbOOQL27mTl0WHpTWueZqBzzVmNb55vGBcxF9cMpBah67CRPDXsUQ9wRBrhS0S0nzI0Hex7Je33V2DCduofkc1w2LgUObo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDeNJZ8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDeNJZ8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F60C2BCB0;
	Tue, 12 May 2026 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609489;
	bh=s+FFLoxTZyV4KfClqb7sSGrduV7aMfsyttxhQ3UKPT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDeNJZ8tKUANYMEaet8yJYLXtnOSZk9JMt+nq/rQ9dNSbI1hNAQVwNTy0yWXao3yY
	 HLLw569UZ/nsStIYzn/KvQFS3LkcuiWPVAMzzqXBtNe1H3+fD4iYg1+dMrKndE4iEQ
	 E9G3zHSLBme3lFbOMTbPRo3mNreoBYqS01OWh1oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farrah Chen <farrah.chen@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH 7.0 216/307] KVM: x86: Do IRR scan in __kvm_apic_update_irr even if PIR is empty
Date: Tue, 12 May 2026 19:40:11 +0200
Message-ID: <20260512173944.674439833@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 33fd0ccd2590b470b65adcca288615ad3b5e3e06 upstream.

Fall back to apic_find_highest_vector() when PID.ON is set but PIR
turns out to be empty, to correctly report the highest pending interrupt
from the existing IRR.

In a nested VM stress test, the following WARNING fires in
vmx_check_nested_events() when kvm_cpu_has_interrupt() reports a pending
interrupt but the subsequent kvm_apic_has_interrupt() (which invokes
vmx_sync_pir_to_irr() again) returns -1:

  WARNING: CPU: 99 PID: 57767 at arch/x86/kvm/vmx/nested.c:4449 vmx_check_nested_events+0x6bf/0x6e0 [kvm_intel]
  Call Trace:
   kvm_check_and_inject_events
   vcpu_enter_guest.constprop.0
   vcpu_run
   kvm_arch_vcpu_ioctl_run
   kvm_vcpu_ioctl
   __x64_sys_ioctl
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

The root cause is a race between vmx_sync_pir_to_irr() on the target vCPU
and __vmx_deliver_posted_interrupt() on a sender vCPU.  The sender
performs two individually-atomic operations that are not a single
transaction:

  1. pi_test_and_set_pir(vector)  -- sets the PIR bit
  2. pi_test_and_set_on()         -- sets PID.ON

The following interleaving triggers the bug:

  Sender vCPU (IPI):              Target vCPU (1st sync_pir_to_irr):
  B1: set PIR[vector]
                                  A1: pi_clear_on()
                                  A2: pi_harvest_pir() -> sees B1 bit
                                  A3: xchg() -> consumes bit, PIR=0
                                      (1st sync returns correct max_irr)
  B2: set PID.ON = 1

                                  Target vCPU (2nd sync_pir_to_irr):
                                  C1: pi_test_on() -> TRUE (from B2)
                                  C2: pi_clear_on() -> ON=0
                                  C3: pi_harvest_pir() -> PIR empty
                                  C4: *max_irr = -1, early return
                                      IRR NOT SCANNED

The interrupt is not lost (it resides in the IRR from the first sync and
is recovered on the next vcpu_enter_guest() iteration), but the incorrect
max_irr causes a spurious WARNING and a wasted L2 VM-Enter/VM-Exit cycle.

Fixes: b41f8638b9d3 ("KVM: VMX: Isolate pure loads from atomic XCHG when processing PIR")
Reported-by: Farrah Chen <farrah.chen@intel.com>
Analyzed-by: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/kvm/20260428070349.1633238-1-chenyi.qiang@intel.com/T/
Link: https://patch.msgid.link/20260503201703.108231-2-pbonzini@redhat.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -669,12 +669,14 @@ bool __kvm_apic_update_irr(unsigned long
 	u32 irr_val, prev_irr_val;
 	int max_updated_irr;
 
+	if (!pi_harvest_pir(pir, pir_vals)) {
+		*max_irr = apic_find_highest_vector(regs + APIC_IRR);
+		return false;
+	}
+
 	max_updated_irr = -1;
 	*max_irr = -1;
 
-	if (!pi_harvest_pir(pir, pir_vals))
-		return false;
-
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 


