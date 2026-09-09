Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07E492E33;
	Wed,  9 Sep 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961698; cv=none; b=HBQ1IbacmDgLUEj4A8FW+hXHgWctkiuw4mYkQJ/ISoYewy0LpOMIyaDAvALlt1xA3Qq1q7qXHzT+zHpqwibTYL8C+IcPzznrC65VilhSjpGMcSoY3LWXJ7MmvmrdP7R7Tfy7zjkh+bRTxH7a5VWTEJe0J0XRvQQyyKMpXBP10Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961698; c=relaxed/simple;
	bh=r06tpLZa7jSei9GSzRFKACh78lpWTQ2erFsWIMIzdk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPHlzQRq9kXjtz1P7CvpbYwk7msiluOmvpE8Onojibn5f7pWRfFQ7LN83bUoDaMGFFj7bbMjAIQgj3S8PgqxjTGLUkN98AD5JcNA5xFyWBOy6yp0QOkB9MlIXXhMmXQcbh07xvRMw5g3RlrOq4K96AuT70pjgXOVGZ1mnc/oxIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrNI+A2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrNI+A2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC9A1F00A3A;
	Wed,  9 Sep 2026 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961697;
	bh=GgnMN12JcYx83h/TL2qsdfgbTXfQ+I4jIZMxlgfaERI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrNI+A2NwNeUaj88IDaFnwPC73JVkZrioLx1h083X98e4I+chJ+3emglvgLuga21Z
	 r6Sz6kDrHuZ6zvO2JAi0DUrev3qHFGHedoLheCsZHxCxWJKm7J94NiWLP5qR20GpVt
	 tmNPYxXkbNuBrjhRbVqA3+0D0YGrSs3suSyiYMXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/556] zram: move lockmap to be per-zram instead per table
Date: Wed,  9 Sep 2026 15:34:47 +0200
Message-ID: <20260909134230.718350307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit dbb7ba9c7fa81a48ed2a108ad684cf3655f3ae4b ]

Patch series "zram: lockmap tweaks".

This patch (of 2):

The zram object contains an array zram_table_entry.  Each one has a `lock'
variable and each has a matching struct lockdep_map.  This mimics a struct
mutex.

It uses always the same key for all lockdep_map instances.  This makes it
look like the same lock to lockdep.  Therefore it could be reduced to have
one lockdep_map per struct zram.

Use only one struct lockdep_map per struct zram.

Link: https://lore.kernel.org/20260714141300.3945672-1-bigeasy@linutronix.de
Link: https://lore.kernel.org/20260714141300.3945672-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: a8b5875741d4 ("zram: fix slot lock bit position on big-endian 64-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   21 +++++++++------------
 drivers/block/zram/zram_drv.h |    2 +-
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -57,14 +57,12 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void slot_free(struct zram *zram, u32 index);
-#define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
-static void slot_lock_init(struct zram *zram, u32 index)
+static void slot_lock_init(struct zram *zram)
 {
 	static struct lock_class_key __key;
 
-	lockdep_init_map(slot_dep_map(zram, index), "zram->table[index].lock",
-			 &__key, 0);
+	lockdep_init_map(&zram->table_lock_map, "zram->table[index].lock", &__key, 0);
 }
 
 /*
@@ -84,8 +82,8 @@ static __must_check bool slot_trylock(st
 	unsigned long *lock = &zram->table[index].__lock;
 
 	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
-		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
-		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+		mutex_acquire(&zram->table_lock_map, 0, 1, _RET_IP_);
+		lock_acquired(&zram->table_lock_map, _RET_IP_);
 		return true;
 	}
 
@@ -96,16 +94,16 @@ static void slot_lock(struct zram *zram,
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
+	mutex_acquire(&zram->table_lock_map, 0, 0, _RET_IP_);
 	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
-	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+	lock_acquired(&zram->table_lock_map, _RET_IP_);
 }
 
 static void slot_unlock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	mutex_release(slot_dep_map(zram, index), _RET_IP_);
+	mutex_release(&zram->table_lock_map, _RET_IP_);
 	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
 }
 
@@ -1989,7 +1987,7 @@ static void zram_meta_free(struct zram *
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 {
-	size_t num_pages, index;
+	size_t num_pages;
 
 	num_pages = disksize >> PAGE_SHIFT;
 	zram->table = vzalloc(array_size(num_pages, sizeof(*zram->table)));
@@ -2006,8 +2004,7 @@ static bool zram_meta_alloc(struct zram
 	if (!huge_class_size)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
-	for (index = 0; index < num_pages; index++)
-		slot_lock_init(zram, index);
+	slot_lock_init(zram);
 
 	return true;
 }
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -74,7 +74,6 @@ struct zram_table_entry {
 #endif
 		} attr;
 	};
-	struct lockdep_map dep_map;
 };
 
 struct zram_stats {
@@ -107,6 +106,7 @@ struct zram_stats {
 
 struct zram {
 	struct zram_table_entry *table;
+	struct lockdep_map table_lock_map;
 	struct zs_pool *mem_pool;
 	struct zcomp *comps[ZRAM_MAX_COMPS];
 	struct zcomp_params params[ZRAM_MAX_COMPS];


