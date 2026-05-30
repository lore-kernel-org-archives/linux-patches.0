Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064F632BF24;
	Sat, 30 May 2026 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160084; cv=none; b=lYi3HctIBORO6uEWrfPCqogXWoU5ueXIMqB5GmefX4rMCi2oDlzwIGN0MQfne+tWkZA4B+EbZIY8/xerqGPXI/WkGtBrKDfzyLFFgSpI5RhAjwYCg+owQXvejKtdOn5ACBHNWFL7gW6+m6usd9FnJqtm2zQPBOuBdHXQlEMY+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160084; c=relaxed/simple;
	bh=kTlM/8LT0FkPMcOZqSrXCFoQ13pQzEyPuUd36URSQoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIkIPr+lvrVTTeFvAcb0hJlGaCQtgJfgBCf+YxMkJn71SKm/glmt7gFs8+ayuD8cpbrjBR7iQsaAtHlsUKtlVII9OEdVmnFRAS/RvAfVL3NDnqHQxSTfrl9POZNYMhUVNod6YpBUpeK/iyC36dw8AfLbFsV8hKM/ibNTqSeQpNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqFwui+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqFwui+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C81F00893;
	Sat, 30 May 2026 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160082;
	bh=Y5t8frf5gCI7X1IGuLYz0pxgfVeXl3NmwlOfBtLiwoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqFwui+UyAjZ96rZQgxmxtjg/ZuAEhOoAm5nRYjeKE7hKr05Hh5Dg9mNvaLeGaSkd
	 YEPuFjCc7metILLMymNFssKX6hvH23BINJSyKT3vSND40T8BI+LYLoRHHjoFuCQm+k
	 X74vZHDwZU+fspY5fUuBFhMXqdEjbQQvncn4f1y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 241/969] KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT
Date: Sat, 30 May 2026 17:56:05 +0200
Message-ID: <20260530160307.113943326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 8998e1d012f3f45d0456f16706682cef04c3c436 upstream.

KVM clears tracking of L1->L2 injected NMIs (i.e. nmi_l1_to_l2) and soft
IRQs (i.e. soft_int_injected) on a synthesized #VMEXIT(INVALID) due to
failed VMRUN. However, they are not explicitly cleared in other
synthesized #VMEXITs.

soft_int_injected is always cleared after the first VMRUN of L2 when
completing interrupts, as any re-injection is then tracked by KVM
(instead of purely in vmcb02).

nmi_l1_to_l2 is not cleared after the first VMRUN if NMI injection
failed, as KVM still needs to keep track that the NMI originated from L1
to avoid blocking NMIs for L1. It is only cleared when the NMI injection
succeeds.

KVM could synthesize a #VMEXIT to L1 before successfully injecting the
NMI into L2 (e.g. due to a #NPF on L2's NMI handler in L1's NPTs). In
this case, nmi_l1_to_l2 will remain true, and KVM may not correctly mask
NMIs and intercept IRET when injecting an NMI into L1.

Clear both nmi_l1_to_l2 and soft_int_injected in nested_svm_vmexit(), i.e.
for all #VMEXITs except those that occur due to failed consistency checks,
as those happen before nmi_l1_to_l2 or soft_int_injected are set.

Fixes: 159fc6fa3b7d ("KVM: nSVM: Transparently handle L1 -> L2 NMI re-injection")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-13-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -864,8 +864,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
-	svm->nmi_l1_to_l2 = false;
-	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 	svm->vmcb->control.exit_code_hi = -1u;
@@ -1131,6 +1129,10 @@ void svm_free_nested(struct vcpu_svm *sv
 	__free_page(virt_to_page(svm->nested.vmcb02.ptr));
 	svm->nested.vmcb02.ptr = NULL;
 
+	/* Drop tracking for L1->L2 injected NMIs and soft IRQs */
+	svm->nmi_l1_to_l2 = false;
+	svm->soft_int_injected = false;
+
 	/*
 	 * When last_vmcb12_gpa matches the current vmcb12 gpa,
 	 * some vmcb12 fields are not loaded if they are marked clean


