Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A901547FAFE;
	Mon, 31 Aug 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184805; cv=none; b=OehnJ5pW9Ot3KO4H4EYekD/YgWppa2YRogPcm6IZyUwPWcdNs98X2CQNgPfMZlk7ckbqtcFXmUUHuJoPb2NKLhIS6ZBI5xyd/IqStwIR7YTXpkNovC6VPWdOWKpvzCS4GTbeKty2cKhBYQBJvW2Mag48VGhoojpCcWFxaQbRY9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184805; c=relaxed/simple;
	bh=p+fmAQWTRWN8e3ZPqDFOVcjp99Pa6GXbFJAe087gxsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDIo3nSKgplw9zqikh5EHyzEmoWtq7oKHOG1CNuQ5OyH70FR1To68cT+xCLWh1HaGc4fs1iZs+WM5YyDVmdY3SqBzDUAlvspUGkECmEP7obDEdb2cFl1/Ps71IZ9P4Ct5FrqIBIQVGw6h4TUg78rYupmNb5UBzgYZCAQpa6w4FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXmU2NYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXmU2NYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2181F000E9;
	Mon, 31 Aug 2026 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184803;
	bh=BR5lDbiy4a3VxvvOb5LwxFO5a9MmoMyMEK4azzuCNN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXmU2NYKpNxicGl5atV5bGCsZ350xlDXg2YdwCgQywau1w/0PG0GM16xZDNgBXe8u
	 Pr7KB+WfbhwxXU8TzGZsHxjYcN4s6b+h3hiKMU/YhubiHCUWqwDMrmqyYUZBfut+Dw
	 Qmj3BHlBpRxRYWMoV+kykM6Y9oJWbCVgJ/NDCenA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Kodama <ckhordiasma@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/92] HID: magicmouse: re-enable multitouch after reset-resume
Date: Mon, 31 Aug 2026 15:34:41 +0200
Message-ID: <20260831133401.953051270@linuxfoundation.org>
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

From: Christopher Kodama <ckhordiasma@gmail.com>

[ Upstream commit 4253fe22b137c4ee68f36b707fdb1b44b191edc4 ]

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
[ kept 6.6's non-const `magicmouse_report_fixup()` signature in context instead of upstream's `static const __u8 *` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -1008,6 +1008,22 @@ static void magicmouse_remove(struct hid
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
 static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 				     unsigned int *rsize)
 {
@@ -1067,6 +1083,9 @@ static struct hid_driver magicmouse_driv
 	.event = magicmouse_event,
 	.input_mapping = magicmouse_input_mapping,
 	.input_configured = magicmouse_input_configured,
+#ifdef CONFIG_PM
+	.reset_resume = magicmouse_reset_resume,
+#endif
 };
 module_hid_driver(magicmouse_driver);
 


