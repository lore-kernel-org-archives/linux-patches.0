Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815B44AB9F;
	Tue, 21 Jul 2026 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674698; cv=none; b=uvQIIPygyydXVW98xs/DTBKAYXYqvnxrXMPMCIwdhev4jhn0M8ZQ+1/pr0S86hbia+IRKj+W9K96gpTAXvt8lgqFrOTMQiWr7lDaj6YVLLnKGyyU4qFKmJavHQr+zKiUitmSyfpMTHeCBqOBu0Cm7c0k7zg1dfKOb0GKKI1iwdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674698; c=relaxed/simple;
	bh=VcfDgr3U3vpvRhwK0zDkttqWKrJvLmE685kPIvXWZmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk1PZU0vWW9JBntyIfhrNfVKcaUGbbFjU4/Q1GKDW5cvvWsv0d+VWpHPKZumx9PwX4plZqS+FDO1xL2F6whAqfGsj07JX8GVPGMFoh/Cd5zv1HjlL8dpOCyZvfOi2sggxIoG3hJnLckwLcnvWAiQO/A49Di2Vp4XG7trx6cgtiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOG11bJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOG11bJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF20C1F00A3D;
	Tue, 21 Jul 2026 22:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674695;
	bh=bMDw7KGTUEah2eSUlIeI4972apOOvDhjOlSv1x0GMhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOG11bJT1g02FZlL5zYce3vlrZ95GxXF3AsdnXiH0XtM9wIaISeYwz1RtVZEUqOkR
	 FzfW5q+spX6a35sp6ve+8BGGkg+kBS7O98FijxC6DQvGihKj7jlYwTRuxJUfnJRFFi
	 hGX/gwU64SXrOE2vfdakGbRxbXuNKyYr2Xir/t5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 596/699] Bluetooth: btintel: Check firmware version before download
Date: Tue, 21 Jul 2026 17:25:55 +0200
Message-ID: <20260721152409.175714528@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ac0565462e330a2b762ca5849a4140b29d725786 ]

