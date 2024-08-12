Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF511494B8;
	Mon, 12 Aug 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479460; cv=none; b=Fc5oHLZgB5jzHrCO3jLvhJiaxswVMpa0SSCwobwX1wkHPnUjb/RIPB35aIxNfM2eRHjD63GicxWIArSdppoUCDVhwBoOSt/phyZaa1YmyEKaww++2i1jyZ+Ql62IasTwVrOxBrDjKrlqjo6Iqd4NEMQ48YZ8bsEBYIxpTD6n0kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479460; c=relaxed/simple;
	bh=je9/EGQwEZRXyqwJxC3L4Np/ZpQ4Pa2X5rLvhoL4EOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUrLiTNBLZHyiXzctLbzC7zqKnKj3wsRS1GNbAqBifPiUNRIzPEgbZxZcznL+2doxQVT9+A3pzgVyOIZ9tqYDEJlQ0ns114KfK8q/ky7HwhDnYKvBqhotsLhCZctGI/lGAmvn7E5VAsL1kzSCeHu86eeEhKuValohAB9S7FlX5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0h0KO4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0h0KO4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27064C32782;
	Mon, 12 Aug 2024 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479460;
	bh=je9/EGQwEZRXyqwJxC3L4Np/ZpQ4Pa2X5rLvhoL4EOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0h0KO4QigW1Zk/MBUwYhA0nISD2y4kpV1so3P2FxneQpjFTN/MU/aRflfL/AL80G
	 Ba2aj8i758JXQbVTCWth4BCmwIXehIqnShg8F4PoFZmN8Pg1xnpOys7+a+FKO4bJmU
	 4mpVBA4TqYsEA3i0KqowiBbwq8nsRBMsP468+e/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/189] media: xc2028: avoid use-after-free in load_firmware_cb()
Date: Mon, 12 Aug 2024 18:01:59 +0200
Message-ID: <20240812160134.567862010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 68594cec291ff9523b9feb3f43fd853dcddd1f60 ]

syzkaller reported use-after-free in load_firmware_cb() [1].
The reason is because the module allocated a struct tuner in tuner_probe(),
and then the module initialization failed, the struct tuner was released.
A worker which created during module initialization accesses this struct
tuner later, it caused use-after-free.

The process is as follows:

task-6504           worker_thread
tuner_probe                             <= alloc dvb_frontend [2]
...
request_firmware_nowait                 <= create a worker
...
tuner_remove                            <= free dvb_frontend
...
                    request_firmware_work_func  <= the firmware is ready
                    load_firmware_cb    <= but now the dvb_frontend has been freed

To fix the issue, check the dvd_frontend in load_firmware_cb(), if it is
null, report a warning and just return.

[1]:
    ==================================================================
     BUG: KASAN: use-after-free in load_firmware_cb+0x1310/0x17a0
     Read of size 8 at addr ffff8000d7ca2308 by task kworker/2:3/6504

     Call trace:
      load_firmware_cb+0x1310/0x17a0
      request_firmware_work_func+0x128/0x220
      process_one_work+0x770/0x1824
      worker_thread+0x488/0xea0
      kthread+0x300/0x430
      ret_from_fork+0x10/0x20

     Allocated by task 6504:
      kzalloc
      tuner_probe+0xb0/0x1430
      i2c_device_probe+0x92c/0xaf0
      really_probe+0x678/0xcd0
      driver_probe_device+0x280/0x370
      __device_attach_driver+0x220/0x330
      bus_for_each_drv+0x134/0x1c0
      __device_attach+0x1f4/0x410
      device_initial_probe+0x20/0x30
      bus_probe_device+0x184/0x200
      device_add+0x924/0x12c0
      device_register+0x24/0x30
      i2c_new_device+0x4e0/0xc44
      v4l2_i2c_new_subdev_board+0xbc/0x290
      v4l2_i2c_new_subdev+0xc8/0x104
      em28xx_v4l2_init+0x1dd0/0x3770

     Freed by task 6504:
      kfree+0x238/0x4e4
      tuner_remove+0x144/0x1c0
      i2c_device_remove+0xc8/0x290
      __device_release_driver+0x314/0x5fc
      device_release_driver+0x30/0x44
      bus_remove_device+0x244/0x490
      device_del+0x350/0x900
      device_unregister+0x28/0xd0
      i2c_unregister_device+0x174/0x1d0
      v4l2_device_unregister+0x224/0x380
      em28xx_v4l2_init+0x1d90/0x3770

     The buggy address belongs to the object at ffff8000d7ca2000
      which belongs to the cache kmalloc-2k of size 2048
     The buggy address is located 776 bytes inside of
      2048-byte region [ffff8000d7ca2000, ffff8000d7ca2800)
     The buggy address belongs to the page:
     page:ffff7fe00035f280 count:1 mapcount:0 mapping:ffff8000c001f000 index:0x0
     flags: 0x7ff800000000100(slab)
     raw: 07ff800000000100 ffff7fe00049d880 0000000300000003 ffff8000c001f000
     raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
     page dumped because: kasan: bad access detected

     Memory state around the buggy address:
      ffff8000d7ca2200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
      ffff8000d7ca2280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     >ffff8000d7ca2300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                           ^
      ffff8000d7ca2380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
      ffff8000d7ca2400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ==================================================================

[2]
    Actually, it is allocated for struct tuner, and dvb_frontend is inside.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/xc2028.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc2028.c b/drivers/media/tuners/xc2028.c
index 5a967edceca93..352b8a3679b72 100644
--- a/drivers/media/tuners/xc2028.c
+++ b/drivers/media/tuners/xc2028.c
@@ -1361,9 +1361,16 @@ static void load_firmware_cb(const struct firmware *fw,
 			     void *context)
 {
 	struct dvb_frontend *fe = context;
-	struct xc2028_data *priv = fe->tuner_priv;
+	struct xc2028_data *priv;
 	int rc;
 
+	if (!fe) {
+		pr_warn("xc2028: No frontend in %s\n", __func__);
+		return;
+	}
+
+	priv = fe->tuner_priv;
+
 	tuner_dbg("request_firmware_nowait(): %s\n", fw ? "OK" : "error");
 	if (!fw) {
 		tuner_err("Could not load firmware %s.\n", priv->fname);
-- 
2.43.0



