Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE7C222D45;
	Thu, 12 Dec 2024 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024834; cv=none; b=aX2MB1SQr4KDL0zHpLcIRN0tg22jpHeysKbSPqCfYVfBNfOIVMoyVy2j9iITgtTrQRfv0/aY0Ni3cLNPy93UWqODho3r1+A2mRaGcVhvZZiyxfXxeMm0BfnCZeHFrMaCXgNux4t+BP25UXbed2M/SvRCe85M4UJ9HO63krNQAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024834; c=relaxed/simple;
	bh=q9YJQthvXQ+pRAzfnO5nZyPMb/vWEb3pXdfvt1AkEWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhxewvdQ0vUgS2Z8qJGgpy7+8v0PBPpVAgJSpQmQ+NC+738TJ7uQjdV6PPRfFPIklgiAVBQbQV24dzW28o6ccsrNY2MmN3nuW69cNPX76KsoXVlJkPI5wxRyAeBa3EUHR2BGP0z8pUHlMAIb42qWINobCjASAm+2OE3PbeoEw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVuYC9uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVuYC9uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31384C4CECE;
	Thu, 12 Dec 2024 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024834;
	bh=q9YJQthvXQ+pRAzfnO5nZyPMb/vWEb3pXdfvt1AkEWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVuYC9uDjOuvPRJWVM/mRRoKGazacllGUY4TbsMBxo5KijBBIJCcJPgevawouyFz4
	 NQsaAcSHgo9CxhLyYlxQAUAta8T73R5Ma1Q9fLd0sgd/8VS5RC6t8GF0vvmo1x+2ez
	 Tgzy7eHGq7dUrAvLdf1fODMfYdP2wBUyZrq1kZQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Defa Li <defa.li@mediatek.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/459] i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock
Date: Thu, 12 Dec 2024 16:02:46 +0100
Message-ID: <20241212144310.668878205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Defa Li <defa.li@mediatek.com>

[ Upstream commit 6cf7b65f7029914dc0cd7db86fac9ee5159008c6 ]

A deadlock may happen since the i3c_master_register() acquires
&i3cbus->lock twice. See the log below.
Use i3cdev->desc->info instead of calling i3c_device_info() to
avoid acquiring the lock twice.

v2:
  - Modified the title and commit message

============================================
WARNING: possible recursive locking detected
6.11.0-mainline
--------------------------------------------
init/1 is trying to acquire lock:
f1ffff80a6a40dc0 (&i3cbus->lock){++++}-{3:3}, at: i3c_bus_normaluse_lock

but task is already holding lock:
f1ffff80a6a40dc0 (&i3cbus->lock){++++}-{3:3}, at: i3c_master_register

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&i3cbus->lock);
  lock(&i3cbus->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by init/1:
 #0: fcffff809b6798f8 (&dev->mutex){....}-{3:3}, at: __driver_attach
 #1: f1ffff80a6a40dc0 (&i3cbus->lock){++++}-{3:3}, at: i3c_master_register

stack backtrace:
CPU: 6 UID: 0 PID: 1 Comm: init
Call trace:
 dump_backtrace+0xfc/0x17c
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0xc0
 dump_stack+0x18/0x24
 print_deadlock_bug+0x388/0x390
 __lock_acquire+0x18bc/0x32ec
 lock_acquire+0x134/0x2b0
 down_read+0x50/0x19c
 i3c_bus_normaluse_lock+0x14/0x24
 i3c_device_get_info+0x24/0x58
 i3c_device_uevent+0x34/0xa4
 dev_uevent+0x310/0x384
 kobject_uevent_env+0x244/0x414
 kobject_uevent+0x14/0x20
 device_add+0x278/0x460
 device_register+0x20/0x34
 i3c_master_register_new_i3c_devs+0x78/0x154
 i3c_master_register+0x6a0/0x6d4
 mtk_i3c_master_probe+0x3b8/0x4d8
 platform_probe+0xa0/0xe0
 really_probe+0x114/0x454
 __driver_probe_device+0xa0/0x15c
 driver_probe_device+0x3c/0x1ac
 __driver_attach+0xc4/0x1f0
 bus_for_each_dev+0x104/0x160
 driver_attach+0x24/0x34
 bus_add_driver+0x14c/0x294
 driver_register+0x68/0x104
 __platform_driver_register+0x20/0x30
 init_module+0x20/0xfe4
 do_one_initcall+0x184/0x464
 do_init_module+0x58/0x1ec
 load_module+0xefc/0x10c8
 __arm64_sys_finit_module+0x238/0x33c
 invoke_syscall+0x58/0x10c
 el0_svc_common+0xa8/0xdc
 do_el0_svc+0x1c/0x28
 el0_svc+0x50/0xac
 el0t_64_sync_handler+0x70/0xbc
 el0t_64_sync+0x1a8/0x1ac

Signed-off-by: Defa Li <defa.li@mediatek.com>
Link: https://lore.kernel.org/r/20241107132549.25439-1-defa.li@mediatek.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 0ade1ce2bbc89..0d8210f40ff63 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -279,7 +279,8 @@ static int i3c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct i3c_device_info devinfo;
 	u16 manuf, part, ext;
 
-	i3c_device_get_info(i3cdev, &devinfo);
+	if (i3cdev->desc)
+		devinfo = i3cdev->desc->info;
 	manuf = I3C_PID_MANUF_ID(devinfo.pid);
 	part = I3C_PID_PART_ID(devinfo.pid);
 	ext = I3C_PID_EXTRA_INFO(devinfo.pid);
-- 
2.43.0



