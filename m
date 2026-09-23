Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430C5304A7;
	Wed, 23 Sep 2026 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175252; cv=none; b=r6DLJEsD8AlieLYJ1mbofhyw8K/vOZjndCTIrpZVUHOIUot/rxW9ENZHVTP3DeanM0R2MksIvvSG+4SJVSONIytGqK+DPpU4cTII1HQLsngyaXyLYKqmTTqUJkY1eyhtfDTOoayR9P9ul27pvY9g1ExbT+a1Fap47MaDKbXkXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175252; c=relaxed/simple;
	bh=EG9LLvdWsV9D1RVVWKWNiFn2j0qDmxGZNIg9bRJ/eqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSSbtSm9AnjpbkgoM1oRXqKeU5Kw+bouZ43POnjfNPbNuGuBx446U49NId8dfmj4KmKV+tZb9t1GjUMLVT5GS7Kps7Ub7/2W0BmvSMGl1l2s2AzyBQMGEUJVvleThsR0+62Po760EdW42LvrfXZ1DMZETAqFeVfQy+SCWS9e9LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWUZuGUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWUZuGUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DCA1F000FF;
	Wed, 23 Sep 2026 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175250;
	bh=u7S0/na2UcQC1za9COpsLjPEGpLb3Dp0N22VhulecKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWUZuGUecCsvwVZtFZ7LhMrILQEeedFjKwo5rcPo4zhH5RUXz0xJ0MBk08bTzqly1
	 hzdMF9X+s2rOqLuC3VZ8/ya0yjzTzSfhzy3C07XNvxPgd4ILTeH4WHM+M6/g3+4v+9
	 lBpdQYzmpFmffnmH8l/R23buj9SOhpFxShMGr8dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Cedric Le Goater <clg@redhat.com>,
	Saravanan D <saravanand@crusoe.ai>,
	Lance Yang <lance.yang@linux.dev>,
	SJ Park <sj@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Liam R. Howlett" <liam@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/398] mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
Date: Wed, 23 Sep 2026 16:07:23 +0200
Message-ID: <20260923140653.009779123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

[ Upstream commit e384abeb559d10d6505aec053ede9368d81d4c71 ]

The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
confusingly only control the behaviour of THP in some instances.

They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.

Long-term, THP is predicated upon compaction being able to obtain large
folios to populate THP ranges.

However, vm_normal_folio() returns NULL for PFN map mappings, thus their
reference count is maintained by the driver, not core mm.

As a consequence, the folios are not subject to reclaim nor compaction, so
are not truly part of the THP mechanism at all.

However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
introduced the ability to establish huge PFN maps, they have been subject
to THP tuneables.

This is incorrect - if a huge PFN map is available (defined by
vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
should be mapped huge upon fault-in.

Correct this by explicitly checking for this while ensuring that smaps
continues to accurately report THPeligible statistics.

While here, abstract the entire file-backed THP check in
vma_can_map_huge_file(), with sensible separation of logic into helper
functions.

Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
maps of shmem folios, however they are marked unevictable in
drm_gem_get_pages(), and in any case would fail the reference check in
__remove_mapping() even if they weren't.

Failing to map huge PFN maps has resulted in significant real-world
performance degradation, see links for details.

[ziy@nvidia.com: rename some functions]
  Link: https://lore.kernel.org/DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com
Link: https://lore.kernel.org/20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org
Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Cedric Le Goater <clg@redhat.com>
Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
Reported-by: Saravanan D <saravanand@crusoe.ai>
Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Saravanan D <saravanand@crusoe.ai>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ replaced vma_test(vma, VMA_PFNMAP_BIT) with (vma->vm_flags & VM_PFNMAP) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   86 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 22 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -84,7 +84,7 @@ unsigned long huge_anon_orders_madvise _
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
@@ -102,6 +102,67 @@ static inline bool file_thp_enabled(stru
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
+		enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/* MADV_COLLAPSE ignores tuneables. */
+	if (type == TVA_FORCED_COLLAPSE)
+		return true;
+	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
+	if ((vma->vm_flags & VM_PFNMAP) && has_huge_fault)
+		return true;
+	return false;
+}
+
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
+{
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise and marked MADV_HUGEPAGE? */
+	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
+		return true;
+	return false;
+}
+
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
+}
+
+static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
+		return false;
+
+	switch (type) {
+	case TVA_PAGEFAULT:
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		return has_huge_fault;
+	case TVA_SMAPS:
+		if (has_huge_fault)
+			return true;
+		fallthrough;
+	default:
+		/* Only regular file is valid in collapse path. */
+		return file_thp_enabled(vma);
+	}
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -174,27 +235,8 @@ unsigned long __thp_vma_allowable_orders
 						   vma, vma->vm_pgoff, 0,
 						   forced_collapse);
 
-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
-			return 0;
-
-		/*
-		 * Trust that ->huge_fault() handlers know what they are doing
-		 * in fault path.
-		 */
-		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
-			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
-		return 0;
-	}
+	if (!vma_is_anonymous(vma))
+		return vma_can_map_huge_file(vma, vm_flags, type) ? orders : 0;
 
 	if (vma_is_temporary_stack(vma))
 		return 0;


