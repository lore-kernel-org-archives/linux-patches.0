Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F35A3DDDD6;
	Mon,  4 May 2026 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904103; cv=none; b=maZs4meSQw9KZdJOAjHhWY4nxDxaWede01ujgDE/GQccXUoK7gnEKhhRzTvKw7ZlGUKQte9tesPIxzbrA1iIlzHGAPVKUbNe/pNPRvwVtVgMvcckBxpauJHKfgXMQ+Z602G8UXvKoTi7kDaPhG1HrzESSc2FFoShl3FpxDyaV/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904103; c=relaxed/simple;
	bh=au8fbHlRn66zthM9bZYpsnLRY/7h7avv0iEmAkAlUwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je/Qd6qQnAAErdxp33pYeCe6gcG6B0U7yxjKYvcY52F/oZFG5C60EVJ4rOQKHcuUIGCRR2qYzaDYINDBZELYXVciN3QFEiwOvFezDPTKXyQwW6Q+vc86xe4Ajx26AmiTf+me6NDek3k2YFZ1OdImUHQb8ky6nnGeoCzQGDidnP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV4doxRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV4doxRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70AAC2BCB8;
	Mon,  4 May 2026 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904103;
	bh=au8fbHlRn66zthM9bZYpsnLRY/7h7avv0iEmAkAlUwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV4doxREAZqWWKdU7in7yowjLguzq0XtrhTsfb8QsWpQ4uzizkSq9SgiIahraDmlI
	 N5QynT4D7dnSOzzXIrG69wY9UAi1lOIdcKlTrjORJJWqL197uAVJzaNGdcHHmlWer7
	 3EzpXmRLv8gKo0o7GhdChBZ6ZULS8vh1XzLhp4vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 184/275] KVM: nSVM: Refactor writing vmcb12 on nested #VMEXIT as a helper
Date: Mon,  4 May 2026 15:52:04 +0200
Message-ID: <20260504135149.911506846@linuxfoundation.org>
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

commit dcf3648ab71437b504abbfdc4e74622a0f1a56e3 upstream.

Move mapping vmcb12 and updating it out of nested_svm_vmexit() into a
helper, no functional change intended.

CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-8-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   77 ++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1082,36 +1082,20 @@ void svm_copy_vmloadsave_state(struct vm
 	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
 }
 
-int nested_svm_vmexit(struct vcpu_svm *svm)
+static int nested_svm_vmexit_update_vmcb12(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	struct vmcb *vmcb12;
 	struct kvm_host_map map;
+	struct vmcb *vmcb12;
 	int rc;
 
 	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (rc)
+		return rc;
 
 	vmcb12 = map.hva;
 
-	/* Exit Guest-Mode */
-	leave_guest_mode(vcpu);
-	svm->nested.vmcb12_gpa = 0;
-	WARN_ON_ONCE(svm->nested.nested_run_pending);
-
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-
-	/* in case we halted in L2 */
-	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
-
-	/* Give the current vmcb to the guest */
-
 	vmcb12->save.es     = vmcb02->save.es;
 	vmcb12->save.cs     = vmcb02->save.cs;
 	vmcb12->save.ss     = vmcb02->save.ss;
@@ -1149,10 +1133,48 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
+	if (nested_vmcb12_has_lbrv(vcpu))
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
+
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
+	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
+				       vmcb12->control.exit_info_1,
+				       vmcb12->control.exit_info_2,
+				       vmcb12->control.exit_int_info,
+				       vmcb12->control.exit_int_info_err,
+				       KVM_ISA_SVM);
+
+	kvm_vcpu_unmap(vcpu, &map);
+	return 0;
+}
+
+int nested_svm_vmexit(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	int rc;
+
+	rc = nested_svm_vmexit_update_vmcb12(vcpu);
+	if (rc) {
+		if (rc == -EINVAL)
+			kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	/* Exit Guest-Mode */
+	leave_guest_mode(vcpu);
+	svm->nested.vmcb12_gpa = 0;
+	WARN_ON_ONCE(svm->nested.nested_run_pending);
+
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
+	/* in case we halted in L2 */
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
+
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
@@ -1194,9 +1216,7 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	if (!nested_exit_on_intr(svm))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	if (nested_vmcb12_has_lbrv(vcpu)) {
-		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
-	} else {
+	if (!nested_vmcb12_has_lbrv(vcpu)) {
 		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
 		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 	}
@@ -1252,15 +1272,6 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
 
-	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
-				       vmcb12->control.exit_info_1,
-				       vmcb12->control.exit_info_2,
-				       vmcb12->control.exit_int_info,
-				       vmcb12->control.exit_int_info_err,
-				       KVM_ISA_SVM);
-
-	kvm_vcpu_unmap(vcpu, &map);
-
 	nested_svm_transition_tlb_flush(vcpu);
 
 	nested_svm_uninit_mmu_context(vcpu);


