Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B881581FC;
	Tue, 18 Jun 2024 13:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716017; cv=none; b=uiynW3Xc1OUuZuRC8MFcHdpYWFF4V0R5l8+SshK1djqUjPt85N9HUTb3GDdDHjFF/ojLEkDk93bsdyUqmNSUgwxWw7EEicQyhNNcxmdy3jb4jEUhOwpayIL5pC/gro0RwFfOpXseOrGZUm2OwXAbsHoqOZepSuZtx6XdbZWyRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716017; c=relaxed/simple;
	bh=clriOZ5a7xLTPiBgfi4mww4yMcGEDpUHo2D6g1N3aUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnLTtK5a/NQkOa8pNfuZ/0IFy3RgusHyrocYWCOP5sN0A74Qm6olMTGv0wV6+40qPAj9zg2sKOxqUP4prGdbvB0wmMG3EhLTDwrXyRb/P5VcMtbswNTcV/suHbrIGL2B8rZn86d+zhAfJAKIRLZkidBkOyZNue6/UZMewxBCUng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2W1WPlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2W1WPlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECDC3277B;
	Tue, 18 Jun 2024 13:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716017;
	bh=clriOZ5a7xLTPiBgfi4mww4yMcGEDpUHo2D6g1N3aUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2W1WPlqbEkZvw1P0J1Mu9+x1vncLPaIAaK4JW4J8gE8hLogFKBzVTH66jBy/gTyY
	 zPMvchemBkJeBEd/ONaC3X+vNaEa5+yGK1u4ygX9yLmAy7rrhWqdVbEIHg6aiZUGfd
	 bl6SjdkcxeoqQabemunuVfgTpIZkjxNJDS5gai8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 504/770] fanotify: use fsnotify group lock helpers
Date: Tue, 18 Jun 2024 14:35:57 +0200
Message-ID: <20240618123426.769099337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ab7a13686b49d..ad520a2796181 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1023,10 +1023,10 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
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
 
@@ -1036,7 +1036,7 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 		fsnotify_recalc_mask(fsn_mark->connector);
 	if (destroy_mark)
 		fsnotify_detach_mark(fsn_mark);
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 	if (destroy_mark)
 		fsnotify_free_mark(fsn_mark);
 
@@ -1184,13 +1184,13 @@ static int fanotify_add_mark(struct fsnotify_group *group,
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
@@ -1219,7 +1219,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 		fsnotify_recalc_mask(fsn_mark->connector);
 
 out:
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 
 	fsnotify_put_mark(fsn_mark);
 	return ret;
@@ -1373,7 +1373,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 
 	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
 	group = fsnotify_alloc_group(&fanotify_fsnotify_ops,
-				     FSNOTIFY_GROUP_USER);
+				     FSNOTIFY_GROUP_USER | FSNOTIFY_GROUP_NOFS);
 	if (IS_ERR(group)) {
 		return PTR_ERR(group);
 	}
-- 
2.43.0



