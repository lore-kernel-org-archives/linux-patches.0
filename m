Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C013195F9;
	Thu, 15 Jan 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499075; cv=none; b=mDvzRZxF31Zx54Xom5g4iugykCFRVmTG5EzOm+3lChu1bnoNZ72w7+ShlwoutpBT+ZZzEYYUA9zBNOgyl3/6RH5dP/A6GzorBY5W7zMfQmw3+eNB70c5e9+gJ/frpUu9lObumhsTE+TCiJJlv+pDtTzJtBftusvE2V3Rg6bJ8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499075; c=relaxed/simple;
	bh=Az6cG0Q1j7z1c1Ykh5ofcQuGtY4IVdhtEHnSUbGywuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSwry0FavvXfEAVAhe2UuZP2Bntm0bKVh3UPDFYnhgpUeiGs5c4z9oBAJY4dVMDb91NIl1PCisM2/fFPGAD1idVP+FM2BsW6haUiYBrLf8FyzcY3jSmIMAVkLLK6oMU2ZSTHlO18BJ3bYIUl5dmXwGGfkJX3wsiz38wwrG30hoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJdasCh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJdasCh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF3EC116D0;
	Thu, 15 Jan 2026 17:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499075;
	bh=Az6cG0Q1j7z1c1Ykh5ofcQuGtY4IVdhtEHnSUbGywuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJdasCh5FS1xfimmwBzRFaNq6HvgVa8/M9YnUqcy/5kiL8JiJvFo9usJwTL/mG/Vs
	 EAFuJE9mpNaB4og94scFEJYaNGx3HG3Zzj09DmmyMoQ7xKjPiTxq+KbGv65MaMwfnE
	 DPtUSS063Kq7pXuV2pU/EeVE/8OrdxTgsjiYP5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mans Rullgard <mans@mansr.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/451] backlight: led_bl: Take led_access lock when required
Date: Thu, 15 Jan 2026 17:45:01 +0100
Message-ID: <20260115164234.536159221@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit a33677b9211b6c328ad359b072043af94f7c9592 ]

The led_access lock must be held when calling led_sysfs_enable() and
led_sysfs_disable().  This fixes warnings such as this:

[    2.432495] ------------[ cut here ]------------
[    2.437316] WARNING: CPU: 0 PID: 22 at drivers/leds/led-core.c:349 led_sysfs_disable+0x54/0x58
[    2.446105] Modules linked in:
[    2.449218] CPU: 0 PID: 22 Comm: kworker/u2:1 Not tainted 6.3.8+ #1
[    2.456268] Hardware name: Generic AM3517 (Flattened Device Tree)
[    2.462402] Workqueue: events_unbound deferred_probe_work_func
[    2.468353]  unwind_backtrace from show_stack+0x10/0x14
[    2.473632]  show_stack from dump_stack_lvl+0x24/0x2c
[    2.478759]  dump_stack_lvl from __warn+0x9c/0xc4
[    2.483551]  __warn from warn_slowpath_fmt+0x64/0xc0
[    2.488586]  warn_slowpath_fmt from led_sysfs_disable+0x54/0x58
[    2.494567]  led_sysfs_disable from led_bl_probe+0x20c/0x3b0
[    2.500305]  led_bl_probe from platform_probe+0x5c/0xb8
[    2.505615]  platform_probe from really_probe+0xc8/0x2a0
[    2.510986]  really_probe from __driver_probe_device+0x88/0x19c
[    2.516967]  __driver_probe_device from driver_probe_device+0x30/0xcc
[    2.523498]  driver_probe_device from __device_attach_driver+0x94/0xc4
[    2.530090]  __device_attach_driver from bus_for_each_drv+0x80/0xcc
[    2.536437]  bus_for_each_drv from __device_attach+0xf8/0x19c
[    2.542236]  __device_attach from bus_probe_device+0x8c/0x90
[    2.547973]  bus_probe_device from deferred_probe_work_func+0x80/0xb0
[    2.554504]  deferred_probe_work_func from process_one_work+0x228/0x4c0
[    2.561187]  process_one_work from worker_thread+0x1fc/0x4d0
[    2.566925]  worker_thread from kthread+0xb4/0xd0
[    2.571685]  kthread from ret_from_fork+0x14/0x2c
[    2.576446] Exception stack(0xd0079fb0 to 0xd0079ff8)
[    2.581573] 9fa0:                                     00000000 00000000 00000000 00000000
[    2.589813] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.598052] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.604888] ---[ end trace 0000000000000000 ]---

Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Link: https://lore.kernel.org/r/20230619160249.10414-1-mans@mansr.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 9341d6698f4c ("backlight: led-bl: Add devlink to supplier LEDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/led_bl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/led_bl.c b/drivers/video/backlight/led_bl.c
index 1020e4405a4d1..0f4e4c3847b75 100644
--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -209,8 +209,11 @@ static int led_bl_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->bl_dev);
 	}
 
-	for (i = 0; i < priv->nb_leds; i++)
+	for (i = 0; i < priv->nb_leds; i++) {
+		mutex_lock(&priv->leds[i]->led_access);
 		led_sysfs_disable(priv->leds[i]);
+		mutex_unlock(&priv->leds[i]->led_access);
+	}
 
 	backlight_update_status(priv->bl_dev);
 
-- 
2.51.0



