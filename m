Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003822C697;
	Mon, 28 Oct 2024 06:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097665; cv=none; b=PTVkYoI0kbRxIkn4iDF2iLqtJHdMa67cdgD7cQ0k5rtYpJbzrLIdOpDpjF+T24cLTsVJ/gyWLRDZyLx5cFGl1nMuf4jZsQCYbqdvPKJ8hoZt4D6KTeOmLHi+Q4gju7pgVMfmmXJZcog9rp2HNIl4cPlkxqk5VervUiB0sYBqBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097665; c=relaxed/simple;
	bh=5A4FjDgB+Uq3AgiKKBv6JvsvZzsCmFCFmVby+u63Q8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+UwdNTeOfpJe/rQao7Rzz9Eh4MJZaWecPRbnbZXt6BI4PUA8rqO3hlrlxf1g6PqVO9uKS9Ppbe+IR3fN8rTJjsFnL5YGl6Z+lvBPj+Ku5LAdtZW/3JW6rIba6xI12o30yPgPgSix4RVd0rq1dTFhf7Dn/Sj6xfYTDJkk070oaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jy7my4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jy7my4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2F9C4CEC3;
	Mon, 28 Oct 2024 06:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097664;
	bh=5A4FjDgB+Uq3AgiKKBv6JvsvZzsCmFCFmVby+u63Q8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jy7my4QxfEsyal7TmuVfkTMiHeOzD4GH7mjxrqwJYMIe8envRIIDXqbL6lheAQas
	 30eM+XVYS8clmzNqrK7cU6qTj83GAbP8ZvE6wRq98wRJicOUBvHXojY3Asu+V9HUHG
	 kJ3yvD4cVqt0XhNp92vdrGjHLU76MVfZb4nUqWgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/208] mm: convert collapse_huge_page() to use a folio
Date: Mon, 28 Oct 2024 07:24:32 +0100
Message-ID: <20241028062308.919434399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 5432726848bb27a01badcbc93b596f39ee6c5ffb ]

Replace three calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20231211162214.2146080-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37f0b47c5143 ("mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97cc4ef061832..24d05e0a672dc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1088,6 +1088,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
+	struct folio *folio;
 	struct page *hpage;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
@@ -1207,13 +1208,13 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
+	folio = page_folio(hpage);
 	/*
-	 * spin_lock() below is not the equivalent of smp_wmb(), but
-	 * the smp_wmb() inside __SetPageUptodate() can be reused to
-	 * avoid the copy_huge_page writes to become visible after
-	 * the set_pmd_at() write.
+	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
+	 * copy_huge_page writes become visible before the set_pmd_at()
+	 * write.
 	 */
-	__SetPageUptodate(hpage);
+	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
 	_pmd = mk_huge_pmd(hpage, vma->vm_page_prot);
@@ -1221,8 +1222,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	page_add_new_anon_rmap(hpage, vma, address);
-	lru_cache_add_inactive_or_unevictable(hpage, vma);
+	folio_add_new_anon_rmap(folio, vma, address);
+	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
-- 
2.43.0



