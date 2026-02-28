Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B135AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302755; cv=none; b=Vs+2Mu5BqhXvGQXQZCN8QYnaol8yK5APTTsgL2vBS1tE9xnKbVTC13bruyCyjmk19upIjO1z5j+jShAE9hrDwxlT+YWESmZbd7JC8nPQ7GzYVYyo4scNklSGKrHjtWTFJNItHqMLtOnmsME0tQtuvFQ4t12DsLjmEkzOFC9RGsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302755; c=relaxed/simple;
	bh=2wX+bfZZ08Hn/+frIcphgPV6ljtuTAv7JnlyPENXOgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCwOjxwrECWr4nBuPwtwbd0Z9NAmWOSVwBNc9UwuC4zRjFR2N3VhCKAqF6xizvuK2s6Pk6hX+ErHIGU8gwzElHG2TCVAZYxKabzjMtWMTAQVLf8gNCCnh/ECK59TtIi6GWePLNukhcsquD5U68guP2/pfklSFdfXw1D3k5dwh2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHlKp5IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHlKp5IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943F1C19424;
	Sat, 28 Feb 2026 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302755;
	bh=2wX+bfZZ08Hn/+frIcphgPV6ljtuTAv7JnlyPENXOgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHlKp5IQxe8Xlzm+Qh1yAEMsuSDP5NK5BTwFspciOuv5I6YF07Xb2gv7ptz4odm2M
	 /EcUiWE+R8q4GrrNk+UQKv1uoIRQyeHNA4ZWxltKw/XDx/2XyCACim/RZN1toQpIR3
	 HMCFxe5nBp1TeOW42382+vFL4cMy/HpNoI7+oS3txLCzz6/K2NSSIZn4Hgch6PcR4l
	 jvh0fj1fBPc2bt6Ml+OKafuuh4oOpQhvMBF7ZcFg+9VLN4FnrMXcIWa5tDS/sRWcVY
	 oWH34JCvtc0qrQNeEAPPn3ezlV8ZTy8t6MDxsAjn2EriTpSBpWxZuhvIWDj2VTG9TX
	 F6ID2I5W8U5PQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@lst.de>,
	Rui Feng <rui_feng@realsil.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/147] mmc: core: Initial support for SD express card/host
Date: Sat, 28 Feb 2026 13:17:12 -0500
Message-ID: <20260228181736.1605592-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit ead49373d2916080509f51fc6a4ee8f9bc021b9b ]

In the SD specification v7.10 the SD express card has been added. This new
type of removable SD card, can be managed via a PCIe/NVMe based interface,
while also allowing backwards compatibility towards the legacy SD
interface.

To keep the backwards compatibility, it's required to start the
initialization through the legacy SD interface. If it turns out that the
mmc host and the SD card, both supports the PCIe/NVMe interface, then a
switch should be allowed.

Therefore, let's introduce some basic support for this type of SD cards to
the mmc core. The mmc host, should set MMC_CAP2_SD_EXP if it supports this
interface and MMC_CAP2_SD_EXP_1_2V, if also 1.2V is supported, as to inform
the core about it.

To deal with the switch to the PCIe/NVMe interface, the mmc host is
required to implement a new host ops, ->init_sd_express(). Based on the
initial communication between the host and the card, host->ios.timing is
set to either MMC_TIMING_SD_EXP or MMC_TIMING_SD_EXP_1_2V, depending on if
1.2V is supported or not. In this way, the mmc host can check these values
in its ->init_sd_express() ops, to know how to proceed with the handover.

Note that, to manage card insert/removal, the mmc core sticks with using
the ->get_cd() callback, which means it's the host's responsibility to make
sure it provides valid data, even if the card may be managed by PCIe/NVMe
at the moment. As long as the card seems to be present, the mmc core keeps
the card powered on.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Rui Feng <rui_feng@realsil.com.cn>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/1603936636-3126-1-git-send-email-rui_feng@realsil.com.cn
Stable-dep-of: aced969e9bf3 ("mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/core.c   | 15 ++++++++++--
 drivers/mmc/core/host.h   |  6 +++++
 drivers/mmc/core/sd_ops.c | 49 +++++++++++++++++++++++++++++++++++++--
 drivers/mmc/core/sd_ops.h |  1 +
 include/linux/mmc/host.h  |  7 ++++++
 5 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 0f73ee841574a..d8169c8c3f405 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2166,8 +2166,12 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 
 	mmc_go_idle(host);
 
-	if (!(host->caps2 & MMC_CAP2_NO_SD))
-		mmc_send_if_cond(host, host->ocr_avail);
+	if (!(host->caps2 & MMC_CAP2_NO_SD)) {
+		if (mmc_send_if_cond_pcie(host, host->ocr_avail))
+			goto out;
+		if (mmc_card_sd_express(host))
+			return 0;
+	}
 
 	/* Order's important: probe SDIO, then SD, then MMC */
 	if (!(host->caps2 & MMC_CAP2_NO_SDIO))
@@ -2182,6 +2186,7 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 		if (!mmc_attach_mmc(host))
 			return 0;
 
+out:
 	mmc_power_off(host);
 	return -EIO;
 }
