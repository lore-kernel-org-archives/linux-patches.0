Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B4531578E;
	Fri, 21 Nov 2025 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731633; cv=none; b=tUY7p4A/ay9nbXcdJXKBU9eskMyKfRjFChi1h7Co8onsQ1RFgD574GtGWxUAEOYjlttoY0e6l4g5hudbqeIjMrZ4o40xaj4PYVRN8y367BcaAm9Tfjw0ijkWFl6sZ0l2+KSd8f8NiOc+oEidFynXqBtpkc79vW8iijXNi/zcM2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731633; c=relaxed/simple;
	bh=oRvo6NSSSjmQQIk3+lbSfLkcWBtLjk2eeVftgXgrJzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaaN8tmaNX0kCdKaqrzPH6epugVPZWDE1ZpUE7+DJdnVqw3vG1GEluiByMt7cVw2TtUkZ791xyAc5+VfdynOuEkBfDtOj06/pMoZ7uKSDZniO7VxsFDksouBdZNlNbpSl74OSR0SF1llWaICI/T2ar3Vu0sDgc3AwnILyEZnS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjjLRZfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjjLRZfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6877C4CEF1;
	Fri, 21 Nov 2025 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731633;
	bh=oRvo6NSSSjmQQIk3+lbSfLkcWBtLjk2eeVftgXgrJzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjjLRZfXM8fYqhqmA3BXGgeyUfWylZW73CZhOI9v6AvJ7x15JDzCbDpNRJffcrXmP
	 TXGQkA/onlCU3OVcfBSAOKGzwoOxc3pWE2HPFfvEGIQb/7Co3FK7Ix+KDMcGm0tJJj
	 jbyA3jEXsRHFa6kWZFMWtDDsUZ3PfKP0W8/+wY9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/185] HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL
Date: Fri, 21 Nov 2025 14:10:55 +0100
Message-ID: <20251121130144.890754884@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59f630962338d..2e72e8967e685 100644
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
 
@@ -3864,6 +3866,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 	struct hidpp_report *answer = hidpp->send_receive_buf;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
+	int last_online;
 
 	/*
 	 * If the mutex is locked then we have a pending answer from a
@@ -3905,6 +3908,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 			"See: https://gitlab.freedesktop.org/jwrdegoede/logitech-27mhz-keyboard-encryption-setup/\n");
 	}
 
+	last_online = hidpp->battery.online;
 	if (hidpp->capabilities & HIDPP_CAPABILITY_HIDPP20_BATTERY) {
 		ret = hidpp20_battery_event_1000(hidpp, data, size);
 		if (ret != 0)
@@ -3929,6 +3933,11 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
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
@@ -4302,6 +4311,13 @@ static void hidpp_connect_event(struct work_struct *work)
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
@@ -4432,6 +4448,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	INIT_WORK(&hidpp->work, hidpp_connect_event);
+	INIT_WORK(&hidpp->reset_hi_res_work, hidpp_reset_hi_res_handler);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
 
@@ -4527,6 +4544,7 @@ static void hidpp_remove(struct hid_device *hdev)
 
 	hid_hw_stop(hdev);
 	cancel_work_sync(&hidpp->work);
+	cancel_work_sync(&hidpp->reset_hi_res_work);
 	mutex_destroy(&hidpp->send_mutex);
 }
 
@@ -4574,6 +4592,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* Keyboard MX5500 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Logitech G502 Lightspeed Wireless Gaming Mouse */
+	  LDJ_DEVICE(0x407f),
+	  .driver_data = HIDPP_QUIRK_RESET_HI_RES_SCROLL },
 
 	{ LDJ_DEVICE(HID_ANY_ID) },
 
-- 
2.51.0



