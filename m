Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EC73F825C;
	Tue, 21 Jul 2026 22:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674387; cv=none; b=TjFjWLtUiVDe4CPP4yGoiR739To84vW0LRdv7WSkWAd0cqgeT2ePq/enbWB+Aoxx8Y2ao7Hm+NvJEjuz66TgmQk6/+A2oE1nzh/pV4Yqr8i8rUv7mR73LYuNZ0CRf+7JvtCAyGlSidjJVMzHtrRxJpukaYQiaO3nPDhKrxN8kjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674387; c=relaxed/simple;
	bh=9AGuVv3dAo2/D0f9VZjylr1R18/DDTEVFsPva7OeO70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO0Ihd/JtFkrm2Qy3gcc3i6d0t+4Yi52QjviJAxvU7Z0xKMRooyq2z9CPjOgqM3mCN5kJl8PZTN+K8Lt8Uxs3hV4ww+HBLtXR/Z0XjPlyE7cMufWhc87AnYltQGrkaaRKOc5XGeIf0cqe1JZXQUT8PC+ua6nez37WspuR9bUryA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cl7WjLF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cl7WjLF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6321F000E9;
	Tue, 21 Jul 2026 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674384;
	bh=XCdVqwf7to6/Dp0m07ffOtc0UuR4JGJ00GLwY09isDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cl7WjLF1SghhKqH4HJTaTrZZ2RFzqrm2WzaeGQD/OCXmxp9s+sQ8ErNSlwZrMlclN
	 EFXAHf6n/xKaw037pv7Rg7RVPkt1h8ldmszs/68dHCmK7TAs3cY/kB8pE48Tyyxtgf
	 hHIGIdlltob2qg3C+N/GUk+8UhpiMVKbKd60JOKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 521/699] Input: ims-pcu - add response length checks
Date: Tue, 21 Jul 2026 17:24:40 +0200
Message-ID: <20260721152407.448942605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -667,11 +676,19 @@ static int __ims_pcu_execute_bl_command(
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
@@ -699,6 +716,12 @@ static int ims_pcu_get_info(struct ims_p
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
@@ -796,6 +819,12 @@ static int ims_pcu_verify_block(struct i
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
@@ -993,6 +1022,10 @@ ims_pcu_backlight_get_brightness(struct
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
@@ -1272,6 +1305,12 @@ static int ims_pcu_read_ofn_config(struc
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
@@ -1292,6 +1331,12 @@ static int ims_pcu_write_ofn_config(stru
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
@@ -1811,6 +1856,12 @@ static int ims_pcu_get_device_info(struc
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
@@ -1823,6 +1874,12 @@ static int ims_pcu_get_device_info(struc
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
@@ -1835,6 +1892,12 @@ static int ims_pcu_get_device_info(struc
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
 
@@ -1861,6 +1924,12 @@ static int ims_pcu_identify_type(struct
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
 
@@ -1966,6 +2035,12 @@ static int ims_pcu_init_bootloader_mode(
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


