Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F85332A31;
	Wed, 17 Sep 2025 12:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113798; cv=none; b=bhToAr/pXRJ1iZ5sNF2CG9Aq4ZIGqtlJWrEu0NlyAT2g4w2wwsD3uU+FFC0J17RUEgRAdM8fm3T4+iZpWKGpAxvhpw/LzaW02t1pNZmnQP6mdNIU3y9b1vjQVzOZSeJeqsu2FW2fUNAIBQDQEMp5yzSgR0SUYTjGVY/XJTv0IPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113798; c=relaxed/simple;
	bh=QrnLAZ5Jl8yvyn22cTxhrPtBgDUK6lS6EBcifvaox3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNvkbL9MbYGjP8R0OBU9P78fwyHyIGvu9rgaTh45++Y0Flx7fnwM9MtRRWtoWPWlQIFNzNs/JNTZEEeEU82wlYzVCMlPNnGXwTHFF8EnaxFXbZHCXidA4GVBdFaIf7vf/r9dwj/fLPWJolYJagK85YhZwvUu975oEqajL+wqYcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN0qHYoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN0qHYoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52944C4CEF0;
	Wed, 17 Sep 2025 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113798;
	bh=QrnLAZ5Jl8yvyn22cTxhrPtBgDUK6lS6EBcifvaox3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN0qHYoCUvb2iUvaakmxy+qvCIm34T3WH/fF1AWhm5dwdN1YPBCTayr58qQsI8tum
	 Ry6Uh3N2eUbS67M3khpwz6KSH9hPKMNmlzR22r8xzkU0QVDlO057bNCcZ7hAblVWDu
	 tirzXDSDHcVRD8xW//znpIV/2f9c6Vp/1I+H7OVA=
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
Subject: [PATCH 6.6 055/101] mm/khugepaged: convert hpage_collapse_scan_pmd() to use folios
Date: Wed, 17 Sep 2025 14:34:38 +0200
Message-ID: <20250917123338.172052752@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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
@@ -1240,6 +1240,7 @@ static int hpage_collapse_scan_pmd(struc
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
+	struct folio *folio = NULL;
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
@@ -1326,29 +1327,28 @@ static int hpage_collapse_scan_pmd(struc
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
@@ -1363,7 +1363,7 @@ static int hpage_collapse_scan_pmd(struc
 		 * has excessive GUP pins (i.e. 512).  Anyway the same check
 		 * will be done again later the risk seems low.
 		 */
-		if (!is_refcount_suitable(page)) {
+		if (!is_refcount_suitable(&folio->page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
@@ -1373,8 +1373,8 @@ static int hpage_collapse_scan_pmd(struc
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
@@ -1396,7 +1396,7 @@ out_unmap:
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, &folio->page, writable, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }


