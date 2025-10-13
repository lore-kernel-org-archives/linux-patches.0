Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1171D23D7D9;
	Mon, 13 Oct 2025 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367696; cv=none; b=tyZCCfoBLfscZu8eWb792SqGb+xeOQc35xZGDJn1G/dcn0+oIwkvQX5FFJODXRXcKHEmDqgQTSWpny32TxZHq3UKjfBll+Qm/ngcFSJ2EgjSM6zvrkCXY8gzi0MqRB8hnE1VS+kfXeEj3EyfDkfyWuE5HfloSQmuQdLHHYnlwXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367696; c=relaxed/simple;
	bh=7+sK/d08x2tiRCO+WQx7O2ufwikTKRBJ/BjgSJwYK2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSo9BIvczVf0Mx/oZY79c4hTIe8zYScgEJBN8ytnslo1y0xN0X+FHdG/WfxNXeCb5iuQrbtVNJ1LuGTQ1/oSyFpM9+PuEYFTb9azXd9muaPgt91sITgFgwnOAKd3hz613z+KhGYtkHQvKcYStGiMyDRU8xwQhTHZhMI9jkRmMFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F62b47Ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F62b47Ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AFDC113D0;
	Mon, 13 Oct 2025 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367695;
	bh=7+sK/d08x2tiRCO+WQx7O2ufwikTKRBJ/BjgSJwYK2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F62b47Ch+Q7WS6V06GpVcDihgyzB82PHS+EiCVoYWtKn4houTW+J6OuPXE9ycizl3
	 kBpuPPQr2aT2QkUOcsbHijor6eCMwHRVssfO1QBiEaZYmpaV7b7nX4B0+OWeQ4Y7BM
	 CAeIed5F4TQGDWBaok5/Q9tN426h2RoIaPPJkzA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/196] pps: fix warning in pps_register_cdev when register device fail
Date: Mon, 13 Oct 2025 16:44:51 +0200
Message-ID: <20251013144318.933582172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit b0531cdba5029f897da5156815e3bdafe1e9b88d ]

Similar to previous commit 2a934fdb01db ("media: v4l2-dev: fix error
handling in __video_register_device()"), the release hook should be set
before device_register(). Otherwise, when device_register() return error
and put_device() try to callback the release function, the below warning
may happen.

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 4760 at drivers/base/core.c:2567 device_release+0x1bd/0x240 drivers/base/core.c:2567
  Modules linked in:
  CPU: 1 UID: 0 PID: 4760 Comm: syz.4.914 Not tainted 6.17.0-rc3+ #1 NONE
  RIP: 0010:device_release+0x1bd/0x240 drivers/base/core.c:2567
  Call Trace:
   <TASK>
   kobject_cleanup+0x136/0x410 lib/kobject.c:689
   kobject_release lib/kobject.c:720 [inline]
   kref_put include/linux/kref.h:65 [inline]
   kobject_put+0xe9/0x130 lib/kobject.c:737
   put_device+0x24/0x30 drivers/base/core.c:3797
   pps_register_cdev+0x2da/0x370 drivers/pps/pps.c:402
   pps_register_source+0x2f6/0x480 drivers/pps/kapi.c:108
   pps_tty_open+0x190/0x310 drivers/pps/clients/pps-ldisc.c:57
   tty_ldisc_open+0xa7/0x120 drivers/tty/tty_ldisc.c:432
   tty_set_ldisc+0x333/0x780 drivers/tty/tty_ldisc.c:563
   tiocsetd drivers/tty/tty_io.c:2429 [inline]
   tty_ioctl+0x5d1/0x1700 drivers/tty/tty_io.c:2728
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:598 [inline]
   __se_sys_ioctl fs/ioctl.c:584 [inline]
   __x64_sys_ioctl+0x194/0x210 fs/ioctl.c:584
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x5f/0x2a0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Before commit c79a39dc8d06 ("pps: Fix a use-after-free"),
pps_register_cdev() call device_create() to create pps->dev, which will
init dev->release to device_create_release(). Now the comment is outdated,
just remove it.

Thanks for the reminder from Calvin Owens, 'kfree_pps' should be removed
in pps_register_source() to avoid a double free in the failure case.

Link: https://lore.kernel.org/all/20250827065010.3208525-1-wangliang74@huawei.com/
Fixes: c79a39dc8d06 ("pps: Fix a use-after-free")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-By: Calvin Owens <calvin@wbinvd.org>
Link: https://lore.kernel.org/r/20250830075023.3498174-1-wangliang74@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/kapi.c | 5 +----
 drivers/pps/pps.c  | 5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 92d1b62ea239d..e9389876229ea 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -109,16 +109,13 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	if (err < 0) {
 		pr_err("%s: unable to create char device\n",
 					info->name);
-		goto kfree_pps;
+		goto pps_register_source_exit;
 	}
 
 	dev_dbg(&pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
-kfree_pps:
-	kfree(pps);
-
 pps_register_source_exit:
 	pr_err("%s: unable to register source\n", info->name);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index e1689957736d9..9539695b337a8 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -375,6 +375,7 @@ int pps_register_cdev(struct pps_device *pps)
 			       pps->info.name);
 			err = -EBUSY;
 		}
+		kfree(pps);
 		goto out_unlock;
 	}
 	pps->id = err;
@@ -384,13 +385,11 @@ int pps_register_cdev(struct pps_device *pps)
 	pps->dev.devt = MKDEV(pps_major, pps->id);
 	dev_set_drvdata(&pps->dev, pps);
 	dev_set_name(&pps->dev, "pps%d", pps->id);
+	pps->dev.release = pps_device_destruct;
 	err = device_register(&pps->dev);
 	if (err)
 		goto free_idr;
 
-	/* Override the release function with our own */
-	pps->dev.release = pps_device_destruct;
-
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name, pps_major,
 		 pps->id);
 
-- 
2.51.0