This checks the firmware build number, week and year against the
repective loaded version. If details are a match, skip the download
process.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: c5b600a3c05b ("Bluetooth: btusb: fix use-after-free on marvell probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c   |  106 +++++++++++++++++++++++++++++++++---------
 drivers/bluetooth/btintel.h   |    5 +
 drivers/bluetooth/btusb.c     |    9 +++
 drivers/bluetooth/hci_intel.c |    7 +-
 4 files changed, 101 insertions(+), 26 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -24,6 +24,14 @@
 #define ECDSA_OFFSET		644
 #define ECDSA_HEADER_LEN	320
 
+#define CMD_WRITE_BOOT_PARAMS	0xfc0e
+struct cmd_write_boot_params {
+	u32 boot_addr;
+	u8  fw_build_num;
+	u8  fw_build_ww;
+	u8  fw_build_yy;
+} __packed;
+
 int btintel_check_bdaddr(struct hci_dev *hdev)
 {
 	struct hci_rp_read_bd_addr *bda;
@@ -841,7 +849,7 @@ static int btintel_sfi_ecdsa_header_secu
 
 static int btintel_download_firmware_payload(struct hci_dev *hdev,
 					     const struct firmware *fw,
-					     u32 *boot_param, size_t offset)
+					     size_t offset)
 {
 	int err;
 	const u8 *fw_ptr;
@@ -854,21 +862,6 @@ static int btintel_download_firmware_pay
 	while (fw_ptr - fw->data < fw->size) {
 		struct hci_command_hdr *cmd = (void *)(fw_ptr + frag_len);
 
-		/* Each SKU has a different reset parameter to use in the
-		 * HCI_Intel_Reset command and it is embedded in the firmware
-		 * data. So, instead of using static value per SKU, check
-		 * the firmware data and save it for later use.
-		 */
-		if (le16_to_cpu(cmd->opcode) == 0xfc0e) {
-			/* The boot parameter is the first 32-bit value
-			 * and rest of 3 octets are reserved.
-			 */
-			*boot_param = get_unaligned_le32(fw_ptr + frag_len +
-							 sizeof(*cmd));
-
-			bt_dev_dbg(hdev, "boot_param=0x%x", *boot_param);
-		}
-
 		frag_len += sizeof(*cmd) + cmd->plen;
 
 		/* The parameter length of the secure send command requires
@@ -897,28 +890,101 @@ done:
 	return err;
 }
 
+static bool btintel_firmware_version(struct hci_dev *hdev,
+				     u8 num, u8 ww, u8 yy,
+				     const struct firmware *fw,
+				     u32 *boot_addr)
+{
+	const u8 *fw_ptr;
+
+	fw_ptr = fw->data;
+
+	while (fw_ptr - fw->data < fw->size) {
+		struct hci_command_hdr *cmd = (void *)(fw_ptr);
+
+		/* Each SKU has a different reset parameter to use in the
+		 * HCI_Intel_Reset command and it is embedded in the firmware
+		 * data. So, instead of using static value per SKU, check
+		 * the firmware data and save it for later use.
+		 */
+		if (le16_to_cpu(cmd->opcode) == CMD_WRITE_BOOT_PARAMS) {
+			struct cmd_write_boot_params *params;
+
+			params = (void *)(fw_ptr + sizeof(*cmd));
+
+			bt_dev_info(hdev, "Boot Address: 0x%x",
+				    le32_to_cpu(params->boot_addr));
+
+			bt_dev_info(hdev, "Firmware Version: %u-%u.%u",
+				    params->fw_build_num, params->fw_build_ww,
+				    params->fw_build_yy);
+
+			return (num == params->fw_build_num &&
+				ww == params->fw_build_ww &&
+				yy == params->fw_build_yy);
+		}
+
+		fw_ptr += sizeof(*cmd) + cmd->plen;
+	}
+
+	return false;
+}
+
 int btintel_download_firmware(struct hci_dev *hdev,
+			      struct intel_version *ver,
 			      const struct firmware *fw,
 			      u32 *boot_param)
 {
 	int err;
 
+	/* SfP and WsP don't seem to update the firmware version on file
+	 * so version checking is currently not possible.
+	 */
+	switch (ver->hw_variant) {
+	case 0x0b:	/* SfP */
+	case 0x0c:	/* WsP */
+		/* Skip version checking */
+		break;
+	default:
+		/* Skip download if firmware has the same version */
+		if (btintel_firmware_version(hdev, ver->fw_build_num,
+					     ver->fw_build_ww, ver->fw_build_yy,
+					     fw, boot_param)) {
+			bt_dev_info(hdev, "Firmware already loaded");
+			/* Return -EALREADY to indicate that the firmware has
+			 * already been loaded.
+			 */
+			return -EALREADY;
+		}
+	}
+
 	err = btintel_sfi_rsa_header_secure_send(hdev, fw);
 	if (err)
 		return err;
 
-	return btintel_download_firmware_payload(hdev, fw, boot_param,
-						 RSA_HEADER_LEN);
+	return btintel_download_firmware_payload(hdev, fw, RSA_HEADER_LEN);
 }
 EXPORT_SYMBOL_GPL(btintel_download_firmware);
 
 int btintel_download_firmware_newgen(struct hci_dev *hdev,
+				     struct intel_version_tlv *ver,
 				     const struct firmware *fw, u32 *boot_param,
 				     u8 hw_variant, u8 sbe_type)
 {
 	int err;
 	u32 css_header_ver;
 
+	/* Skip download if firmware has the same version */
+	if (btintel_firmware_version(hdev, ver->min_fw_build_nn,
+				     ver->min_fw_build_cw, ver->min_fw_build_yy,
+				     fw, boot_param)) {
+		bt_dev_info(hdev, "Firmware already loaded");
+		/* Return -EALREADY to indicate that firmware has already been
+		 * loaded.
+		 */
+		return -EALREADY;
+	}
+
 	/* iBT hardware variants 0x0b, 0x0c, 0x11, 0x12, 0x13, 0x14 support
 	 * only RSA secure boot engine. Hence, the corresponding sfi file will
 	 * have RSA header of 644 bytes followed by Command Buffer.
@@ -948,7 +1014,7 @@ int btintel_download_firmware_newgen(str
 		if (err)
 			return err;
 
-		err = btintel_download_firmware_payload(hdev, fw, boot_param, RSA_HEADER_LEN);
+		err = btintel_download_firmware_payload(hdev, fw, RSA_HEADER_LEN);
 		if (err)
 			return err;
 	} else if (hw_variant >= 0x17) {
@@ -969,7 +1035,6 @@ int btintel_download_firmware_newgen(str
 				return err;
 
 			err = btintel_download_firmware_payload(hdev, fw,
-								boot_param,
 								RSA_HEADER_LEN + ECDSA_HEADER_LEN);
 			if (err)
 				return err;
@@ -979,7 +1044,6 @@ int btintel_download_firmware_newgen(str
 				return err;
 
 			err = btintel_download_firmware_payload(hdev, fw,
-								boot_param,
 								RSA_HEADER_LEN + ECDSA_HEADER_LEN);
 			if (err)
 				return err;
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -157,9 +157,10 @@ struct regmap *btintel_regmap_init(struc
 int btintel_send_intel_reset(struct hci_dev *hdev, u32 boot_param);
 int btintel_read_boot_params(struct hci_dev *hdev,
 			     struct intel_boot_params *params);
-int btintel_download_firmware(struct hci_dev *dev, const struct firmware *fw,
-			      u32 *boot_param);
+int btintel_download_firmware(struct hci_dev *dev, struct intel_version *ver,
+			      const struct firmware *fw, u32 *boot_param);
 int btintel_download_firmware_newgen(struct hci_dev *hdev,
+				     struct intel_version_tlv *ver,
 				     const struct firmware *fw,
 				     u32 *boot_param, u8 hw_variant,
 				     u8 sbe_type);
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2602,8 +2602,15 @@ static int btusb_intel_download_firmware
 	set_bit(BTUSB_DOWNLOADING, &data->flags);
 
 	/* Start firmware downloading and get boot parameter */
-	err = btintel_download_firmware(hdev, fw, boot_param);
+	err = btintel_download_firmware(hdev, ver, fw, boot_param);
 	if (err < 0) {
+		if (err == -EALREADY) {
+			/* Firmware has already been loaded */
+			set_bit(BTUSB_FIRMWARE_LOADED, &data->flags);
+			err = 0;
+			goto done;
+		}
+
 		/* When FW download fails, send Intel Reset to retry
 		 * FW download.
 		 */
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -735,7 +735,7 @@ static int intel_setup(struct hci_uart *
 	set_bit(STATE_DOWNLOADING, &intel->flags);
 
 	/* Start firmware downloading and get boot parameter */
-	err = btintel_download_firmware(hdev, fw, &boot_param);
+	err = btintel_download_firmware(hdev, &ver, fw, &boot_param);
 	if (err < 0)
 		goto done;
 
@@ -784,7 +784,10 @@ static int intel_setup(struct hci_uart *
 done:
 	release_firmware(fw);
 
-	if (err < 0)
+	/* Check if there was an error and if is not -EALREADY which means the
+	 * firmware has already been loaded.
+	 */
+	if (err < 0 && err != -EALREADY)
 		return err;
 
 	/* We need to restore the default speed before Intel reset */


