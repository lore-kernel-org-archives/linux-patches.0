Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B0D2EE60B;
	Tue, 17 Jun 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177629; cv=none; b=HoX0i0k4KUZtHgZs25WqgVCNRZBOQ/huECtpNTnGsnZpvPOlhBOdZYtntreUgwV8LI1kWSMMVJhkXPSjL4NVC1fbIgUD63BslNXrVIdy9/9plSnqBkfR5keLXmTGdr5Br7YSLQpV9NpYHAElzzGmGDA0Fn2tbEGgnGqqiH5rrJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177629; c=relaxed/simple;
	bh=SXoZo2Ngs0fS6q+UX/70oAv5f78zWGcQTNDlz3zVTTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyXPVUw71Y1XHOxfXXJOCCJ0vEtZwDbYpUwI2LUIk7vPpjnSr6hcrnUUjShi8ktUa0nkGX9bGo70hEN8nvsCKYMpOw8piIbdixpOCZP5uvpf8KCplc6KOsLrfrEL/lPz/LWkDokWd9sV+T5T4oBMy+X/t2wzvdBMC2FMf6qPOz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppBTJFw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppBTJFw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7309C4CEE7;
	Tue, 17 Jun 2025 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177629;
	bh=SXoZo2Ngs0fS6q+UX/70oAv5f78zWGcQTNDlz3zVTTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppBTJFw4iL3jkO7vmzgcFxr9C5Ikiz28bcd2K50UVb1+MOphPbAkT1+nWFJKFoOjV
	 l5bpQtZ/f5BMktgG237dxUyqL0Yc62MZ7jBY0c46yuLYq9meAXaTgg/9CvdcL1Nmzw
	 WV81nbyE9e18udZP1VWFEf91xI2R8BdoKo5+bAJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa5bb5f6860e08a60450@syzkaller.appspotmail.com,
	Qi Han <hanqi@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 338/780] f2fs: fix to skip f2fs_balance_fs() if checkpoint is disabled
Date: Tue, 17 Jun 2025 17:20:46 +0200
Message-ID: <20250617152505.216746274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit c836d3b8d94e3dd381e7d4bb918875084f85715e ]

Syzbot reports a f2fs bug as below:

INFO: task syz-executor328:5856 blocked for more than 144 seconds.
      Not tainted 6.15.0-rc6-syzkaller-00208-g3c21441eeffc #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor328 state:D stack:24392 pid:5856  tgid:5832  ppid:5826   task_flags:0x400040 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5382 [inline]
 __schedule+0x168f/0x4c70 kernel/sched/core.c:6767
 __schedule_loop kernel/sched/core.c:6845 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6860
 io_schedule+0x81/0xe0 kernel/sched/core.c:7742
 f2fs_balance_fs+0x4b4/0x780 fs/f2fs/segment.c:444
 f2fs_map_blocks+0x3af1/0x43b0 fs/f2fs/data.c:1791
 f2fs_expand_inode_data+0x653/0xaf0 fs/f2fs/file.c:1872
 f2fs_fallocate+0x4f5/0x990 fs/f2fs/file.c:1975
 vfs_fallocate+0x6a0/0x830 fs/open.c:338
 ioctl_preallocate fs/ioctl.c:290 [inline]
 file_ioctl fs/ioctl.c:-1 [inline]
 do_vfs_ioctl+0x1b8f/0x1eb0 fs/ioctl.c:885
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The root cause is after commit 84b5bb8bf0f6 ("f2fs: modify
f2fs_is_checkpoint_ready logic to allow more data to be written with the
CP disable"), we will get chance to allow f2fs_is_checkpoint_ready() to
return true once below conditions are all true:
1. checkpoint is disabled
2. there are not enough free segments
3. there are enough free blocks

Then it will cause f2fs_balance_fs() to trigger foreground GC.

void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need)
...
	if (!f2fs_is_checkpoint_ready(sbi))
		return;

And the testcase mounts f2fs image w/ gc_merge,checkpoint=disable, so deadloop
will happen through below race condition:

- f2fs_do_shutdown		- vfs_fallocate				- gc_thread_func
				 - file_start_write
				  - __sb_start_write(SB_FREEZE_WRITE)
				 - f2fs_fallocate
				  - f2fs_expand_inode_data
				   - f2fs_map_blocks
				    - f2fs_balance_fs
				     - prepare_to_wait
				     - wake_up(gc_wait_queue_head)
				     - io_schedule
 - bdev_freeze
  - freeze_super
   - sb->s_writers.frozen = SB_FREEZE_WRITE;
   - sb_wait_write(sb, SB_FREEZE_WRITE);
									 - if (sbi->sb->s_writers.frozen >= SB_FREEZE_WRITE) continue;
									 : cause deadloop

This patch fix to add check condition in f2fs_balance_fs(), so that if
checkpoint is disabled, we will just skip trigger foreground GC to
avoid such deadloop issue.

Meanwhile let's remove f2fs_is_checkpoint_ready() check condition in
f2fs_balance_fs(), since it's redundant, due to the main logic in the
function is to check:
a) whether checkpoint is disabled
b) there is enough free segments

f2fs_balance_fs() still has all logics after f2fs_is_checkpoint_ready()'s
removal.

Reported-by: syzbot+aa5bb5f6860e08a60450@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/682d743a.a00a0220.29bc26.0289.GAE@google.com
Fixes: 84b5bb8bf0f6 ("f2fs: modify f2fs_is_checkpoint_ready logic to allow more data to be written with the CP disable")
Cc: Qi Han <hanqi@vivo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2a71e70c9ac97..41ca73622c8d4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -424,7 +424,7 @@ void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need)
 	if (need && excess_cached_nats(sbi))
 		f2fs_balance_fs_bg(sbi, false);
 
-	if (!f2fs_is_checkpoint_ready(sbi))
+	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
 		return;
 
 	/*
-- 
2.39.5



