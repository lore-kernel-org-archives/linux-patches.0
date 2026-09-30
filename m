Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F725187EB;
	Wed, 30 Sep 2026 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792538; cv=none; b=Ben3PdcFj1yD7jFT5i5NysS5DRfqNgg+Y1hm4OuwI7lFacb+zCB3EXvAvpUYkULBlPICreWbi3xAcMl+YHBPIYHKp9uzRixujnYqqa4WLnaTrWvT7mesIzPveDuql8hlrCjxci932TLAL9itRC6TvTfg+QW8VRbyZwUNitYLukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792538; c=relaxed/simple;
	bh=r/3Fqfcl9pDozOsIMwStZtNSuckFgjvRQXAewv78+w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIsGtQP/JufIgM8suxkZ29glkRaDUArSH+W3byXBmAoULDHo7+I5Ea1RFLSdUfUpupZbwne8RRHyDRUSBRkpYUNAtJ+s5ap2unyUktzS+adjZN9wG5ZTjT08viwV4Cv7LBhBljgwJg66WmPrbgEFXR5AUdsGQtAU5wNhudmsB2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xg+Glls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xg+Glls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1311F000FF;
	Wed, 30 Sep 2026 18:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792536;
	bh=w7WmFa4ZF32963LmG5122AQHY7qBnothcKpjfYF+HRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xg+Gllszkjxy+MysVu7TW+QkyeZRFoJocwQMda86hwleBu0TnPJTchN9tlOhAc3Z
	 foWKqsds1FlcWrWpBiakQDteMwxyNAXdLoTeONk/VwzenMpgJY0e52WS6yKU22Ia9m
	 yHoNGzjiiTa0WBupQwZqEe5GY6b71Ahu8bWZAfuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 689/752] KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()
Date: Wed, 30 Sep 2026 17:29:19 +0200
Message-ID: <20260930152413.147768858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0cd8dc739833080aa0813cbd94d907a93e3a14c3 upstream.

Before allocating a child shadow page table, all callers check
whether the parent already points to a huge page and, if so, they
drop that SPTE.  This is done by drop_large_spte().

However, dropping the large SPTE is really only necessary before the
sp is installed.  While the sp is returned by kvm_mmu_get_child_sp(),
installing it happens later in __link_shadow_page().  Move the call
there instead of having it in each and every caller.

To ensure that the shadow page is not linked twice if it was present,
do _not_ opportunistically make kvm_mmu_get_child_sp() idempotent:
instead, return an error value if the shadow page already existed.
This is a bit more verbose, but clearer than NULL.

Finally, now that the drop_large_spte() name is not taken anymore,
remove the two underscores in front of __drop_large_spte().

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c         | 49 +++++++++++++++++++---------------
 arch/x86/kvm/mmu/paging_tmpl.h | 29 +++++++++-----------
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d4468b53c46fb..6410ca9d2faf6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1180,26 +1180,16 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
-
-	return false;
-}
+	struct kvm_mmu_page *sp;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
 }
 
 /*
@@ -2202,6 +2192,9 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role;
 
+	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+		return ERR_PTR(-EEXIST);
+
 	role = kvm_mmu_child_role(sptep, direct, access);
 	return kvm_mmu_get_page(vcpu, gfn, role);
 }
@@ -2269,13 +2262,21 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
-			     struct kvm_mmu_page *sp)
+static void __link_shadow_page(struct kvm_vcpu *vcpu,
+			       struct kvm_mmu_memory_cache *cache, u64 *sptep,
+			       struct kvm_mmu_page *sp)
 {
 	u64 spte;
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
+	/*
+	 * If an SPTE is present already, it must be a leaf and therefore
+	 * a large one.  Drop it and flush the TLB before installing sp.
+	 */
+	if (is_shadow_present_pte(*sptep))
+		drop_large_spte(vcpu->kvm, sptep);
+
 	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
@@ -2286,6 +2287,12 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_unsync(sptep);
 }
 
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+			     struct kvm_mmu_page *sp)
+{
+	__link_shadow_page(vcpu, &vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+}
+
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
@@ -3069,11 +3076,9 @@ static int direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		if (it.level == level)
 			break;
 
-		drop_large_spte(vcpu, it.sptep);
-		if (is_shadow_present_pte(*it.sptep))
-			continue;
-
 		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (is_tdp && huge_page_disallowed &&
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 003383e2a309b..0d50270e4f2fb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -698,15 +698,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		gfn_t table_gfn;
 
 		clear_sp_write_flooding_count(it.sptep);
-		drop_large_spte(vcpu, it.sptep);
 
-		sp = NULL;
-		if (!is_shadow_present_pte(*it.sptep)) {
-			table_gfn = gw->table_gfn[it.level - 2];
-			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
-						  false, access);
+		table_gfn = gw->table_gfn[it.level - 2];
+		access = gw->pt_access[it.level - 2];
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+					  false, access);
 
+		if (sp != ERR_PTR(-EEXIST)) {
 			/*
 			 * We must synchronize the pagetable before linking it
 			 * because the guest doesn't need to flush tlb when
@@ -735,7 +733,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
 
-		if (sp)
+		if (sp != ERR_PTR(-EEXIST))
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
@@ -761,15 +759,14 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 
 		validate_direct_spte(vcpu, it.sptep, direct_access);
 
-		drop_large_spte(vcpu, it.sptep);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+					  true, direct_access);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
 
-		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
-						  true, direct_access);
-			link_shadow_page(vcpu, it.sptep, sp);
-			if (huge_page_disallowed && req_level >= it.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-		}
+		link_shadow_page(vcpu, it.sptep, sp);
+		if (huge_page_disallowed && req_level >= it.level)
+			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
-- 
2.53.0