@@ -2309,6 +2314,12 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+	/* If an SD express card is present, then leave it as is. */
+	if (mmc_card_sd_express(host)) {
+		mmc_release_host(host);
+		goto out;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
 		unsigned int freq = freqs[i];
 		if (freq > host->f_max) {
diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
index 5e3b9534ffb23..ba407617ed23a 100644
--- a/drivers/mmc/core/host.h
+++ b/drivers/mmc/core/host.h
@@ -77,5 +77,11 @@ static inline bool mmc_card_hs400es(struct mmc_card *card)
 	return card->host->ios.enhanced_strobe;
 }
 
+static inline bool mmc_card_sd_express(struct mmc_host *host)
+{
+	return host->ios.timing == MMC_TIMING_SD_EXP ||
+		host->ios.timing == MMC_TIMING_SD_EXP_1_2V;
+}
+
 #endif
 
diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 22bf528294b90..d61ff811218ce 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -158,7 +158,8 @@ int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 	return err;
 }
 
-int mmc_send_if_cond(struct mmc_host *host, u32 ocr)
+static int __mmc_send_if_cond(struct mmc_host *host, u32 ocr, u8 pcie_bits,
+			      u32 *resp)
 {
 	struct mmc_command cmd = {};
 	int err;
@@ -171,7 +172,7 @@ int mmc_send_if_cond(struct mmc_host *host, u32 ocr)
 	 * SD 1.0 cards.
 	 */
 	cmd.opcode = SD_SEND_IF_COND;
-	cmd.arg = ((ocr & 0xFF8000) != 0) << 8 | test_pattern;
+	cmd.arg = ((ocr & 0xFF8000) != 0) << 8 | pcie_bits << 8 | test_pattern;
 	cmd.flags = MMC_RSP_SPI_R7 | MMC_RSP_R7 | MMC_CMD_BCR;
 
 	err = mmc_wait_for_cmd(host, &cmd, 0);
@@ -186,6 +187,50 @@ int mmc_send_if_cond(struct mmc_host *host, u32 ocr)
 	if (result_pattern != test_pattern)
 		return -EIO;
 
+	if (resp)
+		*resp = cmd.resp[0];
+
+	return 0;
+}
+
+int mmc_send_if_cond(struct mmc_host *host, u32 ocr)
+{
+	return __mmc_send_if_cond(host, ocr, 0, NULL);
+}
+
+int mmc_send_if_cond_pcie(struct mmc_host *host, u32 ocr)
+{
+	u32 resp = 0;
+	u8 pcie_bits = 0;
+	int ret;
+
+	if (host->caps2 & MMC_CAP2_SD_EXP) {
+		/* Probe card for SD express support via PCIe. */
+		pcie_bits = 0x10;
+		if (host->caps2 & MMC_CAP2_SD_EXP_1_2V)
+			/* Probe also for 1.2V support. */
+			pcie_bits = 0x30;
+	}
+
+	ret = __mmc_send_if_cond(host, ocr, pcie_bits, &resp);
+	if (ret)
+		return 0;
+
+	/* Continue with the SD express init, if the card supports it. */
+	resp &= 0x3000;
+	if (pcie_bits && resp) {
+		if (resp == 0x3000)
+			host->ios.timing = MMC_TIMING_SD_EXP_1_2V;
+		else
+			host->ios.timing = MMC_TIMING_SD_EXP;
+
+		/*
+		 * According to the spec the clock shall also be gated, but
+		 * let's leave this to the host driver for more flexibility.
+		 */
+		return host->ops->init_sd_express(host, &host->ios);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/mmc/core/sd_ops.h b/drivers/mmc/core/sd_ops.h
index 2194cabfcfc57..3ba7b3cf46520 100644
--- a/drivers/mmc/core/sd_ops.h
+++ b/drivers/mmc/core/sd_ops.h
@@ -16,6 +16,7 @@ struct mmc_host;
 int mmc_app_set_bus_width(struct mmc_card *card, int width);
 int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_send_if_cond(struct mmc_host *host, u32 ocr);
+int mmc_send_if_cond_pcie(struct mmc_host *host, u32 ocr);
 int mmc_send_relative_addr(struct mmc_host *host, unsigned int *rca);
 int mmc_app_send_scr(struct mmc_card *card);
 int mmc_sd_switch(struct mmc_card *card, int mode, int group,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index fb08b86acdbf3..dd3492f377d00 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -60,6 +60,8 @@ struct mmc_ios {
 #define MMC_TIMING_MMC_DDR52	8
 #define MMC_TIMING_MMC_HS200	9
 #define MMC_TIMING_MMC_HS400	10
+#define MMC_TIMING_SD_EXP	11
+#define MMC_TIMING_SD_EXP_1_2V	12
 
 	unsigned char	signal_voltage;		/* signalling voltage (1.8V or 3.3V) */
 
@@ -173,6 +175,9 @@ struct mmc_host_ops {
 	 */
 	int	(*multi_io_quirk)(struct mmc_card *card,
 				  unsigned int direction, int blk_size);
+
+	/* Initialize an SD express card, mandatory for MMC_CAP2_SD_EXP. */
+	int	(*init_sd_express)(struct mmc_host *host, struct mmc_ios *ios);
 };
 
 struct mmc_cqe_ops {
@@ -355,6 +360,8 @@ struct mmc_host {
 #define MMC_CAP2_HS200_1_2V_SDR	(1 << 6)        /* can support */
 #define MMC_CAP2_HS200		(MMC_CAP2_HS200_1_8V_SDR | \
 				 MMC_CAP2_HS200_1_2V_SDR)
+#define MMC_CAP2_SD_EXP		(1 << 7)	/* SD express via PCIe */
+#define MMC_CAP2_SD_EXP_1_2V	(1 << 8)	/* SD express 1.2V */
 #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
 #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
 #define MMC_CAP2_NO_PRESCAN_POWERUP (1 << 14)	/* Don't power up before scan */
-- 
2.51.0

