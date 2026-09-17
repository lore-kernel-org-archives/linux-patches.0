Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C21534440;
	Thu, 17 Sep 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661186; cv=none; b=XzWxuOAJlit9eMb+IwWrl28Ow715m8fyjwas8co0KBQvSxEzzIY3qWcnZRDasuoa23CwAdRm+2O6KtcjkrsZkGAeEVbhqHe93TD0YZsTYp80wZC5wUfRVRONZNkJogW3AG58qAW/dUTFn5KzR/Lqx/Syawm14L29MGUoHyjiSfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661186; c=relaxed/simple;
	bh=aIIo8DU/df2sGQK3kdo2fxovepgEzaZ9zZ6pGwG89Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+XmPOu+qyCwRag1VadxKgmGsZ3JTUa0BSGdPGjwo05KN/KPkzisIpLmd+brWUD9+KSJOQLDS3H/lMribcCzFqgm0UcJ58Q0G516DTsZzeXytWvunhjh4uELnA5CQDnjy7erLXhECqqkSj/Oru83L77W4gsamvApdKtMSmJoPh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxVVvALs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxVVvALs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39AB1F00898;
	Thu, 17 Sep 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661185;
	bh=TuqT27kb8qNabMh2r0pHBKikSPZoEhNJGj3X9VkiC4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxVVvALsyTzrDQ9YMpyMe3W8Tte7aQo/i3ImMzDXFGG3au4bzqzIIxO/KOyalWqtK
	 DdPHEzd8gj31eoyrAvJ9pe30sltQne1fvbiNdPgD1NXhkTcUqLg/WqRp83bG4O6vC3
	 ajdOHyMFvCifPDl1inKqnVwuO3Y0coGMCUFKis7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0110/1250] HID: multitouch: Fix Yoga Book 9 14IAH10 touchscreen misclassification
Date: Thu, 17 Sep 2026 15:58:25 +0100
Message-ID: <20260917151554.990237216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit f1bd44b9b62c6fbdaacdd5d115ebe3fe543fcfa1 ]

The Lenovo Yoga Book 9 14IAH10 (83KJ) (17EF:6161) firmware includes a
HID_DG_TOUCHPAD application collection designed for the Windows inbox HID
driver's Win8 PTP touchpad mode.  On Linux the HID_DG_TOUCHSCREEN
collections provide the correct direct-touch interface.  The presence of
the touchpad collection causes hid-multitouch to misclassify the
touchscreen nodes as indirect buttonpads, leaving them non-functional.

Within the touchpad collection:
- HID_UP_BUTTON usages trigger the touchscreen-with-buttons heuristic
  that sets INPUT_MT_POINTER on the touchscreen applications.
- The HID_DG_TOUCHPAD application itself sets INPUT_MT_POINTER via
  mt_allocate_application(), propagating to all touchscreen nodes.
- A HID_DG_BUTTONTYPE feature (report 0x51) returns MT_BUTTONTYPE_CLICKPAD,
  setting td->is_buttonpad = true for the entire device.

Additionally, the firmware resets if any USB control request arrives while
the CDC-ACM interface is initialising (~1.18 s after enumeration).
The Win8 compliance blob (0xff00:0xc5) and Contact Count Max feature
reports in the touchscreen collections trigger GET_REPORT calls at probe
that hit this window.  Surface Switch (0x57) and Button Switch (0x58)
feature reports are sent by mt_set_modes() on every input-device open and
close, repeatedly hitting this window throughout device lifetime.

The firmware also leaves a persistent ghost contact in its contact buffer
(contact ID 2, fixed coordinates, tip always asserted) on every enumeration.
This ghost occupies a multitouch slot and prevents KWin from seeing a clean
finger-lift, causing stuck touch state.  The ghost is cleared when Input
Mode is set via HID_REQ_SET_REPORT at probe.

Fix using a report descriptor fixup in mt_report_fixup() and a class
definition update:

1. Remove the entire HID_DG_TOUCHPAD application collection.  Parsing
   HID short items from its header to the matching End Collection and
   closing the gap with memmove eliminates all three BUTTONPAD
   heuristics and the feature reports within the collection.

