Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0545C6E5;
	Thu, 30 Jul 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427290; cv=none; b=fQcbsUS34RVMl8vTjkozsabI4rLsKf1x7hAStvy5Q7Rv2jd2kDIn4p7qBGe9uP8CL1YWSyGhJBVG1f9ecmAxzJgsm2cQ1G8Jr9q5+HJVgNSurHmCJpRFGavxSG4BPZuE+9F9s82IqBIkZxXH5oc96wKnpApyRLWW8C9/IhhpB5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427290; c=relaxed/simple;
	bh=paPT0haMsJYCHHMRgZ+7ezvdMLmo8JA4RtVIKe5HwLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQT3JZmfKIxlOAZiS7pl5t9LUSY4AUvhNw9mJ/3W/LDa/VLbgFj12JOoXC4/HS25eYH4KMv4aWOxAgTBVuaROn71CQ4cMyZj+gXJyVo/OZF0jWxr9dK5g02C1jLP0sROMPRUQDFZtnE3tgqo4Qaqw69T6rcb57Mjxt3z8J5CV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr/xra8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr/xra8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0431F00A3A;
	Thu, 30 Jul 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427289;
	bh=567nrb7FS1uzytOBC0RS1Z9j7Du9HgWswl42CU0uIQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr/xra8A2NnkhCW7pGxzUmYdeaK0tM+FEpyFogkkalum1zPKwJZBOTumECYCssV10
	 3ChgNDB0t6ksPvCeYTbayl+Uv+BjKAnmNTHQN1E9I2LriheJb1lp3rQ7XRbAcIuNOW
	 6z3zwQTd1m4yumnZkadu8BASjZVURvfWAsPHtPLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/484] hwmon: (corsair-psu) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:10:14 +0200
Message-ID: <20260730141426.003254787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 9ab8656548cd737b98d0b19c4253aff8d68e97f4 ]

hid_hw_stop() does not stop the device IO.

This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
corsairpsu_probe(). If the probe operation fails after "io start" has
been initiated, this race condition will result in a uaf vulnerability
[1].

CPU0				CPU1
====				====
corsairpsu_probe()
 hid_device_io_start()
  ... unlock driver_input_lock
 hid_hw_stop()
  kfree(hidraw)			__hid_input_report()
				 ... acquire driver_input_lock
				 hid_report_raw_event()
				  hidraw_report_event()
				   ... access hidraw's list_lock // trigger uaf

Consequently, when corsairpsu_probe() fails and hid_hw_stop() needs to
be executed, the io_started flag is first cleared while holding the
driver_input_lock to prevent potential race conditions involving input
reports.

[1]
BUG: KASAN: slab-use-after-free in rt_spin_lock+0x83/0x400 kernel/locking/spinlock_rt.c:56
Call Trace:
 hidraw_report_event+0x5d/0x3a0 drivers/hid/hidraw.c:577
 hid_report_raw_event+0x311/0x1730 drivers/hid/hid-core.c:2076
 __hid_input_report drivers/hid/hid-core.c:2152 [inline]
 hid_input_report+0x44e/0x580 drivers/hid/hid-core.c:2174
 hid_irq_in+0x47e/0x6d0 drivers/hid/usbhid/hid-core.c:286
 __usb_hcd_giveback_urb+0x3b3/0x5e0 drivers/usb/core/hcd.c:1657
 dummy_timer+0x8a9/0x47d0 drivers/usb/gadget/udc/dummy_hcd.c:2005

Allocated by task 10:
 hidraw_connect+0x57/0x430 drivers/hid/hidraw.c:606
 hid_connect+0x5bf/0x19d0 drivers/hid/hid-core.c:2277
 hid_hw_start+0xa8/0x120 drivers/hid/hid-core.c:2387
 corsairpsu_probe+0xd9/0x3c0 drivers/hwmon/corsair-psu.c:782

Freed by task 10:
 hidraw_disconnect+0x4f/0x60 drivers/hid/hidraw.c:662
 hid_disconnect drivers/hid/hid-core.c:2362 [inline]
 hid_hw_stop+0x101/0x1e0 drivers/hid/hid-core.c:2407
 corsairpsu_probe+0x327/0x3c0 drivers/hwmon/corsair-psu.c:826

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Reported-by: syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9eebf5f6544c5e873858
Tested-by: syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://lore.kernel.org/r/tencent_BB7C33EB9EA41B7B4B5F1B8B25C0BA13BB08@qq.com
[groeck: Updated subject and description;
 call hid_device_io_stop() only if IO has been started]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 93937e1bce196b..4ab73bcef1d125 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -831,6 +831,7 @@ static int corsairpsu_probe(struct hid_device *hdev, const struct hid_device_id
 
 fail_and_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 fail_and_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



