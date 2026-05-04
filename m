Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837953DA5C7;
	Mon,  4 May 2026 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903398; cv=none; b=X1QVfce6RVhT0LGjgjSFEMgcAjQT/R9CF9OWD4x6qz0PmcrGiJA+0BEaowcOWrEk6CRL8xEXyATq+yk0hpcEUsJ72Oa8E3IxKn7MZdT2krUmwS4G3Eo0moq16aDRPmLCcRrKhJOgUYSdsGF2d9NJ3HtLZyyue6ZRHcHyGnhd8ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903398; c=relaxed/simple;
	bh=h+OWwQOLVJC3z4FGMbVfeIcBH/jnOKnLIln6jwaOBqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvdzOxR9t3k06Tlr4CM2Nt0xiAk2vbKYuCfwUmbhIIVgm06JlYTAOtVi4S2hKCALaiuLFRa3y+iHGGV629ZGNXNTN9jmIXJEh443jVIjWPWzRjQimgy7HFCyNnJKFr5cs247XEHCfyoO6XtFOdQf3FCIxOegUVRuF0hQGYuSs6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zj4EEO5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zj4EEO5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6574C2BCB8;
	Mon,  4 May 2026 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903398;
	bh=h+OWwQOLVJC3z4FGMbVfeIcBH/jnOKnLIln6jwaOBqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zj4EEO5qHdYf4JK99WYrHcRHq9gEZMOSYUmb2sYlUxOU4Kc4/gZ+yA28z7+DbTjd5
	 x0fjrvKVEWBhx2gX8j2cG03n1ZDGK8RNF8xJtinMKUi8zbpkUpZRzJbG4CN+T6VfkL
	 gxiT5IdYRMG8oMqpaol7KgXtlRz5FblrPV4HZoCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 219/307] KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
Date: Mon,  4 May 2026 15:51:44 +0200
Message-ID: <20260504135151.104371282@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit 5d291ef0585ed880ed4dd71ea1a5965e0a65fb53 upstream.

If loading L1's CR3 fails on a nested #VMEXIT, nested_svm_vmexit()
returns an error code that is ignored by most callers, and continues to
run L1 with corrupted state. A sane recovery is not possible in this
case, and HW behavior is to cause a shutdown. Inject a triple fault
instead, and do not return early from nested_svm_vmexit(). Continue
cleaning up the vCPU state (e.g. clear pending exceptions), to handle
the failure as gracefully as possible.

>From the APM:

  Upon #VMEXIT, the processor performs the following actions in order to
  return to the host execution context:

  ...

  if (illegal host state loaded, or exception while loading host state)
      shutdown
  else
      execute first host instruction following the VMRUN

Remove the return value of nested_svm_vmexit(), which is mostly
unchecked anyway.

Fixes: d82aaef9c88a ("KVM: nSVM: use nested_svm_load_cr3() on guest->host switch")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-10-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   10 +++-------
 arch/x86/kvm/svm/svm.c    |   11 ++---------
 arch/x86/kvm/svm/svm.h    |    6 +++---
 3 files changed, 8 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1202,12 +1202,11 @@ static int nested_svm_vmexit_update_vmcb
 	return 0;
 }
 
-int nested_svm_vmexit(struct vcpu_svm *svm)
+void nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	int rc;
 
 	rc = nested_svm_vmexit_update_vmcb12(vcpu);
 	if (rc) {
@@ -1330,9 +1329,8 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
-		return 1;
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
@@ -1357,8 +1355,6 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	 */
 	if (kvm_apicv_activated(vcpu->kvm))
 		__kvm_vcpu_update_apicv(vcpu);
-
-	return 0;
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2233,13 +2233,9 @@ static int emulate_svm_instr(struct kvm_
 		[SVM_INSTR_VMSAVE] = vmsave_interception,
 	};
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret;
 
 	if (is_guest_mode(vcpu)) {
-		/* Returns '1' or -errno on failure, '0' on success. */
-		ret = nested_svm_simple_vmexit(svm, guest_mode_exit_codes[opcode]);
-		if (ret)
-			return ret;
+		nested_svm_simple_vmexit(svm, guest_mode_exit_codes[opcode]);
 		return 1;
 	}
 	return svm_instr_handlers[opcode](vcpu);
@@ -4872,7 +4868,6 @@ static int svm_enter_smm(struct kvm_vcpu
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map_save;
-	int ret;
 
 	if (!is_guest_mode(vcpu))
 		return 0;
@@ -4892,9 +4887,7 @@ static int svm_enter_smm(struct kvm_vcpu
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
-	if (ret)
-		return ret;
+	nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
 
 	/*
 	 * KVM uses VMCB01 to store L1 host state while L2 runs but
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -793,14 +793,14 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 			  struct vmcb_save_area *from_save);
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
-int nested_svm_vmexit(struct vcpu_svm *svm);
+void nested_svm_vmexit(struct vcpu_svm *svm);
 
-static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
+static inline void nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 {
 	svm->vmcb->control.exit_code	= exit_code;
 	svm->vmcb->control.exit_info_1	= 0;
 	svm->vmcb->control.exit_info_2	= 0;
-	return nested_svm_vmexit(svm);
+	nested_svm_vmexit(svm);
 }
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);


