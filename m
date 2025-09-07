Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53081CDFAC;
	Sun,  7 Sep 2025 20:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275892; cv=none; b=nmKVCTQggOZBCx7+a+DrjAdRhNjFJLU0Sg93g7TsbSJtYZrAfPjXxAHUsO3B5piRXBhkQJEbDurICboh4bVFBWc9c3+IfX8NjDwskzxo3V7Z6b6dsT3cEP3SvoUYRe3+IXM9squXca6WJfPCXA/k88YxdPQ45/L59URKc5JK+kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275892; c=relaxed/simple;
	bh=W4G2qHiwIE3OcY509rGB12qKRRy9tF1fbUZ8VjoHquY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEwbKM0DiiW0DruyjJt0DdGl4qaKuH5UZnZuax9d7QuVEVOWMCGtatD2eaJTykufkc3ah5WKxFGfb0nwzhlkKkzv6AVu0ADpJ3aQq1rT9ZgkWI8QyPHmWrL1uLhPUcX0ZmPNyg2Xch7UXwe/NXo3GMitnVml5QVVasz+Vg9Eb9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1DzS0PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1DzS0PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465BCC4CEF0;
	Sun,  7 Sep 2025 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275892;
	bh=W4G2qHiwIE3OcY509rGB12qKRRy9tF1fbUZ8VjoHquY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1DzS0PU+rEu5GASA33AeSRZOpHvJ4Lqc25EEwGH3b1gAcm77+8RTExGa/nzymfZj
	 irskhHW4H8VRFiCMYpuplXv9ToqARrbMZAfTAFZk0hbDrAiR2W66I5Hthwh4Mp+5eJ
	 ZqQH/vxH/3KYbuHa7KGP6sVktjwe861r+jEsWiQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/45] spi: spi-fsl-lpspi: Set correct chip-select polarity bit
Date: Sun,  7 Sep 2025 21:58:28 +0200
Message-ID: <20250907195602.228467919@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8a4925469dfb9..6cabad2923aec 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -5,6 +5,7 @@
 // Copyright 2016 Freescale Semiconductor, Inc.
 // Copyright 2018, 2023, 2025 NXP
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -74,7 +75,7 @@
 #define DER_TDDE	BIT(0)
 #define CFGR1_PCSCFG	BIT(27)
 #define CFGR1_PINCFG	(BIT(24)|BIT(25))
-#define CFGR1_PCSPOL	BIT(8)
+#define CFGR1_PCSPOL_MASK	GENMASK(11, 8)
 #define CFGR1_NOSTALL	BIT(3)
 #define CFGR1_MASTER	BIT(0)
 #define FSR_TXCOUNT	(0xFF)
@@ -415,7 +416,9 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
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



