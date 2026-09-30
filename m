Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554BE511E90;
	Wed, 30 Sep 2026 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792532; cv=none; b=jtvLjPZL9s+h5t7TC/XaOPMKkhapQlUwb7NZ3N7zI5KMFq7CjEynBixTXsN7fDwVBe7IDeGJzj7crL1N/L8ZLLd6r1XfhMST1y1e0NgKDFeJMWcUl/WkwWNTqRPJo7J2dr2iNiRd0nMwsMI+X8GeoWFh8AbO5821mobkn5tm3O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792532; c=relaxed/simple;
	bh=AZRqVi96VEVrlBdFrd2lbfr9voxRhF8lwT319pu2Hf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Re/WF0ynpE5ssNP2Eupj/1RKpiQacrk6bGv2LkqNeLxposCkgcP8zQOFLMvVAA/PeO7tKwVMIE24G41S7xknah1ueOeDbDbxVid9RYg+udNM97fg3vfld6HVFKoheg03u+yuXz43gykivt8PIBzEEbYgrxW9+uQXmnod9DExa1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bosi7fJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bosi7fJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B436E1F000FF;
	Wed, 30 Sep 2026 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792531;
	bh=8Lf3XB9CYKt1Q8Bsx6tQXqvqmfs65jXyVocGqvzSln4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bosi7fJHF/j2C67ws067/eyFoSIHTUixmxs45hfuFt+jwCTe2GgmiStc18DqI3IXN
	 kDPA6OChNbwXPdTj3c5D+tr6YMctSwvYMcWBAinlu16JAhD+KEEa37EY7A45oFfVDe
	 DdRkS10wIdLl+eYovw6ajOyoCqILmH37AqVk2syg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 687/752] KVM: x86/mmu: Derive shadow MMU page role from parent
Date: Wed, 30 Sep 2026 17:29:17 +0200
Message-ID: <20260930152413.104116306@linuxfoundation.org>
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

From: David Matlack <dmatlack@google.com>

commit 2e65e842c57d72e9a573ba42bc2055b7f626ea1f upstream.

Instead of computing the shadow page role from scratch for every new
page, derive most of the information from the parent shadow page.  This
eliminates the dependency on the vCPU root role to allocate shadow page
tables, and reduces the number of parameters to kvm_mmu_get_page().

Preemptively split out the role calculation to a separate function for
use in a following commit.

Note that when calculating the MMU root role, we can take
@role.passthrough, @role.direct, and @role.access directly from
@vcpu->arch.mmu->root_role. Only @role.level and @role.quadrant still
must be overridden for PAE page directories, when shadowing 32-bit
guest page tables with PAE page tables.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-5-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c         | 97 +++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
 2 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bfb1455ebeefd..48015f96b1dcf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2075,31 +2075,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
-					     gfn_t gfn,
-					     gva_t gaddr,
-					     unsigned level,
-					     bool direct,
-					     unsigned int access)
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
 {
 	bool direct_mmu = vcpu->arch.mmu->direct_map;
-	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
-	unsigned quadrant;
 	struct kvm_mmu_page *sp;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	role = vcpu->arch.mmu->mmu_role.base;
-	role.level = level;
-	role.direct = direct;
-	role.access = access;
-	if (role.has_4_byte_gpte) {
-		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
-		role.quadrant = quadrant;
-	}
-
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
@@ -2117,7 +2101,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			 * Unsync pages must not be left as is, because the new
 			 * upper-level page will be write-protected.
 			 */
-			if (level > PG_LEVEL_4K && sp->unsync)
+			if (role.level > PG_LEVEL_4K && sp->unsync)
 				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 							 &invalid_list);
 			continue;
@@ -2155,14 +2139,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
+	sp = kvm_mmu_alloc_page(vcpu, role.direct);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (!direct) {
+	if (!role.direct) {
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
+		if (role.level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
 	trace_kvm_mmu_get_page(sp, true);
@@ -2174,6 +2158,54 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
+{
+	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
+	union kvm_mmu_page_role role;
+
+	role = parent_sp->role;
+	role.level--;
+	role.access = access;
+	role.direct = direct;
+
+	/*
+	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
+	 * 2-level, non-PAE paging. KVM shadows such guests with PAE paging
+	 * (i.e. 8-byte PTEs). The difference in PTE size means that KVM must
+	 * shadow each guest page table with multiple shadow page tables, which
+	 * requires extra bookkeeping in the role.
+	 *
+	 * Specifically, to shadow the guest's page directory (which covers a
+	 * 4GiB address space), KVM uses 4 PAE page directories, each mapping
+	 * 1GiB of the address space. @role.quadrant encodes which quarter of
+	 * the address space each maps.
+	 *
+	 * To shadow the guest's page tables (which each map a 4MiB region), KVM
+	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
+	 * @role.quadrant encodes which half of the region they map.
+	 *
+	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
+	 * assigned in mmu_alloc_root(). So only page tables need to be handled
+	 * here.
+	 */
+	if (role.has_4_byte_gpte) {
+		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
+		role.quadrant = (sptep - parent_sp->spt) % 2;
+	}
+
+	return role;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
+						 u64 *sptep, gfn_t gfn,
+						 bool direct, unsigned int access)
+{
+	union kvm_mmu_page_role role;
+
+	role = kvm_mmu_child_role(sptep, direct, access);
+	return kvm_mmu_get_page(vcpu, gfn, role);
+}
+
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
@@ -3041,8 +3073,7 @@ static int direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
-		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
-				      it.level - 1, true, ACC_ALL);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (is_tdp && huge_page_disallowed &&
@@ -3436,13 +3467,18 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
+static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 			    u8 level)
 {
-	bool direct = vcpu->arch.mmu->mmu_role.base.direct;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->mmu_role.base;
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	role.level = level;
+
+	if (role.has_4_byte_gpte)
+		role.quadrant = quadrant;
+
+	sp = kvm_mmu_get_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
@@ -3476,8 +3512,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30, PT32_ROOT_LEVEL);
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
+					      PT32_ROOT_LEVEL);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
 		}
@@ -3585,8 +3621,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL);
+		root = mmu_alloc_root(vcpu, root_gfn, i, PT32_ROOT_LEVEL);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fd3f2c5bb7ed1..003383e2a309b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -704,8 +704,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
 			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_page(vcpu, table_gfn, addr,
-					      it.level-1, false, access);
+			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+						  false, access);
+
 			/*
 			 * We must synchronize the pagetable before linking it
 			 * because the guest doesn't need to flush tlb when
@@ -763,8 +764,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		drop_large_spte(vcpu, it.sptep);
 
 		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
-					      it.level - 1, true, direct_access);
+			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+						  true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (huge_page_disallowed && req_level >= it.level)
 				account_huge_nx_page(vcpu->kvm, sp);
-- 
2.53.0



