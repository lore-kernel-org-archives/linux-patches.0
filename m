Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FBA73466;
	Tue, 27 Aug 2024 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771079; cv=none; b=lRpucAbzArej0Xbd/fB9V5NlNkPEbKBu6inp1GqJeI0efoKGJgibKEfvrFixbFfaQWEG5V00RWWMYpQBFOX4GV8lXLiJ6a9bsreULgW48f3PDCCTEhmieVUyVXZ4f3sUGUVk0I+ghhp4fqMFrRaLwokgV7pZMNWBzhUgccyoBGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771079; c=relaxed/simple;
	bh=XTg4ck2+XtfpzyXadXdaSaWygskpYvLln/thlaZkeK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FswWdxNSqNBBn7qE9mpvUJrP+ehSnWQ4jW1Lla4+d8CysWWG4qdRRm01GHP2B7qtCp7oOLn+ZEnFzH6D874v+xp6MSkAK5fKT9XNCRWm6k57QbGbLsPJEZDwIR9nGsGfL1D47zIwZvTVJAEG8UdZdKUraXkMYJzlaamZyE1mFbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LarUD0zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LarUD0zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780ADC6105B;
	Tue, 27 Aug 2024 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771079;
	bh=XTg4ck2+XtfpzyXadXdaSaWygskpYvLln/thlaZkeK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LarUD0zhR7w2vTah9qx7IuOawfuBiHghIc6TFjTzjwDwf34s/9UyUOg5yEaCDxR+i
	 FVRwOcS/hN93EahLeq5Ovq/M8SaMdwKxVKY8Zdz+a/PekyCqoQen6mi4eWzspsciHi
	 wyIpscFGr5PhYZleWmAVY0XovT8UtPE1c/1P0Hm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kzd <kzd@56709.net>,
	Octavia Togami <octavia.togami@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 063/273] btrfs: only run the extent map shrinker from kswapd tasks
Date: Tue, 27 Aug 2024 16:36:27 +0200
Message-ID: <20240827143835.805799008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit ae1e766f623f7a2a889a0b09eb076dd9a60efbe9 upstream.

Currently the extent map shrinker can be run by any task when attempting
to allocate memory and there's enough memory pressure to trigger it.

To avoid too much latency we stop iterating over extent maps and removing
them once the task needs to reschedule. This logic was introduced in commit
b3ebb9b7e92a ("btrfs: stop extent map shrinker if reschedule is needed").

While that solved high latency problems for some use cases, it's still
not enough because with a too high number of tasks entering the extent map
shrinker code, either due to memory allocations or because they are a
kswapd task, we end up having a very high level of contention on some
spin locks, namely:

1) The fs_info->fs_roots_radix_lock spin lock, which we need to find
   roots to iterate over their inodes;

2) The spin lock of the xarray used to track open inodes for a root
   (struct btrfs_root::inodes) - on 6.10 kernels and below, it used to
   be a red black tree and the spin lock was root->inode_lock;

3) The fs_info->delayed_iput_lock spin lock since the shrinker adds
   delayed iputs (calls btrfs_add_delayed_iput()).

Instead of allowing the extent map shrinker to be run by any task, make
it run only by kswapd tasks. This still solves the problem of running
into OOM situations due to an unbounded extent map creation, which is
simple to trigger by direct IO writes, as described in the changelog
of commit 956a17d9d050 ("btrfs: add a shrinker for extent maps"), and
by a similar case when doing buffered IO on files with a very large
number of holes (keeping the file open and creating many holes, whose
extent maps are only released when the file is closed).

Reported-by: kzd <kzd@56709.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219121
Reported-by: Octavia Togami <octavia.togami@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAHPNGSSt-a4ZZWrtJdVyYnJFscFjP9S7rMcvEMaNSpR556DdLA@mail.gmail.com/
Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
CC: stable@vger.kernel.org # 6.10+
Tested-by: kzd <kzd@56709.net>
Tested-by: Octavia Togami <octavia.togami@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |   22 ++++++----------------
 fs/btrfs/super.c      |   10 ++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1065,8 +1065,7 @@ static long btrfs_scan_inode(struct btrf
 		return 0;
 
 	/*
-	 * We want to be fast because we can be called from any path trying to
-	 * allocate memory, so if the lock is busy we don't want to spend time
+	 * We want to be fast so if the lock is busy we don't want to spend time
 	 * waiting for it - either some task is about to do IO for the inode or
 	 * we may have another task shrinking extent maps, here in this code, so
 	 * skip this inode.
@@ -1109,9 +1108,7 @@ next:
 		/*
 		 * Stop if we need to reschedule or there's contention on the
 		 * lock. This is to avoid slowing other tasks trying to take the
-		 * lock and because the shrinker might be called during a memory
-		 * allocation path and we want to avoid taking a very long time
-		 * and slowing down all sorts of tasks.
+		 * lock.
 		 */
 		if (need_resched() || rwlock_needbreak(&tree->lock))
 			break;
@@ -1139,12 +1136,7 @@ static long btrfs_scan_root(struct btrfs
 		if (ctx->scanned >= ctx->nr_to_scan)
 			break;
 
-		/*
-		 * We may be called from memory allocation paths, so we don't
-		 * want to take too much time and slowdown tasks.
-		 */
-		if (need_resched())
-			break;
+		cond_resched();
 
 		inode = btrfs_find_first_inode(root, min_ino);
 	}
@@ -1202,14 +1194,12 @@ long btrfs_free_extent_maps(struct btrfs
 							   ctx.last_ino);
 	}
 
-	/*
-	 * We may be called from memory allocation paths, so we don't want to
-	 * take too much time and slowdown tasks, so stop if we need reschedule.
-	 */
-	while (ctx.scanned < ctx.nr_to_scan && !need_resched()) {
+	while (ctx.scanned < ctx.nr_to_scan) {
 		struct btrfs_root *root;
 		unsigned long count;
 
+		cond_resched();
+
 		spin_lock(&fs_info->fs_roots_radix_lock);
 		count = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
 					       (void **)&root,
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -28,6 +28,7 @@
 #include <linux/btrfs.h>
 #include <linux/security.h>
 #include <linux/fs_parser.h>
+#include <linux/swap.h>
 #include "messages.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -2394,6 +2395,15 @@ static long btrfs_free_cached_objects(st
 	const long nr_to_scan = min_t(unsigned long, LONG_MAX, sc->nr_to_scan);
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 
+	/*
+	 * We may be called from any task trying to allocate memory and we don't
+	 * want to slow it down with scanning and dropping extent maps. It would
+	 * also cause heavy lock contention if many tasks concurrently enter
+	 * here. Therefore only allow kswapd tasks to scan and drop extent maps.
+	 */
+	if (!current_is_kswapd())
+		return 0;
+
 	return btrfs_free_extent_maps(fs_info, nr_to_scan);
 }
 


