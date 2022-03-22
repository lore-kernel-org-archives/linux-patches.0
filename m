Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4436453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971D9C340EC;
	Tue, 22 Mar 2022 21:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985187;
	bh=TkJ0cJQXEXCw8B24NXJixdrql+CcTRDCJStXqy3s2GY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=QD/F/geTDZra5hTN341pb3wrNihHd/7RDPomf12PbYr3a6a4lDaT0oBLIfQyxp/4m
	 H+oMJWGpTZrVtxdLDIefgb307E+ikHOVYlWcNZRATffqhzbZDOky6nEP0YrrMoQV+J
	 uMkgAyyNx1cHQfMweheJegXHYWlcdwU8ML0Ft2aM=
Date: Tue, 22 Mar 2022 14:39:46 -0700
To: willy@infradead.org,peterx@redhat.com,lukas.bulwahn@gmail.com,kirill.shutemov@linux.intel.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,imbrenda@linux.ibm.com,hch@lst.de,david@redhat.com,alex.williamson@redhat.com,aarcange@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 025/227] mm: change lookup_node() to use get_user_pages_fast()
Message-Id: <20220322213947.971D9C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm: change lookup_node() to use get_user_pages_fast()

The purpose of calling get_user_pages_locked() from lookup_node() was to
allow for unlocking the mmap_lock when reading a page from the disk during
a page fault (hidden behind VM_FAULT_RETRY).  The idea was to reduce
contention on the heavily-used mmap_lock.  (Thanks to Jan Kara for clearly
pointing that out, and in fact I've used some of his wording here.)

However, it is unlikely for lookup_node() to take a page fault.  With that
in mind, change over to calling get_user_pages_fast().  This simplifies
the code, runs a little faster in the expected case, and allows removing
get_user_pages_locked() entirely, in a subsequent patch.

Link: https://lkml.kernel.org/r/20220204020010.68930-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/mempolicy.c~mm-change-lookup_node-to-use-get_user_pages_fast
+++ a/mm/mempolicy.c
@@ -907,17 +907,14 @@ static void get_policy_nodemask(struct m
 static int lookup_node(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *p = NULL;
-	int err;
+	int ret;
 
-	int locked = 1;
-	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
-	if (err > 0) {
-		err = page_to_nid(p);
+	ret = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
+	if (ret > 0) {
+		ret = page_to_nid(p);
 		put_page(p);
 	}
-	if (locked)
-		mmap_read_unlock(mm);
-	return err;
+	return ret;
 }
 
 /* Retrieve NUMA policy */
@@ -968,14 +965,14 @@ static long do_get_mempolicy(int *policy
 	if (flags & MPOL_F_NODE) {
 		if (flags & MPOL_F_ADDR) {
 			/*
-			 * Take a refcount on the mpol, lookup_node()
-			 * will drop the mmap_lock, so after calling
-			 * lookup_node() only "pol" remains valid, "vma"
-			 * is stale.
+			 * Take a refcount on the mpol, because we are about to
+			 * drop the mmap_lock, after which only "pol" remains
+			 * valid, "vma" is stale.
 			 */
 			pol_refcount = pol;
 			vma = NULL;
 			mpol_get(pol);
+			mmap_read_unlock(mm);
 			err = lookup_node(mm, addr);
 			if (err < 0)
 				goto out;
_
