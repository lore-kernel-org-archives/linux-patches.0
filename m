Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E753539FE1;
	Fri, 24 Nov 2023 18:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lf/mf7XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72026C433C8;
	Fri, 24 Nov 2023 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849900;
	bh=wUrtZtg3O0+NC4ZT1TVhGZv6NUD3UfKTJH1N54GKmmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf/mf7XD3K7yp48eYUTNEO81hCwEq201vGu5OFFOVoi4HJ6KhLSdfFno1N3dh3v3z
	 Q6y3bkgIHRHo9LVSdB+3PW3juQctCZVx4UvjdAc9D++FwdYNcEmB08Zmx0Udkg4K+f
	 PcRTbhnVSdoMJkzMnO5+dkQ3Dxz7WdMQX+IBc8EQ=
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
Subject: [PATCH 6.6 366/530] fs: use nth_page() in place of direct struct page manipulation
Date: Fri, 24 Nov 2023 17:48:52 +0000
Message-ID: <20231124172039.152629381@linuxfoundation.org>
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

commit 8db0ec791f7788cd21e7f91ee5ff42c1c458d0e7 upstream.

When dealing with hugetlb pages, struct page is not guaranteed to be
contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle it
properly.

Without the fix, a wrong subpage might be checked for HWPoison, causing wrong
number of bytes of a page copied to user space. No bug is reported. The fix
comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-5-zi.yan@sent.com
Fixes: 38c1ddbde6c6 ("hugetlbfs: improve read HWPOISON hugepage")
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
 fs/hugetlbfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 316c4cebd3f3..60fce26ff937 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -295,7 +295,7 @@ static size_t adjust_range_hwpoison(struct page *page, size_t offset, size_t byt
 	size_t res = 0;
 
 	/* First subpage to start the loop. */
-	page += offset / PAGE_SIZE;
+	page = nth_page(page, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
 	while (1) {
 		if (is_raw_hwpoison_page_in_hugepage(page))
@@ -309,7 +309,7 @@ static size_t adjust_range_hwpoison(struct page *page, size_t offset, size_t byt
 			break;
 		offset += n;
 		if (offset == PAGE_SIZE) {
-			page++;
+			page = nth_page(page, 1);
 			offset = 0;
 		}
 	}
-- 
2.43.0



