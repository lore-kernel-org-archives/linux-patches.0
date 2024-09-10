Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F818FDDC;
	Tue, 10 Sep 2024 09:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961329; cv=none; b=iVIAf4sVM4sslTdBM+pUTuucV3e33C2gGfnVR0NyJ8b1j4AEbNipoA5s8z5uVRGvEv4s2XV8dY9xDvRcadCGkMZzAINU0CMCGUKSOzSK2+kmhxIEBzhl1R+O4z775V8od8qwlPmEvmol6f/HDfU7oht9zw8YYkcCGHfrCN2f+jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961329; c=relaxed/simple;
	bh=DCKAYerc7HoR7FY3T/EKwGc2YC/5MCcXH0HBsl+BIEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA+MUX3oke65c+UhErOhMQWKBOt/o+7PA403rFhlPjdJ/A7PJ58XfbHoPqHqQkkpikYgfxkZSo9obaJ22QrSBY+rI4ta1UKIL8mx/JnzltWfSTGZ7zLTc0CNTEbbt9je5MVsuQGm/iYUg0rzjwHOA3JWc4opSOlcydWUMbr1pUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHWgEZvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHWgEZvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A04C4CECC;
	Tue, 10 Sep 2024 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961329;
	bh=DCKAYerc7HoR7FY3T/EKwGc2YC/5MCcXH0HBsl+BIEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHWgEZvY2/BrjQAnCB0wMeXrJL390FWo+tMO1V2RJOz7/XR74qrpeZH5cPM89WvIu
	 VELoiCwyRIyREcJ9rqf2IWwb1mvqJ3b5R+WfiM96e7ZeM8YKkPGRqrjas3SKrdSVeX
	 MflwQwIbz0ldJ97CV/shbwJ1/EL4ev/F0/r/2low=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Bell <jonathan@raspberrypi.com>,
	Keita Aihara <keita.aihara@sony.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 033/375] mmc: core: apply SD quirks earlier during probe
Date: Tue, 10 Sep 2024 11:27:10 +0200
Message-ID: <20240910092623.348710723@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


