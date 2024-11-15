Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8E4186294;
	Fri, 15 Nov 2024 06:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653518; cv=none; b=fDRy7fG4fMXVOaHZ3/EuGQ5Abv3cB+V87MK7xhGlaquQs4kOgEbI8b9nuQjmc7nAGoSlFgTS+An/L+LbwEw7eOa7nM7DuwSVO3sNDe1mH676LiHIh9SkKLdwRMxmp+bilPvh1Ga0M9UITF6DPig95ovH9kCxQ8To/2RZGau3U9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653518; c=relaxed/simple;
	bh=ew3+ijphF7i3LsGCfjfwmnZd+vkJav76YIYVbnkJWmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+xC69B0fJyL6Ol+oD1CdpklscTg+3f8gMk87w+JhSuoV00pWPa9Tda0DIAqADdvnrITkkryQnIcK03m3ohzK/sTSwnuEcIcy8YUsFkqWkSE0Zx8LLN6CymrHPPynAtg1RD7AwkbxTcoK2D/T/aNnmb0uaHOJZc0fOKnlBxmpVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCe1x09W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCe1x09W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A94C4CECF;
	Fri, 15 Nov 2024 06:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653517;
	bh=ew3+ijphF7i3LsGCfjfwmnZd+vkJav76YIYVbnkJWmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCe1x09Wqcxbbg75eoBmQc4LNawVewDA6Oukv5hmF5u1bBg0ft1BQsMS+6yQkY47c
	 SAdFj8eTVOud5NPU+4PuAXpdCJ40Z1Qrw6XmBDQC25Px88qDs/dIplNBw8t5wILgKW
	 qW5uDxGoc+uXSq1S9qLkPczoGR78ojp3UJFpwQaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lance Yang <ioworker0@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH 6.6 46/48] mm: refactor folio_undo_large_rmappable()
Date: Fri, 15 Nov 2024 07:38:35 +0100
Message-ID: <20241115063724.623741857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 593a10dabe08dcf93259fce2badd8dc2528859a8 upstream.

Folios of order <= 1 are not in deferred list, the check of order is added
into folio_undo_large_rmappable() from commit 8897277acfef ("mm: support
order-1 folios in the page cache"), but there is a repeated check for
small folio (order 0) during each call of the
folio_undo_large_rmappable(), so only keep folio_order() check inside the
function.

In addition, move all the checks into header file to save a function call
for non-large-rmappable or empty deferred_list folio.

Link: https://lkml.kernel.org/r/20240521130315.46072-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Upstream commit itself does not apply cleanly, because there
  are fewer calls to folio_undo_large_rmappable() in this tree. ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   13 +------------
 mm/internal.h    |   17 ++++++++++++++++-
 mm/page_alloc.c  |    4 +---
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2767,22 +2767,11 @@ out:
 	return ret;
 }
 
-void folio_undo_large_rmappable(struct folio *folio)
+void __folio_undo_large_rmappable(struct folio *folio)
 {
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
-	if (folio_order(folio) <= 1)
-		return;
-
-	/*
-	 * At this point, there is no one trying to add the folio to
-	 * deferred_list. If folio is not in deferred_list, it's safe
-	 * to check without acquiring the split_queue_lock.
-	 */
-	if (data_race(list_empty(&folio->_deferred_list)))
-		return;
-
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (!list_empty(&folio->_deferred_list)) {
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -413,7 +413,22 @@ static inline void folio_set_order(struc
 #endif
 }
 
-void folio_undo_large_rmappable(struct folio *folio);
+void __folio_undo_large_rmappable(struct folio *folio);
+static inline void folio_undo_large_rmappable(struct folio *folio)
+{
+	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
+		return;
+
+	/*
+	 * At this point, there is no one trying to add the folio to
+	 * deferred_list. If folio is not in deferred_list, it's safe
+	 * to check without acquiring the split_queue_lock.
+	 */
+	if (data_race(list_empty(&folio->_deferred_list)))
+		return;
+
+	__folio_undo_large_rmappable(folio);
+}
 
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -600,9 +600,7 @@ void destroy_large_folio(struct folio *f
 		return;
 	}
 
-	if (folio_test_large_rmappable(folio))
-		folio_undo_large_rmappable(folio);
-
+	folio_undo_large_rmappable(folio);
 	mem_cgroup_uncharge(folio);
 	free_the_page(&folio->page, folio_order(folio));
 }


