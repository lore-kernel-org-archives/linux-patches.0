Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAAE1F3D56;
	Tue, 21 Jul 2026 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654045; cv=none; b=DxZ/cb4aY74njprzGi4tXekZwpOH08W7MLx51LU33FjesYaNNQ2ROMFni5gB5G8WDf2fablxnGGP9bNaw5hxOJGLhsPNuMFqM5gxaoBw3+uD82zsxzYn9ryp/F+QBz8NMurucJIylFZz5unlxsD0mZP81Do4o50WbGSuQRpK+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654045; c=relaxed/simple;
	bh=53zs4bSCLilpPrL3l6RULGQmm73WU7+LwyWgQJrj3Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMK1tAC0rEKyrIPUnmA4KJhdMeHbtNEPx5BMqdbGhVzBmLacDBUOoIJXXGH9caOuN+dmZ30pGaXxP/7Fk32lJ/rwd982+lfCwOJ82kvPwYfLBh4QgoKHlKbKMfdeuOdSnfih9FOltXBebAG+CluXt1TRYiHg1ixegDSh3XgauUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLnRqrve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLnRqrve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19D71F00A3A;
	Tue, 21 Jul 2026 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654044;
	bh=47jYtlnAOjn97uajU8AQIHd1uI3XedX2wStWxw8Bpx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLnRqrveDsgvzdx66x0ceJeI7hrDe5tUUCvXVoCZyArDwmk+kPyylbroZ7Y17oAFz
	 o/HcCKLf9hvMTaWbqS00Ip77309n08caoU3GwwPTAuLvfiwu9ZybkPj33lSm1TzPtY
	 AxtCVkDzb/IdDD7cSoN7t447Im+w+0nbVw2tMFOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1555/2077] KVM: s390: vsie: Use mmu cache to allocate rmap
Date: Tue, 21 Jul 2026 17:20:28 +0200
Message-ID: <20260721152629.453651965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit abeb7eb57f1671d9185ddf11236c784f07bdb928 upstream.

Use kvm_s390_mmu_cache_alloc_rmap() to allocate the rmap in
gmap_insert_rmap(), instead of a normal kzalloc_obj() with GFP_ATOMIC.

This guarantees forward progress.

Fixes: a2c17f9270cc ("KVM: s390: New gmap code")
CC: stable@vger.kernel.org # 7.1
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611104850.110313-6-imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.c | 16 ++++++++--------
 arch/s390/kvm/gmap.c    |  7 ++++---
 arch/s390/kvm/gmap.h    |  3 ++-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 0584fc91606f..36102b2727fb 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1419,8 +1419,8 @@ static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwal
 	return kvm_s390_get_guest_page(kvm, entries + LEVEL_MEM, table.pte.pfra, wr);
 }
 
-static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union pte *ptep,
-			  struct guest_fault *f, bool p)
+static int _do_shadow_pte(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gpa_t raddr,
+			  union pte *ptep_h, union pte *ptep, struct guest_fault *f, bool p)
 {
 	union pgste pgste;
 	union pte newpte;
@@ -1430,7 +1430,7 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
 	lockdep_assert_held(&sg->parent->children_lock);
 
 	scoped_guard(spinlock, &sg->host_to_rmap_lock)
-		rc = gmap_insert_rmap(sg, f->gfn, gpa_to_gfn(raddr), TABLE_TYPE_PAGE_TABLE);
+		rc = gmap_insert_rmap(mc, sg, f->gfn, gpa_to_gfn(raddr), TABLE_TYPE_PAGE_TABLE);
 	if (rc)
 		return rc;
 
@@ -1462,8 +1462,8 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
 	return 0;
 }
 
-static int _do_shadow_crste(struct gmap *sg, gpa_t raddr, union crste *host, union crste *table,
-			    struct guest_fault *f, bool p)
+static int _do_shadow_crste(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gpa_t raddr,
+			    union crste *host, union crste *table, struct guest_fault *f, bool p)
 {
 	union crste newcrste, oldcrste;
 	unsigned long mask;
@@ -1476,7 +1476,7 @@ static int _do_shadow_crste(struct gmap *sg, gpa_t raddr, union crste *host, uni
 	mask = is_pmd(*table) ? _SEGMENT_FR_MASK : _REGION3_FR_MASK;
 	r_gfn = gpa_to_gfn(raddr) & mask;
 	scoped_guard(spinlock, &sg->host_to_rmap_lock)
-		rc = gmap_insert_rmap(sg, f->gfn & mask, r_gfn, host->h.tt);
+		rc = gmap_insert_rmap(mc, sg, f->gfn & mask, r_gfn, host->h.tt);
 	if (rc)
 		return rc;
 
@@ -1578,8 +1578,8 @@ static int _gaccess_do_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
 	if (KVM_BUG_ON(l > TABLE_TYPE_REGION3, sg->kvm))
 		return -EFAULT;
 	if (l == TABLE_TYPE_PAGE_TABLE)
-		return _do_shadow_pte(sg, saddr, ptep_h, ptep, entries + LEVEL_MEM, w->p);
-	return _do_shadow_crste(sg, saddr, host, table, entries + LEVEL_MEM, w->p);
+		return _do_shadow_pte(mc, sg, saddr, ptep_h, ptep, entries + LEVEL_MEM, w->p);
+	return _do_shadow_crste(mc, sg, saddr, host, table, entries + LEVEL_MEM, w->p);
 }
 
 static inline int ___gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 52d55ddea8d4..1d289f8fa3b2 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -1000,7 +1000,8 @@ int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interr
 	return 0;
 }
 
-int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level)
+int gmap_insert_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gfn,
+		     gfn_t r_gfn, int level)
 {
 	struct vsie_rmap *rmap __free(kvfree) = NULL;
 	struct vsie_rmap *temp;
@@ -1010,7 +1011,7 @@ int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level)
 	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
 	lockdep_assert_held(&sg->host_to_rmap_lock);
 
-	rmap = kzalloc_obj(*rmap, GFP_ATOMIC);
+	rmap = kvm_s390_mmu_cache_alloc_rmap(mc);
 	if (!rmap)
 		return -ENOMEM;
 
@@ -1057,7 +1058,7 @@ int gmap_protect_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gf
 	if (level <= TABLE_TYPE_REGION1) {
 		bitmask = -1UL << (8 + 11 * level);
 		scoped_guard(spinlock, &sg->host_to_rmap_lock)
-			rc = gmap_insert_rmap(sg, p_gfn, r_gfn & bitmask, level);
+			rc = gmap_insert_rmap(mc, sg, p_gfn, r_gfn & bitmask, level);
 	}
 	if (rc)
 		return rc;
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
index 20881e3ce9d8..1c040472f56d 100644
--- a/arch/s390/kvm/gmap.h
+++ b/arch/s390/kvm/gmap.h
@@ -100,7 +100,8 @@ int gmap_ucas_map(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn, unsigned long cou
 void gmap_ucas_unmap(struct gmap *gmap, gfn_t c_gfn, unsigned long count);
 int gmap_enable_skeys(struct gmap *gmap);
 int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interruptible);
-int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level);
+int gmap_insert_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gfn,
+		     gfn_t r_gfn, int level);
 int gmap_protect_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn,
 		      kvm_pfn_t pfn, int level, bool wr);
 void gmap_set_cmma_all_dirty(struct gmap *gmap);
-- 
2.55.0



