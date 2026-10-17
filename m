Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9617BED0;
	Sat, 17 Oct 2026 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258671; cv=none; b=nbeL6HJadHhIRS8w6TGRVojxhxvCtc2vUnyqHRdGaPki0ZIutVqFli5wc1nN0rMMFOaw9dIUn4jYPI+pMpkxKZDCmm8laRzJQYrMXU5ylwXbRSqe1Mo3H+WrdFBXASlH71bJ1KpR1CqBa6vV55DT6MfvN82LycoPQDO/zrvnrNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258671; c=relaxed/simple;
	bh=pwPdNt/AnVPb+v39PNWIhPD3Y9X5ThVKzkg+CcnODQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihw2cm9CXQNQzcHwCZr2AgvppVte2vc3HO5zC6YjUB3skdT+768FMVbPkSB4ovk933lVM1GV3lF8A/Lbf76BTOTuu0LSjUHxGv4HQ9gy2Eb9Ihi7sp0p4AvZ4+iSMhNXQmsg66P3bI2UNuGmgQUPChn0yJcJQzI0FgjWePz/21k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWaLdZOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWaLdZOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DEC1F000C4;
	Sat, 17 Oct 2026 17:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258670;
	bh=Xf1lgiUMcsp2pCnlFczgN3TgUAbCF5f7D0s4ARrru6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWaLdZOEl/0eQOfAMEkI2HcjV76g44KGt2OViUewT03rK4nq55tJTrhbGVFPJmy79
	 AKtLbP1XiAyJL7uh+R6V4DKE/AcptaA4QL0BfZ9lXNBAwReg5wkQk7oebU1csENMAi
	 CibETkP1sUwtemh4O95Ezx2XzBPw9qEBCgtVjYoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0960/1674] KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
Date: Sat, 17 Oct 2026 17:53:52 +0200
Message-ID: <20261017160455.768577284@linuxfoundation.org>
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
index a4d5b79811330..bdcfcc492dec8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -626,6 +626,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	} else {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
+	vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	svm_update_lbrv(&svm->vcpu);
 }
 
@@ -1088,10 +1089,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
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
index 961ac6b55e4f8..df8bc8def019b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1003,8 +1003,6 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	to_vmcb->save.br_to		= from_vmcb->save.br_to;
 	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
 	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-
-	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
-- 
2.53.0



