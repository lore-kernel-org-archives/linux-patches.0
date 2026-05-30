Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192D3438AE;
	Sat, 30 May 2026 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160272; cv=none; b=hSGDHrDOdGhhzli4EVp52mtx2ifwt71E4PVKu8ESYXrsPLhDkbXMHEMFb00Vx0FncHPXRheNOWhkh67EHiMW2jOGoftGDIgrNCkApX+CbljxO3I5PXuGk3ccFppw6LjzeTq7liyREIUWCynFgtLyIt8Uw9RSwprJ/bX7mRZUA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160272; c=relaxed/simple;
	bh=WXBFsftGC4bDgtFtlllE+N04Nz44JTLhHMjgftj4lnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzTPqp4CPZ5rmfCLbPEDprze39bHUP4VHfMNfwvAuvWBEEKiTyPHeDm7CYHyhSGThg+d1IoGiYInXv2jI+Z/o/1Nd6EJLkQjQ4nwiJBgX7nxC7IgnjauGAYgpG+QZn/RiC1FuPze0ppmJiA1xWACXJYvV2Tv1vK2bRdVL7rTZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE/D9znO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE/D9znO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1498B1F00893;
	Sat, 30 May 2026 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160270;
	bh=HvQyrW4I+sVsKeZFJp5sLS33qTuLACpO0pTWwhumFYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FE/D9znOKBR8Gvo2PZ5GJXXYkGCT83UWw7mzy1LeeLd8xpha/a4vBdJ3+rhMV/QMg
	 Rfone8vfAhc6iMkePJtQ0NQPnpdhOQTZXQrCi/4RGnbN3bZ92uOTgnIbG3qZJDWN66
	 7rtJ218uVXJHmmKYrlKfqi6r60ajktjnlBYfmNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Bulekov <bkov@amazon.com>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/969] KVM: x86: Fix shadow paging use-after-free due to unexpected GFN
Date: Sat, 30 May 2026 17:56:56 +0200
Message-ID: <20260530160308.512892424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 0cb2af2ea66ad8ff195c156ea690f11216285bdf upstream.

The shadow MMU computes GFNs for direct shadow pages using sp->gfn plus
the SPTE index. This assumption breaks for shadow paging if the guest
page tables are modified between VM entries (similar to commit
aad885e77496, "KVM: x86/mmu: Drop/zap existing present SPTE even
when creating an MMIO SPTE", 2026-03-27).  The flow is as follows:

- a PDE is installed for a 2MB mapping, and a page in that area is
  accessed.  KVM creates a kvm_mmu_page consisting of 512 4KB pages;
  the kvm_mmu_page is marked by FNAME(fetch) as direct-mapped because
  the guest's mapping is a huge page (and thus contiguous).

- the PDE mapping is changed from outside the guest.

- the guest accesses another page in the same 2MB area.  KVM installs
  a new leaf SPTE and rmap entry; the SPTE uses the "correct" GFN
  (i.e. based on the new mapping, as changed in the previous step) but
  that GFN is outside of the [sp->gfn, sp->gfn + 511] range; therefore
  the rmap entry cannot be found and removed when the kvm_mmu_page
  is zapped.

- the memslot that covers the first 2MB mapping is deleted, and the
  kvm_mmu_page for the now-invalid GPA is zapped.  However, rmap_remove()
  only looks at the [sp->gfn, sp->gfn + 511] range established in step 1,
  and fails to find the rmap entry that was recorded by step 3.

- any operation that causes an rmap walk for the same page accessed
  by step 3 then walks a stale rmap and dereferences a freed kvm_mmu_page.
  This includes dirty logging or MMU notifier invalidations (e.g., from
  MADV_DONTNEED).

The underlying issue is that KVM's walking of shadow PTEs assumes that
if a SPTE is present when KVM wants to install a non-leaf SPTE, then the
existing kvm_mmu_page must be for the correct gfn.  Because the only way
for the gfn to be wrong is if KVM messed up and failed to zap a SPTE...
which shouldn't happen, but *actually* only happens in response to a
guest write.

That bug dates back literally forever, as even the first version of KVM
assumes that the GFN matches and walks into the "wrong" shadow page.
However, that was only an imprecision until 2032a93d66fa ("KVM: MMU:
Don't allocate gfns page for direct mmu pages") came along.

Fix it by checking for a target gfn mismatch and zapping the existing
SPTE.  That way the old SP and rmap entries are gone, KVM installs
the rmap in the right location, and everyone is happy.

Fixes: 2032a93d66fa ("KVM: MMU: Don't allocate gfns page for direct mmu pages")
Fixes: 6aa8b732ca01 ("kvm: userspace interface")
Reported-by: Alexander Bulekov <bkov@amazon.com>
Reported-by: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://patch.msgid.link/20260503201029.106481-1-pbonzini@redhat.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c  | 36 ++++++++++++++----------------------
 arch/x86/kvm/mmu/spte.h |  5 +++++
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed5ba38bec869..58d67e5ab2c58 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -163,6 +163,8 @@ struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
+static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    u64 *spte, struct list_head *invalid_list);
 
 struct kvm_mmu_role_regs {
 	const unsigned long cr0;
@@ -1156,20 +1158,6 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
-{
-	struct kvm_mmu_page *sp;
-
-	sp = sptep_to_sp(sptep);
-	WARN_ON(sp->role.level == PG_LEVEL_4K);
-
-	drop_spte(kvm, sptep);
-
-	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
-}
-
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
@@ -2253,7 +2241,8 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role;
 
-	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep) &&
+	    spte_to_child_sp(*sptep) && spte_to_child_sp(*sptep)->gfn == gfn)
 		return ERR_PTR(-EEXIST);
 
 	role = kvm_mmu_child_role(sptep, direct, access);
@@ -2331,13 +2320,16 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	/*
-	 * If an SPTE is present already, it must be a leaf and therefore
-	 * a large one.  Drop it, and flush the TLB if needed, before
-	 * installing sp.
-	 */
-	if (is_shadow_present_pte(*sptep))
-		drop_large_spte(kvm, sptep, flush);
+	if (is_shadow_present_pte(*sptep)) {
+		struct kvm_mmu_page *parent_sp;
+		LIST_HEAD(invalid_list);
+
+		parent_sp = sptep_to_sp(sptep);
+		WARN_ON_ONCE(parent_sp->role.level == PG_LEVEL_4K);
+
+		mmu_page_zap_pte(kvm, parent_sp, sptep, &invalid_list);
+		kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, true);
+	}
 
 	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7670c13ce251b..0ed97eb1c2e6b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -295,6 +295,11 @@ static inline bool is_executable_pte(u64 spte)
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
 
+static inline struct kvm_mmu_page *spte_to_child_sp(u64 spte)
+{
+	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
+}
+
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & SPTE_BASE_ADDR_MASK) >> PAGE_SHIFT;
-- 
2.53.0



