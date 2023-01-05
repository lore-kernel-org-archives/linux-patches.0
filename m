Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B2663DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F462C433EF;
	Thu,  5 Jan 2023 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923437;
	bh=SM77s2y4r8NlOgo2ssY2RbmTJN9AxN+YvyyEEiHEBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzpZDGiWg7BpR/oTwWsKAiPIZhIdQG9G9TqcmPqj6wlJnPt4OHQDWOIC5gH6BzOGY
	 KLtXzHrLO1ylUX4VpSzb1KMIxl4uOFnhLeTTIrymbSLXfLc2/sszKuptZAn0IA+6HO
	 GHW+u8kgCn7CD3KmtXDbwE/8C556E4d+0GslI6eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 002/251] mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths
Date: Thu,  5 Jan 2023 13:52:19 +0100
Message-Id: <20230105125334.848402248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
helper between 5.15 and 6.0;
pmd collapse for PTE-mapped THP was only added in 5.4;
MMU notifier API changed between 4.19 and 5.4]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1302,13 +1302,20 @@ static void retract_page_tables(struct a
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
+				spinlock_t *ptl;
+				unsigned long end = addr + HPAGE_PMD_SIZE;
+
+				mmu_notifier_invalidate_range_start(mm, addr,
+								    end);
+				ptl = pmd_lock(mm, pmd);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				atomic_long_dec(&mm->nr_ptes);
 				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(mm, addr,
+								  end);
 			}
 			up_write(&mm->mmap_sem);
 		}


