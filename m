Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C01A682B;
	Fri,  9 Oct 2026 14:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555803; cv=none; b=V0RG5ZNG8XeP37uWqyC8D3PYxdM/Kr9+WwdXSTRbw+BWFHkiqp6djuuSIvHfY8RJX5Dzb4c9+G8vJeN9bWrRVjA0KpoCNS0pnXRVjMbmzl9tTRRMl1NZKgpbqtyIInew8AjVfozO9B98iK42H5SwGbCfW84ufHjexgqtAzEUTbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555803; c=relaxed/simple;
	bh=owNCXmOqx/7MjgSwUqKFu3dntCpmbFJPQx/3vTkUFrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7HmfcejPAxqvXh4ztk2iWegpaTzF2EJ+d1MmIuOn8+QCKOnZ+VyGeX5gQqd7EfysUjLGRqYn/GEzLzONb/dSbj1QU2wKeaRv0n/Cq8Y+ZDfLK8HZ0psdqZVjB0Wh5rvCKyK5+X/6KGavQ91FQZS6pKnTDh0mBgmkWs88l2sIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi9ZLXCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi9ZLXCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8581F00893;
	Fri,  9 Oct 2026 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555802;
	bh=GSFCVoG3ggIhyDMY9TSLd1rkYSS5bXBnmnoJE1x8J9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi9ZLXCilA8RjG+DC0kd2j2FrTaaagVqDqiw5GUwnnAEg3sizCkRB9m4X+Lr7RNyb
	 F6Gxxiv1gfkC015Fbm/zPq6WYi0nzDo6Tqg9ew5gNqsNHIYb2YRsRhlcVPl0afI7qX
	 0iBTDbGfr6ydww6ZchbenwQ7Nirx02/E5st0IkDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 072/428] blk-cgroup: save IRQ state in blkg_tryget_closest()
Date: Fri,  9 Oct 2026 16:06:49 +0200
Message-ID: <20261009140947.737738375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Zhang <zhanghao1@kylinos.cn>

[ Upstream commit 327c428ba79b13e4cc5253333a9d5c0aa5579bdf ]

bio_set_dev() associates the bio with a blkg through bio_associate_blkg().
If the blkg lookup misses, blkg_tryget_closest() takes q->queue_lock with
spin_lock_irq() and releases it with spin_unlock_irq(), which
unconditionally enables local interrupts.

Callers may call bio_set_dev() with interrupts already disabled, e.g.
dm-thin's pool_map() does so while holding pool->lock taken with
spin_lock_irq().  The nested spin_unlock_irq() then enables interrupts
while pool->lock is still held, so an I/O completion softirq can run on
the same CPU, re-acquire pool->lock (thin_endio(), or overwrite_endio()
-> complete_mapping_preparation()) and deadlock.  lockdep reports this
as inconsistent SOFTIRQ-ON-W to IN-SOFTIRQ-W usage.

Commit 3a762de55b4e ("block: save irq state in blkg_lookup_create()")
fixed the same problem while the lock lived in blkg_lookup_create(), but
commit 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in
blkg_lookup_create()") moved the locking into blkg_tryget_closest() and
reverted it to spin_lock_irq().

Save and restore the caller's IRQ state instead.

Fixes: 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()")
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/aqQmqb1k57PXj8Ef@192.168.1.215
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 52080c7c1a14b..1951bda17cf5c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2078,6 +2078,7 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	struct request_queue *q = bio->bi_bdev->bd_queue;
 	struct blkcg *blkcg = css_to_blkcg(css);
 	struct blkcg_gq *blkg;
+	unsigned long flags;
 
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
@@ -2092,11 +2093,11 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	 * Fast path failed, we're probably issuing IO in this cgroup the first
 	 * time, hold lock to create new blkg.
 	 */
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irqsave(&q->queue_lock, flags);
 	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
 	if (blkg)
 		blkg = blkg_lookup_tryget(blkg);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irqrestore(&q->queue_lock, flags);
 
 	return blkg;
 }
-- 
2.53.0



