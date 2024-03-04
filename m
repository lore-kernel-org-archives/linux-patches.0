Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A468F7B3D8;
	Mon,  4 Mar 2024 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588672; cv=none; b=cy8uibLpX0ni6PN7yqXv/YZDPNO41R0p+sdTyIZ54b8KjuS/6cfxC4sIh3QQxtU9SJqjKC756HGOGIn+0RmIwUhccw8qpbBRCC4N1c7XIZp/MDMxWX8k+xGOkeKDtVxGnPxJqO2YZcr8qTYg9asi9sVidUXWop4wixj7gUgecrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588672; c=relaxed/simple;
	bh=8cEK7i2SGZq39EeX7OiZsmSmzDj/yDTDfirS3n+Zljw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVre/2tktbKxOPscpVovNiJeV4s4gBPGiVWipZ2arrMhOiTdBsGOtHGn8QoidQpZ44lPmdjM6hZfET+R8Juz8memLJoTw68fmjn8MlI0wYYJHPWv6dN/mw96wTkxj/yWx84YkUoU4rlXhWMXzgaT4F5zCmqkfdiUJTfssdrg6GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXv/TXCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXv/TXCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C113C433C7;
	Mon,  4 Mar 2024 21:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588672;
	bh=8cEK7i2SGZq39EeX7OiZsmSmzDj/yDTDfirS3n+Zljw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXv/TXCUTB+7hOR+16JzauU59TVD8k0VzdWlQuB2g5pym5H5Bqo8pPxps+DP0N3HK
	 bh9S5zm9gfF8CLfbp7a3lljnWOUt+IZs3lNsP1BZrfjfCyd0FSfHxKlq+GxkA71Sct
	 8bMtNXMwhk6D6b+7Cft6Y/WNwv4Ld3LV6YqQOz1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/215] Bluetooth: qca: use switch case for soc type behavior
Date: Mon,  4 Mar 2024 21:21:56 +0000
Message-ID: <20240304211558.670617552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 691d54d0f7cb14baac1ff4af210d13c0e4897e27 ]

Use switch/case to handle soc type specific behaviour,
the permit dropping the qca_is_xxx() inline functions
and make the code clearer and easier to update for new
SoCs.

Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c   |  87 +++++++++-----
 drivers/bluetooth/btqca.h   |  36 ------
 drivers/bluetooth/hci_qca.c | 233 +++++++++++++++++++++++++++---------
 3 files changed, 236 insertions(+), 120 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index d775402b33df3..8331090af86ea 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -604,26 +604,34 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 
 	/* Download rampatch file */
 	config.type = TLV_TYPE_PATCH;
-	if (soc_type == QCA_WCN3988) {
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/apbtfw%02x.tlv", rom_ver);
-	} else if (qca_is_wcn399x(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/crbtfw%02x.tlv", rom_ver);
-	} else if (soc_type == QCA_QCA6390) {
+		break;
+	case QCA_WCN3988:
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/apbtfw%02x.tlv", rom_ver);
+		break;
+	case QCA_QCA6390:
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/htbtfw%02x.tlv", rom_ver);
-	} else if (soc_type == QCA_WCN6750) {
+		break;
+	case QCA_WCN6750:
 		/* Choose mbn file by default.If mbn file is not found
 		 * then choose tlv file
 		 */
 		config.type = ELF_TYPE_PATCH;
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msbtfw%02x.mbn", rom_ver);
-	} else if (soc_type == QCA_WCN6855) {
+		break;
+	case QCA_WCN6855:
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/hpbtfw%02x.tlv", rom_ver);
-	} else {
+		break;
+	default:
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
 	}
@@ -639,33 +647,44 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 
 	/* Download NVM configuration */
 	config.type = TLV_TYPE_NVM;
-	if (firmware_name)
+	if (firmware_name) {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/%s", firmware_name);
-	else if (soc_type == QCA_WCN3988)
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/apnv%02x.bin", rom_ver);
-	else if (qca_is_wcn399x(soc_type)) {
-		if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
+	} else {
+		switch (soc_type) {
+		case QCA_WCN3990:
+		case QCA_WCN3991:
+		case QCA_WCN3998:
+			if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
+				snprintf(config.fwname, sizeof(config.fwname),
+					 "qca/crnv%02xu.bin", rom_ver);
+			} else {
+				snprintf(config.fwname, sizeof(config.fwname),
+					 "qca/crnv%02x.bin", rom_ver);
+			}
+			break;
+		case QCA_WCN3988:
 			snprintf(config.fwname, sizeof(config.fwname),
-				 "qca/crnv%02xu.bin", rom_ver);
-		} else {
+				 "qca/apnv%02x.bin", rom_ver);
+			break;
+		case QCA_QCA6390:
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/htnv%02x.bin", rom_ver);
+			break;
+		case QCA_WCN6750:
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/msnv%02x.bin", rom_ver);
+			break;
+		case QCA_WCN6855:
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/hpnv%02x.bin", rom_ver);
+			break;
+
+		default:
 			snprintf(config.fwname, sizeof(config.fwname),
-				 "qca/crnv%02x.bin", rom_ver);
+				 "qca/nvm_%08x.bin", soc_ver);
 		}
 	}
