Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DE33EDE44;
	Tue, 12 May 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608291; cv=none; b=VsXNx9BHvnCIlNV6cryGurWyfzyylguiGKd6647d+8fZ8orooBCf5QdwuzZpVTU7aMXq3q1WfgDqQb5ocxduqPnqktKLskq6bUUwoyWdVocx2gkTOLu0nDhY6Xq59MdzTb95xWTG44DLkW9D3skMXsS6SBNMtUWte3sZQb3BQLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608291; c=relaxed/simple;
	bh=kwckheeuVwRKsdQMIqoAYK43WdH3vbwbo+ckrQsvEv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHYVqs+3P+MnV+r3R9Mfi39ZcLbDgtxLY6tXOikmvYTd9YlwFtC0E/q1EWldMbtEF2v5isf+TTMJd7/uRfgxY90a85vCe98e+lPi5Znwy3VU0WezSr9GQVyxoxG8UM1pwx4OU7ZDcvUfXO+v7QIGqLa06XYW+zg2dbxL9ym2tlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePqG9K4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePqG9K4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AB8C2BCB0;
	Tue, 12 May 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608291;
	bh=kwckheeuVwRKsdQMIqoAYK43WdH3vbwbo+ckrQsvEv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePqG9K4lJm2HN5JTZN84K1hPuEkyg03ZT5fbVxOhnUTDK+PEFj68uSyHgZ5RX48jN
	 YStPp04fl66vKJkfoA3Nbco4t+uIqiqxhn7kbAkgaPFU4n36JAMQiOh9cDxGcxphjR
	 oDxGOvDFJXaOgBOaOuaHicR0xB4g5olKB03VWvLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 022/270] KVM: SVM: check validity of VMCB controls when returning from SMM
Date: Tue, 12 May 2026 19:37:03 +0200
Message-ID: <20260512173938.925077719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -484,6 +484,15 @@ void nested_copy_vmcb_save_to_cache(stru
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
@@ -990,8 +999,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
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
@@ -4885,6 +4885,10 @@ static int svm_leave_smm(struct kvm_vcpu
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
@@ -782,6 +782,7 @@ static inline int nested_svm_simple_vmex
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
+int nested_svm_check_cached_vmcb12(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);


