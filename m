Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662DF126BFF;
	Thu,  3 Jul 2025 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554289; cv=none; b=e+B6dnPQ9ymeCHOHrZMWi44eDYw/MmRPXDVppBc0dXkq8J0BuuTGGOe8cvxcCjzO5pj87KnS1t1PR57aa9PAbSh6RcreO9kNjGLKImrmXK4Ha8sXzghBGPNdOA52kklGxBaWBvjJHBBboyBWsW/gWmVLXs46LrKosMmIry4WWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554289; c=relaxed/simple;
	bh=4JPHWYs6lUOTJYsFDUaoTt8lwojOYSGldx2eqgYZSEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/oAeEjwiknuOALC8eAsPsdbsWVAeaGzjWzCgFqKfnKHIfiiVOEskR9miZyNP7/n6kNe0BsPUPhY9FY1F0TOajtliOcbVvhGhlRb7dvqppJWFsDt5iK5U0II3b4OMUwaY9TYBQOhT/PPk2FKP5oMwSYSVxjvl8WvVokEhbES8Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOpvAYzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOpvAYzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA379C4CEE3;
	Thu,  3 Jul 2025 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554289;
	bh=4JPHWYs6lUOTJYsFDUaoTt8lwojOYSGldx2eqgYZSEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOpvAYzo5xu6eGIdsWtM7v265cJCPVQqsS6agDA3cnN8XBwu52ECEgsCCdTSkbbd1
	 WRACKcX7jxDl52gP2r0k85cVchDi6NVAGgrPVEuOwt+u98A9wP4TzQ4Pt0qlbpzcTv
	 J8NjclvabL7skKgigFUdwPYs8NbBta0i9jJ93fXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Aijun Sun <aijun.sun@unisoc.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 140/218] mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
Date: Thu,  3 Jul 2025 16:41:28 +0200
Message-ID: <20250703144001.725325792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Hildenbrand <david@redhat.com>

commit 517f496e1e61bd169d585dab4dd77e7147506322 upstream.

After commit 1aaf8c122918 ("mm: gup: fix infinite loop within
__get_longterm_locked") we are able to longterm pin folios that are not
supposed to get longterm pinned, simply because they temporarily have the
LRU flag cleared (esp.  temporarily isolated).

For example, two __get_longterm_locked() callers can race, or
__get_longterm_locked() can race with anything else that temporarily
isolates folios.

The introducing commit mentions the use case of a driver that uses
vm_ops->fault to insert pages allocated through cma_alloc() into the page
tables, assuming they can later get longterm pinned.  These pages/ folios
would never have the LRU flag set and consequently cannot get isolated.
There is no known in-tree user making use of that so far, fortunately.

To handle that in the future -- and avoid retrying forever to
isolate/migrate them -- we will need a different mechanism for the CMA
area *owner* to indicate that it actually already allocated the page and
is fine with longterm pinning it.  The LRU flag is not suitable for that.

Probably we can lookup the relevant CMA area and query the bitmap; we only
have have to care about some races, probably.  If already allocated, we
could just allow longterm pinning)

Anyhow, let's fix the "must not be longterm pinned" problem first by
reverting the original commit.

Link: https://lkml.kernel.org/r/20250611131314.594529-1-david@redhat.com
Fixes: 1aaf8c122918 ("mm: gup: fix infinite loop within __get_longterm_locked")
Signed-off-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/all/20250522092755.GA3277597@tiffany/
Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2326,13 +2326,13 @@ static void pofs_unpin(struct pages_or_f
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
-static void collect_longterm_unpinnable_folios(
+static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
-	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
@@ -2344,6 +2344,8 @@ static void collect_longterm_unpinnable_
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
+		collected++;
+
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -2365,6 +2367,8 @@ static void collect_longterm_unpinnable_
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
+
+	return collected;
 }
 
 /*
@@ -2441,9 +2445,11 @@ static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
+	unsigned long collected;
 
-	collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
-	if (list_empty(&movable_folio_list))
+	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
+						       pofs);
+	if (!collected)
 		return 0;
 
 	return migrate_longterm_unpinnable_folios(&movable_folio_list, pofs);


