Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B21A76A4;
	Tue, 30 Jul 2024 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359827; cv=none; b=WQC+b7bk9k870u/W9yWs18V5CFZpzdc6cTD6jrH1ZqvW97JoIl6SkrWVpyfyIpD/kmNHphhXrjkxHpaH5DhVdoTdzCb2kjH7srdWKV9IBJgETeEk7ft7KFQ75wlXyOlByAZKZ7Gu8vppTc4vimvN6Lvg1Y+8L58gvG/znJOhPXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359827; c=relaxed/simple;
	bh=iO+utqeh730UegHmswBH0X8/N7gBIvgTDfYEmX1SZuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a47KB1GJ1xOzmAUUrdf/vKb/EDK5liMiUJ0RAVI/v3maQTWJEMXp4GOOC8NTk+kjt43+JUmY/8CiGg0WVZQDuMRWAhKl/P7uTkn2Rr8BvOjIZxh2yTGDBn6PAcETt7ziObc2cnJWI+sQnZGjifchdY9W6MeQ6/pkSo1GvWwCDVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlSr++BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlSr++BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CBFC32782;
	Tue, 30 Jul 2024 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359827;
	bh=iO+utqeh730UegHmswBH0X8/N7gBIvgTDfYEmX1SZuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlSr++BTmYSvo+va4InJBcu6ivoGIPHmfbE8HsLeRZ6/8KKgL3jXn0JagnPAFduUp
	 ruVMgHkGz5wnRrNbboyM8lbuTD8UvXF78OyA7zZvQtciNbuX6Aq5hIbKsRrBGKhL5C
	 3ZovUn12qDXX8zuyIQJTIuD1a6YOvFAw969Ugxn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 541/809] mm/mglru: fix ineffective protection calculation
Date: Tue, 30 Jul 2024 17:46:57 +0200
Message-ID: <20240730151746.115205573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

commit 30d77b7eef019fa4422980806e8b7cdc8674493e upstream.

mem_cgroup_calculate_protection() is not stateless and should only be used
as part of a top-down tree traversal.  shrink_one() traverses the per-node
memcg LRU instead of the root_mem_cgroup tree, and therefore it should not
call mem_cgroup_calculate_protection().

The existing misuse in shrink_one() can cause ineffective protection of
sub-trees that are grandchildren of root_mem_cgroup.  Fix it by reusing
lru_gen_age_node(), which already traverses the root_mem_cgroup tree, to
calculate the protection.

Previously lru_gen_age_node() opportunistically skips the first pass,
i.e., when scan_control->priority is DEF_PRIORITY.  On the second pass,
lruvec_is_sizable() uses appropriate scan_control->priority, set by
set_initial_priority() from lru_gen_shrink_node(), to decide whether a
memcg is too small to reclaim from.

Now lru_gen_age_node() unconditionally traverses the root_mem_cgroup tree.
So it should call set_initial_priority() upfront, to make sure
lruvec_is_sizable() uses appropriate scan_control->priority on the first
pass.  Otherwise, lruvec_is_reclaimable() can return false negatives and
result in premature OOM kills when min_ttl_ms is used.

Link: https://lkml.kernel.org/r/20240712232956.1427127-1-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: T.J. Mercier <tjmercier@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   82 +++++++++++++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3900,6 +3900,32 @@ done:
  *                          working set protection
  ******************************************************************************/
 
+static void set_initial_priority(struct pglist_data *pgdat, struct scan_control *sc)
+{
+	int priority;
+	unsigned long reclaimable;
+
+	if (sc->priority != DEF_PRIORITY || sc->nr_to_reclaim < MIN_LRU_BATCH)
+		return;
+	/*
+	 * Determine the initial priority based on
+	 * (total >> priority) * reclaimed_to_scanned_ratio = nr_to_reclaim,
+	 * where reclaimed_to_scanned_ratio = inactive / total.
+	 */
+	reclaimable = node_page_state(pgdat, NR_INACTIVE_FILE);
+	if (can_reclaim_anon_pages(NULL, pgdat->node_id, sc))
+		reclaimable += node_page_state(pgdat, NR_INACTIVE_ANON);
+
+	/* round down reclaimable and round up sc->nr_to_reclaim */
+	priority = fls_long(reclaimable) - 1 - fls_long(sc->nr_to_reclaim - 1);
+
+	/*
+	 * The estimation is based on LRU pages only, so cap it to prevent
+	 * overshoots of shrinker objects by large margins.
+	 */
+	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
+}
+
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int gen, type, zone;
@@ -3933,19 +3959,17 @@ static bool lruvec_is_reclaimable(struct
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	/* see the comment on lru_gen_folio */
-	gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
-	birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
-
-	if (time_is_after_jiffies(birth + min_ttl))
+	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
 	if (!lruvec_is_sizable(lruvec, sc))
 		return false;
 
-	mem_cgroup_calculate_protection(NULL, memcg);
+	/* see the comment on lru_gen_folio */
+	gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
+	birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
-	return !mem_cgroup_below_min(NULL, memcg);
+	return time_is_before_jiffies(birth + min_ttl);
 }
 
 /* to protect the working set of the last N jiffies */
@@ -3955,23 +3979,20 @@ static void lru_gen_age_node(struct pgli
 {
 	struct mem_cgroup *memcg;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
+	bool reclaimable = !min_ttl;
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
-	/* check the order to exclude compaction-induced reclaim */
-	if (!min_ttl || sc->order || sc->priority == DEF_PRIORITY)
-		return;
+	set_initial_priority(pgdat, sc);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		if (lruvec_is_reclaimable(lruvec, sc, min_ttl)) {
-			mem_cgroup_iter_break(NULL, memcg);
-			return;
-		}
+		mem_cgroup_calculate_protection(NULL, memcg);
 
-		cond_resched();
+		if (!reclaimable)
+			reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
 	/*
@@ -3979,7 +4000,7 @@ static void lru_gen_age_node(struct pgli
 	 * younger than min_ttl. However, another possibility is all memcgs are
 	 * either too small or below min.
 	 */
-	if (mutex_trylock(&oom_lock)) {
+	if (!reclaimable && mutex_trylock(&oom_lock)) {
 		struct oom_control oc = {
 			.gfp_mask = sc->gfp_mask,
 		};
@@ -4771,8 +4792,7 @@ static int shrink_one(struct lruvec *lru
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	mem_cgroup_calculate_protection(NULL, memcg);
-
+	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
@@ -4896,32 +4916,6 @@ static void lru_gen_shrink_lruvec(struct
 	blk_finish_plug(&plug);
 }
 
-static void set_initial_priority(struct pglist_data *pgdat, struct scan_control *sc)
-{
-	int priority;
-	unsigned long reclaimable;
-
-	if (sc->priority != DEF_PRIORITY || sc->nr_to_reclaim < MIN_LRU_BATCH)
-		return;
-	/*
-	 * Determine the initial priority based on
-	 * (total >> priority) * reclaimed_to_scanned_ratio = nr_to_reclaim,
-	 * where reclaimed_to_scanned_ratio = inactive / total.
-	 */
-	reclaimable = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (can_reclaim_anon_pages(NULL, pgdat->node_id, sc))
-		reclaimable += node_page_state(pgdat, NR_INACTIVE_ANON);
-
-	/* round down reclaimable and round up sc->nr_to_reclaim */
-	priority = fls_long(reclaimable) - 1 - fls_long(sc->nr_to_reclaim - 1);
-
-	/*
-	 * The estimation is based on LRU pages only, so cap it to prevent
-	 * overshoots of shrinker objects by large margins.
-	 */
-	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
-}
-
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct blk_plug plug;


