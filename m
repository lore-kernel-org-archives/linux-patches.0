Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD91B85EC;
	Wed, 19 Feb 2025 09:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957609; cv=none; b=gSmPV96JNAMTSemCYx+KbuawzLhUL9K7uhILy8zyIK7VaNMHLZbeyrkcbhPXcqQb1Zo3gnzTukJsqA5u6zvH/JJJQ1WpCGlpdK5x5whzn5q/ILthUWt5sNH7/SctOORm9FHM3XpYEIz0qIORSDwoARQdScc/s73dci5XQQicSx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957609; c=relaxed/simple;
	bh=qS6UV334fOTFCgD0Nx/fp/Lul8nBiFMAPhcAz+xbryw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+2pchPwmFMKL1An/uc+n4mKgBDnb7RJgkCO5GTFOS7sbjnoiAQRcDBean+LglbH77/VqAnB/zxbbt7WcKNvvef0JxHKRZMXZNM///SwYfb4nj2zh5PuE2VPm2lXli0izIYSsvYFTXPy0tXZCDi/6ghSM850Hc0HAfxl9Fl6tAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5TUGZvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5TUGZvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9A1C4CED1;
	Wed, 19 Feb 2025 09:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957609;
	bh=qS6UV334fOTFCgD0Nx/fp/Lul8nBiFMAPhcAz+xbryw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5TUGZvTP77E+W/G5dg6MxPTvKg2Cd2st/n1CZfCxOqzI+9eJ5LeeZf6tQNePNN9Y
	 GZm0IVOGfShNQJyKVNJUBehNR1fq7jKNi2yY4m8tz8BK/lz48sU5iuPqJpLGfXWAYA
	 R3Fq1cvWc26AXYRw6laO5hACO6iQkHpjALsK2i+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Aijun Sun <aijun.sun@unisoc.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 563/578] mm: gup: fix infinite loop within __get_longterm_locked
Date: Wed, 19 Feb 2025 09:29:27 +0100
Message-ID: <20250219082715.108246639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

commit 1aaf8c122918aa8897605a9aa1e8ed6600d6f930 upstream.

We can run into an infinite loop in __get_longterm_locked() when
collect_longterm_unpinnable_folios() finds only folios that are isolated
from the LRU or were never added to the LRU.  This can happen when all
folios to be pinned are never added to the LRU, for example when
vm_ops->fault allocated pages using cma_alloc() and never added them to
the LRU.

Fix it by simply taking a look at the list in the single caller, to see if
anything was added.

[zhaoyang.huang@unisoc.com: move definition of local]
  Link: https://lkml.kernel.org/r/20250122012604.3654667-1-zhaoyang.huang@unisoc.com
Link: https://lkml.kernel.org/r/20250121020159.3636477-1-zhaoyang.huang@unisoc.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1944,14 +1944,14 @@ struct page *get_dump_page(unsigned long
 /*
  * Returns the number of collected pages. Return value is always >= 0.
  */
-static unsigned long collect_longterm_unpinnable_pages(
+static void collect_longterm_unpinnable_pages(
 					struct list_head *movable_page_list,
 					unsigned long nr_pages,
 					struct page **pages)
 {
-	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
+	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
@@ -1963,8 +1963,6 @@ static unsigned long collect_longterm_un
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
-		collected++;
-
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -1986,8 +1984,6 @@ static unsigned long collect_longterm_un
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
-
-	return collected;
 }
 
 /*
@@ -2080,12 +2076,10 @@ err:
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
 {
-	unsigned long collected;
 	LIST_HEAD(movable_page_list);
 
-	collected = collect_longterm_unpinnable_pages(&movable_page_list,
-						nr_pages, pages);
-	if (!collected)
+	collect_longterm_unpinnable_pages(&movable_page_list, nr_pages, pages);
+	if (list_empty(&movable_page_list))
 		return 0;
 
 	return migrate_longterm_unpinnable_pages(&movable_page_list, nr_pages,


