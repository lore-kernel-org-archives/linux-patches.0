Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB4847FB19;
	Tue, 25 Aug 2026 13:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664719; cv=none; b=ctfADqo+B68E5k7jv9NEUv8DzXGAmJ0dq9MT08Jsok6zQ4kbgSLoSKEGHqfl+UIU9JXkvpvjKJtpBZ/Yk2xV7WF3LYSnt5BjGQVlVe2kqSZsrTSQOhVeN0ja2LZz+xasQ7u7Zt5hvKpj+EyUWPcdUR4at5zzhc8v7NLtkEEL6To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664719; c=relaxed/simple;
	bh=C9jxMwze5K7N3pqXVOucp22vIVMEj1TNqCsu01/VaEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaL+TtViu+c9kD4T+Reqm2XzgKAZ9cVbpb9aKRUyD0/L5nPeGkI4BkpiGuupxQeokWv/41G0K8yHSpapOxHYhy3yDqkaJ9tHkOXmBRJ0X/bKvxV8WbdK/IZoekjJVIITPyi7hDhCkriAiPUYOY71FOSLYV8liVfH1wr7qCC66cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSzWCsa+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSzWCsa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4483F1F00A3A;
	Tue, 25 Aug 2026 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664716;
	bh=w1KifF1AquXk6JD51ieuUc4x9JA8s1qRLYo1ZT7baZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSzWCsa+l8I58YLEGY0c/JuNokHkNwbw/ZvMKN348TCgV6GE9gb2OVPB20DIh6kzm
	 j24Os3D2cAyj2xYpA2Cmp6dkN+oJC8yBpFop/BHD1wo9uAyxjsReJDZInsdFGK8whW
	 UCwEBPj8JE45AWCs3ylsJQj2b9pZa/TV95GEBmBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 63/82] HID: asus: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:25:50 +0200
Message-ID: <20260825132543.988797616@linuxfoundation.org>
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


