Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511B82E40E;
	Fri, 24 Nov 2023 18:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYsQk/sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD39C433C8;
	Fri, 24 Nov 2023 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851284;
	bh=ikGz/aeY+IRGmZzQwcd/7R0nyIhcfQcYObb61L42OEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYsQk/sEJ3NVTjtvhuqZyGEIGysrmEjk486aAreMP7ptygqRgsfX0qvkgayLLHj13
	 yiWOl2hCwuOFjqGX9Gi9xKxJyDOhqv2Gs4Tc6yFgdZqruBENqlnwPcRU5Yv0wuDZIU
	 jXnx7G89xEJ/jq//ZSf1aiusnR1qKVwc7qYIcke4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 379/491] mm/hugetlb: prepare hugetlb_follow_page_mask() for FOLL_PIN
Date: Fri, 24 Nov 2023 17:50:15 +0000
Message-ID: <20231124172035.979372545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 458568c92953dee3716234711f1a2830a35261f3 ]

follow_page() doesn't use FOLL_PIN, meanwhile hugetlb seems to not be the
target of FOLL_WRITE either.  However add the checks.

Namely, either the need to CoW due to missing write bit, or proper
unsharing on !AnonExclusive pages over R/O pins to reject the follow page.
That brings this function closer to follow_hugetlb_page().

So we don't care before, and also for now.  But we'll care if we switch
over slow-gup to use hugetlb_follow_page_mask().  We'll also care when to
return -EMLINK properly, as that's the gup internal api to mean "we should
unshare".  Not really needed for follow page path, though.

When at it, switching the try_grab_page() to use WARN_ON_ONCE(), to be
clear that it just should never fail.  When error happens, instead of
setting page==NULL, capture the errno instead.

Link: https://lkml.kernel.org/r/20230628215310.73782-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 426056efe835 ("mm/hugetlb: use nth_page() in place of direct struct page manipulation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 097b81c37597e..d231f23088a77 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6521,13 +6521,7 @@ struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 	struct page *page = NULL;
 	spinlock_t *ptl;
 	pte_t *pte, entry;
-
-	/*
-	 * FOLL_PIN is not supported for follow_page(). Ordinary GUP goes via
-	 * follow_hugetlb_page().
-	 */
-	if (WARN_ON_ONCE(flags & FOLL_PIN))
-		return NULL;
+	int ret;
 
 	hugetlb_vma_lock_read(vma);
 	pte = hugetlb_walk(vma, haddr, huge_page_size(h));
@@ -6537,8 +6531,23 @@ struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 	ptl = huge_pte_lock(h, mm, pte);
 	entry = huge_ptep_get(pte);
 	if (pte_present(entry)) {
-		page = pte_page(entry) +
-				((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = pte_page(entry);
+
+		if (!huge_pte_write(entry)) {
+			if (flags & FOLL_WRITE) {
+				page = NULL;
+				goto out;
+			}
+
+			if (gup_must_unshare(vma, flags, page)) {
+				/* Tell the caller to do unsharing */
+				page = ERR_PTR(-EMLINK);
+				goto out;
+			}
+		}
+
+		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+
 		/*
 		 * Note that page may be a sub-page, and with vmemmap
 		 * optimizations the page struct may be read only.
@@ -6548,8 +6557,10 @@ struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 		 * try_grab_page() should always be able to get the page here,
 		 * because we hold the ptl lock and have verified pte_present().
 		 */
-		if (try_grab_page(page, flags)) {
-			page = NULL;
+		ret = try_grab_page(page, flags);
+
+		if (WARN_ON_ONCE(ret)) {
+			page = ERR_PTR(ret);
 			goto out;
 		}
 	}
-- 
2.42.0



