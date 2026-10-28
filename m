Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215097;
	b=2TFiOzlMWvs3VBZB77d1CLEgjihd7HPqryqMeSySJotpUoXStzFSX3u2kZPCBAAAISzH
	 zswhGFpctvpU7bIkNrBulM/kDJKV4dbFJbgzuopQ2MbwgWaVWNTXUTclvAFBQEWMte7PM
	 b2gHSn29iZj5NRGGnL4EDA9fkI3aAhaZg36spIFpXRuzn9aE4nN6k5El7yW6JoNxhXPYa
	 rbLpLGJiYSTQ1eNEMz32zptg/rvAaM5Qr3VO34kiF9rLXx+HfzPtucNRtk7HEJdMzEwvC
	 qfqI9KITYUx2wIhQhhn9dd1hegL8DblKbcQVb+6c36Y2/e9+hJw0XFbQdWUCtX4iMdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cl2etKhJYzbMxjeTWc7vbyi05rBbXOMBomK+mMHCab4=;
	b=y/wVjhk/7I6ekmKarRVavpc8q88x+ivqKODCMoK/M/aWdw+mR8lCIq9DxfFsyjfGzGLi
	 Wmpeiwu5Viw0qWuJ2ktr98eu+vmO+S1JOrkNL+Ez8fzUy9x4PSoKxuVlaOIBKO3nVZlPT
	 ENSiGEEZLhAVPFsCx6bnhbOIfmohx04ILdCQsw44qoJzOaIZjB341mjj508966+72QFaT
	 EwxWGyVU6HBDM5KHwa52l+f3hjxdCh6zFAF36ZUGpNZqKdfEv5fvAF+aUGvI3YmnLBSQE
	 PBi38VG3aMbgTMuftBEKc6fwPs0hMsTrmQXjCBDwWtklEeb+u7UaPPzCH0so9ZrVCbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0OwNAhd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C707F606A31C;
	Wed, 28 Oct 2026 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0OwNAhd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240821F01825;
	Wed, 28 Oct 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215096;
	bh=cl2etKhJYzbMxjeTWc7vbyi05rBbXOMBomK+mMHCab4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0OwNAhdFMFQoRdJM4ejfcSt1mtZtFR0DOB7ptWYYWcuhcnkmtqvCLJu5ILduzSwJ
	 j0Q7wZ7GQ3YXFpL5C0T6W6axKSd9gS+wH3Tk6+6fE7RSajgg2RG/wnAoXif25v4hCT
	 63GoybTMLDzejUX6G1tX3LxUxyC7wuddAuGb/I2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1047/1887] KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
Date: Wed, 28 Oct 2026 17:52:23 +0100
Message-ID: <20261028170523.236793042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kvm/svm/nested.c |  3 +++
 arch/x86/kvm/svm/svm.c    | 10 ++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 313f9e952d6a8..a35fc16ba3841 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -589,10 +589,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 */
 		svm_copy_lbrs(vmcb02, vmcb12);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 		svm_update_lbrv(&svm->vcpu);
 
 	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(vmcb02, vmcb01);
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	}
 }
 
@@ -1012,6 +1014,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(vmcb01, vmcb02);
+		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d2a84597711ed..7b6110ca9f681 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -910,8 +910,6 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	to_vmcb->save.br_to		= from_vmcb->save.br_to;
 	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
 	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-
-	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
 static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -925,8 +923,10 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
-	if (is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu)) {
 		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+	}
 }
 
 static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
@@ -943,8 +943,10 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
 	 * on nested guest entries.
 	 */
-	if (is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu)) {
 		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_LBR);
+	}
 }
 
 static int svm_get_lbr_msr(struct vcpu_svm *svm, u32 index)
-- 
2.53.0



