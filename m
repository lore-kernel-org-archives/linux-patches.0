Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B80137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3285DC2BBE4;
	Fri,  1 Apr 2022 18:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837708;
	bh=2hQH4xIfEI7cKb8n8lwC1lNjdFUqMLTsrFO0c/gJyxI=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=fRoz1FkM6CrxpvCckjKNb6Cj+/bSdqzaSXAcYspSbXnrKOIbf3/3PinUJ4ukaRhLG
	 pUJ07KDeKpSm9/JK/cpFzE0TDy/q/nzymyC6ayjni9uYHnYBMjtwoLfMgzKGO+s4Qy
	 3P07KRj6WCKIjSIy7c1otB5b3CYb9MpJEr9WQyb0=
Date: Fri, 01 Apr 2022 11:28:27 -0700
To: vbabka@suse.cz,efault@gmx.de,hughd@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 06/16] mm/munlock: add lru_add_drain() to fix memcg_stat_test
Message-Id: <20220401182828.3285DC2BBE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: add lru_add_drain() to fix memcg_stat_test

Mike reports that LTP memcg_stat_test usually leads to...
memcg_stat_test 3 TINFO: Test unevictable with MAP_LOCKED
memcg_stat_test 3 TINFO: Running memcg_process --mmap-lock1 -s 135168
memcg_stat_test 3 TINFO: Warming up pid: 3460
memcg_stat_test 3 TINFO: Process is still here after warm up: 3460
memcg_stat_test 3 TFAIL: unevictable is 122880, 135168 expected
...but may lead to...
memcg_stat_test 4 TINFO: Test unevictable with mlock
memcg_stat_test 4 TINFO: Running memcg_process --mmap-lock2 -s 135168
memcg_stat_test 4 TINFO: Warming up pid: 4271
memcg_stat_test 4 TINFO: Process is still here after warm up: 4271
memcg_stat_test 4 TFAIL: unevictable is 122880, 135168 expected
...or both.  A wee bit flaky.

follow_page_pte() used to have an lru_add_drain() per each page mlocked,
and the test came to rely on accurate stats.  The pagevec to be drained is
different now, but still covered by lru_add_drain(); and, never mind the
test, I believe it's in everyone's interest that a bulk faulting interface
like populate_vma_page_range() or faultin_vma_page_range() should drain
its local pagevecs at the end, to save others sometimes needing the much
more expensive lru_add_drain_all().  This does not absolutely guarantee
exact stats - the mlocking task can be migrated between CPUs as it
proceeds - but it's good enough and the tests pass.

Link: https://lkml.kernel.org/r/47f6d39c-a075-50cb-1cfb-26dd957a48af@google.com
Fixes: b67bf49ce7aa ("mm/munlock: delete FOLL_MLOCK and FOLL_POPULATE")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Mike Galbraith <efault@gmx.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-munlock-add-lru_add_drain-to-fix-memcg_stat_test
+++ a/mm/gup.c
@@ -1404,6 +1404,7 @@ long populate_vma_page_range(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
+	long ret;
 
 	VM_BUG_ON(!PAGE_ALIGNED(start));
 	VM_BUG_ON(!PAGE_ALIGNED(end));
@@ -1438,8 +1439,10 @@ long populate_vma_page_range(struct vm_a
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
 	 */
-	return __get_user_pages(mm, start, nr_pages, gup_flags,
+	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
 				NULL, NULL, locked);
+	lru_add_drain();
+	return ret;
 }
 
 /*
@@ -1471,6 +1474,7 @@ long faultin_vma_page_range(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
+	long ret;
 
 	VM_BUG_ON(!PAGE_ALIGNED(start));
 	VM_BUG_ON(!PAGE_ALIGNED(end));
@@ -1498,8 +1502,10 @@ long faultin_vma_page_range(struct vm_ar
 	if (check_vma_flags(vma, gup_flags))
 		return -EINVAL;
 
-	return __get_user_pages(mm, start, nr_pages, gup_flags,
+	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
 				NULL, NULL, locked);
+	lru_add_drain();
+	return ret;
 }
 
 /*
_
