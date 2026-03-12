Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D712949E0;
	Thu, 12 Mar 2026 20:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346568; cv=none; b=swQ/jw5owyQDGpxuew2zx2Ymj9Vu5s+ggnlHas5Gw68ETbTD4u8AZK6jKkbJz+dgHohfO9dN3OwpIkHU5UlTdg09BuXJ+8V08oCvx7ftlNXD2NWH6L/C8DZwNwCwB9xOsXBICeI5PzXV4UlGLUNRFuBD/uH3BmRmGIqKhSX/QJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346568; c=relaxed/simple;
	bh=n7Z2+CBu38d6uvW4GSwn1SCr0q58QNcbBdFXh9PyTyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM9Gj0nqtnwzhrhLOM2clBfzfBPOGjWZTglpz6JqJb78CkBJoDMRTMGsXWHe/+UTeg6SMusmURWi3To3mDAu31BKq8UkOwy2aCSjuoou3BeoJhZvbXZuBcSUPefGvhEPd8FxetrXDYo6Jg23wtu+K+WSF63aSTX33MKjj/pCQjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNfvppez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNfvppez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC04C4CEF7;
	Thu, 12 Mar 2026 20:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346567;
	bh=n7Z2+CBu38d6uvW4GSwn1SCr0q58QNcbBdFXh9PyTyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNfvppezZ7ks+sI7BmCf6xXONrupBE3dYjTUL98mZwrdsXNuENhyUNHJUgKSjaNsW
	 8VQ2P4z8rtvFvA5ISPq8+K41VD2r2FtJm8FIAk/a3q5bMtWJKr1OGnyw5wbXeFxSwT
	 bVNTDaU5inetTVrZzzX8n4kooHsyzLZ+2JHLE//k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/265] ext4: add ext4_try_lock_group() to skip busy groups
Date: Thu, 12 Mar 2026 21:07:40 +0100
Message-ID: <20260312201020.852056752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit e9eec6f33971fbfcdd32fd1c7dd515ff4d2954c0 ]

When ext4 allocates blocks, we used to just go through the block groups
one by one to find a good one. But when there are tons of block groups
(like hundreds of thousands or even millions) and not many have free space
(meaning they're mostly full), it takes a really long time to check them
all, and performance gets bad. So, we added the "mb_optimize_scan" mount
option (which is on by default now). It keeps track of some group lists,
so when we need a free block, we can just grab a likely group from the
right list. This saves time and makes block allocation much faster.

But when multiple processes or containers are doing similar things, like
constantly allocating 8k blocks, they all try to use the same block group
in the same list. Even just two processes doing this can cut the IOPS in
half. For example, one container might do 300,000 IOPS, but if you run two
at the same time, the total is only 150,000.

Since we can already look at block groups in a non-linear way, the first
and last groups in the same list are basically the same for finding a block
right now. Therefore, add an ext4_try_lock_group() helper function to skip
the current group when it is locked by another process, thereby avoiding
contention with other processes. This helps ext4 make better use of having
multiple block groups.

Also, to make sure we don't skip all the groups that have free space
when allocating blocks, we won't try to skip busy groups anymore when
ac_criteria is CR_ANY_FREE.

Performance test data follows:

Test: Running will-it-scale/fallocate2 on CPU-bound containers.
Observation: Average fallocate operations per container per second.

|CPU: Kunpeng 920   |          P80            |
|Memory: 512GB      |-------------------------|
|960GB SSD (0.5GB/s)| base  |    patched      |
|-------------------|-------|-----------------|
|mb_optimize_scan=0 | 2667  | 4821  (+80.7%)  |
|mb_optimize_scan=1 | 2643  | 4784  (+81.0%)  |

|CPU: AMD 9654 * 2  |          P96            |
|Memory: 1536GB     |-------------------------|
|960GB SSD (1GB/s)  | base  |    patched      |
|-------------------|-------|-----------------|
|mb_optimize_scan=0 | 3450  | 15371 (+345%)   |
|mb_optimize_scan=1 | 3209  | 6101  (+90.0%)  |

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250714130327.1830534-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    | 23 ++++++++++++++---------
 fs/ext4/mballoc.c | 19 ++++++++++++++++---
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d8a059ec1ad62..822b18996a434 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3507,23 +3507,28 @@ static inline int ext4_fs_is_busy(struct ext4_sb_info *sbi)
 	return (atomic_read(&sbi->s_lock_busy) > EXT4_CONTENTION_THRESHOLD);
 }
 
