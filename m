Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B0511193;
	Mon,  4 Mar 2024 21:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588664; cv=none; b=alZ3l3gWvjY8jjt4RqfAq2wQeOn1OKDkK392dpNMwisUkOB8JGUjEypyBgC8johey+UuR+PPz4n8+o+atNluI+PTFK+K3bG5DWLqfoa7RdnRCb6yApsa8twiyv2NYLAqzxxhSIZnOKhOH8YQDYBXZYq0yxMiRHv+MD3a2ymV+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588664; c=relaxed/simple;
	bh=4TfgzBlxGrsBo0ihFByzmiLoWB/2qUJLeVLVLssLQoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U955CQ4tgYI3EDae0PqU5VJuCw0iM6CtwCPC2iHgqQMHbkOke1j1Cap7PIyjmg3wThGSH/gFM+CB0P3JheZcQJMZd1QoDbtlKFFr5yIX1oAqY3h6xHKuftpMfTpZT9lie6VD0Usty//9K5HMcLhe05rf6p+PaZEgMpUfMDp9S/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwQLBibH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwQLBibH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A3C433C7;
	Mon,  4 Mar 2024 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588664;
	bh=4TfgzBlxGrsBo0ihFByzmiLoWB/2qUJLeVLVLssLQoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwQLBibHoLfh1ykgucs4bFPxOQ7jB4GLpRzg+3paOgkLmA1D4EVvddGmRS79EdLYD
	 wQSC0Oy0GxEHW4rM8vFeX3q5yvKBWYOxmwAWWOCmkyaaKYFM9iimjBJ+QMosjYV/IP
	 8WplxWWblccum+SQOLjLbf9enIcFMU2PwGIbTS9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/215] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
Date: Mon,  4 Mar 2024 21:21:53 +0000
Message-ID: <20240304211558.580834913@linuxfoundation.org>
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

From: Steev Klimaszewski <steev@kali.org>

[ Upstream commit 095327fede005f4b14d40b2183b2f7965c739dbd ]

Add regulators, GPIOs and changes required to power on/off wcn6855.
Add support for firmware download for wcn6855 which is in the
linux-firmware repository as hpbtfw21.tlv and hpnv21.bin.

Based on the assumption that this is similar to the wcn6750

Tested-on: BTFW.HSP.2.1.0-00538-VER_PATCHZ-1

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c   | 14 ++++++++-
 drivers/bluetooth/btqca.h   | 10 +++++++
 drivers/bluetooth/hci_qca.c | 57 ++++++++++++++++++++++++++++---------
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index d7d0c9de3dc31..4cb541096b934 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -614,6 +614,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		config.type = ELF_TYPE_PATCH;
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msbtfw%02x.mbn", rom_ver);
+	} else if (soc_type == QCA_WCN6855) {
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpbtfw%02x.tlv", rom_ver);
 	} else {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
@@ -648,6 +651,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	else if (soc_type == QCA_WCN6750)
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msnv%02x.bin", rom_ver);
+	else if (soc_type == QCA_WCN6855)
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpnv%02x.bin", rom_ver);
 	else
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/nvm_%08x.bin", soc_ver);
@@ -685,11 +691,17 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
-	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
+	switch (soc_type) {
+	case QCA_WCN3991:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
 			return err;
+		break;
+	default:
+		break;
 	}
 
 	bt_dev_info(hdev, "QCA setup on UART is completed");
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index 61e9a50e66ae1..b884095bcd9d0 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -147,6 +147,7 @@ enum qca_btsoc_type {
 	QCA_WCN3991,
 	QCA_QCA6390,
 	QCA_WCN6750,
+	QCA_WCN6855,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)
@@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 {
 	return soc_type == QCA_WCN6750;
 }
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return soc_type == QCA_WCN6855;
+}
 
 #else
 
@@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 	return false;
 }
 
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return false;
+}
+
 static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 0e908a337e534..f217c2821b9fb 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1315,7 +1315,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 
 	/* Give the controller time to process the request */
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)))
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu)))
 		usleep_range(1000, 10000);
 	else
 		msleep(300);
@@ -1392,7 +1393,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
 static int qca_check_speeds(struct hci_uart *hu)
 {
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu))) {
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu))) {
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1426,7 +1428,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		 * changing the baudrate of chip and host.
 		 */
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, true);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1444,7 +1447,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 
 error:
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, false);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1680,7 +1684,8 @@ static int qca_power_on(struct hci_dev *hdev)
 		return 0;
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		ret = qca_regulator_init(hu);
 	} else {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
@@ -1721,7 +1726,8 @@ static int qca_setup(struct hci_uart *hu)
 
 	bt_dev_info(hdev, "setting up %s",
 		qca_is_wcn399x(soc_type) ? "wcn399x" :
-		(soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
+		(soc_type == QCA_WCN6750) ? "wcn6750" :
+		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
 
 	qca->memdump_state = QCA_MEMDUMP_IDLE;
 
@@ -1733,7 +1739,8 @@ static int qca_setup(struct hci_uart *hu)
 	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
@@ -1755,7 +1762,8 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 	if (!(qca_is_wcn399x(soc_type) ||
-	     qca_is_wcn6750(soc_type))) {
+	      qca_is_wcn6750(soc_type) ||
+	      qca_is_wcn6855(soc_type))) {
 		/* Get QCA version information */
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
@@ -1881,6 +1889,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 __maybe_unused = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
+static const struct qca_device_data qca_soc_data_wcn6855 = {
+	.soc_type = QCA_WCN6855,
+	.vregs = (struct qca_vreg []) {
+		{ "vddio", 5000 },
+		{ "vddbtcxmx", 126000 },
+		{ "vddrfacmn", 12500 },
+		{ "vddrfa0p8", 102000 },
+		{ "vddrfa1p7", 302000 },
+		{ "vddrfa1p2", 257000 },
+	},
+	.num_vregs = 6,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
+};
+
 static void qca_power_shutdown(struct hci_uart *hu)
 {
 	struct qca_serdev *qcadev;
@@ -1910,7 +1932,7 @@ static void qca_power_shutdown(struct hci_uart *hu)
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
 		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750) {
+	} else if (soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 		msleep(100);
 		qca_regulator_disable(qcadev);
@@ -2045,7 +2067,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 	if (data &&
 	    (qca_is_wcn399x(data->soc_type) ||
-	    qca_is_wcn6750(data->soc_type))) {
+	     qca_is_wcn6750(data->soc_type) ||
+	     qca_is_wcn6855(data->soc_type))) {
 		qcadev->btsoc_type = data->soc_type;
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
@@ -2065,14 +2088,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855)) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
 			power_ctrl_enabled = false;
 		}
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
-		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
+		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855))
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2148,8 +2175,9 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	struct qca_power *power = qcadev->bt_power;
 
 	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
-	     qca_is_wcn6750(qcadev->btsoc_type)) &&
-	     power->vregs_on)
+	     qca_is_wcn6750(qcadev->btsoc_type) ||
+	     qca_is_wcn6855(qcadev->btsoc_type)) &&
+	    power->vregs_on)
 		qca_power_shutdown(&qcadev->serdev_hu);
 	else if (qcadev->susclk)
 		clk_disable_unprepare(qcadev->susclk);
@@ -2333,6 +2361,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
+	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
-- 
2.43.0



