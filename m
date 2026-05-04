Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4C3DDDDA;
	Mon,  4 May 2026 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903406; cv=none; b=GPVn/qR/XB/9OSRiMqAoBRtWrIUutJrMqgwT4ZR5xyLhnTKvLGUAD7fOmVYzm+nPU+KuXPjotll+VC0JC68n9B2CNxNwB4CN1P+9w/euon8sMg6rxgo8JsZNI7stUBgPIQpvjsrpT6lXV6wJfN0tf7AE0MUQMvnmV6MIt7dVxKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903406; c=relaxed/simple;
	bh=3GidTrf8t3bbOGf3X+wBEhg52hTQ6T5apVjdDNa10Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wapa5Wiydqijm1kLPbxSPaeAEH3/bamc9AOpZNeWCu13feJvvDgT4wAW+RO7WI+nGKRe9FvxEGM+K4zjcl7jWH7SdLRz0vcL6oYrKmJ5P++uSbPSoesTkjThgf5ye9uTN21h5vKfr6/qSuSH/yyQ/KZb1+6CBqd0q5j4LV+vzTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmpfuOgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmpfuOgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4A0C2BCB8;
	Mon,  4 May 2026 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903405;
	bh=3GidTrf8t3bbOGf3X+wBEhg52hTQ6T5apVjdDNa10Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmpfuOgxL5OKiWJ0qLmtfhlVM0KSaZ6js8aZ04mrjAWrjepzKuokDcpbq4lYTgv+j
	 wxoIm4U0iumAAkbMeqhvg26GEnGn6T/ieKYgknraOt+e4vQ+3OTrxZ+dUnxszCxaXz
	 TLy2dQs83Ce4FquA7ePD3EYSqe/Rr5M4x9ViOxmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 222/307] KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT
Date: Mon,  4 May 2026 15:51:47 +0200
Message-ID: <20260504135151.215104911@linuxfoundation.org>
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

commit 69b721a86d0dcb026f6db7d111dcde7550442d2e upstream.

According to the APM, from the reference of the VMRUN instruction:

  Upon #VMEXIT, the processor performs the following actions in order to
  return to the host execution context:

  ...

  clear EVENTINJ field in VMCB

KVM already syncs EVENTINJ fields from vmcb02 to cached vmcb12 on every
L2->L0  #VMEXIT. Since these fields are zeroed by the CPU on #VMEXIT, they
will mostly be zeroed in vmcb12 on nested #VMEXIT by nested_svm_vmexit().

However, this is not the case when:

  1. Consistency checks fail, as nested_svm_vmexit() is not called.
  2. Entering guest mode fails before L2 runs (e.g. due to failed load of
     CR3).

(2) was broken by commit 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB
controls updated by the processor on every vmexit"), as prior to that
nested_svm_vmexit() always zeroed EVENTINJ fields.

Explicitly clear the fields in all nested #VMEXIT code paths.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Fixes: 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB controls updated by the processor on every vmexit")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-12-yosry@kernel.org
[sean: massage changelog formatting]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1045,6 +1045,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		vmcb12->control.event_inj = 0;
+		vmcb12->control.event_inj_err = 0;
 		svm_set_gif(svm, false);
 		goto out;
 	}
@@ -1188,9 +1190,9 @@ static int nested_svm_vmexit_update_vmcb
 	if (nested_vmcb12_has_lbrv(vcpu))
 		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 
+	vmcb12->control.event_inj	  = 0;
+	vmcb12->control.event_inj_err	  = 0;
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
 				       vmcb12->control.exit_info_1,


