Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A596147F791;
	Mon, 31 Aug 2026 13:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184798; cv=none; b=Fj+j1a2fW6c42ALGUEZc4lc7hHbqHncslfS4O9ifNx6wHvVZTzMiXkeI/P3H5cmo83SackzdEItWYdek8eMPMkHBlVtKGp2B3gZpzxMuTnUTtCDooYcBP+82Ew/Qv+LTBJm2G43Raeh8XBZGMm+qxB2Pz1OY1zQNFvfPKVBIDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184798; c=relaxed/simple;
	bh=WvdnlEFeZlxN3/6dUT2NN3vRN+1rjd8yHbjAzXchJRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppIWG3bRw5p1yf948V3QKekBT90xlqme5RbVqNcWnyHt/Sx3n91qwQ9LK2iasiuOgXxmPpspScyS3gBSlAXFPbUQjVLgRfkD9zAa0sCtbT3GiEEpSk4DM5kyoZQ8zVsAJfRV1ERLIm8fIGB3JOCYKhfqo4OGUEkPxfcMNXdgGZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYaZJzZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYaZJzZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4F61F00A3D;
	Mon, 31 Aug 2026 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184796;
	bh=EQeH7yFtN0DVK7ziO78D5TDVpGObFIgoYJTvbdLEK9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYaZJzZJX1LEBpk1i608jQAoI9YasaAK/t/xBL0Ab2NR14g2FTrGQZW0lnoSHw2q0
	 ZJhh7atxGZTciQKtdyA7JWQQ264PDsxEQGbv1q5lDv09L/qAhyd3Q2gqeuB0p3COTr
	 5/yzTmsfzb7A6qLwtji+jiy0N++gO/bNfwBJRwOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Fed <andfed.net@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/92] HID: magicmouse: fix battery reporting for Bluetooth Magic Trackpad USB-C
Date: Mon, 31 Aug 2026 15:34:39 +0200
Message-ID: <20260831133401.845021048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Fed <andfed.net@gmail.com>

[ Upstream commit a1556b48efc157fdda07b52ecc56c7bd1e1786f0 ]

The Apple Magic Trackpad 2 (USB-C) reports a wildly wrong battery
capacity over Bluetooth, for example a constant 4% for a pack that is
actually at 74%.

The device's battery input report (0x90) is laid out as
[report-id][status][charge]. hid-input's synchronous capacity query,
hidinput_query_battery_capacity(), assumes the common
[report-id][capacity] layout and returns buf[1], which for this device
is the status byte rather than the charge (buf[2]).

magicmouse_fetch_battery(), which requests the battery report through
hid_hw_request() so the reply is decoded via the report descriptor at
the correct field offset, is gated to the USB models and never runs
over Bluetooth. The device does not push battery reports on its own
either, except a single one at connect time, which is delivered while
probe holds driver_input_lock and is silently dropped. All userspace
reads therefore go through the misparsing query, and the device is
stuck reporting its status byte as the capacity.

Enabling the fetch for Bluetooth is not sufficient on its own: user
space reacts to the power_supply registration immediately, so a query
is typically already in flight when the fetch reply is parsed.
hidinput_get_battery_property() stores the query result and marks the
battery as queried without rechecking whether a report arrived while
it was waiting, clobbering the just-reported correct value with the
misparsed one.

Fix this by adding HID_BATTERY_QUIRK_AVOID_QUERY for the Bluetooth
Magic Trackpad USB-C so the misparsing query path is never used, and
by fetching the battery at the end of probe for this device. hidp has
no asynchronous request() callback, so the fetch is serviced
synchronously via __hid_request() while probe still holds
driver_input_lock; call hid_device_io_start() first so the reply is
processed instead of being discarded.

Tested with a Magic Trackpad USB-C (004c:0324) over Bluetooth on
6.18.37: the reported capacity now matches the device (verified against
a raw GET_REPORT of report 0x90) and updates on reconnect.

Fixes: 87a2f10395c8 ("HID: magicmouse: Apple Magic Trackpad 2 USB-C driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Andrei Fed <andfed.net@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ Kept only the new quirk entry from the conflicting hunk, dropping the adjacent Magic Trackpad 1 entry absent from this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-input.c      |    3 +++
 drivers/hid/hid-magicmouse.c |   19 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -358,6 +358,9 @@ static const struct hid_device_id hid_ba
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_MAGICTRACKPAD2_USBC),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM,
 		USB_DEVICE_ID_ELECOM_BM084),
 	  HID_BATTERY_QUIRK_IGNORE },
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -808,6 +808,12 @@ static bool is_usb_magictrackpad2(__u32
 	       product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2_USBC;
 }
 
+static bool is_bt_magictrackpad2(__u32 vendor, __u32 product)
+{
+	return vendor == BT_VENDOR_ID_APPLE &&
+	       product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2_USBC;
+}
+
 static int magicmouse_fetch_battery(struct hid_device *hdev)
 {
 #ifdef CONFIG_HID_BATTERY_STRENGTH
@@ -816,7 +822,8 @@ static int magicmouse_fetch_battery(stru
 
 	if (!hdev->battery ||
 	    (!is_usb_magicmouse2(hdev->vendor, hdev->product) &&
-	     !is_usb_magictrackpad2(hdev->vendor, hdev->product)))
+	     !is_usb_magictrackpad2(hdev->vendor, hdev->product) &&
+	     !is_bt_magictrackpad2(hdev->vendor, hdev->product)))
 		return -1;
 
 	report_enum = &hdev->report_enum[hdev->battery_report_type];
@@ -952,6 +959,16 @@ static int magicmouse_probe(struct hid_d
 		schedule_delayed_work(&msc->work, msecs_to_jiffies(500));
 	}
 
+	/*
+	 * Query the Bluetooth Magic Trackpad USB-C battery as done for USB.
+	 * Start io first: probe holds driver_input_lock and the synchronous
+	 * GET_REPORT reply would otherwise be dropped.
+	 */
+	if (is_bt_magictrackpad2(id->vendor, id->product)) {
+		hid_device_io_start(hdev);
+		magicmouse_fetch_battery(hdev);
+	}
+
 	return 0;
 err_stop_hw:
 	if (is_usb_magicmouse2(id->vendor, id->product) ||


