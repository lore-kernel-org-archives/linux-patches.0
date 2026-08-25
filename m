Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70F3EC6B9;
	Tue, 25 Aug 2026 13:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664703; cv=none; b=uO5wmONENv6jiEVe8TtglfK0L8OPRJN9kucAFPyi67YGu2I9I6Ccll60wzrqgGZybnkZUZ//zRkUjBFdbbTTjseh0W8xF1+8AqJsckFQ81kDvqH8Umj4HHlL5mqPqXnG9QeEoBlhVv1deLCiwDSHTwCgpztyPYI+4rRpQURMl6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664703; c=relaxed/simple;
	bh=HlN8XYFU6s+3b0D9ghytdsQGH5iyYRvJkQOWC+f+QcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4rEOJXJ9vUF4xLwcVTJ9BJ7HOoIe/SlvdizUatwdlyiUXOGFKi2GXtJ2ADNUZjSbdQFo2YAueJMCujWvL7Bm8yVQ+P6Z2qtamuS1TWaaMlq7WRpkQ8pxVKV8tTSE+zBjByL4qTPT9PNJBZjc8lmMwhD22ngjywDZNTZrsTMi9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgXRSlv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgXRSlv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56081F000E9;
	Tue, 25 Aug 2026 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664702;
	bh=lWzsGb9RueDw1gi9/6NMHws5zrTSVzSc2ykFubE8E3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgXRSlv7NUoIB5bUVQK5joRtCwCEGVT8dtZspP3ARA5FwFfBuqRvFWsKW37e+1tcF
	 14dtREY8EhVeYIMpjzJCOe99r+CMYj55CSURR9CEzbvMQ+6TmJZMYIouhOIkSmjOXa
	 EDdCkOIclZUkZ334ljmGHt9x08ekplPaQd5YBdLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Kodama <ckhordiasma@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 58/82] HID: magicmouse: re-enable multitouch after reset-resume
Date: Tue, 25 Aug 2026 15:25:45 +0200
Message-ID: <20260825132543.804141663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Kodama <ckhordiasma@gmail.com>

commit 4253fe22b137c4ee68f36b707fdb1b44b191edc4 upstream.

When the Apple Magic Trackpad 2 (USB) is reset across a power transition
(e.g. resume from hibernation) it drops out of multitouch mode: it keeps
sending report ID 0x02 on its HID_TYPE_USBMOUSE interface, but the packet
shrinks from 21 to 8 bytes and the trackpad2 handler drops it (size < 12).
Clicks still work but pointer motion is lost until the device is re-plugged
or the driver reloaded.

Re-enable multitouch from .reset_resume via the workqueue.  Only
.reset_resume is needed; suspend-to-idle keeps the device powered and
retains multitouch.

Fixes: 87a2f10395c8 ("HID: magicmouse: Apple Magic Trackpad 2 USB-C driver support")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Christopher Kodama <ckhordiasma@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -1027,6 +1027,22 @@ static void magicmouse_remove(struct hid
 	hid_hw_stop(hdev);
 }
 
+#ifdef CONFIG_PM
+static int magicmouse_reset_resume(struct hid_device *hdev)
+{
+	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
+
+	/* The device drops out of multitouch mode on resume; re-send the
+	 * enable report.  Only the HID_TYPE_USBMOUSE interface accepts it, and
+	 * it must be deferred. Sending it inline here is too early.
+	 */
+	if (msc && hdev->type == HID_TYPE_USBMOUSE)
+		schedule_delayed_work(&msc->work, msecs_to_jiffies(500));
+
+	return 0;
+}
+#endif
+
 static const __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					   unsigned int *rsize)
 {
@@ -1090,6 +1106,9 @@ static struct hid_driver magicmouse_driv
 	.event = magicmouse_event,
 	.input_mapping = magicmouse_input_mapping,
 	.input_configured = magicmouse_input_configured,
+#ifdef CONFIG_PM
+	.reset_resume = magicmouse_reset_resume,
+#endif
 };
 module_hid_driver(magicmouse_driver);
 


