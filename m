Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9A43B498;
	Mon, 31 Aug 2026 13:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184532; cv=none; b=FXj49NvJnw96be3+/SPUnq1B064swxbQFTgSqHa1x82UfqNtLtVh0IvdpHjaKr7d53Qp9mko8Ejf6ciWl7Gpq2PwrSwyJOlOT6NZyYkoCInrObCERYqOXk/Bfey5VRZbP3xfVwGR3nVZX3iS48Lz12QVGFfmksOhLw8ilVVt2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184532; c=relaxed/simple;
	bh=n4PPTb9/YtWnQmKDDy+IfGnL16ChU38IZVdWbDw3Rtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkBmYBjSjDyTtrEN4No2sonuSw0KY10F2cj1uZOoEbF71kZiYXKZV1pIVp4BwyJ1GL3fzJWEtKP2WazTiWMGHqXZx/y4rE6IkWqf7u2zH4Ap4Sgxpuq5wjzLFnAOgRLpTQPLFl6JChNm/HadTQ63h8tM1EU56ej5TYL965H3AQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzob2bd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzob2bd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640401F000E9;
	Mon, 31 Aug 2026 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184530;
	bh=L6sOyIflEDIcRmOvNJ/Y1Mxi5uLj29OKW4RZOxrgU3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzob2bd0FDUlstCRHY9Pl+OtgrFjs8pvc9AVDQQfFXehvWX+wosRXB/PQlGpIRHoz
	 zXxYhmT7iRrh1x/YuYo0clQ+DMnW0jm7TNHxI/kI2+uY3Z+wV9zoQArLh8x+zGUUrq
	 P0c9w1fvoMuW7LufjX0BvtwfeL0ItRjzJ8f8eANQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Kodama <ckhordiasma@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/91] HID: magicmouse: re-enable multitouch after reset-resume
Date: Mon, 31 Aug 2026 15:34:29 +0200
Message-ID: <20260831133401.853829641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -993,6 +993,22 @@ static void magicmouse_remove(struct hid
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
@@ -1052,6 +1068,9 @@ static struct hid_driver magicmouse_driv
 	.event = magicmouse_event,
 	.input_mapping = magicmouse_input_mapping,
 	.input_configured = magicmouse_input_configured,
+#ifdef CONFIG_PM
+	.reset_resume = magicmouse_reset_resume,
+#endif
 };
 module_hid_driver(magicmouse_driver);
 


