Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6BC3CCA19;
	Sat, 17 Oct 2026 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260020; cv=none; b=Jw9jbc4RFG6CGiyJxzFRg0O4wR/ro4Vz/FLSR9XXWwX+WJ5wQo3hppi+j4kRpVn6hinKN8AIXNGG3Sb3vFG2vLI4fq7+MdwsBgqwgKv4W68YYV4TGCcJ0QQnak2eIyLQgttwahA9BT7sqy/G+ICM+BU9telursY0FTPfl0aRrIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260020; c=relaxed/simple;
	bh=jx8wNqrHqbTOW3BnZP5jLq7X0Na5HiF9VopBgNj2KQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3VxdRjWtYc3tmD+0uLreGiRpo/BGwfmW0akDQUxxoEa89P7WtRLmkKM/06zjC5VqbTOJOsqUfdhSL5fBixUTSth7YQg9qflYB40zwrB4j4wRHOxSDU5XGcv3knWEWa469OlSEwuYjhu7behaz2N1eREclsnSnDtduo9uMU6+xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLOuzCfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLOuzCfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16931F000C4;
	Sat, 17 Oct 2026 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260019;
	bh=zdj2Lsu27F4nxZW1ALHUMwrctK3a8UufLZAsV7NWUvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLOuzCfo1fqrK7w7gSI7cOMO0LRb2iB4qmUxz3Y91FV9RI/Yw31kfLjQyFHzrKZmN
	 aM2m/SKhLK/Icmf5t/oNDjI9VOexoUVkyQbmiE1VvxFh6ruvcM8jvXaxMNocrDBQ+O
	 gVr5VdqqYahYuLdVAsK7Z1OLCF0T6kX+nM9HyJXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1404/1674] blk-cgroup: delay freeing policy data after rcu grace period
Date: Sat, 17 Oct 2026 18:01:16 +0200
Message-ID: <20261017160507.214712917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 0af3fedb8c8ed3c07b4f76927bd7fc88f6f82efb ]

Currently blkcg_print_blkgs() must hold RCU to iterate blkgs from a
blkcg, and prfill() must hold queue_lock to prevent policy data from
being freed by policy deactivation. As a consequence, queue_lock has to
be nested under RCU from blkcg_print_blkgs().

Delay freeing policy data until after an RCU grace period so prfill() can
be protected by RCU alone.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/e20e5d984b41a026d61851966bed35eb094c4bff.1780621988.git.yukuai@fygo.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 97cb95d21488 ("blk-iocost: clear delay state when freeing policy data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c    |  9 ++++++++-
 block/blk-cgroup.h    |  2 ++
 block/blk-iocost.c    | 14 ++++++++++++--
 block/blk-iolatency.c | 10 +++++++++-
 block/blk-throttle.c  | 13 +++++++++++--
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index cb2a381193d13..8434581f0a70c 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -548,14 +548,21 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
-static void bfq_pd_free(struct blkg_policy_data *pd)
+static void bfqg_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct bfq_group *bfqg = pd_to_bfqg(pd);
 
 	bfqg_stats_exit(&bfqg->stats);
 	bfqg_put(bfqg);
 }
 
+static void bfq_pd_free(struct blkg_policy_data *pd)
+{
+	call_rcu(&pd->rcu_head, bfqg_release);
+}
+
 static void bfq_pd_reset_stats(struct blkg_policy_data *pd)
 {
 	struct bfq_group *bfqg = pd_to_bfqg(pd);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 5b0bdc268ade9..59ea7cc24f358 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -137,6 +137,8 @@ struct blkg_policy_data {
 	struct blkcg_gq			*blkg;
 	int				plid;
 	bool				online;
+
+	struct rcu_head			rcu_head;
 };
 
 /*
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7291f59986b80..e94b424f67791 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3019,6 +3019,16 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
+static void iocg_release(struct rcu_head *rcu)
+{
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
+	struct ioc_gq *iocg = pd_to_iocg(pd);
+
+	free_percpu(iocg->pcpu_stat);
+	kfree(iocg);
+}
+
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
@@ -3043,8 +3053,8 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
-	free_percpu(iocg->pcpu_stat);
-	kfree(iocg);
+
+	call_rcu(&pd->rcu_head, iocg_release);
 }
 
 static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index c1a6aba1d59e4..432d35a7196ec 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1031,13 +1031,21 @@ static void iolatency_pd_offline(struct blkg_policy_data *pd)
 	iolatency_clear_scaling(blkg);
 }
 
-static void iolatency_pd_free(struct blkg_policy_data *pd)
+static void iolat_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct iolatency_grp *iolat = pd_to_lat(pd);
+
 	free_percpu(iolat->stats);
 	kfree(iolat);
 }
 
+static void iolatency_pd_free(struct blkg_policy_data *pd)
+{
+	call_rcu(&pd->rcu_head, iolat_release);
+}
+
 static struct cftype iolatency_files[] = {
 	{
 		.name = "latency",
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 16f5766620a41..ed6fa1e7b8624 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -486,16 +486,25 @@ static void throtl_pd_offline(struct blkg_policy_data *pd)
 		throtl_upgrade_state(tg->td);
 }
 
-static void throtl_pd_free(struct blkg_policy_data *pd)
+static void tg_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct throtl_grp *tg = pd_to_tg(pd);
 
-	del_timer_sync(&tg->service_queue.pending_timer);
 	blkg_rwstat_exit(&tg->stat_bytes);
 	blkg_rwstat_exit(&tg->stat_ios);
 	kfree(tg);
 }
 
+static void throtl_pd_free(struct blkg_policy_data *pd)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+
+	del_timer_sync(&tg->service_queue.pending_timer);
+	call_rcu(&pd->rcu_head, tg_release);
+}
+
 static struct throtl_grp *
 throtl_rb_first(struct throtl_service_queue *parent_sq)
 {
-- 
2.53.0



