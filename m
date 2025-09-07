Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94236126C02;
	Sun,  7 Sep 2025 20:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277912; cv=none; b=NuXNcX72c9F58JiuUttN/7V0sMURhOcQ83Npzgar5/4ofR9tdrNJyH3xA5DX8Egq7vxBdt3s1yN5+m6/np0nNDbeSlihJo2nbS0DYQ6TdttUDjAtiFJqdCAEarZ9sQ5nglfS7F8d99RyF4PCpEnOoVj64RAMq5BK6mACH4O0Vnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277912; c=relaxed/simple;
	bh=gpPZDyT2bdK4CucfAvWIim1V2WPRvIlUa/EIKmovuwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0l1G94B+ZhWkfrv04V/HgAGx4P7uISZJcSpGqaoWPgyf223IVKkpliaqqe0IYVI9SMzKTxl9Ir8WZ0VU2bdMiVxlAh1XUJwBfm10ZiTEJZPGSNwpjrFlXrrIrs7BPGiCDUsZQWLpmLTZRXy/Fgk8XsHCC/GUME8B+fPo1PcNC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQw0eZN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQw0eZN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F3DC4CEF0;
	Sun,  7 Sep 2025 20:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277912;
	bh=gpPZDyT2bdK4CucfAvWIim1V2WPRvIlUa/EIKmovuwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQw0eZN0aEoRMQ+v1gv2UyVuT94Vod9gnYlwpu/sHmHeDM4GAb5Yx8LkcfVPJ0QST
	 bVqwzvwsvAHT00UMgr6cQ7mX82y6TdfLAPUL3rAZEez++5B5B/jNW4yKAS3w+gS7SX
	 vkn2mnaaILo5wlnkCBTo5LFha98TbNohTaNOW1f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	Ciprian Marian Costea <ciprianmarian.costea@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 160/183] spi: spi-fsl-lpspi: Clear status register after disabling the module
Date: Sun,  7 Sep 2025 21:59:47 +0200
Message-ID: <20250907195619.619697371@linuxfoundation.org>
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

[ Upstream commit dedf9c93dece441e9a0a4836458bc93677008ddd ]

Clear the error flags after disabling the module to avoid the case when
a flag is set again between flag clear and module disable. And use
SR_CLEAR_MASK to replace hardcoded value for improved readability.

Although fsl_lpspi_reset() was only introduced in commit a15dc3d657fa
("spi: lpspi: Fix CLK pin becomes low before one transfer"), the
original driver only reset SR in the interrupt handler, making it
vulnerable to the same issue. Therefore the fixes commit is set at the
introduction of the driver.

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: Ciprian Marian Costea <ciprianmarian.costea@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-4-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 0bb25b473271c..90e4028ca14fc 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -83,6 +83,8 @@
 #define TCR_RXMSK	BIT(19)
 #define TCR_TXMSK	BIT(18)
 
+#define SR_CLEAR_MASK	GENMASK(13, 8)
+
 struct fsl_lpspi_devtype_data {
 	u8 prescale_max;
 };
@@ -536,14 +538,13 @@ static int fsl_lpspi_reset(struct fsl_lpspi_data *fsl_lpspi)
 		fsl_lpspi_intctrl(fsl_lpspi, 0);
 	}
 
-	/* W1C for all flags in SR */
-	temp = 0x3F << 8;
-	writel(temp, fsl_lpspi->base + IMX7ULP_SR);
-
 	/* Clear FIFO and disable module */
 	temp = CR_RRF | CR_RTF;
 	writel(temp, fsl_lpspi->base + IMX7ULP_CR);
 
+	/* W1C for all flags in SR */
+	writel(SR_CLEAR_MASK, fsl_lpspi->base + IMX7ULP_SR);
+
 	return 0;
 }
 
-- 
2.51.0



