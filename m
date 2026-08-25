Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F4480346;
	Tue, 25 Aug 2026 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664994; cv=none; b=rERF8inHt7bjQldpbyT4mlSzvkgb5qVBBNtuQGlis6hiPU6nFfjluOtjyVdLK9slvsd5aM6UqCq/qAlj0481pUrjQc6mZqpnqMtCWyjvLH/fJbdILW530YMilbF5/7Ctkrc/PO2iMzx7Pq9cji8UNcWa56j6peU10VleBlSi42A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664994; c=relaxed/simple;
	bh=YhUV92xKT+4gBrXkdk0QkCPbBog0tSh/MpqR1JBuSrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s99pVZsPg6gQbDLUTDvwEfnCbKGQXchY29dP57zOC32C9f5toIqMOIlzUvFAejXOIX0m8FYyQRduIoe0y4H2Pu4nM68vhK/1sSbv0GAnEe4fv/TFQkR6+k16nihFCcLi1vzKAOpBizt0IDgEvbxgkcOmvOdWEh+UxKYykpBIpK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyqVoH+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyqVoH+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A9E1F000E9;
	Tue, 25 Aug 2026 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664993;
	bh=DIsPK/bNC+TPs0jHfKrv5c+x9oYEghuk0MI1nJIt2mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyqVoH+R1wROZIdx2Lf5UKShFVDouS2Wx5gTFWeCD1PHyni6zeKGsOKLWIkU3vJmi
	 Lw0dYrKjDXswQzQvOpMyNrx1SaoQQBdx9ctv0MqbnD4LPzMqeUM/2NVToiqu41ADaL
	 qROa2rj5LDI3TV9UNuGFncBnfPcmn1JoL6RbitRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 074/101] HID: pidff: fix OOB write when hid->inputs is empty
Date: Tue, 25 Aug 2026 15:25:52 +0200
Message-ID: <20260825132544.894825482@linuxfoundation.org>
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


