Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE7B1DE4E6;
	Wed,  6 Nov 2024 13:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899339; cv=none; b=nOx/m27eJF/46PfqSkiMhbbYuRE1cS1OiSm8Yy3DFZO8OdppX6kx82jt/h4X8wIzEtI7AsR4OkhMeRzTLE0Acz6R9tuIBo/atzRALkrS49kHORfmefynd2Byk18H03bka/Udgnyy1s/VSuWZs9nUqfHrMreQrSqRCqdPnjlOHEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899339; c=relaxed/simple;
	bh=xpB99pPfHyzswOIeoeSOQhIxl4Vco047Xjnnp+qfBWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuBoDV6NKFbWB6xLzje3DgwP99eKFUJSGNVAS/nvOZ3L8PSYlM+W4QHmxZDUY1PXPleA/hJgT1aMVLlU2mEUZXuTrJ6hN7xoymxttrD7llqmLjTIyEpYCQWGwWTgC7KIJDEdIHmNhjQfpPgZDEm/jQDgsX/5gdoswfCNDKr0Pag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZgXdcC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZgXdcC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960CBC4CECD;
	Wed,  6 Nov 2024 13:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899339;
	bh=xpB99pPfHyzswOIeoeSOQhIxl4Vco047Xjnnp+qfBWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZgXdcC0uOpOAc38PQ3niVd/XoIi6vVxA4lNZsDDBESm8epHdhQDetsTi96hBs3Sq
	 h5wDSBB6QVKhb2zABKlJQ52Et0YsozkXQv5Tfvt62oVBuKGHH/qPJHUO8aBIDg3C2M
	 6rXK6eTF778GSaUjWGoUSCT3lwYlhdlPocaBq8zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 62/73] mm/page_alloc: explicitly define what alloc flags deplete min reserves
Date: Wed,  6 Nov 2024 13:06:06 +0100
Message-ID: <20241106120301.802616957@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit ab3508854353793cd35e348fde89a5c09b2fd8b5 ]

As there are more ALLOC_ flags that affect reserves, define what flags
affect reserves and clarify the effect of each flag.

Link: https://lkml.kernel.org/r/20230113111217.14134-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/internal.h   |  3 +++
 mm/page_alloc.c | 34 ++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 136f435e0f1ab..717e75313693c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -606,6 +606,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
+/* Flags that allow allocations below the min watermark. */
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 43122de999c4c..7778c2b11d8cb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3838,15 +3838,14 @@ ALLOW_ERROR_INJECTION(should_fail_alloc_page, TRUE);
 static inline long __zone_watermark_unusable_free(struct zone *z,
 				unsigned int order, unsigned int alloc_flags)
 {
-	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 	long unusable_free = (1 << order) - 1;
 
 	/*
-	 * If the caller does not have rights to ALLOC_HARDER then subtract
-	 * the high-atomic reserves. This will over-estimate the size of the
-	 * atomic reserve but it avoids a search.
+	 * If the caller does not have rights to reserves below the min
+	 * watermark then subtract the high-atomic reserves. This will
+	 * over-estimate the size of the atomic reserve but it avoids a search.
 	 */
-	if (likely(!alloc_harder))
+	if (likely(!(alloc_flags & ALLOC_RESERVES)))
 		unusable_free += z->nr_reserved_highatomic;
 
 #ifdef CONFIG_CMA
@@ -3870,25 +3869,36 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 {
 	long min = mark;
 	int o;
-	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
-	if (alloc_flags & ALLOC_MIN_RESERVE)
-		min -= min / 2;
+	if (unlikely(alloc_flags & ALLOC_RESERVES)) {
+		/*
+		 * __GFP_HIGH allows access to 50% of the min reserve as well
+		 * as OOM.
+		 */
+		if (alloc_flags & ALLOC_MIN_RESERVE)
+			min -= min / 2;
 
-	if (unlikely(alloc_harder)) {
 		/*
-		 * OOM victims can try even harder than normal ALLOC_HARDER
+		 * Non-blocking allocations can access some of the reserve
+		 * with more access if also __GFP_HIGH. The reasoning is that
+		 * a non-blocking caller may incur a more severe penalty
+		 * if it cannot get memory quickly, particularly if it's
+		 * also __GFP_HIGH.
+		 */
+		if (alloc_flags & ALLOC_HARDER)
+			min -= min / 4;
+
+		/*
+		 * OOM victims can try even harder than the normal reserve
 		 * users on the grounds that it's definitely going to be in
 		 * the exit path shortly and free memory. Any allocation it
 		 * makes during the free path will be small and short-lived.
 		 */
 		if (alloc_flags & ALLOC_OOM)
 			min -= min / 2;
-		else
-			min -= min / 4;
 	}
 
 	/*
-- 
2.43.0



