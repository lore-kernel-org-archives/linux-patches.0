Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590618;
	b=cHDZkxzIYYFO3S5Qy/I2RW7RSLmFvJ3wmKjz7wRbKjnJmQsGoNzWtXqlTkn1pBuXsUo2
	 a+ppOfhEytIoMJiIpsumTF6xu7hbHCe6T6wxIDVwUKsvFASRE7EVEWEF6BSVLlE9WzOdL
	 HQzYfKe8BX7bRs5PNoabTGyOJm0Eplc4DLliOj3X+fEZsmVemXkZQQzWqDMsUb7ASM4NS
	 Cl4ZHuhe/PA39ezJWtIe6CeYiPu1s2UPawEXabqlGTDP9ofnPrYxnyeBT3ybwHVyy6zGD
	 az9cyTjjI2LVnbQbstam+ECDFf4E2zeSWkhWSq6qhrMTkY49W0jUrmknubnJhyKwtCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2mb0BFoqFiB/itXQjrR4ty98Acn5/NCNenLhbLR/FQA=;
	b=aclL0FLtgKxd2FxeNwnC5JoQ/hHJxDAspipfMmL/ITqsiqolJ24P8Ym+vCE7kgleEduR
	 4FuyKTJffPlpMpBo581jhn9z8RdbDC8L3doYSGffBy/EUUQoK2KzqZgje/g31lFn7qFe4
	 YUzV0D8NAYB173FyBuPbKPCdTrWsPJ7zJJrBYikeG+l+0a14pSxcHKAswxjkwwyOzrLZG
	 G7lncbDh5i4YiZSTMCMiZZafTcSUU0vqGt+FEfIAH0xa1r+W6DfX0QkeF918zzBJG39hx
	 FKP9KeyxOd7qNTXxFwiOTREsJqk1VRwrTlMf7VyIK02+a7uwUM/jnvnjTWq6xdL2ZPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSKNFswa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9873607586E;
	Fri, 13 Nov 2026 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSKNFswa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6127F1F000C6;
	Fri, 13 Nov 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590618;
	bh=2mb0BFoqFiB/itXQjrR4ty98Acn5/NCNenLhbLR/FQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSKNFswa3Rbi2liN6PU2gqXe0rPFCbGEdJPmftbHJr1daz3v7r1o35ojTCa2+Ps7X
	 Fi2dlxDjRdJMweuXKn9F9ee/GeienBIArbYCzdTdYLRg80BRU0gNKrggeTeDxufy+j
	 w0ObRQp6qVIJsvFPamH/Flu1Wv90n5WE8RpTnCcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ayush Ranjan <ayushr@modal.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/686] mm: memory: fix truncation removing mapped folios
Date: Fri, 13 Nov 2026 10:51:16 -0500
Message-ID: <20261113153839.815415794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 243cf1f67b365668389832463fc31cbb9fec47af ]

Ayush reported an issue that shmem/tmpfs folios are still mapped when
truncating them on production:
"
BUG: Bad page cache in process ...  pfn:...
page dumped because: still mapped when deleted
"

I reproduced the issue with Ayush's reproducer [1] with the latest
mm-unstable branch, and I got the following crash info.  From the dump
message, we can see that truncate_inode_folio() is really trying to remove
mapped folios, which is incorrect.

"
[  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
index:0x3880 pfn:0x191647
[  189.171995] memcg:ffff0000cc073d40
[  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
[  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
.......
[  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
[  189.172026] ------------[ cut here ]------------
[  189.172027] kernel BUG at mm/filemap.c:155!
[  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
.......
[  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
7.3.0-rc4+ #277 PREEMPT(lazy)
.......
[  189.183986] Call trace:
[  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
[  189.184391]  __filemap_remove_folio+0x34/0x160
[  189.184633]  filemap_remove_folio+0x4c/0xb0
[  189.184859]  truncate_inode_folio+0x34/0x58
[  189.185087]  shmem_undo_range+0x220/0x658
[  189.185308]  shmem_fallocate+0x2f0/0x470
[  189.185527]  vfs_fallocate+0x128/0x328
......
[  189.187078]  el0t_64_sync+0x184/0x188
"

After analysis, I believe the race exists between truncation and
MADV_DONTNEED, and shmem's ->map_pages() merely makes the issue easier to
reproduce.  Since MADV_DONTNEED synchronously releases the pagetable page
before calling tlb_flush_rmaps(), this could cause another thread's
truncation to skip zap_pte_range() (due to pmd is none) but still observe
the folio's mapcount as non-zero.  A possible race scenario is as follows:

CPU 0                           CPU 1
shmem_fallocate                 madvise_dontneed_single_vma
  unmap_mapping_range            .......
  ......
  (filemap_map_pages() remap folios)
				  zap_pte_range
  truncate_inode_folio		    zap_empty_pte_table(pmd clear)
    unmap_mapping_folio
    ......
      zap_pmd_range (saw pmd none, skip)

  filemap_remove_folio
    BUG_ON(folio_mapped)
                                    tlb_flush_rmaps(remove rmaps)

To fix this issue, we should move the pmd clear operation (via
zap_empty_pte_table()) to after tlb_flush_rmaps() and use
sync_with_folio_pmd_zap() to sync with concurrent zapping, so that when we
find a pmd_none() while unmapping a folio without holding the PTL, the
folio's mappings are guaranteed to have been removed via
tlb_flush_rmaps().

Meanwhile move the second pmd_none() check to where it belongs: if
splitting zapped the PMD.

Link: https://lore.kernel.org/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/ [1]
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
[ sashal: adapted to try_get_and_clear_pmd() and arch_leave_lazy_mmu_mode() with inline PMD locking in place of sync_with_folio_pmd_zap() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 52 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3049e4dc2651f..e37ae367c8c19 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1877,6 +1877,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
+	add_mm_rss_vec(mm, rss);
+	arch_leave_lazy_mmu_mode();
+
+	/* Do the actual TLB flush before dropping ptl */
+	if (force_flush) {
+		tlb_flush_mmu_tlbonly(tlb);
+		tlb_flush_rmaps(tlb, vma);
+	}
+
 	/*
 	 * Fast path: try to hold the pmd lock and unmap the PTE page.
 	 *
@@ -1884,18 +1893,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * to hold the pmd lock failed, then we need to recheck all pte entries
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
+	 *
+	 * Clear the PMD after the rmaps for the table have been removed, in case
+	 * an incorrect mapcount is observed after unmapping the folio.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
 		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	arch_leave_lazy_mmu_mode();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
-	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
@@ -1942,19 +1945,26 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 				addr = next;
 				continue;
 			}
+			/* We already synchronized with concurrent zapping. */
+			if (pmd_none(*pmd)) {
+				addr = next;
+				continue;
+			}
 			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
-			/*
-			 * Take and drop THP pmd lock so that we cannot return
-			 * prematurely, while zap_huge_pmd() has cleared *pmd,
-			 * but not yet decremented compound_mapcount().
-			 */
-			spin_unlock(ptl);
-		}
-		if (pmd_none(*pmd)) {
+		} else if (pmd_none(*pmd)) {
+			if (details && details->single_folio) {
+				spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
+
+				/*
+				 * zap_huge_pmd() may have cleared the PMD but not
+				 * yet updated the folio mapcount, and
+				 * try_get_and_clear_pmd() clears the PMD only after
+				 * the rmaps for the table have been removed, but
+				 * nothing orders the pmd_none() read against later
+				 * mapcount reads without this synchronization.
+				 */
+				spin_unlock(ptl);
+			}
 			addr = next;
 			continue;
 		}
-- 
2.53.0



