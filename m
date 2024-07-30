Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976ED18B467;
	Tue, 30 Jul 2024 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359624; cv=none; b=U9q0ZvEYOxStIFcVB59cmoZF622WV7vS8XOO7Lvl4BLOVrQQAB9lgxuhtA+RusDkgq8Jp1XyUGIr1g01CMte/kJe985/jGTV3QXVroMPm0V6yCcnEVy845GSUIPPl09u1w7xS7cUr1MFEntUNMw9XV9FS5GoSz5vnHgONprDOTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359624; c=relaxed/simple;
	bh=hvssmeq/E8WYTVjPrClADq9GrQC9Wa0MkIHDJSGli5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A64qS5tPTh8Lq5EAOV3u5FS1Rcf0jCE0oLYqWXgQMNBbirtRJ2awNfIrqY0MolTs2YaPVFm6qQSy07OE4nj6uJBnTOdI2wVQkRaHyT/f7Wy/5ymdEOWM7zMQk/SkJZY01qUHSMsNWZctbJqDnAta3Zl7VP3rE9nNayI8IWqw2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9Rx3T3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9Rx3T3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A5AC32782;
	Tue, 30 Jul 2024 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359624;
	bh=hvssmeq/E8WYTVjPrClADq9GrQC9Wa0MkIHDJSGli5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9Rx3T3Mbnwp4OwCepHG5uxi00Bb9XuMdD2AffhYc2OhmCmf6jXglY8p31L1qPhbQ
	 DdAOWBOKZhQ4xrP8oHN0QWuHoJ2PO8z6BBm0lNbXOLCudAahNLnwG7JP0qt7NLB3Te
	 bpvvicvLp/4w6Ligktg2DDsBQZepvR2LCY/ZHwVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 510/568] mm/mglru: fix ineffective protection calculation
Date: Tue, 30 Jul 2024 17:50:17 +0200
Message-ID: <20240730151659.957340658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
 mm/vmscan.c |   83 +++++++++++++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 45 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4546,6 +4546,32 @@ done:
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
@@ -4579,19 +4605,17 @@ static bool lruvec_is_reclaimable(struct
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
@@ -4601,23 +4625,20 @@ static void lru_gen_age_node(struct pgli
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
@@ -4625,7 +4646,7 @@ static void lru_gen_age_node(struct pgli
 	 * younger than min_ttl. However, another possibility is all memcgs are
 	 * either too small or below min.
 	 */
-	if (mutex_trylock(&oom_lock)) {
+	if (!reclaimable && mutex_trylock(&oom_lock)) {
 		struct oom_control oc = {
 			.gfp_mask = sc->gfp_mask,
 		};
@@ -5424,8 +5445,7 @@ static int shrink_one(struct lruvec *lru
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	mem_cgroup_calculate_protection(NULL, memcg);
-
+	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
@@ -5565,33 +5585,6 @@ static void lru_gen_shrink_lruvec(struct
 
 #endif
 
-static void set_initial_priority(struct pglist_data *pgdat, struct scan_control *sc)
-{
-	int priority;
-	unsigned long reclaimable;
-	struct lruvec *lruvec = mem_cgroup_lruvec(NULL, pgdat);
-
-	if (sc->priority != DEF_PRIORITY || sc->nr_to_reclaim < MIN_LRU_BATCH)
-		return;
-	/*
-	 * Determine the initial priority based on
-	 * (total >> priority) * reclaimed_to_scanned_ratio = nr_to_reclaim,
-	 * where reclaimed_to_scanned_ratio = inactive / total.
-	 */
-	reclaimable = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (get_swappiness(lruvec, sc))
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