-	else if (soc_type == QCA_QCA6390)
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/htnv%02x.bin", rom_ver);
-	else if (soc_type == QCA_WCN6750)
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/msnv%02x.bin", rom_ver);
-	else if (soc_type == QCA_WCN6855)
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/hpnv%02x.bin", rom_ver);
-	else
-		snprintf(config.fwname, sizeof(config.fwname),
-			 "qca/nvm_%08x.bin", soc_ver);
 
 	err = qca_download_firmware(hdev, &config, soc_type, rom_ver);
 	if (err < 0) {
@@ -673,16 +692,24 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
-	if (soc_type >= QCA_WCN3991) {
+	switch (soc_type) {
+	case QCA_WCN3991:
+	case QCA_QCA6390:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		err = qca_disable_soc_logging(hdev);
 		if (err < 0)
 			return err;
+		break;
+	default:
+		break;
 	}
 
 	/* WCN399x and WCN6750 supports the Microsoft vendor extension with 0xFD70 as the
 	 * VsMsftOpCode.
 	 */
 	switch (soc_type) {
+	case QCA_WCN3988:
 	case QCA_WCN3990:
 	case QCA_WCN3991:
 	case QCA_WCN3998:
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index fc6cf314eb0ef..fe51c632d7720 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -161,27 +161,6 @@ int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type);
 int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr);
 int qca_send_pre_shutdown_cmd(struct hci_dev *hdev);
-static inline bool qca_is_wcn399x(enum qca_btsoc_type soc_type)
-{
-	switch (soc_type) {
-	case QCA_WCN3988:
-	case QCA_WCN3990:
-	case QCA_WCN3991:
-	case QCA_WCN3998:
-		return true;
-	default:
-		return false;
-	}
-}
-static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
-{
-	return soc_type == QCA_WCN6750;
-}
-static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
-{
-	return soc_type == QCA_WCN6855;
-}
-
 #else
 
 static inline int qca_set_bdaddr_rome(struct hci_dev *hdev, const bdaddr_t *bdaddr)
@@ -209,21 +188,6 @@ static inline int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
 	return -EOPNOTSUPP;
 }
 
-static inline bool qca_is_wcn399x(enum qca_btsoc_type soc_type)
-{
-	return false;
-}
-
-static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
-{
-	return false;
-}
-
-static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
-{
-	return false;
-}
-
 static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 746eb096c037c..e6ead996948a8 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -606,9 +606,18 @@ static int qca_open(struct hci_uart *hu)
 	if (hu->serdev) {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 
-		if (qca_is_wcn399x(qcadev->btsoc_type) ||
-		    qca_is_wcn6750(qcadev->btsoc_type))
+		switch (qcadev->btsoc_type) {
+		case QCA_WCN3988:
+		case QCA_WCN3990:
+		case QCA_WCN3991:
+		case QCA_WCN3998:
+		case QCA_WCN6750:
 			hu->init_speed = qcadev->init_speed;
+			break;
+
+		default:
+			break;
+		}
 
 		if (qcadev->oper_speed)
 			hu->oper_speed = qcadev->oper_speed;
@@ -1314,12 +1323,19 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 		      msecs_to_jiffies(CMD_TRANS_TIMEOUT_MS));
 
 	/* Give the controller time to process the request */
