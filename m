Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F23DD53E;
	Mon,  4 May 2026 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903382; cv=none; b=lIQqfd0dg0Hqb4b7fWqnAsTmGZvN8qFkiaPzdHWiyIVX66lI/PKEjnFRzXR/eaeGz/1gn9F7Ohr0ADkNISuiWHMW15V2FZ3hMIpDiTuImYcOGU/KQqMeyUq7N/PmE/ZNcm662S/gfEfmZbExWUY193hIdslSrdMwM0bfRYzSkTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903382; c=relaxed/simple;
	bh=w8/7/c2mWrfRUAguKeO8R+sTt8tsIcUDCEtd7K/A1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYF9SJZIoF9vxdtnQT6koimMuDsIucjnSNi0w+KfJIoVxKCbdgB/0zBbOAj1044fdCb8YhsTdHcfVyQ5F/Boy/se+MVCENupDSCB3Zn6Qb/ssGdhF3zFwMLSbhv9/+d4kQr+9ReOX7rJ84G+YITEMnDIYsLxxwkP5Sm02ZocHjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNbJx0L8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNbJx0L8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C83EC2BCB8;
	Mon,  4 May 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903382;
	bh=w8/7/c2mWrfRUAguKeO8R+sTt8tsIcUDCEtd7K/A1dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNbJx0L8WX22aI4uzRaCNsV8g6yRXfsTubrv4vnzgylgTA8XJ93t95MyfMiKesdUJ
	 z6cGkskQ1m6z7Qnu3VQp5hfbAZTSl5JiswfnNngnEJ4Pq/DHRkZ4Bpdnttd7D0R9Y4
	 42kVlmgeeKgN+VNHTIXYGk0ja4+PS0zTVezlJ2ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 7.0 213/307] KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run
Date: Mon,  4 May 2026 15:51:38 +0200
Message-ID: <20260504135150.884056956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit c64bc6ed1764c1b7e3c0017019f743196074092f upstream.

In the save+restore path, when restoring nested state, the values of RIP
and CS base passed into nested_vmcb02_prepare_control() are mostly
incorrect.  They are both pulled from the vmcb02. For CS base, the value
is only correct if system regs are restored before nested state. The
value of RIP is whatever the vCPU had in vmcb02 before restoring nested
state (zero on a freshly created vCPU).

Instead, take a similar approach to NextRIP, and delay initializing the
RIP tracking fields until shortly before the vCPU is run, to make sure
the most up-to-date values of RIP and CS base are used regardless of
KVM_SET_SREGS, KVM_SET_REGS, and KVM_SET_NESTED_STATE's relative
ordering.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-8-yosry@kernel.org
[sean: deal with the svm_cancel_injection() madness]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   17 ++++++++---------
 arch/x86/kvm/svm/svm.c    |   29 +++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -754,9 +754,7 @@ static bool is_evtinj_nmi(u32 evtinj)
 	return type == SVM_EVTINJ_TYPE_NMI;
 }
 
-static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
-					  unsigned long vmcb12_rip,
-					  unsigned long vmcb12_csbase)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -868,15 +866,16 @@ static void nested_vmcb02_prepare_contro
 		vmcb02->control.next_rip = svm->nested.ctl.next_rip;
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
+
+	/*
+	 * soft_int_csbase, soft_int_old_rip, and soft_int_next_rip (if L1
+	 * doesn't have NRIPS) are initialized later, before the vCPU is run.
+	 */
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
-		svm->soft_int_csbase = vmcb12_csbase;
-		svm->soft_int_old_rip = vmcb12_rip;
 		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
 		    !svm->nested.nested_run_pending)
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
-		else
-			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
 	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
@@ -974,7 +973,7 @@ int enter_svm_guest_mode(struct kvm_vcpu
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
+	nested_vmcb02_prepare_control(svm);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1920,7 +1919,7 @@ static int svm_set_nested_state(struct k
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+	nested_vmcb02_prepare_control(svm);
 
 	/*
 	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3639,6 +3639,16 @@ static int svm_handle_exit(struct kvm_vc
 	return svm_invoke_exit_handler(vcpu, svm->vmcb->control.exit_code);
 }
 
+static void svm_set_nested_run_soft_int_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->soft_int_csbase = svm->vmcb->save.cs.base;
+	svm->soft_int_old_rip = kvm_rip_read(vcpu);
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+		svm->soft_int_next_rip = kvm_rip_read(vcpu);
+}
+
 static int pre_svm_run(struct kvm_vcpu *vcpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
@@ -3761,6 +3771,13 @@ static void svm_fixup_nested_rips(struct
 	if (boot_cpu_has(X86_FEATURE_NRIPS) &&
 	    !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 		svm->vmcb->control.next_rip = kvm_rip_read(vcpu);
+
+	/*
+	 * Simiarly, initialize the soft int metadata here to use the most
+	 * up-to-date values of RIP and CS base, regardless of restore order.
+	 */
+	if (svm->soft_int_injected)
+		svm_set_nested_run_soft_int_state(vcpu);
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -4131,6 +4148,18 @@ static void svm_complete_soft_interrupt(
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
+	 * Initialize the soft int fields *before* reading them below if KVM
+	 * aborted entry to the guest with a nested VMRUN pending.  To ensure
+	 * KVM uses up-to-date values for RIP and CS base across save/restore,
+	 * regardless of restore order, KVM waits to set the soft int fields
+	 * until VMRUN is imminent.  But when canceling injection, KVM requeues
+	 * the soft int and will reinject it via the standard injection flow,
+	 * and so KVM needs to grab the state from the pending nested VMRUN.
+	 */
+	if (is_guest_mode(vcpu) && svm->nested.nested_run_pending)
+		svm_set_nested_run_soft_int_state(vcpu);
+
+	/*
 	 * If NRIPS is enabled, KVM must snapshot the pre-VMRUN next_rip that's
 	 * associated with the original soft exception/interrupt.  next_rip is
 	 * cleared on all exits that can occur while vectoring an event, so KVM


