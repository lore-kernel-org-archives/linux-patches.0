Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFA2211476;
	Thu, 12 Dec 2024 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015979; cv=none; b=T4GMoVJjnIDtEIbGMw8CkHT5P6JhU1pFeRUc+fOjIgFx2OqNXnF2iCibDokRfH7xEIrpfDIIjIgwlXkUJ+/Pxwl/tkidu3jKuLf1n2EfFVZW6w3jbJd59cfjlLku8a8QaL/UC8sijmNyM8z51103KD/o9wHSJKtAVqeNK9ZK6KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015979; c=relaxed/simple;
	bh=tg/RtxyBu2zlek1zBWEiWWnBJevvlXh3hjgqPuLopFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fANerXVw8EVxOEuHWnt1qHdE+SoedczzdJpTrK6tEAee8if5Ysjlviz2mqT1bgbyX+w4tRSONnD6LeqUlHwYS+23MgHqP3Vzskea+wXYfEBBboxgGByzeIB8PCTk/VrypO+jbKihLZYKrwm1BzwlNhhFoijCcxTkHceJDhbNljI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBatNN0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBatNN0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCA3C4CECE;
	Thu, 12 Dec 2024 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015978;
	bh=tg/RtxyBu2zlek1zBWEiWWnBJevvlXh3hjgqPuLopFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBatNN0eZvtXfjoWJk4peeOH2LJ8Z9iF4qhp8vPuwscMR+csZCLcqbotQnWAaQMFd
	 zQbnUcFdxKhxrOdJpnEujsZPc1QJ0jMRUDRBK9LmkRTCTC8o1waW05BZvVYlRhN7Ly
	 erFI0SJIeZzBDhnh/wJwsHUNABmAixkgxjqYxLb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky WU <ricky_wu@realtek.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/466] mmc: sd: SDUC Support Recognition
Date: Thu, 12 Dec 2024 15:53:56 +0100
Message-ID: <20241212144309.464685123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit fce2ce78af1e14dc1316aaddb5b3308be05cf452 ]

Ultra Capacity SD cards (SDUC) was already introduced in SD7.0.  Those
cards support capacity larger than 2TB and up to including 128TB.

ACMD41 was extended to support the host-card handshake during
initialization.  The card expects that the HCS & HO2T bits to be set in
the command argument, and sets the applicable bits in the R3 returned
response.  On the contrary, if a SDUC card is inserted to a
non-supporting host, it will never respond to this ACMD41 until
eventually, the host will timed out and give up.

Also, add SD CSD version 3.0 - designated for SDUC, and properly parse
the csd register as the c_size field got expanded to 28 bits.

Do not enable SDUC for now - leave it to the last patch in the series.

