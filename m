Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E05A10A35;
	Mon,  4 Mar 2024 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588670; cv=none; b=VUBmbpA7k+jmLAmppwCu9/NsnLuqswi1XQ5Z1rwdM9ncJ16xU1pm4pLuvcHGURvLCpV4qILH79w2pK4YyLQH2x0Y+3Dtsapfph5L3CDeex2yCuNp8ynPwORWV0KRZ48SpqS/ob1XP8RbQuUfNrt8DF5WRTP4c5pf1zNQXS/GBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588670; c=relaxed/simple;
	bh=DSVHSCQumpSHeOVT2UN5ymIRHSsF/xJi/wT29h73YOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNPhihy1j+CuGPf1MlYDRy6Sl9l/L/7fzyNsLUtAAZx5kRCeAs/6+GQkjmzqrnWoY151Q6Sb5ZSuh9HzA5s9mkyS6vUmZXPPmmi75IX7S7uIbgwUO72d7VdfyRNuFzKWjQZp1kqyoJzl9esE+CfznSUeSb5LTN70kgCJZT7zQ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5mYIaEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5mYIaEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA2EC433F1;
	Mon,  4 Mar 2024 21:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588669;
	bh=DSVHSCQumpSHeOVT2UN5ymIRHSsF/xJi/wT29h73YOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5mYIaEvUzmRkvecRPJ+eNtQGiy3x/gRP/FDbMODKXMqsnj8o+9Em8qmwj0cpL78n
	 m+B4OIn9fJVQXTd1Z1EV226uw64CyARZuxqrUomrw6c7sA/PUdSH3UbnSrjMt9LOtN
	 64lCWUW7s6tYWrUonLGO1xqDVRbR8HfMc0SrOyYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/215] Bluetooth: btqca: Add WCN3988 support
Date: Mon,  4 Mar 2024 21:21:55 +0000
Message-ID: <20240304211558.638037271@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f904feefe60c28b6852d5625adc4a2c39426a2d9 ]

Add support for the Bluetooth chip codenamed APACHE which is part of
WCN3988.

The firmware for this chip has a slightly different naming scheme
compared to most others. For ROM Version 0x0200 we need to use
apbtfw10.tlv + apnv10.bin and for ROM version 0x201 apbtfw11.tlv +
apnv11.bin

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c   | 13 +++++++++++--
 drivers/bluetooth/btqca.h   | 12 ++++++++++--
 drivers/bluetooth/hci_qca.c | 12 ++++++++++++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index d40a6041c48cd..d775402b33df3 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -594,14 +594,20 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	/* Firmware files to download are based on ROM version.
 	 * ROM version is derived from last two bytes of soc_ver.
 	 */
-	rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
+	if (soc_type == QCA_WCN3988)
+		rom_ver = ((soc_ver & 0x00000f00) >> 0x05) | (soc_ver & 0x0000000f);
+	else
+		rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
 
 	if (soc_type == QCA_WCN6750)
 		qca_send_patch_config_cmd(hdev);
 
 	/* Download rampatch file */
 	config.type = TLV_TYPE_PATCH;
-	if (qca_is_wcn399x(soc_type)) {
+	if (soc_type == QCA_WCN3988) {
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/apbtfw%02x.tlv", rom_ver);
+	} else if (qca_is_wcn399x(soc_type)) {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/crbtfw%02x.tlv", rom_ver);
 	} else if (soc_type == QCA_QCA6390) {
@@ -636,6 +642,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	if (firmware_name)
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/%s", firmware_name);
+	else if (soc_type == QCA_WCN3988)
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/apnv%02x.bin", rom_ver);
 	else if (qca_is_wcn399x(soc_type)) {
 		if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
 			snprintf(config.fwname, sizeof(config.fwname),
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index b884095bcd9d0..fc6cf314eb0ef 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -142,6 +142,7 @@ enum qca_btsoc_type {
 	QCA_INVALID = -1,
 	QCA_AR3002,
 	QCA_ROME,
+	QCA_WCN3988,
 	QCA_WCN3990,
 	QCA_WCN3998,
 	QCA_WCN3991,
@@ -162,8 +163,15 @@ int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr);
 int qca_send_pre_shutdown_cmd(struct hci_dev *hdev);
 static inline bool qca_is_wcn399x(enum qca_btsoc_type soc_type)
 {
-	return soc_type == QCA_WCN3990 || soc_type == QCA_WCN3991 ||
-	       soc_type == QCA_WCN3998;
+	switch (soc_type) {
+	case QCA_WCN3988:
+	case QCA_WCN3990:
+	case QCA_WCN3991:
+	case QCA_WCN3998:
+		return true;
+	default:
+		return false;
+	}
 }
 static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 {
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f217c2821b9fb..746eb096c037c 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1832,6 +1832,17 @@ static const struct hci_uart_proto qca_proto = {
 	.dequeue	= qca_dequeue,
 };
 
+static const struct qca_device_data qca_soc_data_wcn3988 __maybe_unused = {
+	.soc_type = QCA_WCN3988,
+	.vregs = (struct qca_vreg []) {
+		{ "vddio", 15000  },
+		{ "vddxo", 80000  },
+		{ "vddrf", 300000 },
+		{ "vddch0", 450000 },
+	},
+	.num_vregs = 4,
+};
+
 static const struct qca_device_data qca_soc_data_wcn3990 __maybe_unused = {
 	.soc_type = QCA_WCN3990,
 	.vregs = (struct qca_vreg []) {
@@ -2357,6 +2368,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,qca6174-bt" },
 	{ .compatible = "qcom,qca6390-bt", .data = &qca_soc_data_qca6390},
 	{ .compatible = "qcom,qca9377-bt" },
+	{ .compatible = "qcom,wcn3988-bt", .data = &qca_soc_data_wcn3988},
 	{ .compatible = "qcom,wcn3990-bt", .data = &qca_soc_data_wcn3990},
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
-- 
2.43.0



