Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6ED199948;
	Tue, 10 Sep 2024 10:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963976; cv=none; b=cOlxUT86cK5xFbrK2AUnQ/wHTrZPkkEk37s1kKvyWs1QaYtD/hJHjU3zUks7Ugvfaa4sLO/8G3/zXIPPb3cSrRekGgPs/jnANj6Z8SH+3EgnAJZyZWT5qLX43UtoojBW+rIx23U4qeGwKteV5Shx8Q4UY6UfFxvDJOIId7cW0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963976; c=relaxed/simple;
	bh=aOgLVERwtbzLLDYoR3tH01XYcfAqc5f8PrZr9EKazGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flX+OrV/GIM+Q2nKDGoTcJQzUANFNgVRBu6l+HVMFHKfATu1o8RyjtXzK6khSjWBtUiTH4ppjoy380pGguAS/pr0tJHWFFt+OjzuRhINA50DWBxgfyAd5A3NxmBg3JPHvmS8Ly+JCT+sCC4xfN3uncJTzJeaaiWHCOdSuSrYCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umg6N4BX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umg6N4BX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E27C4CEC3;
	Tue, 10 Sep 2024 10:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963976;
	bh=aOgLVERwtbzLLDYoR3tH01XYcfAqc5f8PrZr9EKazGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umg6N4BXxjfpUVmz1W5VCiI4+Se2g4opRXGEU/NRlKl8TtjpnZEcBSQvhmILPD48d
	 rlWruH8dbbjBvpGNfb5gaN1+3WjGgK+MYscQIUnG0EfZ6VXgqfVKigmx/HdDaHc2iS
	 sFKDrzi1cvyLooHmHMe7cFVrgBQMtppX9AnE+WmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Bell <jonathan@raspberrypi.com>,
	Keita Aihara <keita.aihara@sony.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 025/269] mmc: core: apply SD quirks earlier during probe
Date: Tue, 10 Sep 2024 11:30:12 +0200
Message-ID: <20240910092609.141293810@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Bell <jonathan@raspberrypi.com>

commit 469e5e4713989fdd5e3e502b922e7be0da2464b9 upstream.

Applying MMC_QUIRK_BROKEN_SD_CACHE is broken, as the card's SD quirks are
referenced in sd_parse_ext_reg_perf() prior to the quirks being initialized
in mmc_blk_probe().

To fix this problem, let's split out an SD-specific list of quirks and
apply in mmc_sd_init_card() instead. In this way, sd_read_ext_regs() to has
the available information for not assigning the SD_EXT_PERF_CACHE as one of
the (un)supported features, which in turn allows mmc_sd_init_card() to
properly skip execution of sd_enable_cache().

Fixes: c467c8f08185 ("mmc: Add MMC_QUIRK_BROKEN_SD_CACHE for Kingston Canvas Go Plus from 11/2019")
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.com>
Co-developed-by: Keita Aihara <keita.aihara@sony.com>
Signed-off-by: Keita Aihara <keita.aihara@sony.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240820230631.GA436523@sony.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/quirks.h |   22 +++++++++++++---------
 drivers/mmc/core/sd.c     |    4 ++++
 2 files changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -15,6 +15,19 @@
 
 #include "card.h"
 
+static const struct mmc_fixup __maybe_unused mmc_sd_fixups[] = {
+	/*
+	 * Kingston Canvas Go! Plus microSD cards never finish SD cache flush.
+	 * This has so far only been observed on cards from 11/2019, while new
+	 * cards from 2023/05 do not exhibit this behavior.
+	 */
+	_FIXUP_EXT("SD64G", CID_MANFID_KINGSTON_SD, 0x5449, 2019, 11,
+		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
+		   MMC_QUIRK_BROKEN_SD_CACHE, EXT_CSD_REV_ANY),
+
+	END_FIXUP
+};
+
 static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 #define INAND_CMD38_ARG_EXT_CSD  113
 #define INAND_CMD38_ARG_ERASE    0x00
@@ -54,15 +67,6 @@ static const struct mmc_fixup __maybe_un
 		  MMC_QUIRK_BLK_NO_CMD23),
 
 	/*
-	 * Kingston Canvas Go! Plus microSD cards never finish SD cache flush.
-	 * This has so far only been observed on cards from 11/2019, while new
-	 * cards from 2023/05 do not exhibit this behavior.
-	 */
-	_FIXUP_EXT("SD64G", CID_MANFID_KINGSTON_SD, 0x5449, 2019, 11,
-		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
-		   MMC_QUIRK_BROKEN_SD_CACHE, EXT_CSD_REV_ANY),
-
-	/*
 	 * Some SD cards lockup while using CMD23 multiblock transfers.
 	 */
 	MMC_FIXUP("AF SD", CID_MANFID_ATP, CID_OEMID_ANY, add_quirk_sd,
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -26,6 +26,7 @@
 #include "host.h"
 #include "bus.h"
 #include "mmc_ops.h"
+#include "quirks.h"
 #include "sd.h"
 #include "sd_ops.h"
 
@@ -1475,6 +1476,9 @@ retry:
 			goto free_card;
 	}
 
+	/* Apply quirks prior to card setup */
+	mmc_fixup_device(card, mmc_sd_fixups);
+
 	err = mmc_sd_setup_card(host, card, oldcard != NULL);
 	if (err)
 		goto free_card;


