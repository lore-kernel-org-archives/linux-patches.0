Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216415;
	b=xV5nqTK7MaphdKg99ggAMWr8vNnUB9vzJ7XaEnnc9uAViOaUK54YI+tlBvMtcF/RR/ee
	 KAJ7OM77XybKc7jOFSj1BhMI+QlEdcUYZY42BMGrsxOS8h0CrmhZy9Y2Wc08kpabVyGLi
	 ZYxvHLOcHKudS4PfuR8JTmPBNCTUYmH4Zi1Fz/e+uzwG6dDf6viPV2kJMXdfXC6eCtuAp
	 tT0fDKuMaYE/n6zwPIKqfp8VIffCRY3KPSEwzcFr1cTDOpIEiULSxPFQnubNeKavpiUDy
	 h7ZYX5d5W1kLExeDYuAf1MreVc9MR1o//zOecw4rD5JTVsWq0LwsLkeGfIw1RF2tgEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9h2P2fumiT3Q+b1PLkbK3FNrW/hJyHz++aMezOMBgDw=;
	b=CKeSb+qA8aBUk3fCKKUZewEh4ue4GX2/guEKg1lpI5w20swyHoOwJ/gS4qJy+TLccpZ4
	 7dxG3K7bGE8hVZIZRXC2x0F0d/ZUCzCm2OHxElTGZ7DE5kb/AI8djYm97LYEmcB2IvclY
	 BibHnbns3g+mCEaXjOpuJlISoOoOLHT0AvY5nSRXG1GIMuJVy2Cbgfu78TYtub96F0PkK
	 C08lGv+MPGkS59Zcai91lrO/sQ1UyxKlQgiUHXEgk9y7T9I3k83ni3PlvH3vA0z/qWdcq
	 LoGNForlKFrX2Odqt0cjkxDEPTjeOjWw/D3GtVN9UiMDppIKTPX/MRuXDvFfjqvnWwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfDFBzc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F960A2604;
	Wed, 28 Oct 2026 19:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfDFBzc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86961F01825;
	Wed, 28 Oct 2026 19:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216415;
	bh=9h2P2fumiT3Q+b1PLkbK3FNrW/hJyHz++aMezOMBgDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfDFBzc7WtQNkmfpcoYAeCMWWGGeSxL59pZQdYinfm5preqwxFtE7Ac8My4LnHnpB
	 /EAhMZJidcSc/GZfge7c9t76/Qx9nmL3dyvGmEOii+n5V0BJoA8sZSsMZXKmNcBq2i
	 wPdZ1JeHir6kkDZ+pln6yiODFCmu9d19Mh+Eq47w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1546/1887] blk-cgroup: delay freeing policy data after rcu grace period
Date: Wed, 28 Oct 2026 18:00:42 +0100
Message-ID: <20261028170534.649295594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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

Adapted for this tree: bfqg_release() also exits the group stats, the
throttle policy keeps its existing offline helpers, and the bfq_group
reference counter becomes atomic because the final bfqg_put() now runs
from an RCU callback without the locks that protect the other users.

Stable-dep-of: 97cb95d21488 ("blk-iocost: clear delay state when freeing policy data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c    | 15 ++++++++++-----
 block/bfq-iosched.h   |  2 +-
 block/blk-cgroup.h    |  2 ++
 block/blk-iocost.c    | 14 ++++++++++++--
 block/blk-iolatency.c | 10 +++++++++-
 block/blk-throttle.c  | 13 +++++++++++--
 6 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 8e2478efd6695..136a61a1458ba 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
 
 static void bfqg_get(struct bfq_group *bfqg)
 {
-	bfqg->ref++;
+	atomic_inc(&bfqg->ref);
 }
 
 static void bfqg_put(struct bfq_group *bfqg)
 {
-	bfqg->ref--;
-
-	if (bfqg->ref == 0)
+	if (atomic_dec_and_test(&bfqg->ref))
 		kfree(bfqg);
 }
 
@@ -556,14 +554,21 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
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
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 2b413ddffbb95..278fb51919b5d 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -953,7 +953,7 @@ struct bfq_group {
 	char blkg_path[128];
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
-	int ref;
+	atomic_t ref;
 	/* Is bfq_group still online? */
 	bool online;
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 59815b269a20e..840deb32746c1 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -126,6 +126,8 @@ struct blkg_policy_data {
 	struct blkcg_gq			*blkg;
 	int				plid;
 	bool				online;
+
+	struct rcu_head			rcu_head;
 };
 
 /*
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 3989d8c796b0f..eeda41267bd43 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3003,6 +3003,16 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
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
@@ -3027,8 +3037,8 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
-	free_percpu(iocg->pcpu_stat);
-	kfree(iocg);
+
+	call_rcu(&pd->rcu_head, iocg_release);
 }
 
 static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 571fa95aafe96..884be27f0dda5 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1025,13 +1025,21 @@ static void iolatency_pd_offline(struct blkg_policy_data *pd)
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
index 62a3f62316df1..7ae61c3f887e9 100644
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



