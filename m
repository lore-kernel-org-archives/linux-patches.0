Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14B136998C;
	Wed, 30 Sep 2026 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794599; cv=none; b=BscNYh6XbljXnjrJIutYxcDl5iGm+oOA5OvohPm8qSozM6xZpaGcBdPgsqyGOXo9EVs9VRGnJrZOfdSmPTD5uweGzv6dMhcel8d8CfbZ4YJaa/+TIUbM7r7Lsh+qip/0KILQpN7o4eYQm9ll7zcb2VkB2rp83eGgS8weL4sfSUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794599; c=relaxed/simple;
	bh=JYiEjqwa7rtCGSFQZfh067JtsTb3YjmtJyDrFlqC9M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B57bKvg7W2N4IbNClJTuoKURTfXX8T+jEZFU3VFXGCXnHDGnjIZ8hvObcgwyNwKLxtbiMrlgQcOUkJyc9gzi7mQZ0XiMe//FMs/a1nOkIsQZ/oqqlgMGodju4cpfi/VMY7fRAkAZAdDPQocag/cqdmrs8/rnXddWg7JHxqQh780=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbJIxnsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbJIxnsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264101F000FF;
	Wed, 30 Sep 2026 18:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794597;
	bh=WbiN/zAMqK4p9nSiReIEdzQta3vltyo7UYvHJBW9yV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbJIxnsRI6BarGN3nlcZhH73mQ/XfMa17w0OpLjoU1KKLzXNoCdGGegm6jHMN7c4z
	 nUupLWFm1vhH9a3UMivGXbej7G7hGUEpebK6HTEUQKUIoxQMGHhU6OeSBLM5a6ZEBN
	 cc0lxMZweH5Z91N3mf3Z4YyEpETWxOlAN01ZDS3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0266/1193] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Wed, 30 Sep 2026 17:15:50 +0200
Message-ID: <20260930152440.080635936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

[ Upstream commit 25656304dabd26198ec69460c594a19d086ef099 ]

blkcg_print_one_stat() will be called for each blkg:
- access blkg->iostat, which is freed from rcu callback
  blkg_free_workfn();
- access policy data from pd_stat_fn(), which is freed from
  pd_free_fn(), while pd_free_fn() can be called by removing blkcg or
  deactivating policy;

Take blkcg->lock while iterating so the blkgs stay online and both
blkg->iostat and policy data for activated policies stay valid.  Use
irq-safe locking because blkcg->lock can be nested under q->queue_lock,
which is used from IRQ completion paths.

Prepare to convert protecting blkgs from request_queue with mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/05799877e720dcd300e2ddd4625e8e162959d7cc.1780621988.git.yukuai@fygo.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b108e934a1427..cd30f2ca561f5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1201,13 +1201,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	else
 		cgroup_rstat_flush(blkcg->css.cgroup);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	guard(spinlock_irq)(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+
 	return 0;
 }
 
-- 
2.53.0



