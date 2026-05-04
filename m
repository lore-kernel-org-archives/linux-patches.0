Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250343DDDD6;
	Mon,  4 May 2026 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904080; cv=none; b=JKN+VjFWoq0U72DEQyDm0uCzMFArQ+phs1bz+glbx9N5ld51RGs41c5IRMB6fsgE5RsQK8aq7XyBvDhe/nl/rcmMgvyHhjm5EokKvWmkerh5TPJlZhRI3+2LRm8Id+Q9W5CyjSdAwdFaWNuO3TQE6bmxIYw6IMFMgMx2DjbxEVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904080; c=relaxed/simple;
	bh=ZtAy3l5q1sSbHKk0csCwEN1l0mVPlzn7B5c8Q+CP9Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVFkWDU7+8iSQ98dV52nm7w4MNv6sQGXKSQUSGi93jgsCefeiWfvXaHdzqxuPLyB/Tnov2JxkNEPiSfdkyM6ciY6zsJD2nF6mCWwX0dUi7bonk/XvsUdLaAeJjKFEInXFhDkJReffQglkQJlrD0YjURiNryd+dd9r8q0Mq/FFR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmcuWdLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmcuWdLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD15C2BCB8;
	Mon,  4 May 2026 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904080;
	bh=ZtAy3l5q1sSbHKk0csCwEN1l0mVPlzn7B5c8Q+CP9Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmcuWdLfhadEVpzZP4U8YUzCLaSI+WhZlZq1GKnSuLVy/s4qiAwqeSr2/51RtxKVw
	 dR+gyaBNiaWmX+P5c3zXMA7/riPT3nVohvJFX3IxVXVgoAWcGIIxODR8wHHHCsZzhD
	 /eVlbSpK1Zw3iTdORkgHBBFiu3zB4+tJps5PePTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 6.18 176/275] KVM: nSVM: Delay stuffing L2s current RIP into NextRIP until vCPU run
Date: Mon,  4 May 2026 15:51:56 +0200
Message-ID: <20260504135149.607134426@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit a0592461f39c00b28f552fe842a063a00043eaa8 upstream.

For guests with NRIPS disabled, L1 does not provide NextRIP when running
an L2 with an injected soft interrupt, instead it advances L2's RIP
before running it. KVM uses L2's current RIP as the NextRIP in vmcb02 to
emulate a CPU without NRIPS.

However, in svm_set_nested_state(), the value used for L2's current RIP
comes from vmcb02, which is just whatever the vCPU had in vmcb02 before
restoring nested state (zero on a freshly created vCPU). Passing the
cached RIP value instead (i.e. kvm_rip_read()) would only fix the issue
if registers are restored before nested state.

Instead, split the logic of setting NextRIP in vmcb02. Handle the
'normal' case of initializing vmcb02's NextRIP using NextRIP from vmcb12
(or KVM_GET_NESTED_STATE's payload) in nested_vmcb02_prepare_control().
Delay the special case of stuffing L2's current RIP into vmcb02's
NextRIP until shortly before the vCPU is run, to make sure the most
up-to-date value of RIP is used regardless of KVM_SET_REGS and
KVM_SET_NESTED_STATE's relative ordering.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-7-yosry@kernel.org
[sean: use new helper, svm_fixup_nested_rips()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   25 ++++++++-----------------
 arch/x86/kvm/svm/svm.c    |   25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -814,24 +814,15 @@ static void nested_vmcb02_prepare_contro
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
 	/*
-	 * NextRIP is consumed on VMRUN as the return address pushed on the
-	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
-	 * to L1, take it verbatim from vmcb12.
-	 *
-	 * If nrips is supported in hardware but not exposed to L1, stuff the
-	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
-	 * responsible for advancing RIP prior to injecting the event). This is
-	 * only the case for the first L2 run after VMRUN. After that (e.g.
-	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
-	 * the value of the L2 RIP from vmcb12 should not be used.
+	 * If nrips is exposed to L1, take NextRIP as-is.  Otherwise, L1
+	 * advances L2's RIP before VMRUN instead of using NextRIP. KVM will
+	 * stuff the current RIP as vmcb02's NextRIP before L2 is run.  After
+	 * the first run of L2 (e.g. after save+restore), NextRIP is updated by
+	 * the CPU and/or KVM and should be used regardless of L1's support.
 	 */
-	if (boot_cpu_has(X86_FEATURE_NRIPS)) {
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
-		    !svm->nested.nested_run_pending)
-			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-		else
-			vmcb02->control.next_rip    = vmcb12_rip;
-	}
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
+	    !svm->nested.nested_run_pending)
+		vmcb02->control.next_rip = svm->nested.ctl.next_rip;
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3661,6 +3661,29 @@ static void svm_inject_irq(struct kvm_vc
 	svm->vmcb->control.event_inj = intr->nr | SVM_EVTINJ_VALID | type;
 }
 
+static void svm_fixup_nested_rips(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!is_guest_mode(vcpu) || !svm->nested.nested_run_pending)
+		return;
+
+	/*
+	 * If nrips is supported in hardware but not exposed to L1, stuff the
+	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
+	 * responsible for advancing RIP prior to injecting the event). Once L2
+	 * runs after L1 executes VMRUN, NextRIP is updated by the CPU and/or
+	 * KVM, and this is no longer needed.
+	 *
+	 * This is done here (as opposed to when preparing vmcb02) to use the
+	 * most up-to-date value of RIP regardless of the order of restoring
+	 * registers and nested state in the vCPU save+restore path.
+	 */
+	if (boot_cpu_has(X86_FEATURE_NRIPS) &&
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+		svm->vmcb->control.next_rip = kvm_rip_read(vcpu);
+}
+
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vector)
 {
@@ -4246,6 +4269,8 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
+	svm_fixup_nested_rips(vcpu);
+
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
 
 	/*


