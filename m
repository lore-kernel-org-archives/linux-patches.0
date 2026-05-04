Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249FB3AA4F8;
	Mon,  4 May 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903727; cv=none; b=s9VghA436H/6lNuElclEg/L2hAMAjWIqrXDVki+ZY9qeKfF/YNLFUtS/hSwu3Wvr9AX/8iHEm7QIolYRLQOlZdj/Ab6Wu2yLHMdOD08Vu+RL9CwvertdO2fGnk4GsBRRM1xGL6O9z4U4UA0iIu18NVtcOBYawel0Aio2E8i4z6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903727; c=relaxed/simple;
	bh=r+pK5X5zhBNa1YkXObym8LaNbRRnBqDaLuxek8zu6ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3ygvq3rR/SdgW6yNB6mTUXHewUNjudmNNlccqYt9YDA4E6T/7hf1IisPCfbeqpK+1yGgj6DRY/vW55yFWzw3f0Pwn9gkj52NaW+p2NY11ZJg5oE2V6ZG/qGWrCo27UJ6fp1AjXJaNDCg3RRnL7P0RLjfn5CZg2xAC5jn2jB0NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1TLA1gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1TLA1gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD63C2BCB8;
	Mon,  4 May 2026 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903727;
	bh=r+pK5X5zhBNa1YkXObym8LaNbRRnBqDaLuxek8zu6ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1TLA1gZmC0i3yqeHA3xWtKz8+GaP4/cPo9FpJsDuUu0IriQgS6ERjVo5IqMwK/M6
	 9iRghnJkTdLNjaiUReqEioRh3S/x98cbhfOsDWrhZSBb/0k9QLgOESY+jSNt1n8IYI
	 YByRWyusntg9IWaaVGgd/Jgt3pqXR6jXIArdlImM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/275] mm: call ->free_folio() directly in folio_unmap_invalidate()
Date: Mon,  4 May 2026 15:49:38 +0200
Message-ID: <20260504135144.353831543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 615d9bb2ccad42f9e21d837431e401db2e471195 upstream.

We can only call filemap_free_folio() if we have a reference to (or hold a
lock on) the mapping.  Otherwise, we've already removed the folio from the
mapping so it no longer pins the mapping and the mapping can be removed,
causing a use-after-free when accessing mapping->a_ops.

Follow the same pattern as __remove_mapping() and load the free_folio
function pointer before dropping the lock on the mapping.  That lets us
make filemap_free_folio() static as this was the only caller outside
filemap.c.

Link: https://lore.kernel.org/20260413184314.3419945-1-willy@infradead.org
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c  | 3 ++-
 mm/internal.h | 1 -
 mm/truncate.c | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 91dcfe14a67b7..e3339cf37a1f0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -227,7 +227,8 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
 	page_cache_delete(mapping, folio, shadow);
 }
 
-void filemap_free_folio(struct address_space *mapping, struct folio *folio)
+static void filemap_free_folio(const struct address_space *mapping,
+		struct folio *folio)
 {
 	void (*free_folio)(struct folio *);
 
diff --git a/mm/internal.h b/mm/internal.h
index c80c6f566c2d9..4cf6a12ff491d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -471,7 +471,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
-void filemap_free_folio(struct address_space *mapping, struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
diff --git a/mm/truncate.c b/mm/truncate.c
index 3c5a50ae32741..4bf64fd610c94 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -622,6 +622,7 @@ static int folio_launder(struct address_space *mapping, struct folio *folio)
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp)
 {
+	void (*free_folio)(struct folio *);
 	int ret;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -648,9 +649,12 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_add_lru(mapping->host);
+	free_folio = mapping->a_ops->free_folio;
 	spin_unlock(&mapping->host->i_lock);
 
-	filemap_free_folio(mapping, folio);
+	if (free_folio)
+		free_folio(folio);
+	folio_put_refs(folio, folio_nr_pages(folio));
 	return 1;
 failed:
 	xa_unlock_irq(&mapping->i_pages);
-- 
2.53.0



