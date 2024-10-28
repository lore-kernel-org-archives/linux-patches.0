Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06D2C697;
	Mon, 28 Oct 2024 06:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097667; cv=none; b=gZNGJ9vkHEd0YpMm6ccRzhmaSouhxohmwE9cUUkCkkR+K/q/T2zBW5kQBnUaqdUnVgJh1Z8kS9rGuaY+wMlEXREiiISOr6mavmLaO5y4Y0OEgac/LJO9qwx0xG7A+vmGj7lGQ92ODx8w7UbzCGDratJVxGY7J0j5Ks8WPs1/n7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097667; c=relaxed/simple;
	bh=6/48O118OMVNVVYXmEwj8p1EtnspjVaJGaZ3rM4fPz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeoJmi5KDBdeRIRo11RZ7C4fYAEZRom2R8F8LKiamQYPJ4a5EI1wnINvtCKfFVc9gEFTOAIn/IN5uz0o557XxMgfyC3KKEybhQnMPbUs/ubv9zsIU2rQ7GC1ok2nZwc1j+haneJwau7G4Mlpa4KbzXEAM/PsVy4YsyvTmiMlYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvfeMxgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvfeMxgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAEFC4CEC3;
	Mon, 28 Oct 2024 06:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097667;
	bh=6/48O118OMVNVVYXmEwj8p1EtnspjVaJGaZ3rM4fPz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvfeMxgukbqRzr1EBfJu3ewFAhPtICuHWyYtfHnr2VaXA/OVDXCLzm9OlJSTwAGZD
	 hitKjJsVRXvg5JVXCh9gRJCP2XSUB9uvkYKY/9AmREEsCBgoghKTKZwjnSkacNcyrl
	 aBvP9sMGQu+5Tmpq7PUC1XFIU/4HSCObG94NXt9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/208] mm/khugepaged: use a folio more in collapse_file()
Date: Mon, 28 Oct 2024 07:24:33 +0100
Message-ID: <20241028062308.946053707@linuxfoundation.org>
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

[ Upstream commit b54d60b18e850561e8bdb4264ae740676c3b7658 ]

This function is not yet fully converted to the folio API, but this
removes a few uses of old APIs.

Link: https://lkml.kernel.org/r/20231228085748.1083901-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37f0b47c5143 ("mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 24d05e0a672dc..cb6a243688045 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2124,23 +2124,23 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
-	nr = thp_nr_pages(hpage);
+	folio = page_folio(hpage);
+	nr = folio_nr_pages(folio);
 	if (is_shmem)
-		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
 	else
-		__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
 
 	if (nr_none) {
-		__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_none);
 	}
 
 	/*
 	 * Mark hpage as uptodate before inserting it into the page cache so
 	 * that it isn't mistaken for an fallocated but unwritten page.
 	 */
-	folio = page_folio(hpage);
 	folio_mark_uptodate(folio);
 	folio_ref_add(folio, HPAGE_PMD_NR - 1);
 
@@ -2150,7 +2150,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	/* Join all the small entries into a single multi-index entry. */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
+	xas_store(&xas, folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
 
@@ -2161,7 +2161,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
-	unlock_page(hpage);
+	folio_unlock(folio);
 
 	/*
 	 * The collapse has succeeded, so free the old pages.
-- 
2.43.0



