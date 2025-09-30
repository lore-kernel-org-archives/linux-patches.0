Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF48E846F;
	Tue, 30 Sep 2025 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245813; cv=none; b=W6ReDUZJcfY92fuDUzVZSP0+Rv9Tu6dQJ5l3QtG9lGz5SSSHCa2ffKmwWD1pBund+fibvfvXQeiNmHM9QMk1oD/tP/PzatWt0GV54W71fwcQtJCMCMlYr6C5mgS8AQEmUGGf3/8Dapwmfnxi1dx1WBb2zv3UxYSXuQaQqclWpq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245813; c=relaxed/simple;
	bh=3KeIgCxQ7/vy6Up/ToBIRgHenVEju0zYhczMIOV3jpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCare3cgt+sQXkHHUBcLxYxqvM28msFDbaG3UddAMeCSLRPWU+6PxUFFblh/ma8kb+WpSo1OiFfSBdNp9A/r+WXqk1aPb0X/tkyfJQoIwEC9uht23ZeOFIaTx+Of7sic9Sb+314Ch75TacNKMFeyF7X16/mbGB+EOqbp23YrFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9jtzbvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9jtzbvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90592C4CEF0;
	Tue, 30 Sep 2025 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245813;
	bh=3KeIgCxQ7/vy6Up/ToBIRgHenVEju0zYhczMIOV3jpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9jtzbvNWMoZaVBCTpNwj0Ew77K/P0SR0cNX/WehYuVd/MxvURFX+AT1dAuhrwAid
	 8+pJfP+L6BbAkFZellg9F4A2ucw1UNJERSlQgvebErW2T2Z7xNRqsMmWyLVKb2VG8n
	 VWyIKsayqincs1pWXCyQ1kYSiWTNxYpKpEos9rUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chris Li <chrisl@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Keir Fraser <keirf@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Li Zhe <lizhe.67@bytedance.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Shivank Garg <shivankg@amd.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Xu <weixugc@google.com>,
	Will Deacon <will@kernel.org>,
	yangge <yangge1116@126.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/91] mm: folio_may_be_lru_cached() unless folio_test_large()
Date: Tue, 30 Sep 2025 16:47:25 +0200
Message-ID: <20250930143822.227352066@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 2da6de30e60dd9bb14600eff1cc99df2fa2ddae3 ]

mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as a
large folio is added: so collect_longterm_unpinnable_folios() just wastes
effort when calling lru_add_drain[_all]() on a large folio.

But although there is good reason not to batch up PMD-sized folios, we
might well benefit from batching a small number of low-order mTHPs (though
unclear how that "small number" limitation will be implemented).

So ask if folio_may_be_lru_cached() rather than !folio_test_large(), to
insulate those particular checks from future change.  Name preferred to
"folio_is_batchable" because large folios can well be put on a batch: it's
just the per-CPU LRU caches, drained much later, which need care.

Marked for stable, to counter the increase in lru_add_drain_all()s from
"mm/gup: check ref_count instead of lru before migration".

Link: https://lkml.kernel.org/r/57d2eaf8-3607-f318-e0c5-be02dce61ad0@google.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Resolved conflicts in mm/swap.c ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swap.h | 10 ++++++++++
 mm/gup.c             |  4 ++--
 mm/mlock.c           |  6 +++---
 mm/swap.c            |  4 ++--
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index cb25db2a93dd1..d7a5b7817987d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -375,6 +375,16 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
+static inline bool folio_may_be_lru_cached(struct folio *folio)
+{
+	/*
+	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
+	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
+	 * will be sensible, but nobody has implemented and tested that yet.
+	 */
+	return !folio_test_large(folio);
+}
+
 extern atomic_t lru_disable_count;
 
 static inline bool lru_cache_disabled(void)
diff --git a/mm/gup.c b/mm/gup.c
index 5be764395e046..53154b63295ab 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1975,13 +1975,13 @@ static unsigned long collect_longterm_unpinnable_pages(
 			continue;
 		}
 
-		if (drained == 0 &&
+		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain();
 			drained = 1;
 		}
-		if (drained == 1 &&
+		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
diff --git a/mm/mlock.c b/mm/mlock.c
index 06bdfab83b58a..6858095c20dd9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -256,7 +256,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -279,7 +279,7 @@ void mlock_new_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -300,7 +300,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
diff --git a/mm/swap.c b/mm/swap.c
index 42082eba42de3..8fde1a27aa482 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -220,8 +220,8 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 static void folio_batch_add_and_move(struct folio_batch *fbatch,
 		struct folio *folio, move_fn_t move_fn)
 {
-	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
-	    !lru_cache_disabled())
+	if (folio_batch_add(fbatch, folio) &&
+	    folio_may_be_lru_cached(folio) && !lru_cache_disabled())
 		return;
 	folio_batch_move_lru(fbatch, move_fn);
 }
-- 
2.51.0



