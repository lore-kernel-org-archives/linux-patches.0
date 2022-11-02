Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B34633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B847C433D6;
	Wed,  2 Nov 2022 03:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360192;
	bh=4MDeUX9zXGuKwdru4RSYc2GsBf2ukdN4kUYOT0uptiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9sAyrQWRhymqfCl/DKkSKWmsquXgsmmdXzeZ5fjQ0omtq73PMaeB13pb2wCmYzy+
	 3ZmX1Ob0QgeyzlWQOOPqjO61Y6b7wDtC6y2dw9B0VH0mi0Jdsd1Gn3XqheDXlSKU+G
	 VFfcj+dXD4WTkhF6tsG+1D+KKPYVB8MC/RxnLlWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Glen McCready <gkmccready@meta.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 47/78] mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages
Date: Wed,  2 Nov 2022 03:34:32 +0100
Message-Id: <20221102022054.371007992@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rik van Riel <riel@surriel.com>

commit 12df140f0bdfae5dcfc81800970dd7f6f632e00c upstream.

The h->*_huge_pages counters are protected by the hugetlb_lock, but
alloc_huge_page has a corner case where it can decrement the counter
outside of the lock.

This could lead to a corrupted value of h->resv_huge_pages, which we have
observed on our systems.

Take the hugetlb_lock before decrementing h->resv_huge_pages to avoid a
potential race.

Link: https://lkml.kernel.org/r/20221017202505.0e6a4fcd@imladris.surriel.com
Fixes: a88c76954804 ("mm: hugetlb: fix hugepage memory leak caused by wrong reserve count")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Glen McCready <gkmccready@meta.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2116,11 +2116,11 @@ struct page *alloc_huge_page(struct vm_a
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetPagePrivate(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}


