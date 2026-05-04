Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799341A6827;
	Mon,  4 May 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904113; cv=none; b=dx7/AP2FeFcmekl+z/Ggulw152NzkkYipYOfD+YY/LkECDui0ZFpEDYvGQOepUYO7RBXGWwKOuj6CDeysu9vybpEfjdlB3wR6nL/jWxSxHE6g000Yhtu1C3Qfk9rfLr9jrlAW7djqYGBsMrlGbaCNA7K8Thyf3VREDbtJ4zXW5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904113; c=relaxed/simple;
	bh=3NKZBCxEGILHMrKgM1M1gV6xd3QLcupOmdqk1o9JMWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWP2AqhjAdyMeZ+FR6bkBYS12uF9WVKHXJrHbVHGvJcYva1fJkotqTYayBnLk6ScDZiPyX8XUkPomDEA8xGbdmveSq1aVT3udd1EhQ+FCUWwR66paquLsERLLRTFFv9Fas9uQosTLnOfooJ1RjpKopbsPOh8fl7l2m39HG1DHr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBNCa9jC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBNCa9jC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1092FC2BCB8;
	Mon,  4 May 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904113;
	bh=3NKZBCxEGILHMrKgM1M1gV6xd3QLcupOmdqk1o9JMWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBNCa9jCPGrs59dWfBg+G2jBK0MbNb93wt+1nyRAQgyxmoWiikjhoPtRZwlZ8sTP8
	 7G//DrHYheY38Lj44flulRK+iZVdTX0jVV+GRBujEPCbSaSWrBGwbDnNcpQDyYDvGx
	 piMM52gUNApltfFRE7LF6sdbiDAlSVm5BCfdrYlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 187/275] KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT
Date: Mon,  4 May 2026 15:52:07 +0200
Message-ID: <20260504135150.023003633@linuxfoundation.org>
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
@@ -992,6 +992,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		vmcb12->control.event_inj = 0;
+		vmcb12->control.event_inj_err = 0;
 		svm_set_gif(svm, false);
 		goto out;
 	}
@@ -1137,9 +1139,9 @@ static int nested_svm_vmexit_update_vmcb
 	if (nested_vmcb12_has_lbrv(vcpu))
 		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 
+	vmcb12->control.event_inj	  = 0;
+	vmcb12->control.event_inj_err	  = 0;
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
 				       vmcb12->control.exit_info_1,


