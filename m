Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D432BCF7F;
	Tue, 25 Aug 2026 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664735; cv=none; b=h4qv+YSwrcke9QAKxkTJL/rXhGa4jC9hI/CrXak8J9BhuPuNB9jrVncmwcCY7pWJrYErin378hv7qwFBY+R/c+5Kex8wh/lfyUy60g7gNcz2QErPDnjaPWHOoR/FdZkeFjyjERyDNfsFTsV3KxnsyCluNmRSC13OpHYBOSmgqB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664735; c=relaxed/simple;
	bh=IWfFO7ll1rGm41xKdID9lC7l63x5He3ypGGUMGxbyPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcJNO7RuX5JIjVtJTcglW67MTUXLIQwxTcD/CkIgDNVbHx7kEv7R8ER7NvaS7j2dgB/E04sHmpd1K6VbdQFcieKO5V0BZhSB+2fifGgw0VjCWH4vuzSvIi5DsjE3ItZlVsUfqL/Li98LediVRY8J1Q1iLpSWHxHJpAmyd/1Fa6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRe0/Wii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRe0/Wii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7FC1F000E9;
	Tue, 25 Aug 2026 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664734;
	bh=kuoWvJzfhe7zvjwkTp2u/aqOxTDx4GbWZUZZ1vbpTnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRe0/Wiij0yedjjVCGh+Ix9P739d0FAkaw3ZVjxftHOlA+G+Yae3BRwwGgjqbxFhI
	 gL3JUJVjanDG3ck3ZisxA5TEeKtqhhI0Hgu1PNTZA1JmKzvSPYBQK77Fgw8eKZ3oMR
	 /ex9gwA3Sb+jyb2zGcQukbsHx3louX6UVE0aSKLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 68/82] HID: rapoo: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:25:55 +0200
Message-ID: <20260825132544.160978358@linuxfoundation.org>
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
@@ -1048,6 +1048,7 @@ config HID_PXRC
 
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


