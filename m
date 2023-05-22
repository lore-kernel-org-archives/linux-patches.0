Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39A2171BA
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC0C4339B;
	Mon, 22 May 2023 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784586;
	bh=g3CJpD1vm4vL6lHqVtKo/c+s3vffDwnNcNpN7F4o14s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNblBzgbI9weT2AWETUg/AZzL4rDGuWv2gyp6Ct3tS/6KRPr114cyF+0menPlZKeg
	 PYBh3PZhMpXSVSs4CD2AjVhsxQECU0FSEBZdQ0OBbnrOy3F88t4WbqSTk6yMYGxjxs
	 IoQXgkdmiUa6nZqjsyKcl1PdJqTuHdGyCPYpBFyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 132/364] wifi: rtw88: Fix memory leak in rtw88_usb
Date: Mon, 22 May 2023 20:07:17 +0100
Message-Id: <20230522190416.091788146@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 59a3a312009723e3e5082899655fdcc420e2b47a ]

Kmemleak shows the following leak arising from routine in the usb
probe routine:

unreferenced object 0xffff895cb29bba00 (size 512):
  comm "(udev-worker)", pid 534, jiffies 4294903932 (age 102751.088s)
  hex dump (first 32 bytes):
    77 30 30 30 00 00 00 00 02 2f 2d 2b 30 00 00 00  w000...../-+0...
    02 00 2a 28 00 00 00 00 ff 55 ff ff ff 00 00 00  ..*(.....U......
  backtrace:
    [<ffffffff9265fa36>] kmalloc_trace+0x26/0x90
    [<ffffffffc17eec41>] rtw_usb_probe+0x2f1/0x680 [rtw_usb]
    [<ffffffffc03e19fd>] usb_probe_interface+0xdd/0x2e0 [usbcore]
    [<ffffffff92b4f2fe>] really_probe+0x18e/0x3d0
    [<ffffffff92b4f5b8>] __driver_probe_device+0x78/0x160
    [<ffffffff92b4f6bf>] driver_probe_device+0x1f/0x90
    [<ffffffff92b4f8df>] __driver_attach+0xbf/0x1b0
    [<ffffffff92b4d350>] bus_for_each_dev+0x70/0xc0
    [<ffffffff92b4e51e>] bus_add_driver+0x10e/0x210
    [<ffffffff92b50935>] driver_register+0x55/0xf0
    [<ffffffffc03e0708>] usb_register_driver+0x88/0x140 [usbcore]
    [<ffffffff92401153>] do_one_initcall+0x43/0x210
    [<ffffffff9254f42a>] do_init_module+0x4a/0x200
    [<ffffffff92551d1c>] __do_sys_finit_module+0xac/0x120
    [<ffffffff92ee6626>] do_syscall_64+0x56/0x80
    [<ffffffff9300006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

The leak was verified to be real by unloading the driver, which resulted
in a dangling pointer to the allocation.

The allocated memory is freed in rtw_usb_intf_deinit().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230417160331.23071-1-Larry.Finger@lwfinger.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 8e2c99f9c3662..44a5fafb99055 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -804,6 +804,7 @@ static void rtw_usb_intf_deinit(struct rtw_dev *rtwdev,
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
 	usb_put_dev(rtwusb->udev);
+	kfree(rtwusb->usb_data);
 	usb_set_intfdata(intf, NULL);
 }
 
-- 
2.39.2



