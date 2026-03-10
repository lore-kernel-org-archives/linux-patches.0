Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F73D5240;
	Tue, 10 Mar 2026 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142203; cv=none; b=rrEPxk7QXbKPEhbYR7QgWMfcO+xbZj+O1heUbz4NyTzvjobU/ccopnud9uDG5bULuDXD50Xpl3Ifw4K+NpfcrEuKHvU74NOtlhthc8k2b5OuZt9Q5GJzAhI9tcMlxJlyGqg99RMnl4QLy0e7AYb3giZ3kpBxMjg+AAdaLd9fdrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142203; c=relaxed/simple;
	bh=L2Bm0IX5awlm3CIpln2CR5n9vUv3Ihy7OrSiS5Xvt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm8CTg9JJokD2CCfICFjIuyXijxxTH4FtZRFNv/PH4emoMC+v0TCoFXEtb6+dwE3NkPzMtzWK2MHUwzHLhB1R38lpJHP0H1rI6+1NQygiYVlfm6qLTTgMQoYC1i+ivx0pI/vi8FQVBko4A4su9qqo8mi9YscM6HRBAZl5r+5mOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPfb1NB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPfb1NB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9ECC2BC9E;
	Tue, 10 Mar 2026 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142202;
	bh=L2Bm0IX5awlm3CIpln2CR5n9vUv3Ihy7OrSiS5Xvt2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPfb1NB/rfOnBkrwHfkXjg4JMnt/lGNielbqxqI4luh6WNsRWXZpRhvLmPONLvEdh
	 CT5Rgfo/TOAYBpMCU09q5tLYMf8TQhZ3yPC/XbL8kxQJGIxWJBhvG5WBeaKsoXcH1T
	 9mPh+RPs1Oih4Kzq65TV90k20oegCuGvEWHUnfbINjQiGu6rIsOI+YZjF59SA9yV/E
	 DRxzoKiXxVArszuYrpzPLj8/q3PudPBdyXsjj2lnoflLYBt7gx6UXXQcUpCzNe9kLb
	 Qc8QqXmoh0M+aeYo58ep4kN3esXlZA2Jw+gwaAtfABa1cN/QUtHTya3wM3nAwbrdYX
	 1y8wHaaFzebaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/314] block: use trylock to avoid lockdep circular dependency in sysfs
Date: Tue, 10 Mar 2026 07:19:11 -0400
Message-ID: <41579287b8faa7714fffe424e1199e70fffc1434.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

