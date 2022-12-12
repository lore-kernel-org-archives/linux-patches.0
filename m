Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36C428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC557C43392;
	Mon, 12 Dec 2022 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850890;
	bh=jIXSjnRGbT3QfL7VnQW0EhXTuNRfDQDZ4dMFrgB+9lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2teXkH7crkrzUOA+f5pfCOO67xdHzd6oaEyZpH1ba8iZXu6Zttmctl4XUjAMK63P
	 N2lKXdWtTPg/KtKfnF+yzT8a9yIS7YItlJmc7nlvc5WQTT5z6a4b5PhkgI2kRl1Thg
	 VVb8E6mKRSEkrbI6mwSiuJJ6/pJtnIVNnFUGV6Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/106] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date: Mon, 12 Dec 2022 14:09:32 +0100
Message-Id: <20221212130926.126661624@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

commit f268f6cf875f3220afc77bdd0bf1bb136eb54db9 upstream.

Any codepath that zaps page table entries must invoke MMU notifiers to
ensure that secondary MMUs (like KVM) don't keep accessing pages which
aren't mapped anymore.  Secondary MMUs don't hold their own references to
pages that are mirrored over, so failing to notify them can lead to page
use-after-free.

I'm marking this as addressing an issue introduced in commit f3f0e1d2150b
("khugepaged: add support of collapse for tmpfs/shmem pages"), but most of
the security impact of this only came in commit 27e1f8273113 ("khugepaged:
enable collapse pmd for pte-mapped THP"), which actually omitted flushes
for the removal of present PTEs, not just for the removal of empty page
tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-3-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-3-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[manual backport: this code was refactored from two copies into a common
helper between 5.15 and 6.0]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0268b549bd60..0eb3adf4ff68 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1444,6 +1444,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
+	struct mmu_notifier_range range;
 
 	if (!vma || !vma->vm_file ||
 	    vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE)
@@ -1537,9 +1538,13 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
+				haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	mm_dec_nr_ptes(mm);
 	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
@@ -1624,11 +1629,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (mmap_write_trylock(mm)) {
 			if (!khugepaged_test_exit(mm)) {
+				struct mmu_notifier_range range;
+
+				mmu_notifier_range_init(&range,
+							MMU_NOTIFY_CLEAR, 0,
+							NULL, mm, addr,
+							addr + HPAGE_PMD_SIZE);
+				mmu_notifier_invalidate_range_start(&range);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				mm_dec_nr_ptes(mm);
 				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(&range);
 			}
 			mmap_write_unlock(mm);
 		} else {
-- 
2.35.1



