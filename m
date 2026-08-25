Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5AF47FB0E;
	Tue, 25 Aug 2026 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665026; cv=none; b=gkt7ZG4SkWyRLOxFVZqKy9DKWhrWtQr2ZuRXZK3Xw1UryiCOK3+PrnQCi/jHKenU2BFsGLxznwxj1K24o+JXAxxPVvszz6R0zn7R3uijJDDvOLzUAr8ctx5q+xo+2Al1vvnEKSXPzpYBKoGaEYhr1bCkL7MM3bHBv+5tuKxLoFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665026; c=relaxed/simple;
	bh=XmNcoSIGkvtk+lfCPtB1n9tOEvRlDtDvhFzK2pWfwMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSgdTgBjP1rtMP52lADwvCcEw6iTXPq5leJB45KAB73NxF24J7YbCB5/b8ppHQ0TGJccBnS7mFPT+Fu5ZUdchktPuh4GFxtQfdk/b2Eq+Uv8xABAzIFSiDE1CTYzKOgIA3SLS6eOyGbZ8ZH4uXMsXb6F1Eo6Vd6SozYLqPTxZyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vv+UpMc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vv+UpMc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAE11F000E9;
	Tue, 25 Aug 2026 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665024;
	bh=0KnwWd3FaFAw4KDlp5UeA38W3PIIr05s/Zc7yMf5EL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vv+UpMc9CwTg2JAn6xYoV0UxtPqvucxFdKwd7BUB4lQCTTVxPR/cOUZbcJtCDRYji
	 DejrfivPzkNZG7e5uIic5QWpSh1Ovj8z94tKZWiq4qbjFdo2CAzERVtqo+352G+X95
	 RUWb1PJzOve8DIDIqBHhnoRBy+90eBLc4h+70fAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 083/101] HID: huawei: fix missing hid_is_usb() check
Date: Tue, 25 Aug 2026 15:26:01 +0200
Message-ID: <20260825132545.183710281@linuxfoundation.org>
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
 drivers/hid/hid-huawei.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-huawei.c b/drivers/hid/hid-huawei.c
index 6a616bf21b38..ee3fc6f68475 100644
--- a/drivers/hid/hid-huawei.c
+++ b/drivers/hid/hid-huawei.c
@@ -44,11 +44,12 @@ static const __u8 huawei_cd30_kbd_rdesc_fixed[] = {
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
-- 
2.55.0



