Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6F2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F4C433D2;
	Mon, 12 Dec 2022 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850704;
	bh=6VSp0i79I5T83XdeetNKWeOU8b1RQGCgX3uT5uO8XM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WutAnU+IoaPKVVxYrGpcu0QYPUGbbYarW0zLYV1WR8G34nqpbZo75X267ZBcLvTwh
	 SV+EA/wOcbJzfCpNwEIrKOn2dfuAGfVsTDjWRbbCk2g+UqIKuV0CLnUhKeHPVlW/bH
	 lyl6H2XwZec21FdMui30VkyeZKK+8Hd76oQRmR6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Shi <alex.shi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	"Chen, Rong A" <rong.a.chen@intel.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Jann Horn <jannh@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@nextfour.com>,
	Minchan Kim <minchan@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <yang.shi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/106] mm/mlock: remove lru_lock on TestClearPageMlocked
Date: Mon, 12 Dec 2022 14:09:04 +0100
Message-Id: <20221212130924.929782499@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit 3db19aa39bac33f2e850fa1ddd67be29b192e51f ]

In the func munlock_vma_page, comments mentained lru_lock needed for
serialization with split_huge_pages.  But the page must be PageLocked as
well as pages in split_huge_page series funcs.  Thus the PageLocked is
enough to serialize both funcs.

Further more, Hugh Dickins pointed: before splitting in
split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
which protect the page from munlock.  Thus, no needs to guard
__split_huge_page_tail for mlock clean, just keep the lru_lock there for
isolation purpose.

LKP found a preempt issue on __mod_zone_page_state which need change to
mod_zone_page_state.  Thanks!

Link: https://lkml.kernel.org/r/1604566549-62481-13-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttilä <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 884b1216da6a..796c726a0407 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -187,40 +187,24 @@ static void __munlock_isolation_failed(struct page *page)
 unsigned int munlock_vma_page(struct page *page)
 {
 	int nr_pages;
-	pg_data_t *pgdat = page_pgdat(page);
 
 	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
-
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
-	/*
-	 * Serialize with any parallel __split_huge_page_refcount() which
-	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes thp_nr_pages().
-	 */
-	spin_lock_irq(&pgdat->lru_lock);
-
 	if (!TestClearPageMlocked(page)) {
 		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
-		nr_pages = 1;
-		goto unlock_out;
+		return 0;
 	}
 
 	nr_pages = thp_nr_pages(page);
-	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+	mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 
-	if (__munlock_isolate_lru_page(page, true)) {
-		spin_unlock_irq(&pgdat->lru_lock);
+	if (!isolate_lru_page(page))
 		__munlock_isolated_page(page);
-		goto out;
-	}
-	__munlock_isolation_failed(page);
-
-unlock_out:
-	spin_unlock_irq(&pgdat->lru_lock);
+	else
+		__munlock_isolation_failed(page);
 
-out:
 	return nr_pages - 1;
 }
 
-- 
2.35.1