-	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)) ||
-	    qca_is_wcn6855(qca_soc_type(hu)))
+	switch (qca_soc_type(hu)) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		usleep_range(1000, 10000);
-	else
+		break;
+
+	default:
 		msleep(300);
+	}
 
 	return 0;
 }
@@ -1392,13 +1408,19 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
 
 static int qca_check_speeds(struct hci_uart *hu)
 {
-	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)) ||
-	    qca_is_wcn6855(qca_soc_type(hu))) {
+	switch (qca_soc_type(hu)) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
-	} else {
+		break;
+
+	default:
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) ||
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1427,14 +1449,28 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		/* Disable flow control for wcn3990 to deassert RTS while
 		 * changing the baudrate of chip and host.
 		 */
-		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type) ||
-		    qca_is_wcn6855(soc_type))
+		switch (soc_type) {
+		case QCA_WCN3988:
+		case QCA_WCN3990:
+		case QCA_WCN3991:
+		case QCA_WCN3998:
+		case QCA_WCN6750:
+		case QCA_WCN6855:
 			hci_uart_set_flow_control(hu, true);
+			break;
 
-		if (soc_type == QCA_WCN3990) {
+		default:
+			break;
+		}
+
+		switch (soc_type) {
+		case QCA_WCN3990:
 			reinit_completion(&qca->drop_ev_comp);
 			set_bit(QCA_DROP_VENDOR_EVENT, &qca->flags);
+			break;
+
+		default:
+			break;
 		}
 
 		qca_baudrate = qca_get_baudrate_value(speed);
@@ -1446,12 +1482,22 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		host_set_baudrate(hu, speed);
 
 error:
-		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type) ||
-		    qca_is_wcn6855(soc_type))
+		switch (soc_type) {
+		case QCA_WCN3988:
+		case QCA_WCN3990:
+		case QCA_WCN3991:
+		case QCA_WCN3998:
+		case QCA_WCN6750:
+		case QCA_WCN6855:
 			hci_uart_set_flow_control(hu, false);
+			break;
 
-		if (soc_type == QCA_WCN3990) {
+		default:
+			break;
+		}
+
+		switch (soc_type) {
+		case QCA_WCN3990:
 			/* Wait for the controller to send the vendor event
 			 * for the baudrate change command.
 			 */
@@ -1463,6 +1509,10 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 			}
 
 			clear_bit(QCA_DROP_VENDOR_EVENT, &qca->flags);
+			break;
+
+		default:
+			break;
 		}
 	}
 
@@ -1624,12 +1674,20 @@ static int qca_regulator_init(struct hci_uart *hu)
 		}
 	}
 
