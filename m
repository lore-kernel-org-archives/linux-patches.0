Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA57F
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 00:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38A8C340EB;
	Sat, 12 Feb 2022 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1644625738;
	bh=nAsAa9beVcKSKQQrisgnyE7yrkfz/RWQFq7n6+rP2ek=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=StQn2tCP1Gd0OzsV9k3No9GiwBsdUVvRLcT8hmQAtiikRol0Emy+fxcFHFspaDRNv
	 oo+DoPSRhNVGNWM/N0vcNnr9EpkOozkuNcjk2L3XcReu1BStZvsQeTV+ri9QA58jey
	 0uDdzMiNBsxddZqsFZ3PafbRpeD71kx+IOudupao=
Date: Fri, 11 Feb 2022 16:28:58 -0800
To: willy@infradead.org,peterx@redhat.com,lukas.bulwahn@gmail.com,kirill.shutemov@linux.intel.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,imbrenda@linux.ibm.com,hch@lst.de,david@redhat.com,alex.williamson@redhat.com,aarcange@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 2/5] mm/gup: follow_pfn_pte(): -EEXIST cleanup
Message-Id: <20220212002858.B38A8C340EB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: follow_pfn_pte(): -EEXIST cleanup

Remove a quirky special case from follow_pfn_pte(), and adjust its callers
to match.  Caller changes include:

__get_user_pages(): Regardless of any FOLL_* flags, get_user_pages() and
its variants should handle PFN-only entries by stopping early, if the
caller expected **pages to be filled in.  This makes for a more reliable
API, as compared to the previous approach of skipping over such entries
(and thus leaving them silently unwritten).

move_pages(): squash the -EEXIST error return from follow_page() into
-EFAULT, because -EFAULT is listed in the man page, whereas -EEXIST is
not.

Link: https://lkml.kernel.org/r/20220204020010.68930-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-follow_pfn_pte-eexist-cleanup
+++ a/mm/gup.c
@@ -464,10 +464,6 @@ static struct page *no_page_table(struct
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
-	/* No page to get reference */
-	if (flags & (FOLL_GET | FOLL_PIN))
-		return -EFAULT;
-
 	if (flags & FOLL_TOUCH) {
 		pte_t entry = *pte;
 
@@ -1205,8 +1201,15 @@ retry:
 		} else if (PTR_ERR(page) == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
-			 * struct page.
+			 * struct page. If the caller expects **pages to be
+			 * filled in, bail out now, because that can't be done
+			 * for this page.
 			 */
+			if (pages) {
+				ret = PTR_ERR(page);
+				goto out;
+			}
+
 			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
--- a/mm/migrate.c~mm-gup-follow_pfn_pte-eexist-cleanup
+++ a/mm/migrate.c
@@ -1762,6 +1762,13 @@ static int do_pages_move(struct mm_struc
 		}
 
 		/*
+		 * The move_pages() man page does not have an -EEXIST choice, so
+		 * use -EFAULT instead.
+		 */
+		if (err == -EEXIST)
+			err = -EFAULT;
+
+		/*
 		 * If the page is already on the target node (!err), store the
 		 * node, otherwise, store the err.
 		 */
_
