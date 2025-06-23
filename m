Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8475C1ACEDA;
	Mon, 23 Jun 2025 21:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713864; cv=none; b=ekP1ouILO5+EJJ2WVsZgwK4u1VkXpRkI4p79h4/MP3XQk17ra11z77QFqBa4bPE9YrzCpOe6jzREJl8XLepfUOHRF4Ftifwo+4CDd3uNj35J7qxNB8FI8IQycjyvZJv0VUuOmcUIulGgliNB7NxmyzuF9ZJfQjatkWbbPZ9sHyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713864; c=relaxed/simple;
	bh=3TlEnTNGwM+REEYtfs0cgc49b8FdTmGGY5198hZR9A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuHEwtfEMYoxc7roXyrD1K4VKzG+kUMD9BIijS0zA++Niw0h5Gm7B7mgc5Kc+VAd71VMqsScd3e2GZKd6XKxgRLl4wokDvcySitxS3U6r00wNSFdSET6fxBhqWcU2IlTb1xcGBWglW6whroPT16Oyw1b+sJvaorfSylQYbH4XsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YLn0u4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YLn0u4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5F9C4CEEA;
	Mon, 23 Jun 2025 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713864;
	bh=3TlEnTNGwM+REEYtfs0cgc49b8FdTmGGY5198hZR9A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YLn0u4DkwBh+qM1+3gBCrnxhgMJEGAd5+HI6gviCXoZNywCMDQaP3XSbwyJBXtUr
	 KKysIdWXFEQuupHBSGR3vPWJB8VaMT/p1tsCP2yQdITWNuYAJ4YQ828tZMWafJMSqj
	 0mb9PnJ3C0ggl6QNu6XTvxRu5QXbpacS2Q2YQqdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/290] mmc: Add quirk to disable DDR50 tuning
Date: Mon, 23 Jun 2025 15:06:21 +0200
Message-ID: <20250623130630.547095593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Erick Shepherd <erick.shepherd@ni.com>

[ Upstream commit 9510b38dc0ba358c93cbf5ee7c28820afb85937b ]

Adds the MMC_QUIRK_NO_UHS_DDR50_TUNING quirk and updates
mmc_execute_tuning() to return 0 if that quirk is set. This fixes an
issue on certain Swissbit SD cards that do not support DDR50 tuning
where tuning requests caused I/O errors to be thrown.

Signed-off-by: Erick Shepherd <erick.shepherd@ni.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250331221337.1414534-1-erick.shepherd@ni.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/card.h   |  6 ++++++
 drivers/mmc/core/quirks.h | 10 ++++++++++
 drivers/mmc/core/sd.c     | 32 ++++++++++++++++++++++++--------
 include/linux/mmc/card.h  |  1 +
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 8476754b1b170..fe0b2fa3bb89d 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -86,6 +86,7 @@ struct mmc_fixup {
 #define CID_MANFID_MICRON       0x13
 #define CID_MANFID_SAMSUNG      0x15
 #define CID_MANFID_APACER       0x27
+#define CID_MANFID_SWISSBIT     0x5D
 #define CID_MANFID_KINGSTON     0x70
 #define CID_MANFID_HYNIX	0x90
 #define CID_MANFID_KINGSTON_SD	0x9F
@@ -291,4 +292,9 @@ static inline int mmc_card_broken_sd_poweroff_notify(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY;
 }
 
+static inline int mmc_card_no_uhs_ddr50_tuning(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_NO_UHS_DDR50_TUNING;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index 89b512905be14..7f893bafaa607 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -34,6 +34,16 @@ static const struct mmc_fixup __maybe_unused mmc_sd_fixups[] = {
 		   MMC_QUIRK_BROKEN_SD_CACHE | MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY,
 		   EXT_CSD_REV_ANY),
 
+	/*
+	 * Swissbit series S46-u cards throw I/O errors during tuning requests
+	 * after the initial tuning request expectedly times out. This has
+	 * only been observed on cards manufactured on 01/2019 that are using
+	 * Bay Trail host controllers.
+	 */
+	_FIXUP_EXT("0016G", CID_MANFID_SWISSBIT, 0x5342, 2019, 1,
+		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
+		   MMC_QUIRK_NO_UHS_DDR50_TUNING, EXT_CSD_REV_ANY),
+
 	END_FIXUP
 };
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index f02c3e5eb5c85..a06f3011e2b58 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -618,6 +618,29 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 	return 0;
 }
 
+/*
+ * Determine if the card should tune or not.
+ */
+static bool mmc_sd_use_tuning(struct mmc_card *card)
+{
+	/*
+	 * SPI mode doesn't define CMD19 and tuning is only valid for SDR50 and
+	 * SDR104 mode SD-cards. Note that tuning is mandatory for SDR104.
+	 */
+	if (mmc_host_is_spi(card->host))
+		return false;
+
+	switch (card->host->ios.timing) {
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+		return true;
+	case MMC_TIMING_UHS_DDR50:
+		return !mmc_card_no_uhs_ddr50_tuning(card);
+	}
+
+	return false;
+}
+
 /*
  * UHS-I specific initialization procedure
  */
@@ -661,14 +684,7 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
 	if (err)
 		goto out;
 
-	/*
-	 * SPI mode doesn't define CMD19 and tuning is only valid for SDR50 and
-	 * SDR104 mode SD-cards. Note that tuning is mandatory for SDR104.
-	 */
-	if (!mmc_host_is_spi(card->host) &&
-		(card->host->ios.timing == MMC_TIMING_UHS_SDR50 ||
-		 card->host->ios.timing == MMC_TIMING_UHS_DDR50 ||
-		 card->host->ios.timing == MMC_TIMING_UHS_SDR104)) {
+	if (mmc_sd_use_tuning(card)) {
 		err = mmc_execute_tuning(card);
 
 		/*
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index afa575e362a47..7c6da19fff9f0 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -297,6 +297,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_SD_CACHE	(1<<15)	/* Disable broken SD cache support */
 #define MMC_QUIRK_BROKEN_CACHE_FLUSH	(1<<16)	/* Don't flush cache until the write has occurred */
 #define MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY	(1<<17) /* Disable broken SD poweroff notify support */
+#define MMC_QUIRK_NO_UHS_DDR50_TUNING	(1<<18) /* Disable DDR50 tuning */
 
 	bool			written_flag;	/* Indicates eMMC has been written since power on */
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
-- 
2.39.5



