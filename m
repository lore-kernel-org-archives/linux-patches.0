Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE35D2745E;
	Fri, 17 Oct 2025 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714763; cv=none; b=KWZcvpMk0+hJKN4UFFXoP/iZjBYNp2qf9i00NUK4rdcmK3sBI15Wer0ZZu2c74uJJx5hsSfZ0OziR5Wf3xmNwsxdqLDNqjvYb1kmQppVIL2SUoIk/BYYk0lLQ5RaK01Hbjsn9CjqNrEztcQac8YmyuUHxzuZhNLlf9sQQvIo1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714763; c=relaxed/simple;
	bh=SuCwcZn/g0I1I3vGGr8tm5Is4t6LrVRpExMjh6niHdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js8GGFMWKyv+VPcWmBdJ/bBZmTAjedxIsb4Dd4wGlEbAaGrqE+hx0UpPBvEdbVw/ia3wXl4ADvHCndDmyCyepgrA83c90NZ0/z1k8my37iJJjVnT2veLOYqXoeOS6/fCdnZk4i5VzCvP2ftJudIzXrF2n6SySbYjQVN/tQ3zajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBCDL/SC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBCDL/SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F4AC4CEE7;
	Fri, 17 Oct 2025 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714762;
	bh=SuCwcZn/g0I1I3vGGr8tm5Is4t6LrVRpExMjh6niHdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBCDL/SCtJGDNmx/CMN3kI2RahM2SGMyrwZdqsKETSxph6N6gp/8jp6FGuBlv0mQT
	 bZUAK/tvm9AQwCDr92a0hxb3ckmMufKmzyuastiHhkH5usG5dc/nfLkxSJS8brwou3
	 nTeNtL92ymTLMFAnFU873YGJhdfjddBFrdyFyNh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Mathew Brost <matthew.brost@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 258/277] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Fri, 17 Oct 2025 16:54:25 +0200
Message-ID: <20251017145156.577742769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

commit 9658d698a8a83540bf6a6c80d13c9a61590ee985 upstream.

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several
important PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped.
This breaks the userfaultfd write-protection mechanism, causing writes to
be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Link: https://lkml.kernel.org/r/20250930081040.80926-1-lance.yang@linux.dev
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -198,8 +198,7 @@ bool isolate_folio_to_list(struct folio
 }
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
-					  struct folio *folio,
-					  unsigned long idx)
+		struct folio *folio, pte_t old_pte, unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
@@ -208,7 +207,7 @@ static bool try_to_map_unused_to_zeropag
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -224,6 +223,12 @@ static bool try_to_map_unused_to_zeropag
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(old_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(old_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -266,13 +271,13 @@ static bool remove_migration_pte(struct
 			continue;
 		}
 #endif
+		old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
-		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);
 
 		entry = pte_to_swp_entry(old_pte);
 		if (!is_migration_entry_young(entry))


