Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6E39FF7;
	Fri, 24 Nov 2023 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFF0QLnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F2FC433C9;
	Fri, 24 Nov 2023 18:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849905;
	bh=z+JBOQYqlrutSEEci0F7w74eMoVb8UN2mqJuykmIm5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFF0QLnPAtidjqbUcGvbl6d524vlAU+kxX0UJvzrPRsjpNgKwSpxnxmMVhloTgh5y
	 KKCN6+2iPbf4ufSnDBQ7MwWuOz688ARMxt3kWQobj0+tzdU7hjSgHpH4MAZcG+sHBi
	 BAcA2Xc04FeSKZfM+kis4gbbaZJMyUCBoE2pizZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 367/530] mips: use nth_page() in place of direct struct page manipulation
Date: Fri, 24 Nov 2023 17:48:53 +0000
Message-ID: <20231124172039.178554120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit aa5fe31b6b59210cb4ea28a59e68781f48eeca74 upstream.

__flush_dcache_pages() is called during hugetlb migration via
migrate_pages() -> migrate_hugetlbs() -> unmap_and_move_huge_page() ->
move_to_new_folio() -> flush_dcache_folio().  And with hugetlb and without
sparsemem vmemmap, struct page is not guaranteed to be contiguous beyond a
section.  Use nth_page() instead.

Without the fix, a wrong address might be used for data cache page flush.
No bug is reported. The fix comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-6-zi.yan@sent.com
Fixes: 15fa3e8e3269 ("mips: implement the new page table range API")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -117,7 +117,7 @@ void __flush_dcache_pages(struct page *p
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(page + i);
+		addr = (unsigned long)kmap_local_page(nth_page(page, i));
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}


