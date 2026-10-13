Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A73AA1BC;
	Tue, 13 Oct 2026 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894008; cv=none; b=tWVILQP0y9JrFwHWVXlR9G2q8JKwq7Oca+Cr2OnqLoyg8LDzamn5TRtHeEiqpkih7YWkwq1FEs1GmTb/KGiRuX56fvokr7wEtP2L1uNKF7mU2Ye7d7Sn2bAv3IIs1W0Ho37DNQ9fwUs47wZvB9y0OcJUSSy2M0skxenEjr0HY14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894008; c=relaxed/simple;
	bh=e59AOWwIvDwmbsGv+9SzwX758SMk5zYrJAn3kDNKOzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ87CLI5oIHMJKOajxIE3zgiv5atOsmXo/MOf3K/XhZAEd8pkZ+loHAUG0kt8WrGmiDhgpXrC13h487/XfddcZEisAX1m+GNhPL28LgMAHIk0fGb0P6pG3ySxiXpXHRQWkadkLAZ/9kMcwOq3DS9wEFOTw29S2h9V2h3mK1qupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQV+EAKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQV+EAKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F01F00893;
	Tue, 13 Oct 2026 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894007;
	bh=AyJpZTgGm5CNkfRthTCVrnnJzwAUXPxYH1hjwN84REM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQV+EAKBUkkz6kBCQtPvFrsBNIZpMTKkvKUJHkfjOJbvMembCxEy/Vge+K9MHZtQP
	 +7UGMN3vGXSZxyT15U1GwzLA8e3kE76TN/HWMHFL1JK74QYqg7+/sgL27kOONbGjyK
	 QmI1ZW8gLF7dENdauwr/TXwtyIa7w+y6nUDQBwq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/621] blk-cgroup: delay freeing policy data after rcu grace period
Date: Tue, 13 Oct 2026 13:36:51 +0200
Message-ID: <20261013112930.707826677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 6a75fe1c7a5c0..2e7cfaac7b214 100644
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
index 1cce3294634d1..fd206d1fa3c98 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -140,6 +140,8 @@ struct blkg_policy_data {
 	struct blkcg_gq			*blkg;
 	int				plid;
 	bool				online;
+
+	struct rcu_head			rcu_head;
 };
 
 /*
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ecf4969125050..e1901c98c4af5 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3017,6 +3017,16 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
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
@@ -3041,8 +3051,8 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
-	free_percpu(iocg->pcpu_stat);
-	kfree(iocg);
+
+	call_rcu(&pd->rcu_head, iocg_release);
 }
 
 static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 45bd18f68541b..ce25fbb8aaf66 100644
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
index c19d052a8f2f1..64e78c79a7b47 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -358,16 +358,25 @@ static void throtl_pd_online(struct blkg_policy_data *pd)
 	tg_update_has_rules(tg);
 }
 
-static void throtl_pd_free(struct blkg_policy_data *pd)
+static void tg_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct throtl_grp *tg = pd_to_tg(pd);
 
-	timer_delete_sync(&tg->service_queue.pending_timer);
 	blkg_rwstat_exit(&tg->stat_bytes);
 	blkg_rwstat_exit(&tg->stat_ios);
 	kfree(tg);
 }
 
+static void throtl_pd_free(struct blkg_policy_data *pd)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+
+	timer_delete_sync(&tg->service_queue.pending_timer);
+	call_rcu(&pd->rcu_head, tg_release);
+}
+
 static struct throtl_grp *
 throtl_rb_first(struct throtl_service_queue *parent_sq)
 {
-- 
2.53.0



