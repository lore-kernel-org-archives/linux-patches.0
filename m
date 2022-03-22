Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2CA6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79723C340EE;
	Tue, 22 Mar 2022 21:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985491;
	bh=zCEyjdx5mHzAsw8Q2UZPFRSoRBqMsxXVKNHia3WkJyw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=GCY75yYEe/eZ1v1mAWx6vqle7Po4M6FgQuNM4h3RwC4rj21re+bA9HAhyRnlbxtS5
	 CjeqRHaw5CkOt0j8EsZmZNUnSX5vSjcsQYypVM9iJBeGNhgknCbhg+CbvOC/VVO3yt
	 3tfNl+hR89ffpYN26TVoADCZOpkiRctcD0Wpg7ug=
Date: Tue, 22 Mar 2022 14:44:50 -0700
To: tony.luck@intel.com,shy828301@gmail.com,naoya.horiguchi@nec.com,mike.kravetz@oracle.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 125/227] mm/memory-failure.c: make non-LRU movable pages unhandlable
Message-Id: <20220322214451.79723C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: make non-LRU movable pages unhandlable

We can not really handle non-LRU movable pages in memory failure. 
Typically they are balloon, zsmalloc, etc.  Assuming we run into a base
(4K) non-LRU movable page, we could reach as far as identify_page_state(),
it should not fall into any category except me_unknown.

For the non-LRU compound movable pages, they could be taken for transhuge
pages but it's unexpected to split non-LRU movable pages using
split_huge_page_to_list in memory_failure.  So we could just simply make
non-LRU movable pages unhandlable to avoid these possible nasty cases.

Link: https://lkml.kernel.org/r/20220312074613.4798-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-make-non-lru-movable-pages-unhandlable
+++ a/mm/memory-failure.c
@@ -1176,12 +1176,18 @@ void ClearPageHWPoisonTakenOff(struct pa
  * does not return true for hugetlb or device memory pages, so it's assumed
  * to be called only in the context where we never have such pages.
  */
-static inline bool HWPoisonHandlable(struct page *page)
+static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 {
-	return PageLRU(page) || __PageMovable(page) || is_free_buddy_page(page);
+	bool movable = false;
+
+	/* Soft offline could mirgate non-LRU movable pages */
+	if ((flags & MF_SOFT_OFFLINE) && __PageMovable(page))
+		movable = true;
+
+	return movable || PageLRU(page) || is_free_buddy_page(page);
 }
 
-static int __get_hwpoison_page(struct page *page)
+static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
 	struct page *head = compound_head(page);
 	int ret = 0;
@@ -1196,7 +1202,7 @@ static int __get_hwpoison_page(struct pa
 	 * for any unsupported type of page in order to reduce the risk of
 	 * unexpected races caused by taking a page refcount.
 	 */
-	if (!HWPoisonHandlable(head))
+	if (!HWPoisonHandlable(head, flags))
 		return -EBUSY;
 
 	if (get_page_unless_zero(head)) {
@@ -1221,7 +1227,7 @@ static int get_any_page(struct page *p,
 
 try_again:
 	if (!count_increased) {
-		ret = __get_hwpoison_page(p);
+		ret = __get_hwpoison_page(p, flags);
 		if (!ret) {
 			if (page_count(p)) {
 				/* We raced with an allocation, retry. */
@@ -1249,7 +1255,7 @@ try_again:
 		}
 	}
 
-	if (PageHuge(p) || HWPoisonHandlable(p)) {
+	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
 		ret = 1;
 	} else {
 		/*
@@ -2302,7 +2308,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags);
+	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
 	if (ret > 0) {
_
