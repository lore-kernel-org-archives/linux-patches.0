Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCB3AA9E2;
	Sat, 17 Oct 2026 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254118; cv=none; b=lnA7k4/DPc55XkSsZTMDuWrx3JOAAeaaFRgfBPp1wjdZX6c5JlGDzT+G5rdXEQm1g51dkQ2GPge7Uyet9HWfb0ugkna5M07GojnFS6Igpr3YY5clI7DMbpbkY9BUsGg2UdkCBsmwsVttyo5n07Fou4ScyZRkSFGQv839re3oQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254118; c=relaxed/simple;
	bh=Ksut667ty/m7505afbQf/bZnL0HighrpQcVL5N8UE3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io1+OlS2eXQGsXn7waJn9YmlVsN/NUQ1FlfMrhax/b7h15Bb5BuwJ6iUXcbNq+o7R8ERPwVxOImR3r79ZLg77b0jMmPfZVg/Srox3XTGFuUkdK50UKeFtUHJ942RxpwSCFgBsDcj4B7CbJ0Ii3QuuUa+fsofCJzyMYcv7USB9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i63ksqMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i63ksqMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F01F000C6;
	Sat, 17 Oct 2026 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254116;
	bh=dh/qluu24ruW9/WEVrqBXZQ5LI854nPX0MM0DjQJo+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i63ksqMXlFGq9LmFyuQ22D87Fd6xZP2hUpi6FS31ye3PVjtXGGWVURnFN62O9Auo/
	 Sem/HvpbLkTH6MGusnIcCuYytgeUyi7YWgcC1S5iUQoKPkvIlzWFZzfgqmRU/KYHho
	 2DKQSFOB+jaxenDUy/tiDbcvBVm2UQzJ8k9xNnYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/869] KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
Date: Sat, 17 Oct 2026 17:52:07 +0200
Message-ID: <20261017160044.406738011@linuxfoundation.org>
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

[ Upstream commit b53ab5167a81537777ac780bbd93d32613aa3bda ]

svm_copy_lbrs() always marks VMCB_LBR dirty in the destination VMCB.
However, nested_svm_vmexit() uses it to copy LBRs to vmcb12, and
clearing clean bits in vmcb12 is not architecturally defined.

Move vmcb_mark_dirty() to callers and drop it for vmcb12.

This also facilitates incoming refactoring that does not pass the entire
VMCB to svm_copy_lbrs().

Fixes: d20c796ca370 ("KVM: x86: nSVM: implement nested LBR virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 7 +++++--
 arch/x86/kvm/svm/svm.c    | 2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2f98a90537d28..636f0354fa815 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -621,6 +621,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	} else {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
+	vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	svm_update_lbrv(&svm->vcpu);
 }
 
@@ -1091,10 +1092,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK)))
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
-	else
+	} else {
 		svm_copy_lbrs(vmcb01, vmcb02);
+		vmcb_mark_dirty(vmcb01, VMCB_LBR);
+	}
 
 	svm_update_lbrv(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3e2af127a4e27..4c3891fb789a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -990,8 +990,6 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	to_vmcb->save.br_to		= from_vmcb->save.br_to;
 	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
 	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-
-	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
-- 
2.53.0



