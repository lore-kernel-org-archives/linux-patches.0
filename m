Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9E713AD2
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8D6C433CD;
	Mon, 26 Jun 2023 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803622;
	bh=lCdrSBBnf+pP20fLiCNvWVrG/YG274yASOAWt+DEm6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXkJnwTqKpNkHc4qWXXFgJii9QFYIpJpwIX61YbLO8jRECvx2ktdJIVf6htC/Sv7T
	 HuBRwT90+gaQVVatCwC5SVafrHnlYPy8cfhSQWO2gr0U1sv2Miwsv8WSV/GvmPV0HO
	 c1dUloQsW5ULkHzZvEBERxvNBF1B8m/Hnc5EAjmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jay Shin <jaeshin@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 096/199] block: make sure local irq is disabled when calling __blkcg_rstat_flush
Date: Mon, 26 Jun 2023 20:10:02 +0200
Message-ID: <20230626180809.833924745@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

commit 9c39b7a905d84b7da5f59d80f2e455853fea7217 upstream.

When __blkcg_rstat_flush() is called from cgroup_rstat_flush*() code
path, interrupt is always disabled.

When we start to flush blkcg per-cpu stats list in __blkg_release()
for avoiding to leak blkcg_gq's reference in commit 20cb1c2fb756
("blk-cgroup: Flush stats before releasing blkcg_gq"), local irq
isn't disabled yet, then lockdep warning may be triggered because
the dependent cgroup locks may be acquired from irq(soft irq) handler.

Fix the issue by disabling local irq always.

Fixes: 20cb1c2fb756 ("blk-cgroup: Flush stats before releasing blkcg_gq")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/pz2wzwnmn5tk3pwpskmjhli6g3qly7eoknilb26of376c7kwxy@qydzpvt6zpis/T/#u
Cc: stable@vger.kernel.org
Cc: Jay Shin <jaeshin@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20230622084249.1208005-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -907,6 +907,7 @@ static void __blkcg_rstat_flush(struct b
 	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
 	struct llist_node *lnode;
 	struct blkg_iostat_set *bisc, *next_bisc;
+	unsigned long flags;
 
 	rcu_read_lock();
 
@@ -920,7 +921,7 @@ static void __blkcg_rstat_flush(struct b
 	 * When flushing from cgroup, cgroup_rstat_lock is always held, so
 	 * this lock won't cause contention most of time.
 	 */
-	raw_spin_lock(&blkg_stat_lock);
+	raw_spin_lock_irqsave(&blkg_stat_lock, flags);
 
 	/*
 	 * Iterate only the iostat_cpu's queued in the lockless list.
@@ -946,7 +947,7 @@ static void __blkcg_rstat_flush(struct b
 			blkcg_iostat_update(parent, &blkg->iostat.cur,
 					    &blkg->iostat.last);
 	}
-	raw_spin_unlock(&blkg_stat_lock);
+	raw_spin_unlock_irqrestore(&blkg_stat_lock, flags);
 out:
 	rcu_read_unlock();
 }


