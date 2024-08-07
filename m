Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BD3EA9A;
	Wed,  7 Aug 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042946; cv=none; b=n48bdNS09L9kdC5C0FkUPDziX5XaabmLUl+klSnVKaU/xW7ihIyi7asRwCJOwenTAVltdCv21WrG0gOm3waSMDlsoyoDJfqc1PnQdnB5b/E15/SfNi5hwg4SxWiAw/Cpx0yB2bjBxtVMxtRc68j3i6r0rCBfOTxezzOaDhQ0XvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042946; c=relaxed/simple;
	bh=ss82xnj7NoP5gYbKurZCxHHz1V4jBKYqiuoEASDnR/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RENnu3iNhucGNy7UAP9EpDah6AL/UlfcD4A0/vRlzql6os+3el8z7y4CvfseEDc4DtgyMSQKKJClDREX5kGbYXBlCPBs3TxmbB1LaCBAJh+oDlxk8lxCmoL03pxga3j7UueUV76SKGuISrg15H3KTXPtrY9nNFIzsSvmne9vD7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pJFvxbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pJFvxbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78717C32781;
	Wed,  7 Aug 2024 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042945;
	bh=ss82xnj7NoP5gYbKurZCxHHz1V4jBKYqiuoEASDnR/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pJFvxboN/Fk+w5JyAdGKphIqajahkiASI9hRtSosgV0a9THQAfPD/2eTFr0bbgb9
	 fcwZ1CcM9W8J+prk7IX55zxlf0ECh7+dJNIZ2acR9OB/o7VLekpTvl6QIyBtYqoRqV
	 ODHPzDb4dLe6/phiQ+I6NBVZqHn6cZJ4DDi7js4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yang Shi <shy828301@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Huang Ying <ying.huang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 005/123] mm/migrate: putback split folios when numa hint migration fails
Date: Wed,  7 Aug 2024 16:58:44 +0200
Message-ID: <20240807150020.986774419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 6e49019db5f7a09a9c0e8ac4d108e656c3f8e583 ]

This issue is not from any report yet, but by code observation only.

This is yet another fix besides Hugh's patch [1] but on relevant code
path, where eager split of folio can happen if the folio is already on
deferred list during a folio migration.

Here the issue is NUMA path (migrate_misplaced_folio()) may start to
encounter such folio split now even with MR_NUMA_MISPLACED hint applied.
Then when migrate_pages() didn't migrate all the folios, it's possible the
split small folios be put onto the list instead of the original folio.
Then putting back only the head page won't be enough.

Fix it by putting back all the folios on the list.

[1] https://lore.kernel.org/all/46c948b4-4dd8-6e03-4c7b-ce4e81cfa536@google.com/

[akpm@linux-foundation.org: remove now unused local `nr_pages']
Link: https://lkml.kernel.org/r/20240708215537.2630610-1-peterx@redhat.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 6b5affe49cf91..9dabeb90f772d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2634,20 +2634,13 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
-	int nr_pages = folio_nr_pages(folio);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
 				     NULL, node, MIGRATE_ASYNC,
 				     MR_NUMA_MISPLACED, &nr_succeeded);
-	if (nr_remaining) {
-		if (!list_empty(&migratepages)) {
-			list_del(&folio->lru);
-			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
-					folio_is_file_lru(folio), -nr_pages);
-			folio_putback_lru(folio);
-		}
-	}
+	if (nr_remaining && !list_empty(&migratepages))
+		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
-- 
2.43.0



