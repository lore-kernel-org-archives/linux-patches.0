Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390053FD37;
	Wed,  9 Sep 2026 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962518; cv=none; b=JBaJWGTxSPbbBKczTt7ohJyDIes8UfeO2oJyZ5He7ObW+rcoyLWUOVcatfani7jtEDVQWLW+KgoAxEVsQBgEpL/OaMI7tiT7unGQVQ3vVW6sea/D4klm7S3zY2Rina3lGF75zdzz8F6HY8GG+S4vHZ1WzDDBvVMU5RWTNBXt4jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962518; c=relaxed/simple;
	bh=EXtje2WKGQoUdJNJI87JvzKXmHXaDFqtKcznPTAWovQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0d7PmSK7I9YgfJIG1ByfGhgrvIsg14l2I284wWn0VM0UXMvbTEifCbdsLi90nye4NU0yEoe0RbROxf+ziXNCLCk9qRlp4+QB3NO/1kbsjkK0YBNyxaUeAjNvgxYmz8HVbpdgCKygjNmoapBcGuAqgRg4spaNsq+g2TL5Um23wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLu7e4N2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLu7e4N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3611F00A3A;
	Wed,  9 Sep 2026 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962516;
	bh=LXRza1w6ahsFji6CClrmkZAbGlTgqLd26+5EE9r9sNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLu7e4N2WOMT6QbFg0siJZ9eV4pAFVxoKCOKT8v006EkzaY2uYa8eaK1LxpkitahR
	 UTqMzdXwQ0bSkcyj2nqAAwRO75oAor20yCH3XFEWx3YMSOygcWIVc9k/9BilqJ0EHm
	 UC8xxOVwYTjJzYBmdQ2jbn8/Xhr8Cu66nvcLELw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 318/556] KVM: arm64: Make VNCR invalidation participate in MMU invalidation retry
Date: Wed,  9 Sep 2026 15:39:58 +0200
Message-ID: <20260909134241.848664070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 2b7324f3a0c1072b9d578b8d42f199506753f26e upstream.

A VNCR TLB invalidation can occur on one vcpu while another vcpu is
faulting in this same page. Without correctly handling this, we can
end up with the following scenario:

- vcpu A walks the PTs to translate VNCR
- before vcpu A is able to grab the MMU lock to insert the TLB,
  vcpu B updates the S1 PTs with an invalid entry, and issues
  a TLBI S1E2 for this VA
- vcpu A inserts the TLB for something that is now invalid

This isn't a new problem, and we manage S2 by having the MMU notifier
to bump up mmu_invalidate_seq on invalidation so that the fault can be
replayed.

We can perform something similar here, and extend invalidate_vncr_va() to
update the same counter, clearly indicating that the context has
changed under our feet. This is safe as the invalidation always happen
while holding the MMU lock for write, and that we sample the sequence
number before walking S1.

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260801130454.5D9F11F00AC4@smtp.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-8-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1060,6 +1060,12 @@ static void kvm_invalidate_vncr_ipa(stru
 	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
 		return;
 
+	/*
+	 * Note that invalidating the VNCR on the back of an MMU notifier
+	 * doesn't require messing with the invalidation counter for a
+	 * parallel walk. The notifier itself will have bumped the counter,
+	 * making sure we rewalk.
+	 */
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm)
 		if (vncr_tlb_intersects(vt, vt->wr.pa, start, end - start))
 			invalidate_vncr(vt);
@@ -1087,6 +1093,15 @@ static void invalidate_vncr_va(struct kv
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	/*
+	 * We might be performing a parallel S1 walk, so bump up the
+	 * invalidation counter even in the absence of an actual VNCR TLB
+	 * invalidation, as this could indicate that the guest has gone
+	 * through a BBM sequence.
+	 */
+	kvm->mmu_invalidate_seq++;
+	smp_wmb();
+
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
 		switch (scope->type) {
 		case TLBI_ALL:
@@ -1421,15 +1436,15 @@ static int kvm_translate_vncr(struct kvm
 
 	va =  read_vncr_el2(vcpu);
 
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
 	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
 	if (ret)
 		return ret;
 
 	write_fault = kvm_is_write_fault(vcpu);
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	gfn = vt->wr.pa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!memslot) {


