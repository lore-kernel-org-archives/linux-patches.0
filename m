Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005313DB96F;
	Tue, 12 May 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607754; cv=none; b=RobK9d0zjbFikrDk58vDD0v8Rd1Jve0tiNPIlz2TPlZoHuDD1EMNN+2PjplA2Xyt+UVyKo1Pc9EjrDJ8JWikZ52WA7G4E/uJuunkQyynZyQS/qOxosdEKQj1hua0hi0OabeRVOIBiqb0p3JqsoceCsvYmYMPw8X0rXbfDYMoGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607754; c=relaxed/simple;
	bh=Zwjb6lLpMjXOijZJNUjbQl3u9slG8S2JAmWK8eHZOk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kf+baVGI+kF6LAZmhVVb9yCqLckf6goTNv0xjAsy3T+2f0d7CHiaE3LnwcZbxyxsytU5KmBtwNrv8YoZT3nNfCK9O8Hu9OSCAt7Wk54aEx+qA8RK30JU/JkGsVtJ/MgWawJQsouyyEVbg4X/1cQ9h7zz1B+okHM9ODO2zxAPVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7jhAEXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7jhAEXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46062C2BCB0;
	Tue, 12 May 2026 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607753;
	bh=Zwjb6lLpMjXOijZJNUjbQl3u9slG8S2JAmWK8eHZOk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7jhAEXnuLlcToH02pWuhwfXoEDQy//Nvmt4qFTSaEHh32PNYyjypTo0Q1o9Bgotu
	 cLdPmULlHM2SGn1Txw4gHlHQQbMvidxERxADr0xSbW5jV7H9bTW70mors/6AHrT7DT
	 xGRTZXwgD8pS9W2SiaHdLgL+7VEaXJOThLnsvlBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 023/206] KVM: SVM: check validity of VMCB controls when returning from SMM
Date: Tue, 12 May 2026 19:37:55 +0200
Message-ID: <20260512173933.316221862@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit be5fa8737d42c5ba16d2ea72c23681f8abbb07e8 upstream.

The VMCB12 is stored in guest memory and can be mangled while in SMM; it
is then reloaded by svm_leave_smm(), but it is not checked again for
validity.

Move the cached vmcb12 control and save consistency checks out of
svm_set_nested_state() and into a helper, and reuse it in
svm_leave_smm().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   12 ++++++++++--
 arch/x86/kvm/svm/svm.c    |    4 ++++
 arch/x86/kvm/svm/svm.h    |    1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -416,6 +416,15 @@ void nested_copy_vmcb_save_to_cache(stru
 	__nested_copy_vmcb_save_to_cache(&svm->nested.save, save);
 }
 
+int nested_svm_check_cached_vmcb12(struct kvm_vcpu *vcpu)
+{
+	if (!nested_vmcb_check_save(vcpu) ||
+	    !nested_vmcb_check_controls(vcpu))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
@@ -883,8 +892,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
+	if (nested_svm_check_cached_vmcb12(vcpu) < 0) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4934,6 +4934,10 @@ static int svm_leave_smm(struct kvm_vcpu
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+
+	if (nested_svm_check_cached_vmcb12(vcpu) < 0)
+		goto unmap_save;
+
 	ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb12, false);
 
 	if (ret)
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -672,6 +672,7 @@ static inline int nested_svm_simple_vmex
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
+int nested_svm_check_cached_vmcb12(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);


