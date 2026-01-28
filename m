Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F532143F;
	Wed, 28 Jan 2026 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615102; cv=none; b=FTzddqGaecKu3LBKuQuxRu9Sl6GfdGWe6+OTNPhqt3qZMpHN43UFrHELnMDkHmi8YQ62aK1HLtdELyii5Q2ttZjOxXRllpXJEMPrErLBx5dCew0OBTUpSixqHnfwb6CHBKj5gYfb2zRTsJQttiyqZvxXhCEeRNcdOZSd37+KgCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615102; c=relaxed/simple;
	bh=wet5orXTQmBD8LV6oWwLucmeZNMJFcQ7yyEMUN4yxV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTbW9oW7iGUXIhqlF0JdEC7KJp+xjslCVP0sKQV64xN0J2ISeYDxLsvbp4tOAfcXoGnHhgFqHIsnz/njJfB9xoxlXmfyg7/AZ36y+x0SU9iSJ29fy2nMS4KCUMCVAiGu6Yygt+xw3L4Md1arqkhep2EYvZGu7EadFgeAZG6Rhjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM6zj5GX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM6zj5GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42101C4CEF1;
	Wed, 28 Jan 2026 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615102;
	bh=wet5orXTQmBD8LV6oWwLucmeZNMJFcQ7yyEMUN4yxV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GM6zj5GXXrasmRX75ZJ9Fed4PM4pzdgtWJlReW9xYNS4jn0Ay8v3+IJyQ5dXXoWPR
	 zqf1wbbCHLbLLpmDxCui7P0NG6uzlqgzX16TZb2M7XElFMVKXZJ9o/U3T1m+/mrk5S
	 xSAqB3johPlh8dlFfQ91DetMA90HDnJYpz3mJAuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/169] mISDN: annotate data-race around dev->work
Date: Wed, 28 Jan 2026 16:22:41 +0100
Message-ID: <20260128145336.815209877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8175dbf174d487afab81e936a862a8d9b8a1ccb6 ]

dev->work can re read locklessly in mISDN_read()
and mISDN_poll(). Add READ_ONCE()/WRITE_ONCE() annotations.

BUG: KCSAN: data-race in mISDN_ioctl / mISDN_read

write to 0xffff88812d848280 of 4 bytes by task 10864 on cpu 1:
  misdn_add_timer drivers/isdn/mISDN/timerdev.c:175 [inline]
  mISDN_ioctl+0x2fb/0x550 drivers/isdn/mISDN/timerdev.c:233
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:597 [inline]
  __se_sys_ioctl+0xce/0x140 fs/ioctl.c:583
  __x64_sys_ioctl+0x43/0x50 fs/ioctl.c:583
  x64_sys_call+0x14b0/0x3000 arch/x86/include/generated/asm/syscalls_64.h:17
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xd8/0x2c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88812d848280 of 4 bytes by task 10857 on cpu 0:
  mISDN_read+0x1f2/0x470 drivers/isdn/mISDN/timerdev.c:112
  do_loop_readv_writev fs/read_write.c:847 [inline]
  vfs_readv+0x3fb/0x690 fs/read_write.c:1020
  do_readv+0xe7/0x210 fs/read_write.c:1080
  __do_sys_readv fs/read_write.c:1165 [inline]
  __se_sys_readv fs/read_write.c:1162 [inline]
  __x64_sys_readv+0x45/0x50 fs/read_write.c:1162
  x64_sys_call+0x2831/0x3000 arch/x86/include/generated/asm/syscalls_64.h:20
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xd8/0x2c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00000000 -> 0x00000001

Fixes: 1b2b03f8e514 ("Add mISDN core files")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260118132528.2349573-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/timerdev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 7cfa8c61dba0a..b2df23234ed3c 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -109,14 +109,14 @@ mISDN_read(struct file *filep, char __user *buf, size_t count, loff_t *off)
 		spin_unlock_irq(&dev->lock);
 		if (filep->f_flags & O_NONBLOCK)
 			return -EAGAIN;
-		wait_event_interruptible(dev->wait, (dev->work ||
+		wait_event_interruptible(dev->wait, (READ_ONCE(dev->work) ||
 						     !list_empty(list)));
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 		spin_lock_irq(&dev->lock);
 	}
 	if (dev->work)
-		dev->work = 0;
+		WRITE_ONCE(dev->work, 0);
 	if (!list_empty(list)) {
 		timer = list_first_entry(list, struct mISDNtimer, list);
 		list_del(&timer->list);
@@ -141,13 +141,16 @@ mISDN_poll(struct file *filep, poll_table *wait)
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %p)\n", __func__, filep, wait);
 	if (dev) {
+		u32 work;
+
 		poll_wait(filep, &dev->wait, wait);
 		mask = 0;
-		if (dev->work || !list_empty(&dev->expired))
+		work = READ_ONCE(dev->work);
+		if (work || !list_empty(&dev->expired))
 			mask |= (EPOLLIN | EPOLLRDNORM);
 		if (*debug & DEBUG_TIMER)
 			printk(KERN_DEBUG "%s work(%d) empty(%d)\n", __func__,
-			       dev->work, list_empty(&dev->expired));
+			       work, list_empty(&dev->expired));
 	}
 	return mask;
 }
@@ -172,7 +175,7 @@ misdn_add_timer(struct mISDNtimerdev *dev, int timeout)
 	struct mISDNtimer	*timer;
 
 	if (!timeout) {
-		dev->work = 1;
+		WRITE_ONCE(dev->work, 1);
 		wake_up_interruptible(&dev->wait);
 		id = 0;
 	} else {
-- 
2.51.0



