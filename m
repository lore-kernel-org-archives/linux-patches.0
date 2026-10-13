Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5AC4F4049;
	Tue, 13 Oct 2026 12:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893365; cv=none; b=gWHtt2C0Lw3Tg8yBrC8Bh0mxFr0NCGBPzGMpzN5dwV6plpyRILM8p3c4wxuHn6tyyCL8aj2ouT9d2kDDMpm5pQuvcKXuwOM9IZfj6RuBtC5uOWXnt9K4zSh/dJENiyQAcuW1p87hmU7e4hCHW0K3gRWT5ksDQhBCRNVY2L+a07I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893365; c=relaxed/simple;
	bh=932AT4EXe5A6s/CQyk1Ow1Bl2Aa22rCEpkkgnv3DcLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELB5/TwHWeuaHvNSyP+d/Hjk9BOLjEBd61dcIfCZytVljqfwf+DbWz10ntTHjni7aaJ36R/A0jN4Nm0cVNTM0jfoYS5+p1oNcfSc74qw+71zFiwlC9W4TPPUfKVe/f7MFbibaQpB/G4YllVLkdZTXIK4u7qmR/hOJuIJ/46uHMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F228RP66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F228RP66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10FC1F000FF;
	Tue, 13 Oct 2026 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893363;
	bh=WGC+8mAnZ0TJIg66TWGT0TsDJKpl/7ynblaGv5NH+X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F228RP66tdBNHdjXfAbfvpk1Kx9TVVeWVS6B7YL+2Lqh3GMx9WtUfS4qn5Gt/qkpc
	 hI8CBx+Iop23obohLJ6A0kj+bBJvdjbp+OFS4JruQK464sfqYl5f9csU2orYsn2IAg
	 IMy1xtu51nUmWlpQ3DQHB+PSmsq9WliPb9TgsHeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/621] KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
Date: Tue, 13 Oct 2026 13:33:14 +0200
Message-ID: <20261013112925.585823741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit 5d291ef0585ed880ed4dd71ea1a5965e0a65fb53 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 10 +++-------
 arch/x86/kvm/svm/svm.c    | 11 ++---------
 arch/x86/kvm/svm/svm.h    |  6 +++---
 3 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index df54df7ae2013..892b6fd48a0d7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1165,12 +1165,11 @@ static int nested_svm_vmexit_update_vmcb12(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int nested_svm_vmexit(struct vcpu_svm *svm)
+void nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	int rc;
 
 	if (nested_svm_vmexit_update_vmcb12(vcpu))
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -1286,9 +1285,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
-		return 1;
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/* Drop tracking for L1->L2 injected NMIs and soft IRQs */
 	svm->nmi_l1_to_l2 = false;
@@ -1317,8 +1315,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 */
 	if (kvm_apicv_activated(vcpu->kvm))
 		__kvm_vcpu_update_apicv(vcpu);
-
-	return 0;
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ba7b0a67ad29e..e100717a37d6e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2152,13 +2152,9 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
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
@@ -4787,7 +4783,6 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map_save;
-	int ret;
 
 	if (!is_guest_mode(vcpu))
 		return 0;
@@ -4807,9 +4802,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
-	if (ret)
-		return ret;
+	nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
 
 	/*
 	 * KVM uses VMCB01 to store L1 host state while L2 runs but
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 85f64d9ebe59a..681e0ffec1054 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -771,15 +771,15 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu);
 void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 			  struct vmcb_save_area *from_save);
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
-int nested_svm_vmexit(struct vcpu_svm *svm);
+void nested_svm_vmexit(struct vcpu_svm *svm);
 
-static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
+static inline void nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 {
 	svm->vmcb->control.exit_code	= exit_code;
 	svm->vmcb->control.exit_code_hi	= 0;
 	svm->vmcb->control.exit_info_1	= 0;
 	svm->vmcb->control.exit_info_2	= 0;
-	return nested_svm_vmexit(svm);
+	nested_svm_vmexit(svm);
 }
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);
-- 
2.53.0



