Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AAA248F45;
	Tue, 20 May 2025 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750877; cv=none; b=M5mqc7Mwaf3TJeFX2oWCyeD+CzneJYwzH8YnA1edW6io9WygynHl06s8pnnJD8cwsjaX56jMpYfHRr5Eg1Fv5Atb/c0KgMj157GyIJ9JJKpgqMD4s1ruOfUvhCp1mIwRfQB7+iZtv5UTRZI8tzNWFREC/yUpmGtCMG0De1V2AZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750877; c=relaxed/simple;
	bh=Hbkf0RjEeQrryPV2asy9F314HG6n1eP5q9LI7pMETgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s41hzEFiXxjKuRZWpYpEggutrDk6ewumC+xSLstIhgoISVo+yWRoGY1Ww08guvquL5ol1rxBpi9uw/iS7PgxLJMPufDAFJDqEqIFdkKbjp39yBF6UI+69gBhd4ciiLMttVC+2MXdRgI5Zf995Mmwza+ToKuc9/5jPj8GAvfjVz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea1mKXVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea1mKXVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196DFC4CEE9;
	Tue, 20 May 2025 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750877;
	bh=Hbkf0RjEeQrryPV2asy9F314HG6n1eP5q9LI7pMETgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea1mKXVtvjDHEPAJwktSlqbwqQwEcVlyShw0oodwhw+2ZFFScci7KncSP2liO9ZgT
	 ElyI/DcZA5rBnJ0urTy7tuoGOGh52YzxF0WLD2NSlianSCMjZRz4KMWHHmAIWZ+vxQ
	 fd/IuLlPa4CHlpdXKQl+dfYZZwxpsA6dBkM484Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 143/145] mm/page_alloc: fix race condition in unaccepted memory handling
Date: Tue, 20 May 2025 15:51:53 +0200
Message-ID: <20250520125816.144960734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit fefc075182275057ce607effaa3daa9e6e3bdc73 upstream.

The page allocator tracks the number of zones that have unaccepted memory
using static_branch_enc/dec() and uses that static branch in hot paths to
determine if it needs to deal with unaccepted memory.

Borislav and Thomas pointed out that the tracking is racy: operations on
static_branch are not serialized against adding/removing unaccepted pages
to/from the zone.

Sanity checks inside static_branch machinery detects it:

WARNING: CPU: 0 PID: 10 at kernel/jump_label.c:276 __static_key_slow_dec_cpuslocked+0x8e/0xa0

The comment around the WARN() explains the problem:

	/*
	 * Warn about the '-1' case though; since that means a
	 * decrement is concurrent with a first (0->1) increment. IOW
	 * people are trying to disable something that wasn't yet fully
	 * enabled. This suggests an ordering problem on the user side.
	 */

The effect of this static_branch optimization is only visible on
microbenchmark.

Instead of adding more complexity around it, remove it altogether.

Link: https://lkml.kernel.org/r/20250506133207.1009676-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Link: https://lore.kernel.org/all/20250506092445.GBaBnVXXyvnazly6iF@fat_crate.local
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   23 -----------------------
 1 file changed, 23 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6951,9 +6951,6 @@ bool has_managed_dma(void)
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 
-/* Counts number of zones with unaccepted pages. */
-static DEFINE_STATIC_KEY_FALSE(zones_with_unaccepted_pages);
-
 static bool lazy_accept = true;
 
 static int __init accept_memory_parse(char *p)
@@ -6980,11 +6977,7 @@ static bool page_contains_unaccepted(str
 static void __accept_page(struct zone *zone, unsigned long *flags,
 			  struct page *page)
 {
-	bool last;
-
 	list_del(&page->lru);
-	last = list_empty(&zone->unaccepted_pages);
-
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	__ClearPageUnaccepted(page);
@@ -6993,9 +6986,6 @@ static void __accept_page(struct zone *z
 	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
 	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
-
-	if (last)
-		static_branch_dec(&zones_with_unaccepted_pages);
 }
 
 void accept_page(struct page *page)
@@ -7032,19 +7022,11 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
-static inline bool has_unaccepted_memory(void)
-{
-	return static_branch_unlikely(&zones_with_unaccepted_pages);
-}
-
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept, wmark;
 	bool ret = false;
 
-	if (!has_unaccepted_memory())
-		return false;
-
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
@@ -7078,22 +7060,17 @@ static bool __free_unaccepted(struct pag
 {
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
-	bool first = false;
 
 	if (!lazy_accept)
 		return false;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	first = list_empty(&zone->unaccepted_pages);
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
 	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
 	__SetPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	if (first)
-		static_branch_inc(&zones_with_unaccepted_pages);
-
 	return true;
 }
 


