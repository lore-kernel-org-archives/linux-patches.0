Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C930D1F12F4;
	Sun,  7 Sep 2025 20:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277905; cv=none; b=iIX3992f9NMlSmpP/79KgkccPhzB0EzCwp5ByGzNLzFLkOK8bY+5IIWsCxpP+pbxIWwYzOs53+M7IvtKuR0Ak0ZifLm7LVZmmE/Rl2Y72Zj7pwoOS/r+YlI414wUJ63GoSZ8xYsEf2MBKeGUrt4KtkAAiKFbQHOghU4Gk8cowKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277905; c=relaxed/simple;
	bh=HKNHuKkaXqP12AC+Zk6SeDTurOFFc+gMdvzASl5Bem0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayQnMLN9YM7gLupgJ5MxVvfax30b8ipJPhVTKQvVKHznGiW6sGeYTq6iBXk5KQ2CZJM5dVHsf9iX6CzG0yeeXx1coFwRDL0DqynAfM/F6jAaczJQs63829uAoN731pGMRzItQWaXBOXa+qToqzd2d2AvpmdWS0YqZLp2fzLwNBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvwShaK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvwShaK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A554C4CEF0;
	Sun,  7 Sep 2025 20:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277905;
	bh=HKNHuKkaXqP12AC+Zk6SeDTurOFFc+gMdvzASl5Bem0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvwShaK23Qgb3/bhfSWmF+PY9pTrEScNgqdyIRcB8h0LGBmoKM/UuNCuj6uz39PVO
	 ccwEjGCtmASQZZPvKaPoUSApa2x/qqYVgGcBYpgqsvP8LaNURtse2qiL0XtSLnbDis
	 LZ4DCZ5VPQIOVoloMi2azuFiw+eULLtMIas/eceY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 158/183] spi: spi-fsl-lpspi: Set correct chip-select polarity bit
Date: Sun,  7 Sep 2025 21:59:45 +0200
Message-ID: <20250907195619.571568970@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit cbe33705864ba2697a2939de715b81538cf32430 ]

The driver currently supports multiple chip-selects, but only sets the
polarity for the first one (CS 0). Fix it by setting the PCSPOL bit for
the desired chip-select.

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-2-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index fbe58cbf33864..55570c814dcdd 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -5,6 +5,7 @@
 // Copyright 2016 Freescale Semiconductor, Inc.
 // Copyright 2018, 2023, 2025 NXP
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -70,7 +71,7 @@
 #define DER_TDDE	BIT(0)
 #define CFGR1_PCSCFG	BIT(27)
 #define CFGR1_PINCFG	(BIT(24)|BIT(25))
-#define CFGR1_PCSPOL	BIT(8)
+#define CFGR1_PCSPOL_MASK	GENMASK(11, 8)
 #define CFGR1_NOSTALL	BIT(3)
 #define CFGR1_HOST	BIT(0)
 #define FSR_TXCOUNT	(0xFF)
@@ -424,7 +425,9 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
 	else
 		temp = CFGR1_PINCFG;
 	if (fsl_lpspi->config.mode & SPI_CS_HIGH)
-		temp |= CFGR1_PCSPOL;
+		temp |= FIELD_PREP(CFGR1_PCSPOL_MASK,
+				   BIT(fsl_lpspi->config.chip_select));
+
 	writel(temp, fsl_lpspi->base + IMX7ULP_CFGR1);
 
 	temp = readl(fsl_lpspi->base + IMX7ULP_CR);
-- 
2.51.0