-	if (qca_is_wcn399x(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
 		/* Forcefully enable wcn399x to enter in to boot mode. */
 		host_set_baudrate(hu, 2400);
 		ret = qca_send_power_pulse(hu, false);
 		if (ret)
 			return ret;
+		break;
+
+	default:
+		break;
 	}
 
 	/* For wcn6750 need to enable gpio bt_en */
@@ -1646,10 +1704,18 @@ static int qca_regulator_init(struct hci_uart *hu)
 
 	qca_set_speed(hu, QCA_INIT_SPEED);
 
-	if (qca_is_wcn399x(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
 		ret = qca_send_power_pulse(hu, true);
 		if (ret)
 			return ret;
+		break;
+
+	default:
+		break;
 	}
 
 	/* Now the device is in ready state to communicate with host.
@@ -1683,11 +1749,17 @@ static int qca_power_on(struct hci_dev *hdev)
 	if (!hu->serdev)
 		return 0;
 
-	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type) ||
-	    qca_is_wcn6855(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		ret = qca_regulator_init(hu);
-	} else {
+		break;
+
+	default:
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->bt_en) {
 			gpiod_set_value_cansleep(qcadev->bt_en, 1);
@@ -1710,6 +1782,7 @@ static int qca_setup(struct hci_uart *hu)
 	const char *firmware_name = qca_get_firmware_name(hu);
 	int ret;
 	struct qca_btsoc_version ver;
+	const char *soc_name;
 
 	ret = qca_check_speeds(hu);
 	if (ret)
@@ -1724,10 +1797,26 @@ static int qca_setup(struct hci_uart *hu)
 	 */
 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 
-	bt_dev_info(hdev, "setting up %s",
-		qca_is_wcn399x(soc_type) ? "wcn399x" :
-		(soc_type == QCA_WCN6750) ? "wcn6750" :
-		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+		soc_name = "wcn399x";
+		break;
+
+	case QCA_WCN6750:
+		soc_name = "wcn6750";
+		break;
+
+	case QCA_WCN6855:
+		soc_name = "wcn6855";
+		break;
+
+	default:
+		soc_name = "ROME/QCA6390";
+	}
+	bt_dev_info(hdev, "setting up %s", soc_name);
 
 	qca->memdump_state = QCA_MEMDUMP_IDLE;
 
@@ -1738,16 +1827,22 @@ static int qca_setup(struct hci_uart *hu)
 
 	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
 
-	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type) ||
-	    qca_is_wcn6855(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
 			goto out;
-	} else {
+		break;
+
+	default:
 		qca_set_speed(hu, QCA_INIT_SPEED);
 	}
 
@@ -1761,9 +1856,16 @@ static int qca_setup(struct hci_uart *hu)
 		qca_baudrate = qca_get_baudrate_value(speed);
 	}
 
-	if (!(qca_is_wcn399x(soc_type) ||
-	      qca_is_wcn6750(soc_type) ||
-	      qca_is_wcn6855(soc_type))) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
+		break;
+
+	default:
 		/* Get QCA version information */
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
@@ -1939,11 +2041,18 @@ static void qca_power_shutdown(struct hci_uart *hu)
 
 	qcadev = serdev_device_get_drvdata(hu->serdev);
 
-	if (qca_is_wcn399x(soc_type)) {
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
 		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
+		break;
+
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 		msleep(100);
 		qca_regulator_disable(qcadev);
@@ -1951,7 +2060,9 @@ static void qca_power_shutdown(struct hci_uart *hu)
 			sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
 			bt_dev_dbg(hu->hdev, "SW_CTRL is %d", sw_ctrl_state);
 		}
-	} else if (qcadev->bt_en) {
+		break;
+
+	default:
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 	}
 
@@ -2076,11 +2187,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	if (!qcadev->oper_speed)
 		BT_DBG("UART will pick default operating speed");
 
-	if (data &&
-	    (qca_is_wcn399x(data->soc_type) ||
-	     qca_is_wcn6750(data->soc_type) ||
-	     qca_is_wcn6855(data->soc_type))) {
+	if (data)
 		qcadev->btsoc_type = data->soc_type;
+	else
+		qcadev->btsoc_type = QCA_ROME;
+
+	switch (qcadev->btsoc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
 						GFP_KERNEL);
@@ -2124,12 +2242,9 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 			BT_ERR("wcn3990 serdev registration failed");
 			return err;
 		}
-	} else {
-		if (data)
-			qcadev->btsoc_type = data->soc_type;
-		else
-			qcadev->btsoc_type = QCA_ROME;
+		break;
 
+	default:
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
 		if (IS_ERR_OR_NULL(qcadev->bt_en)) {
@@ -2185,13 +2300,23 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
 	struct qca_power *power = qcadev->bt_power;
 
-	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
-	     qca_is_wcn6750(qcadev->btsoc_type) ||
-	     qca_is_wcn6855(qcadev->btsoc_type)) &&
-	    power->vregs_on)
-		qca_power_shutdown(&qcadev->serdev_hu);
-	else if (qcadev->susclk)
-		clk_disable_unprepare(qcadev->susclk);
+	switch (qcadev->btsoc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
+		if (power->vregs_on) {
+			qca_power_shutdown(&qcadev->serdev_hu);
+			break;
+		}
+		fallthrough;
+
+	default:
+		if (qcadev->susclk)
+			clk_disable_unprepare(qcadev->susclk);
+	}
 
 	hci_uart_unregister_device(&qcadev->serdev_hu);
 }
-- 
2.43.0



