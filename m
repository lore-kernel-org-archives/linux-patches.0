Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D2858F07A;
	Wed,  9 Sep 2026 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963954; cv=none; b=XHj2HUTA2Lt1lj0LWDxOCiy4kLFbv4vSr7xY0W1kLF6wBL3bqAlS//xEE97jM2Cm+IHCkhX6rH+RYclrb7yV0uj6+CiQCT5a97GL18qyWBLzr7456ipKvhf2X+uYg7LlssDOnwuSBck8qf1k4fLnZfzgP7k+8cLJhreMApcpKUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963954; c=relaxed/simple;
	bh=SorR1HsiAphv7Zx3dE0O9fggjrK9hpMGX9bRMoOShjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHTCP9YsI7SJ87llIO2igjLpP2NmgYAhLjbYX37V9T8rgOA2b8MvYKQF7vWtNS0GRx6/3Lnoq8IBq7AoNuvvo03bGdjqci1TgKhfgP4aVaR0NfulRZZCK6oUnsi87jXWoUaTP+BFoUKXUPxcfM8Ohhyx4wxNVC+xyq5ATG8ctoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDy5IWk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDy5IWk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0AC1F00A3A;
	Wed,  9 Sep 2026 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963953;
	bh=2I35wSYIKen8uhfddOJRYtct3lM795sEgSgTS3rkW3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDy5IWk//sxs0dBF68Sp7B+ukB90IeDSjHj7f66EYisvRa3qNjZq7fwQBDw5Y8Yhf
	 LDlOeEcWdDQ4+gH35HZeavdFrPXrxrLWKk6+Fb7x6QFNM1glwZ3zcdV9kgTHXVkFj1
	 OaEAHRwOAcsmMCf2LqnDKqu43qjNwh0pROAF02LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 255/583] KVM: arm64: Make VNCR invalidation participate in MMU invalidation retry
Date: Wed,  9 Sep 2026 15:39:00 +0200
Message-ID: <20260909134246.955701718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -904,6 +904,12 @@ static void kvm_invalidate_vncr_ipa(stru
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
@@ -931,6 +937,15 @@ static void invalidate_vncr_va(struct kv
 
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
@@ -1243,15 +1258,15 @@ static int kvm_translate_vncr(struct kvm
 
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


