Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018517;
	b=4DS/gN4oF5cHTTYROtabe2kCquY0bS2U8EBqfUHK0ESqVbw855/PZuKpbNKts7UNUW8m
	 SVp7HtHs29CtGVQXcTp7WVYms8jwWlxKj5Z4koqIXKsURCYOVlbiZw5PkLAENnLUh++vy
	 4Lx8j1sgU9/3Te51ksYwMNAqi2SpHvLN+X0GlPjoUkGyinJOEtEQdOGRVYPDkDPypu2pk
	 D4pRguiPGZ1K34IBlVFyyvcVIR9DnDak/uvgRSUZYMU2KfU9KoXRKIDSMSHRt2MQGMJSF
	 dU2MbvUSJ0UrNJOucWNF3bN30oz19a4nHv8oMvhJ69p2yyFp8V4LZtL6m4u1NUYUy2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m9zzcuUH859+UdVLzgrRj1Nt3y+QAmQN4Jy0I3L3Xy8=;
	b=m/qvSBfdOgsHRVBlB22iz2IjrWukauyuTWVc++QQ9N9rnsT79vZqFa6kkhmQu045ubzA
	 p+MfZ0IyAs3mMJuucgyKbsJbfG+RvhzbdvlSccFiu9Fp+KQkUxxUWAXKhwXEGQF44PRIh
	 aypAywVgDeQiif2zfOljMCEGeDxq/IjW95pDIdik8tdrKWD8ZOu6lqsV215f8yShua2zy
	 MRIfoRfGld9HWouI9JpvMN7iT8z27rAKhtTWocFMTqnSC9vsryt5Rw1zuEP9pxszVFQ+T
	 w3X0uBxqP2XlIwD65xsXoLgfIwc8IkDnJQTmtm4+DIJRHRBNyUIGnE8UxcD/oZ23NGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR1tkum6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1627606A31C;
	Wed, 18 Nov 2026 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR1tkum6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416631F000C5;
	Wed, 18 Nov 2026 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018516;
	bh=m9zzcuUH859+UdVLzgrRj1Nt3y+QAmQN4Jy0I3L3Xy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lR1tkum6nthhhJpH1p+wD3XLrnXA+y+tVxP6G1BiEDdLehreIZzBhYAZPaiR1ZXKX
	 tS49+4Zm9jJJl/Z5gmoKIyhPc4ro27LWZWFi0tdNIHLa3U6tlyob441H+3NctJ0HMw
	 eSfUIHE3UDq/unY3euSWBTynULm2PFVxpizHMeZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1269/2651] power: supply: ab8500_charger: Decode AB8505 USB status
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150333.647990382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2b697df2b6394613a3bb168adfa8a845ad7c83d9 ]

AB8505 keeps USB link status in the same bit position as AB8500 but
defines a different five-bit value table. Reusing the AB8500 enum
treats several reserved AB8505 values as chargers and misidentifies
the AB8505 charger-fault and DM-high states.

Add an AB8505 decoder, reject reserved and non-charging states, and
retain conservative current limits for supported charger types.
Restrict the invalid-link workaround to AB8500 and stop processing
when the status register cannot be read.

Fixes: d4337660d069 ("ab8500-charger: Add AB8505_USB_LINK_STATUS")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-8-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 170 +++++++++++++++++++++-----
 1 file changed, 142 insertions(+), 28 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index b966d2e4a39f8..748c0c6900fc0 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -136,6 +136,33 @@ enum ab8500_charger_link_status {
 	USB_STAT_ACA_DOCK_CHARGER,
 };
 
