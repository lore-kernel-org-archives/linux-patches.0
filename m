Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697C43A6B6B;
	Wed,  8 Apr 2026 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672359; cv=none; b=fZMgm1wio/4oJ7Z5zsVSVMXp67Nvgj7gOXnOXEPhxIAn1K/skKVs1i8agoqqATN/9TKWV90C30MQwIcdebmnZV/hv9UwYkKSHCrLS89BAS75dCP2Y85J6w8pgvR7nKYWkEOrOXvoKla7nvzGQwAib00Ka45CC2iB8i5i0RTdgHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672359; c=relaxed/simple;
	bh=wToCIokKeR0cMbbaso93SnkxjYOYHDM4GnR0twfyO0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+FwYr9E0VfM4PXFom2xg1GjNl3e8xeKGj/GfnPY6rCowp5vE/IKfPhdXKWi8D1fnhxeMQd2bGYSnQ1AiOmJLj9OjdgpFTJKEg30DdZ8JghICx/SSbhmcnhFVZK8iu7flbtZzlCxGvp0hMxpbChTgQY6kA0LKKsKmcXUurRdVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0O8za54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0O8za54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96D6C19421;
	Wed,  8 Apr 2026 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672359;
	bh=wToCIokKeR0cMbbaso93SnkxjYOYHDM4GnR0twfyO0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0O8za548OfqxCozmzdWD78KaoFCT9pFoecC8x+d1Y2SWTInBAoK/49y/J5aVD8B9
	 pWaOq6EhfVpmiyH6uAvoolsBwLnji/C2WyfHJ4nXC8p28USGTrUVZNNHSSRMK0Y50V
	 AwmiEtBb752jAFvAoFjJ4QsFUdk09SCgKMy+Bpj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/312] ext4: fix the might_sleep() warnings in kvfree()
Date: Wed,  8 Apr 2026 20:03:26 +0200
Message-ID: <20260408175944.553866371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 496bb99b7e66f48b178126626f47e9ba79e2d0fa ]

Use the kvfree() in the RCU read critical section can trigger
the following warnings:

EXT4-fs (vdb): unmounting filesystem cd983e5b-3c83-4f5a-a136-17b00eb9d018.

WARNING: suspicious RCU usage

./include/linux/rcupdate.h:409 Illegal context switch in RCU read-side critical section!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1

Call Trace:
 <TASK>
 dump_stack_lvl+0xbb/0xd0
 dump_stack+0x14/0x20
 lockdep_rcu_suspicious+0x15a/0x1b0
 __might_resched+0x375/0x4d0
 ? put_object.part.0+0x2c/0x50
 __might_sleep+0x108/0x160
 vfree+0x58/0x910
 ? ext4_group_desc_free+0x27/0x270
 kvfree+0x23/0x40
 ext4_group_desc_free+0x111/0x270
 ext4_put_super+0x3c8/0xd40
 generic_shutdown_super+0x14c/0x4a0
 ? __pfx_shrinker_free+0x10/0x10
 kill_block_super+0x40/0x90
 ext4_kill_sb+0x6d/0xb0
 deactivate_locked_super+0xb4/0x180
 deactivate_super+0x7e/0xa0
 cleanup_mnt+0x296/0x3e0
 __cleanup_mnt+0x16/0x20
 task_work_run+0x157/0x250
 ? __pfx_task_work_run+0x10/0x10
 ? exit_to_user_mode_loop+0x6a/0x550
 exit_to_user_mode_loop+0x102/0x550
 do_syscall_64+0x44a/0x500
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

