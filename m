Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309D17BED0;
	Sat, 17 Oct 2026 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253925; cv=none; b=NzDtQxidxbQnskF8T6B8f19kWFuSgC/iIW1urELS41fpPm5xRwUHkqXWbjvW014fwwOzBA93v9oxUvr63oMR/HnBm2U49KvbLyxbxR5QsMhgT8/EHS/6WEv4hLYv7DVYhzfpiD09ce9V/fK6ZAtnYXP3YRGysZdSCRZ++hhIuI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253925; c=relaxed/simple;
	bh=X1motj4ihvoWnEtD7lZDxSdsFgWfFba2hKJBxhH1Tq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQHo0RKRAb3DVKVtJIX7WPw7pL7WfelW8xWxdCyMblRzw2ILoOd1/ySiqGQDATo21U8NPVlz7PLZcNPReLj6S6xdkiek/Lo0p+RpqGx7mXaF6uxOm73SUu0sdTq5OAeJV5rdbWxA6RiI8iXKdj3KOzTtFDj3A+nj0xaXbwSbCiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8rqkJHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8rqkJHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57F1F000C4;
	Sat, 17 Oct 2026 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253924;
	bh=JcrJDQO3oWiBAUNAsjbyhgw7IwzTFkRO3PaLYjI99qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8rqkJHxIf3qXtZfLWrVzfQKdWpNuPiFYX8jYADgFidNKJ4Msj/mSDv60omsinLkx
	 g3kpLoF1VZEtxNJzfoeVdvvkjMbQsvbS27Dq1C/NnXu7fhPhFGQDepQFhNw9H31d5p
	 tQusFeUeUEwraNJpipSR2gV0Zp/gj1vXmAqSBKRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/869] KVM: SVM: Add missing save/restore handling of LBR MSRs
Date: Sat, 17 Oct 2026 17:51:58 +0200
Message-ID: <20261017160044.173795370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 3700f0788da6acf73b2df56690f4b201aa4aefd2 ]

MSR_IA32_DEBUGCTLMSR and LBR MSRs are currently not enumerated by
KVM_GET_MSR_INDEX_LIST, and LBR MSRs cannot be set with KVM_SET_MSRS. So
save/restore is completely broken.

Fix it by adding the MSRs to msrs_to_save_base, and allowing writes to
LBR MSRs from userspace only (as they are read-only MSRs) if LBR
virtualization is enabled.  Additionally, to correctly restore L1's LBRs
while L2 is running, make sure the LBRs are copied from the captured
VMCB01 save area in svm_copy_vmrun_state().

Note, for VMX, this also fixes a flaw where MSR_IA32_DEBUGCTLMSR isn't
reported as an MSR to save/restore.

Note #2, over-reporting MSR_IA32_LASTxxx on Intel is ok, as KVM already
handles unsupported reads and writes thanks to commit b5e2fec0ebc3 ("KVM:
Ignore DEBUGCTL MSRs with no effect") (kvm_do_msr_access() will morph the
unsupported userspace write into a nop).

Fixes: 24e09cbf480a ("KVM: SVM: enable LBR virtualization")
Cc: stable@vger.kernel.org
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-4-yosry@kernel.org
[sean: guard with lbrv checks, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c |  8 ++++++++
 arch/x86/kvm/svm/svm.c    | 42 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c        |  3 +++
 3 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2d81f1cb4ca7b..95698c1da833d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -959,6 +959,14 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 	to_save->rsp = from_save->rsp;
 	to_save->rip = from_save->rip;
 	to_save->cpl = 0;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_LBRV)) {
+		to_save->dbgctl = from_save->dbgctl & ~DEBUGCTL_RESERVED_BITS;
+		to_save->br_from = from_save->br_from;
+		to_save->br_to = from_save->br_to;
+		to_save->last_excp_from = from_save->last_excp_from;
+		to_save->last_excp_to = from_save->last_excp_to;
+	}
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9408ab965aeaa..21f74cea2b05b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2966,19 +2966,19 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = svm->tsc_aux;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = svm->vmcb->save.dbgctl;
+		msr_info->data = lbrv ? svm->vmcb->save.dbgctl : 0;
 		break;
 	case MSR_IA32_LASTBRANCHFROMIP:
-		msr_info->data = svm->vmcb->save.br_from;
+		msr_info->data = lbrv ? svm->vmcb->save.br_from : 0;
 		break;
 	case MSR_IA32_LASTBRANCHTOIP:
-		msr_info->data = svm->vmcb->save.br_to;
+		msr_info->data = lbrv ? svm->vmcb->save.br_to : 0;
 		break;
 	case MSR_IA32_LASTINTFROMIP:
-		msr_info->data = svm->vmcb->save.last_excp_from;
+		msr_info->data = lbrv ? svm->vmcb->save.last_excp_from : 0;
 		break;
 	case MSR_IA32_LASTINTTOIP:
-		msr_info->data = svm->vmcb->save.last_excp_to;
+		msr_info->data = lbrv ? svm->vmcb->save.last_excp_to : 0;
 		break;
 	case MSR_VM_HSAVE_PA:
 		msr_info->data = svm->nested.hsave_msr;
@@ -3258,6 +3258,38 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;
+	case MSR_IA32_LASTBRANCHFROMIP:
+		if (!lbrv)
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_from = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTBRANCHTOIP:
+		if (!lbrv)
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_to = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTINTFROMIP:
+		if (!lbrv)
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_from = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTINTTOIP:
+		if (!lbrv)
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_to = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
 	case MSR_VM_HSAVE_PA:
 		/*
 		 * Old kernels did not validate the value written to
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99549df4c633d..842e4af926302 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -320,6 +320,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP, MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP, MSR_IA32_LASTINTTOIP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.53.0



