Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EDE7BB0F;
	Wed, 21 Feb 2024 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523407; cv=none; b=a8JT8iyUELSpmP8CEp1jnmK9ANO7dUIcQEdVJm+JpgBDSb4ovQX6+VKbIfbEaTSG7qXQszGRXc9iYJQpXQ2X+kjlzgXKDaHCGMycFX0eE2oGEYA+oufFJFgtpJBNc9zhV3NQbpPdONpxJ//v8Yzp7n5St0JAf1OmIoFn5wlyUz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523407; c=relaxed/simple;
	bh=WY+jW6aAuCiWQhUIEekj7/ug+lwVp18R3CeYcOZhbe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebpZAk5ffzHCPBXuA9za8rczBnjqGR9xMcYrmZ1IAJA1Ew6yI78+UmUXVyQGTdlGqj2gNSjS765pLOV1rdG3Qs6qlAZAt/ugmHrG8TX9/s5MX+HBJUIM+P55NUEIfRSyMkNmzz3x3DHhKYUn+h+I3/1Q4Ir/iBuifWO6bTLTgK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=httftXqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="httftXqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B90FC433C7;
	Wed, 21 Feb 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523407;
	bh=WY+jW6aAuCiWQhUIEekj7/ug+lwVp18R3CeYcOZhbe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=httftXqKcZCpJvAt/L5WS1FTvSXoN4c4OpPYd+sBiDSjWVTs6a6b+Zr/Rqvp+s9vG
	 kJnlqQNdx63s7o1UvRljbUao+DCFubqZRUmUGjraCyFa9GHr05UXNjGW817SZw+Yh6
	 V+0C7hGfF91F+XK1r5GEEparSEBmo4e/RX0tWddY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/476] mwifiex: Select firmware based on strapping
Date: Wed, 21 Feb 2024 14:07:58 +0100
Message-ID: <20240221130023.815110111@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

[ Upstream commit 255ca28a659d3cfb069f73c7644853ed93aecdb0 ]

Some WiFi/Bluetooth modules might have different host connection
options, allowing to either use SDIO for both WiFi and Bluetooth,
or SDIO for WiFi and UART for Bluetooth. It is possible to detect
whether a module has SDIO-SDIO or SDIO-UART connection by reading
its host strap register.

This change introduces a way to automatically select appropriate
firmware depending of the connection method, and removes a need
of symlinking or overwriting the original firmware file with a
required one.

Host strap register used in this commit comes from the NXP driver [1]
hosted at Code Aurora.

[1] https://source.codeaurora.org/external/imx/linux-imx/tree/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlinux/moal_sdio_mmc.c?h=rel_imx_5.4.70_2.3.2&id=688b67b2c7220b01521ffe560da7eee33042c7bd#n1274

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220422090313.125857-2-andrejs.cainikovs@toradex.com
Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 21 ++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  5 +++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index b09e60fedeb1..016065a56e6c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -182,6 +182,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
 	.host_int_rsr_reg = 0x4,
 	.host_int_status_reg = 0x0C,
 	.host_int_mask_reg = 0x08,
+	.host_strap_reg = 0xF4,
+	.host_strap_mask = 0x01,
+	.host_strap_value = 0x00,
 	.status_reg_0 = 0xE8,
 	.status_reg_1 = 0xE9,
 	.sdio_int_mask = 0xff,
@@ -283,6 +286,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
 	.host_int_rsr_reg = 0x4,
 	.host_int_status_reg = 0x0C,
 	.host_int_mask_reg = 0x08,
+	.host_strap_reg = 0xF4,
+	.host_strap_mask = 0x01,
+	.host_strap_value = 0x00,
 	.status_reg_0 = 0xE8,
 	.status_reg_1 = 0xE9,
 	.sdio_int_mask = 0xff,
@@ -537,6 +543,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		struct mwifiex_sdio_device *data = (void *)id->driver_data;
 
 		card->firmware = data->firmware;
+		card->firmware_sdiouart = data->firmware_sdiouart;
 		card->reg = data->reg;
 		card->max_ports = data->max_ports;
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
@@ -2440,6 +2447,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	int ret;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
+	const char *firmware = card->firmware;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
@@ -2456,7 +2464,18 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-	strcpy(adapter->fw_name, card->firmware);
+	/* Select correct firmware (sdsd or sdiouart) firmware based on the strapping
+	 * option
+	 */
+	if (card->firmware_sdiouart) {
+		u8 val;
+
+		mwifiex_read_reg(adapter, card->reg->host_strap_reg, &val);
+		if ((val & card->reg->host_strap_mask) == card->reg->host_strap_value)
+			firmware = card->firmware_sdiouart;
+	}
+	strcpy(adapter->fw_name, firmware);
+
 	if (card->fw_dump_enh) {
 		adapter->mem_type_mapping_tbl = generic_mem_type_map;
 		adapter->num_mem_types = 1;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 5648512c9300..ad2c28cbb630 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -196,6 +196,9 @@ struct mwifiex_sdio_card_reg {
 	u8 host_int_rsr_reg;
 	u8 host_int_status_reg;
 	u8 host_int_mask_reg;
+	u8 host_strap_reg;
+	u8 host_strap_mask;
+	u8 host_strap_value;
 	u8 status_reg_0;
 	u8 status_reg_1;
 	u8 sdio_int_mask;
@@ -241,6 +244,7 @@ struct sdio_mmc_card {
 
 	struct completion fw_done;
 	const char *firmware;
+	const char *firmware_sdiouart;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
@@ -274,6 +278,7 @@ struct sdio_mmc_card {
 
 struct mwifiex_sdio_device {
 	const char *firmware;
+	const char *firmware_sdiouart;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
-- 
2.43.0



