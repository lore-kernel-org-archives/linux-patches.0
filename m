Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399AC7263D;
	Tue, 22 Jul 2025 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192137; cv=none; b=NvPGx3Jwkqox9tksH1/KkIhGG/TZoMO4tlebwIOsmRJglVIAfkMk50SlLRzRNCJ1hBekV/zse2kqDALshSRfqZmkn+gnyFFjM4oDsM2NRdOHzwHpJPsyixQ+cb4a0NE2LcTmaKRO0bDzZnVLm95RpelrNyp/eL/vs0cZkHJMbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192137; c=relaxed/simple;
	bh=U1EhOJa+7ww1H5sTxO/26/XYFTMKwoOVrrBoVG5BFWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKz4mWq4XHl485VHI95Lj55Vhe/tqfow2EQs/+pXU4bsic7IAOhmORL+wIcp04S7WA43U4Ha9kEm3+E7IAxqWAQuCCZvI8dZ0R9TtX8goYm06rqAcxwYou8FB1nYHFm8T3i9V0ACd2SElv4+1Vq+JtGghlFkQe7URXdl4YNNu1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Crbs/7HG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Crbs/7HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E29C4CEEB;
	Tue, 22 Jul 2025 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192137;
	bh=U1EhOJa+7ww1H5sTxO/26/XYFTMKwoOVrrBoVG5BFWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Crbs/7HGm0e3pKqEPHvaxNozGyOeIqFd59BQmma/bb6z31NSXmu9I9JJWztu37H1w
	 yvqUzIyQv+2oXitC6Y1W7wzVLKUEcqs8nqMl4kZC4a9C8IPgUQUvjaK56WR1VB8w+h
	 RgF663yLGlQnRMpq664wrHSJvSvIwbFfzRjvEQI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/79] Bluetooth: btusb: QCA: Fix downloading wrong NVM for WCN6855 GF variant without board ID
Date: Tue, 22 Jul 2025 15:44:52 +0200
Message-ID: <20250722134330.436299437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 43015955795a619f7ca4ae69b9c0ffc994c82818 ]

For GF variant of WCN6855 without board ID programmed
btusb_generate_qca_nvm_name() will chose wrong NVM
'qca/nvm_usb_00130201.bin' to download.

Fix by choosing right NVM 'qca/nvm_usb_00130201_gf.bin'.
Also simplify NVM choice logic of btusb_generate_qca_nvm_name().

Fixes: d6cba4e6d0e2 ("Bluetooth: btusb: Add support using different nvm for variant WCN6855 controller")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 78 ++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 25adb3ac40eb8..8bb1162031a6a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3251,6 +3251,32 @@ static const struct qca_device_info qca_devices_table[] = {
 	{ 0x00190200, 40, 4, 16 }, /* WCN785x 2.0 */
 };
 
+static u16 qca_extract_board_id(const struct qca_version *ver)
+{
+	u16 flag = le16_to_cpu(ver->flag);
+	u16 board_id = 0;
+
+	if (((flag >> 8) & 0xff) == QCA_FLAG_MULTI_NVM) {
+		/* The board_id should be split into two bytes
+		 * The 1st byte is chip ID, and the 2nd byte is platform ID
+		 * For example, board ID 0x010A, 0x01 is platform ID. 0x0A is chip ID
+		 * we have several platforms, and platform IDs are continuously added
+		 * Platform ID:
+		 * 0x00 is for Mobile
+		 * 0x01 is for X86
+		 * 0x02 is for Automotive
+		 * 0x03 is for Consumer electronic
+		 */
+		board_id = (ver->chip_id << 8) + ver->platform_id;
+	}
+
+	/* Take 0xffff as invalid board ID */
+	if (board_id == 0xffff)
+		board_id = 0;
+
+	return board_id;
+}
+
 static int btusb_qca_send_vendor_req(struct usb_device *udev, u8 request,
 				     void *data, u16 size)
 {
@@ -3407,44 +3433,28 @@ static void btusb_generate_qca_nvm_name(char *fwname, size_t max_size,
 					const struct qca_version *ver)
 {
 	u32 rom_version = le32_to_cpu(ver->rom_version);
-	u16 flag = le16_to_cpu(ver->flag);
+	const char *variant;
+	int len;
+	u16 board_id;
 
-	if (((flag >> 8) & 0xff) == QCA_FLAG_MULTI_NVM) {
-		/* The board_id should be split into two bytes
-		 * The 1st byte is chip ID, and the 2nd byte is platform ID
-		 * For example, board ID 0x010A, 0x01 is platform ID. 0x0A is chip ID
-		 * we have several platforms, and platform IDs are continuously added
-		 * Platform ID:
-		 * 0x00 is for Mobile
-		 * 0x01 is for X86
-		 * 0x02 is for Automotive
-		 * 0x03 is for Consumer electronic
-		 */
-		u16 board_id = (ver->chip_id << 8) + ver->platform_id;
-		const char *variant;
+	board_id = qca_extract_board_id(ver);
 
-		switch (le32_to_cpu(ver->ram_version)) {
-		case WCN6855_2_0_RAM_VERSION_GF:
-		case WCN6855_2_1_RAM_VERSION_GF:
-			variant = "_gf";
-			break;
-		default:
-			variant = "";
-			break;
-		}
-
-		if (board_id == 0) {
-			snprintf(fwname, max_size, "qca/nvm_usb_%08x%s.bin",
-				rom_version, variant);
-		} else {
-			snprintf(fwname, max_size, "qca/nvm_usb_%08x%s_%04x.bin",
-				rom_version, variant, board_id);
-		}
-	} else {
-		snprintf(fwname, max_size, "qca/nvm_usb_%08x.bin",
-			rom_version);
+	switch (le32_to_cpu(ver->ram_version)) {
+	case WCN6855_2_0_RAM_VERSION_GF:
+	case WCN6855_2_1_RAM_VERSION_GF:
+		variant = "_gf";
+		break;
+	default:
+		variant = NULL;
+		break;
 	}
 
+	len = snprintf(fwname, max_size, "qca/nvm_usb_%08x", rom_version);
+	if (variant)
+		len += snprintf(fwname + len, max_size - len, "%s", variant);
+	if (board_id)
+		len += snprintf(fwname + len, max_size - len, "_%04x", board_id);
+	len += snprintf(fwname + len, max_size - len, ".bin");
 }
 
 static int btusb_setup_qca_load_nvm(struct hci_dev *hdev,
-- 
2.39.5



