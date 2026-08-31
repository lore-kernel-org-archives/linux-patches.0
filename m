Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF55921EF;
	Mon, 31 Aug 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184268; cv=none; b=kepAtklufD9RHbf3yHw4MLPbjZL+xI9PvQoVFUKtJrka530m5IcXfx44L2TjPAomMg9Y7CyydO6hzsYnPsvsT0pNMDqukEuZe4ov9dFyYvCqraXJ9W1COItrM2aPhHvUbVGex1jB6wnNV7InxyH7X7e3YOEeIlmXlO04Jz+533M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184268; c=relaxed/simple;
	bh=XVJJJPOxhHfY8sfodOVyU6RC1WNDrfGFIUyGlvx+Vh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuIcCwLesL7CapiGnNCpXEjHfjiD6/+Mq/EUJ7AYO02LxuDw2E7iLOT2F/4MsECZ4YV9Qzr1a2+Dn3aEGSiMpj+88MKMWbTzho1qVmvemROTVkpCSCD5glo3T3g36y0CJfSXqFh7ysvMNzm+G9WRZpxIYN2QTcFkBIB1LWe+puA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hc6iaqsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hc6iaqsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB901F000E9;
	Mon, 31 Aug 2026 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184265;
	bh=I2N+lVHK2k5wiEnJ+FPX4O1Jyr1m3rgabI7/jHYcKMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc6iaqsMkcR4eAX9jlhXO3gj60uw24GRfZfeivfH+3F6lTeMHYbBtaXsN5oYuxOzs
	 IG57jM5JVmukCeu+gXThqvAPx3g1ilLdQzs7pl39qiLdY41lsLTgA1zgHp5evML+UR
	 NAYQBMwZyVDi+Et4bPvgyFIN/Yt1ZX4G5hnw5JuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 47/99] HID: pidff: fix OOB write when hid->inputs is empty
Date: Mon, 31 Aug 2026 15:34:16 +0200
Message-ID: <20260831133402.398783383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

[ Upstream commit 67bb1074e3d2d12fa059a9cc707e89398a4e4704 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1405,13 +1405,20 @@ static int pidff_check_autocenter(struct
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


