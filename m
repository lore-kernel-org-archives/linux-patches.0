Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79DC3B27EA;
	Fri, 15 May 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860857; cv=none; b=pkWMxAbcsOatve9mZsfCbYnzVOSSa/IGwkDtj/Y/3poIn02UfcSu5v2hZETJuY8oPxwAapLonQPHUlPb+iTGmJB5AEyY1V8RAWKNJuqadZJlr00MC2EwXD/2Zkd3gRi9cS3V2W3xmNzVJLAJEanS0A6gwYbwAGucsjWg51hGDLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860857; c=relaxed/simple;
	bh=i5NEPIYx4QOvlw4HNa65Ekg/gT4B4sCs+oyyIWdd9Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hD7VQtHJQWyTO9KTYsrlinWMp7Q0uu9V00wNpcG+OYICJkrqYE/zwg+Q+RZNawJfAaw1oNw8OOFBcGwrFYjYhZVLnEYMnw9bTj6DMoQMfd4OzNHeoRbT9Ys1NgB8b3LWSqri9r2Awailmn+dhGx6uBfr3ZjcLezkXVxMluWqPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6s2nOFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6s2nOFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E454C2BCB0;
	Fri, 15 May 2026 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860856;
	bh=i5NEPIYx4QOvlw4HNa65Ekg/gT4B4sCs+oyyIWdd9Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6s2nOFsIwDXL6B6Yq0JAbxNNFJ+5bBKr1G+m4FE8BHREO4uh4ArM+FvDW5rl6I2l
	 nLL6pqFWz03c5RD409SqZCW9ZQhMRXbx5kF6LlM58a6sj2l1Abks8KprA/VDTrODy9
	 32jqPIYZVoBt+Jcs1NX0+/Ktbrx2FviQTO/oL+t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 104/474] KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT
Date: Fri, 15 May 2026 17:43:33 +0200
Message-ID: <20260515154717.287439822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -884,6 +884,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		vmcb12->control.event_inj = 0;
+		vmcb12->control.event_inj_err = 0;
 		svm_set_gif(svm, false);
 		goto out;
 	}
@@ -1025,9 +1027,9 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
+	vmcb12->control.event_inj	  = 0;
+	vmcb12->control.event_inj_err	  = 0;
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;


