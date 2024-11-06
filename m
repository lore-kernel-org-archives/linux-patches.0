Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE4E1F8908;
	Wed,  6 Nov 2024 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897179; cv=none; b=YuCoWoGO7q0BeVDnNQlKllZZgjCTnQ6lW+vdoquhfvTHHxYJg+vcnxZG4+z3Y7zqsf4ucze+fxE2w1Ll/2dyAfSc/uLhnnHcWaBdYup8TQCym9cJAWEzfmxy7huiZJSZhEmcFVPLwpe2d9OkfxIu+cOZP2yrymYLL5lb+/EB6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897179; c=relaxed/simple;
	bh=EwzYyNcHe8Fhg4qK9QM/kRQl51E80JHyqcR/2REj3Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMeb7IgN4tuxi0GfzZpFE/qQf/qwOsi7RH7xys+1QmT+N05iSCpnr23Sr4gVVdGwIYkQp755GG+lpygySNgmeXCI9gpwidobuwQoJyR/CTNZRC5h27Ots5Wj2cEvjnCxEn9RBG2BmMss0WLfsUp9iAhnuIRflY5FaR2tqxUDbdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq8SagAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq8SagAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC0C4CED3;
	Wed,  6 Nov 2024 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897179;
	bh=EwzYyNcHe8Fhg4qK9QM/kRQl51E80JHyqcR/2REj3Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq8SagAq1WpM+8FkCHRNOY0hmhGe+D5NfW0kEjoCr6H9WTD8gpcKFZOZs1GbZ9CGl
	 FwGnUKnLbulRuHgzRD3o5buw6FStyl4D2dNUr1qdc0+5SOQ4GgbPho1vi3gDDpvCQT
	 SGyAA6toByiwCbht41ZjaLY8TStVjJ6aBwgNBVLM=
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
Subject: [PATCH 6.1 093/126] mm/page_alloc: explicitly define what alloc flags deplete min reserves
Date: Wed,  6 Nov 2024 13:04:54 +0100
Message-ID: <20241106120308.583560254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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
index f0f6198462cc1..cd095ce2f199e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -768,6 +768,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
+/* Flags that allow allocations below the min watermark. */
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8e1f4d779b26c..6ab53e47ccea1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3956,15 +3956,14 @@ ALLOW_ERROR_INJECTION(should_fail_alloc_page, TRUE);
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
@@ -3988,25 +3987,36 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
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



