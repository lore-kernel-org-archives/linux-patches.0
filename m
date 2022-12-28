Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584771C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F62C433D2;
	Wed, 28 Dec 2022 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244846;
	bh=PHGuHIM1Wlw3cFSP3Z0RTUG8LbXNJFIPI/SbgqvEhl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=homUfbhhmeXGJo7GQAaAG8YNK+f/JQdURY3a0lQgCYiWlKon/F8N409u+VnwmvqhG
	 wdRMECKms9bxDyPvJXEdwfceuadBZ+7CUwHoqFNhmSkDFxKg3z4PHsULwxwta2AyCR
	 NVYx8SzFrksoCWQMueMKuhUj1x6dRy37qZJyBLts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0784/1073] rtc: class: Fix potential memleak in devm_rtc_allocate_device()
Date: Wed, 28 Dec 2022 15:39:32 +0100
Message-Id: <20221228144349.305465856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 60da73808298ff2cfa9f165d55eb3d7aa7078601 ]

devm_rtc_allocate_device() will alloc a rtc_device first, and then run
dev_set_name(). If dev_set_name() failed, the rtc_device will memleak.
Move devm_add_action_or_reset() in front of dev_set_name() to prevent
memleak.

unreferenced object 0xffff888110a53000 (size 2048):
  comm "python3", pid 470, jiffies 4296078308 (age 58.882s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 30 a5 10 81 88 ff ff  .........0......
    08 30 a5 10 81 88 ff ff 00 00 00 00 00 00 00 00  .0..............
  backtrace:
    [<000000004aac0364>] kmalloc_trace+0x21/0x110
    [<000000000ff02202>] devm_rtc_allocate_device+0xd4/0x400
    [<000000001bdf5639>] devm_rtc_device_register+0x1a/0x80
    [<00000000351bf81c>] rx4581_probe+0xdd/0x110 [rtc_rx4581]
    [<00000000f0eba0ae>] spi_probe+0xde/0x130
    [<00000000bff89ee8>] really_probe+0x175/0x3f0
    [<00000000128e8d84>] __driver_probe_device+0xe6/0x170
    [<00000000ee5bf913>] device_driver_attach+0x32/0x80
    [<00000000f3f28f92>] bind_store+0x10b/0x1a0
    [<000000009ff812d8>] drv_attr_store+0x49/0x70
    [<000000008139c323>] sysfs_kf_write+0x8d/0xb0
    [<00000000b6146e01>] kernfs_fop_write_iter+0x214/0x2d0
    [<00000000ecbe3895>] vfs_write+0x61a/0x7d0
    [<00000000aa2196ea>] ksys_write+0xc8/0x190
    [<0000000046a600f5>] do_syscall_64+0x37/0x90
    [<00000000541a336f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 24d23181e43d ("rtc: class: check return value when calling dev_set_name()")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221110090810.11225-1-shangxiaojing@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/class.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index e48223c00c67..e5b7b48cffac 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -374,11 +374,11 @@ struct rtc_device *devm_rtc_allocate_device(struct device *dev)
 
 	rtc->id = id;
 	rtc->dev.parent = dev;
-	err = dev_set_name(&rtc->dev, "rtc%d", id);
+	err = devm_add_action_or_reset(dev, devm_rtc_release_device, rtc);
 	if (err)
 		return ERR_PTR(err);
 
-	err = devm_add_action_or_reset(dev, devm_rtc_release_device, rtc);
+	err = dev_set_name(&rtc->dev, "rtc%d", id);
 	if (err)
 		return ERR_PTR(err);
 
-- 
2.35.1



