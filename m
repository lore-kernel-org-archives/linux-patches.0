Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48939FD9;
	Fri, 24 Nov 2023 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhX3GB8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D532C433C8;
	Fri, 24 Nov 2023 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850001;
	bh=jt3NEgDqPFfrc5XDeOxrhGpK+k/NldW6V0VUUlV/jtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhX3GB8+ulMjX947u/EQ9w5sRrvd+XC2f7SvQ8Is5nZGek63wJPTOu68OxUItSWnW
	 tJWm54eyLp46SdmN7qBXCpMMTZ3sKRiiOHKk6SVp9EuH5f1gRMzNcSUr+7PwIe4wjQ
	 RCJ6TnJXrvPtM7GGuGyIg5LoiHD0dEvBA6BBwOnI=
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
Subject: [PATCH 6.6 381/530] mm/hugetlb: use nth_page() in place of direct struct page manipulation
Date: Fri, 24 Nov 2023 17:49:07 +0000
Message-ID: <20231124172039.613322737@linuxfoundation.org>
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

commit 426056efe835cf4864ccf4c328fe3af9146fc539 upstream.

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle
it properly.

A wrong or non-existing page might be tried to be grabbed, either
leading to a non freeable page or kernel memory access errors.  No bug
is reported.  It comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-3-zi.yan@sent.com
Fixes: 57a196a58421 ("hugetlb: simplify hugetlb handling in follow_page_mask")
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
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6520,7 +6520,7 @@ struct page *hugetlb_follow_page_mask(st
 			}
 		}
 
-		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = nth_page(page, ((address & ~huge_page_mask(h)) >> PAGE_SHIFT));
 
 		/*
 		 * Note that page may be a sub-page, and with vmemmap


