Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688493D75B3;
	Tue, 31 Mar 2026 16:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974581; cv=none; b=gZwrS/j6e/qt2wz7l5WGwvADTKn0SADM9lBeTPRKJCQkTv1kEaDItEuYJLTK5K6m7tjcv4BZ9qh1OK/1e9tKIHEUPXCLZunYLX90cRtL63KjXz8YVloSoy1wcBOnQ4STQSBWWkkQY3rawasiaIu7xdxRkxpRdV0eHXQZOAxLvqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974581; c=relaxed/simple;
	bh=G2GGGAAN+D0h0BBimYBL8hVbD8cAEgNWVKJ6aqndCwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx5k7Z9r9/SnwHOykjgdsJ1odxiL1DjzpCVZfmvR81K/3cLDbGDhhw/tGJk/4Uwnt+YxrnkhiKFmO+gcAmAb0ge2w9u6G9KdUdi+nIbKILCV4Sqs05E1VKJ80BGpTMgYl6uY071tengp2H2OKjIT7lZxUCRdoWXkHTaGAvHuRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjEuAIQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjEuAIQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F287EC19423;
	Tue, 31 Mar 2026 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974581;
	bh=G2GGGAAN+D0h0BBimYBL8hVbD8cAEgNWVKJ6aqndCwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjEuAIQpkXxVUeZCsYmL8Jgz0p31CyiQBYp44M8vCI1kQn4mq8n5lbcLPZ67wZlXX
	 9nYnKk3RPvw1Z5JNjyeOavlnAREmnIwGV5+66O+UHwiulgX1gLFUEP/Vp74JvrNHCc
	 eZQnXZeVyo//b8f+S9vPV9tnI44ndQozNYBw3iJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 139/175] ext4: fix the might_sleep() warnings in kvfree()
Date: Tue, 31 Mar 2026 18:22:03 +0200
Message-ID: <20260331161734.892118153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

commit 496bb99b7e66f48b178126626f47e9ba79e2d0fa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   10 +++-------
 fs/ext4/super.c   |    8 ++------
 2 files changed, 5 insertions(+), 13 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3502,9 +3502,7 @@ err_freebuddy:
 	rcu_read_unlock();
 	iput(sbi->s_buddy_cache);
 err_freesgi:
-	rcu_read_lock();
-	kvfree(rcu_dereference(sbi->s_group_info));
-	rcu_read_unlock();
+	kvfree(rcu_access_pointer(sbi->s_group_info));
 	return -ENOMEM;
 }
 
@@ -3803,7 +3801,8 @@ int ext4_mb_release(struct super_block *
 		WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
 	}
 
-	if (sbi->s_group_info) {
+	group_info = rcu_access_pointer(sbi->s_group_info);
+	if (group_info) {
 		for (i = 0; i < ngroups; i++) {
 			cond_resched();
 			grinfo = ext4_get_group_info(sb, i);
@@ -3821,12 +3820,9 @@ int ext4_mb_release(struct super_block *
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
@@ -1266,12 +1266,10 @@ static void ext4_group_desc_free(struct
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
@@ -1279,14 +1277,12 @@ static void ext4_flex_groups_free(struct
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


