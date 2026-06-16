Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33CD466B57;
	Tue, 16 Jun 2026 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627058; cv=none; b=Sh5gCxfomMGXaL/md+78ZzI+hQlrvkRWExG8X38/yg20qJMXgtV7zq/Xzdx0ShYdfD3DOPswSkoKDsHOHWgyLQeX3tBNkCowYUmBYe1aSxyEOjzca6Tx+BKeFlh2BIRXssGtVOQZmg0OxZrxPg9vjETWmAa/sbz4CBdX5AMP1So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627058; c=relaxed/simple;
	bh=BOBjp77sacgQOoysPoLJ7zYJuANBHbJwChh9K+HgDWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX29Y1AKB3l2is8evdhFf406/IXp0go7P2IQbkghE21UC63/4DJo0YS433lLpMYL9xd8j4c6mWdCoWK3II/J3JpltxiK+cn421SM/va43txzLjKeYfT3WoAn110e7oJ5bmPvdzf4OLEgQV6QcGM9yds4DoHWbReyEV/mwRN6W1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfulqqZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfulqqZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CBD1F000E9;
	Tue, 16 Jun 2026 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627057;
	bh=JkF+KuV/O9dWx/u/oxJyL3MYqs2KDNHWax5Kfvx7Lw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfulqqZif02W+4jWee0ucjEp6nmcUPenvrYU8y7oL+e/bWKccwdiaHecxt3UhA1tv
	 V4a0mlNEXTwmbQH9gFLb4K32M7iM1iFFbP2azUgKUfpZIlsj7x0Mjp83B9O6YQYl7w
	 Nd26w14Z6/VHkoNpND4KydKcADVkmHhoA5k5N35Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Gulshan Gabel <gulshan.gabel@nutanix.com>,
	Jon Kohler <jon@nutanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/261] KVM: VMX: Update SVI during runtime APICv activation
Date: Tue, 16 Jun 2026 20:29:11 +0530
Message-ID: <20260616145050.301260065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongli Zhang <dongli.zhang@oracle.com>

commit b2849bec936be642b5420801f902337f2507648e upstream.

The APICv (apic->apicv_active) can be activated or deactivated at runtime,
for instance, because of APICv inhibit reasons. Intel VMX employs different
mechanisms to virtualize LAPIC based on whether APICv is active.

When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
and report the current pending IRR and ISR states. Unless a specific vector
is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
KVM. Intel VMX automatically clears the corresponding ISR bit based on the
GUEST_INTR_STATUS.SVI field.

When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
to specify the next interrupt vector to invoke upon VM-entry. The
VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
VM-exit. EOIs are always trapped to KVM, so the software can manually clear
pending ISR bits.

There are scenarios where, with APICv activated at runtime, a guest-issued
EOI may not be able to clear the pending ISR bit.

Taking vector 236 as an example, here is one scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. After VM-entry, vector 236 is invoked through the guest IDT. At this
point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
interrupt handler for vector 236 is invoked.
4. Suppose a VM exit occurs very early in the guest interrupt handler,
before the EOI is issued.
5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
vector 236 has already been invoked in the guest.
6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
7. Unfortunately, GUEST_INTR_STATUS.SVI is not configured, although
vector 236 is still pending in the ISR.
8. After VM-entry, the guest finally issues the EOI for vector 236.
However, because SVI is not configured, vector 236 is not cleared.
9. ISR is stalled forever on vector 236.

Here is another scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. VM-exit occurs immediately after the next VM-entry. The vector 236 is
not invoked through the guest IDT. Instead, it is saved to the
IDT_VECTORING_INFO_FIELD during the VM-exit.
4. KVM calls kvm_queue_interrupt() to re-queue the un-invoked vector 236
into vcpu->arch.interrupt. A KVM_REQ_EVENT is requested.
5. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
6. Although APICv is now active, KVM still uses the legacy
VM_ENTRY_INTR_INFO_FIELD to re-inject vector 236. GUEST_INTR_STATUS.SVI is
not configured.
7. After the next VM-entry, vector 236 is invoked through the guest IDT.
Finally, an EOI occurs. However, due to the lack of GUEST_INTR_STATUS.SVI
configuration, vector 236 is not cleared from the ISR.
8. ISR is stalled forever on vector 236.

Using QEMU as an example, vector 236 is stuck in ISR forever.

(qemu) info lapic 1
dumping local APIC state for CPU 1

LVT0	 0x00010700 active-hi edge  masked                      ExtINT (vec 0)
LVT1	 0x00010400 active-hi edge  masked                      NMI
LVTPC	 0x00000400 active-hi edge                              NMI
LVTERR	 0x000000fe active-hi edge                              Fixed  (vec 254)
LVTTHMR	 0x00010000 active-hi edge  masked                      Fixed  (vec 0)
LVTT	 0x000400ec active-hi edge                 tsc-deadline Fixed  (vec 236)
Timer	 DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
SPIV	 0x000001ff APIC enabled, focus=off, spurious vec 255
ICR	 0x000000fd physical edge de-assert no-shorthand
ICR2	 0x00000000 cpu 0 (X2APIC ID)
ESR	 0x00000000
ISR	 236
IRR	 37(level) 236

The issue isn't applicable to AMD SVM as KVM simply writes vmcb01 directly
irrespective of whether L1 (vmcs01) or L2 (vmcb02) is active (unlike VMX,
there is no need/cost to switch between VMCBs).  In addition,
APICV_INHIBIT_REASON_IRQWIN ensures AMD SVM AVIC is not activated until
the last interrupt is EOI'd.

Fix the bug by configuring Intel VMX GUEST_INTR_STATUS.SVI if APICv is
activated at runtime.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Link: https://patch.msgid.link/20251110063212.34902-1-dongli.zhang@oracle.com
[sean: call out that SVM writes vmcb01 directly, tweak comment]
Link: https://patch.msgid.link/20251205231913.441872-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
(cherry picked from commit b2849bec936be642b5420801f902337f2507648e)
Cc: stable@vger.kernel.org # 6.6.x and above
Cc: Gulshan Gabel <gulshan.gabel@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 9 ---------
 arch/x86/kvm/x86.c     | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b8aa9ef73e7a46..d9011af23fb625 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6853,15 +6853,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 	 * VM-Exit, otherwise L1 with run with a stale SVI.
 	 */
 	if (is_guest_mode(vcpu)) {
-		/*
-		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
-		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
-		 * Note, userspace can stuff state while L2 is active; assert
-		 * that VID is disabled if and only if the vCPU is in KVM_RUN
-		 * to avoid false positives if userspace is setting APIC state.
-		 */
-		WARN_ON_ONCE(vcpu->wants_to_run &&
-			     nested_cpu_has_vid(get_vmcs12(vcpu)));
 		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
 		return;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1ee8bd3ca1569..21c10a87eed5b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10629,9 +10629,16 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
 	 * kvm_check_and_inject_events() is called to check for that.
+	 *
+	 * Update SVI when APICv gets enabled, otherwise SVI won't reflect the
+	 * highest bit in vISR and the next accelerated EOI in the guest won't
+	 * be virtualized correctly (the CPU uses SVI to determine which vISR
+	 * vector to clear).
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	else
+		kvm_apic_update_hwapic_isr(vcpu);
 
 out:
 	preempt_enable();
-- 
2.53.0



