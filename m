Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869FF46C4CA;
	Tue, 21 Jul 2026 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654916; cv=none; b=tV8YiLqnwWPfgQ4o3sd7O4RUAzbbOfjwNCG5TJRHWlOgESw5IyQxltJQapyn7CNr7/InqqYeoVcZwcQi0KpkOXtG0HbUxAh1sXqDxUNf4nvKf4Kj5vZ2y3Vfxdz1ruw+sv0YVVwceG3cJWYuSObDWkZaJi5i4YGiQgKWkmVSEQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654916; c=relaxed/simple;
	bh=CEF7EIL0Yqs4+mDpryfUXEKX8pr+WCQcbYOHbfC2QIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEvZOctFdqN44yvD/SASy13klfnmGykPMTXnd9JvhMs735b0vwY9tgX7GOz+6o+ooOTctHbU+IOXxIe175QDfeEv5Zwizohvp50HFE1TNudZ4F/fUP9de/KGQ21uM5zUQsjDMaTJVhmwIp88g+7jrOplkQGk3CVd7sqgWLGN3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp0H+T5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp0H+T5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE09E1F000E9;
	Tue, 21 Jul 2026 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654915;
	bh=UTTHcIsGybl3yNas9ZvFzKB8+H46NBdA9CYGvm4fWJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bp0H+T5kAAOFQH4HuprbJNhcT9tpB580bfcfxGR+ax4eMEK0emHwgpXlz1GuWUefH
	 stRNVMIAtwqPTyDbZe/5z5qW81alXUolbfumKJLdUtb8mKhdTr0mvDh0McXV9DXa8G
	 +kO98P2QJv5Awo6ARUwORKcO/TQ1UwO/ibdcNeBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1884/2077] Input: ims-pcu - add response length checks
Date: Tue, 21 Jul 2026 17:25:57 +0200
Message-ID: <20260721152637.158268072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 48c9d92fd4ee3a8f5d2cb46c802a0eff8e67c79c upstream.

The driver processes response data from device buffers without verifying
that the device actually sent enough data. This can lead to
out-of-bounds reads or processing stale data.

