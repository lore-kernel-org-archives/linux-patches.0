Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383BC22F1B
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvnjUW3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30DBC433C8;
	Mon,  6 Nov 2023 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277454;
	bh=GN2yaOJ252AZllo9ZyRLBQq4SWBYypjvnuO70ZZuGOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvnjUW3u9GWZV0KuM1FS4KRJAf4Vm2GzPHpeTI5vPDSVOUVFqWPw69jxwfRUFyAvQ
	 4bOhpor4jVmhME8aCFBcMq+1Po60G0HOvEAHdQKcm4OiZySIyCuUmOlNDwXT7Bj1g8
	 FQZWTLll0t05J3MWOzSOYugJAOygdo6mEi18d6Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.10 07/95] mmc: renesas_sdhi: use custom mask for TMIO_MASK_ALL
Date: Mon,  6 Nov 2023 14:03:35 +0100
Message-ID: <20231106130304.963166478@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 9f12cac1bb88e3296990e760d867a98308d6b0ac upstream.

Populate the new member for custom mask values to make sure this value
is applied whenever needed. Also, rename the define holding the value
because this is not only about initialization anymore.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210304092903.8534-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[geert: Backport to v5.10.199]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |    3 ++-
 drivers/mmc/host/tmio_mmc.h          |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -571,7 +571,7 @@ static void renesas_sdhi_reset(struct tm
 
 	if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
 		sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK,
-					     TMIO_MASK_INIT_RCAR2);
+					     TMIO_MASK_ALL_RCAR2);
 }
 
 #define SH_MOBILE_SDHI_MIN_TAP_ROW 3
@@ -1012,6 +1012,7 @@ int renesas_sdhi_probe(struct platform_d
 		host->ops.start_signal_voltage_switch =
 			renesas_sdhi_start_signal_voltage_switch;
 		host->sdcard_irq_setbit_mask = TMIO_STAT_ALWAYS_SET_27;
+		host->sdcard_irq_mask_all = TMIO_MASK_ALL_RCAR2;
 		host->reset = renesas_sdhi_reset;
 	} else {
 		host->sdcard_irq_mask_all = TMIO_MASK_ALL;
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -97,8 +97,8 @@
 
 /* Define some IRQ masks */
 /* This is the mask used at reset by the chip */
-#define TMIO_MASK_INIT_RCAR2	0x8b7f031d /* Initial value for R-Car Gen2+ */
 #define TMIO_MASK_ALL           0x837f031d
+#define TMIO_MASK_ALL_RCAR2	0x8b7f031d
 #define TMIO_MASK_READOP  (TMIO_STAT_RXRDY | TMIO_STAT_DATAEND)
 #define TMIO_MASK_WRITEOP (TMIO_STAT_TXRQ | TMIO_STAT_DATAEND)
 #define TMIO_MASK_CMD     (TMIO_STAT_CMDRESPEND | TMIO_STAT_CMDTIMEOUT | \