2. Neutralize the Win8 compliance blob feature reports remaining in the
   touchscreen collections by changing Usage Page 0xff00 to 0x0f00,
   preventing the case 0xff0000c5 branch in mt_feature_mapping() from
   issuing GET_REPORT.

3. Neutralize the Contact Count Max feature reports by changing usage
   0x55 to 0x00; set maxcontacts = 10 in the class definition so the
   driver uses the correct contact limit without querying the device.

4. Neutralize Surface Switch (0x57) and Button Switch (0x58) feature
   report usages in the Device Configuration collection so mt_set_modes()
   does not issue HID_REQ_SET_REPORT for these on every input-device
   open/close.  Input Mode (0x52) is intentionally left intact: the single
   HID_REQ_SET_REPORT at probe flushes the firmware's contact buffer and
   clears the persistent ghost contact.  By probe time the cdc-acm driver
   has already satisfied the CDC-ACM init watchdog (~130 ms), so this
   request arrives safely after the reset window has closed.

5. Add MT_QUIRK_NOT_SEEN_MEANS_UP to the MT_CLS_YOGABOOK9I class so that
   contacts not present in a frame are released via INPUT_MT_DROP_UNUSED,
   preventing stale multitouch slots from lingering if the firmware omits
   a contact from a report.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 146 ++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fd1b45ece4544..fbf6f4b9e588f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -440,11 +440,13 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE,
 	},
 		{ .name = MT_CLS_YOGABOOK9I,
-		.quirks = MT_QUIRK_ALWAYS_VALID |
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_FORCE_MULTI_INPUT |
 			MT_QUIRK_SEPARATE_APP_REPORT |
 			MT_QUIRK_HOVERING |
 			MT_QUIRK_YOGABOOK9I,
+		.maxcontacts = 10,
 		.export_all_inputs = true
 	},
 	{ .name = MT_CLS_EGALAX_P80H84,
@@ -1564,6 +1566,144 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 0;
 }
 
