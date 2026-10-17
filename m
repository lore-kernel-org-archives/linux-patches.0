Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175CC2C026C;
	Sat, 17 Oct 2026 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254227; cv=none; b=t4iiH1O3+iHOAdCt0BgvulT+6KRVtGfQrp3w07uXwXE9EAXAwRm1DBE5OB40s3ft72x+x7LSEMPKOCfoUTginvrUzviO2HM0TXKzU2Ll2wb96mo64+6umvVSbZ3fI0gR3G3LNIhIxrDLOfKyti3m9sFMk/hAbSOXgeeCf09qA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254227; c=relaxed/simple;
	bh=s85u5DQAPL/iOWDT/s8rixTf6SX7vlsUS95pqYaTu20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sLkBoDkezTtT6nGcJVdfBjdmN1d+Cj7YoIAYFDYmVQLoqaOYwLw/YyyMueziVQMIhaxX7c02AGelU0veqhO95Yeo6wJuCsat1yFuFeeNXy9IxMBo3KJK3IIWIz4Dvi0rQwSdjUHAf7BdkAUtTRw4+2+XdvIy5ZH1e2F/ipVFHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPjYmogW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPjYmogW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B32A1F000C4;
	Sat, 17 Oct 2026 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254225;
	bh=NKGtS5byiDp9+1CT8Aebx952QkS4RDl4PAwqXictqpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPjYmogWZUTV7YgMrHULgB7ya999aW7FzSWbT95griwEsipHSsQKQ8muice7vnTr8
	 ZmZ2HLd7OaS825s/GE/GC6JgddxndqY3hjSEM95JkaZpwFnjHl0bWQkpxr3210y/5R
	 BYCHXzJXvnofgT95Gqk7g/t9XqVSTdLdZVAYfkCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/869] KVM: x86: Unconditionally recompute CR8 intercept on PPR update
Date: Sat, 17 Oct 2026 17:53:36 +0200
Message-ID: <20261017160046.729382750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit bb365a506b1e6fb050c0fceaad354fe395385ef0 ]

The TPR_THRESHOLD field in the VMCS is used by VMX to induce VM exits
when the guest's virtual TPR falls under the specified threshold,
allowing KVM to inject previously masked interrupts.

KVM handles these VM exits in handle_tpr_below_threshold().
Commit eb90f3417a0c ("KVM: vmx: speed up TPR below threshold vmexits")
optimized this function by calling apic_update_ppr() instead of raising
KVM_REQ_EVENT. apic_update_ppr() then raises KVM_REQ_EVENT if there is
a pending, deliverable interrupt.

However, if there are no new interrupts pending, apic_update_ppr() does
not issue the request. Thus, kvm_lapic_update_cr8_intercept() and
vmx_update_cr8_intercept() are not called before VM entry, which results
in a high, stale TPR_THRESHOLD. This is problematic due to the following
sentence in 28.2.1.1 "VM-Execution Control Fields" in the SDM:

  The following check is performed if the “use TPR shadow” VM-execution
  control is 1 and the “virtualize APIC accesses” and “virtual-interrupt
  delivery” VM-execution controls are both 0: the value of bits 3:0 of
  the TPR threshold VM-execution control field should not be greater
  than the value of bits 7:4 of VTPR.

This error condition is typically not observed when KVM runs on a bare
metal system because modern processors support APICv, which enables
virtual-interrupt delivery, and which KVM uses when possible. This
causes the processor to no longer generate TPR-below-threshold exits
and to no longer check TPR_THRESHOLD on entry. However, when running
on older platforms, or under nested virtualization on a hypervisor that
does not support virtual-interrupt delivery and enforces this check
(like Hyper-V) this can cause a VM entry failure with hardware error
0x7, as seen in [1].

Call kvm_lapic_update_cr8_intercept() if apic_update_ppr() does not
find a deliverable interrupt (and thus does not raise KVM_REQ_EVENT).
Remove calls to kvm_lapic_update_cr8_intercept() on paths that end up in
apic_update_ppr(), as they now become redundant. This ensures that any
path that updates the guest's PPR also figures out if KVM needs to wait
for a TPR change (using TPR_THRESHOLD on VMX or CR8 intercepts on SVM).

Link: https://github.com/coconut-svsm/svsm/issues/1081 [1]
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Cc: stable@vger.kernel.org
Fixes: eb90f3417a0c ("KVM: vmx: speed up TPR below threshold vmexits")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260618174347.1981064-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 2 ++
 arch/x86/kvm/regs.c  | 4 +---
 arch/x86/kvm/x86.c   | 1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 574111144a903..6e6d00b3c042b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -994,6 +994,8 @@ static void apic_update_ppr(struct kvm_lapic *apic)
 	if (__apic_update_ppr(apic, &ppr) &&
 	    apic_has_interrupt_for_ppr(apic, ppr) != -1)
 		kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	else
+		kvm_lapic_update_cr8_intercept(apic->vcpu);
 }
 
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/regs.c b/arch/x86/kvm/regs.c
index 6d71bdb9f72c8..49afacc9b0990 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -591,8 +591,6 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 	kvm_x86_call(post_set_cr3)(vcpu, sregs->cr3);
 
-	kvm_set_cr8(vcpu, sregs->cr8);
-
 	*mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
 	kvm_x86_call(set_efer)(vcpu, sregs->efer);
 
@@ -621,7 +619,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	kvm_lapic_update_cr8_intercept(vcpu);
+	kvm_set_cr8(vcpu, sregs->cr8);
 
 	/* Older userspace won't unhalt the vcpu on reset. */
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 796bca8b9a865..23696631599ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4697,7 +4697,6 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	r = kvm_apic_set_state(vcpu, s);
 	if (r)
 		return r;
-	kvm_lapic_update_cr8_intercept(vcpu);
 
 	return 0;
 }
-- 
2.53.0



