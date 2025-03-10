Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158D22C336;
	Mon, 10 Mar 2025 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627726; cv=none; b=DjMWDcVICno6+C1cYZigd/WrNQKb+qlKj5sNT7BJjTlRkhLjskQvICJ654KXiwtR5w4BrkhbWIgk+U9jT2XHJdUhKifT2rrUNwLo8m/rNBBO57rvSLnamyX1mlb6NwtFi6Di0q1iTvFVbh5rX57j+f7bsp0PU/JiZsjTo95SqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627726; c=relaxed/simple;
	bh=55uR/OHcS2e1gWz9Fa8kacf/fll5Jc1q4E3cycfTZxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKs1HC5W7DGd6kddLZlehsBDIpBIslhnwP/D7aGi0jm1Mvjqmg5A3TlKC3r9ZCo0sdkSKUBlwKPzPcjZATn9K+rmrIEOYZ4leY7MS0SoQfZwNLjt+nPVfXuYT01Zq+acrP3BndFQbsLKF3LN/WWqCFAXsXoZyI50k5NHhzmWWwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgzvU5Dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgzvU5Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28E8C4CEE5;
	Mon, 10 Mar 2025 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627726;
	bh=55uR/OHcS2e1gWz9Fa8kacf/fll5Jc1q4E3cycfTZxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgzvU5DgBp7aVb1eL5oY0NytlzT3EnJS7BTalbkM1FgurGRHb/lLseH5zpKnwSzD7
	 OWGqvjwZYxxeArb46SbvTuzG+6t0R2QRTMYCUDiDaPb0X7ZYbjyBKO7V9FJl7FzaCM
	 bm84GlpdT6KRB4uBTTshVbpaQUNlC9rX+PYDnPQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Covelli <doug.covelli@broadcom.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 229/269] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI shadow
Date: Mon, 10 Mar 2025 18:06:22 +0100
Message-ID: <20250310170506.816341678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Christopherson <seanjc@google.com>

commit be45bc4eff33d9a7dae84a2150f242a91a617402 upstream.

Enable/disable local IRQs, i.e. set/clear RFLAGS.IF, in the common
svm_vcpu_enter_exit() just after/before guest_state_{enter,exit}_irqoff()
so that VMRUN is not executed in an STI shadow.  AMD CPUs have a quirk
(some would say "bug"), where the STI shadow bleeds into the guest's
intr_state field if a #VMEXIT occurs during injection of an event, i.e. if
the VMRUN doesn't complete before the subsequent #VMEXIT.

The spurious "interrupts masked" state is relatively benign, as it only
occurs during event injection and is transient.  Because KVM is already
injecting an event, the guest can't be in HLT, and if KVM is querying IRQ
blocking for injection, then KVM would need to force an immediate exit
anyways since injecting multiple events is impossible.

However, because KVM copies int_state verbatim from vmcb02 to vmcb12, the
spurious STI shadow is visible to L1 when running a nested VM, which can
trip sanity checks, e.g. in VMware's VMM.

Hoist the STI+CLI all the way to C code, as the aforementioned calls to
guest_state_{enter,exit}_irqoff() already inform lockdep that IRQs are
enabled/disabled, and taking a fault on VMRUN with RFLAGS.IF=1 is already
possible.  I.e. if there's kernel code that is confused by running with
RFLAGS.IF=1, then it's already a problem.  In practice, since GIF=0 also
blocks NMIs, the only change in exposure to non-KVM code (relative to
surrounding VMRUN with STI+CLI) is exception handling code, and except for
the kvm_rebooting=1 case, all exception in the core VM-Enter/VM-Exit path
are fatal.

Use the "raw" variants to enable/disable IRQs to avoid tracing in the
"no instrumentation" code; the guest state helpers also take care of
tracing IRQ state.

Oppurtunstically document why KVM needs to do STI in the first place.

Reported-by: Doug Covelli <doug.covelli@broadcom.com>
Closes: https://lore.kernel.org/all/CADH9ctBs1YPmE4aCfGPNBwA10cA8RuAk2gO7542DjMZgs4uzJQ@mail.gmail.com
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250224165442.2338294-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c     |   14 ++++++++++++++
 arch/x86/kvm/svm/vmenter.S |   10 +---------
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4176,6 +4176,18 @@ static noinstr void svm_vcpu_enter_exit(
 
 	guest_state_enter_irqoff();
 
+	/*
+	 * Set RFLAGS.IF prior to VMRUN, as the host's RFLAGS.IF at the time of
+	 * VMRUN controls whether or not physical IRQs are masked (KVM always
+	 * runs with V_INTR_MASKING_MASK).  Toggle RFLAGS.IF here to avoid the
+	 * temptation to do STI+VMRUN+CLI, as AMD CPUs bleed the STI shadow
+	 * into guest state if delivery of an event during VMRUN triggers a
+	 * #VMEXIT, and the guest_state transitions already tell lockdep that
+	 * IRQs are being enabled/disabled.  Note!  GIF=0 for the entirety of
+	 * this path, so IRQs aren't actually unmasked while running host code.
+	 */
+	raw_local_irq_enable();
+
 	amd_clear_divider();
 
 	if (sev_es_guest(vcpu->kvm))
@@ -4184,6 +4196,8 @@ static noinstr void svm_vcpu_enter_exit(
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	raw_local_irq_disable();
+
 	guest_state_exit_irqoff();
 }
 
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -170,12 +170,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
-	sti
-
 3:	vmrun %_ASM_AX
 4:
-	cli
-
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
@@ -340,12 +336,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	mov KVM_VMCB_pa(%rax), %rax
 
 	/* Enter guest mode */
-	sti
-
 1:	vmrun %rax
-
-2:	cli
-
+2:
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 


