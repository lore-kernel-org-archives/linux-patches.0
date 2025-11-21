Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C4A27B358;
	Fri, 21 Nov 2025 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730965; cv=none; b=TH5dbVaHTNespD2J/qukvAavNfRmrUMuthB6nu0VLdCBYMhV8wW6aVDloJ8ChXgooYG6kd+yiqea96WYYlTAgqrQZnR2XQUvgAqvVkzV6n3t/fhpXFWZ70MINkTN5DgJ27Jcf9juAoI5Q7uH8LQuw4oZVUIBSj/t54gU4P+CiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730965; c=relaxed/simple;
	bh=88YJIPgUNzK9d+I1wWfWKLYlD+Cn2v2YZqbNtU160B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnyWQ7VecvEA5dox78+Air7h+3G/hw+Tgr8Wu83hyqx19fvbWhPnfDPyOmN8mrJ529mNxYk+XejkIAeH+uAD2sVkaaB4q8Td1F0klCEduV+bczY2GRY3HUbFz0oAk8NJSqHvVap/Id9W08Gl0zM7kJKtHzQaIarVCAFlmX81OyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ke6rpWaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ke6rpWaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982CDC116D0;
	Fri, 21 Nov 2025 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730965;
	bh=88YJIPgUNzK9d+I1wWfWKLYlD+Cn2v2YZqbNtU160B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke6rpWaMR3Ix2wGGrkHDZe7Ym3az5wgoTpmdk4UXc7Ws2U5+ue4keSYAU5c45qdwO
	 2DRC1L3DzmCzUi71FZSj2RaBVMNKVqOUm8HhujFhUEweIZ6K0oU7bKYeFEXlbtn5Fq
	 ApQ7pzy7J99ovsdtogj14Y0y2HpHi+2dpz7Srn5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 042/247] HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL
Date: Fri, 21 Nov 2025 14:09:49 +0100
Message-ID: <20251121130156.112801293@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

[ Upstream commit ed80cc4667ac997b84546e6d35f0a0ae525d239c ]

The Logitech G502 Hero Wireless's high resolution scrolling resets after
being unplugged without notifying the driver, causing extremely slow
scrolling.

The only indication of this is a battery update packet, so add a quirk to
detect when the device is unplugged and re-enable the scrolling.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218037
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index aaef405a717ee..5e763de4b94fd 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -75,6 +75,7 @@ MODULE_PARM_DESC(disable_tap_to_click,
 #define HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS	BIT(27)
 #define HIDPP_QUIRK_HI_RES_SCROLL_1P0		BIT(28)
 #define HIDPP_QUIRK_WIRELESS_STATUS		BIT(29)
+#define HIDPP_QUIRK_RESET_HI_RES_SCROLL		BIT(30)
 
 /* These are just aliases for now */
 #define HIDPP_QUIRK_KBD_SCROLL_WHEEL HIDPP_QUIRK_HIDPP_WHEELS
@@ -193,6 +194,7 @@ struct hidpp_device {
 	void *private_data;
 
 	struct work_struct work;
+	struct work_struct reset_hi_res_work;
 	struct kfifo delayed_work_fifo;
 	struct input_dev *delayed_input;
 
@@ -3836,6 +3838,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 	struct hidpp_report *answer = hidpp->send_receive_buf;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
+	int last_online;
 
 	/*
 	 * If the mutex is locked then we have a pending answer from a
@@ -3877,6 +3880,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 			"See: https://gitlab.freedesktop.org/jwrdegoede/logitech-27mhz-keyboard-encryption-setup/\n");
 	}
 
+	last_online = hidpp->battery.online;
 	if (hidpp->capabilities & HIDPP_CAPABILITY_HIDPP20_BATTERY) {
 		ret = hidpp20_battery_event_1000(hidpp, data, size);
 		if (ret != 0)
@@ -3901,6 +3905,11 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 			return ret;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_RESET_HI_RES_SCROLL) {
+		if (last_online == 0 && hidpp->battery.online == 1)
+			schedule_work(&hidpp->reset_hi_res_work);
+	}
+
 	if (hidpp->quirks & HIDPP_QUIRK_HIDPP_WHEELS) {
 		ret = hidpp10_wheel_raw_event(hidpp, data, size);
 		if (ret != 0)
@@ -4274,6 +4283,13 @@ static void hidpp_connect_event(struct work_struct *work)
 	hidpp->delayed_input = input;
 }
 
+static void hidpp_reset_hi_res_handler(struct work_struct *work)
+{
+	struct hidpp_device *hidpp = container_of(work, struct hidpp_device, reset_hi_res_work);
+
+	hi_res_scroll_enable(hidpp);
+}
+
 static DEVICE_ATTR(builtin_power_supply, 0000, NULL, NULL);
 
 static struct attribute *sysfs_attrs[] = {
@@ -4404,6 +4420,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	INIT_WORK(&hidpp->work, hidpp_connect_event);
+	INIT_WORK(&hidpp->reset_hi_res_work, hidpp_reset_hi_res_handler);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
 
@@ -4499,6 +4516,7 @@ static void hidpp_remove(struct hid_device *hdev)
 
 	hid_hw_stop(hdev);
 	cancel_work_sync(&hidpp->work);
+	cancel_work_sync(&hidpp->reset_hi_res_work);
 	mutex_destroy(&hidpp->send_mutex);
 }
 
@@ -4546,6 +4564,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* Keyboard MX5500 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Logitech G502 Lightspeed Wireless Gaming Mouse */
+	  LDJ_DEVICE(0x407f),
+	  .driver_data = HIDPP_QUIRK_RESET_HI_RES_SCROLL },
 
 	{ LDJ_DEVICE(HID_ANY_ID) },
 
-- 
2.51.0



