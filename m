Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79C27FD5B;
	Wed, 23 Apr 2025 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420300; cv=none; b=MpdfV8BlLKc7LBWKhmxTQiYvrowYI1dTGt8yIu/DvplJiDCMGSAntdvdPjpabEzzpGrhXA029u8kiQ4tBKvqWAzWTWBefGAwMcMRFz5t7qLxfi7Xxf6MZGdIVeKd1JqOW/h0ySsNPQ6IhjN4rxF7OMMBcfTPstowpJ4Q/9bYG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420300; c=relaxed/simple;
	bh=VZWEy9zB+zJ1BiPxeVr4LOkfCPGpbIQGEhk6JmBelPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra2RgtVAwYQg2HtkVBHt9CXzCK8TUQ2Y1w3T039oxNin9L4YCXRq6yqXg5k5uPC65PZNRUytg69JzzJOuCf5bXwaEo++Kpu9iwEtO7kN1+6Vrn438CYQ2aNUJojhNooPpiG1pohapXb/1ruM3AQfv0GCRiI5Q0Vt7U38TDXeyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8sJuLEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8sJuLEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12BFC4CEE2;
	Wed, 23 Apr 2025 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420300;
	bh=VZWEy9zB+zJ1BiPxeVr4LOkfCPGpbIQGEhk6JmBelPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8sJuLEaBbg4Si5RdBttHwA620nKjG32t0ifhTT2qSkUA1rc+8EqSu5x0iWWXJaSr
	 PRBcC3HAnxKFypwvpO8qd1830TC5Vey4+NLCZcODKp3OIdogIod5u0w3RaHqAc0A2G
	 ebwAqncExJfG8rrSyyp4nlmVJ1vqWT241lAxeP3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 117/223] mm/compaction: fix bug in hugetlb handling pathway
Date: Wed, 23 Apr 2025 16:43:09 +0200
Message-ID: <20250423142621.877247451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

commit a84edd52f0a0fa193f0f685769939cf84510755b upstream.

The compaction code doesn't take references on pages until we're certain
we should attempt to handle it.

In the hugetlb case, isolate_or_dissolve_huge_page() may return -EBUSY
without taking a reference to the folio associated with our pfn.  If our
folio's refcount drops to 0, compound_nr() becomes unpredictable, making
low_pfn and nr_scanned unreliable.  The user-visible effect is minimal -
this should rarely happen (if ever).

Fix this by storing the folio statistics earlier on the stack (just like
the THP and Buddy cases).

Also revert commit 66fe1cf7f581 ("mm: compaction: use helper compound_nr
in isolate_migratepages_block") to make backporting easier.

Link: https://lkml.kernel.org/r/20250401021025.637333-1-vishal.moola@gmail.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -980,13 +980,13 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page)) {
+			const unsigned int order = compound_order(page);
 			/*
 			 * skip hugetlbfs if we are not compacting for pages
 			 * bigger than its order. THPs and other compound pages
 			 * are handled below.
 			 */
 			if (!cc->alloc_contig) {
-				const unsigned int order = compound_order(page);
 
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
@@ -1010,8 +1010,8 @@ isolate_migratepages_block(struct compac
 				 /* Do not report -EBUSY down the chain */
 				if (ret == -EBUSY)
 					ret = 0;
-				low_pfn += compound_nr(page) - 1;
-				nr_scanned += compound_nr(page) - 1;
+				low_pfn += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
 				goto isolate_fail;
 			}
 


