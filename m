Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B56221DAD;
	Wed, 28 May 2025 21:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469382; cv=none; b=qfNCFW/7LXNqXGwh9jXBqUstHTwN+djp915IMsSnOtM4kIzKIzrYnjuiqmg5/yooczYnk2z0DEbXCCKQWQCvIxzg+Lr+th73Q0Y3hAMEnxQvyGJxaZ9IOq3/BZGe/qMt+Hww1Tftz+LqDBJBOUVFCZuSRIlaX+5ycfj1zwPA89s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469382; c=relaxed/simple;
	bh=G4OERUkSBYpc8nh8CkbEbQ1J10NUPAI/Img+V6PXY8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cYAVgCe8nf3IUFlBk6ASFXEEEQLbSzLQyNvSJ0RvX6a8XOR/J+Eh66oicD1ky/n1jcweFa02liQYexsNqY9Pxj8MNUN0i2vdT9+22Lv6aExKnLo0ienJ04ZpGyDOUepPwzU0mKBDUtxmCfiKwWeZNywWwbKaQhd4Ph7yspU39Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaHtj8bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaHtj8bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122D2C4CEF0;
	Wed, 28 May 2025 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469382;
	bh=G4OERUkSBYpc8nh8CkbEbQ1J10NUPAI/Img+V6PXY8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaHtj8bCEGqQlIp4DXEs69AMJIWY48EMAuSmnz9Vvc9RffnjwprN+7FLgIgkVyYo5
	 v1DdggSUJEZFMX5I02j67lK6TnuRdOVbfk2Qk2qxPzOcBi5yRonOk2+7QhEgV+T3s1
	 qvRnB7AC7ljKmyE7H2bKrkySa1I01SBVeT4XNi/NH4Szs6Rx8Nc4hpk0j4IiJqJZek
	 HJhfahpjL5J4PMdVaN4ywOMivklMLZPhFHrhBQ0pIKDk+VecVU/Os5vqm3ewn8nzK0
	 9z4ccLpTnGat/l0L2LbMcc3wR1XwrUTnUCFILWrH50QH+wT8fPBwvtekw/E0NHI9Tq
	 ZjL/kVzl0hqWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 8/8] block: use q->elevator with ->elevator_lock held in elv_iosched_show()
Date: Wed, 28 May 2025 17:56:11 -0400
Message-Id: <20250528215611.1983429-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250528215611.1983429-1-sashal@kernel.org>
References: <20250528215611.1983429-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 94209d27d14104ed828ca88cd5403a99162fe51a ]

Use q->elevator with ->elevator_lock held in elv_iosched_show(), since
the local cached elevator reference may become stale after getting
->elevator_lock.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250505141805.2751237-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

The environment variable is set. Now let me analyze the commit mentioned
in the prompt: **Subject**: block: use q->elevator with ->elevator_lock
held in elv_iosched_show() **Analysis of the code changes**: The commit
fixes a race condition in the block elevator subsystem in
`elv_iosched_show()`. Here's what it does: 1. **Removes local cached
variable**: The commit removes the local variable `struct elevator_queue
*eq = q->elevator;` that was caching the elevator queue reference. 2.
**Accesses q->elevator under lock**: Instead of using the cached
`eq->type`, it now directly accesses `q->elevator->type` while holding
the `->elevator_lock` mutex. 3. **Fixes race condition**: The old code
had a time-of-check-time-of-use (TOCTOU) race where the cached `eq`
could become stale after acquiring the `->elevator_lock`, but before
actually using `eq->type`. **Analysis of backport suitability**: Looking
at similar commits in the reference history: - Similar Commit #4 was
marked YES for backporting because it fixed a real bug with clear user
impact - The other similar commits were marked NO because they were code
cleanups/optimizations without fixing actual bugs This commit: 1.
**Fixes a real race condition bug** - The cached elevator reference
could become invalid between when it's stored and when it's used 2.
**Has clear user impact** - Race conditions in the elevator code could
lead to crashes or memory corruption when users access
`/sys/block/*/queue/scheduler` 3. **Is a small, contained fix** - Only
changes a few lines in one function 4. **Has minimal regression risk** -
Simply ensures proper locking is used when accessing shared data 5.
**Follows stable tree rules** - It's an important bugfix with minimal
risk The commit message explicitly states the problem: "the local cached
elevator reference may become stale after getting ->elevator_lock" -
this is a classic race condition that could cause system instability.
**YES** This commit should be backported to stable kernel trees. It
fixes a race condition in the block elevator subsystem where a cached
elevator reference could become stale between the time it's stored and
when it's actually used, even after acquiring the elevator lock. The fix
is minimal and safe - it simply ensures that `q->elevator->type` is
accessed directly while holding the lock rather than using a potentially
stale cached reference. This prevents potential crashes or memory
corruption when users access the scheduler interface in
`/sys/block/*/queue/scheduler`. The change is small, contained to a
single function, has clear bug-fixing intent, and follows stable tree
criteria of being an important bugfix with minimal regression risk.

 block/elevator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index cd2ce49216010..1cc89c49e4cc9 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -734,7 +734,6 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 {
 	struct request_queue *q = disk->queue;
-	struct elevator_queue *eq = q->elevator;
 	struct elevator_type *cur = NULL, *e;
 	int len = 0;
 
@@ -742,7 +741,7 @@ ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 		len += sprintf(name+len, "[none] ");
 	} else {
 		len += sprintf(name+len, "none ");
-		cur = eq->type;
+		cur = q->elevator->type;
 	}
 
 	spin_lock(&elv_list_lock);
-- 
2.39.5

