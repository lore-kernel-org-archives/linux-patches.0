Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592FC1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AF1C340EC;
	Fri, 25 Mar 2022 01:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170593;
	bh=ScfNCgSDD6pedCbQrNdSqkDjkRn4PGxjSfzYW38zyu8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=ME5XJuqNdtRNxpyTqyXPwaigsRpJfLz/OY6ZQZyQ8ELJWN6h+HYH6srxnJkv3RMYX
	 tUPC0QxonVrI0z/LZLfHK6Zmhuf4gzcdlyEb+EZxd3T8wOUqPpN11SJBqIhrmpjoVQ
	 AtzWLIKrWfKpKATY5+tBiG1dmxdyqGGDcZ7Em2Fo=
Date: Thu, 24 Mar 2022 18:09:52 -0700
To: willy@infradead.org,hughd@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 026/114] mm: filemap_unaccount_folio() large skip mapcount fixup
Message-Id: <20220325010953.25AF1C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Hugh Dickins <hughd@google.com>
Subject: mm: filemap_unaccount_folio() large skip mapcount fixup

The page_mapcount_reset() when folio_mapped() while mapping_exiting() was
devised long before there were huge or compound pages in the cache.  It is
still valid for small pages, but not at all clear what's right to check
and reset on large pages.  Just don't try when folio_test_large().

Link: https://lkml.kernel.org/r/879c4426-4122-da9c-1a86-697f2c9a083@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap_unaccount_folio-large-skip-mapcount-fixup
+++ a/mm/filemap.c
@@ -152,25 +152,25 @@ static void filemap_unaccount_folio(stru
 
 	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(folio_mapped(folio))) {
-		int mapcount;
-
 		pr_alert("BUG: Bad page cache in process %s  pfn:%05lx\n",
 			 current->comm, folio_pfn(folio));
 		dump_page(&folio->page, "still mapped when deleted");
 		dump_stack();
 		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
-		mapcount = page_mapcount(&folio->page);
-		if (mapping_exiting(mapping) &&
-		    folio_ref_count(folio) >= mapcount + 2) {
-			/*
-			 * All vmas have already been torn down, so it's
-			 * a good bet that actually the folio is unmapped,
-			 * and we'd prefer not to leak it: if we're wrong,
-			 * some other bad page check should catch it later.
-			 */
-			page_mapcount_reset(&folio->page);
-			folio_ref_sub(folio, mapcount);
+		if (mapping_exiting(mapping) && !folio_test_large(folio)) {
+			int mapcount = page_mapcount(&folio->page);
+
+			if (folio_ref_count(folio) >= mapcount + 2) {
+				/*
+				 * All vmas have already been torn down, so it's
+				 * a good bet that actually the page is unmapped
+				 * and we'd rather not leak it: if we're wrong,
+				 * another bad page check should catch it later.
+				 */
+				page_mapcount_reset(&folio->page);
+				folio_ref_sub(folio, mapcount);
+			}
 		}
 	}
 
_
