Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CAB3A63EC;
	Mon,  4 May 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902953; cv=none; b=M9Ci1sTue8lSF+pFtgCl6jEnDWyE/K+9LVWnVqZ1X053TypuzeKowdcg1WOsSYf3G3y970RIcxqOcDoA5CEY9nXfu0SyslZQHtBvk0CDMv/9+NuD346SJ9ZwfxZ0+cJX53aTlZRVqbLPquN5EfMO5PE9xNoYaFrek3nWULYmAIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902953; c=relaxed/simple;
	bh=h15FefVmHTszHNHAZI+xRAVvnDO+Bgk9GxHB6kccmIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2pHhFsaG1AlnMuWlGPdlGhXMp8Md5l91aFjoimhBCv6faV0ShmDzrXzMEtZoJvsc9Go/wdxUizAiOtJiM3ubf+gDIaLsFImPD1Iu1s9VtNkgzeJ8FqhbbMJtwfuiZCdrpcPNCB6wO4DJCXyzVx0QwvgSbbium7e0Gd5TmQlCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGS0UcuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGS0UcuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC119C2BCB8;
	Mon,  4 May 2026 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902953;
	bh=h15FefVmHTszHNHAZI+xRAVvnDO+Bgk9GxHB6kccmIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGS0UcuAP5W+I/aa5mll+ddqBJj8uJjp2UjF7ItYocEW4/mfWcQh5lMQa7gXuR8ai
	 tVUNnGHoLtdrECd8Pe1yHgj7FtMdUdb5VqZLCFx7W/ChhOeWNK3/g78fts5zrm8i7m
	 ZFDizg/Qnq/N9vV7n4c0NMJ/iTCBI9RFE87yBAOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Yang <lance.yang@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Nico Pache <npache@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 029/307] mm: fix deferred split queue races during migration
Date: Mon,  4 May 2026 15:48:34 +0200
Message-ID: <20260504135143.929287175@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

commit 3bac01168982ec3e3bf87efdc1807c7933590a85 upstream.

migrate_folio_move() records the deferred split queue state from src and
replays it on dst.  Replaying it after remove_migration_ptes(src, dst, 0)
makes dst visible before it is requeued, so a concurrent rmap-removal path
can mark dst partially mapped and trip the WARN in deferred_split_folio().

Move the requeue before remove_migration_ptes() so dst is back on the
deferred split queue before it becomes visible again.

Because migration still holds dst locked at that point, teach
deferred_split_scan() to requeue a folio when folio_trylock() fails.
Otherwise a fully mapped underused folio can be dequeued by the shrinker
and silently lost from split_queue.

[ziy@nvidia.com: move the comment]
  Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
Link: https://lkml.kernel.org/r/20260401131032.13011-1-lance.yang@linux.dev
Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   15 ++++++++++-----
 mm/migrate.c     |   18 +++++++++---------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4456,7 +4456,7 @@ retry:
 				goto next;
 		}
 		if (!folio_trylock(folio))
-			goto next;
+			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
 			if (underused)
@@ -4465,13 +4465,18 @@ retry:
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
+requeue:
 		/*
-		 * Only add back to the queue if folio is partially mapped.
-		 * If thp_underused returns false, or if split_folio fails
-		 * in the case it was underused, then consider it used and
-		 * don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1384,6 +1384,15 @@ static int migrate_folio_move(free_folio
 		goto out;
 
 	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
+	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
 	 * automatically build up the correct dst->mlock_count for it.
@@ -1399,15 +1408,6 @@ static int migrate_folio_move(free_folio
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-	/*
-	 * Requeue the destination folio on the deferred split queue if
-	 * the source was on the queue.  The source is unqueued in
-	 * __folio_migrate_mapping(), so we recorded the state from
-	 * before move_to_new_folio().
-	 */
-	if (src_deferred_split)
-		deferred_split_folio(dst, src_partially_mapped);
-
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);


