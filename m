Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE162248F73;
	Tue, 10 Mar 2026 11:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141282; cv=none; b=Ql4nanw+AoIzoriPmmSSbS+09rrEAvXVmF8cZ0qY43JCt+74bI19/+ZY4I5nU4T+mkCDpFeSKAavW0rzRsY7bvPSAsi/vco5geNkMjJHOw/b7paw0jahEYcnrr8zA83p++QLKtE+QKL5xUUof2XjBYC92S9nfoZJX39wYX3Gw7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141282; c=relaxed/simple;
	bh=L2Bm0IX5awlm3CIpln2CR5n9vUv3Ihy7OrSiS5Xvt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/5HGyjIJLgO0sZd9PQ/b/cOCeQp68fS5ZrKdcMBxV53zIgv2Btk0A7rE7se00Jc6RvtviZCDtiR+xFrdbFog7WVk2BkO3AkimRVl75EJUm5FuYvTxQnt9/atNNsYOsAm8iemVTv/SR/Sl5RlXDDZ2st4ydsSq8Z5D38UmQbSVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EKY9nlWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKY9nlWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22297C2BCAF;
	Tue, 10 Mar 2026 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141282;
	bh=L2Bm0IX5awlm3CIpln2CR5n9vUv3Ihy7OrSiS5Xvt2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKY9nlWYpWisjNDU+J/iE7XN94kTTBzsbuQRuis4dxZmuyE2+nPIpASZ1jsOR4m7E
	 gp+MiE0JGYED/x2+xBv2sDdOsEaBZhdlCjnbgGTHgrEiRAAN778N2wVYA8S6zfrE7c
	 PpvxrFQhJP3OKfW1UbSOOkQNSspAxFBzfkCeIVAM2LkY74A2R8Otm+ILwREDzOYy/G
	 lYov/C8pCGD4AGrCV2cZIka9ZamcELSUrICi2/OhOmftSQQfeqKN3GBw42elXA407G
	 ugMCmZtxsPzcmdnCzGv4oi2C/teOYLveWa+vDoqvk8+bynopa6YR/Gt/9cBOu4stWb
	 nZXOOdEA/KZjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 286/311] block: use trylock to avoid lockdep circular dependency in sysfs
Date: Tue, 10 Mar 2026 07:05:33 -0400
Message-ID: <772055615e25ab0de85ec73da512174bb06e5df9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit ce8ee8583ed83122405eabaa8fb351be4d9dc65c ]

Use trylock instead of blocking lock acquisition for update_nr_hwq_lock
in queue_requests_store() and elv_iosched_store() to avoid circular lock
dependency with kernfs active reference during concurrent disk deletion:

  update_nr_hwq_lock -> kn->active (via del_gendisk -> kobject_del)
  kn->active -> update_nr_hwq_lock (via sysfs write path)

Return -EBUSY when the lock is not immediately available.

Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs-em-4acsHabMdT=jJhXkCzjnprD-aQH1OgrZo4nTnmMw@mail.gmail.com/
Fixes: 626ff4f8ebcb ("blk-mq: convert to serialize updating nr_requests with update_nr_hwq_lock")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c |  8 +++++++-
 block/elevator.c  | 12 +++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e0a70d26972b3..af12526d866a9 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -78,8 +78,14 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 	/*
 	 * Serialize updating nr_requests with concurrent queue_requests_store()
 	 * and switching elevator.
+	 *
+	 * Use trylock to avoid circular lock dependency with kernfs active
+	 * reference during concurrent disk deletion:
+	 *   update_nr_hwq_lock -> kn->active (via del_gendisk -> kobject_del)
+	 *   kn->active -> update_nr_hwq_lock (via this sysfs write path)
 	 */
-	down_write(&set->update_nr_hwq_lock);
+	if (!down_write_trylock(&set->update_nr_hwq_lock))
+		return -EBUSY;
 
 	if (nr == q->nr_requests)
 		goto unlock;
diff --git a/block/elevator.c b/block/elevator.c
index a2f8b2251dc6e..7a97998cd8bd7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -806,7 +806,16 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 	elv_iosched_load_module(ctx.name);
 	ctx.type = elevator_find_get(ctx.name);
 
-	down_read(&set->update_nr_hwq_lock);
+	/*
+	 * Use trylock to avoid circular lock dependency with kernfs active
+	 * reference during concurrent disk deletion:
+	 *   update_nr_hwq_lock -> kn->active (via del_gendisk -> kobject_del)
+	 *   kn->active -> update_nr_hwq_lock (via this sysfs write path)
+	 */
+	if (!down_read_trylock(&set->update_nr_hwq_lock)) {
+		ret = -EBUSY;
+		goto out;
+	}
 	if (!blk_queue_no_elv_switch(q)) {
 		ret = elevator_change(q, &ctx);
 		if (!ret)
@@ -816,6 +825,7 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 	}
 	up_read(&set->update_nr_hwq_lock);
 
+out:
 	if (ctx.type)
 		elevator_put(ctx.type);
 	return ret;
-- 
2.51.0

