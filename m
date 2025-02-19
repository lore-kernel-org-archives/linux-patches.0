Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BE418FC86;
	Wed, 19 Feb 2025 09:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955883; cv=none; b=UyuOAd6WQMmJUriDc+yTiK1pPerlHMLYCTYi1hAYYCYhmYiXJZlvU5CKpC1bS8EoVCIGLeTCpxtVxFKULtDjzAM/qcsW2m9Znk1wfL0zx47qHxAeGO+X6v1OH4yDYh2yZjI4OJf9WUKshe9Yew1o4lOGw+mrBgz37HBrmyaL9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955883; c=relaxed/simple;
	bh=Vvfwf9TQF8MUiSPHhCLm9J+WU02mlG4EZ9xrfVlrGUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtYhba0xI9I6qaAAmZ30i1JecpnqfOw5jiXLHyIT3NUjxEqLTJS2mJ5HKoF/o16bXP0eFvANP6hBABcZGlDx8cGUnlz6vXtjh5oeOaZNnRshMqD15YKcmdwNWKwmuIqgcKeVInwWx/MWrX28ftlF4DNqtwuxudgwQemmVQWO4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP4kfema; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP4kfema"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7050C4CED1;
	Wed, 19 Feb 2025 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955882;
	bh=Vvfwf9TQF8MUiSPHhCLm9J+WU02mlG4EZ9xrfVlrGUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP4kfemahTestqboOhDqYom5Civ8peWa56e/IF1ZGbiKj16VcNIuHqDSlzrCDEIoA
	 5QOptyavpxf1krDMHTVSIleUpdmlQ+ctTRUq7reYcQzhe3tFWLbgtnsq9FZpIfvFcD
	 y9akt1Bf2VE60pcLKy/JTth5BMlVSCDBj25rStbQ=
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
Subject: [PATCH 6.6 145/152] mm: gup: fix infinite loop within __get_longterm_locked
Date: Wed, 19 Feb 2025 09:29:18 +0100
Message-ID: <20250219082555.785479119@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1946,14 +1946,14 @@ struct page *get_dump_page(unsigned long
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
@@ -1965,8 +1965,6 @@ static unsigned long collect_longterm_un
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
-		collected++;
-
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -1988,8 +1986,6 @@ static unsigned long collect_longterm_un
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
-
-	return collected;
 }
 
 /*
@@ -2082,12 +2078,10 @@ err:
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


