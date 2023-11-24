Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA8A339BE;
	Fri, 24 Nov 2023 19:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZC9Q52I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93647C433C7;
	Fri, 24 Nov 2023 19:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853520;
	bh=tRuOBqxXAax/47gngJuEJzrmVe0tjX2+eAz81Hp8lE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZC9Q52Itw1G7HCs2iXpzoAtKTvVxUwm2I/LNN5em/8L0V2G8+vEGCsBER72VmYCX
	 eZxV3m4OaeXzT6KOvkRcd0LqgnJZPlPvCYrqvYRQM34Yws28tgh7DJ81QoOqIGDdxd
	 lfprzlKHWXW+vMelqA7ZDuetzWJox5HHTQxQpKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <songmuchun@bytedance.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 222/297] mm/cma: use nth_page() in place of direct struct page manipulation
Date: Fri, 24 Nov 2023 17:54:24 +0000
Message-ID: <20231124172007.976479283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 2e7cfe5cd5b6b0b98abf57a3074885979e187c1c upstream.

Patch series "Use nth_page() in place of direct struct page manipulation",
v3.

On SPARSEMEM without VMEMMAP, struct page is not guaranteed to be
contiguous, since each memory section's memmap might be allocated
independently.  hugetlb pages can go beyond a memory section size, thus
direct struct page manipulation on hugetlb pages/subpages might give wrong
struct page.  Kernel provides nth_page() to do the manipulation properly.
Use that whenever code can see hugetlb pages.


This patch (of 5):

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle
it properly.

Without the fix, page_kasan_tag_reset() could reset wrong page tags,
causing a wrong kasan result.  No related bug is reported.  The fix
comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20230913201248.452081-2-zi.yan@sent.com
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -503,7 +503,7 @@ struct page *cma_alloc(struct cma *cma,
 	 */
 	if (page) {
 		for (i = 0; i < count; i++)
-			page_kasan_tag_reset(page + i);
+			page_kasan_tag_reset(nth_page(page, i));
 	}
 
 	if (ret && !no_warn) {


