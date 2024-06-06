Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C611C7D76;
	Thu,  6 Jun 2024 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683704; cv=none; b=jnTgCSvrxqqJ0pPGJMgk6itFKe9pvwP5gBCxTGhmF+hQBwjKpQ/ritL0/uBO76zaXZFclmBj9KXpJMsrlsbaSbc0377yOQjTZs1LSiPfJZH0W5yoJt+nqx8eFG7Hc7jWia3hfeuH6S3hJokzu7ODcNMaFpAA7hl1tRZcl4m4mjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683704; c=relaxed/simple;
	bh=9mFrghmry0Um8QT949xDe4IsFXfk1eIHNdc2/zPkQcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwFlyDphoMLh+Ty2QFYvTv8I6P0QLlvEo/lMtliA8n9NJBYcCOu7309bfv06lnQGI3QlJh2QMz5t67dVkRI8JVJsCJqwkWeZltSPyc/WJwrQSxniZhZmE6Bx7toIwys6nhO6teTjrk1Vj12agtnYYy8y8etoBWCu/cAjwy8dDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziEsmN59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziEsmN59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC52C32781;
	Thu,  6 Jun 2024 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683704;
	bh=9mFrghmry0Um8QT949xDe4IsFXfk1eIHNdc2/zPkQcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziEsmN59EQYHEsnIud2bwNribnJSiskz+MERD/XRiOlmijHooFJvII0xRA4HQ8KSi
	 cDPi5/j5FjxCimwRnN69y/akP6sylNABcgJp9vT62dTEzV2fTdfkdlutKD3gb4fJmC
	 1EZzCs7X12NdtISP0LDM1OnMa1VjwT7znr4XGo6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 628/744] blk-cgroup: Properly propagate the iostat update up the hierarchy
Date: Thu,  6 Jun 2024 16:05:00 +0200
Message-ID: <20240606131752.631787366@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 9d230c09964e6e18c8f6e4f0d41ee90eef45ec1c ]

During a cgroup_rstat_flush() call, the lowest level of nodes are flushed
first before their parents. Since commit 3b8cc6298724 ("blk-cgroup:
Optimize blkcg_rstat_flush()"), iostat propagation was still done to
the parent. Grandparent, however, may not get the iostat update if the
parent has no blkg_iostat_set queued in its lhead lockless list.

Fix this iostat propagation problem by queuing the parent's global
blkg->iostat into one of its percpu lockless lists to make sure that
the delta will always be propagated up to the grandparent and so on
toward the root blkcg.

Note that successive calls to __blkcg_rstat_flush() are serialized by
the cgroup_rstat_lock. So no special barrier is used in the reading
and writing of blkg->iostat.lqueued.

Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Reported-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Closes: https://lore.kernel.org/lkml/ZkO6l%2FODzadSgdhC@dschatzberg-fedora-PF3DHTBV/
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20240515143059.276677-1-longman@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8102a23b24871..4fb045d26bd5a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -323,6 +323,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
+	blkg->iostat.blkg = blkg;
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	spin_lock_init(&blkg->async_bio_lock);
 	bio_list_init(&blkg->async_bios);
@@ -1047,6 +1048,8 @@ static void __blkcg_rstat_flush(struct blkcg *blkcg, int cpu)
 		smp_mb();
 
 		WRITE_ONCE(bisc->lqueued, false);
+		if (bisc == &blkg->iostat)
+			goto propagate_up; /* propagate up to parent only */
 
 		/* fetch the current per-cpu values */
 		do {
@@ -1056,10 +1059,24 @@ static void __blkcg_rstat_flush(struct blkcg *blkcg, int cpu)
 
 		blkcg_iostat_update(blkg, &cur, &bisc->last);
 
+propagate_up:
 		/* propagate global delta to parent (unless that's root) */
-		if (parent && parent->parent)
+		if (parent && parent->parent) {
 			blkcg_iostat_update(parent, &blkg->iostat.cur,
 					    &blkg->iostat.last);
+			/*
+			 * Queue parent->iostat to its blkcg's lockless
+			 * list to propagate up to the grandparent if the
+			 * iostat hasn't been queued yet.
+			 */
+			if (!parent->iostat.lqueued) {
+				struct llist_head *plhead;
+
+				plhead = per_cpu_ptr(parent->blkcg->lhead, cpu);
+				llist_add(&parent->iostat.lnode, plhead);
+				parent->iostat.lqueued = true;
+			}
+		}
 	}
 	raw_spin_unlock_irqrestore(&blkg_stat_lock, flags);
 out:
-- 
2.43.0



