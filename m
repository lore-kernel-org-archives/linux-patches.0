Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063123;
	b=2iA8Q1BeQ41M+jKy4ize8HVRJDMwsrEkJ1wLofXt7Ywq/LoAuXasJwn/cUim9WhOuVG2
	 TVRhXrYkcExsm/ct4LA4I5NdnkWsJKg1gf5O+kPpxbgATMQT6xzbSjZ8g/vc3B6PoxrMR
	 /nGc44h9/nCErfFLUZdKBH+tn2NxPq9JBmf/zpPo1wI/lqFViMvIO2qC1d/Xrcz2LTyKG
	 OQ0Pifq2ElDGxMoGiTpPHXVmpx4Nyz952hPmRvpVQxhzUysMd0/aZFNRF9iGJR6B0nCfD
	 CXreCq/XWl4f9rGOidzD616VYo9IbgHYx9uuH6vQVDD5HdoBNscxsfxB0TZbcHV0UDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wwz3PPUuCfhHxGmnO4eveDpBi07LraGeSZT3Ob2WmWY=;
	b=YU2MkMI7Rx7UO/fTfzgLgEngkHCRyG4KMQBqTPXg5XA7Dr0rdqztUf5u8fqpEsFkJJNf
	 t1dK+jguo0qLgneYwfkWvdp8lHi/B/zU45G+zc/VGAIKWyUDcF8+BHIFaLe+71JELvTmL
	 eLU56sBeoLK0ZZA4upq9v2uGUzqota05XjnlXAPQ7eiL9+OaUVEq0lODho6y5goodxdl+
	 uONVbed7IVBOUQi07bCMfj2CejPrZX1rIleWOoeQqmz8nIHJAkMevVaDyy8tmYcaQrq8C
	 KJnEBzlVEzCCiR5KGUr1HiLpnJMzP1+D3rlIhMsnRh6qEM9mQEcFRA6cI4/CyZsx7/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAOh4tkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7A606A33B;
	Sat,  7 Nov 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAOh4tkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC11F008A1;
	Sat,  7 Nov 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063122;
	bh=Wwz3PPUuCfhHxGmnO4eveDpBi07LraGeSZT3Ob2WmWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAOh4tkZyOMZo7CZvWw9AI/6rryGbXbvRelVGR8MXejv+Cz7575lCcFqW4zhaqt4O
	 DOVtzx9OHmgo5ZUxPrIrs6KVG+JgjF9blYcH9cz4p2lqCXHfiy5m7Z32aZHrJLkmS0
	 1xbZHePgH8q95qcV3tXCDZ+a/pVuLQ4sCPRwIEcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6a04efcebe0fc0ce@bugs.sh,
	Kaho Jiang <kj2864@nyu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/869] media: em28xx: fix double free in em28xx_alloc_urbs
Date: Sat,  7 Nov 2026 08:49:56 -0500
Message-ID: <20261107134903.146071062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaho Jiang <kj2864@nyu.edu>

[ Upstream commit fd427b8adae437cac78a2332241a03cac56e95c2 ]

When allocation of usb_bufs->buf[i] fails, em28xx_alloc_urbs()
explicitly frees all items within usb_bufs->buf before calling
em28xx_uninit_usb_xfer(), which also frees these items, causing them to be
freed twice.

BUG: KASAN: double-free in usb_free_urb.part.0 (drivers/usb/core/urb.c:25 ./include/linux/kref.h:65 drivers/usb/core/urb.c:96)
Free of addr ffff88802fd37c00 by task kworker/1:2/1182
Workqueue: events request_module_async
Call Trace:
  kasan_report_invalid_free (mm/kasan/report.c:557)
  check_slab_allocation (mm/kasan/common.c:235)
  kfree (./include/linux/kasan.h:199 (discriminator 1) mm/slub.c:2693 (discriminator 1) mm/slub.c:6508 (discriminator 1) mm/slub.c:6801 (discriminator 1))
  usb_free_urb.part.0 (drivers/usb/core/urb.c:25 ./include/linux/kref.h:65 drivers/usb/core/urb.c:96)
  usb_free_urb (drivers/usb/core/urb.c:95)
  em28xx_uninit_usb_xfer (drivers/media/usb/em28xx/em28xx-core.c:964)
  em28xx_alloc_urbs (drivers/media/usb/em28xx/em28xx-core.c:1076)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Allocated by task 1182:
  kasan_save_stack (mm/kasan/common.c:57)
  kasan_save_track (mm/kasan/common.c:78)
  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
  __kmalloc_noprof (./include/linux/kasan.h:263 mm/slub.c:5414 mm/slub.c:5439)
  em28xx_alloc_urbs (./include/linux/slab.h:995 ./include/linux/slab.h:1312 drivers/media/usb/em28xx/em28xx-core.c:1081)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Freed by task 1182:
  kasan_save_stack (mm/kasan/common.c:57)
  kasan_save_track (mm/kasan/common.c:78)
  kasan_save_free_info (mm/kasan/generic.c:584)
  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
  kfree (./include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:6508 mm/slub.c:6801)
  em28xx_alloc_urbs (drivers/media/usb/em28xx/em28xx-core.c:1084)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

Remove the explicit cleanup loop and let em28xx_uninit_usb_xfer()
handle the cleanup.

Fixes: d571b592c6206 ("media: em28xx: don't use coherent buffer for DMA transfers")
Cc: stable@vger.kernel.org
Reported-by: co+6a04efcebe0fc0ce@bugs.sh
Assisted-by: LLM
Signed-off-by: Kaho Jiang <kj2864@nyu.edu>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 1012bfb186460..5552813875132 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -949,9 +949,6 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 		usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
 		if (!usb_bufs->buf[i]) {
-			for (i--; i >= 0; i--)
-				kfree(usb_bufs->buf[i]);
-
 			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
-- 
2.53.0