+static inline bool ext4_try_lock_group(struct super_block *sb, ext4_group_t group)
+{
+	if (!spin_trylock(ext4_group_lock_ptr(sb, group)))
+		return false;
+	/*
+	 * We're able to grab the lock right away, so drop the lock
+	 * contention counter.
+	 */
+	atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, -1, 0);
+	return true;
+}
+
 static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
 {
-	spinlock_t *lock = ext4_group_lock_ptr(sb, group);
-	if (spin_trylock(lock))
-		/*
-		 * We're able to grab the lock right away, so drop the
-		 * lock contention counter.
-		 */
-		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, -1, 0);
-	else {
+	if (!ext4_try_lock_group(sb, group)) {
 		/*
 		 * The lock is busy, so bump the contention counter,
 		 * and then wait on the spin lock.
 		 */
 		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, 1,
 				  EXT4_MAX_CONTENTION);
-		spin_lock(lock);
+		spin_lock(ext4_group_lock_ptr(sb, group));
 	}
 }
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index edfffd15b2952..329fe83cbe814 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -913,7 +913,8 @@ static void ext4_mb_choose_next_group_p2_aligned(struct ext4_allocation_context
 				    bb_largest_free_order_node) {
 			if (sbi->s_mb_stats)
 				atomic64_inc(&sbi->s_bal_cX_groups_considered[CR_POWER2_ALIGNED]);
-			if (likely(ext4_mb_good_group(ac, iter->bb_group, CR_POWER2_ALIGNED))) {
+			if (!spin_is_locked(ext4_group_lock_ptr(ac->ac_sb, iter->bb_group)) &&
+			    likely(ext4_mb_good_group(ac, iter->bb_group, CR_POWER2_ALIGNED))) {
 				*group = iter->bb_group;
 				ac->ac_flags |= EXT4_MB_CR_POWER2_ALIGNED_OPTIMIZED;
 				read_unlock(&sbi->s_mb_largest_free_orders_locks[i]);
@@ -949,7 +950,8 @@ ext4_mb_find_good_group_avg_frag_lists(struct ext4_allocation_context *ac, int o
 	list_for_each_entry(iter, frag_list, bb_avg_fragment_size_node) {
 		if (sbi->s_mb_stats)
 			atomic64_inc(&sbi->s_bal_cX_groups_considered[cr]);
-		if (likely(ext4_mb_good_group(ac, iter->bb_group, cr))) {
+		if (!spin_is_locked(ext4_group_lock_ptr(ac->ac_sb, iter->bb_group)) &&
+		    likely(ext4_mb_good_group(ac, iter->bb_group, cr))) {
 			grp = iter;
 			break;
 		}
@@ -2910,6 +2912,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 							nr, &prefetch_ios);
 			}
 
+			/* prevent unnecessary buddy loading. */
+			if (cr < CR_ANY_FREE &&
+			    spin_is_locked(ext4_group_lock_ptr(sb, group)))
+				continue;
+
 			/* This now checks without needing the buddy page */
 			ret = ext4_mb_good_group_nolock(ac, group, cr);
 			if (ret <= 0) {
@@ -2922,7 +2929,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			if (err)
 				goto out;
 
-			ext4_lock_group(sb, group);
+			/* skip busy group */
+			if (cr >= CR_ANY_FREE) {
+				ext4_lock_group(sb, group);
+			} else if (!ext4_try_lock_group(sb, group)) {
+				ext4_mb_unload_buddy(&e4b);
+				continue;
+			}
 
 			/*
 			 * We need to check again after locking the
-- 
2.51.0



