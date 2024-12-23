Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E6F1AF0CE;
	Mon, 23 Dec 2024 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970050; cv=none; b=opVD3vMGO3db/PQyy3Wd6LV7X8QC5+acLSVosPtluSVnes+1EczGDKdLbR3TpB7qwSMMYR7+X7LHtlLexzOWQocnXIexuC6IWn7Tr4mTmg6HqArZgWmCf94BVf0fjdOTtyOPeADh3/Wza/ux7vFWH0rTBayIjc4HgA+IqKXIUC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970050; c=relaxed/simple;
	bh=75y4DFa4yGV5tEJnwZAq8E9vaKwpfaU/VBiVLl2xBEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqKyYBgnzd8LH64yT+9DjoKAgFNU9QDHDX5h6YH7I/8Zba7VxQICV0RU14rqQYSjLh5OMB7rNVpXB0eXSGeRWrSSFTZj0cEtXQgr8kM8Ysd9DovGJRCpzku++EWZno5v/2eYBrdcCm8rsZ1qrYLkkyxvsJaHdB4SBFLO5Fcq7Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHRoCZhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHRoCZhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11BFC4CED4;
	Mon, 23 Dec 2024 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970050;
	bh=75y4DFa4yGV5tEJnwZAq8E9vaKwpfaU/VBiVLl2xBEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHRoCZhhinCa62U7Rbv4XCdf+giXEnFJged7I4nER1ZM0/okBKwhhphaUohekB6yW
	 +SKVmnt3OMbWKbfHcULA95F3UtN7Y2EEXPQzz/T2Xkq0Vtc00cKw8DDvGHaVW7glxp
	 WOGRZtDHY0jaDXY0K58U+F67um7CchWKGnT8x530=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 112/160] mm/page_alloc: dont call pfn_to_page() on possibly non-existent PFN in split_large_buddy()
Date: Mon, 23 Dec 2024 16:58:43 +0100
Message-ID: <20241223155413.002588034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit faeec8e23c10bd30e8aa759a2eb3018dae00f924 upstream.

In split_large_buddy(), we might call pfn_to_page() on a PFN that might
not exist.  In corner cases, such as when freeing the highest pageblock in
the last memory section, this could result with CONFIG_SPARSEMEM &&
!CONFIG_SPARSEMEM_EXTREME in __pfn_to_section() returning NULL and and
__section_mem_map_addr() dereferencing that NULL pointer.

Let's fix it, and avoid doing a pfn_to_page() call for the first
iteration, where we already have the page.

So far this was found by code inspection, but let's just CC stable as the
fix is easy.

Link: https://lkml.kernel.org/r/20241210093437.174413-1-david@redhat.com
Fixes: fd919a85cd55 ("mm: page_isolation: prepare for hygienic freelists")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lkml.kernel.org/r/e1a898ba-a717-4d20-9144-29df1a6c8813@suse.cz
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1cb4b8c8886d..cae7b93864c2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1238,13 +1238,15 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	if (order > pageblock_order)
 		order = pageblock_order;
 
-	while (pfn != end) {
+	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
+		if (pfn == end)
+			break;
 		page = pfn_to_page(pfn);
-	}
+	} while (1);
 }
 
 static void free_one_page(struct zone *zone, struct page *page,
-- 
2.47.1



