Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F039C386C3B;
	Tue, 25 Aug 2026 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665023; cv=none; b=WRFN3cPlTEK9OT6VUMwStJJO0b47EI9dUFJMpDJr/jGAar42NqinwiDCJ4dnfRmTwr3Y6btUVJxaTA/QfNNg/1uSaeoTlSBlvXwgN9Kcs/0avwAM+YQuuIKlFZARyNEUFrJWqkcRhJ9mWBqBRJx1SOWGp0M8WovI0H5aioZ5iAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665023; c=relaxed/simple;
	bh=4ljEcVk43FJIB6Ic3+lHGRUuihq5dZXcVi6T8V+Wh+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7A0NhwKMmXnZe/xvBbkhjvAYx2ZbZvxfCjA4hTgxRmUpUvnK1ABRYcmzM1F7s3b0pOmODC+3ezbxX4d1Qu5dPAulL1CNtKrO7CvIxvMJAPXc+XzD8qofoXy+CxUYpHh6eETQipTaRe4v/Bs9OFmnclwqxHRb0Z5UWm0I4sGvuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GzZyDyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GzZyDyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5067F1F000E9;
	Tue, 25 Aug 2026 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665021;
	bh=MrU3PiR+vBdw/W8BWZZH6UIgRR1v3V57NT18+RaOjCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GzZyDyj3c+L3qhCEW9cuGrs+hiyLVuKn03y1RUzT1qgKZwB4rEFEli9zZd40MOsM
	 exdBih1flql5MObTUk5rzImq5ZzEF4ECEqryQAs7pN0INP/QvkpquUz2s+zUGH2k91
	 dNxwR+9xWkLsuNzJ9mNOVCy3aTFdpEoXS3eGsxS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 082/101] HID: asus: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:26:00 +0200
Message-ID: <20260825132545.158964653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 02bf61dfb44f17ec187d1da1a82495951bbd12df upstream.

to_usb_interface() can only be used on a hid_device whose parent is really
USB; uhid can create devices that identify as being on BUS_USB, but don't
actually have a USB parent.
Fix the use of to_usb_interface() without a hid_is_usb() check.

I have verified that it is currently possible to trigger a kernel splat due
to this bug in an ASAN build, and that this commit fixes the issue.

Fixes: 00e005c952f7 ("hid-asus: check ROG Ally MCU version and warn")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -753,7 +753,7 @@ static int asus_kbd_register_leds(struct
 			return ret;
 	}
 
-	if (drvdata->quirks & QUIRK_ROG_ALLY_XPAD) {
+	if ((drvdata->quirks & QUIRK_ROG_ALLY_XPAD) && hid_is_usb(hdev)) {
 		intf = to_usb_interface(hdev->dev.parent);
 		udev = interface_to_usbdev(intf);
 		validate_mcu_fw_version(hdev,