+/*
+ * Yoga Book 9 14IAH10 descriptor fixup.
+ *
+ * The device includes a HID_DG_TOUCHPAD application collection designed for
+ * the Windows inbox HID driver's Win8 PTP touchpad mode.  On Linux we want
+ * only the HID_DG_TOUCHSCREEN collections.  The touchpad collection (and the
+ * HID_DG_BUTTONTYPE and Win8 compliance blob features it contains) must be
+ * removed so hid-multitouch does not misclassify the touchscreen nodes as
+ * indirect buttonpads.
+ *
+ * The firmware also resets if any USB control request is received while the
+ * CDC-ACM interface is initialising (~1.18 s after enumeration).  Dropping
+ * the Win8 blob and Contact Count Max feature reports prevents the
+ * GET_REPORT calls that hid-multitouch issues at probe.
+ */
+static void mt_yogabook9_fixup(struct hid_device *hdev, __u8 *rdesc,
+			       unsigned int *size)
+{
+	/* Usage Page (Digitizer), Usage (Touch Pad), Collection (Application) */
+	static const __u8 tp_app_hdr[] = { 0x05, 0x0d, 0x09, 0x05, 0xa1, 0x01 };
+	/* Vendor Usage Page 0xff00 (Win8 compliance blob header) */
+	static const __u8 win8_page[] = { 0x06, 0x00, 0xff };
+	/* Usage (Contact Count Max = 0x55) */
+	static const __u8 ccmax_usage[] = { 0x09, 0x55 };
+	unsigned int i;
+
+	/*
+	 * Step 1: find and remove the Touch Pad application collection.
+	 * Walk HID short items from the collection header to its matching
+	 * End Collection, then close the gap with memmove.
+	 */
+	for (i = 0; i + sizeof(tp_app_hdr) <= *size; i++) {
+		if (memcmp(rdesc + i, tp_app_hdr, sizeof(tp_app_hdr)) == 0) {
+			__u8 *start = rdesc + i;
+			__u8 *coll_end = NULL;
+			__u8 *p = start;
+			unsigned int drop;
+			int depth = 0;
+
+			while (p < rdesc + *size) {
+				__u8 b = *p;
+				int ds = b & 3;
+				int item_len;
+
+				if (b == 0xfe) { /* long item */
+					if (p + 2 >= rdesc + *size)
+						break;
+					item_len = p[1] + 3;
+				} else {
+					item_len = (ds == 3) ? 5 : ds + 1;
+				}
+				if (p + item_len > rdesc + *size)
+					break;
+
+				if ((b & 0xfc) == 0xa0)
+					depth++; /* Collection */
+				else if (b == 0xc0) {
+					depth--; /* End Collection */
+					if (depth == 0) {
+						coll_end = p;
+						break;
+					}
+				}
+				p += item_len;
+			}
+
+			if (!coll_end) {
+				hid_err(hdev,
+					"Yoga Book 9: Touch Pad End Collection not found\n");
+				break;
+			}
+
+			drop = coll_end - start + 1;
+			memmove(start, coll_end + 1, rdesc + *size - coll_end - 1);
+			*size -= drop;
+			hid_dbg(hdev,
+				"Yoga Book 9: dropped Touch Pad collection (%u bytes)\n",
+				drop);
+			break;
+		}
+	}
+
+	/*
+	 * Step 2: neutralize Win8 compliance blob feature reports remaining
+	 * in the touchscreen collections.  Change Usage Page 0xff00 to 0x0f00
+	 * so the case 0xff0000c5 branch in mt_feature_mapping() is not reached
+	 * and no GET_REPORT is issued.
+	 */
+	for (i = 0; i + sizeof(win8_page) <= *size; i++) {
+		if (memcmp(rdesc + i, win8_page, sizeof(win8_page)) == 0) {
+			rdesc[i + 2] = 0x0f; /* 0xff00 -> 0x0f00 */
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized Win8 blob at offset %u\n",
+				i);
+		}
+	}
+
+	/*
+	 * Step 3: neutralize Contact Count Max feature reports.  Change usage
+	 * 0x55 (HID_DG_CONTACTMAX) to 0x00 so mt_feature_mapping() does not
+	 * issue GET_REPORT.  The class maxcontacts field provides the value.
+	 */
+	for (i = 0; i + sizeof(ccmax_usage) <= *size; i++) {
+		if (memcmp(rdesc + i, ccmax_usage, sizeof(ccmax_usage)) == 0) {
+			rdesc[i + 1] = 0x00;
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized ContactMax at offset %u\n",
+				i);
+		}
+	}
+
+	/*
+	 * Step 4: neutralize Surface Switch (0x57) and Button Switch (0x58)
+	 * feature report usages in the Device Configuration collection.
+	 * mt_set_modes() issues HID_REQ_SET_REPORT for these on every
+	 * input-device open/close; those repeated control requests hit the
+	 * firmware's CDC-ACM init window and trigger resets.
+	 *
+	 * Input Mode (0x52) is intentionally left intact.  mt_set_modes()
+	 * sends it once at probe to set the device into touchscreen mode,
+	 * which flushes the firmware's contact buffer and clears a persistent
+	 * ghost contact (cid 2, fixed coordinates) that otherwise appears on
+	 * every enumeration.  By probe time cdc_acm has already satisfied the
+	 * CDC-ACM init watchdog (~130 ms), so the single SET_REPORT for Input
+	 * Mode arrives safely after the reset window has closed.
+	 */
+	for (i = 0; i + 2 <= *size; i++) {
+		if (rdesc[i] == 0x09 &&
+		    (rdesc[i + 1] == 0x57 ||
+		     rdesc[i + 1] == 0x58)) {
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized set-modes usage 0x%02x at offset %u\n",
+				rdesc[i + 1], i);
+			rdesc[i + 1] = 0x00;
+		}
+	}
+}
+
 static const __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			     unsigned int *size)
 {
@@ -1593,6 +1733,10 @@ got: %x\n",
 		}
 	}
 
+	if (hdev->vendor == USB_VENDOR_ID_LENOVO &&
+	    hdev->product == USB_DEVICE_ID_LENOVO_YOGABOOK9I)
+		mt_yogabook9_fixup(hdev, rdesc, size);
+
 	return rdesc;
 }
 
-- 
2.53.0