+/* UsbLink1Status register values used by AB8505 */
+enum ab8505_charger_link_status {
+	AB8505_USB_STAT_OFF,
+	AB8505_USB_STAT_SDP_NOT_CHARGING,
+	AB8505_USB_STAT_SDP_CHARGING,
+	AB8505_USB_STAT_SDP_SUSPENDED,
+	AB8505_USB_STAT_CDP,
+	AB8505_USB_STAT_RESERVED_5,
+	AB8505_USB_STAT_RESERVED_6,
+	AB8505_USB_STAT_DCP,
+	AB8505_USB_STAT_ACA_RID_A,
+	AB8505_USB_STAT_ACA_RID_B,
+	AB8505_USB_STAT_ACA_RID_C,
+	AB8505_USB_STAT_RESERVED_11,
+	AB8505_USB_STAT_RESERVED_12,
+	AB8505_USB_STAT_UPSTREAM_IDGND,
+	AB8505_USB_STAT_CHARGER_NOT_OK,
+	AB8505_USB_STAT_CHARGER_DM_HIGH,
+	AB8505_USB_STAT_PHY_ENABLED,
+	AB8505_USB_STAT_UPSTREAM_NO_IDGND,
+	AB8505_USB_STAT_UPSTREAM_IDGND_VBUS,
+	AB8505_USB_STAT_CHARGER_SE1,
+	AB8505_USB_STAT_CARKIT_1,
+	AB8505_USB_STAT_CARKIT_2,
+	AB8505_USB_STAT_ACA_DOCK_CHARGER,
+};
+
 enum ab8500_usb_state {
 	AB8500_BM_USB_STATE_RESET_HS,	/* HighSpeed Reset */
 	AB8500_BM_USB_STATE_RESET_FS,	/* FullSpeed/LowSpeed Reset */
@@ -699,20 +726,102 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 }
 
 /**
- * ab8500_charger_max_usb_curr() - get the max curr for the USB type
+ * ab8505_charger_max_usb_curr() - get the max current for the USB type
  * @di:			pointer to the ab8500_charger structure
  * @link_status:	the identified USB type
  *
- * Get the maximum current that is allowed to be drawn from the host
- * based on the USB type.
+ * Decode AB8505-specific UsbLink1Status values and get the maximum current
+ * that is allowed to be drawn based on the USB type.
  * Returns error code in case of failure else 0 on success
  */
