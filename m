Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA9519885D;
	Thu,  6 Jun 2024 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683041; cv=none; b=BAHzRVISXS2QU1XUSi/zPj4cSEOcGXfxfevdfiZNzeMxuXYiShycGB7NVTzo0QK7dezdQ/ChFr4X89rlLpyZxvMQYyOylPwHfX/oOA5WjSvUXIaHo/47YMUQkoJ81ViVkro/vxIa/OrVL1178pV6zQk5HPtkvon+87SwuKlzl78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683041; c=relaxed/simple;
	bh=pxu20ylrbxEJixeGMaFyP/lFuwdlQhOLRbiKvoxMihw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr3G4UPU0LItvAC7fi48baN3rfX5UuoM60tDRelv7OEARJsOsn7HyD0D951RznneIKGf+8KlynqcxqvxSJc0wPUv8fhiXrQTiPQy/79c46S5DtLXyuq6g/zUBRKv2N7Fd2kL4AsEIp9RpDJF0WkiM0WnIuY2lIbUNfpFDBD/cYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd0EdY6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd0EdY6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC88CC32782;
	Thu,  6 Jun 2024 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683041;
	bh=pxu20ylrbxEJixeGMaFyP/lFuwdlQhOLRbiKvoxMihw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd0EdY6E27fc7BJdPlndPQbOM0esQFUclCY7yDCLpIcC4sKVAAAEqxlmxTRiXWQiJ
	 AsQMy8e96bQ+XUQAYCCMBDu0ddQTQGZURavYfOc60lc3TgsNavNCtrPYqOU2RGhcj0
	 ulhM68/Dp8NdX2VUKxRDccnLieScPTIa7HKQmWEQ=
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
Subject: [PATCH 6.9 225/374] blk-cgroup: fix list corruption from resetting io stat
Date: Thu,  6 Jun 2024 16:03:24 +0200
Message-ID: <20240606131659.338750270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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
index 059467086b131..86752b1652b5b 100644
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



