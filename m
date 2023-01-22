Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A850F2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E70EC433AE;
	Sun, 22 Jan 2023 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400933;
	bh=q3VCB3prLBXvTbuY3/LFgnj9/Gg3HgTcGUbj0iMcfyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MK0ehdJi1wNC6LSrRiXz+SjOYjoPGVcyyIP9Ah5o0NuuWNnxqSFkaKooPLNKfnkg
	 7k4xNNWE/tsMRvoW1gX4mICkP8I+X1ULhlV3hclkvIF5YfscE9iNhjg71D2qJltFi4
	 rLQX2+6ZpN7QFv1o7+zsbGON4+Kyx8MVP6QQyEpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Zach OKeefe <zokeefe@google.com>,
	Song Liu <songliubraving@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 047/193] mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma
Date: Sun, 22 Jan 2023 16:02:56 +0100
Message-Id: <20230122150248.528355283@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hugh Dickins <hughd@google.com>

commit ab0c3f1251b4670978fde0bd54161795a139b060 upstream.

uprobe_write_opcode() uses collapse_pte_mapped_thp() to restore huge pmd,
when removing a breakpoint from hugepage text: vma->anon_vma is always set
in that case, so undo the prohibition.  And MADV_COLLAPSE ought to be able
to collapse some page tables in a vma which happens to have anon_vma set
from CoWing elsewhere.

Is anon_vma lock required?  Almost not: if any page other than expected
subpage of the non-anon huge page is found in the page table, collapse is
aborted without making any change.  However, it is possible that an anon
page was CoWed from this extent in another mm or vma, in which case a
concurrent lookup might look here: so keep it away while clearing pmd (but
perhaps we shall go back to using pmd_lock() there in future).

Note that collapse_pte_mapped_thp() is exceptional in freeing a page table
without having cleared its ptes: I'm uneasy about that, and had thought
pte_clear()ing appropriate; but exclusive i_mmap lock does fix the
problem, and we would have to move the mmu_notification if clearing those
ptes.

What this fixes is not a dangerous instability.  But I suggest Cc stable
because uprobes "healing" has regressed in that way, so this should follow
8d3c106e19e8 into those stable releases where it was backported (and may
want adjustment there - I'll supply backports as needed).

Link: https://lkml.kernel.org/r/b740c9fb-edba-92ba-59fb-7a5592e5dfc@google.com
Fixes: 8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1467,14 +1467,6 @@ int collapse_pte_mapped_thp(struct mm_st
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return SCAN_VMA_CHECK;
 
-	/*
-	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
-	 * that got written to. Without this, we'd have to also lock the
-	 * anon_vma if one exists.
-	 */
-	if (vma->anon_vma)
-		return SCAN_VMA_CHECK;
-
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
@@ -1574,8 +1566,14 @@ int collapse_pte_mapped_thp(struct mm_st
 	}
 
 	/* step 4: remove pte entries */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 maybe_install_pmd:


