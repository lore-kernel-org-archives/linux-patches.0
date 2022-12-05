Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5810115C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB8AC433C1;
	Mon,  5 Dec 2022 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268394;
	bh=zGxXD27XeAphn3rLRUFYy+4QC/WBxcqqp6dqm1tIm6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f80qXL3hk9uGR66Uy1FWpakJWeMSLwlAYaQFU/mI0pSXykZoup/PLYOplHxFON02s
	 2ODHYC/9VlU6tLdPadno4ahzi30TcCyQVWM6RhIvmCJ5b/O4xvDUATrrwuEobYpU0P
	 ed+Umg/nzsp0C0xVjSCIK26TU0zChj6fx9HSRNYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 085/124] mm: migrate: fix THPs mapcount on isolation
Date: Mon,  5 Dec 2022 20:09:51 +0100
Message-Id: <20221205190810.832681913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavin Shan <gshan@redhat.com>

commit 829ae0f81ce093d674ff2256f66a714753e9ce32 upstream.

The issue is reported when removing memory through virtio_mem device.  The
transparent huge page, experienced copy-on-write fault, is wrongly
regarded as pinned.  The transparent huge page is escaped from being
isolated in isolate_migratepages_block().  The transparent huge page can't
be migrated and the corresponding memory block can't be put into offline
state.

Fix it by replacing page_mapcount() with total_mapcount().  With this, the
transparent huge page can be isolated and migrated, and the memory block
can be put into offline state.  Besides, The page's refcount is increased
a bit earlier to avoid the page is released when the check is executed.

Link: https://lkml.kernel.org/r/20221124095523.31061-1-gshan@redhat.com
Fixes: 1da2f328fa64 ("mm,thp,compaction,cma: allow THP migration for CMA allocations")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Tested-by: Zhenyu Zhang <zhenyzha@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>	[5.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -987,28 +987,28 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
+		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
 		mapping = page_mapping(page);
-		if (!mapping && page_count(page) > page_mapcount(page))
-			goto isolate_fail;
+		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+			goto isolate_fail_put;
 
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
 		 */
 		if (!(cc->gfp_mask & __GFP_FS) && mapping)
-			goto isolate_fail;
-
-		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		if (unlikely(!get_page_unless_zero(page)))
-			goto isolate_fail;
+			goto isolate_fail_put;
 
 		/* Only take pages on LRU: a check now makes later tests safe */
 		if (!PageLRU(page))


