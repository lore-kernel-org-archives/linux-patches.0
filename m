Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EF314AD12;
	Tue, 20 Feb 2024 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463219; cv=none; b=ZyRgn/r+saxpYsO9AW6IT91JV1dQTt6t6K7psObsvGvyYeuPnJ4WwaKQqP6UFZvD7amcnDbooNAu8zqUa2FY6f18DZxcFj2QzKGFmDhb6hailbkYV73GTzL4EpKQJAwD/2DOjp4+Zge1uV11QGREjNc1pGkheLgmFSGOsdhWpgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463219; c=relaxed/simple;
	bh=yz1R2pA1fTPm8g5qXDDPX9UTIGsjeA/IUubNFbzvJ+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWEkXO4s/Lw7buC7jNwNNzLuO54J4AAvfMhm2Jai+PHfv0v/0FCT90gOKjeHngV7q9jT20qE9ErogmOwIaJLuv0RLXo4Q5fmmYr2PnBEVIDEysRmOwG7lODe02RsihDDt7skaflruKZbFZFqEi9w1fbmgX2bws1789L8qpatmII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiqutPMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiqutPMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B666C433C7;
	Tue, 20 Feb 2024 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463219;
	bh=yz1R2pA1fTPm8g5qXDDPX9UTIGsjeA/IUubNFbzvJ+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiqutPMJuTyYCpoggYjDf/ympgigmlQ1lyxcnqAKjm5MdcHKC6CbfiHWfXgOmfQwq
	 beMzaiCtsqsYIlsp/Gy9qP1hthu7BubgpfJyH4MwUPKaaKf+q9J9mzuV7v1R1eVxRY
	 CyhOQeh5pI8U5zbfMUwRlxw1O15q0q2PJ95foGi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/197] wifi: mwifiex: Support SD8978 chipset
Date: Tue, 20 Feb 2024 21:52:13 +0100
Message-ID: <20240220204846.279064097@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit bba047f15851c8b053221f1b276eb7682d59f755 ]

The Marvell SD8978 (aka NXP IW416) uses identical registers as SD8987,
so reuse the existing mwifiex_reg_sd8987 definition.

Note that mwifiex_reg_sd8977 and mwifiex_reg_sd8997 are likewise
identical, save for the fw_dump_ctrl register:  They define it as 0xf0
whereas mwifiex_reg_sd8987 defines it as 0xf9.  I've verified that
0xf9 is the correct value on SD8978.  NXP's out-of-tree driver uses
0xf9 for all of them, so there's a chance that 0xf0 is not correct
in the mwifiex_reg_sd8977 and mwifiex_reg_sd8997 definitions.  I cannot
test that for lack of hardware, hence am leaving it as is.

NXP has only released a firmware which runs Bluetooth over UART.
Perhaps Bluetooth over SDIO is unsupported by this chipset.
Consequently, only an "sdiouart" firmware image is referenced, not an
alternative "sdsd" image.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/536b4f17a72ca460ad1b07045757043fb0778988.1674827105.git.lukas@wunner.de
Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/net/wireless/marvell-8xxx.txt    |  4 ++-
 drivers/net/wireless/marvell/mwifiex/Kconfig  |  5 ++--
 drivers/net/wireless/marvell/mwifiex/sdio.c   | 25 +++++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.h   |  1 +
 include/linux/mmc/sdio_ids.h                  |  1 +
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
index 9bf9bbac16e2..cdc303caf5f4 100644
--- a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -1,4 +1,4 @@
-Marvell 8787/8897/8997 (sd8787/sd8897/sd8997/pcie8997) SDIO/PCIE devices
+Marvell 8787/8897/8978/8997 (sd8787/sd8897/sd8978/sd8997/pcie8997) SDIO/PCIE devices
 ------
 
 This node provides properties for controlling the Marvell SDIO/PCIE wireless device.
@@ -10,7 +10,9 @@ Required properties:
   - compatible : should be one of the following:
 	* "marvell,sd8787"
 	* "marvell,sd8897"
+	* "marvell,sd8978"
 	* "marvell,sd8997"
+	* "nxp,iw416"
 	* "pci11ab,2b42"
 	* "pci1b4b,2b42"
 
diff --git a/drivers/net/wireless/marvell/mwifiex/Kconfig b/drivers/net/wireless/marvell/mwifiex/Kconfig
index 2b4ff2b78a7e..b182f7155d66 100644
--- a/drivers/net/wireless/marvell/mwifiex/Kconfig
+++ b/drivers/net/wireless/marvell/mwifiex/Kconfig
@@ -10,13 +10,14 @@ config MWIFIEX
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/SD8977/SD8987/SD8997"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/SD8977/SD8978/SD8987/SD8997"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
 	help
 	  This adds support for wireless adapters based on Marvell
-	  8786/8787/8797/8887/8897/8977/8987/8997 chipsets with SDIO interface.
+	  8786/8787/8797/8887/8897/8977/8978/8987/8997 chipsets with
+	  SDIO interface. SD8978 is also known as NXP IW416.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index ea1c1c2412e7..a24bd40dd41a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -263,7 +263,7 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
 				 0x68, 0x69, 0x6a},
 };
 
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd89xx = {
 	.start_rd_port = 0,
 	.start_wr_port = 0,
 	.base_0_reg = 0xF8,
@@ -394,6 +394,22 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
 	.can_ext_scan = true,
 };
 
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8978 = {
+	.firmware_sdiouart = SD8978_SDIOUART_FW_NAME,
+	.reg = &mwifiex_reg_sd89xx,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
 	.firmware = SD8997_DEFAULT_FW_NAME,
 	.firmware_sdiouart = SD8997_SDIOUART_FW_NAME,
@@ -428,7 +444,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
 	.firmware = SD8987_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8987,
+	.reg = &mwifiex_reg_sd89xx,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
@@ -482,7 +498,9 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
+	{ .compatible = "marvell,sd8978" },
 	{ .compatible = "marvell,sd8997" },
+	{ .compatible = "nxp,iw416" },
 	{ }
 };
 
@@ -920,6 +938,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8801},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8977_WLAN),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8977},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8978_WLAN),
+		.driver_data = (unsigned long)&mwifiex_sdio_sd8978},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8987_WLAN),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8987},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8997_WLAN),
@@ -3164,6 +3184,7 @@ MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8978_SDIOUART_FW_NAME);
 MODULE_FIRMWARE(SD8987_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_SDIOUART_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 3a24bb48b299..ae94c172310f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -25,6 +25,7 @@
 #define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
 #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
+#define SD8978_SDIOUART_FW_NAME "mrvl/sdiouartiw416_combo_v0.bin"
 #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
 #define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
 #define SD8997_SDIOUART_FW_NAME "mrvl/sdiouart8997_combo_v4.bin"
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 74f9d9a6d330..0e4ef9c5127a 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -102,6 +102,7 @@
 #define SDIO_DEVICE_ID_MARVELL_8977_BT		0x9146
 #define SDIO_DEVICE_ID_MARVELL_8987_WLAN	0x9149
 #define SDIO_DEVICE_ID_MARVELL_8987_BT		0x914a
+#define SDIO_DEVICE_ID_MARVELL_8978_WLAN	0x9159
 
 #define SDIO_VENDOR_ID_MEDIATEK			0x037a
 #define SDIO_DEVICE_ID_MEDIATEK_MT7663		0x7663
-- 
2.43.0



