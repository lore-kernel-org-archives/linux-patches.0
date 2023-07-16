Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA9C8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9D1C433C8;
	Sun, 16 Jul 2023 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537697;
	bh=Ao0ZEJifQUDDRaYgnh0U8JI3GzeoO6jV7cvrKNgEgNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Brc2MP8wefskyYHRaPJ0v5tycq+M57K7GlOR/ZwJ2SyWA/HnnccGOLns3WyMKYP2W
	 UZCRkjH1UriYYNcA7athnik4jZdI1jx+J2/U3OrUPk6HLiPDTXuIXd4uI3/G1bKHo7
	 1bz+vOPXQxA2NXMbqM7yQgrSVAGAEX210ANSiG0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 189/800] mmc: Add MMC_QUIRK_BROKEN_SD_CACHE for Kingston Canvas Go Plus from 11/2019
Date: Sun, 16 Jul 2023 21:40:42 +0200
Message-ID: <20230716194953.494697776@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit c467c8f081859d4f4ca4eee4fba54bb5d85d6c97 ]

This microSD card never clears Flush Cache bit after cache flush has
been started in sd_flush_cache(). This leads e.g. to failure to mount
file system. Add a quirk which disables the SD cache for this specific
card from specific manufacturing date of 11/2019, since on newer dated
cards from 05/2023 the cache flush works correctly.

