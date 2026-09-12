Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAFB2BCF4C;
	Sat, 12 Sep 2026 19:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241888; cv=none; b=rX4qcWDheeHqrD3Po3+pgFZReBlRXR7dw0FKsc9AV6PUFGAFjNRk9ZHsU7LsSyVTOsglzSCNHEeTdO5ri9mIunDK+iQ244c17gAm+Ng82K/AgKIHVj/Gc127cIIV5a8LCVJwCexs+CGI8moOXi3+IeYg2wPL7U410XosgNumC2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241888; c=relaxed/simple;
	bh=sBG+zp1lBrOPPx7JUThUTqlZqge7EcEr03BI6yqUChg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz6/o972jobmvZQcJxoaO7R5925rXruiCLCu3uH7b2ZudGFHZhg2HenbpslHeGI/xjuGUXjq5vuzRKI+IPs/AzaIViRRyqEnSo+bnTBLSwZdzI0ax+2na1pYz0LhvHEH3OfFlgc+BuXfY6Me1lYhIJEz4bRPZt9eFRWKNyK2+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtNXRoNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtNXRoNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14841F000FF;
	Sat, 12 Sep 2026 19:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241886;
	bh=/+0VMqcK+zxL88X69vNKtztYtn4EYfF0ZR0EzRoWxfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtNXRoNMd92pJyRAADaBk7UnFj5qc8nnyjx3g4YShn4Ug6hD0FvSH2gaLLmuRkdqt
	 9DlYyl/Rt8rot6rZ2uExGtb8FYDpL6oqATi93ASBZnDR6gvbOB0ummpyrJxvexshqi
	 fm6VGHpkdqGHX90cskC+ByhM0xU4Ygkh5Gs8X/oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 227/798] HID: wacom: validate report length in wacom_intuos_pro2_bt_irq
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065522.341021146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

commit a8e04f3f894ccb52cfcd7e60125a9f35da4a616d upstream.

wacom_intuos_pro2_bt_irq() receives the wire report length in `len`
but never consults it before parsing. After the report-id gate it
unconditionally calls wacom_intuos_pro2_bt_pen() and then, selected by
features.type, a fixed chain of sub-parsers, none of which receive
`len`:

	wacom_intuos_pro2_bt_pen(wacom);
	if (type == INTUOSP2_BT || type == INTUOSP2S_BT) {
		wacom_intuos_pro2_bt_touch(wacom);
		wacom_intuos_pro2_bt_pad(wacom);
		wacom_intuos_pro2_bt_battery(wacom);
	} else {
		wacom_intuos_gen3_bt_pad(wacom);
		wacom_intuos_gen3_bt_battery(wacom);
	}

Each sub-parser dereferences wacom->data at fixed offsets. The furthest
byte touched on each branch is:

  INTUOSP2_BT / INTUOSP2S_BT: wacom_intuos_pro2_bt_pad() reads data[285]
	(the touchring byte), so the report must be at least 286 bytes;
  INTUOSHT3_BT ("gen3"): wacom_intuos_gen3_bt_battery() reads data[45],
	so the report must be at least 46 bytes.

features.type is selected from the VID/PID id_table entry and
wacom_setup_device_quirks() force-registers the pen/pad/touch inputs
for that type independent of the report descriptor, so a malicious or
malfunctioning paired/spoofed Bluetooth peripheral can advertise that
VID/PID and send an undersized report that still satisfies the
data[0] == 0x80/0x81 gate. The driver then reads past the received
report and forwards the bytes to userspace via evdev (MSC_SERIAL /
ABS_MISC / ABS_WHEEL on the pen and pad input nodes), an out-of-bounds
read with a concrete userspace read-back channel, and a true
out-of-bounds read on transports whose backing buffer is sized to the
(small) report descriptor rather than a fixed-size staging buffer.

This is the same class of bug commit 2f1763f62909 ("HID: wacom: fix
out-of-bounds read in wacom_intuos_bt_irq") already hardened in the
sibling wacom_intuos_bt_irq(), which guards each report id against its
minimum length before parsing.

Guard wacom_intuos_pro2_bt_irq() the same way: before parsing, reject
reports shorter than the furthest offset the selected branch actually
dereferences, warn, and bail out. Because the whole pen/touch/pad/
battery chain runs unconditionally per branch, a single up-front check
against the maximum offset (286 bytes for INTUOSP2_BT/INTUOSP2S_BT,
46 bytes for the gen3 branch) bounds every sub-parser. Returning 0 on
a short report also skips those calls for the same malformed report,
which is the safe, conservative behavior.

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Acked-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1589,6 +1589,19 @@ static int wacom_intuos_pro2_bt_irq(stru
 		return 0;
 	}
 
+	if (wacom->features.type == INTUOSP2_BT ||
+	    wacom->features.type == INTUOSP2S_BT) {
+		if (len < 286) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Pro2 BT report too short: %zu bytes\n", len);
+			return 0;
+		}
+	} else if (len < 46) {
+		dev_warn(wacom->pen_input->dev.parent,
+			 "Pro2 BT report too short: %zu bytes\n", len);
+		return 0;
+	}
+
 	wacom_intuos_pro2_bt_pen(wacom);
 	if (wacom->features.type == INTUOSP2_BT ||
 	    wacom->features.type == INTUOSP2S_BT) {