Tested-by: Ricky WU <ricky_wu@realtek.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241006051148.160278-2-avri.altman@wdc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 869d37475788 ("mmc: core: Use GFP_NOIO in ACMD22")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/bus.c   |  4 +++-
 drivers/mmc/core/card.h  |  3 +++
 drivers/mmc/core/sd.c    | 28 +++++++++++++++++-----------
 drivers/mmc/core/sd.h    |  2 +-
 drivers/mmc/core/sdio.c  |  2 +-
 include/linux/mmc/card.h |  2 +-
 include/linux/mmc/sd.h   |  1 +
 7 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 0ddaee0eae54f..30763b342bd36 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -321,7 +321,9 @@ int mmc_add_card(struct mmc_card *card)
 	case MMC_TYPE_SD:
 		type = "SD";
 		if (mmc_card_blockaddr(card)) {
-			if (mmc_card_ext_capacity(card))
+			if (mmc_card_ult_capacity(card))
+				type = "SDUC";
+			else if (mmc_card_ext_capacity(card))
 				type = "SDXC";
 			else
 				type = "SDHC";
diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index b7754a1b8d978..64dcb463a4f49 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -23,6 +23,7 @@
 #define MMC_CARD_SDXC		(1<<3)		/* card is SDXC */
 #define MMC_CARD_REMOVED	(1<<4)		/* card has been removed */
 #define MMC_STATE_SUSPENDED	(1<<5)		/* card is suspended */
+#define MMC_CARD_SDUC		(1<<6)		/* card is SDUC */
 
 #define mmc_card_present(c)	((c)->state & MMC_STATE_PRESENT)
 #define mmc_card_readonly(c)	((c)->state & MMC_STATE_READONLY)
@@ -30,11 +31,13 @@
 #define mmc_card_ext_capacity(c) ((c)->state & MMC_CARD_SDXC)
 #define mmc_card_removed(c)	((c) && ((c)->state & MMC_CARD_REMOVED))
 #define mmc_card_suspended(c)	((c)->state & MMC_STATE_SUSPENDED)
+#define mmc_card_ult_capacity(c) ((c)->state & MMC_CARD_SDUC)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 #define mmc_card_set_ext_capacity(c) ((c)->state |= MMC_CARD_SDXC)
+#define mmc_card_set_ult_capacity(c) ((c)->state |= MMC_CARD_SDUC)
 #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
 #define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
 #define mmc_card_clr_suspended(c) ((c)->state &= ~MMC_STATE_SUSPENDED)
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 12fe282bea77e..1d09f0f2e7697 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -100,7 +100,7 @@ void mmc_decode_cid(struct mmc_card *card)
 /*
  * Given a 128-bit response, decode to our card CSD structure.
  */
-static int mmc_decode_csd(struct mmc_card *card)
+static int mmc_decode_csd(struct mmc_card *card, bool is_sduc)
 {
 	struct mmc_csd *csd = &card->csd;
 	unsigned int e, m, csd_struct;
@@ -144,9 +144,10 @@ static int mmc_decode_csd(struct mmc_card *card)
 			mmc_card_set_readonly(card);
 		break;
 	case 1:
+	case 2:
 		/*
-		 * This is a block-addressed SDHC or SDXC card. Most
-		 * interesting fields are unused and have fixed
+		 * This is a block-addressed SDHC, SDXC or SDUC card.
+		 * Most interesting fields are unused and have fixed
 		 * values. To avoid getting tripped by buggy cards,
 		 * we assume those fixed values ourselves.
 		 */
@@ -159,14 +160,19 @@ static int mmc_decode_csd(struct mmc_card *card)
 		e = unstuff_bits(resp, 96, 3);
 		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
 		csd->cmdclass	  = unstuff_bits(resp, 84, 12);
-		csd->c_size	  = unstuff_bits(resp, 48, 22);
 
-		/* SDXC cards have a minimum C_SIZE of 0x00FFFF */
-		if (csd->c_size >= 0xFFFF)
+		if (csd_struct == 1)
+			m = unstuff_bits(resp, 48, 22);
+		else
+			m = unstuff_bits(resp, 48, 28);
+		csd->c_size = m;
+
+		if (csd->c_size >= 0x400000 && is_sduc)
+			mmc_card_set_ult_capacity(card);
+		else if (csd->c_size >= 0xFFFF)
 			mmc_card_set_ext_capacity(card);
 
-		m = unstuff_bits(resp, 48, 22);
-		csd->capacity     = (1 + m) << 10;
+		csd->capacity     = (1 + (typeof(sector_t))m) << 10;
 
 		csd->read_blkbits = 9;
 		csd->read_partial = 0;
@@ -876,7 +882,7 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	return err;
 }
 
-int mmc_sd_get_csd(struct mmc_card *card)
+int mmc_sd_get_csd(struct mmc_card *card, bool is_sduc)
 {
 	int err;
 
@@ -887,7 +893,7 @@ int mmc_sd_get_csd(struct mmc_card *card)
 	if (err)
 		return err;
 
-	err = mmc_decode_csd(card);
+	err = mmc_decode_csd(card, is_sduc);
 	if (err)
 		return err;
 
@@ -1442,7 +1448,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	if (!oldcard) {
-		err = mmc_sd_get_csd(card);
+		err = mmc_sd_get_csd(card, false);
 		if (err)
 			goto free_card;
 
diff --git a/drivers/mmc/core/sd.h b/drivers/mmc/core/sd.h
index fe6dd46927a42..7e8beface2ca6 100644
--- a/drivers/mmc/core/sd.h
+++ b/drivers/mmc/core/sd.h
@@ -10,7 +10,7 @@ struct mmc_host;
 struct mmc_card;
 
 int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr);
-int mmc_sd_get_csd(struct mmc_card *card);
+int mmc_sd_get_csd(struct mmc_card *card, bool is_sduc);
 void mmc_decode_cid(struct mmc_card *card);
 int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 	bool reinit);
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 4fb247fde5c08..9566837c9848e 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -769,7 +769,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	 * Read CSD, before selecting the card
 	 */
 	if (!oldcard && mmc_card_sd_combo(card)) {
-		err = mmc_sd_get_csd(card);
+		err = mmc_sd_get_csd(card, false);
 		if (err)
 			goto remove;
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index f34407cc27888..f39bce3223654 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -35,7 +35,7 @@ struct mmc_csd {
 	unsigned int		wp_grp_size;
 	unsigned int		read_blkbits;
 	unsigned int		write_blkbits;
-	unsigned int		capacity;
+	sector_t		capacity;
 	unsigned int		read_partial:1,
 				read_misalign:1,
 				write_partial:1,
diff --git a/include/linux/mmc/sd.h b/include/linux/mmc/sd.h
index 6727576a87555..865cc0ca8543d 100644
--- a/include/linux/mmc/sd.h
+++ b/include/linux/mmc/sd.h
@@ -36,6 +36,7 @@
 /* OCR bit definitions */
 #define SD_OCR_S18R		(1 << 24)    /* 1.8V switching request */
 #define SD_ROCR_S18A		SD_OCR_S18R  /* 1.8V switching accepted by card */
+#define SD_OCR_2T		(1 << 27)    /* HO2T/CO2T - SDUC support */
 #define SD_OCR_XPC		(1 << 28)    /* SDXC power control */
 #define SD_OCR_CCS		(1 << 30)    /* Card Capacity Status */
 
-- 
2.43.0



