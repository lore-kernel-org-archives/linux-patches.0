Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9F033E9;
	Fri, 24 Nov 2023 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nH+niHJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02496C433C8;
	Fri, 24 Nov 2023 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851311;
	bh=UnTVa3ZU1f81BifdHpMaIe0C317AonhaVP+cZWcZeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nH+niHJJSD5XLYGlKJOkg5h/mmnnDhtJtPQzfzDmFp/Yooy4mhKv5aYZRsbRvhGlJ
	 euFFU9VNADFZ3/0VUPH6qEjX4ef7Txslq12W9DBS4tO2XQFzsYyhYfm04JF7X8cAcS
	 M1w8nXam8cmjVAuQypaizUiJL5czrFXCC8aA9LhA=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 380/491] mm/hugetlb: use nth_page() in place of direct struct page manipulation
Date: Fri, 24 Nov 2023 17:50:16 +0000
Message-ID: <20231124172036.012256609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

[ Upstream commit 426056efe835cf4864ccf4c328fe3af9146fc539 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d231f23088a77..9951fb7412cc7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6546,7 +6546,7 @@ struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 			}
 		}
 
-		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = nth_page(page, ((address & ~huge_page_mask(h)) >> PAGE_SHIFT));
 
 		/*
 		 * Note that page may be a sub-page, and with vmemmap
-- 
2.42.0