+static int ab8505_charger_max_usb_curr(struct ab8500_charger *di,
+				       u8 link_status)
+{
+	int ret = 0;
+
+	di->is_aca_rid = 0;
+
+	switch (link_status) {
+	case AB8505_USB_STAT_SDP_NOT_CHARGING:
+	case AB8505_USB_STAT_SDP_CHARGING:
+	case AB8505_USB_STAT_SDP_SUSPENDED:
+	case AB8505_USB_STAT_CDP:
+	case AB8505_USB_STAT_CHARGER_DM_HIGH:
+	case AB8505_USB_STAT_UPSTREAM_NO_IDGND:
+	case AB8505_USB_STAT_UPSTREAM_IDGND_VBUS:
+	case AB8505_USB_STAT_CHARGER_SE1:
+	case AB8505_USB_STAT_CARKIT_1:
+	case AB8505_USB_STAT_CARKIT_2:
+	case AB8505_USB_STAT_ACA_DOCK_CHARGER:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P5;
+		break;
+	case AB8505_USB_STAT_DCP:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P5;
+		break;
+	case AB8505_USB_STAT_ACA_RID_A:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P5;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_ACA_RID_B:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P3;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_ACA_RID_C:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P5;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_OFF:
+		if (di->vbus_detected) {
+			di->usb_device_is_unrecognised = true;
+			di->max_usb_in_curr.usb_type_max_ua =
+				USB_CH_IP_CUR_LVL_1P5;
+			break;
+		}
+		fallthrough;
+	case AB8505_USB_STAT_UPSTREAM_IDGND:
+	case AB8505_USB_STAT_PHY_ENABLED:
+		dev_err(di->dev, "USB Type - Charging not allowed\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	case AB8505_USB_STAT_CHARGER_NOT_OK:
+		di->flags.vbus_collapse = true;
+		dev_err(di->dev, "USB Type - VBUS has collapsed\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	case AB8505_USB_STAT_RESERVED_5:
+	case AB8505_USB_STAT_RESERVED_6:
+	case AB8505_USB_STAT_RESERVED_11:
+	case AB8505_USB_STAT_RESERVED_12:
+	default:
+		dev_err(di->dev, "USB Type - Unknown\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ab8500_charger_max_usb_curr() - get the max current for the USB type
+ * @di:			pointer to the ab8500_charger structure
+ * @link_status:	the identified USB type
+ *
+ * Get the maximum current that is allowed to be drawn based on the USB type.
+ * Returns error code in case of failure else 0 on success.
+ */
 static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
-		enum ab8500_charger_link_status link_status)
+				       u8 link_status)
 {
 	int ret = 0;
 
 	di->usb_device_is_unrecognised = false;
+	if (is_ab8505(di->parent)) {
+		ret = ab8505_charger_max_usb_curr(di, link_status);
+		goto out;
+	}
 
 	/*
 	 * Platform only supports USB 2.0.
@@ -721,7 +830,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	 * should set USB_CH_IP_CUR_LVL_0P5.
 	 */
 
-	switch (link_status) {
+	switch ((enum ab8500_charger_link_status)link_status) {
 	case USB_STAT_STD_HOST_NC:
 	case USB_STAT_STD_HOST_C_NS:
 	case USB_STAT_STD_HOST_C_S:
@@ -825,6 +934,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		break;
 	}
 
+out:
 	di->max_usb_in_curr.set_max_ua = di->max_usb_in_curr.usb_type_max_ua;
 	dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
 		link_status, di->max_usb_in_curr.set_max_ua);
@@ -866,8 +976,7 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 		val = (val & AB8500_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
 	else
 		val = (val & AB8505_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
-	ret = ab8500_charger_max_usb_curr(di,
-		(enum ab8500_charger_link_status) val);
+	ret = ab8500_charger_max_usb_curr(di, val);
 
 	return ret;
 }
@@ -929,8 +1038,7 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		if (val)
 			break;
 	}
-	ret = ab8500_charger_max_usb_curr(di,
-		(enum ab8500_charger_link_status) val);
+	ret = ab8500_charger_max_usb_curr(di, val);
 
 	return ret;
 }
@@ -2277,6 +2385,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	int ret;
 	u8 val;
 	u8 link_status;
+	u8 link_status_mask;
 
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, usb_link_status_work);
@@ -2303,20 +2412,22 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
 					AB8500_USB_LINK1_STAT_REG, &val);
 
-	if (ret >= 0)
-		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
-	else
-		dev_dbg(di->dev, "Error reading USB link status\n");
+	if (ret < 0) {
+		dev_err(di->dev, "Error reading USB link status\n");
+		return;
+	}
+	dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
 
 	if (is_ab8500(di->parent))
-		link_status = AB8500_USB_LINK_STATUS;
+		link_status_mask = AB8500_USB_LINK_STATUS;
 	else
-		link_status = AB8505_USB_LINK_STATUS;
+		link_status_mask = AB8505_USB_LINK_STATUS;
+	link_status = (val & link_status_mask) >> USB_LINK_STATUS_SHIFT;
 
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & link_status) >> USB_LINK_STATUS_SHIFT) ==
-				USB_STAT_NOT_VALID_LINK &&
-				di->invalid_charger_detect_state == 0) {
+		if (is_ab8500(di->parent) &&
+		    link_status == USB_STAT_NOT_VALID_LINK &&
+		    di->invalid_charger_detect_state == 0) {
 			dev_dbg(di->dev,
 					"Invalid charger detected, state= 0\n");
 			/*Enable charger*/
@@ -2339,18 +2450,21 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 			abx500_mask_and_set_register_interruptible(di->dev,
 					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
 					USB_CH_DET, 0x00);
-			/*Check link status*/
-			if (is_ab8500(di->parent))
-				ret = abx500_get_register_interruptible(di->dev,
-					AB8500_USB, AB8500_USB_LINE_STAT_REG,
-					&val);
-			else
-				ret = abx500_get_register_interruptible(di->dev,
-					AB8500_USB, AB8500_USB_LINK1_STAT_REG,
-					&val);
+			/* Check link status */
+			ret = abx500_get_register_interruptible(di->dev,
+								AB8500_USB,
+								AB8500_USB_LINE_STAT_REG,
+								&val);
+			if (ret < 0) {
+				dev_err(di->dev,
+					"Error reading USB link status\n");
+				return;
+			}
 
+			link_status = (val & link_status_mask) >>
+				USB_LINK_STATUS_SHIFT;
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-				(val & link_status) >> USB_LINK_STATUS_SHIFT);
+				link_status);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
-- 
2.53.0



