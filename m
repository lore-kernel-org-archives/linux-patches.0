Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9E46E00B;
	Tue, 21 Jul 2026 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659063; cv=none; b=qOFTirSGTDXqQEmG6UP1Uktbbka+anP2iIZJ/RhmeUyDA1lkNxjqtoDDI8aL7k7e7fb9mKsbhH6AhGYkQbOfTZe4U4b0HSPp0Aei2yug7vAcDMIOh7qTp6je0RLn8Bc1DITcb9B4uyirz07C1Mgxz+maJy+3lbofRdMeNgjdqRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659063; c=relaxed/simple;
	bh=667b0p6r7hEP4LgvLST0FBMEYCVgQNLX3LG0eE5LRY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYoJ+di4iK/56eDOEnjXqW9UTiZiYJLI7dz0DLW6g4MUrBsSiKSVKizSN/FusGXLdFMzA1UDpk4CRM9eEHSC9RdnUZtE0HaqV0BdgE/JAYfw/IkUjh8722zDr/QgT7m9wATuuuQUg09tmNFpYkhK2WZ5ZiBm+QlEGQZJGsEtGGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9iA6w1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9iA6w1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FB41F000E9;
	Tue, 21 Jul 2026 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659062;
	bh=bsljJypZ5fpb5gj8a+hqbrpE48DtoNwbUxKZLPWN3Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9iA6w1ziI71O4cosWy8FgMdg466ItAKnBudZYfMj2UqWJd9eL103793mUztZSDsN
	 /ZB03MgEreMh+h5e1SasZsjZ/FM6MKjWC/KNLnWqRg24DqqHjbU/7cVwdh8rHphrOe
	 9QJgs4/2YPAz0MYJal0Bd+abyOMJ/vFRH97ejN4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1378/1611] Input: ims-pcu - add response length checks
Date: Tue, 21 Jul 2026 17:24:54 +0200
Message-ID: <20260721152546.439563730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -990,6 +1019,10 @@ ims_pcu_backlight_get_brightness(struct
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
@@ -1266,6 +1299,12 @@ static int ims_pcu_read_ofn_config(struc
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
@@ -1286,6 +1325,12 @@ static int ims_pcu_write_ofn_config(stru
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
@@ -1824,6 +1869,12 @@ static int ims_pcu_get_device_info(struc
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
@@ -1836,6 +1887,12 @@ static int ims_pcu_get_device_info(struc
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
@@ -1848,6 +1905,12 @@ static int ims_pcu_get_device_info(struc
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
 
@@ -1874,6 +1937,12 @@ static int ims_pcu_identify_type(struct
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
 
@@ -1965,6 +2034,12 @@ static int ims_pcu_init_bootloader_mode(
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