Add checks for the expected response length before accessing the
buffers.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |   87 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 6 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -407,7 +407,16 @@ static void ims_pcu_destroy_gamepad(stru
 
 static void ims_pcu_report_events(struct ims_pcu *pcu)
 {
-	u32 data = get_unaligned_be32(&pcu->read_buf[3]);
+	u32 data;
+
+	/* 6-axis setting (1 byte) + button data + checksum */
+	if (pcu->read_pos < IMS_PCU_DATA_OFFSET + 1 + sizeof(data) + 1) {
+		dev_warn(pcu->dev, "Short buttons report: %d bytes\n",
+			 pcu->read_pos);
+		return;
+	}
+
+	data = get_unaligned_be32(&pcu->read_buf[IMS_PCU_DATA_OFFSET + 1]);
 
 	ims_pcu_buttons_report(pcu, data & ~IMS_PCU_GAMEPAD_MASK);
 	if (pcu->gamepad)
@@ -687,11 +696,19 @@ static int __ims_pcu_execute_bl_command(
 		return error;
 	}
 
-	if (expected_response && pcu->cmd_buf[2] != expected_response) {
-		dev_err(pcu->dev,
-			"Unexpected response from bootloader: 0x%02x, wanted 0x%02x\n",
-			pcu->cmd_buf[2], expected_response);
-		return -EINVAL;
+	if (expected_response) {
+		if (pcu->cmd_buf_len < 3) {
+			dev_err(pcu->dev, "Short response from bootloader: %d bytes\n",
+				pcu->cmd_buf_len);
+			return -EIO;
+		}
+
+		if (pcu->cmd_buf[2] != expected_response) {
+			dev_err(pcu->dev,
+				"Unexpected response from bootloader: 0x%02x, wanted 0x%02x\n",
+				pcu->cmd_buf[2], expected_response);
+			return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -719,6 +736,12 @@ static int ims_pcu_get_info(struct ims_p
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + IMS_PCU_SET_INFO_SIZE + 1) {
+		dev_err(pcu->dev, "Short GET_INFO response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	memcpy(pcu->part_number,
 	       &pcu->cmd_buf[IMS_PCU_INFO_PART_OFFSET],
 	       sizeof(pcu->part_number));
@@ -816,6 +839,12 @@ static int ims_pcu_verify_block(struct i
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_BL_DATA_OFFSET + sizeof(*fragment) + len + 1) {
+		dev_err(pcu->dev, "Short READ_APP response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	fragment = (void *)&pcu->cmd_buf[IMS_PCU_BL_DATA_OFFSET];
 	if (get_unaligned_le32(&fragment->addr) != addr ||
 	    fragment->len != len) {
@@ -1010,6 +1039,10 @@ ims_pcu_backlight_get_brightness(struct
 			 error);
 		/* Assume the LED is OFF */
 		brightness = LED_OFF;
+	} else if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 2 + 1) {
+		dev_err(pcu->dev, "Short GET_BRIGHTNESS response: %d bytes\n",
+			pcu->cmd_buf_len);
+		brightness = LED_OFF;
 	} else {
 		brightness =
 			get_unaligned_le16(&pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
@@ -1286,6 +1319,12 @@ static int ims_pcu_read_ofn_config(struc
 	if (error)
 		return error;
 
+	if (pcu->cmd_buf_len < OFN_REG_RESULT_OFFSET + 2 + 1) {
+		dev_err(pcu->dev, "Short OFN_GET_CONFIG response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	result = (s16)get_unaligned_le16(pcu->cmd_buf + OFN_REG_RESULT_OFFSET);
 	if (result < 0)
 		return -EIO;
@@ -1306,6 +1345,12 @@ static int ims_pcu_write_ofn_config(stru
 	if (error)
 		return error;
 
+	if (pcu->cmd_buf_len < OFN_REG_RESULT_OFFSET + 2 + 1) {
+		dev_err(pcu->dev, "Short OFN_SET_CONFIG response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	result = (s16)get_unaligned_le16(pcu->cmd_buf + OFN_REG_RESULT_OFFSET);
 	if (result < 0)
 		return -EIO;
@@ -1844,6 +1889,12 @@ static int ims_pcu_get_device_info(struc
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 6 + 1) {
+		dev_err(pcu->dev, "Short GET_FW_VERSION response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	snprintf(pcu->fw_version, sizeof(pcu->fw_version),
 		 "%02d%02d%02d%02d.%c%c",
 		 pcu->cmd_buf[2], pcu->cmd_buf[3], pcu->cmd_buf[4], pcu->cmd_buf[5],
@@ -1856,6 +1907,12 @@ static int ims_pcu_get_device_info(struc
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 6 + 1) {
+		dev_err(pcu->dev, "Short GET_BL_VERSION response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	snprintf(pcu->bl_version, sizeof(pcu->bl_version),
 		 "%02d%02d%02d%02d.%c%c",
 		 pcu->cmd_buf[2], pcu->cmd_buf[3], pcu->cmd_buf[4], pcu->cmd_buf[5],
@@ -1868,6 +1925,12 @@ static int ims_pcu_get_device_info(struc
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 1 + 1) {
+		dev_err(pcu->dev, "Short RESET_REASON response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	snprintf(pcu->reset_reason, sizeof(pcu->reset_reason),
 		 "%02x", pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
 
@@ -1894,6 +1957,12 @@ static int ims_pcu_identify_type(struct
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 1 + 1) {
+		dev_err(pcu->dev, "Short GET_DEVICE_ID response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	*device_id = pcu->cmd_buf[IMS_PCU_DATA_OFFSET];
 	dev_dbg(pcu->dev, "Detected device ID: %d\n", *device_id);
 
@@ -1985,6 +2054,12 @@ static int ims_pcu_init_bootloader_mode(
 		return error;
 	}
 
+	if (pcu->cmd_buf_len < IMS_PCU_DATA_OFFSET + 15 + 4 + 1) {
+		dev_err(pcu->dev, "Short QUERY_DEVICE response: %d bytes\n",
+			pcu->cmd_buf_len);
+		return -EIO;
+	}
+
 	pcu->fw_start_addr =
 		get_unaligned_le32(&pcu->cmd_buf[IMS_PCU_DATA_OFFSET + 11]);
 	pcu->fw_end_addr =


