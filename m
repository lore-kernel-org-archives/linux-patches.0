Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E0E2BCF7F;
	Tue, 25 Aug 2026 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664713; cv=none; b=Mgo1hEzuTzrxmMCjCb6NWUotcez1Y682gyLm8j2Goj/Iq49/uwPeMAJikF28Ns0qz66LUJDwgZQsi72AtWUhHMG3dC04sdoN2XIxp39N9Fz8bfXJn5iZGCm9D5vkRWzEKSpRU4tPrbV3pZ835NUMumhp0EGrxDF+gAquPsn5BtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664713; c=relaxed/simple;
	bh=mpI0rJK+Kw9MLUGPzLpeFcxn4A+bnjyTKNTQMH3AJHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEhMLWGaLib5po2QOvYzQA35784BfReiVGQwp20grBCY9PAYgFBXLpwjkQRjchQAjCly9ZduuKxHxTKzTLs644HWMaXo6GhwGhF4cApXjdOKKn9SSYphF3v/GVgYIObgL36qj10CTFynxKYTXkM4l7tPStQdpqqk6WJokeLvAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4dgAUrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4dgAUrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D6F1F000E9;
	Tue, 25 Aug 2026 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664710;
	bh=MZ84zKGddgDC3oE99M3PP0cGyoEbwYxgV9JyqAI0TZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4dgAUrtsiHv/VnB9Y1Yvtrn/L/W21wbzBQygrihmqthCmWA0pvnfgXJEt9oscVqV
	 ySyEFJ6ZDaq6OObLktnL8+BWY2LDBtjpH2dnJgCV7uv7/2N7Gedd4GadrWD/SKbHeC
	 50SqC5wuxNBQzjeMTBF7HrCbf/OyjEYhPLzaDu6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 61/82] HID: pidff: fix OOB write when hid->inputs is empty
Date: Tue, 25 Aug 2026 15:25:48 +0200
Message-ID: <20260825132543.915513037@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 67bb1074e3d2d12fa059a9cc707e89398a4e4704 upstream.

hid_pidff_init_with_quirks() derives its input_dev from

	list_entry(hid->inputs.next, struct hid_input, list)

without first checking that hid->inputs is non-empty.  The list member
of struct hid_input is at offset 0, so on an empty list list_entry()
yields &hid->inputs itself and the following hidinput->input load reads
an unrelated member of struct hid_device.  dev is then a type-confused
pointer, and force-feedback init writes through it: each
set_bit(FF_*, dev->ffbit) stores 8 bytes at dev + 192, past the end of
the object dev actually aliases, and input_ff_create() adds further
writes of a heap pointer and two function pointers.

Until hid-universal-pidff the only caller was hid_pidff_init() from
usbhid, which runs under HID_CLAIMED_INPUT and therefore always has at
least one hid_input.  universal_pidff_probe() starts the device with
HID_CONNECT_DEFAULT & ~HID_CONNECT_FF and then calls
hid_pidff_init_with_quirks() directly whenever the descriptor carries a
PID usage page, bypassing that gate.  A report descriptor whose only
application collection is on HID_UP_PID leaves hid->inputs empty while
hid_connect() still succeeds through the hidraw claim, so probe reaches
the unguarded list_entry().

The write happens in the USB probe path, on the hotplug workqueue, so
plugging in a malicious device is enough to trigger it; no attacker
software and no logged-in user are required.  KASAN reports an 8-byte
out-of-bounds write in hid_pidff_init_with_quirks() reached from
universal_pidff_probe().

Check for an empty list before deriving dev and return -ENODEV, as the
other HID force-feedback drivers already do.  universal_pidff_probe()
propagates the error and unwinds.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: f06bf8d94fff ("HID: Add hid-universal-pidff driver and supported device ids")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1539,13 +1539,20 @@ static int pidff_check_autocenter(struct
 int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 {
 	struct pidff_device *pidff;
-	struct hid_input *hidinput =
-		list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	struct ff_device *ff;
 	int max_effects;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	hid_dbg(hid, "starting pid init\n");
 
 	if (list_empty(&hid->report_enum[HID_OUTPUT_REPORT].report_list)) {


