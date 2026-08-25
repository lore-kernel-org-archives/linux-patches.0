Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D2448D11;
	Tue, 25 Aug 2026 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666243; cv=none; b=s4dENZsGAPdazb7fuladUW9mIYGhw/8kwdWb20wP1P93M6wHBRPDIJpIV38L/8bciCBKr++73z0Hehi+MxbZDfaRUA2uiDa6HdCklhN6fECWHyJVVt92xfxHa11lRdY7SNoJnplpFZk+e1oma2Qu+DDdZ+CPTArSZaFBLdYlZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666243; c=relaxed/simple;
	bh=J3iitPPKzZlsGQfCtrhMRITc9Yl3/IiMmMYHMwF18rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfYAUk836JbCtEyJCiQizoJfMdvPrjRNR/k2Rmxz8fYWPUUkiqkTHy1era6V631byfEphu+IYEvfCWfOFD0XYnpO8s1gKWUCi9Sm/FtbhsAermhnTahipCotJMq60YrZl1untYR8hBoQsLsfVtzm0Ar1G0mFpM0U4enp47tJirY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1wsC8QZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1wsC8QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B055D1F000E9;
	Tue, 25 Aug 2026 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666241;
	bh=mpnD2Ks0abOMC763Y1Eg7A3PAmC4zsEZfNXJFwlcaqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1wsC8QZBhGK+Fh8Hu1INCXh5vQvjKKM9ZSalmA7bRAetUD9ICm3ZMCbI8xDnuPSl
	 Xj/uIaYCdyZSVaNeJE2V3AQ7Q1JCvOdYOAPVi7pmetfcb1CtP3kPChB/MHoA+ptyLj
	 24fq5L3bij33F3uEL8P0jnDT/Ukhoc/D4d/pvsl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 53/76] KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap SPTEs
Date: Tue, 25 Aug 2026 15:26:46 +0200
Message-ID: <20260825132543.653134969@linuxfoundation.org>
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

[ Upstream commit 9202aee816c84d69179f94193c5dd321bb0e8530 ]

Rename pte_list_remove() and pte_list_destroy() to kvm_zap_one_rmap_spte()
and kvm_zap_all_rmap_sptes() respectively to document that (a) they zap
SPTEs and (b) to better document how they differ (remove vs. destroy does
not exactly scream "one vs. all").

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220715224226.3749507-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2abd5287f083 ("KVM: x86: Check for invalid/obsolete root *after* making MMU pages available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -999,15 +999,16 @@ static void __pte_list_remove(u64 *spte,
 	}
 }
 
-static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			    u64 *sptep)
+static void kvm_zap_one_rmap_spte(struct kvm *kvm,
+				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
 	__pte_list_remove(sptep, rmap_head);
 }
 
-/* Return true if rmap existed, false otherwise */
-static bool pte_list_destroy(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
+/* Return true if at least one SPTE was zapped, false otherwise */
+static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
+				   struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
 	int i;
@@ -1434,7 +1435,7 @@ static bool rmap_write_protect(struct kv
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			  const struct kvm_memory_slot *slot)
 {
-	return pte_list_destroy(kvm, rmap_head);
+	return kvm_zap_all_rmap_sptes(kvm, rmap_head);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1465,7 +1466,7 @@ restart:
 		need_flush = 1;
 
 		if (pte_write(pte)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 			goto restart;
 		} else {
 			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
@@ -1639,7 +1640,7 @@ static void rmap_add(struct kvm_vcpu *vc
 	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		pte_list_destroy(vcpu->kvm, rmap_head);
+		kvm_zap_all_rmap_sptes(vcpu->kvm, rmap_head);
 		kvm_flush_remote_tlbs_with_address(
 				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
@@ -5873,7 +5874,7 @@ restart:
 		    !kvm_is_reserved_pfn(pfn) &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
 				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,


