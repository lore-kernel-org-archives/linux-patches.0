Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB0511193;
	Mon,  4 Mar 2024 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588675; cv=none; b=Uw5KYytmWvRpTsQOyRF6PNi/bxUlBrv0Q4d26HP+q/rlNUnIBANtiy0KPUF3QNgZnil8vpWILeX7clly1Pr2i03sja8OaU+L3TGOKw0syDy037hMfnP5saaTkUhvm6ocamGml1ZAdD/gVcfAKLOIwRY742yRpiUHoMDVMQPRMuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588675; c=relaxed/simple;
	bh=Qp3YTnZHeuBI73ILo9qpY+AzlIj/v9nDzakzl4Cx3u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igeWHt9MvW0g3aDrmobHolYTPSbxhR4b66a7YmX9/FsCAq8uLvYTh5BKfxy9rPn4JYRDVtHc6M307DmvbsPYbg3/tTHctlL+Q6eoQ5xVNARy3ok+dZRbk4uX+f44/haGNKPL+02mQ4K5BfGLae+kgXQpvj+IrsCrjAHh7QEiHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yt7hutPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yt7hutPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76EAC433F1;
	Mon,  4 Mar 2024 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588675;
	bh=Qp3YTnZHeuBI73ILo9qpY+AzlIj/v9nDzakzl4Cx3u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yt7hutPmjAh0+3Rb4DRBKPDvzx/HKU4duCCrGRmPPxdLG/MIlusUyZXzGPAu6k/Vm
	 XT+lTEQyaaOZHBu5WSCRIK3IQ4xjlmDEov7H9R6pjYLVpAOzH/1QIM/RdIR5WrCIfX
	 zKlRbEnSeyZMNM22p0w0PvVjJOWXsWGlqVFBLjRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/215] Bluetooth: qca: add support for WCN7850
Date: Mon,  4 Mar 2024 21:21:57 +0000
Message-ID: <20240304211558.699571531@linuxfoundation.org>
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

[ Upstream commit e0c1278ac89b0390fe9a74f673b6f25172292db2 ]

Add support for the WCN7850 Bluetooth chipset.

Tested on the SM8550 QRD platform.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c   | 10 ++++++++++
 drivers/bluetooth/btqca.h   |  1 +
 drivers/bluetooth/hci_qca.c | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 8331090af86ea..0211f704a358b 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -631,6 +631,10 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/hpbtfw%02x.tlv", rom_ver);
 		break;
+	case QCA_WCN7850:
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hmtbtfw%02x.tlv", rom_ver);
+		break;
 	default:
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
@@ -679,6 +683,10 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/hpnv%02x.bin", rom_ver);
 			break;
+		case QCA_WCN7850:
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/hmtnv%02x.bin", rom_ver);
+			break;
 
 		default:
 			snprintf(config.fwname, sizeof(config.fwname),
@@ -697,6 +705,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	case QCA_QCA6390:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		err = qca_disable_soc_logging(hdev);
 		if (err < 0)
 			return err;
@@ -731,6 +740,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	case QCA_WCN3991:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index fe51c632d7720..03bff5c0059de 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -149,6 +149,7 @@ enum qca_btsoc_type {
 	QCA_QCA6390,
 	QCA_WCN6750,
 	QCA_WCN6855,
+	QCA_WCN7850,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index e6ead996948a8..43abdaf92a0ed 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1330,6 +1330,7 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		usleep_range(1000, 10000);
 		break;
 
@@ -1415,6 +1416,7 @@ static int qca_check_speeds(struct hci_uart *hu)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1456,6 +1458,7 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		case QCA_WCN3998:
 		case QCA_WCN6750:
 		case QCA_WCN6855:
+		case QCA_WCN7850:
 			hci_uart_set_flow_control(hu, true);
 			break;
 
@@ -1489,6 +1492,7 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		case QCA_WCN3998:
 		case QCA_WCN6750:
 		case QCA_WCN6855:
+		case QCA_WCN7850:
 			hci_uart_set_flow_control(hu, false);
 			break;
 
@@ -1756,6 +1760,7 @@ static int qca_power_on(struct hci_dev *hdev)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		ret = qca_regulator_init(hu);
 		break;
 
@@ -1813,6 +1818,10 @@ static int qca_setup(struct hci_uart *hu)
 		soc_name = "wcn6855";
 		break;
 
+	case QCA_WCN7850:
+		soc_name = "wcn7850";
+		break;
+
 	default:
 		soc_name = "ROME/QCA6390";
 	}
@@ -1834,6 +1843,7 @@ static int qca_setup(struct hci_uart *hu)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
@@ -1863,6 +1873,7 @@ static int qca_setup(struct hci_uart *hu)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		break;
 
 	default:
@@ -2016,6 +2027,20 @@ static const struct qca_device_data qca_soc_data_wcn6855 = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
+static const struct qca_device_data qca_soc_data_wcn7850 __maybe_unused = {
+	.soc_type = QCA_WCN7850,
+	.vregs = (struct qca_vreg []) {
+		{ "vddio", 5000 },
+		{ "vddaon", 26000 },
+		{ "vdddig", 126000 },
+		{ "vddrfa0p8", 102000 },
+		{ "vddrfa1p2", 257000 },
+		{ "vddrfa1p9", 302000 },
+	},
+	.num_vregs = 6,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
+};
+
 static void qca_power_shutdown(struct hci_uart *hu)
 {
 	struct qca_serdev *qcadev;
@@ -2199,6 +2224,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
 						GFP_KERNEL);
@@ -2228,7 +2254,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 					       GPIOD_IN);
 		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) &&
 		    (data->soc_type == QCA_WCN6750 ||
-		     data->soc_type == QCA_WCN6855))
+		     data->soc_type == QCA_WCN6855 ||
+		     data->soc_type == QCA_WCN7850))
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2307,6 +2334,7 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	case QCA_WCN3998:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
+	case QCA_WCN7850:
 		if (power->vregs_on) {
 			qca_power_shutdown(&qcadev->serdev_hu);
 			break;
@@ -2499,6 +2527,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
 	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
+	{ .compatible = "qcom,wcn7850-bt", .data = &qca_soc_data_wcn7850},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
-- 
2.43.0



