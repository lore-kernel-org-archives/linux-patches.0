Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06016391E74;
	Sat, 17 Oct 2026 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254837; cv=none; b=o9xWwj7ZZXhU9wkQEBfNutW12eqBvoD37WlIKwGXLiCBg1ssMzzbNCWoQreGXfR5+xBRfy3xjJsKZN2UQtuu55nmBNgNFTZRRdLUE/VaMHMyrKE3gBULDWkg2izy3vg0fV9eR8MAWG9MX2ayiwUi4QINteiBjczo6DIUY8uGfKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254837; c=relaxed/simple;
	bh=ow08GWSaOiCRg59h/+Q14giVPdfQo3fMW6PtiGYKnZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3tPU9U0ozYMvgmyEk0dncxfQZM2NkF1SFfqoxUOna1SttvT2vFvKHlz09sVrOn5ILjf0WLnXOgi5zI34VU+50eTGUUSeHvx1s/JK/A9Eq7JrCRqMuBsuw6+xdvCqd+Maheer1Wbf+KeOtpnQWuRY55KBfwMiaY8DeCN/6EysWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8dAVztO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8dAVztO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C21F000C4;
	Sat, 17 Oct 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254835;
	bh=tP0hpah/mOLjACinjmcA5ELppgMeHX0t02ob2Dj631Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8dAVztOoCFfX32jpIP8tvaBKW8Tb45Hue9JC5ZoMq2qhPW3TGx+9AoW7P7FmR7fQ
	 knnVw4pqQUUf+7dk1ubtR+Bnd8H4wGe+OPVgth3MlsewF5xHmxbAobYrDBk7uT1iPd
	 203safbO5siEkWgiFBQkHFbJSQr875dPgricOLZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brian Geffon <bgeffon@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Barrett <steven@liquorix.net>,
	Suleiman Souhlal <suleiman@google.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/869] mm/mglru: fix and remove redundant unevictable folio handling
Date: Sat, 17 Oct 2026 17:56:59 +0200
Message-ID: <20261017160051.880426962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

[ Upstream commit f7e698e326b239a91ea15844817551921209e826 ]

sort_folio() has a shortcut for moving folios that are no longer evictable
but are still sitting on a generation list.  However, this shortcut is
buggy.  It does not follow the PG_lru usage convention, and it has a more
serious issue.

Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
folio->lru can be reused to hold folio->mlock_count (see the comment in
lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
and every other place that turns a folio unevictable initialises
mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
__mlock_new_folio() set it to !!folio_test_mlocked(folio).  sort_folio()
sets nothing, and the lru_gen_del_folio() right above it may have already
poisoned folio->lru via list_del(), so mlock_count ends up aliasing
LIST_POISON2, which reads as 0x122, i.e.  290.  The result is user
visible.  On munlock, __munlock_folio() decrements that bogus count, finds
it still non-zero and bails out before clearing PG_mlocked, so the folio
remains unevictable and the Mlocked accounting stays inflated until the
folio is freed.

The shortcut also touches the LRU flags in the wrong order.  It calls
lru_gen_del_folio() while PG_lru is still set, so a concurrent
folio_test_clear_lru() (e.g.  compaction, folio_isolate_lru()) can succeed
on a folio that has already been taken off the generation list, which may
lead to unexpected behavior.

So fix it by isolating them as common folios and letting the generic
shrink path cull them.  This matches the classical LRU behavior, and there
should be no visible effect on the generic eviction or isolation behavior.

There is no performance concern either, such a folio goes through this
once, and then it is off the generation lists for good.

Link: https://lore.kernel.org/20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ec19d061232e7..f9b5fbd072db5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4312,7 +4312,6 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
 		       int tier_idx)
 {
-	bool success;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4323,15 +4322,9 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
 
-	/* unevictable */
-	if (!folio_evictable(folio)) {
-		success = lru_gen_del_folio(lruvec, folio, true);
-		VM_WARN_ON_ONCE_FOLIO(!success, folio);
-		folio_set_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
-		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
-		return true;
-	}
+	/* unevictable: let it through and the generic path will cull it */
+	if (!folio_evictable(folio))
+		return false;
 
 	/* promoted */
 	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
@@ -4609,11 +4602,9 @@ static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swap
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		if (!folio_evictable(folio)) {
-			list_del(&folio->lru);
-			folio_putback_lru(folio);
+		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
+		if (!folio_evictable(folio))
 			continue;
-		}
 
 		if (folio_test_reclaim(folio) &&
 		    (folio_test_dirty(folio) || folio_test_writeback(folio))) {
-- 
2.53.0



