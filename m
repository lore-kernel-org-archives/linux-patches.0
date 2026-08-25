Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1123386C3B;
	Tue, 25 Aug 2026 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665057; cv=none; b=lr1pv01ES5CJTpxWztULJu+Ihy8/SDqtmAA2BHSfRFn5r2ZsM/ybxMKGDpcmS1ug6caMKiM+XJabsJ+Dz5IEaBzbsUHFfJQveEQ1atd/M4EDyc54EOAGZu8Rgw+zW+FihtsNEjV9FxRL+21mipd13OVoU1TdbLeNpbYrX+tyb5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665057; c=relaxed/simple;
	bh=SQrR4JyQrPWH8wJY2WX3h275xTxx+e9SObqSPp1oCF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBrooMcfi5T3UaOpq1vGmSNQuyGsm4XohwOiPWFWe4GDZMHHmKwcyOgYLn31qNZ3EurHok7oSFlFT4+XFao/lDeOFL/mUREJRbV6aVUAoVpv7DHYCsqBXyssCC/BXVmuczRk2Qzw7mjjE0poS3GvhYb1t5cGVgwk2979VBOk9bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNKXlkxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNKXlkxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435011F000E9;
	Tue, 25 Aug 2026 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665055;
	bh=G6O1JF0qyH6iHHBRsq9Po8XExIHGhW6SpqU6S43afVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNKXlkxYI0NrtuUPCedUSkPxMYXc1qU5+f5Pq0k4cavr91m9oco1ecRlxu6XNJV3d
	 W6hQ1qyMiorq/6PtYDYnzORtSAfvlMMsvsTCemwxheEtyxY+vXQD/GM/hGAYhEk35z
	 VLkTk9GiPxqOwUNNAjVSeDa0s8jSG4HAE4QViQKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 087/101] HID: rapoo: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:26:05 +0200
Message-ID: <20260825132545.292641648@linuxfoundation.org>
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

commit b57af2448268c30c25509a832b6ff6dc27176b28 upstream.

to_usb_interface() can only be used on a hid_device whose parent is really
USB; uhid can create devices that identify as being on BUS_USB, but don't
actually have a USB parent.
Fix the use of to_usb_interface() without a hid_is_usb() check.

Add a dependency on USB_HID for hid_is_usb(), as other HID drivers do; the
alternative would be to provide a simple stub implementation on !USB_HID
builds.

I have verified that it is currently possible to trigger a kernel splat due
to this bug in an ASAN build, and that this commit fixes the issue.

Fixes: b3b1c68fb726 ("HID: rapoo: Add support for side buttons on RAPOO 0x2015 mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig     |    1 +
 drivers/hid/hid-rapoo.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1026,6 +1026,7 @@ config HID_PXRC
 
 config HID_RAPOO
 	tristate "Rapoo non-fully HID-compliant devices"
+	depends on USB_HID
 	help
 	Support for Rapoo devices that are not fully compliant with the
 	HID standard.
--- a/drivers/hid/hid-rapoo.c
+++ b/drivers/hid/hid-rapoo.c
@@ -36,7 +36,7 @@ static int rapoo_probe(struct hid_device
 		return ret;
 	}
 
-	if (hdev->bus == BUS_USB) {
+	if (hid_is_usb(hdev)) {
 		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 
 		if (intf->cur_altsetting->desc.bInterfaceNumber != 1)


