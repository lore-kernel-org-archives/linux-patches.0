Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8B32D5408;
	Wed, 28 Jan 2026 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614545; cv=none; b=bqRscucTYlzUC2ytU2RBiS7JpIvGklJxjEfA1du4goJiqmEgExvb7DgkmxgOyFbbrcfNQOSHa7SXO/9WH77q2FmAqerpg4WFpMe2lK2ZNebxNnji0+e2WyD5TkD9kPCc2T/Qm+ZY4WsYfRSEPHqUhUG6VhXuEwiOvBTmC/1Srds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614545; c=relaxed/simple;
	bh=/VLHWouTnQ2RfbAE1kqhevZUteCjkeaOyDy0SX23oZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVOHVhgnGJ45LXI5ET10duZWkJwNLI/5cyW/mEzzQOK0zQ9/to0Yat3wa9eCaIPIkGRPTThDP2gEtA2IfUmQV4LsEuMrMwjbLn8efpzMVq78cxWaHc99xsMrPmJ1t+Y/GeqMU7+j+r0tv04NQFsa/ck3GqYMy5VuEElHUiqUhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVElD2yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVElD2yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1408FC4CEF1;
	Wed, 28 Jan 2026 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614545;
	bh=/VLHWouTnQ2RfbAE1kqhevZUteCjkeaOyDy0SX23oZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVElD2yzxdTWj8Npkd7m9vZCUXNeHigjpOaKbVdDpOo3+mrbwX+nS7s1+not2QzLi
	 mLTDDnaUPTQaOdFA5rW0MlMYUfTo8UKZ778gMEvjjnn/a6IcR+1oGVDG4GKmNRixSj
	 eiSrqEm8qq+IrpCX8feUAnjUSfbzFJ/a0CKMTj0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/254] mISDN: annotate data-race around dev->work
Date: Wed, 28 Jan 2026 16:22:24 +0100
Message-ID: <20260128145350.853405803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
index 83d6b484d3c6c..2ea1887ca2fa0 100644
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



