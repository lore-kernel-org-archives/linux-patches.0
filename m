Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9304544C94;
	Mon, 24 Feb 2025 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407892; cv=none; b=bSe0ze/libV5K2lULF216gc3h5/13jjpoTpOoE+MPQKYRRITC38rCi7i13MQhh6jjyy/NWhbpUKZN/khGLWwhWtebbTBdw1m/4uT8D2wk7XeTNjrBfPDbFhPXehoId8pwK0/q0FgwfB5VlFnXp75Z5VnBFdBou7Ocg6UI+uH3GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407892; c=relaxed/simple;
	bh=AqPWFvrR9jC2qHrW/mBIJo4F0Y11iB1idYtlIyOEuyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0zYF9EyDAKTDOBbQhWeUZz8ubPicxEueg62Ehh3NXYIemKJgtBDO00ZMyh2hqNwbbI2rgu9d5vRoLVxO3XKyWxmlRuG6tTjs42JEoxT49SOo/tMW4Bs67pEjz71LFzd3vxWTcxyRrec6NmJLWwTjPxBWJYtLgnS6InmkYjAUDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIgzBpnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIgzBpnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F99C4CED6;
	Mon, 24 Feb 2025 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407892;
	bh=AqPWFvrR9jC2qHrW/mBIJo4F0Y11iB1idYtlIyOEuyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIgzBpnVU18PwLzLX9QnDgEjRQkJA/yo7vER07mrW4uFDz75xnDR8YxyAkgqN29r2
	 TrAGEhFuOtm08DND+zTzglhYyM1wzD+jtbVFHuBjG/OrUoqlKYl6GAvJw8ny3wf0Xf
	 XSDkdnOzegXl3PeQd7JinSDMZhW/9v0h1eJErPuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Jiang <quic_chejiang@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/140] Bluetooth: qca: Update firmware-name to support board specific nvm
Date: Mon, 24 Feb 2025 15:33:59 +0100
Message-ID: <20250224142604.584069230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cheng Jiang <quic_chejiang@quicinc.com>

[ Upstream commit a4c5a468c6329bde7dfd46bacff2cbf5f8a8152e ]

Different connectivity boards may be attached to the same platform. For
example, QCA6698-based boards can support either a two-antenna or
three-antenna solution, both of which work on the sa8775p-ride platform.
Due to differences in connectivity boards and variations in RF
performance from different foundries, different NVM configurations are
used based on the board ID.

Therefore, in the firmware-name property, if the NVM file has an
extension, the NVM file will be used. Otherwise, the system will first
try the .bNN (board ID) file, and if that fails, it will fall back to
the .bin file.

Possible configurations:
firmware-name = "QCA6698/hpnv21";
firmware-name = "QCA6698/hpnv21.bin";

Signed-off-by: Cheng Jiang <quic_chejiang@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a2fad248947d ("Bluetooth: qca: Fix poor RF performance for WCN6855")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 113 ++++++++++++++++++++++++++++----------
 1 file changed, 85 insertions(+), 28 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 513ff87a7a049..484a860785fde 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -289,6 +289,39 @@ int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 }
 EXPORT_SYMBOL_GPL(qca_send_pre_shutdown_cmd);
 
+static bool qca_filename_has_extension(const char *filename)
+{
+	const char *suffix = strrchr(filename, '.');
+
+	/* File extensions require a dot, but not as the first or last character */
+	if (!suffix || suffix == filename || *(suffix + 1) == '\0')
+		return 0;
+
+	/* Avoid matching directories with names that look like files with extensions */
+	return !strchr(suffix, '/');
+}
+
+static bool qca_get_alt_nvm_file(char *filename, size_t max_size)
+{
+	char fwname[64];
+	const char *suffix;
+
+	/* nvm file name has an extension, replace with .bin */
+	if (qca_filename_has_extension(filename)) {
+		suffix = strrchr(filename, '.');
+		strscpy(fwname, filename, suffix - filename + 1);
+		snprintf(fwname + (suffix - filename),
+		       sizeof(fwname) - (suffix - filename), ".bin");
+		/* If nvm file is already the default one, return false to skip the retry. */
+		if (strcmp(fwname, filename) == 0)
+			return false;
+
+		snprintf(filename, max_size, "%s", fwname);
+		return true;
+	}
+	return false;
+}
+
 static int qca_tlv_check_data(struct hci_dev *hdev,
 			       struct qca_fw_config *config,
 			       u8 *fw_data, size_t fw_size,
@@ -586,6 +619,19 @@ static int qca_download_firmware(struct hci_dev *hdev,
 					   config->fwname, ret);
 				return ret;
 			}
