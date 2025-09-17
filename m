Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BA5303A05;
	Wed, 17 Sep 2025 13:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114076; cv=none; b=PUInUOtftEsiu+mMblJEeqYcGh9QekK10Jablqr4hY8/rQYdTfhSgmtloXNQ77ofasj0SGgEkw13yq6hPXiwcj+SgriSBbJkidIPkGaxCQuXrj4URaT4YXwq2+X4H3ZUyBJU3opd626om9ThrgUW4hyPCGY+kPd6GhwoJ36VzHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114076; c=relaxed/simple;
	bh=sfufQgHXtEAGL76+UV2beUiV8QfCYovXkfihxbBOvwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaTY9vIEdmXm8CVbeGKmEIHinKQ1Z3RrXNJsuqQ5TZ0cwxZooKUW2lpxH2Fq7JyeQesCLvG3/F61oIGLcrTP3auvP+ERkUSHEhN8asc9bTVUgnwdI05l7tMH0kZdfofHtXCp5l93rwjANKXqL0o/NtWdqkZkE5nU7lFLE8DFfYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBh1D5/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBh1D5/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD76AC4CEF5;
	Wed, 17 Sep 2025 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114074;
	bh=sfufQgHXtEAGL76+UV2beUiV8QfCYovXkfihxbBOvwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBh1D5/YE611TyzVBUDW5ROF3ZJnBQTcpecdflBA1HqjcUvoTpZfhDDqOMYVWzg+a
	 A/8qKsv4/d25qNGHpu7RkHN1yYPtLY0qmp5fxyy5eVdFCBrp2vZkC5caOVYz/6GrSX
	 cc2ofq2tuuEkq9ouMMEgaleYcvP1lmy5lGeDPLQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Yang Shi <shy828301@gmail.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/78] mm/khugepaged: convert hpage_collapse_scan_pmd() to use folios
Date: Wed, 17 Sep 2025 14:35:00 +0200
Message-ID: <20250917123330.513677117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

[ Upstream commit 5c07ebb372d66423e508ecfb8e00324f8797f072 ]

Replaces 5 calls to compound_head(), and removes 1385 bytes of kernel
text.

Link: https://lkml.kernel.org/r/20231020183331.10770-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 394bfac1c7f7 ("mm/khugepaged: fix the address passed to notifier on testing young")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1140,6 +1140,7 @@ static int hpage_collapse_scan_pmd(struc
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
+	struct folio *folio = NULL;
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
@@ -1221,29 +1222,28 @@ static int hpage_collapse_scan_pmd(struc
 			}
 		}
 
-		page = compound_head(page);
-
+		folio = page_folio(page);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
 		 * Khugepaged will allocate hugepage from the node has the max
 		 * hit record.
 		 */
-		node = page_to_nid(page);
+		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
 		cc->node_load[node]++;
-		if (!PageLRU(page)) {
+		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
 			goto out_unmap;
 		}
-		if (PageLocked(page)) {
+		if (folio_test_locked(folio)) {
 			result = SCAN_PAGE_LOCK;
 			goto out_unmap;
 		}
-		if (!PageAnon(page)) {
+		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
 		}
@@ -1265,7 +1265,7 @@ static int hpage_collapse_scan_pmd(struc
 		 * has excessive GUP pins (i.e. 512).  Anyway the same check
 		 * will be done again later the risk seems low.
 		 */
-		if (!is_refcount_suitable(page)) {
+		if (!is_refcount_suitable(&folio->page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
@@ -1275,8 +1275,8 @@ static int hpage_collapse_scan_pmd(struc
 		 * enough young pte to justify collapsing the page
 		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || page_is_young(page) ||
-		     PageReferenced(page) || mmu_notifier_test_young(vma->vm_mm,
+		    (pte_young(pteval) || folio_test_young(folio) ||
+		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
 								     address)))
 			referenced++;
 	}
@@ -1298,7 +1298,7 @@ out_unmap:
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, &folio->page, writable, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }


