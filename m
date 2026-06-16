Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9C53D47CE;
	Tue, 16 Jun 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632833; cv=none; b=QGAWO/x1oaM+JeDLrhc9WLQ5rOHFYoCDZIZzm1dPHPsvAZdDlRKIiVq6cv+rDJhGZT6HJRcsI779F3HeY/RX//FF5QAp6CCvynxE2wPoAm+fjJTnXDjeQjeoATuYst5DkmBoqast/xDthXb63flgOa9hucCC8o9UVp4PBqQd5FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632833; c=relaxed/simple;
	bh=4fTE7QnV+HpQHUymCb0c+0fsPwT5mhO/7NAMrDMnCJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kitvpwkpg7fmj7nIH4ld63EZ8hGKaF9SPu/tsBEZdFEkyeQmMAlEz+YEXHwhJ8GzQbJ7f+ezv3VJ72umny8OId+/qI9LGVYB6+uWGD2nz28qejbkdnzOnohN7lpVHmjRiqY4ODuAFxnCzNVt+S8+mwMzeKWnDFCy/gOASXSCntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNx4qNkb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNx4qNkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124801F000E9;
	Tue, 16 Jun 2026 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632832;
	bh=Z6urFAwqsT/P/c6PfZGrcnG8Q8t1RZF6KFK5PWEMTB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNx4qNkbY0Ltk9pGKo2aCsbyP+895mhTcktjuIdt6AqzrqF2IqCFxVV6SM27197Xv
	 GdAZS1wgpTHEIX/6jlYbFfczq6edGX+H7wQNYVCMQC7wm/PYWSEvrkWn8Dw7Lndabb
	 g6NpQznFF7ZwhFO8R+hO/wF7JAKOde/uOwB451O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/522] mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison
Date: Tue, 16 Jun 2026 20:30:33 +0530
Message-ID: <20260616145148.550265518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wupeng Ma <mawupeng1@huawei.com>

[ Upstream commit 3c2d42b8ee345b17a4ba56b0f6492d1ff4c1178e ]

Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page can
trigger a recursive spinlock self-deadlock (AA deadlock) on hugetlb_lock
when racing with a concurrent unmap:

  thread#0                              thread#1
  --------                              --------
  madvise(folio, MADV_HWPOISON)
    -> poisons the folio successfully
  madvise(folio, MADV_HWPOISON)         unmap(folio)
    try_memory_failure_hugetlb
      get_huge_page_for_hwpoison
        spin_lock_irq(&hugetlb_lock)    <- held
        __get_huge_page_for_hwpoison
          hugetlb_update_hwpoison()
            -> MF_HUGETLB_FOLIO_PRE_POISONED
          goto out:
            folio_put()
              refcount: 1 -> 0
              free_huge_folio()
                spin_lock_irqsave(&hugetlb_lock)
                  -> AA DEADLOCK!

The out: path in __get_huge_page_for_hwpoison() calls folio_put() to drop
the GUP reference while the hugetlb_lock is still held by the hugetlb.c
wrapper get_huge_page_for_hwpoison().  If concurrent unmap has released
the page table mapping reference, folio_put() drops the folio refcount to
zero, triggering free_huge_folio() which attempts to re-acquire the
non-recursive hugetlb_lock.

Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
folio_put() at the out: label so the folio is always released outside the
lock.

[akpm@linux-foundation.org: fix race, rename label per Miaohe]
  Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
  Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
Link: https://lore.kernel.org/20260522010305.4099834-1-mawupeng1@huawei.com
Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    6 ------
 include/linux/mm.h      |    5 -----
 mm/hugetlb.c            |   10 ----------
 mm/memory-failure.c     |   19 ++++++++++---------
 4 files changed, 10 insertions(+), 30 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -184,7 +184,6 @@ long hugetlb_unreserve_pages(struct inod
 						long freed);
 int folio_isolate_hugetlb(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void folio_putback_hugetlb(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -437,11 +436,6 @@ static inline int get_hwpoison_huge_page
 {
 	return 0;
 }
-
-static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
-{
-	return 0;
-}
 
 static inline void folio_putback_hugetlb(struct page *page)
 {
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3429,15 +3429,10 @@ extern atomic_long_t num_poisoned_pages
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
 extern void memory_failure_queue(unsigned long pfn, int flags);
-extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
-static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
-{
-	return 0;
-}
 #endif
 
 #ifndef arch_memory_failure
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7499,16 +7499,6 @@ int get_hwpoison_huge_page(struct page *
 	return ret;
 }
 
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
-{
-	int ret;
-
-	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags);
-	spin_unlock_irq(&hugetlb_lock);
-	return ret;
-}
-
 /**
  * folio_putback_hugetlb - unisolate a hugetlb page
  * @page: the isolated hugetlb page
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1812,19 +1812,18 @@ void hugetlb_clear_page_hwpoison(struct
 	free_raw_hwp_pages(hpage, true);
 }
 
-/*
- * Called from hugetlb code with hugetlb_lock held.
- */
-int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+static int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct page *head = compound_head(page);
+	struct page *head;
 	bool count_increased = false;
 	int ret, rc;
 
+	spin_lock_irq(&hugetlb_lock);
+	head = compound_head(page);
 	if (!PageHeadHuge(head)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
-		goto out;
+		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
@@ -1840,17 +1839,19 @@ int __get_huge_page_for_hwpoison(unsigne
 	} else {
 		ret = MF_HUGETLB_RETRY;
 		if (!(flags & MF_NO_RETRY))
-			goto out;
+			goto out_unlock;
 	}
 
 	rc = hugetlb_update_hwpoison(head, page);
 	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
 		ret = rc;
-		goto out;
+		goto out_unlock;
 	}
 
+	spin_unlock_irq(&hugetlb_lock);
 	return ret;
-out:
+out_unlock:
+	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		put_page(head);
 	return ret;


