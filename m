Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F41952F7D;
	Mon,  8 Apr 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583908; cv=none; b=InTQzjIuXQ1BndlSz7E8nPPNi8hcmp6OFZCqQswiqfsItJY+hJKAaW19DBJErnoNCSsz+0YegYKzEvYJxz9s5V1cXJnc8SlywkVuvsKjVZEcm91PrepWuwCv7PaRkuzR9LMhr09U0hSCmF3i/8Cq0NHDMlISGWwyaad5F9WLbOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583908; c=relaxed/simple;
	bh=DI3We5MnRcV16THW/aMJvGwlXmSb+i8HefLagXR+nPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=occiKm8TN/rUrirFsndGqPY6ro+md8majnOxWFgsHc/WWtTcEGDSNM1M9+tTN0IasMRB1maW+JTXx8EcCzXgG7UOwXohYPAm34dAl38F5pfPnl89rCwcN9f+674jaTVzEEX57NzlqaGTH6IsbecWHhzpG6o6ijwR4gQgshmR35s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM5g+jvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM5g+jvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9531C433F1;
	Mon,  8 Apr 2024 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583908;
	bh=DI3We5MnRcV16THW/aMJvGwlXmSb+i8HefLagXR+nPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM5g+jvGJON/JA4GfxG7MQtwQtQVXy7uRZ+iaUma2n5yNGSsZxM0sHSxn+R3KY942
	 jaWjJ+t/MDS1BAXe4OATPyWdqktMW6UQsDiUTcTByLFI5AZMCkauKUmJQXEXiYGN5k
	 kiqi6K4tf3O9A5+OyAFmLxwGRBHA2PpV2Jy5D2eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 301/690] fanotify: use fsnotify group lock helpers
Date: Mon,  8 Apr 2024 14:52:47 +0200
Message-ID: <20240408125410.504645219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit e79719a2ca5c61912c0493bc1367db52759cf6fd ]

Direct reclaim from fanotify mark allocation context may try to evict
inodes with evictable marks of the same group and hit this deadlock:

[<0>] fsnotify_destroy_mark+0x1f/0x3a
[<0>] fsnotify_destroy_marks+0x71/0xd9
[<0>] __destroy_inode+0x24/0x7e
[<0>] destroy_inode+0x2c/0x67
[<0>] dispose_list+0x49/0x68
[<0>] prune_icache_sb+0x5b/0x79
[<0>] super_cache_scan+0x11c/0x16f
[<0>] shrink_slab.constprop.0+0x23e/0x40f
[<0>] shrink_node+0x218/0x3e7
[<0>] do_try_to_free_pages+0x12a/0x2d2
[<0>] try_to_free_pages+0x166/0x242
[<0>] __alloc_pages_slowpath.constprop.0+0x30c/0x903
[<0>] __alloc_pages+0xeb/0x1c7
[<0>] cache_grow_begin+0x6f/0x31e
[<0>] fallback_alloc+0xe0/0x12d
[<0>] ____cache_alloc_node+0x15a/0x17e
[<0>] kmem_cache_alloc_trace+0xa1/0x143
[<0>] fanotify_add_mark+0xd5/0x2b2
[<0>] do_fanotify_mark+0x566/0x5eb
[<0>] __x64_sys_fanotify_mark+0x21/0x24
[<0>] do_syscall_64+0x6d/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Set the FSNOTIFY_GROUP_NOFS flag to prevent going into direct reclaim
from allocations under fanotify group lock and use the safe group lock
helpers.

Link: https://lore.kernel.org/r/20220422120327.3459282-16-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9bb182dc3f9b3..b4d16caa98d80 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1031,10 +1031,10 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 	__u32 removed;
 	int destroy_mark;
 
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	fsn_mark = fsnotify_find_mark(connp, group);
 	if (!fsn_mark) {
-		mutex_unlock(&group->mark_mutex);
+		fsnotify_group_unlock(group);
 		return -ENOENT;
 	}
 
@@ -1044,7 +1044,7 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 		fsnotify_recalc_mask(fsn_mark->connector);
 	if (destroy_mark)
 		fsnotify_detach_mark(fsn_mark);
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 	if (destroy_mark)
 		fsnotify_free_mark(fsn_mark);
 
@@ -1192,13 +1192,13 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 	bool recalc;
 	int ret = 0;
 
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	fsn_mark = fsnotify_find_mark(connp, group);
 	if (!fsn_mark) {
 		fsn_mark = fanotify_add_new_mark(group, connp, obj_type,
 						 fan_flags, fsid);
 		if (IS_ERR(fsn_mark)) {
-			mutex_unlock(&group->mark_mutex);
+			fsnotify_group_unlock(group);
 			return PTR_ERR(fsn_mark);
 		}
 	}
@@ -1227,7 +1227,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 		fsnotify_recalc_mask(fsn_mark->connector);
 
 out:
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 
 	fsnotify_put_mark(fsn_mark);
 	return ret;
@@ -1381,7 +1381,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 
 	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
 	group = fsnotify_alloc_group(&fanotify_fsnotify_ops,
-				     FSNOTIFY_GROUP_USER);
+				     FSNOTIFY_GROUP_USER | FSNOTIFY_GROUP_NOFS);
 	if (IS_ERR(group)) {
 		return PTR_ERR(group);
 	}
-- 
2.43.0



