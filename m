Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B42189915;
	Fri, 15 Nov 2024 06:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653515; cv=none; b=fhT6d3DIcPsxND1Avs5Spv47c3O6XHSjdTwiHQV/0s2nak+M4Ns5xbQneepZ90kimnYeUgpnyZdROsiD44MTu86+UYiI7f1nPiXhlduJuat7EcHrGKCeSI7yEI8xC+18PgO1RwZe1JJVIWq8pOhqvSCBjeydQ/R4gItOl1ZkV8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653515; c=relaxed/simple;
	bh=frzP8z4NXUYDwpY4IghV+FCS1sPVFSfRYoj8zopAPT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IElbnxsvgBNbUvQly8DOWphQvjXJrLCVaCug7TDfD+bVhJPckumr7I4KbSCJp6oZTomoY+j9zZX1nBr99a6aopXRR0wMuYuWTFFYH/UGivOqiQRwYamk5dj9m2CDzK5VtwwKP5osrLpmwDjZNG3h2WF9fYxZ6i1mQDMm/AggDRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3wJVmHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3wJVmHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3994FC4CECF;
	Fri, 15 Nov 2024 06:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653514;
	bh=frzP8z4NXUYDwpY4IghV+FCS1sPVFSfRYoj8zopAPT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3wJVmHQ4CAwVwWb7tgzrzmKNwftaNanoB1TMFOdM6r/CqjBhBksE5qw2qqTij8u0
	 K8WOGq0sGwvqjNRwxusCvJwfwv2lGR/H7M3KNeJTzOtF9uLzFFnrYZVFJr+yHNk6n1
	 JDRA7aGX7q63aaLsR6+vWYODSZ0RLHfhQspSKOlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH 6.6 45/48] mm: always initialise folio->_deferred_list
Date: Fri, 15 Nov 2024 07:38:34 +0100
Message-ID: <20241115063724.587802492@linuxfoundation.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit b7b098cf00a2b65d5654a86dc8edf82f125289c1 upstream.

Patch series "Various significant MM patches".

These patches all interact in annoying ways which make it tricky to send
them out in any way other than a big batch, even though there's not really
an overarching theme to connect them.

The big effects of this patch series are:

 - folio_test_hugetlb() becomes reliable, even when called without a
   page reference
 - We free up PG_slab, and we could always use more page flags
 - We no longer need to check PageSlab before calling page_mapcount()

This patch (of 9):

For compound pages which are at least order-2 (and hence have a
deferred_list), initialise it and then we can check at free that the page
is not part of a deferred list.  We recently found this useful to rule out
a source of corruption.

[peterx@redhat.com: always initialise folio->_deferred_list]
  Link: https://lkml.kernel.org/r/20240417211836.2742593-2-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240321142448.1645400-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240321142448.1645400-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Include three small changes from the upstream commit, for backport safety:
  replace list_del() by list_del_init() in split_huge_page_to_list(),
  like c010d47f107f ("mm: thp: split huge page to any lower order pages");
  replace list_del() by list_del_init() in folio_undo_large_rmappable(), like
  9bcef5973e31 ("mm: memcg: fix split queue list crash when large folio migration");
  keep __free_pages() instead of folio_put() in __update_and_free_hugetlb_folio(). ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    6 ++----
 mm/hugetlb.c     |    1 +
 mm/internal.h    |    2 ++
 mm/memcontrol.c  |    3 +++
 mm/page_alloc.c  |    9 +++++----
 5 files changed, 13 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -571,8 +571,6 @@ void folio_prep_large_rmappable(struct f
 {
 	if (!folio || !folio_test_large(folio))
 		return;
-	if (folio_order(folio) > 1)
-		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
@@ -2725,7 +2723,7 @@ int split_huge_page_to_list(struct page
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
-			list_del(&folio->_deferred_list);
+			list_del_init(&folio->_deferred_list);
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
@@ -2789,7 +2787,7 @@ void folio_undo_large_rmappable(struct f
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
-		list_del(&folio->_deferred_list);
+		list_del_init(&folio->_deferred_list);
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1795,6 +1795,7 @@ static void __update_and_free_hugetlb_fo
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
+		INIT_LIST_HEAD(&folio->_deferred_list);
 		__free_pages(&folio->page, huge_page_order(h));
 	}
 }
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -431,6 +431,8 @@ static inline void prep_compound_head(st
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
+	if (order > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
 static inline void prep_compound_tail(struct page *head, int tail_idx)
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7153,6 +7153,9 @@ static void uncharge_folio(struct folio
 	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
+			!folio_test_hugetlb(folio) &&
+			!list_empty(&folio->_deferred_list), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1002,10 +1002,11 @@ static int free_tail_page_prepare(struct
 		}
 		break;
 	case 2:
-		/*
-		 * the second tail page: ->mapping is
-		 * deferred_list.next -- ignore value.
-		 */
+		/* the second tail page: deferred_list overlaps ->mapping */
+		if (unlikely(!list_empty(&folio->_deferred_list))) {
+			bad_page(page, "on deferred list");
+			goto out;
+		}
 		break;
 	default:
 		if (page->mapping != TAIL_MAPPING) {


