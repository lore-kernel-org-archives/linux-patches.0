Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207739;
	b=4vEXrEZUnr/JKBxU1OMq3fgiYPmGJ1ogG9xqhX9Wy2tE95E4NeeIEe4T4wJO1jHaLAyG
	 ItifmMmpPyjCfpNrdyIytEU+jja7veVu8fprlGJOa2QP14z7wYSI1llLPKy56R4kjATBw
	 fiDpPt8TedzU5RFG8J1gYL27/UcGfuP6BefW8BjHLDcVjssg6C/GXmsv1LvrNMvT0cSvP
	 5r3ik4WTtBmASTHxWZSyV0OB6EQK1UxzlAC6Z1T6EO9dW0erSRE6oVhxbc4xkpb0mMv0L
	 0BY3kdt7SZUQVBvH4LvO5O7Mnl4PsB+qeALawGWw618DCf6xgZx7f5ErRJMUXTkaMUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUaLq+FDD75yEKLjfjzm/HvTB0b5HlvMP+y7ZGBgYbo=;
	b=MbItdVkQu9Y9/QmJOdd0G2034ARZ3/jcY7dCfWa1n/xx9/D/PFR1CAybOOmA2JSvuXl0
	 ka5MnRx1kDlc/rNuFmIEjv63gpjTKTd+yPlX9DZWlNph7aHxB1J4kxcLMBMhXMHHUI0gz
	 u7R3JhKyoyBRBuMM0lIY3bp6FQQp6AzgAbs4I5n8/xXxRJlFrbV2JI6mIB2PZo1S15VO2
	 8QOItSAls4tijebMQOAj9/EhjWbT1rJmPOhFRuhLrZ2wydH1+q7CgI+0nTtMyljDyy3Cc
	 pobn2mtihXnL/0Wbw+0kPZerSE7RlxJfVDiy2I6rMzxZIlbMS7MU3EyaLBT7F79t9PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/f15Ohw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8F4606A327;
	Wed, 28 Oct 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/f15Ohw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC191F031E6;
	Wed, 28 Oct 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207738;
	bh=uUaLq+FDD75yEKLjfjzm/HvTB0b5HlvMP+y7ZGBgYbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/f15Ohwx/scUknwaWVuMBPOrszplXaHezOu0dW5+qb2wbREIeO4h9H5KQy06XhR8
	 zmhXwu3cRMkrk9zsNj6X0F3SpK0vLn/KY25ryJw9OFeHvpFqmycYOl0JOEQoz4kPwf
	 w7sWzWFup5f2FRdm8W0gU+KBGTx1jqfju2H4jk1E=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/247] mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
Date: Wed, 28 Oct 2026 17:58:43 +0100
Message-ID: <20261028165950.242749872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
vma->vm_ops->huge_fault being non-NULL for a VM_PFNMAP VMA), then it
should be mapped huge upon fault-in.

Correct this by explicitly checking for this while ensuring that smaps
continues to accurately report THPeligible statistics.

While here, abstract the entire file-backed THP check in
vma_can_map_huge_file(), with sensible separation of logic into helper
functions.

Failing to map huge PFN maps has resulted in significant real-world
performance degradation, see links for details.

[ziy@nvidia.com: rename some functions]
  Link: https://lore.kernel.org/DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ ljs - Converted to tva_flags, made file_thp_enabled() const in huge_mm.h
   + other smaller changes. Updated commit msg to reflect. ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h |  2 +-
 mm/huge_memory.c        | 79 ++++++++++++++++++++++++++++++-----------
 2 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd34b70dd0cf9..10e41e8b16349 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -254,7 +254,7 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f6ba19b57265b..d175e93988a92 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,6 +86,62 @@ unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
+		unsigned long tva_flags)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/* MADV_COLLAPSE ignores tuneables. */
+	if (!(tva_flags & TVA_ENFORCE_SYSFS))
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
+		vm_flags_t vm_flags, unsigned long tva_flags)
+{
+	return vma_file_bypass_thp_tuneables(vma, tva_flags) ||
+		vma_file_allow_thp_tuneables(vm_flags);
+}
+
+static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, unsigned long tva_flags)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, tva_flags))
+		return false;
+
+	/*
+	 * Trust that ->huge_fault() handlers know what they are doing
+	 * in fault path.
+	 */
+	if (tva_flags & TVA_IN_PF)
+		return has_huge_fault;
+	if ((tva_flags & TVA_SMAPS) && has_huge_fault)
+		return true;
+	/* Only regular file is valid in collapse path. */
+	return file_thp_enabled(vma);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
 					 unsigned long tva_flags,
@@ -158,27 +214,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 						   vma, vma->vm_pgoff, 0,
 						   !enforce_sysfs);
 
-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce sysfs THP requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (enforce_sysfs &&
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
+		return vma_can_map_huge_file(vma, vm_flags, tva_flags) ? orders : 0;
 
 	if (vma_is_temporary_stack(vma))
 		return 0;
-- 
2.53.0



