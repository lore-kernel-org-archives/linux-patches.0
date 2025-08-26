Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ECA33CEB0;
	Tue, 26 Aug 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216557; cv=none; b=EjC8V3XVyBR8FUHcr/Hf+/6jJ8SjvQ2S5A00WS6hCdB3QSwJI7l6yEvo0SdAKXDnbkD6XbEkHbe2FcvDxWVw0B0y4kvWkDIUbh2UIysuR2alcPCCjFH6Vnmwf4gzFSxU4Ox/xleG4angTAMUW+kLl5sJNKb5fe+n19CwvaUojUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216557; c=relaxed/simple;
	bh=B3OZEYpX773bZTkwd5jj40c5DOHtA9sWqcne/JqMlRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3I0Nqsp++WoOlMcEVL+8jcxCtHLyG7Gz1Jp3/Iu9GMotoAmvUP8+liYHIIG3Wfrqj8pRxrFiL5dSv1WGZmPU4uAB8Nk0gBTsJrrZcT0kbJpj/QN+oasqSjt3GH8mcJMJQV719eZUFlkACT9f3mwWeg9+JSYeKkdwTqmWfHYSII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWk8ZWuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWk8ZWuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A27FC4CEF1;
	Tue, 26 Aug 2025 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216556;
	bh=B3OZEYpX773bZTkwd5jj40c5DOHtA9sWqcne/JqMlRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWk8ZWuEgZB2flrtP3Rm9wwNy9NJrPJVO3+EFPg+yDC8jyU2huZs0RRWiKiIoQyEy
	 bcMFB/TYmanSzeVDVUjgYqmBRLXFAaWubp4MndHE3f536RPxoPCbfJfPxLVi+JC0di
	 /+3wyGf6MXMWjSSDzPO02okqGfCKZrywPdGzOJtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 455/644] HID: magicmouse: avoid setting up battery timer when not needed
Date: Tue, 26 Aug 2025 13:09:06 +0200
Message-ID: <20250826110957.751970544@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 9bdc30e35cbc1aa78ccf01040354209f1e11ca22 upstream.

Currently, the battery timer is set up for all devices using
hid-magicmouse, irrespective of whether they actually need it or not.

The current implementation requires the battery timer for Magic Mouse 2
and Magic Trackpad 2 when connected via USB only. Add checks to ensure
that the battery timer is only set up when they are connected via USB.

Fixes: 0b91b4e4dae6 ("HID: magicmouse: Report battery level over USB")
Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   53 ++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 16 deletions(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -741,15 +741,29 @@ static void magicmouse_enable_mt_work(st
 		hid_err(msc->hdev, "unable to request touch data (%d)\n", ret);
 }
 
+static bool is_usb_magicmouse2(__u32 vendor, __u32 product)
+{
+	if (vendor != USB_VENDOR_ID_APPLE)
+		return false;
+	return product == USB_DEVICE_ID_APPLE_MAGICMOUSE2;
+}
+
+static bool is_usb_magictrackpad2(__u32 vendor, __u32 product)
+{
+	if (vendor != USB_VENDOR_ID_APPLE)
+		return false;
+	return product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2;
+}
+
 static int magicmouse_fetch_battery(struct hid_device *hdev)
 {
 #ifdef CONFIG_HID_BATTERY_STRENGTH
 	struct hid_report_enum *report_enum;
 	struct hid_report *report;
 
-	if (!hdev->battery || hdev->vendor != USB_VENDOR_ID_APPLE ||
-	    (hdev->product != USB_DEVICE_ID_APPLE_MAGICMOUSE2 &&
-	     hdev->product != USB_DEVICE_ID_APPLE_MAGICTRACKPAD2))
+	if (!hdev->battery ||
+	    (!is_usb_magicmouse2(hdev->vendor, hdev->product) &&
+	     !is_usb_magictrackpad2(hdev->vendor, hdev->product)))
 		return -1;
 
 	report_enum = &hdev->report_enum[hdev->battery_report_type];
@@ -811,14 +825,17 @@ static int magicmouse_probe(struct hid_d
 		return ret;
 	}
 
-	timer_setup(&msc->battery_timer, magicmouse_battery_timer_tick, 0);
-	mod_timer(&msc->battery_timer,
-		  jiffies + msecs_to_jiffies(USB_BATTERY_TIMEOUT_MS));
-	magicmouse_fetch_battery(hdev);
-
-	if (id->vendor == USB_VENDOR_ID_APPLE &&
-	    (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
-	     (id->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2 && hdev->type != HID_TYPE_USBMOUSE)))
+	if (is_usb_magicmouse2(id->vendor, id->product) ||
+	    is_usb_magictrackpad2(id->vendor, id->product)) {
+		timer_setup(&msc->battery_timer, magicmouse_battery_timer_tick, 0);
+		mod_timer(&msc->battery_timer,
+			  jiffies + msecs_to_jiffies(USB_BATTERY_TIMEOUT_MS));
+		magicmouse_fetch_battery(hdev);
+	}
+
+	if (is_usb_magicmouse2(id->vendor, id->product) ||
+	    (is_usb_magictrackpad2(id->vendor, id->product) &&
+	     hdev->type != HID_TYPE_USBMOUSE))
 		return 0;
 
 	if (!msc->input) {
@@ -873,7 +890,10 @@ static int magicmouse_probe(struct hid_d
 
 	return 0;
 err_stop_hw:
-	del_timer_sync(&msc->battery_timer);
+	if (is_usb_magicmouse2(id->vendor, id->product) ||
+	    is_usb_magictrackpad2(id->vendor, id->product))
+		del_timer_sync(&msc->battery_timer);
+
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -884,7 +904,9 @@ static void magicmouse_remove(struct hid
 
 	if (msc) {
 		cancel_delayed_work_sync(&msc->work);
-		del_timer_sync(&msc->battery_timer);
+		if (is_usb_magicmouse2(hdev->vendor, hdev->product) ||
+		    is_usb_magictrackpad2(hdev->vendor, hdev->product))
+			del_timer_sync(&msc->battery_timer);
 	}
 
 	hid_hw_stop(hdev);
@@ -901,9 +923,8 @@ static __u8 *magicmouse_report_fixup(str
 	 *   0x05, 0x01,       // Usage Page (Generic Desktop)        0
 	 *   0x09, 0x02,       // Usage (Mouse)                       2
 	 */
-	if (hdev->vendor == USB_VENDOR_ID_APPLE &&
-	    (hdev->product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
-	     hdev->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2) &&
+	if ((is_usb_magicmouse2(hdev->vendor, hdev->product) ||
+	     is_usb_magictrackpad2(hdev->vendor, hdev->product)) &&
 	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");


