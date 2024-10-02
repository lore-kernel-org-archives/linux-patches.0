Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC721D079C;
	Wed,  2 Oct 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880109; cv=none; b=n0DZciNxxMMxu3UulnfwGcTroIbh/Ta0CSDRiLPxdnctjJvhVhiyMB5OqDMozWFzn9AsA+5NN+N5O7kp8FsRiVRHInIxXVu3r6j8fq9gm/VCF8pIk+uIu9m5WjVgJ0NSzEoPHHXHg3BoYkwyXTeoc/7ph9vSaJ8++6x2ChB6P54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880109; c=relaxed/simple;
	bh=QyWm6Lbw3XT4ZqEOywm5CMzy3TqRSZMxlqQ+OX/HnmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ/0ozgZuGk/M5YpZoL2xBnql+fWRTaPGEiWuoNKI8K6vhc+l53hB9oEfuvRyyCG5VaPPnmsft4eJoiBfx9f9X+Na+Z6XgyJE4I0DR6ER5svKkxRo5PJc/o2EgFiLiWpd+rQgZ9x4cV3CFHsbtDaQ2JmuZYjP+RkKDN96BYd2sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhEhvwrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhEhvwrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6822CC4CECF;
	Wed,  2 Oct 2024 14:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880108;
	bh=QyWm6Lbw3XT4ZqEOywm5CMzy3TqRSZMxlqQ+OX/HnmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhEhvwrGBr7TqbfbBBXojAU+F9j9qOafKHk3lU9VlxIb1W+ZXV7Q8zjfl2xqmufnu
	 8vQHkQmWWKtyv8lBk/JeEtbXOXyQSmrYylU9ywmeLn/Cr7JNtwMVlh1ADpd8+wrpa3
	 8eODCBMX97FT+3TbIMph2/WZnvnSHMl3A0oplu58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20d7e439f76bbbd863a7@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 347/538] f2fs: fix to dont set SB_RDONLY in f2fs_handle_critical_error()
Date: Wed,  2 Oct 2024 14:59:46 +0200
Message-ID: <20241002125806.127940865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 930c6ab93492c4b15436524e704950b364b2930c ]

syzbot reports a f2fs bug as below:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 58 at kernel/rcu/sync.c:177 rcu_sync_dtor+0xcd/0x180 kernel/rcu/sync.c:177
CPU: 1 UID: 0 PID: 58 Comm: kworker/1:2 Not tainted 6.10.0-syzkaller-12562-g1722389b0d86 #0
Workqueue: events destroy_super_work
RIP: 0010:rcu_sync_dtor+0xcd/0x180 kernel/rcu/sync.c:177
Call Trace:
 percpu_free_rwsem+0x41/0x80 kernel/locking/percpu-rwsem.c:42
 destroy_super_work+0xec/0x130 fs/super.c:282
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

As Christian Brauner pointed out [1]: the root cause is f2fs sets
SB_RDONLY flag in internal function, rather than setting the flag
covered w/ sb->s_umount semaphore via remount procedure, then below
race condition causes this bug:

- freeze_super()
 - sb_wait_write(sb, SB_FREEZE_WRITE)
 - sb_wait_write(sb, SB_FREEZE_PAGEFAULT)
 - sb_wait_write(sb, SB_FREEZE_FS)
					- f2fs_handle_critical_error
					 - sb->s_flags |= SB_RDONLY
- thaw_super
 - thaw_super_locked
  - sb_rdonly() is true, so it skips
    sb_freeze_unlock(sb, SB_FREEZE_FS)
  - deactivate_locked_super

Since f2fs has almost the same logic as ext4 [2] when handling critical
error in filesystem if it mounts w/ errors=remount-ro option:
- set CP_ERROR_FLAG flag which indicates filesystem is stopped
- record errors to superblock
- set SB_RDONLY falg
Once we set CP_ERROR_FLAG flag, all writable interfaces can detect the
flag and stop any further updates on filesystem. So, it is safe to not
set SB_RDONLY flag, let's remove the logic and keep in line w/ ext4 [3].

[1] https://lore.kernel.org/all/20240729-himbeeren-funknetz-96e62f9c7aee@brauner
[2] https://lore.kernel.org/all/20240729132721.hxih6ehigadqf7wx@quack3
[3] https://lore.kernel.org/linux-ext4/20240805201241.27286-1-jack@suse.cz

Fixes: b62e71be2110 ("f2fs: support errors=remount-ro|continue|panic mountoption")
Reported-by: syzbot+20d7e439f76bbbd863a7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b90a8e061e21d12f@google.com/
Cc: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2bec5176df65d..37fa7e32835a3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4137,12 +4137,14 @@ void f2fs_handle_critical_error(struct f2fs_sb_info *sbi, unsigned char reason,
 	}
 
 	f2fs_warn(sbi, "Remounting filesystem read-only");
+
 	/*
-	 * Make sure updated value of ->s_mount_flags will be visible before
-	 * ->s_flags update
+	 * We have already set CP_ERROR_FLAG flag to stop all updates
+	 * to filesystem, so it doesn't need to set SB_RDONLY flag here
+	 * because the flag should be set covered w/ sb->s_umount semaphore
+	 * via remount procedure, otherwise, it will confuse code like
+	 * freeze_super() which will lead to deadlocks and other problems.
 	 */
-	smp_wmb();
-	sb->s_flags |= SB_RDONLY;
 }
 
 static void f2fs_record_error_work(struct work_struct *work)
-- 
2.43.0



