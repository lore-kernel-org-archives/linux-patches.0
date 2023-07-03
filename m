Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864CA101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEEFC433C7;
	Mon,  3 Jul 2023 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410588;
	bh=DUEdUhfkjFg4dEHv6hhIC0ZS7mD55KNny4uT0v4xvK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfKmO7jQZ998A3gn5AIr2GaPe9wxfNZhERUMRKtZbO0JUiuvKU/vFxj2/aEG5OLPf
	 zOuRHmURELr1Zg7FAQ/Kdt5vkbs9f7AVzGJ87zq6ixZwdNohhgips+rAQOrppkPs5V
	 S+6hK+wgWvKf4/9zm12p+BxTic3jZRawJwE6JtP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Erdem Aktas <erdemaktas@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 09/13] hugetlb: revert use of page_cache_next_miss()
Date: Mon,  3 Jul 2023 20:54:19 +0200
Message-ID: <20230703184519.477133328@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.206275653@linuxfoundation.org>
References: <20230703184519.206275653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Kravetz <mike.kravetz@oracle.com>

commit fd4aed8d985a3236d0877ff6d0c80ad39d4ce81a upstream.

Ackerley Tng reported an issue with hugetlbfs fallocate as noted in the
Closes tag.  The issue showed up after the conversion of hugetlb page
cache lookup code to use page_cache_next_miss.  User visible effects are:

- hugetlbfs fallocate incorrectly returns -EEXIST if pages are presnet
  in the file.
- hugetlb pages will not be included in core dumps if they need to be
  brought in via GUP.
- userfaultfd UFFDIO_COPY will not notice pages already present in the
  cache.  It may try to allocate a new page and potentially return
  ENOMEM as opposed to EEXIST.

Revert the use page_cache_next_miss() in hugetlb code.

IMPORTANT NOTE FOR STABLE BACKPORTS:
This patch will apply cleanly to v6.3.  However, due to the change of
filemap_get_folio() return values, it will not function correctly.  This
patch must be modified for stable backports.

[dan.carpenter@linaro.org: fix hugetlbfs_pagecache_present()]
  Link: https://lkml.kernel.org/r/efa86091-6a2c-4064-8f55-9b44e1313015@moroto.mountain
Link: https://lkml.kernel.org/r/20230621212403.174710-2-mike.kravetz@oracle.com
Fixes: d0ce0e47b323 ("mm/hugetlb: convert hugetlb fault paths to use alloc_hugetlb_folio()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: Ackerley Tng <ackerleytng@google.com>
Closes: https://lore.kernel.org/linux-mm/cover.1683069252.git.ackerleytng@google.com
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    8 +++-----
 mm/hugetlb.c         |   12 ++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -821,7 +821,6 @@ static long hugetlbfs_fallocate(struct f
 		 */
 		struct folio *folio;
 		unsigned long addr;
-		bool present;
 
 		cond_resched();
 
@@ -845,10 +844,9 @@ static long hugetlbfs_fallocate(struct f
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
-		rcu_read_lock();
-		present = page_cache_next_miss(mapping, index, 1) != index;
-		rcu_read_unlock();
-		if (present) {
+		folio = filemap_get_folio(mapping, index);
+		if (!IS_ERR(folio)) {
+			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_drop_vma_policy(&pseudo_vma);
 			continue;
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5672,13 +5672,13 @@ static bool hugetlbfs_pagecache_present(
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	pgoff_t idx = vma_hugecache_offset(h, vma, address);
-	bool present;
+	struct folio *folio;
 
-	rcu_read_lock();
-	present = page_cache_next_miss(mapping, idx, 1) != idx;
-	rcu_read_unlock();
-
-	return present;
+	folio = filemap_get_folio(mapping, idx);
+	if (IS_ERR(folio))
+		return false;
+	folio_put(folio);
+	return true;
 }
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,