+		}
+		/* If the board-specific file is missing, try loading the default
+		 * one, unless that was attempted already.
+		 */
+		else if (config->type == TLV_TYPE_NVM &&
+			 qca_get_alt_nvm_file(config->fwname, sizeof(config->fwname))) {
+			bt_dev_info(hdev, "QCA Downloading %s", config->fwname);
+			ret = request_firmware(&fw, config->fwname, &hdev->dev);
+			if (ret) {
+				bt_dev_err(hdev, "QCA Failed to request file: %s (%d)",
+					   config->fwname, ret);
+				return ret;
+			}
 		} else {
 			bt_dev_err(hdev, "QCA Failed to request file: %s (%d)",
 				   config->fwname, ret);
@@ -722,34 +768,38 @@ static int qca_check_bdaddr(struct hci_dev *hdev, const struct qca_fw_config *co
 	return 0;
 }
 
-static void qca_generate_hsp_nvm_name(char *fwname, size_t max_size,
+static void qca_get_nvm_name_by_board(char *fwname, size_t max_size,
+		const char *stem, enum qca_btsoc_type soc_type,
 		struct qca_btsoc_version ver, u8 rom_ver, u16 bid)
 {
 	const char *variant;
+	const char *prefix;
 
-	/* hsp gf chip */
-	if ((le32_to_cpu(ver.soc_id) & QCA_HSP_GF_SOC_MASK) == QCA_HSP_GF_SOC_ID)
-		variant = "g";
-	else
-		variant = "";
+	/* Set the default value to variant and prefix */
+	variant = "";
+	prefix = "b";
 
-	if (bid == 0x0)
-		snprintf(fwname, max_size, "qca/hpnv%02x%s.bin", rom_ver, variant);
-	else
-		snprintf(fwname, max_size, "qca/hpnv%02x%s.%x", rom_ver, variant, bid);
-}
+	if (soc_type == QCA_QCA2066)
+		prefix = "";
 
-static inline void qca_get_nvm_name_generic(struct qca_fw_config *cfg,
-					    const char *stem, u8 rom_ver, u16 bid)
-{
-	if (bid == 0x0)
-		snprintf(cfg->fwname, sizeof(cfg->fwname), "qca/%snv%02x.bin", stem, rom_ver);
-	else if (bid & 0xff00)
-		snprintf(cfg->fwname, sizeof(cfg->fwname),
-			 "qca/%snv%02x.b%x", stem, rom_ver, bid);
-	else
-		snprintf(cfg->fwname, sizeof(cfg->fwname),
-			 "qca/%snv%02x.b%02x", stem, rom_ver, bid);
+	if (soc_type == QCA_WCN6855 || soc_type == QCA_QCA2066) {
+		/* If the chip is manufactured by GlobalFoundries */
+		if ((le32_to_cpu(ver.soc_id) & QCA_HSP_GF_SOC_MASK) == QCA_HSP_GF_SOC_ID)
+			variant = "g";
+	}
+
+	if (rom_ver != 0) {
+		if (bid == 0x0 || bid == 0xffff)
+			snprintf(fwname, max_size, "qca/%s%02x%s.bin", stem, rom_ver, variant);
+		else
+			snprintf(fwname, max_size, "qca/%s%02x%s.%s%02x", stem, rom_ver,
+						variant, prefix, bid);
+	} else {
+		if (bid == 0x0 || bid == 0xffff)
+			snprintf(fwname, max_size, "qca/%s%s.bin", stem, variant);
+		else
+			snprintf(fwname, max_size, "qca/%s%s.%s%02x", stem, variant, prefix, bid);
+	}
 }
 
 int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
@@ -838,8 +888,14 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	/* Download NVM configuration */
 	config.type = TLV_TYPE_NVM;
 	if (firmware_name) {
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/%s", firmware_name);
+		/* The firmware name has an extension, use it directly */
+		if (qca_filename_has_extension(firmware_name)) {
+			snprintf(config.fwname, sizeof(config.fwname), "qca/%s", firmware_name);
+		} else {
+			qca_read_fw_board_id(hdev, &boardid);
+			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
+				 firmware_name, soc_type, ver, 0, boardid);
+		}
 	} else {
 		switch (soc_type) {
 		case QCA_WCN3990:
@@ -858,8 +914,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 				 "qca/apnv%02x.bin", rom_ver);
 			break;
 		case QCA_QCA2066:
-			qca_generate_hsp_nvm_name(config.fwname,
-				sizeof(config.fwname), ver, rom_ver, boardid);
+			qca_get_nvm_name_by_board(config.fwname,
+				sizeof(config.fwname), "hpnv", soc_type, ver,
+				rom_ver, boardid);
 			break;
 		case QCA_QCA6390:
 			snprintf(config.fwname, sizeof(config.fwname),
@@ -874,9 +931,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 				 "qca/hpnv%02x.bin", rom_ver);
 			break;
 		case QCA_WCN7850:
-			qca_get_nvm_name_generic(&config, "hmt", rom_ver, boardid);
+			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
+				 "hmtnv", soc_type, ver, rom_ver, boardid);
 			break;
-
 		default:
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/nvm_%08x.bin", soc_ver);
-- 
2.39.5



