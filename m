Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBEE27B328;
	Tue, 30 Sep 2025 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245436; cv=none; b=cRV66bFrbjox3waCj4qma4kouSzcuWg1df5OqlUULooD03BkR14P+IxPCrlH8a7PCzkgjeBwKAwNLFU6HMIPxuCnPYG48LLKJoGbzYqIs+1K7GgjKsGJvGguFYbnYhzzYSxIkSvwVQdsr4AvfVr+eKADjxlWJnBW6kUrJS/qtFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245436; c=relaxed/simple;
	bh=xnID8nKoXsprt0eFPNnTVL8YGrhL7Btryd2WpkVGBTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bldvpld5Lm1bwGgTseQtqKcSjM9v83tgaAz9lTpWSsNYwGophNYjaO60O0nNXI/doU4LqQombIXwd+hFGIEQkBZaeX7tNrivsf1Mi4u+nLJeINPaJT4a1SXH7zowzA5aF2OLXVNfwFVNr0Y36ceQezj//zoICHm3Ev5ELkiqCxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiRqgdKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiRqgdKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A82CC4CEF0;
	Tue, 30 Sep 2025 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245435;
	bh=xnID8nKoXsprt0eFPNnTVL8YGrhL7Btryd2WpkVGBTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiRqgdKbpTfhaKG6ZM8NWlc81EjjFjlUO/3HSXV8Vy0Or1Cclt1JmjRhuZmDLZeJk
	 NlxHd5d5P7bH656FV6qjeiybDGvZsHMPAh83cjXA93oAiW6pwt0yiNY/1nUoqhZue/
	 S//tHXmDPy+/5+2b61NBmY5/rgAo05Om4T03PWWQ=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/73] mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
Date: Tue, 30 Sep 2025 16:47:22 +0200
Message-ID: <20250930143821.318082947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 517f496e1e61bd169d585dab4dd77e7147506322 ]

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
[ Revert v6.1.129 commit c986a5fb15ed ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 37c55e61460e2..599c6b9453166 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1961,14 +1961,14 @@ struct page *get_dump_page(unsigned long addr)
 /*
  * Returns the number of collected pages. Return value is always >= 0.
  */
-static void collect_longterm_unpinnable_pages(
+static unsigned long collect_longterm_unpinnable_pages(
 					struct list_head *movable_page_list,
 					unsigned long nr_pages,
 					struct page **pages)
 {
+	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
-	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
@@ -1980,6 +1980,8 @@ static void collect_longterm_unpinnable_pages(
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
+		collected++;
+
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -2001,6 +2003,8 @@ static void collect_longterm_unpinnable_pages(
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
+
+	return collected;
 }
 
 /*
@@ -2093,10 +2097,12 @@ static int migrate_longterm_unpinnable_pages(
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
 {
+	unsigned long collected;
 	LIST_HEAD(movable_page_list);
 
-	collect_longterm_unpinnable_pages(&movable_page_list, nr_pages, pages);
-	if (list_empty(&movable_page_list))
+	collected = collect_longterm_unpinnable_pages(&movable_page_list,
+						nr_pages, pages);
+	if (!collected)
 		return 0;
 
 	return migrate_longterm_unpinnable_pages(&movable_page_list, nr_pages,
-- 
2.51.0



