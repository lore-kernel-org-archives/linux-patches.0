Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B111A6827;
	Mon,  4 May 2026 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904236; cv=none; b=a10WOyod+Tmgc+yrp9xSVXvdi57uJHV8dQRiISKOkdDAcjKwneagp37jRPbRr7VyskhVokRyaKP0CwUT3cCBhiKLRvf+6y59xiLNhOtMxVX5NL04Iazo4qvysMwRp1+cuPpqU0zDhNbgyHIYjTLEYwhptBxIunuURX3BPoC8KlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904236; c=relaxed/simple;
	bh=6SPqRyDTUveaaTCyywob/awJC5BnV/XFO7o+9q8nFOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGAq1CUNBQRHHhuheK+ZSqTo3vyTsU+1cMAk1V7foA7mG12WLlOvIvnm6FLDKJ2DtU9LB1COow86KR7zfFPL5346riH/2oGWX11mvxE5tApwkE4wPqRj01Oz6y6kncwT6qqR/XQtD/GLHtSQoKxZqJfsSm6NazF7kIozUguNnBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9wbOafD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9wbOafD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE6EC2BCB8;
	Mon,  4 May 2026 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904236;
	bh=6SPqRyDTUveaaTCyywob/awJC5BnV/XFO7o+9q8nFOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9wbOafDQACQbYX50ZUm7WG531RNFg+IyHTqVEEZMzsf6palYpUfcr3ofGuY/sCO5
	 TmWH96CaO7nMpXwWOM/+5dVvafknpGJbtxxNwDeQXeFmhAGr2b9RcdOll4CgNuc76F
	 v563qEqJ7SX3V9ZBZs6nWAZdSvKm9xOA1RP/j/g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 193/275] KVM: nSVM: Always intercept VMMCALL when L2 is active
Date: Mon,  4 May 2026 15:52:13 +0200
Message-ID: <20260504135150.248166214@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 33d3617a52f9930d22b2af59f813c2fbdefa6dd5 upstream.

Always intercept VMMCALL now that KVM properly synthesizes a #UD as
appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_INSN
is enabled.

By letting L2 execute VMMCALL natively and thus #UD, for all intents and
purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM always
intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
VMMCALL in response to the #UD by trying to fixup the opcode to the "right"
vendor, then restarts the guest, without skipping the VMMCALL.  As a
result, the guest sees an endless stream of #UDs since it's already
executing the correct vendor hypercall instruction, i.e. the emulator
doesn't anticipate that the #UD could be due to lack of interception, as
opposed to a truly undefined opcode.

Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL into host")
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/20260304002223.1105129-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/hyperv.h |    4 ----
 arch/x86/kvm/svm/nested.c |    7 -------
 2 files changed, 11 deletions(-)

--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else /* CONFIG_KVM_HYPERV */
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
-static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
 static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 {
 	return false;
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -159,13 +159,6 @@ void recalc_intercepts(struct vcpu_svm *
 			vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
-	/*
-	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
-	 * flush feature is enabled.
-	 */
-	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
-		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
-
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		c->intercepts[i] |= g->intercepts[i];
 