Fixes: 08ebf903af57 ("mmc: core: Fixup support for writeback-cache for eMMC and SD")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20230620102713.7701-1-marex@denx.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/card.h   | 30 +++++++++++++++++++++++-------
 drivers/mmc/core/quirks.h | 13 +++++++++++++
 drivers/mmc/core/sd.c     |  2 +-
 include/linux/mmc/card.h  |  1 +
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index cfdd1ff40b865..4edf9057fa79d 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -53,6 +53,10 @@ struct mmc_fixup {
 	unsigned int manfid;
 	unsigned short oemid;
 
+	/* Manufacturing date */
+	unsigned short year;
+	unsigned char month;
+
 	/* SDIO-specific fields. You can use SDIO_ANY_ID here of course */
 	u16 cis_vendor, cis_device;
 
@@ -68,6 +72,8 @@ struct mmc_fixup {
 
 #define CID_MANFID_ANY (-1u)
 #define CID_OEMID_ANY ((unsigned short) -1)
+#define CID_YEAR_ANY ((unsigned short) -1)
+#define CID_MONTH_ANY ((unsigned char) -1)
 #define CID_NAME_ANY (NULL)
 
 #define EXT_CSD_REV_ANY (-1u)
@@ -81,17 +87,21 @@ struct mmc_fixup {
 #define CID_MANFID_APACER       0x27
 #define CID_MANFID_KINGSTON     0x70
 #define CID_MANFID_HYNIX	0x90
+#define CID_MANFID_KINGSTON_SD	0x9F
 #define CID_MANFID_NUMONYX	0xFE
 
 #define END_FIXUP { NULL }
 
-#define _FIXUP_EXT(_name, _manfid, _oemid, _rev_start, _rev_end,	\
-		   _cis_vendor, _cis_device,				\
-		   _fixup, _data, _ext_csd_rev)				\
+#define _FIXUP_EXT(_name, _manfid, _oemid, _year, _month,	\
+		   _rev_start, _rev_end,			\
+		   _cis_vendor, _cis_device,			\
+		   _fixup, _data, _ext_csd_rev)			\
 	{						\
 		.name = (_name),			\
 		.manfid = (_manfid),			\
 		.oemid = (_oemid),			\
+		.year = (_year),			\
+		.month = (_month),			\
 		.rev_start = (_rev_start),		\
 		.rev_end = (_rev_end),			\
 		.cis_vendor = (_cis_vendor),		\
@@ -103,8 +113,8 @@ struct mmc_fixup {
 
 #define MMC_FIXUP_REV(_name, _manfid, _oemid, _rev_start, _rev_end,	\
 		      _fixup, _data, _ext_csd_rev)			\
-	_FIXUP_EXT(_name, _manfid,					\
-		   _oemid, _rev_start, _rev_end,			\
+	_FIXUP_EXT(_name, _manfid, _oemid, CID_YEAR_ANY, CID_MONTH_ANY,	\
+		   _rev_start, _rev_end,				\
 		   SDIO_ANY_ID, SDIO_ANY_ID,				\
 		   _fixup, _data, _ext_csd_rev)				\
 
@@ -118,8 +128,9 @@ struct mmc_fixup {
 		      _ext_csd_rev)
 
 #define SDIO_FIXUP(_vendor, _device, _fixup, _data)			\
-	_FIXUP_EXT(CID_NAME_ANY, CID_MANFID_ANY,			\
-		    CID_OEMID_ANY, 0, -1ull,				\
+	_FIXUP_EXT(CID_NAME_ANY, CID_MANFID_ANY, CID_OEMID_ANY,		\
+		   CID_YEAR_ANY, CID_MONTH_ANY,				\
+		   0, -1ull,						\
 		   _vendor, _device,					\
 		   _fixup, _data, EXT_CSD_REV_ANY)			\
 
@@ -264,4 +275,9 @@ static inline int mmc_card_broken_sd_discard(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_SD_DISCARD;
 }
 
+static inline int mmc_card_broken_sd_cache(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_SD_CACHE;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index 29b9497936df9..a7ffbc930ea9d 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -53,6 +53,15 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	MMC_FIXUP("MMC32G", CID_MANFID_TOSHIBA, CID_OEMID_ANY, add_quirk_mmc,
 		  MMC_QUIRK_BLK_NO_CMD23),
 
+	/*
+	 * Kingston Canvas Go! Plus microSD cards never finish SD cache flush.
+	 * This has so far only been observed on cards from 11/2019, while new
+	 * cards from 2023/05 do not exhibit this behavior.
+	 */
+	_FIXUP_EXT("SD64G", CID_MANFID_KINGSTON_SD, 0x5449, 2019, 11,
+		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
+		   MMC_QUIRK_BROKEN_SD_CACHE, EXT_CSD_REV_ANY),
+
 	/*
 	 * Some SD cards lockup while using CMD23 multiblock transfers.
 	 */
@@ -209,6 +218,10 @@ static inline void mmc_fixup_device(struct mmc_card *card,
 		if (f->of_compatible &&
 		    !mmc_fixup_of_compatible_match(card, f->of_compatible))
 			continue;
+		if (f->year != CID_YEAR_ANY && f->year != card->cid.year)
+			continue;
+		if (f->month != CID_MONTH_ANY && f->month != card->cid.month)
+			continue;
 
 		dev_dbg(&card->dev, "calling %ps\n", f->vendor_fixup);
 		f->vendor_fixup(card, f->data);
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 72b664ed90cf6..246ce027ae0aa 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1170,7 +1170,7 @@ static int sd_parse_ext_reg_perf(struct mmc_card *card, u8 fno, u8 page,
 		card->ext_perf.feature_support |= SD_EXT_PERF_HOST_MAINT;
 
 	/* Cache support at bit 0. */
-	if (reg_buf[4] & BIT(0))
+	if ((reg_buf[4] & BIT(0)) && !mmc_card_broken_sd_cache(card))
 		card->ext_perf.feature_support |= SD_EXT_PERF_CACHE;
 
 	/* Command queue support indicated via queue depth bits (0 to 4). */
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index c726ea7812552..daa2f40d9ce65 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -294,6 +294,7 @@ struct mmc_card {
 #define MMC_QUIRK_TRIM_BROKEN	(1<<12)		/* Skip trim */
 #define MMC_QUIRK_BROKEN_HPI	(1<<13)		/* Disable broken HPI support */
 #define MMC_QUIRK_BROKEN_SD_DISCARD	(1<<14)	/* Disable broken SD discard support */
+#define MMC_QUIRK_BROKEN_SD_CACHE	(1<<15)	/* Disable broken SD cache support */
 
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
 
-- 
2.39.2



