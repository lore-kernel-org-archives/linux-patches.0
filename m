Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590059;
	b=z5zZkPZLbKMzjNsPITZiFJWkc7OupswprqQLxNsV/UO/hxYDV2xZAMDqKdxRNcTjjM4u
	 SJtk/OQWvYAqrzb3xKkLoNKHYv3p7QvYyomZonclr8XQp8L0bTQox2GbdbGTvWdTx+NK2
	 nizdKInzs3OyL3R9JMzimlU951Gtoa9DNXRtrqwozy4YoqSQQHSx+ox1yKjb/YM2Pffla
	 QHpilfXreNI+7UUZzUB+d/CpNoGi8Tw1XGqlavtus0uI3LfJWJmnbCwG8iIrU3NnO0iIB
	 kdIAbmKY4k2EJuECQGLDW6ECGp3UUT9mk3Kil1DHj2FCfF1VUd2MJTcCqQLMMJaFTMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6CbMhbeETl/upDxMLf8qmRwUURZomD/qJoeF+IrTNEU=;
	b=CAM0Pil2U6vL/Co++GmSm+JRvF15xsbYx+82ec4K0TRJmcO/uq8amcQBd/87YsnDmU41
	 B8vUzMaBvrPLo+xpWn7fEA1mVTGUHZIYvcSkha9bFlJtq9y4XzvXusY90iKSNY0Nid44W
	 Lh1071vLuUPUvAyp0j4K0NdVixi3tDWYBT5esGOODDflZETiX+vM2gN8cxGtouHMKG7Fb
	 nt6QkCpmHY5FGXxrtcGJ4kUc6Bi3/++qHoZrEYyk5HmAa6lXJJ95CX14gxWomhXYjRQup
	 scMP6t5/t20JvsrTwgFZwrEnsr+uAsRShf/iegDPX1Ltt5BO/+Chgx41uePeLj5OA8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKEtZ10e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E8D606A886;
	Fri, 13 Nov 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKEtZ10e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB111F000CB;
	Fri, 13 Nov 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590059;
	bh=6CbMhbeETl/upDxMLf8qmRwUURZomD/qJoeF+IrTNEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKEtZ10eiPgj4eaRCbLNeZM/C3w1PmYXShdhl2AFzln9GQPoouQZUeKarPNQVfSrQ
	 0LAwvJzHeUoANls86xlY+yBAIgjywWYJaM+4Kn8pH2HTHT88O/3QTYEKj0o6Lk48mr
	 9rX+9682gxRMyqPQHLzLzgXhMJTeWaFRIeJ1poi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/686] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Fri, 13 Nov 2026 10:43:03 -0500
Message-ID: <20261113153822.658602815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5dc500a354cc8e109df678076ae3488094649468 ]

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
[ sashal: adjusted context to retain the two-argument __nested_vmcb_check_save() helper instead of nested_vmcb_check_save() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 064a2bb9cf8ed..49cc457a4c370 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1880,6 +1880,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !__nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
-- 
2.53.0



