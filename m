Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208343;
	b=ykit17U8TjexJTysWOtcdXE9IVafKk65RpjTdmT6wZPjZvVISlV8PW/hd2Np1KZNpVXP
	 31dK1gQ4WGK9/KPh+9b0nt+XSkjRufpjDM2ZpCFtiIfAsmRxROy13ycRnxP0LwCdPMBKB
	 B8RYqswuaPMIhgxlFUMN2yvXQ5VZMTHsX/E3bo3SOE+ZLRiWvXWepdHMj5Tt0Fg8UM3FE
	 VndVjaOHGwZtGrbfb2PzINwTnUmqDRuGNPDn9aLHxNeRzJbJ6KM1OGrV5IGzgUnr+mbU2
	 K66K3J0hM1ptxOeD5Ik43T4ac67i7zPEQ8QMRm5hb+BCXmfTHFW2wjdhBwSBwl/Y8OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WTnbybZTzr214hwM0jLmE06uoRW7CA0PL2pl7oJz/9U=;
	b=t3kLIUPgKwPLiXcHfITaDjda616JckbgZo08EqS5mQiRNrpJr0SDAWZmrNMG+tyYfExB
	 wjxsdyLh/esF/djBe8SFl/NJjiwcAHombvJBKRKUpzlK1dJ4wt5hAGCZAnJa0fMwBbhoN
	 hM0Vdcx3acEF3iDeGqSJBxYeOD7dVo3Kh4ho56a4Bln0roXBbqzqMiY1nRBRMwQ1UzZmv
	 J66KAd0tncOTac5ScC6g8QLVOZ6H3XHuGRKzBM+cA9gpD+DYh2X6R+Va5NgprNHVBQN73
	 nJuJfzA+PK3fAmnbdQ3JCDUL8nTBEvVa6RB8qVS4m390IOWGIWx407hdAW6V2r0aGUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvwAoAwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D45606A320;
	Wed, 28 Oct 2026 17:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvwAoAwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C861F01825;
	Wed, 28 Oct 2026 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208343;
	bh=WTnbybZTzr214hwM0jLmE06uoRW7CA0PL2pl7oJz/9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvwAoAwtdBSZQEwBnOch3xiMxAwxxV9QYppr7jU2LELQ+4qdGHBTJQJKgCtaEQUN/
	 OX7JusT66enMCkUYYb/NQs+Hncu0E1Wa3vm35zh1C+BicPuy++2xucPnWv+WNEd/ZH
	 SRmilvIFupBc5Ga2RZTV6KG9SMU9zJSltkPPZTdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 5.10 085/516] KVM: nVMX: Service local TLB flushes on failed nested VM-Enter
Date: Wed, 28 Oct 2026 17:53:57 +0100
Message-ID: <20261028170005.530113423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 05a0b701d1089fb57beeb8982f23c3bbafe0fa8b ]

KVM services local TLB flushes on "full" nested VM-Exits (through
__nested_vmx_vmexit()), but not if a nested VM-Enter fails (e.g. due to
failed VMCS checks in nested_vmx_enter_non_root_mode()).

However, it is possible that KVM had queued TLB flushes that need to be
performed, even if the nested VM-Enter was not successful. For example,
if VPID is disabled for L2 (via nested_vmx_transition_tlb_flush(), or if
via the MSR load lists, as the SDM says:

  If any MSR is being loaded in such a way that would architecturally
  require a TLB flush, the TLBs are updated so that, after VM entry, the
  logical processor will not use any translations that were cached before
  the transition.

The SDM is unclear about when the TLB flush should occur, and whether or
not a failed VM entry would flush the TLB, so it is safer to always
do the TLB flush in this case.

More concretely, KVM also updates the last VPID L1 used for L2 in
nested_vmx_transition_tlb_flush() (i.e. last_vpid), even if the VM entry
ultimately fails. With the current code, KVM could miss a TLB flush if
L1 changes L2's VPID, then does a failed VM entry followed by a
successful one, as the failed VM entry would update last_vpid but not
actually flush the TLB. Servicing local TLB flushes on failed VM entries
makes sure that the TLB is always flushed when last_vpid is updated.

Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org> # Internal review
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260722230128.1587363-1-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ replaced unavailable kvm_service_local_tlb_flush_requests() with inline 5.10 TLB flush request handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 801938b255822..90636832db684 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3490,6 +3490,20 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 vmentry_fail_vmexit_guest_mode:
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
+
+	/*
+	 * Handle any TLB flush requests that were queued for L2 if KVM made it
+	 * far enough along to switch to L2 context.  Note, loading host state
+	 * will generate any flushes for L1 required by VM-Exit.
+	 */
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+		kvm_vcpu_flush_tlb_current(vcpu);
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
+		++vcpu->stat.tlb_flush;
+		kvm_x86_ops.tlb_flush_guest(vcpu);
+	}
+
 	leave_guest_mode(vcpu);
 
 vmentry_fail_vmexit:
-- 
2.53.0



