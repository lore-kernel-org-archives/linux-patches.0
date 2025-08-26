Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63241A23BB;
	Tue, 26 Aug 2025 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208992; cv=none; b=E++5+DMGBsdLuMxetc1S8XeZWTz5e98YxsOED02PGTJA90FPCede25lUmaaZ2TvrvZ/RHNjMP0OUXitVx5+GMJoaG0p0jHWngyTJ07DedB3VOiIwdeyzLNet2zsf7GlB7pTnFMBGujZAdAifkTubWrjNKRtmJDJnXG3EVSfsqd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208992; c=relaxed/simple;
	bh=lXQyYum5Bf9rqjayvLCNnNKCn9wRjDMCVvkb1VybaWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HifRn6erRcmAmpu3CZI2PJ0InrdgHuDLFpy2EIDM2X9vBk9IuGZWdplgKx8iZfCSkFsDf/qm/IYXmo+iH0poR7SlRvEbK3MaOmLBfmO3ZVzLUdvS8wyZbYlMkNZAAIJY27M7VKhgkahjxOwNVGyj+uGGVGTU8SoK2KbzRFrIrl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFFv0d+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFFv0d+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42DBC4CEF1;
	Tue, 26 Aug 2025 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208992;
	bh=lXQyYum5Bf9rqjayvLCNnNKCn9wRjDMCVvkb1VybaWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFFv0d+F3WzJerZsFZTA9CM3PTX9GlW+HeqWrJYQ5ItEjHb2StelNfrORqc3Jk6YA
	 y9uRl38ctROaQFZhh3n+dk52pjG7OJlA3uzUlvoPExkgg6SzZrD9aBKWDxtcj9CyO9
	 WNhPkLkpIoi+3IpBLORlSrhIOUTJXfx9/0HZspOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dewei Meng <mengdewei@cqsoftware.com.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/322] ALSA: timer: fix ida_free call while not allocated
Date: Tue, 26 Aug 2025 13:12:04 +0200
Message-ID: <20250826110923.524270102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dewei Meng <mengdewei@cqsoftware.com.cn>

[ Upstream commit 5003a65790ed66be882d1987cc2ca86af0de3db1 ]

In the snd_utimer_create() function, if the kasprintf() function return
NULL, snd_utimer_put_id() will be called, finally use ida_free()
to free the unallocated id 0.

the syzkaller reported the following information:
  ------------[ cut here ]------------
  ida_free called for id=0 which is not allocated.
  WARNING: CPU: 1 PID: 1286 at lib/idr.c:592 ida_free+0x1fd/0x2f0 lib/idr.c:592
  Modules linked in:
  CPU: 1 UID: 0 PID: 1286 Comm: syz-executor164 Not tainted 6.15.8 #3 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.fc42 04/01/2014
  RIP: 0010:ida_free+0x1fd/0x2f0 lib/idr.c:592
  Code: f8 fc 41 83 fc 3e 76 69 e8 70 b2 f8 (...)
  RSP: 0018:ffffc900007f79c8 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: 1ffff920000fef3b RCX: ffffffff872176a5
  RDX: ffff88800369d200 RSI: 0000000000000000 RDI: ffff88800369d200
  RBP: 0000000000000000 R08: ffffffff87ba60a5 R09: 0000000000000000
  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
  R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007f6f1abc1740(0000) GS:ffff8880d76a0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f6f1ad7a784 CR3: 000000007a6e2000 CR4: 00000000000006f0
  Call Trace:
   <TASK>
   snd_utimer_put_id sound/core/timer.c:2043 [inline] [snd_timer]
   snd_utimer_create+0x59b/0x6a0 sound/core/timer.c:2184 [snd_timer]
   snd_utimer_ioctl_create sound/core/timer.c:2202 [inline] [snd_timer]
   __snd_timer_user_ioctl.isra.0+0x724/0x1340 sound/core/timer.c:2287 [snd_timer]
   snd_timer_user_ioctl+0x75/0xc0 sound/core/timer.c:2298 [snd_timer]
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:907 [inline]
   __se_sys_ioctl fs/ioctl.c:893 [inline]
   __x64_sys_ioctl+0x198/0x200 fs/ioctl.c:893
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x7b/0x160 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [...]

The utimer->id should be set properly before the kasprintf() function,
ensures the snd_utimer_put_id() function will free the allocated id.

Fixes: 37745918e0e75 ("ALSA: timer: Introduce virtual userspace-driven timers")
Signed-off-by: Dewei Meng <mengdewei@cqsoftware.com.cn>
Link: https://patch.msgid.link/20250821014317.40786-1-mengdewei@cqsoftware.com.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index d774b9b71ce2..a0dcb4ebb059 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -2139,14 +2139,14 @@ static int snd_utimer_create(struct snd_timer_uinfo *utimer_info,
 		goto err_take_id;
 	}
 
+	utimer->id = utimer_id;
+
 	utimer->name = kasprintf(GFP_KERNEL, "snd-utimer%d", utimer_id);
 	if (!utimer->name) {
 		err = -ENOMEM;
 		goto err_get_name;
 	}
 
-	utimer->id = utimer_id;
-
 	tid.dev_sclass = SNDRV_TIMER_SCLASS_APPLICATION;
 	tid.dev_class = SNDRV_TIMER_CLASS_GLOBAL;
 	tid.card = -1;
-- 
2.50.1



