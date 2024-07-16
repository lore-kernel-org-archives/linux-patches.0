Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181E719DFB3;
	Tue, 16 Jul 2024 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145074; cv=none; b=go/bfzWTR07QPrBDqDHWDcs0eW33Rl+6cn6UUdj2enTNHSqNgRle6qpzBpR68HjP//mJ5c4cy6uTD0suxe1BBW0PYYjAmid8g+C0pC5gz3FFIGF8zH2q1PCXDyUbUaHa+bgYBnazHtAqYVRtGc08b4bxVQWQ5EBM7W2OzTJNGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145074; c=relaxed/simple;
	bh=P8yUMUdYJo5yQzSVmJJyj0B29X2igIf6xMOifHR9P4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qeom1IeEDnuFcX7bKOu8c5qZoos/GN3lNQ1ypjmiJCdKqFu5SeuZ5gyawCtQ1Gsp+v34BNp8pGsSwFbgfoqO45RasDSSIUBnpko8BYXzhwfkmuEVJJiiKJOOsvvBNLWZfUiTq640TjB/H7F1G/9gSeDxWtIO8FFrERDjflJBivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fghS3DVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fghS3DVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DFDC4AF0D;
	Tue, 16 Jul 2024 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145074;
	bh=P8yUMUdYJo5yQzSVmJJyj0B29X2igIf6xMOifHR9P4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fghS3DVhmZ7ETg9it9vyZEraAvM7jznKIe/OAGtvlP/2YIxHa0YRlTh0UbsbJy1t1
	 NziY44xjQEC4tyRI+sdEZAPZyoxbwr5dK29soElsotRincEmJ9zxgLlQhRB2DIPakc
	 bhWLP1FlWGNYjIROaxTu23VvEzyW7zUBbNtFNMps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 088/143] mm: fix crashes from deferred split racing folio migration
Date: Tue, 16 Jul 2024 17:31:24 +0200
Message-ID: <20240716152759.360945987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit be9581ea8c058d81154251cb0695987098996cad upstream.

Even on 6.10-rc6, I've been seeing elusive "Bad page state"s (often on
flags when freeing, yet the flags shown are not bad: PG_locked had been
set and cleared??), and VM_BUG_ON_PAGE(page_ref_count(page) == 0)s from
deferred_split_scan()'s folio_put(), and a variety of other BUG and WARN
symptoms implying double free by deferred split and large folio migration.

6.7 commit 9bcef5973e31 ("mm: memcg: fix split queue list crash when large
folio migration") was right to fix the memcg-dependent locking broken in
85ce2c517ade ("memcontrol: only transfer the memcg data for migration"),
but missed a subtlety of deferred_split_scan(): it moves folios to its own
local list to work on them without split_queue_lock, during which time
folio->_deferred_list is not empty, but even the "right" lock does nothing
to secure the folio and the list it is on.

Fortunately, deferred_split_scan() is careful to use folio_try_get(): so
folio_migrate_mapping() can avoid the race by folio_undo_large_rmappable()
while the old folio's reference count is temporarily frozen to 0 - adding
such a freeze in the !mapping case too (originally, folio lock and
unmapping and no swap cache left an anon folio unreachable, so no freezing
was needed there: but the deferred split queue offers a way to reach it).

Link: https://lkml.kernel.org/r/29c83d1a-11ca-b6c9-f92e-6ccb322af510@google.com
Fixes: 9bcef5973e31 ("mm: memcg: fix split queue list crash when large folio migration")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   11 -----------
 mm/migrate.c    |   13 +++++++++++++
 2 files changed, 13 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7609,17 +7609,6 @@ void mem_cgroup_migrate(struct folio *ol
 
 	/* Transfer the charge and the css ref */
 	commit_charge(new, memcg);
-	/*
-	 * If the old folio is a large folio and is in the split queue, it needs
-	 * to be removed from the split queue now, in case getting an incorrect
-	 * split queue in destroy_large_folio() after the memcg of the old folio
-	 * is cleared.
-	 *
-	 * In addition, the old folio is about to be freed after migration, so
-	 * removing from the split queue a bit earlier seems reasonable.
-	 */
-	if (folio_test_large(old) && folio_test_large_rmappable(old))
-		folio_undo_large_rmappable(old);
 	old->memcg_data = 0;
 }
 
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -415,6 +415,15 @@ int folio_migrate_mapping(struct address
 		if (folio_ref_count(folio) != expected_count)
 			return -EAGAIN;
 
+		/* Take off deferred split queue while frozen and memcg set */
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio)) {
+			if (!folio_ref_freeze(folio, expected_count))
+				return -EAGAIN;
+			folio_undo_large_rmappable(folio);
+			folio_ref_unfreeze(folio, expected_count);
+		}
+
 		/* No turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
@@ -433,6 +442,10 @@ int folio_migrate_mapping(struct address
 		return -EAGAIN;
 	}
 
+	/* Take off deferred split queue while frozen and memcg set */
+	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
+		folio_undo_large_rmappable(folio);
+
 	/*
 	 * Now we know that no one else is looking at the folio:
 	 * no turning back from here.


