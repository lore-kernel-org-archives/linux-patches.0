Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412EA882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D9CC433D2;
	Fri, 10 Mar 2023 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461137;
	bh=FF3RJdHwnHKPwf5KoLY2RHgQQTsSDbwASa4pGzJuF7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8KCTEF21KP3F9fm55E6JeywVsGzt/41LA3l+YXC4W7u7vFKgNQd/vUN6r/5fIISR
	 1PF0AzGFqXqzFL9VAq7GvX0CvuH0Mw47fdjhFE4XLeI2RWKrBugnIY9zneVjq7ouFm
	 GX2cbtGwHIVx/Ctr6lRWHwlq72teaL7SRkvVhdZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jun <chenjun102@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/136] watchdog: Fix kmemleak in watchdog_cdev_register
Date: Fri, 10 Mar 2023 14:42:40 +0100
Message-Id: <20230310133708.220149173@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 13721a2ac66b246f5802ba1b75ad8637e53eeecc ]

kmemleak reports memory leaks in watchdog_dev_register, as follows:
unreferenced object 0xffff888116233000 (size 2048):
  comm ""modprobe"", pid 28147, jiffies 4353426116 (age 61.741s)
  hex dump (first 32 bytes):
    80 fa b9 05 81 88 ff ff 08 30 23 16 81 88 ff ff  .........0#.....
    08 30 23 16 81 88 ff ff 00 00 00 00 00 00 00 00  .0#.............
  backtrace:
    [<000000007f001ffd>] __kmem_cache_alloc_node+0x157/0x220
    [<000000006a389304>] kmalloc_trace+0x21/0x110
    [<000000008d640eea>] watchdog_dev_register+0x4e/0x780 [watchdog]
    [<0000000053c9f248>] __watchdog_register_device+0x4f0/0x680 [watchdog]
    [<00000000b2979824>] watchdog_register_device+0xd2/0x110 [watchdog]
    [<000000001f730178>] 0xffffffffc10880ae
    [<000000007a1a8bcc>] do_one_initcall+0xcb/0x4d0
    [<00000000b98be325>] do_init_module+0x1ca/0x5f0
    [<0000000046d08e7c>] load_module+0x6133/0x70f0
    ...

unreferenced object 0xffff888105b9fa80 (size 16):
  comm ""modprobe"", pid 28147, jiffies 4353426116 (age 61.741s)
  hex dump (first 16 bytes):
    77 61 74 63 68 64 6f 67 31 00 b9 05 81 88 ff ff  watchdog1.......
  backtrace:
    [<000000007f001ffd>] __kmem_cache_alloc_node+0x157/0x220
    [<00000000486ab89b>] __kmalloc_node_track_caller+0x44/0x1b0
    [<000000005a39aab0>] kvasprintf+0xb5/0x140
    [<0000000024806f85>] kvasprintf_const+0x55/0x180
    [<000000009276cb7f>] kobject_set_name_vargs+0x56/0x150
    [<00000000a92e820b>] dev_set_name+0xab/0xe0
    [<00000000cec812c6>] watchdog_dev_register+0x285/0x780 [watchdog]
    [<0000000053c9f248>] __watchdog_register_device+0x4f0/0x680 [watchdog]
    [<00000000b2979824>] watchdog_register_device+0xd2/0x110 [watchdog]
    [<000000001f730178>] 0xffffffffc10880ae
    [<000000007a1a8bcc>] do_one_initcall+0xcb/0x4d0
    [<00000000b98be325>] do_init_module+0x1ca/0x5f0
    [<0000000046d08e7c>] load_module+0x6133/0x70f0
    ...

The reason is that put_device is not be called if cdev_device_add fails
and wdd->id != 0.

watchdog_cdev_register
  wd_data = kzalloc                             [1]
  err = dev_set_name                            [2]
  ..
  err = cdev_device_add
  if (err) {
    if (wdd->id == 0) {  // wdd->id != 0
      ..
    }
    return err;  // [1],[2] would be leaked

To fix it, call put_device in all wdd->id cases.

Fixes: 72139dfa2464 ("watchdog: Fix the race between the release of watchdog_core_data and cdev")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116012714.102066-1-chenjun102@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 3a3d8b5c7ad59..5eec84fa65170 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1044,8 +1044,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
-- 
2.39.2



