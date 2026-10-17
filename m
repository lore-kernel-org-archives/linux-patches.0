Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B23C0601;
	Sat, 17 Oct 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260498; cv=none; b=EMyXDf7oC5C4SJPkHxZHO/GSBaxTl0ibpUcHyIVxrhmUkGrsJmIJXcnXEWaRFIItNyi80boHwauRuBdzJ2+WxpscvYdgocT855w6J7Vu+gwihXqJcWm6TuDMTkI7CdqGbCL09+GPBCJUfWrlKNPMx9pv0TFHIm1eO5TcDOwhgpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260498; c=relaxed/simple;
	bh=5NjXOHxM6WZcDDHDXvQa+BYz/7IFsZnDKJbEA7NqcQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZpdEvrrOP/MHX74kQx3bNH7XyLqwXGbpwXK/z44HHC4vWexdxgA7aHVKD1C81eHSnwz+b26GEKT1YUS09l/a64jEexsy/59bc7yqL6z9TPcaXdnV7Bjtw66hCuGLb/Xvm1shFpk7c/6bruv43flJO4FgBvfmzAbxGjoNn7ppec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYwEQ12A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYwEQ12A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418801F000C4;
	Sat, 17 Oct 2026 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260496;
	bh=kbE1Yjve5xop9oOLboSVyHwwkEW/+TRvkzqclXhVzIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYwEQ12ATlb0ftfuZuDwgTOerypmslYNYeCMo8JGYj4NQOmSOBdETWJIqzsCAK5bf
	 orx4qDVOFGAzk8cEbbI4kSsW6Vn8+aBY4HpWoiJiOpqdHRR5e3EN8JqvYpxe6sDPYS
	 vGxqUTWbXVgKnVCdt7zeMicF47tnAnVs7NdoU3fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1564/1674] KVM: SVM: Add missing save/restore handling of LBR MSRs
Date: Sat, 17 Oct 2026 18:03:56 +0200
Message-ID: <20261017160511.243652577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 arch/x86/kvm/svm/nested.c |  9 +++++++++
 arch/x86/kvm/svm/svm.c    | 42 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c        | 13 ++++++++++++
 3 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 432d188b2f3c9..2e4db6602db11 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -973,6 +973,15 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 	to_save->rsp = from_save->rsp;
 	to_save->rip = from_save->rip;
 	to_save->cpl = 0;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_LBRV)) {
+		to_save->dbgctl		= from_save->dbgctl;
+		to_save->br_from	= from_save->br_from;
+		to_save->br_to		= from_save->br_to;
+		to_save->last_excp_from	= from_save->last_excp_from;
+		to_save->last_excp_to	= from_save->last_excp_to;
+		to_save->dbgctl &= ~DEBUGCTL_RESERVED_BITS;
+	}
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8844f49d3e7f8..832886bec53d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2903,19 +2903,19 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3191,6 +3191,38 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
index 313fce77e0589..cb659d04d07ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1473,6 +1473,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP, MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP, MSR_IA32_LASTINTTOIP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -1914,6 +1917,16 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
+	if (ret == KVM_MSR_RET_UNSUPPORTED && host_initiated && !data) {
+		switch (index) {
+		case MSR_IA32_LASTBRANCHFROMIP:
+		case MSR_IA32_LASTBRANCHTOIP:
+		case MSR_IA32_LASTINTFROMIP:
+		case MSR_IA32_LASTINTTOIP:
+			return 0;
+		}
+	}
+
 	if (ret == KVM_MSR_RET_UNSUPPORTED)
 		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
-- 
2.53.0



