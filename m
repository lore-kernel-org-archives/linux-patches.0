Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7DC1C7D6E;
	Thu,  6 Jun 2024 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683702; cv=none; b=dqkL1W+2agNJqGOyQTIlNAuU2d2gEZ6ztRLsejX5xRl3BcSEJQ+qMSUfqYO/vrvDNrkwdBeyetPtLbXBEavT1yx/EXkq5iJjrXk063Ojbw/NZgEb4oo4BMemBcaeSgrqSNwRIWogWwSbYCQVZl/oUxdIxc84ZQYXHm3IFc7A6iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683702; c=relaxed/simple;
	bh=a0ZgA15c9VkQ+JhXorJC/Emgzj+SsDtZ4K9XwM9r+rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYrYwidWNDdc8gbjSKEiRX1YvpMk900DFXJg3+qEqRWmdgrxKCYZgOpgt1P7HhmCLBmm4EhOg8+joyoWloqpCZIihylUPkvAFIJeMaZQE385rwgLgk9IaJpfUlprt2DDTRGFlObBDOaYi2HxDmXNHL86jeMOe2eYKINFtnQGGNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL3fF42j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL3fF42j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC0BC2BD10;
	Thu,  6 Jun 2024 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683702;
	bh=a0ZgA15c9VkQ+JhXorJC/Emgzj+SsDtZ4K9XwM9r+rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL3fF42jGDphFszBynt9LXThXs4f86BeNx0u8TvlJMb8kShbvTYIKGlkQwKT9HDLM
	 hMaKiFwoQTmb/KjYAyvFg/SAzPQTnfI3j944J42cve1yZ7KPeqpGidzNM4J5rSRWIf
	 sMp4uv30yNbdCeA4glKBtBtLRneTdpdbhZtwnYt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 626/744] blk-cgroup: fix list corruption from resetting io stat
Date: Thu,  6 Jun 2024 16:04:58 +0200
Message-ID: <20240606131752.569619476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 6da6680632792709cecf2b006f2fe3ca7857e791 ]

Since commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
each iostat instance is added to blkcg percpu list, so blkcg_reset_stats()
can't reset the stat instance by memset(), otherwise the llist may be
corrupted.

Fix the issue by only resetting the counter part.

Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Jay Shin <jaeshin@redhat.com>
Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20240515013157.443672-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 58 ++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4c49a70b46bd1..9359b57545d22 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -619,12 +619,45 @@ static void blkg_destroy_all(struct gendisk *disk)
 	spin_unlock_irq(&q->queue_lock);
 }
 
+static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
+{
+	int i;
+
+	for (i = 0; i < BLKG_IOSTAT_NR; i++) {
+		dst->bytes[i] = src->bytes[i];
+		dst->ios[i] = src->ios[i];
+	}
+}
+
+static void __blkg_clear_stat(struct blkg_iostat_set *bis)
+{
+	struct blkg_iostat cur = {0};
+	unsigned long flags;
+
+	flags = u64_stats_update_begin_irqsave(&bis->sync);
+	blkg_iostat_set(&bis->cur, &cur);
+	blkg_iostat_set(&bis->last, &cur);
+	u64_stats_update_end_irqrestore(&bis->sync, flags);
+}
+
+static void blkg_clear_stat(struct blkcg_gq *blkg)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct blkg_iostat_set *s = per_cpu_ptr(blkg->iostat_cpu, cpu);
+
+		__blkg_clear_stat(s);
+	}
+	__blkg_clear_stat(&blkg->iostat);
+}
+
 static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 			     struct cftype *cftype, u64 val)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
 	struct blkcg_gq *blkg;
-	int i, cpu;
+	int i;
 
 	mutex_lock(&blkcg_pol_mutex);
 	spin_lock_irq(&blkcg->lock);
@@ -635,18 +668,7 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 	 * anyway.  If you get hit by a race, retry.
 	 */
 	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
-		for_each_possible_cpu(cpu) {
-			struct blkg_iostat_set *bis =
-				per_cpu_ptr(blkg->iostat_cpu, cpu);
-			memset(bis, 0, sizeof(*bis));
-
-			/* Re-initialize the cleared blkg_iostat_set */
-			u64_stats_init(&bis->sync);
-			bis->blkg = blkg;
-		}
-		memset(&blkg->iostat, 0, sizeof(blkg->iostat));
-		u64_stats_init(&blkg->iostat.sync);
-
+		blkg_clear_stat(blkg);
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
@@ -949,16 +971,6 @@ void blkg_conf_exit(struct blkg_conf_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(blkg_conf_exit);
 
-static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
-{
-	int i;
-
-	for (i = 0; i < BLKG_IOSTAT_NR; i++) {
-		dst->bytes[i] = src->bytes[i];
-		dst->ios[i] = src->ios[i];
-	}
-}
-
 static void blkg_iostat_add(struct blkg_iostat *dst, struct blkg_iostat *src)
 {
 	int i;
-- 
2.43.0



