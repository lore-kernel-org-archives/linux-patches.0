Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829118;
	b=osUYKt9RyY4luK8YDFFk+jnSYXrdn702C4Ljnbx8xCD8/J1QU6LQY36fPRR4+120DYW6
	 +4DGKFIp/sOUMWnWD+nfHQX7csCVjehygo+uoawJ4NAqqHeaQ7DH5FnVzEj/Fziotb5L1
	 IgbPRFtqk2Xy98cHnRdpw0n9MGdkpUS+8IjVqYPJwYyHKRydprhH6TJTXkAiLKcboikru
	 TwnvDfSSgEBFq8p4PYpeuig1QazDFHtFIFzzmUmqDMu28+d1IxpTY1cZGbC9UmZEKjziK
	 hmcUNPSI4m+uDggh2Lp1BdJcC8oJZawqvKg1u+sJJnY1gEQICChu4H2GMD8ItqY6WdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DrqzXF6D/LErPAB2/uM4vVPeohvHQ7yy7AM9dliVAhA=;
	b=IZxRn3rtWSSmZ8BpwzI9bqgC1C9rIcW3EXvtf5UFa5FNrFZ2SH63akq3tSh+EQ5UhOrm
	 kAOhKSMSpZrrgVC7j//h6BDW1GOIyUy+rkd0l4X3KULFGIoMCPuTVEnDQR26LCLmcRUvE
	 I9QeEoH3LtYYGcBTXSOS8HlfVUwc6h+0Pmyc8Rd5/7/sASohY8t8LK5nDG9gjv3eL2F1Q
	 VzBW+84ny5XRxxqxnLfClBAJS4mXSf6a2pGGVAMRHWyqbL3Tjwz/61a+lS5PNVz+U85Eh
	 8oqcUjflmNpD+58Zlte65j4B5JTZsjUu/KIzaF/h99hYb+yglwqpXWMY4chapBCXRBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuJcHQB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81576083627;
	Wed,  4 Nov 2026 21:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuJcHQB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A05D1F000C1;
	Wed,  4 Nov 2026 21:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829117;
	bh=DrqzXF6D/LErPAB2/uM4vVPeohvHQ7yy7AM9dliVAhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuJcHQB2AURQHdWqfscPNrZVseH3FAWrAnOXS8LGnVs4gIIhLlMrnanf1j4ajKOgK
	 DGCrUVOddXwGTUG17jUwtZN2KoSLsOMRyeEt2s0jBWXWCuOuHay+/uRH/VQehNLDCr
	 OvXJGfnbH7sEFT+r3FdzXfjWGnfafLUoGOHPsoQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 457/547] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed,  4 Nov 2026 16:10:41 -0500
Message-ID: <20261104211051.332473846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 1c4c84a643b704e473cb171f7b61359ff29b12a4 upstream.

Force EFER.LMA=0 if EFER.LME=0 when preparing L2 state for VMRUN, i.e.
mimic real hardware's behavior of ignoring EFER.LMA if EFER.LME=0.  VMRUN
unfortunately allows the nonsensical combination, i.e. doesn't fail, but
KVM itself has an invariant EFER.LMA can be set et if and only if EFER.LME
is set.   Breaking that invariant can lead to a variety of issue,
particularly in MMU code that keys off EFER.LMA when determining whether to
emulate/virtualization 4/5-level paging versus PAE paging.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260902232028.2767071-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -789,6 +789,10 @@ static void nested_vmcb02_prepare_save(s
 
 	kvm_set_rflags(vcpu, save->rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(svm->nested.save.efer & EFER_LME))
+		svm->nested.save.efer &= ~EFER_LMA;
+
 	svm_set_efer(vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(vcpu, svm->nested.save.cr0);


