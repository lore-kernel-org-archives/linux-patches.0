Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C534C83A;
	Fri, 21 Nov 2025 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732062; cv=none; b=BBSDcpmU93PHeyNVMho8SzZ0tOl17Gp2euFBhXLWpXTDm29uMm8uwtNHk5UaE8PBAxCVUQJAvmgoAUph5J+2aYexnKXXhhnSTmWP2JIpqFY3Gm2Cppri8L2rYWdRDOzIra6AKcy8rEqEhwvCuYvSfn8tYP7pzmQZUfMN3o+r0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732062; c=relaxed/simple;
	bh=0qaAWi9gkjXt1Mx8CIeeIontv2Eg2EoL/njIAe8qyXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiHEtWydLmiAF/Kh9BejynJbrI9aYEy4jbhPYHRnRpZOkp/N1uAS97sb2Rf6+LmQVuItMDCKW3k6rCYeoSkZs54OW2rB7TrzXrH4Vtd+XOc1yixSxbZBR/8VHRLgdzWUplFco7pjWUjd9NauMAWtQr2sPQ6lY4DKsriMB97tqjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqMZyRXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqMZyRXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBADC4CEF1;
	Fri, 21 Nov 2025 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732062;
	bh=0qaAWi9gkjXt1Mx8CIeeIontv2Eg2EoL/njIAe8qyXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqMZyRXV6tsNummFGIftOjKdGcDrHlALxWaIs6FoVpXIQS9/e88gtqR9wB80vBF2N
	 upzAPnwyQlvq9O3ukBqLiX53E48jG7EJVYeXSYtDw7sp05ia0ynAJRy4xAMJSCC/PZ
	 DhnKfVl/5HFqz/dcC+GxDjTZ1TB4DOstBIIAJszQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 176/185] mm/memory: do not populate page table entries beyond i_size
Date: Fri, 21 Nov 2025 14:13:23 +0100
Message-ID: <20251121130150.241665641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Kiryl Shutsemau <kas@kernel.org>

commit 74207de2ba10c2973334906822dc94d2e859ffc5 upstream.

Patch series "Fix SIGBUS semantics with large folios", v3.

Accessing memory within a VMA, but beyond i_size rounded up to the next
page size, is supposed to generate SIGBUS.

Darrick reported[1] an xfstests regression in v6.18-rc1.  generic/749
failed due to missing SIGBUS.  This was caused by my recent changes that
try to fault in the whole folio where possible:

        19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
        357b92761d94 ("mm/filemap: map entire large folio faultaround")

These changes did not consider i_size when setting up PTEs, leading to
xfstest breakage.

However, the problem has been present in the kernel for a long time -
since huge tmpfs was introduced in 2016.  The kernel happily maps
PMD-sized folios as PMD without checking i_size.  And huge=always tmpfs
allocates PMD-size folios on any writes.

I considered this corner case when I implemented a large tmpfs, and my
conclusion was that no one in their right mind should rely on receiving a
SIGBUS signal when accessing beyond i_size.  I cannot imagine how it could
be useful for the workload.

But apparently filesystem folks care a lot about preserving strict SIGBUS
semantics.

Generic/749 was introduced last year with reference to POSIX, but no real
workloads were mentioned.  It also acknowledged the tmpfs deviation from
the test case.

POSIX indeed says[3]:

        References within the address range starting at pa and
        continuing for len bytes to whole pages following the end of an
        object shall result in delivery of a SIGBUS signal.

The patchset fixes the regression introduced by recent changes as well as
more subtle SIGBUS breakage due to split failure on truncation.


This patch (of 2):

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

Recent changes attempted to fault in full folio where possible.  They did
not respect i_size, which led to populating PTEs beyond i_size and
breaking SIGBUS semantics.

Darrick reported generic/749 breakage because of this.

However, the problem existed before the recent changes.  With huge=always
tmpfs, any write to a file leads to PMD-size allocation.  Following the
fault-in of the folio will install PMD mapping regardless of i_size.

Fix filemap_map_pages() and finish_fault() to not install:
  - PTEs beyond i_size;
  - PMD mappings across i_size;

Make an exception for shmem/tmpfs that for long time intentionally
mapped with PMDs across i_size.

Link: https://lkml.kernel.org/r/20251027115636.82382-1-kirill@shutemov.name
Link: https://lkml.kernel.org/r/20251027115636.82382-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Fixes: 6795801366da ("xfs: Support large folios")
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   20 +++++++++++++++-----
 mm/memory.c  |   23 +++++++++++++++++++++--
 2 files changed, 36 insertions(+), 7 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3653,13 +3653,27 @@ vm_fault_t filemap_map_pages(struct vm_f
 	vm_fault_t ret = 0;
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, mmap_miss = 0, mmap_miss_saved, folio_type;
+	bool can_map_large;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
 	if (!folio)
 		goto out;
 
-	if (filemap_map_pmd(vmf, folio, start_pgoff)) {
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
+	/*
+	 * Do not allow to map with PTEs beyond i_size and with PMD
+	 * across i_size to preserve SIGBUS semantics.
+	 *
+	 * Make an exception for shmem/tmpfs that for long time
+	 * intentionally mapped with PMDs across i_size.
+	 */
+	can_map_large = shmem_mapping(mapping) ||
+		file_end >= folio_next_index(folio);
+
+	if (can_map_large && filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3672,10 +3686,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 		goto out;
 	}
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	if (end_pgoff > file_end)
-		end_pgoff = file_end;
-
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -68,6 +68,7 @@
 #include <linux/gfp.h>
 #include <linux/migrate.h>
 #include <linux/string.h>
+#include <linux/shmem_fs.h>
 #include <linux/memory-tiers.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
@@ -5088,6 +5089,8 @@ fallback:
 	else
 		page = vmf->page;
 
+	folio = page_folio(page);
+
 	/*
 	 * check even for read faults because we might have lost our CoWed
 	 * page
@@ -5098,8 +5101,25 @@ fallback:
 			return ret;
 	}
 
+	if (!needs_fallback && vma->vm_file) {
+		struct address_space *mapping = vma->vm_file->f_mapping;
+		pgoff_t file_end;
+
+		file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+
+		/*
+		 * Do not allow to map with PTEs beyond i_size and with PMD
+		 * across i_size to preserve SIGBUS semantics.
+		 *
+		 * Make an exception for shmem/tmpfs that for long time
+		 * intentionally mapped with PMDs across i_size.
+		 */
+		needs_fallback = !shmem_mapping(mapping) &&
+			file_end < folio_next_index(folio);
+	}
+
 	if (pmd_none(*vmf->pmd)) {
-		if (PageTransCompound(page)) {
+		if (!needs_fallback && PageTransCompound(page)) {
 			ret = do_set_pmd(vmf, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
@@ -5111,7 +5131,6 @@ fallback:
 			return VM_FAULT_OOM;
 	}
 
-	folio = page_folio(page);
 	nr_pages = folio_nr_pages(folio);
 
 	/*


