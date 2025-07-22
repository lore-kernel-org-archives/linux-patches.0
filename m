Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770132B9A5;
	Tue, 22 Jul 2025 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192485; cv=none; b=pmi3mx+XA/IQ6jJvOvHisk/ed2OgTyMSHufHHniO4sIDgnmueubYVvdewaswPETtL4uBTB4MVpRspzj9k5gdzV8nicYxE16Eu5zpIj5S/z0ylIG7+btadIgP+ZraZN5CISj719/YJaCKsC4lXSR/Di1lrBHAaQcsTid/vzrnxAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192485; c=relaxed/simple;
	bh=dGyCl3ERWex265j79UCLnqNDI5r1RrPQDBv6QWIGTSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y34OrHXU61kP4ZLL5O0OjR1kTahpFPIJlGlZOuYbG7FSsQR/yDZsRsM2syllUWF9clmWdZaxq7eOpRCGaTPZ+qTASUrtyhaRZC40quO/nmebevFeQMVA9SSLP9XhxzExDxZbaP9HGGZDvUtCB7MHQ8hH3SEoThhhwmKpvLdC6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6LBw/Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6LBw/Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADA9C4CEEB;
	Tue, 22 Jul 2025 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192485;
	bh=dGyCl3ERWex265j79UCLnqNDI5r1RrPQDBv6QWIGTSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6LBw/FmGe122ieDE8bqOsLnjiNLDjj6T6x1PC8OpMHa5N1B4urZ8a2TPeEKe4KAI
	 BVm7Fq3cMjgYW8u3BrFWGYcFsYLyKgpHUii4IS29QmAC5mxhGtMsytDAuEbXv6oJDJ
	 7yxfJ/TvijDep1/vpIkx+mVdVBuEaTDzkI2IiXPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/111] Bluetooth: btusb: QCA: Fix downloading wrong NVM for WCN6855 GF variant without board ID
Date: Tue, 22 Jul 2025 15:44:55 +0200
Message-ID: <20250722134336.387352478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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
index e0dd698896088..db507a66fa8ac 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3736,6 +3736,32 @@ static const struct qca_device_info qca_devices_table[] = {
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
@@ -3892,44 +3918,28 @@ static void btusb_generate_qca_nvm_name(char *fwname, size_t max_size,
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



