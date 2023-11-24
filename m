Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B117B39FFD;
	Fri, 24 Nov 2023 18:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmuV4UQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C259C433C8;
	Fri, 24 Nov 2023 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850219;
	bh=nkEVIRkug3plGpJSNJ5jb/8M6w0R6ZIekOvNtlOmuJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmuV4UQKp/88btAu2g1BrQ4ZX/tvMQknloQK33w0vUN1et/+ecnIwhwLkWCoc7qDq
	 Uvta6DEm0UTN2WptvXOaFYUQAHmReAgjes/zECH5BHLrrlS+C6OMsabvvftP3P5rmQ
	 aNUnLCJGCnh+qY5J+IvECalj2RHUZVTFcmtTwEN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.6 493/530] Revert "HID: logitech-dj: Add support for a new lightspeed receiver iteration"
Date: Fri, 24 Nov 2023 17:50:59 +0000
Message-ID: <20231124172043.140796747@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 5b4ffb176d7979ac66b349addf3f7de433335e00 upstream.

This reverts commit 9d1bd9346241cd6963b58da7ffb7ed303285f684.

Multiple people reported misbehaving devices and reverting this commit fixes
the problem for them. As soon as the original commit author starts reacting
again, we can try to figure out why he hasn't seen the issues (mismatching
report descriptors?), but for the time being, fix for 6.7 by reverting.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218172
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218094

Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h         |    1 -
 drivers/hid/hid-logitech-dj.c |   11 +++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -869,7 +869,6 @@
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_2		0xc534
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1	0xc539
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1	0xc53f
-#define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2	0xc547
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_POWERPLAY	0xc53a
 #define USB_DEVICE_ID_SPACETRAVELLER	0xc623
 #define USB_DEVICE_ID_SPACENAVIGATOR	0xc626
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1695,12 +1695,11 @@ static int logi_dj_raw_event(struct hid_
 		}
 		/*
 		 * Mouse-only receivers send unnumbered mouse data. The 27 MHz
-		 * receiver uses 6 byte packets, the nano receiver 8 bytes,
-		 * the lightspeed receiver (Pro X Superlight) 13 bytes.
+		 * receiver uses 6 byte packets, the nano receiver 8 bytes.
 		 */
 		if (djrcv_dev->unnumbered_application == HID_GD_MOUSE &&
-		    size <= 13){
-			u8 mouse_report[14];
+		    size <= 8) {
+			u8 mouse_report[9];
 
 			/* Prepend report id */
 			mouse_report[0] = REPORT_TYPE_MOUSE;
@@ -1984,10 +1983,6 @@ static const struct hid_device_id logi_d
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1),
 	 .driver_data = recvr_type_gaming_hidpp},
-	{ /* Logitech lightspeed receiver (0xc547) */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2),
-	 .driver_data = recvr_type_gaming_hidpp},
 
 	{ /* Logitech 27 MHz HID++ 1.0 receiver (0xc513) */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),


