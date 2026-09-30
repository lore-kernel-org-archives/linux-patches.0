Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C351A726;
	Wed, 30 Sep 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784644; cv=none; b=g1WdZHKVW86P8B3dtlXmZZMMbTwHp27nNkvTl+uvZYKf3p3XyslxVALG8E6bkeP7jdu9/12v3guaQBMlPkg3pIMK6A6537g67ScepwQ4ecYsIxLfYvbyHPaa3v6vlHJFt5AlxEXtQiessRiehgNZ/2jE8ltsAxI1fM9H637zxWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784644; c=relaxed/simple;
	bh=JruK9yMofr/VGfKociByES2vJJL951XcCfrTE17grT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=no4LaxFl2HgteBTIOrYH50msiEBgcbdDukTm5uTBsOTaqzcniQ0QT9sv4qswgW0PzYqbYVXkPLrFoBZIScz5rgEfaC3jI5/UVCZsV1PnMgbszU2u1GM0k+u8XVxjeO5ZATqWI7kIFUSDtek3XsFXk0AEINUkjT8OQm1sWtwQV5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOZGJgCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOZGJgCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BE31F00898;
	Wed, 30 Sep 2026 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784640;
	bh=z+J2CF3AiytDjkhU4hXVpQdRZTXRhLS4rJ4iAs7BtXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOZGJgCGd/CALr7WSTtuNXPJKnklxXOBj7OClpx9VcRIlqvXmv6c3ebP71RXjob1g
	 t+PtoQd97tNfS6tSQI/fHIZgz9kulLRjaaDMO8Qde0sXOqp/idykTDX/y2Rv3G4Tko
	 6RMAonG/q+JVgGkCSBjOhJQoYna73b+3gGBN1MdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/982] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Wed, 30 Sep 2026 17:16:03 +0200
Message-ID: <20260930152421.675802937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e88e493457519..c02292b0bd694 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1003,13 +1003,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
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



