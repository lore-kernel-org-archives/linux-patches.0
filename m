Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3695E57C700;
	Wed,  9 Sep 2026 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963404; cv=none; b=qwixhLpqPFXQgog3/O2t44Ewk7r8me3lmS4+N1o3HE8lsqOijssTBsiKqEKsrcUYGVXxq17n+7ReUpGga2IdR98cpsV1Te3JDs7gGdwXuYcyX8lJQ5SXMioDTFcfpwsCDgpIUisxqg7FKtpHh5mawMiebFPe7+vYVPvyEikIBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963404; c=relaxed/simple;
	bh=c88ujwx1UEgnncwgCDFrNVLtNPrAk6vA9uMvdyRCLzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPyNNYi1bPJmXyt411QCN/3Pj0Y+Ab7pyMzuW6jSR4T6iZjEm+EhQc4zJ5FjMuIgcdXlYbhVrBSjapGJd+0C+gznDPh4kWZqPyjrsCL+AhUGt0MwXGIZ6TmOtYJZvwYbtYGG4Q/dA5XUQytZDsq+l2pClYqmJOxwV/DZiBJaCCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GASrtS8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GASrtS8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFDB1F00A3A;
	Wed,  9 Sep 2026 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963403;
	bh=JsaPNvl/GZ5h0Yela9cEEaWXBCM2Gi141lI7D2VRnAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GASrtS8dvr8WxlDJGpt1YB/XnQCUOKYV80VNxJ0TbepbP2xnP7CyJSATg0CIfOdy4
	 5qVlGgcVSmROR982NchBpkXvQbl5x932g+KJpIsH/LV/XlenZFea4fFfI8gfa79eR7
	 EcN5oYzuDwfHsHRFEtPiI2rywTtzRPRRCEoY8/ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 066/583] HID: wacom: validate report length in wacom_intuos_pro2_bt_irq
Date: Wed,  9 Sep 2026 15:35:51 +0200
Message-ID: <20260909134240.358032710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1548,6 +1548,19 @@ static int wacom_intuos_pro2_bt_irq(stru
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


