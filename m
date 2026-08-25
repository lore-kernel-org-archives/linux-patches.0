Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD325393E;
	Tue, 25 Aug 2026 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666274; cv=none; b=f02EF3SrUJqv9GJ3L1uobFOeuBOwSJ2zkckxDnrXqoSp7gEVthCxY04jCVlWhB11rBylMgsPPY05HAqIpCsCtuwLvjtmeykpk8++GllXt702HyLKiKHUVKX4VIUN/mZI82Unoed48R6GVCoZSNOPqJ71J+XOLJyCjq//SSHjREQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666274; c=relaxed/simple;
	bh=UVX2EV+CFXVaYpjPBS6XRdCxujVkZ9tlq4s4DoYfxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kvmys0EtELrk/UEdua6j7MGToYB0rR4LGY6igN/w47t7uQFGQc4hyT4CQn2zFl+C1187g1qnB2e/hRkeCNyjMl48zIaIsuG8pCpbms+QTGW2M46qxuOdzB9i2xbfoUqkeQpi0yXLa26Wkhq3vB8S+NYTS7it+dDevHWxhJo2lMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C41h0EvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C41h0EvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947361F000E9;
	Tue, 25 Aug 2026 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666273;
	bh=AX2y1QDj8f52wOQLXpK1lYMAmguktYv9rf+pbB2Zt7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C41h0EvDHWNpWY9PYNhex5oc3o/G4bDgSw3Xn79Ja1VCKAC26ToQGDtRgHYvXMCze
	 Q29iEsg5LtdpAp7DSGcNN2usVJZ52WQNKtIKIVeWsM33nfTv9Qpi34Fsdz8C8TADrq
	 FKKRezS6eybwbLYMpqR2MAvFFkA0YmxbVAIIIsmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/76] KVM: x86: Retry page fault if MMU reload is pending and root has no sp
Date: Tue, 25 Aug 2026 15:26:56 +0200
Message-ID: <20260825132544.041374311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 18c841e1f4112d3fb742aca3429e84117fcb1e1c ]

Play nice with a NULL shadow page when checking for an obsolete root in
the page fault handler by flagging the page fault as stale if there's no
shadow page associated with the root and KVM_REQ_MMU_RELOAD is pending.
Invalidating memslots, which is the only case where _all_ roots need to
be reloaded, requests all vCPUs to reload their MMUs while holding
mmu_lock for lock.

The "special" roots, e.g. pae_root when KVM uses PAE paging, are not
backed by a shadow page.  Running with TDP disabled or with nested NPT
explodes spectaculary due to dereferencing a NULL shadow page pointer.

Skip the KVM_REQ_MMU_RELOAD check if there is a valid shadow page for the
root.  Zapping shadow pages in response to guest activity, e.g. when the
guest frees a PGD, can trigger KVM_REQ_MMU_RELOAD even if the current
vCPU isn't using the affected root.  I.e. KVM_REQ_MMU_RELOAD can be seen
with a completely valid root shadow page.  This is a bit of a moot point
as KVM currently unloads all roots on KVM_REQ_MMU_RELOAD, but that will
be cleaned up in the future.

Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211209060552.2956723-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c381cf61e219..c0257bbb25c39 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4005,7 +4005,21 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				kvm_pfn_t pfn, unsigned long mmu_seq, hva_t hva)
 {
-	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
+
+	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
+	if (sp && is_obsolete_sp(vcpu->kvm, sp))
+		return true;
+
+	/*
+	 * Roots without an associated shadow page are considered invalid if
+	 * there is a pending request to free obsolete roots.  The request is
+	 * only a hint that the current root _may_ be obsolete and needs to be
+	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
+	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
+	 * to reload even if no vCPU is actively using the root.
+	 */
+	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
 		return true;
 
 	return !is_noslot_pfn(pfn) &&
-- 
2.53.0



