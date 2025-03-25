Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D31125B66A;
	Tue, 25 Mar 2025 12:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906002; cv=none; b=hOgdlPP5iaRC8O80oCI9/XqPUG6W/pvAhXV6l2b8MXJV0tGU4/ZvXdfjAcNbnyNJPSYGAWUjml43mfXxhJMEUuoTFvNPz4UP8YCOO1pYf01dtTGqqZfJsn/htGDrtEJHU6rNfUmEp8WXHKod+mwUomfRvAPKs8WSQBoSpWfjN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906002; c=relaxed/simple;
	bh=+LPhEJvP5FRLC+fd8yiyURRzfZSWZDwB5nRGM4Ho04w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBF+KDRy3Kled8Ikxrt9m/YHVdIK0VejqqlAYTIsB9rG7L3GCvA4v0IIKc0KMKecrTIiwlj2yWTHLdvklXausQUR95jPfPeCisEjb3NCsfyjCLBdKxpI7aC9Z0uY3DYDqYnj5I6w1YCkL9yKM+FFJKcf0wpAS3h7waRjayZEIA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twQyJGyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twQyJGyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ABCC4CEE4;
	Tue, 25 Mar 2025 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906002;
	bh=+LPhEJvP5FRLC+fd8yiyURRzfZSWZDwB5nRGM4Ho04w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twQyJGygK6OldL4/HywZ5CJqkMFKYTMTXc9M5M8sMmBV07NJ5BsrgHgc90yD6s5ld
	 8cE4AbVGDNd8429wyUWN4Au2JwXIv471ZyucK20otW7nRjmFtVnOndKS3ul/i9xY+/
	 /Y1yY9/FkBns5sPvFhIcmNzzh5f4Bul5XS8pqhig=
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
Subject: [PATCH 6.13 081/119] mm/page_alloc: fix memory accept before watermarks gets initialized
Date: Tue, 25 Mar 2025 08:22:19 -0400
Message-ID: <20250325122151.127017834@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6961,7 +6961,7 @@ static inline bool has_unaccepted_memory
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
-	long to_accept;
+	long to_accept, wmark;
 	bool ret = false;
 
 	if (!has_unaccepted_memory())
@@ -6970,8 +6970,18 @@ static bool cond_accept_memory(struct zo
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


