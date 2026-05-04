Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090903DEAD3;
	Mon,  4 May 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904675; cv=none; b=Wvi9z2ouC1Ia31AbKEah7HFmu5gLn7iJJNSkUA3xP6DUlMRkXYrFWSTbo/XhWtIYeXpBikAXGjXKR35laZ3yxhYw6u6mWHazBaxbStjVyavmJXDZ4A6hRN8FINeJdDIhKvpyH4wnHcxwOIK0itqKUm0j8Uq7bMCRuF/Fe0FPNe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904675; c=relaxed/simple;
	bh=Y7TzdW1EEtq1G9NqYBVw7GB/PkxaWoMxz4XPUVZxco0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE4Nytx5bPKyRPys87FA5pX/ay4ggCNtc+P5GU4xJQgOauRwSn7BnbUaz/oOpX9sdtL/C5RqukKG787M8aivz2IM0kor/vdYjfnyKNBKJ25TTdsltWqjY0oUI7iu8LpVC+lRrzxh7OCCfm9FeYZc0Q8NumLC3ZRRpXVsfZLMT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF8Ht9vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF8Ht9vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616E9C2BCB8;
	Mon,  4 May 2026 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904674;
	bh=Y7TzdW1EEtq1G9NqYBVw7GB/PkxaWoMxz4XPUVZxco0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF8Ht9vgiVLF1q4fmkLTqsubxmU9W1ZDAwNVjcLYTKVHHW+ZKn5DcKBWHuXFvEUIM
	 +O1IXoonrT1Xho5brZv5XXl1shbgGxHBSRxO7SHDdrZDtz1NFS4k4xHRQNwJ6/t/cp
	 tqR8nhnFh+Hq8hUQoyHGM/euxt/VxwLQRwnw3fxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 129/215] KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT
Date: Mon,  4 May 2026 15:52:28 +0200
Message-ID: <20260504135134.861987215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -915,8 +915,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
-	svm->nmi_l1_to_l2 = false;
-	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 	svm->vmcb->control.exit_code_hi = -1u;
@@ -1156,6 +1154,10 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	if (unlikely(vmcb01->save.rflags & X86_EFLAGS_TF))
 		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
 
+	/* Drop tracking for L1->L2 injected NMIs and soft IRQs */
+	svm->nmi_l1_to_l2 = false;
+	svm->soft_int_injected = false;
+
 	/*
 	 * Un-inhibit the AVIC right away, so that other vCPUs can start
 	 * to benefit from it right away.


