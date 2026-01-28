Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA723033C4;
	Wed, 28 Jan 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616149; cv=none; b=HVqByRxpchotf4Xs7Eh3lKej0Y23mCuVv+oZz9Q0dy9fmencsm5cr1dKW25wJDlsUUMzJNKgJHHa640z4FEdU4XAN1dmgdGsBcZxxF5L3MyUz5SiF1ozmm0NLw5xTTsYpZKlA6lUVkD3sYMzr7s1KjJDss7ee6MniV1iP+G3LGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616149; c=relaxed/simple;
	bh=lkp4jlBGEN8fF1HyL0Gqgi78lqCFBfm3fsegFdPNbnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By63hy/YpOGCw4wrpUE+0Rg9Hb2SqF6xyKvysEyEJrHTsRsngYydBLuGc55xWfThJX0w3aUNqiEakBb1ihGjwwcYM5NIIryNCmJGI6lP1uD1aamlVxn8/LBkehQtkXuP2tvzNcC2VrFO830YwMdP+r3Iey8qDKwedUrffp+Ogrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKlctt7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKlctt7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B44C4CEF1;
	Wed, 28 Jan 2026 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616149;
	bh=lkp4jlBGEN8fF1HyL0Gqgi78lqCFBfm3fsegFdPNbnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKlctt7kgkB/cmYNXvlSSI9z1SPs/xITXWixH+lT7dwD3n+E4lDx0ckFQaCD4DugV
	 s9hmMtR8PAoXts1Jn69UKA/0V9/pN1wJXPzpv1OTC2pGopjH/6/9mQfaK/CPbYBmfD
	 7qZzgqIYwrZ7fQUhHGnb6r3h32t0UyJr6Biv9kf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Harry Yoo <harry.yoo@oracle.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Uschakow, Stanislav" <suschako@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/227] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Wed, 28 Jan 2026 16:24:26 +0100
Message-ID: <20260128145352.385701841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

[ Upstream commit 3937027caecb4f8251e82dd857ba1d749bb5a428 ]

Ever since we stopped using the page count to detect shared PMD page
tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop the
i_mmap_rwsem, the previously shared page table could get freed (to then
get reallocated and used for other purpose).  So we really have to flush
the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded in
the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do anything.
So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Link: https://lkml.kernel.org/r/20251223214037.580860-3-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6005,17 +6005,10 @@ void __unmap_hugepage_range(struct mmu_g
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -7226,11 +7219,10 @@ long hugetlb_change_protection(struct vm
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);


