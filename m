Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63441142E84;
	Thu, 13 Jun 2024 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280977; cv=none; b=uXbXeitn7Lyo9jSSOLe+Rf0+Plu4GXKILUAnBW8VbKumS3j73iZ3qQUpT0tueGx7d0amejhtohzCytTEvNbnwUUnmbiqdhNyc7OISvt6Hj4QsXK4pOzXdFf/1V9v6F9+fxThBzca0bcD3M409Gvd5duR0R5Y7z/hShrzjGmYKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280977; c=relaxed/simple;
	bh=2Zc4/1g/A8n2YvcBfQqJ0Guh6zuemENx91R0jWr//C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy3d5is/4eo5ICyiLoDWvg6lWXWbwR5uDG7HIwEWcxDw5lyb9dDWswJ82rVarR9F5Di1B3azmcBfGyG/pyZG+9BKo2svp2JZDFYwFGpjxIV5es1AqqpG8diGlvrhrw/Lq9ufm5xuvlaD/cblAG5tKFpszRTs4siEHZsPT5AV5gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU3l93AP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU3l93AP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10CDC2BBFC;
	Thu, 13 Jun 2024 12:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280977;
	bh=2Zc4/1g/A8n2YvcBfQqJ0Guh6zuemENx91R0jWr//C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU3l93APXfeZ+Ff5zzlqSGy/r7k73HrRhRpQnDa7lsF066tjuDbFt2J1GjAS67++b
	 K++yEN6EtIYtKIpwBkvbq/NmPP9kzDwqCfcZwGJPeLlWFQhnEfGBlyIql4Bqstur0A
	 gPrZ2XLAKAg0FaEx3RfXlBNc/sULJbjI30a8M/Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Christian Lamparter <chunkeey@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+0ae4804973be759fa420@syzkaller.appspotmail.com
Subject: [PATCH 5.10 067/317] wifi: carl9170: add a proper sanity check for endpoints
Date: Thu, 13 Jun 2024 13:31:25 +0200
Message-ID: <20240613113250.140852477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit b6dd09b3dac89b45d1ea3e3bd035a3859c0369a0 ]

Syzkaller reports [1] hitting a warning which is caused by presence
of a wrong endpoint type at the URB sumbitting stage. While there
was a check for a specific 4th endpoint, since it can switch types
between bulk and interrupt, other endpoints are trusted implicitly.
Similar warning is triggered in a couple of other syzbot issues [2].

Fix the issue by doing a comprehensive check of all endpoints
taking into account difference between high- and full-speed
configuration.

[1] Syzkaller report:
...
WARNING: CPU: 0 PID: 4721 at drivers/usb/core/urb.c:504 usb_submit_urb+0xed6/0x1880 drivers/usb/core/urb.c:504
...
Call Trace:
 <TASK>
 carl9170_usb_send_rx_irq_urb+0x273/0x340 drivers/net/wireless/ath/carl9170/usb.c:504
 carl9170_usb_init_device drivers/net/wireless/ath/carl9170/usb.c:939 [inline]
 carl9170_usb_firmware_finish drivers/net/wireless/ath/carl9170/usb.c:999 [inline]
 carl9170_usb_firmware_step2+0x175/0x240 drivers/net/wireless/ath/carl9170/usb.c:1028
 request_firmware_work_func+0x130/0x240 drivers/base/firmware_loader/main.c:1107
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

[2] Related syzkaller crashes:
Link: https://syzkaller.appspot.com/bug?extid=e394db78ae0b0032cb4d
Link: https://syzkaller.appspot.com/bug?extid=9468df99cb63a4a4c4e1

Reported-and-tested-by: syzbot+0ae4804973be759fa420@syzkaller.appspotmail.com
Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Acked-By: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240422183355.3785-1-n.zhandarovich@fintech.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/usb.c | 32 +++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index e4eb666c6eea4..a5265997b5767 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -1069,6 +1069,38 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 			ar->usb_ep_cmd_is_bulk = true;
 	}
 
+	/* Verify that all expected endpoints are present */
+	if (ar->usb_ep_cmd_is_bulk) {
+		u8 bulk_ep_addr[] = {
+			AR9170_USB_EP_RX | USB_DIR_IN,
+			AR9170_USB_EP_TX | USB_DIR_OUT,
+			AR9170_USB_EP_CMD | USB_DIR_OUT,
+			0};
+		u8 int_ep_addr[] = {
+			AR9170_USB_EP_IRQ | USB_DIR_IN,
+			0};
+		if (!usb_check_bulk_endpoints(intf, bulk_ep_addr) ||
+		    !usb_check_int_endpoints(intf, int_ep_addr))
+			err = -ENODEV;
+	} else {
+		u8 bulk_ep_addr[] = {
+			AR9170_USB_EP_RX | USB_DIR_IN,
+			AR9170_USB_EP_TX | USB_DIR_OUT,
+			0};
+		u8 int_ep_addr[] = {
+			AR9170_USB_EP_IRQ | USB_DIR_IN,
+			AR9170_USB_EP_CMD | USB_DIR_OUT,
+			0};
+		if (!usb_check_bulk_endpoints(intf, bulk_ep_addr) ||
+		    !usb_check_int_endpoints(intf, int_ep_addr))
+			err = -ENODEV;
+	}
+
+	if (err) {
+		carl9170_free(ar);
+		return err;
+	}
+
 	usb_set_intfdata(intf, ar);
 	SET_IEEE80211_DEV(ar->hw, &intf->dev);
 
-- 
2.43.0



