Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51DC52F9B;
	Mon,  8 Jan 2024 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykHSEKH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED7CC433CD;
	Mon,  8 Jan 2024 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728508;
	bh=4R3rF4W2KGEq5GmoYvMOMiYRPAIFZ+ibqLSRtgqNdHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykHSEKH2pY11j05arvUgmTWC31S4cvCxqi5JwnKbVo3byv6nyOfn8/skymhCwsrBh
	 GVZ+Pk7BfLTYmGTC8GPbqBIY4gzq3VOCfU/k4yf7x1GiMbZEu924aJ+rq1Ou+zZgKK
	 yh/uJAqMuGq3hwdA85VZfzG2VcTbxmT4/H8pviI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/150] khugepage: replace try_to_release_page() with filemap_release_folio()
Date: Mon,  8 Jan 2024 16:35:50 +0100
Message-ID: <20240108153515.762851846@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit 64ab3195ea077eaeedc8b382939c3dc5ca56f369 ]

Replace some calls with their folio equivalents.  This change removes 4
calls to compound_head() and is in preparation for the removal of the
try_to_release_page() wrapper.

Link: https://lkml.kernel.org/r/20221118073055.55694-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 1898efcdbed3 ("block: update the stable_writes flag in bdev_add")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ef72d3df4b65b..6fc7db587c453 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1818,6 +1818,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
 		struct page *page = xas_next(&xas);
+		struct folio *folio;
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
@@ -1844,8 +1845,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 
 			if (xa_is_value(page) || !PageUptodate(page)) {
-				struct folio *folio;
-
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index,
@@ -1933,13 +1932,15 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
-		if (page_mapping(page) != mapping) {
+		folio = page_folio(page);
+
+		if (folio_mapping(folio) != mapping) {
 			result = SCAN_TRUNCATED;
 			goto out_unlock;
 		}
 
-		if (!is_shmem && (PageDirty(page) ||
-				  PageWriteback(page))) {
+		if (!is_shmem && (folio_test_dirty(folio) ||
+				  folio_test_writeback(folio))) {
 			/*
 			 * khugepaged only works on read-only fd, so this
 			 * page is dirty because it hasn't been flushed
@@ -1949,20 +1950,20 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
-		if (isolate_lru_page(page)) {
+		if (folio_isolate_lru(folio)) {
 			result = SCAN_DEL_PAGE_LRU;
 			goto out_unlock;
 		}
 
-		if (page_has_private(page) &&
-		    !try_to_release_page(page, GFP_KERNEL)) {
+		if (folio_has_private(folio) &&
+		    !filemap_release_folio(folio, GFP_KERNEL)) {
 			result = SCAN_PAGE_HAS_PRIVATE;
-			putback_lru_page(page);
+			folio_putback_lru(folio);
 			goto out_unlock;
 		}
 
-		if (page_mapped(page))
-			try_to_unmap(page_folio(page),
+		if (folio_mapped(folio))
+			try_to_unmap(folio,
 					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
-- 
2.43.0



