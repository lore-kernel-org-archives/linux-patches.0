Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F2726F44C;
	Tue, 25 Mar 2025 12:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906362; cv=none; b=MEu7oEwL84jEAJ2tm2YEN9cxZLVs4zKkCDWSvwPEHeOioOhhSGZaohOaCEFV6GhmcytTNNgg+fV3kHiZ23i+fXpIZc73wMSk61d3PHbJ/h3H4BZH//SRRCZ6upKEr0zBSa5IlmEt769E3jkSx1VasuHIFqEDcO0t7/h3Gv2P0HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906362; c=relaxed/simple;
	bh=asKXlGWNoe5PV/3NE9tfjL3u+pg3bodzz2kO3A0IMnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR+yX6Zl/CC2384FXN/IaIXcOnsfHh/jM/UnCUkhWR6HXS/xr5MBr+M8FuASsV/LtQT/NWgi8lrUXV+hiikeyf3WOrRbNI0cM00FVFeODRuqZ28hosgNdNdk2sy1kgmZM0AtB6OwSu6dfhkIvS6zvhcblFbFEuLQHMY7VMDpBtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSiKhtE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSiKhtE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23F1C4CEE4;
	Tue, 25 Mar 2025 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906362;
	bh=asKXlGWNoe5PV/3NE9tfjL3u+pg3bodzz2kO3A0IMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSiKhtE1JiVnOJKQE/IoCpZEv05OT9I/7bJ1yMOYgv7e4HmY4MRsmKAB00uHkbuWE
	 bKej8Tn9anQfjxjC8DwL7NxCGjYxxRfKIygsJEzzPcUmI+iNfxjn3GaMsVPs1m5Phx
	 3jrOWwNOBlHcEThJ2Uh2+ukVA4++e9sKn4cSqs5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	David Hildenbrand <david@redhat.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Thomas Lendacky <thomas.lendacky@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 077/116] mm/page_alloc: fix memory accept before watermarks gets initialized
Date: Tue, 25 Mar 2025 08:22:44 -0400
Message-ID: <20250325122151.177696651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 800f1059c99e2b39899bdc67a7593a7bea6375d8 upstream.

Watermarks are initialized during the postcore initcall.  Until then, all
watermarks are set to zero.  This causes cond_accept_memory() to
incorrectly skip memory acceptance because a watermark of 0 is always met.

This can lead to a premature OOM on boot.

To ensure progress, accept one MAX_ORDER page if the watermark is zero.

Link: https://lkml.kernel.org/r/20250310082855.2587122-1-kirill.shutemov@linux.intel.com
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7094,7 +7094,7 @@ static inline bool has_unaccepted_memory
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
-	long to_accept;
+	long to_accept, wmark;
 	bool ret = false;
 
 	if (!has_unaccepted_memory())
@@ -7103,8 +7103,18 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	wmark = promo_wmark_pages(zone);
+
+	/*
+	 * Watermarks have not been initialized yet.
+	 *
+	 * Accepting one MAX_ORDER page to ensure progress.
+	 */
+	if (!wmark)
+		return try_to_accept_memory_one(zone);
+
 	/* How much to accept to get to promo watermark? */
-	to_accept = promo_wmark_pages(zone) -
+	to_accept = wmark -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));


