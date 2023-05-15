Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B1C8E3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA19AC433D2;
	Mon, 15 May 2023 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173677;
	bh=JvunV0I2SGxCgkrjijXWkeVwiEGWlSHq6au3OmwcdpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16U/VQnzLWeBexdsP0Utm7BBvj4EOJQqfthF6jRs7bRUP7jGfT+j4THokHjeI+3lw
	 +vv/kaZu4D1Mn0kVngAx/FnOdrvCKf9U6TuXrggm1mt+oP2SKXTWQcOJX9YgVZsCaL
	 Mb0gL/nri2jrc+cGJeYD/CpOBon+T2WbbiyhWkeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/282] mtd: spi-nor: cadence-quadspi: Provide a way to disable DAC mode
Date: Mon, 15 May 2023 18:28:39 +0200
Message-Id: <20230515161726.449122108@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit a99705079a91e6373122bd0ca2fc129b688fc5b3 ]

Currently direct access mode is used on platforms that have AHB window
(memory mapped window) larger than flash size. This feature is limited
to TI platforms as non TI platforms have < 1MB of AHB window.
Therefore introduce a driver quirk to disable DAC mode and set it for
non TI compatibles. This is in preparation to move to spi-mem framework
where flash geometry cannot be known.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20200601070444.16923-3-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2087e85bb66e ("spi: cadence-quadspi: fix suspend-resume implementations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
index d680e4a272a13..7e7736bbbfb3b 100644
--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -34,6 +34,7 @@
 
 /* Quirks */
 #define CQSPI_NEEDS_WR_DELAY		BIT(0)
+#define CQSPI_DISABLE_DAC_MODE		BIT(1)
 
 /* Capabilities mask */
 #define CQSPI_BASE_HWCAPS_MASK					\
@@ -1257,7 +1258,8 @@ static int cqspi_setup_flash(struct cqspi_st *cqspi, struct device_node *np)
 
 		f_pdata->registered = true;
 
-		if (mtd->size <= cqspi->ahb_size) {
+		if (mtd->size <= cqspi->ahb_size &&
+		    !(ddata->quirks & CQSPI_DISABLE_DAC_MODE)) {
 			f_pdata->use_direct_mode = true;
 			dev_dbg(nor->dev, "using direct mode for %s\n",
 				mtd->name);
@@ -1455,6 +1457,7 @@ static const struct dev_pm_ops cqspi__dev_pm_ops = {
 
 static const struct cqspi_driver_platdata cdns_qspi = {
 	.hwcaps_mask = CQSPI_BASE_HWCAPS_MASK,
+	.quirks = CQSPI_DISABLE_DAC_MODE,
 };
 
 static const struct cqspi_driver_platdata k2g_qspi = {
-- 
2.39.2



