Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A855E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAE4C433F0;
	Mon, 16 Jan 2023 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886348;
	bh=yYrgXirR63d1iwbQbUojBmHLqb2EjtbO2PLDwu6Z7P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhBNGaf3o0zEbVwWeWjcbzDPzf8QNhK8LkGadGAovfKU11X7KQZQq/h9ABsY4SPEc
	 yCwF8XNl7CULwSRwLvRAWzZawqAlSMXA87mgMmvI4SnYeUgru4n6HExjmx340YTART
	 gvlpbP7HLYY/L8UKPpfpMeWmakImmGWq/GmW1pfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 397/658] wifi: ath9k: verify the expected usb_endpoints are present
Date: Mon, 16 Jan 2023 16:48:05 +0100
Message-Id: <20230116154927.744996869@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 16ef02bad239f11f322df8425d302be62f0443ce ]

The bug arises when a USB device claims to be an ATH9K but doesn't
have the expected endpoints. (In this case there was an interrupt
endpoint where the driver expected a bulk endpoint.) The kernel
needs to be able to handle such devices without getting an internal error.

usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 3 PID: 500 at drivers/usb/core/urb.c:493 usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
Modules linked in:
CPU: 3 PID: 500 Comm: kworker/3:2 Not tainted 5.10.135-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: events request_firmware_work_func
RIP: 0010:usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
Call Trace:
 ath9k_hif_usb_alloc_rx_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:908 [inline]
 ath9k_hif_usb_alloc_urbs+0x75e/0x1010 drivers/net/wireless/ath/ath9k/hif_usb.c:1019
 ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [inline]
 ath9k_hif_usb_firmware_cb+0x142/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1242
 request_firmware_work_func+0x12e/0x240 drivers/base/firmware_loader/main.c:1097
 process_one_work+0x9af/0x1600 kernel/workqueue.c:2279
 worker_thread+0x61d/0x12f0 kernel/workqueue.c:2425
 kthread+0x3b4/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:299

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221008211532.74583-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index d872459c51cc..8a18a33b5b59 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1328,10 +1328,24 @@ static int send_eject_command(struct usb_interface *interface)
 static int ath9k_hif_usb_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;
 	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_host_interface *alt;
 	struct hif_device_usb *hif_dev;
 	int ret = 0;
 
+	/* Verify the expected endpoints are present */
+	alt = interface->cur_altsetting;
+	if (usb_find_common_endpoints(alt, &bulk_in, &bulk_out, &int_in, &int_out) < 0 ||
+	    usb_endpoint_num(bulk_in) != USB_WLAN_RX_PIPE ||
+	    usb_endpoint_num(bulk_out) != USB_WLAN_TX_PIPE ||
+	    usb_endpoint_num(int_in) != USB_REG_IN_PIPE ||
+	    usb_endpoint_num(int_out) != USB_REG_OUT_PIPE) {
+		dev_err(&udev->dev,
+			"ath9k_htc: Device endpoint numbers are not the expected ones\n");
+		return -ENODEV;
+	}
+
 	if (id->driver_info == STORAGE_DEVICE)
 		return send_eject_command(interface);
 
-- 
2.35.1



