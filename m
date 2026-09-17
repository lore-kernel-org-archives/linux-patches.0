Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B39252CCEC;
	Thu, 17 Sep 2026 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665980; cv=none; b=aOOaKpe/yQl36lyBWhML8UF3uR9GR5bSnK271qB6QgU3pKF881Y9isAT1BnLx6HwK8VNorjG27OrKXcs4LPfL/ULt09fVDoNLjdKblJ3WpKGStiKc2D67SaJfxvkusHZghrbr6hpi+GSmlP1qZ5Hkpx+48tb+mbFRxSe6SW2QN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665980; c=relaxed/simple;
	bh=G0q9NMJtBT3h6ZkFPg7FecmDFT1Z6YfFWJpHUmSUPho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOBny7nh6z4YY4idB5BGfV5/bgCDVbuQxIkP5JjvuudnsCxvMEUtalj3fiS24mPCN6iRxAuHtr6ta5hkYiTstOV9qEO0sQXQk/VtgAfe8Dhwk8/X1Uq/pdKrIaggz0DWD3PvDhVOnemTP80ghlX74TmNlfAdnXgL2oeQ+BCmCZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5mnxCIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5mnxCIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EEB1F00893;
	Thu, 17 Sep 2026 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665979;
	bh=yYfcWWZRUr2n0jaAtP1CE6kf79NSyTBe03d/Ve4Ouis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5mnxCIb0lo2qbUtOg3f1lhTFOKeUZS3VtKDemREN+gMsbBb4mYgce9ve+IJQERiy
	 HEEHWhL4WLX4Hg3cy6oe1hfQQ3b0fU3hAd+J5t989JD3kkWXuT8rRzrd347x6witGy
	 +x8Sn0ik2OztUvzuSjHNnD1y5IQyc7lXYEoTMWAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0884/1250] Bluetooth: btusb: mediatek: Fix leaked runtime PM reference in reset
Date: Thu, 17 Sep 2026 16:11:19 +0100
Message-ID: <20260917151615.943378255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit e486a891c412d9d82ee865987f4eead6196e1f96 ]

MT7925 on HP Pro Mini 260 sometimes timed out during reloading driver
and reset usb device. btusb_suspend is not called again after closing
bluetooth interface.

 usbcore: registered new interface driver btusb
 Bluetooth: hci0: HW/SW Version: 0x00000000, Build Time: 20260605184935
 Bluetooth: hci0: Execution of wmt command timed out
 Bluetooth: hci0: Failed to send wmt patch dwnld (-110)
 Bluetooth: hci0: Failed to set up firmware (-110)
 usb 3-10: reset high-speed USB device number 4 using xhci_hcd
 Bluetooth: hci0: HW/SW Version: 0x00000000, Build Time: 20260605184935
 Bluetooth: hci0: Device setup in 1856545 usecs
 Bluetooth: hci0: AOSP extensions version v1.00
 Bluetooth: hci0: AOSP quality report is supported
 Bluetooth: MGMT ver 1.23

btusb_mtk_reset calls usb_autopm_get_interface to resume the device
before driving the hardware reset, but never calls the matching
usb_autopm_put_interface. Every hardware reset therefore leaks a PM
usage reference of the interface, preventing the device from being
runtime suspended again until it is unbound.

Add the BTUSB_RESET flag. It is set before usb_queue_reset_device
and is cleared in btusb_disconnect, which drops the reference as well.
If the flag is already set when a new reset is requested, drop one
reference.

Also clear BTMTK_HW_RESET_ACTIVE if usb_autopm_get_interface fails,
otherwise no further reset could ever be attempted.

Fixes: 25b6d7593a3a ("Bluetooth: btmtk: introduce btmtk reset work")
Assisted-by: Claude:qwen3.8-max
Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 98d6b27fe07f6..b71486097b1ad 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -936,6 +936,7 @@ struct qca_dump_info {
 #define BTUSB_USE_ALT3_FOR_WBS	15
 #define BTUSB_ALT6_CONTINUOUS_TX	16
 #define BTUSB_HW_SSR_ACTIVE	17
+#define BTUSB_RESET		19
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -2858,8 +2859,11 @@ static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 	}
 
 	err = usb_autopm_get_interface(data->intf);
-	if (err < 0)
+	if (err < 0) {
+		bt_dev_err(hdev, "Failed usb_autopm_get_interface: %d", err);
+		clear_bit(BTMTK_HW_RESET_ACTIVE, &btmtk_data->flags);
 		return err;
+	}
 
 	/* Release MediaTek ISO data interface */
 	btusb_mtk_release_iso_intf(hdev);
@@ -2869,6 +2873,11 @@ static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 
 	err = btmtk_usb_subsys_reset(hdev, btmtk_data->dev_id);
 
+	if (test_and_set_bit(BTUSB_RESET, &data->flags)) {
+		bt_dev_err(hdev, "last usb reset failed? Resetting again");
+		usb_autopm_put_interface_no_suspend(data->intf);
+	}
+
 	usb_queue_reset_device(data->intf);
 	clear_bit(BTMTK_HW_RESET_ACTIVE, &btmtk_data->flags);
 
@@ -4445,6 +4454,9 @@ static void btusb_disconnect(struct usb_interface *intf)
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 
+	if (test_and_clear_bit(BTUSB_RESET, &data->flags))
+		usb_autopm_put_interface_no_suspend(data->intf);
+
 	if (intf == data->intf) {
 		if (data->isoc)
 			usb_driver_release_interface(&btusb_driver, data->isoc);
-- 
2.53.0



