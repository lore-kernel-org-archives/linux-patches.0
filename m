Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB3B23183B;
	Wed, 28 May 2025 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469392; cv=none; b=VsmjljEscgVCG/vxUuR4fJ0V5iRBxG+b3pAvD4U0SQeAvKAvVweb1Axgi7BtzvzHm7+n9Ul8HfbBgH4ovUqNTgut0Vxg3VRO1eAbuv/y1BstB0ag+6kcqadrJ7UFL+qChlrrGIVQjGiG0rEnoDnalmT21897k8RdkwKlkiNjBRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469392; c=relaxed/simple;
	bh=JaaW6qnfUmXrbmFUIgHO1/CWZ0FtykmM4JWqgs3M8PI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VvhSRLbmZOPxmcIL5eJ1ApOOlWA7Vmab4Nsu38P7sqFLsLUSZA0Qbf8AhJ5QeoykdC/3UEZDTurN2du0Ub80Z/xZkA4B7O7DZJPGkFM9pCdpl3qtKSzDB7h18Mk8sJJ5J8frsElQ2ItqmpdAAfpkwCLmMX8y6AFnH/5UvPTpLlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kje8NJV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kje8NJV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1A3C4CEED;
	Wed, 28 May 2025 21:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469391;
	bh=JaaW6qnfUmXrbmFUIgHO1/CWZ0FtykmM4JWqgs3M8PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kje8NJV78Iw4DWXh/1uX7hsDeuHGnmNvbgrmc27/U/OKbvsxnmUzpgjJiWo9GKryF
	 +BlRTgzPse+yvRLe4fJoPoXDWQ1GMr7aPOMhxW4pN61gq0FtV823HyuGfuNmbfrTdQ
	 61YAo1Dp+RhBcdIHe5QJsZyRVQgXgVMHmkk/J/DeHEYvRmWJmWFfAq+6npp5KIxynO
	 j9UWydUtqPJHrR4D8Ye4TxEFFc0Mh4gEfQavMDueVeIvr9zjuRVlfk2EsOeLWFPIyL
	 ZpPW0q0H0K50XBKTJZ6Ub542qtD5je/u93trO/hV+mmo08syDNVkXPHRKmto//Nfv+
	 xVyQKMYs07xAQ==
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
Subject: [PATCH AUTOSEL 6.12 7/7] block: use q->elevator with ->elevator_lock held in elv_iosched_show()
Date: Wed, 28 May 2025 17:56:22 -0400
Message-Id: <20250528215622.1983622-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250528215622.1983622-1-sashal@kernel.org>
References: <20250528215622.1983622-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.30
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
index 43ba4ab1ada7f..1f76e9efd7717 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -752,7 +752,6 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 {
 	struct request_queue *q = disk->queue;
-	struct elevator_queue *eq = q->elevator;
 	struct elevator_type *cur = NULL, *e;
 	int len = 0;
 
@@ -763,7 +762,7 @@ ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 		len += sprintf(name+len, "[none] ");
 	} else {
 		len += sprintf(name+len, "none ");
-		cur = eq->type;
+		cur = q->elevator->type;
 	}
 
 	spin_lock(&elv_list_lock);
-- 
2.39.5

