Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFF11E630C;
	Mon, 21 Oct 2024 10:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506507; cv=none; b=euyoNYhmbt773ZJXLZ4r5HQmBF3Nal7U9vZsnGFmW8amN7K38pzYCapaqQnoWwLr/sHEshhjtRwsXoA3n9QEts+j4zxYS4j7pahnCHuu5x+vKHnp7AFYhJYWBP+gydBVX8URwUo0MynI23cHm1bLlINRBWNmSjWw9IgWM/jo8xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506507; c=relaxed/simple;
	bh=MXgiVb3Hob86S/Tk6sPpTUVeT+FBRbjb3x32Lc4IM+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrYcKHDHLyQGFcRBUB6evzqMu0JZl19VgIw/7cTa76IxGreTCHStJNhdtdftkdPQjsMpGoJTIKiDPb5cA1p0svln0JIPpLJYuOrqYQDMxC648gzjDvwsDRfgaWowe+if2OfSQaZ1MEUCFutPv5bMhyYBUcXOxa2keBj740NRe8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmwoAIPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmwoAIPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D23C4CEE7;
	Mon, 21 Oct 2024 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506507;
	bh=MXgiVb3Hob86S/Tk6sPpTUVeT+FBRbjb3x32Lc4IM+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmwoAIPCs/+RSed7yTcZuBVH1kzqbSvaxHbCNzJ6KZoxw+eS3pxkemKZxjazM9m8r
	 6wyg77BKTttYRz4a6/GWYPYp64LL+CsJKUZ9RVJO6H8hvustvMJvPQwCPqknPHIY78
	 3e1+ahCgY/Y+1IJK1lxQqi8RGwK+h/5rg29YV5qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 027/135] mm/mremap: fix move_normal_pmd/retract_page_tables race
Date: Mon, 21 Oct 2024 12:23:03 +0200
Message-ID: <20241021102300.397314982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 6fa1066fc5d00cb9f1b0e83b7ff6ef98d26ba2aa upstream.

In mremap(), move_page_tables() looks at the type of the PMD entry and the
specified address range to figure out by which method the next chunk of
page table entries should be moved.

At that point, the mmap_lock is held in write mode, but no rmap locks are
held yet.  For PMD entries that point to page tables and are fully covered
by the source address range, move_pgt_entry(NORMAL_PMD, ...) is called,
which first takes rmap locks, then does move_normal_pmd().
move_normal_pmd() takes the necessary page table locks at source and
destination, then moves an entire page table from the source to the
destination.

The problem is: The rmap locks, which protect against concurrent page
table removal by retract_page_tables() in the THP code, are only taken
after the PMD entry has been read and it has been decided how to move it.
So we can race as follows (with two processes that have mappings of the
same tmpfs file that is stored on a tmpfs mount with huge=advise); note
that process A accesses page tables through the MM while process B does it
through the file rmap:

process A                      process B
=========                      =========
mremap
  mremap_to
    move_vma
      move_page_tables
        get_old_pmd
        alloc_new_pmd
                      *** PREEMPT ***
                               madvise(MADV_COLLAPSE)
                                 do_madvise
                                   madvise_walk_vmas
                                     madvise_vma_behavior
                                       madvise_collapse
                                         hpage_collapse_scan_file
                                           collapse_file
                                             retract_page_tables
                                               i_mmap_lock_read(mapping)
                                               pmdp_collapse_flush
                                               i_mmap_unlock_read(mapping)
        move_pgt_entry(NORMAL_PMD, ...)
          take_rmap_locks
          move_normal_pmd
          drop_rmap_locks

When this happens, move_normal_pmd() can end up creating bogus PMD entries
in the line `pmd_populate(mm, new_pmd, pmd_pgtable(pmd))`.  The effect
depends on arch-specific and machine-specific details; on x86, you can end
up with physical page 0 mapped as a page table, which is likely
exploitable for user->kernel privilege escalation.

Fix the race by letting process B recheck that the PMD still points to a
page table after the rmap locks have been taken.  Otherwise, we bail and
let the caller fall back to the PTE-level copying path, which will then
bail immediately at the pmd_none() check.

Bug reachability: Reaching this bug requires that you can create
shmem/file THP mappings - anonymous THP uses different code that doesn't
zap stuff under rmap locks.  File THP is gated on an experimental config
flag (CONFIG_READ_ONLY_THP_FOR_FS), so on normal distro kernels you need
shmem THP to hit this bug.  As far as I know, getting shmem THP normally
requires that you can mount your own tmpfs with the right mount flags,
which would require creating your own user+mount namespace; though I don't
know if some distros maybe enable shmem THP by default or something like
that.

Bug impact: This issue can likely be used for user->kernel privilege
escalation when it is reachable.

Link: https://lkml.kernel.org/r/20241007-move_normal_pmd-vs-collapse-fix-2-v1-1-5ead9631f2ea@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Closes: https://project-zero.issues.chromium.org/371047675
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -238,6 +238,7 @@ static bool move_normal_pmd(struct vm_ar
 {
 	spinlock_t *old_ptl, *new_ptl;
 	struct mm_struct *mm = vma->vm_mm;
+	bool res = false;
 	pmd_t pmd;
 
 	if (!arch_supports_page_table_move())
@@ -277,19 +278,25 @@ static bool move_normal_pmd(struct vm_ar
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	/* Clear the pmd */
 	pmd = *old_pmd;
+
+	/* Racing with collapse? */
+	if (unlikely(!pmd_present(pmd) || pmd_leaf(pmd)))
+		goto out_unlock;
+	/* Clear the pmd */
 	pmd_clear(old_pmd);
+	res = true;
 
 	VM_BUG_ON(!pmd_none(*new_pmd));
 
 	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
 
-	return true;
+	return res;
 }
 #else
 static inline bool move_normal_pmd(struct vm_area_struct *vma,


