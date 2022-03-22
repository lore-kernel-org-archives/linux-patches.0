Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4A6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6A9C340EC;
	Tue, 22 Mar 2022 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985724;
	bh=mUuROq10ahLPR03SHPG1MdCOWBxv+599rSB3EdvybYM=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=lKyB3klfkRYBZsMx+kfzEWYz1fAOXkpTXebbCnMOSwo8Jx9TH/dONH3VWnAkXwPe+
	 R2zuCsNhgJOSLNpFeSb2eXQlbVbb6d/2+kD2+C7W6+N19YiPRzVJ/oHyXjRAHYFv0B
	 J3ChoBMbZU4J04CKaH+UFZ303yfDkgAYeuqdsuJQ=
Date: Tue, 22 Mar 2022 14:48:43 -0700
To: sj@kernel.org,rientjes@google.com,linmiaohe@huawei.com,jrdr.linux@gmail.com,dan.carpenter@oracle.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 201/227] mm/damon: remove redundant page validation
Message-Id: <20220322214843.DD6A9C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: remove redundant page validation

It will never get a NULL page by pte_page() as discussed in thread [1],
thus remove the redundant page validation to fix below Smatch static
checker warning.

    mm/damon/vaddr.c:405 damon_hugetlb_mkold()
    warn: 'page' can't be NULL.

[1] https://lore.kernel.org/linux-mm/20220106091200.GA14564@kili/

Link: https://lkml.kernel.org/r/6d32f7d201b8970d53f51b6c5717d472aed2987c.1642386715.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-remove-redundant-page-validation
+++ a/mm/damon/vaddr.c
@@ -402,9 +402,6 @@ static void damon_hugetlb_mkold(pte_t *p
 	pte_t entry = huge_ptep_get(pte);
 	struct page *page = pte_page(entry);
 
-	if (!page)
-		return;
-
 	get_page(page);
 
 	if (pte_young(entry)) {
@@ -564,9 +561,6 @@ static int damon_young_hugetlb_entry(pte
 		goto out;
 
 	page = pte_page(entry);
-	if (!page)
-		goto out;
-
 	get_page(page);
 
 	if (pte_young(entry) || !page_is_idle(page) ||
_
