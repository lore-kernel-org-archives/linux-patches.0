Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591430;
	b=R6c1xqOjjYd7w7rU6o+UB8JAC/k9vpiSE7sHa6vxJxAubQFgUHBL+KAWkVQ3fVp2jvIx
	 YBLGJf6Iw33RZPOXA0lhJe6hogKhG64C7BojSzJYucQUjB0yUd+xLxIXdASPeOOt6x2Fv
	 QSCoGGSaYZrNS/IdACrDYeXpU85ONIkJd9WtIM/eIMEymqUUC2JWR5eEyhlAxcwKOhXNY
	 DDHf0zCcIrxTkVFjWItPDQDVYG/RzgcWTGeJTu/PquGH78Y9sjMvj3le/79/vGNLSg4XJ
	 w/D+aFO06DVQOe4Chz3s2e6/xEAJoeZibYrTkrUCUewhEfV0xWRn8rBxeeEa8fZRpEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LdG9FEko6quGNdiH4X7EPKPNq/mT8jOMQBMKAC2JSP4=;
	b=5UJ5bPWcdZ2tqRPPZq3hfV+W7KTJ8c4AQOSxLRrxn8a7E+bzOiAqPoV0eA5E8NE7H0/F
	 vXoKM8MBLXwgOcyac7IS6+ZTs0FyY3Hw0tbWZxmarLPrJu1wWAeZz/PQkIz6mBgfv0xsw
	 6SYw33aI+U18QF9sx8cxHiTPHoe7eBq2Y76yhTg6b9802TEx3riNB5eJQ/OgXRhwOZd7k
	 4+yu7IbSPLo0/iO0QxbWwDNJ/8QYxF15S5Mukk3koPzXdqGbFmg+QmNtPH3CBSgshBH9x
	 X17KCOkp+jBH1pbnUHk91va7BGhOkpZ+ePu38Ghcr7YjGHoVzm/I7neWOqoIdD3LQ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5tV7dBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2972606E204;
	Fri, 13 Nov 2026 17:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5tV7dBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A511F000C4;
	Fri, 13 Nov 2026 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591429;
	bh=LdG9FEko6quGNdiH4X7EPKPNq/mT8jOMQBMKAC2JSP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5tV7dBPdLXexYoe+v4pr6pSdT2wrReTIXBG7XftRgHbKtyUQKEj9Gm5d10XqnKZi
	 JmK7MMgfxNfPe2OVDf4qxxaMMxjJZ3J0rCmlKBWBLXLshYhCjOW44I15zYJn8IY60P
	 JjzSr973ToHRxXTjUVbqxl95o2W9fVVo9k2CmbZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ge Yang <yangge1116@126.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 470/670] mm/hugetlb: remove unnecessary holding of hugetlb_lock
Date: Fri, 13 Nov 2026 10:50:34 -0500
Message-ID: <20261113153827.892907308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 344ef45b03336e7f74658814f66483b5417c9cf1 ]

In isolate_or_dissolve_huge_folio(), after acquiring the hugetlb_lock, it
is only for the purpose of obtaining the correct hstate, which is then
passed to alloc_and_dissolve_hugetlb_folio().

alloc_and_dissolve_hugetlb_folio() itself also acquires the hugetlb_lock.
We can have alloc_and_dissolve_hugetlb_folio() obtain the hstate by
itself, so that isolate_or_dissolve_huge_folio() no longer needs to
acquire the hugetlb_lock.  In addition, we keep the folio_test_hugetlb()
check within isolate_or_dissolve_huge_folio().  By doing so, we can avoid
disrupting the normal path by vainly holding the hugetlb_lock.

replace_free_hugepage_folios() has the same issue, and we should address
it as well.

Addresses a possible performance problem which was added by the hotfix
113ed54ad276 ("mm/hugetlb: fix kernel NULL pointer dereference when
replacing free hugetlb folios").

Link: https://lkml.kernel.org/r/1748317010-16272-1-git-send-email-yangge1116@126.com
Fixes: 113ed54ad276 ("mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios")
Signed-off-by: Ge Yang <yangge1116@126.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Dropped the struct hstate *h; declaration (kept page_folio()) because this tree still uses the page-based isolate_or_dissolve_huge_page() name and signature, which differ from upstream's folio version. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 54 +++++++++++++++++-----------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f72edd252250..01b81fdf86f68 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2866,20 +2866,24 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 /*
  * alloc_and_dissolve_hugetlb_folio - Allocate a new folio and dissolve
  * the old one
- * @h: struct hstate old page belongs to
  * @old_folio: Old folio to dissolve
  * @list: List to isolate the page in case we need to
  * Returns 0 on success, otherwise negated error.
  */
-static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
-			struct folio *old_folio, struct list_head *list)
+static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
+			struct list_head *list)
 {
-	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+	gfp_t gfp_mask;
+	struct hstate *h;
 	int nid = folio_nid(old_folio);
 	struct folio *new_folio = NULL;
 	int ret = 0;
 
 retry:
+	/*
+	 * The old_folio might have been dissolved from under our feet, so make sure
+	 * to carefully check the state under the lock.
+	 */
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(old_folio)) {
 		/*
@@ -2908,8 +2912,10 @@ static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
 		cond_resched();
 		goto retry;
 	} else {
+		h = folio_hstate(old_folio);
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
+			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
 							      NULL, NULL);
 			if (!new_folio)
@@ -2953,36 +2959,25 @@ static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 {
-	struct hstate *h;
 	struct folio *folio = page_folio(page);
 	int ret = -EBUSY;
 
-	/*
-	 * The page might have been dissolved from under our feet, so make sure
-	 * to carefully check the state under the lock.
-	 * Return success when racing as if we dissolved the page ourselves.
-	 */
-	spin_lock_irq(&hugetlb_lock);
-	if (folio_test_hugetlb(folio)) {
-		h = folio_hstate(folio);
-	} else {
-		spin_unlock_irq(&hugetlb_lock);
+	/* Not to disrupt normal path by vainly holding hugetlb_lock */
+	if (!folio_test_hugetlb(folio))
 		return 0;
-	}
-	spin_unlock_irq(&hugetlb_lock);
 
 	/*
 	 * Fence off gigantic pages as there is a cyclic dependency between
 	 * alloc_contig_range and them. Return -ENOMEM as this has the effect
 	 * of bailing out right away without further retrying.
 	 */
-	if (hstate_is_gigantic(h))
+	if (folio_order(folio) > MAX_PAGE_ORDER)
 		return -ENOMEM;
 
 	if (folio_ref_count(folio) && isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
-		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
+		ret = alloc_and_dissolve_hugetlb_folio(folio, list);
 
 	return ret;
 }
@@ -3004,7 +2999,6 @@ void wait_for_freed_hugetlb_folios(void)
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct hstate *h;
 	struct folio *folio;
 	int ret = 0;
 
@@ -3013,23 +3007,9 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 	while (start_pfn < end_pfn) {
 		folio = pfn_folio(start_pfn);
 
-		/*
-		 * The folio might have been dissolved from under our feet, so make sure
-		 * to carefully check the state under the lock.
-		 */
-		spin_lock_irq(&hugetlb_lock);
-		if (folio_test_hugetlb(folio)) {
-			h = folio_hstate(folio);
-		} else {
-			spin_unlock_irq(&hugetlb_lock);
-			start_pfn++;
-			continue;
-		}
-		spin_unlock_irq(&hugetlb_lock);
-
-		if (!folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
-							       &isolate_list);
+		/* Not to disrupt normal path by vainly holding hugetlb_lock */
+		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
 			if (ret)
 				break;
 
-- 
2.53.0



