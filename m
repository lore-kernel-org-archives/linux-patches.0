Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB971258CD3;
	Fri, 30 May 2025 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608820; cv=none; b=NndhjgGvr0tZGyoSzAVxrsYL4amq4qMUayvru8oCg+13vFnJtLHgq5CkwCnTQ0SghrbJZMuNA/DEjMVxK5OcK8KicLOQoEuJeKMjeDpND+/cc7ULMnFswg889h3tmjiDGx5bgK4YHTGaqH0ePoFcs3cml2YJHsQzgnNMQFIQ+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608820; c=relaxed/simple;
	bh=JqCSuh2WkMf9UAgArpAqtSe4jGhwNOvf+oHYM15zWss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+i2dfto2n6/8zxpI7MvYX8HAkA295te5PXmZDhMwrHD0+KbCoxMA3lpkXHhTIwKBq///wNuYBFwFLj7TTP5GLPR7nV5DnPDptx+D8FhwC+liTXwpcQXcX8OsukfE/+bJWdyrbm/+hFfTK9JjOrmzgRXsGJTw9perssU+SKAY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKlTNfjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKlTNfjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C130AC4CEEA;
	Fri, 30 May 2025 12:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608820;
	bh=JqCSuh2WkMf9UAgArpAqtSe4jGhwNOvf+oHYM15zWss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKlTNfjb+4ji+TC5xF8GCBUzaOYdqGRJ93z5OiivtYQ33Ki5S6xSjoc8TbFDimkUw
	 xzoaiC6LcAbEnNY6VOTJ4PdgO40RkUgNDLu2pa2hy1vuI//NzH8AsmwlVi++hRX5XV
	 OUYn5dSpOqLzxv2SdUN/1jjd9p8f11/Ag3RScmyePHr0QmiPViXBEloGon6aiR2nfK
	 pcA1Cl63WJwP7QOPy3+E59b76od0+ZIDngQoXT2gReIfkkDQstvi8AorJ99ipAlzDQ
	 FIyT0Vuh4ez5H8LsJ2u/tP9V4lKk5+wC1tHo2iQjxpqsqiDkoe8EwiZlJgJf3eWnnp
	 ZfSCw9CG9mOZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 06/26] mmc: Add quirk to disable DDR50 tuning
Date: Fri, 30 May 2025 08:39:52 -0400
Message-Id: <20250530124012.2575409-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Bug Fix Classification This is clearly a
**bugfix**, not a new feature. The commit fixes I/O errors that occur on
specific Swissbit SD cards when DDR50 tuning is attempted. The commit
message explicitly states: "This fixes an issue on certain Swissbit SD
cards that do not support DDR50 tuning where tuning requests caused I/O
errors to be thrown." ## Code Change Analysis ### 1. **Minimal and
Targeted Changes** The changes are very focused and follow established
kernel patterns: - **New quirk flag**: `MMC_QUIRK_NO_UHS_DDR50_TUNING
(1<<18)` in `include/linux/mmc/card.h` - **Helper function**:
`mmc_card_no_uhs_ddr50_tuning()` in `drivers/mmc/core/card.h` -
**Specific card targeting**: Only affects Swissbit cards (manufacturer
ID 0x5D) with specific model/date criteria - **Logic refactoring**:
Extracts tuning decision into `mmc_sd_use_tuning()` function ### 2.
**Low Risk Implementation** The implementation uses the existing MMC
quirk infrastructure, which is well-tested: - Follows the same pattern
as Similar Commit #2 (marked YES for backport) - Uses standard
`_FIXUP_EXT()` macro with precise card identification - Only affects the
specific problematic cards, leaving all others unchanged ### 3.
**Controlled Scope** The quirk is highly specific: ```c
_FIXUP_EXT("0016G", CID_MANFID_SWISSBIT, 0x5342, 2019, 1, 0, -1ull,
SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd, MMC_QUIRK_NO_UHS_DDR50_TUNING,
EXT_CSD_REV_ANY), ``` This targets only Swissbit cards with model
"0016G", OEM ID 0x5342, manufactured in January 2019. ## Comparison with
Similar Commits This commit closely matches **Similar Commit #2** (YES
for backport), which also: - Adds quirk handling for specific hardware
issues - Makes minimal, contained changes - Fixes real user-facing
problems - Uses existing infrastructure Unlike **Similar Commit #1** (NO
for backport), this commit: - Fixes an existing bug rather than adding
new functionality - Doesn't introduce new interfaces or capabilities -
Has minimal risk of regression ## User Impact Without this fix, affected
Swissbit SD cards would be **unusable** due to I/O errors during tuning.
This represents a significant hardware compatibility issue that makes
the cards completely non-functional on affected systems. ## Stable Tree
Criteria Compliance ✅ **Important bugfix**: Fixes I/O errors on specific
hardware ✅ **Minimal risk**: Uses established quirk infrastructure ✅
**No architectural changes**: Follows existing patterns ✅ **Contained
scope**: Only affects specific problematic cards ✅ **No new features**:
Pure hardware compatibility fix The commit follows the stable tree rule
that quirks for hardware compatibility issues are generally acceptable
for backporting when they fix real problems with minimal risk.

 drivers/mmc/core/card.h   |  6 ++++++
 drivers/mmc/core/quirks.h | 10 ++++++++++
 drivers/mmc/core/sd.c     | 32 ++++++++++++++++++++++++--------
 include/linux/mmc/card.h  |  1 +
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 3205feb1e8ff6..9cbdd240c3a7d 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -89,6 +89,7 @@ struct mmc_fixup {
 #define CID_MANFID_MICRON       0x13
 #define CID_MANFID_SAMSUNG      0x15
 #define CID_MANFID_APACER       0x27
+#define CID_MANFID_SWISSBIT     0x5D
 #define CID_MANFID_KINGSTON     0x70
 #define CID_MANFID_HYNIX	0x90
 #define CID_MANFID_KINGSTON_SD	0x9F
@@ -294,4 +295,9 @@ static inline int mmc_card_broken_sd_poweroff_notify(const struct mmc_card *c)
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
index 63915541c0e49..916ae9996e9d7 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -613,6 +613,29 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
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
@@ -656,14 +679,7 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
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
index eb67d3d5ff5b2..2e455b20c37c2 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -295,6 +295,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_SD_CACHE	(1<<15)	/* Disable broken SD cache support */
 #define MMC_QUIRK_BROKEN_CACHE_FLUSH	(1<<16)	/* Don't flush cache until the write has occurred */
 #define MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY	(1<<17) /* Disable broken SD poweroff notify support */
+#define MMC_QUIRK_NO_UHS_DDR50_TUNING	(1<<18) /* Disable DDR50 tuning */
 
 	bool			written_flag;	/* Indicates eMMC has been written since power on */
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
-- 
2.39.5

