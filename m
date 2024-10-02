Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3351D0787;
	Wed,  2 Oct 2024 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876439; cv=none; b=mM3s0rsUydpcLUdq4EJBZcn8GdTIiyYsYY4sBSDI1g386BB1s6K0E+NcB7tmscpMk0e/I+fcH46KI3F9DWltCTDDXioEfXxdDg+zat3Brj18OFAFsXQXkyleK1V3Ry7LHscdtxZpCQXEDQLPyLVQigl5XWzSoEJ1aRi8c2pGMoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876439; c=relaxed/simple;
	bh=M0yYnU05VA/Fvpk66NUnNu2XmJef2kWM9uQUn/hrO08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umAVGJLtToAPn20B9fO5rmQfoVJ3iBGWxn/SjIswuU7sYyyq9ZfNailx1/ukDWRVumh5PHKiI/fArOHEiIY9sal6bHSHlw0Mt9P6KN/wZm/ZhuUtMELj6AYqeRTQg6VFRRSZ+ZCWCqiCIjjhqEdhs35Y9cWiqofgMd+YqI9od8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdfYeuCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdfYeuCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A43C4CEC5;
	Wed,  2 Oct 2024 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876439;
	bh=M0yYnU05VA/Fvpk66NUnNu2XmJef2kWM9uQUn/hrO08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdfYeuCC8b8INibuoQzSWjwBuW2EwqZmitb7Ql8nRP4WeSZAoYSL7itK9J4ZBXXi0
	 YM+gs1j5ZZAEAj1ffsZ/b+k8jRriR7uimHI6ozUfkfLeyPtX5kQUJ5jMFkg5PdAxUR
	 //ObGW4sI6Ha0LvY5q6NfCLoWNNVwwuWdR0wONUQ=
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
Subject: [PATCH 6.11 444/695] f2fs: fix to dont set SB_RDONLY in f2fs_handle_critical_error()
Date: Wed,  2 Oct 2024 14:57:22 +0200
Message-ID: <20241002125840.179296473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4e46cbd1fc2ba..80ce869d542c6 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4173,12 +4173,14 @@ void f2fs_handle_critical_error(struct f2fs_sb_info *sbi, unsigned char reason,
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



