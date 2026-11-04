Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829116;
	b=dUDhExYto1dfoEPilyEKyhlSzN6rxIy2uaoiZ51uoESCwJUo7sid6elh70+eU0D2TdQD
	 z7xUOdR7so8PODcnzMgV5rjWFw8ufGvgd7Gjhx9yNrf2zfEgMEgFEJlho5F50a+7hryvJ
	 XywlS6Y8o9a+ZM2PYYEgFRYhx73uSl5tEii6FPFmZo0f0rjiVsLlK1xJ0Ugm8H32Sw5rX
	 H40/TuMb7gMs3WMHLE4hClMg+tR+FkZEJzfb0f7iop9uTTHCSUm597Tc09fe0oKeUv6UM
	 Zl+glWBQu0189U8NFD6ilZ2lbvPdGvP9Tj70Dg7ztya9Uc3qgDYtZG1vMCHqbVcGRkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDTDgWtO7XZWYcWSYzM3mC5d6jCM4YyvOjTxO+mfFi0=;
	b=PSESsLcztQqnkVLUTtFRiyMzL0omH9dVj3YIritGVY1aZTBQS+JfjbK4AU8+RmPFsbcI
	 8mSZTIG7MvBkfwpBDXWCV4uu46tT2vmskVmtlJ6QfcY9jded/zPYeivIIodQILISLVhYm
	 gq/F6ibMsfbimcasfa3UE52+Y3PfFWd34zmveMeuKLJyUqK3MklJqgbmvnsa0uPfwzbXK
	 JuswyFyX224cmJr8yJUHHFofcONGtp/lOO49LpDb1xRra37bwN49Ccl9nOrgpZKTtRhNd
	 ZXEoNuFdXXcuBK7C5QZWl3TmUCah4v1neLLCGCOFGt+wcO5Vdg1ykBoPeII7NsQnRrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quRtcgLq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808266082BCA;
	Wed,  4 Nov 2026 21:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quRtcgLq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4541F000C1;
	Wed,  4 Nov 2026 21:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829116;
	bh=xDTDgWtO7XZWYcWSYzM3mC5d6jCM4YyvOjTxO+mfFi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quRtcgLq66sk/w88kq2n6xKEmn7dzQC/hsKuSvoTTMXPDBktR25ug1OCniAbS5L2O
	 87MPYqlNGRLoNxxrP95AkxvLsOAmxE7rU+b7WyKtBvxv6CiUJgctNVo+kSTZtdFkjv
	 Pw36qsa0NoPujzaEuJWb/kmIgIViqI7JkP6L086Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 456/547] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Wed,  4 Nov 2026 16:10:40 -0500
Message-ID: <20261104211051.306433566@linuxfoundation.org>
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

commit 5dc500a354cc8e109df678076ae3488094649468 upstream.

Reject KVM_SET_NESTED_STATE if the incoming L1 host state has what is
effectively an impossible EFER combination of LMA=1 but LME=0, i.e. if the
state says long mode is active but not enabled.  Unlike VMX, SVM doesn't
have an explicit consistent check for the illegal combination; presumably
hardware simply ignores EFER.LMA if EFER.LME=0.

Unfortunately, KVM doesn't ignore EFER.LMA in this case and consumes the
illegal state when constructing the shadow MMU for L2.  E.g. if userspace
also clears CR4.PAE, then kvm_calc_cpu_role() will compute a role with 4 or
5 levels of paging, but shadow_mmu_init_context() will wire up the MMU to
use the paging32 template, which maxes out its levels at 2.

Note, the "real badness" is effectively the same as what happened with the
nVMX bug fixed by commit 112e66017bff ("KVM: nVMX: add missing consistency
checks for CR0 and CR4").  Unfortunately, the sanity check added by commit
72e2fb24a0b0 ("KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode
without PAE enabled") doesn't work for this case, since L2 state is active
at the time of the page fault, but it's L1 that has the bad state.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260902232028.2767071-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -2029,6 +2029,7 @@ static int svm_set_nested_state(struct k
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !nested_vmcb_check_save(vcpu, &save_cached, false))
 		goto out_free;
 


