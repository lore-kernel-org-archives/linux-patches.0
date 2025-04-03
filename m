Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA36524C077;
	Thu,  3 Apr 2025 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693977; cv=none; b=buDm0k4q8JKQvxb5/1J7wR8nlJJK3XjlJDF0BSt3q1r7HcRCUmVTz5b1T/MvfR+GVKUo+F0VwJNn4egJXyC4TlHGOEFXqE0kMEv3PvT78IXqfgahsueIXyDtLJqoG2Xd7WYs27k2t260Lw6X/Lr662NAc8OHDfXKX75/W5MQsCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693977; c=relaxed/simple;
	bh=dCa44yXbuw5ZvJdtCV6fOe6jkupLdATTVtUwS0anmQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPl7tlJ9SlF3Jq6AqvISlI9zqfxJ4VeGsT7C8bIr4qHRsZVn4x4I5nKVO2mjif37C9ANT62pSCDQz/MQl8W/mRB3gUb8OYvdA6QBtsb+7I+DjsMToSzqwYYKRG9boKbOcM1swTFAuhblA+mNhlFa++KZkJnVQvXBjUR3LaiYCFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBwOrM1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBwOrM1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E97EC4CEE3;
	Thu,  3 Apr 2025 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693977;
	bh=dCa44yXbuw5ZvJdtCV6fOe6jkupLdATTVtUwS0anmQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBwOrM1FH8ld5uQgB5/szvWNAd9VGikPcDhl7Vy0qyem/spuw6MgMUWIa0bzeLcAu
	 i5QPLO0os5xKuAaPn5RPCTwLUSy72u8uVpEgqYPa6olk/SVj0waGbZzXxOFIEsa6ff
	 MO0TfiNKN9n0dH0zB0wdavepSBUIDKvWq3EZQLfQ=
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
Subject: [PATCH 6.6 11/26] mm/page_alloc: fix memory accept before watermarks gets initialized
Date: Thu,  3 Apr 2025 16:20:32 +0100
Message-ID: <20250403151622.739326418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6653,7 +6653,7 @@ static bool try_to_accept_memory_one(str
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
-	long to_accept;
+	long to_accept, wmark;
 	bool ret = false;
 
 	if (!has_unaccepted_memory())
@@ -6662,8 +6662,18 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	wmark = high_wmark_pages(zone);
+
+	/*
+	 * Watermarks have not been initialized yet.
+	 *
+	 * Accepting one MAX_ORDER page to ensure progress.
+	 */
+	if (!wmark)
+		return try_to_accept_memory_one(zone);
+
 	/* How much to accept to get to high watermark? */
-	to_accept = high_wmark_pages(zone) -
+	to_accept = wmark -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));


