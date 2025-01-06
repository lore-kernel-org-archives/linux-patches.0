Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE8E126C05;
	Mon,  6 Jan 2025 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177250; cv=none; b=Fy/XZoKJFrPEYIlZVYDZwjddjqFBVdq++paua3JDWJv+kSDl9Br0FPLzS3f5ggr5dn6OUou0+fa8y39I5IYjwjr5BuUOcjNfAevQkZI8No2jfzLao9sJwWYJ+Ai5vHAhWagHSCai2cSoOJ4D8v7ZLmpOibX+hqeHJdmNn+5LpX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177250; c=relaxed/simple;
	bh=CpHq2tz9EpYk7ONytQ76HjkXtb7ozYNAuLkJ66CFW20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6J4t4hrjDAdS8j/J4QqkhUDPoZdg3b376hgOGkurNVqH4Qa+vZgVH7mV0b6K4qOF5ZPJmt/CBCcYjOhcPr3R4Xm0o5b9DaznIIgVbKEVsYD7C3MdrVM2t+NjaoyvWaJz8RGSK9FQjDTF0fB/dbE/HdwYKzjbdAASMWYJRipI7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhRprP59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhRprP59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3279C4CED2;
	Mon,  6 Jan 2025 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177250;
	bh=CpHq2tz9EpYk7ONytQ76HjkXtb7ozYNAuLkJ66CFW20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhRprP598Ro8lgEI4xsxjc1wM4kym5W3fxVRU1XcbLfXH0zhvpp5Z1b2ZQkReNxZh
	 ZmlJAlEGAI07elpiLkAsr85l6cWS3OpkxydTfAKCKhWzPrFgsZ7IVmXjathY8293Dv
	 qjnmsY4PcFMRDRL9mCXo6bRrXt6tP77I6yCLDGyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/222] Bluetooth: btusb: add callback function in btusb suspend/resume
Date: Mon,  6 Jan 2025 16:15:06 +0100
Message-ID: <20250106151154.457839700@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 95f92928ad2215b5f524903e67eebd8e14f99564 ]

Add suspend/resum callback function in btusb_data which are reserved
for vendor specific usage during suspend/resume. hdev->suspend will be
added before stop traffic in btusb_suspend and hdev-> resume will be
added after resubmit urb in btusb_resume.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cea1805f165c ("Bluetooth: btusb: mediatek: add callback function in btusb_disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 67577933835f..19d371aa8317 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -892,6 +892,9 @@ struct btusb_data {
 
 	int (*setup_on_usb)(struct hci_dev *hdev);
 
+	int (*suspend)(struct hci_dev *hdev);
+	int (*resume)(struct hci_dev *hdev);
+
 	int oob_wake_irq;   /* irq for out-of-band wake-on-bt */
 	unsigned cmd_timeout_cnt;
 
@@ -4691,6 +4694,9 @@ static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
 
 	cancel_work_sync(&data->work);
 
+	if (data->suspend)
+		data->suspend(data->hdev);
+
 	btusb_stop_traffic(data);
 	usb_kill_anchored_urbs(&data->tx_anchor);
 
@@ -4794,6 +4800,9 @@ static int btusb_resume(struct usb_interface *intf)
 			btusb_submit_isoc_urb(hdev, GFP_NOIO);
 	}
 
+	if (data->resume)
+		data->resume(hdev);
+
 	spin_lock_irq(&data->txlock);
 	play_deferred(data);
 	clear_bit(BTUSB_SUSPENDING, &data->flags);
-- 
2.39.5



