Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A4E472F72;
	Tue, 25 Aug 2026 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664720; cv=none; b=StvCC7h7sJ/Yx9i+uskKIPVSUjSYa4nE7fCcmuNLD7h41A61kEwxB7xxKFmneQ8ezBU0qkWtlS+ktcuPG50Adnoxyq5NB0bsmKpnXM6777O+Fo5GlMQ4E40Ww0IvC4ScsCzMdWzjCYScIvXsGjrz6ZsMpFZQydmeRqYaMGCrL/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664720; c=relaxed/simple;
	bh=+v2A4wSNxpcn7bmffJSPi8lD2axfm5ScmfpK+EMenDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMAEGVuOrimoawrCSFj/LY6JgFQg8DWcitaV+N2Bjg65nYP3tUVFUjQL/hJxsfJq+3VmUCkvKvQZHnmkrmGlDsr9y5N4EJo0ZZGDIhI5fmUOFSSNvj3N8ETyicb+6hdAL73psYTdzpYbn/qhYLIThjuOr6+Dcu1XXLSgf5HnQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzNs5v1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzNs5v1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329721F000E9;
	Tue, 25 Aug 2026 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664719;
	bh=0WWSiGocIDlA56q9CFmocKOknktUkxJG0sTZbBrkz50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzNs5v1o5PUcQJaSWFb5K2OjhMEVPhEbmqDxj8Y+0rBMOpakzztv9ho6CAgObqX7k
	 Rp4QBuUYz8FhbsP0E/49hlnPk0TakJygVOcoV07xzI8P+D0rGM5q/ruCBT02k4/H2x
	 WKnKLADqzAh48aDwgiACjUV1hlVKh0eHjJNHT5OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 64/82] HID: huawei: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:25:51 +0200
Message-ID: <20260825132544.024063399@linuxfoundation.org>
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

commit 4cdb6b4b34d7823254f6e1b22faf56c96ac57fb9 upstream.

to_usb_interface() can only be used on a hid_device whose parent is really
USB; uhid can create devices that identify as being on BUS_USB, but don't
actually have a USB parent.
Fix the use of to_usb_interface() without a hid_is_usb() check.

I have verified that it is currently possible to trigger a kernel splat due
to this bug in an ASAN build, and that this commit fixes the issue.

Fixes: e93faaca84b7 ("HID: huawei: fix CD30 keyboard report descriptor issue")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-huawei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-huawei.c
+++ b/drivers/hid/hid-huawei.c
@@ -44,11 +44,12 @@ static const __u8 huawei_cd30_kbd_rdesc_
 static const __u8 *huawei_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 				  unsigned int *rsize)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_interface *intf = hid_is_usb(hdev) ?
+			to_usb_interface(hdev->dev.parent) : NULL;
 
 	switch (hdev->product) {
 	case USB_DEVICE_ID_HUAWEI_CD30KBD:
-		if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
+		if (!intf || intf->cur_altsetting->desc.bInterfaceNumber == 1) {
 			if (*rsize != sizeof(huawei_cd30_kbd_rdesc_fixed) ||
 				memcmp(huawei_cd30_kbd_rdesc_fixed, rdesc,
 					sizeof(huawei_cd30_kbd_rdesc_fixed)) != 0) {