BUG: sleeping function called from invalid context at mm/vmalloc.c:3441
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 556, name: umount
preempt_count: 1, expected: 0
CPU: 3 UID: 0 PID: 556 Comm: umount
Call Trace:
 <TASK>
 dump_stack_lvl+0xbb/0xd0
 dump_stack+0x14/0x20
 __might_resched+0x275/0x4d0
 ? put_object.part.0+0x2c/0x50
 __might_sleep+0x108/0x160
 vfree+0x58/0x910
 ? ext4_group_desc_free+0x27/0x270
 kvfree+0x23/0x40
 ext4_group_desc_free+0x111/0x270
 ext4_put_super+0x3c8/0xd40
 generic_shutdown_super+0x14c/0x4a0
 ? __pfx_shrinker_free+0x10/0x10
 kill_block_super+0x40/0x90
 ext4_kill_sb+0x6d/0xb0
 deactivate_locked_super+0xb4/0x180
 deactivate_super+0x7e/0xa0
 cleanup_mnt+0x296/0x3e0
 __cleanup_mnt+0x16/0x20
 task_work_run+0x157/0x250
 ? __pfx_task_work_run+0x10/0x10
 ? exit_to_user_mode_loop+0x6a/0x550
 exit_to_user_mode_loop+0x102/0x550
 do_syscall_64+0x44a/0x500
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The above scenarios occur in initialization failures and teardown
paths, there are no parallel operations on the resources released
by kvfree(), this commit therefore remove rcu_read_lock/unlock() and
use rcu_access_pointer() instead of rcu_dereference() operations.

Fixes: 7c990728b99e ("ext4: fix potential race between s_flex_groups online resizing and access")
Fixes: df3da4ea5a0f ("ext4: fix potential race between s_group_info online resizing and access")
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260319094545.19291-1-qiang.zhang@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   10 +++-------
 fs/ext4/super.c   |    8 ++------
 2 files changed, 5 insertions(+), 13 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3298,9 +3298,7 @@ err_freebuddy:
 	rcu_read_unlock();
 	iput(sbi->s_buddy_cache);
 err_freesgi:
-	rcu_read_lock();
-	kvfree(rcu_dereference(sbi->s_group_info));
-	rcu_read_unlock();
+	kvfree(rcu_access_pointer(sbi->s_group_info));
 	return -ENOMEM;
 }
 
@@ -3597,7 +3595,8 @@ int ext4_mb_release(struct super_block *
 	flush_work(&sbi->s_discard_work);
 	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
 
-	if (sbi->s_group_info) {
+	group_info = rcu_access_pointer(sbi->s_group_info);
+	if (group_info) {
 		for (i = 0; i < ngroups; i++) {
 			cond_resched();
 			grinfo = ext4_get_group_info(sb, i);
@@ -3615,12 +3614,9 @@ int ext4_mb_release(struct super_block *
 		num_meta_group_infos = (ngroups +
 				EXT4_DESC_PER_BLOCK(sb) - 1) >>
 			EXT4_DESC_PER_BLOCK_BITS(sb);
-		rcu_read_lock();
-		group_info = rcu_dereference(sbi->s_group_info);
 		for (i = 0; i < num_meta_group_infos; i++)
 			kfree(group_info[i]);
 		kvfree(group_info);
-		rcu_read_unlock();
 	}
 	kfree(sbi->s_mb_avg_fragment_size);
 	kfree(sbi->s_mb_avg_fragment_size_locks);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1241,12 +1241,10 @@ static void ext4_group_desc_free(struct
 	struct buffer_head **group_desc;
 	int i;
 
-	rcu_read_lock();
-	group_desc = rcu_dereference(sbi->s_group_desc);
+	group_desc = rcu_access_pointer(sbi->s_group_desc);
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(group_desc[i]);
 	kvfree(group_desc);
-	rcu_read_unlock();
 }
 
 static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
@@ -1254,14 +1252,12 @@ static void ext4_flex_groups_free(struct
 	struct flex_groups **flex_groups;
 	int i;
 
-	rcu_read_lock();
-	flex_groups = rcu_dereference(sbi->s_flex_groups);
+	flex_groups = rcu_access_pointer(sbi->s_flex_groups);
 	if (flex_groups) {
 		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
 			kvfree(flex_groups[i]);
 		kvfree(flex_groups);
 	}
-	rcu_read_unlock();
 }
 
 static void ext4_put_super(struct super_block *sb)


