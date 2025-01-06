Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9F7603F;
	Mon,  6 Jan 2025 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177888; cv=none; b=lAWPK8t4hxGS1W/fB1MXJZ1wzWfZaJmkzUxfNDxF42gjqqrHcyx3yTmaWM5v7E79coBY7VFE0NKOoVWcSooY/MOCnRVyqNXiBjQ5NVmIUQX0kuCEVsKLP29Tp1wq3Uf6khSKwgQ1aNnAJhc+rL6YYMeAkWV6wzrHuT1cCZRuOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177888; c=relaxed/simple;
	bh=OZiKYH0qsxACi91MYfHSrvI/atY12vtrKmCPHwPlKAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlHKHDbobbI/D5NoURfgLzXEZ7KbOr0u/TTYkIYHoOLrME5vpidWSk7qNAaeHOks8Y4k+uc/fs29rmvXb2oBhqUgdkR1RIDDzFbKopTQMWhjp8gkRiwewBxvS1l21GROwnN1uPdkf2r2yySTd5vElZwk6HyT9D+Q249R9I6JOgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNDL0+0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNDL0+0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03607C4CED2;
	Mon,  6 Jan 2025 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177888;
	bh=OZiKYH0qsxACi91MYfHSrvI/atY12vtrKmCPHwPlKAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNDL0+0dvwuocLNyEyIigeKdqVx1G61/5Y5OvTOf6x9lZ08IXMnLBFvAvLrQmJVSI
	 WuPvoIAdCScLQbHWglv3SNk5V+xvhMlM52z139NCx2Y9Nw14NTxZwBGnqxi1/6ibw/
	 va8ynM+sjl8UrXIj51JJ/FPPmbYpa3aj4JSnkhfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/156] spi: spi-cadence-qspi: Disable STIG mode for Altera SoCFPGA.
Date: Mon,  6 Jan 2025 16:16:17 +0100
Message-ID: <20250106151145.155415932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

[ Upstream commit 25fb0e77b90e290a1ca30900d54c6a495eea65e2 ]

STIG mode is enabled by default for less than 8 bytes data read/write.
STIG mode doesn't work with Altera SocFPGA platform due hardware
limitation.
Add a quirks to disable STIG mode for Altera SoCFPGA platform.

Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Link: https://patch.msgid.link/20241204063338.296959-1-niravkumar.l.rabara@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 1755ca026f08..73b1edd0531b 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -43,6 +43,7 @@ static_assert(CQSPI_MAX_CHIPSELECT <= SPI_CS_CNT_MAX);
 #define CQSPI_SLOW_SRAM		BIT(4)
 #define CQSPI_NEEDS_APB_AHB_HAZARD_WAR	BIT(5)
 #define CQSPI_RD_NO_IRQ			BIT(6)
+#define CQSPI_DISABLE_STIG_MODE		BIT(7)
 
 /* Capabilities */
 #define CQSPI_SUPPORTS_OCTAL		BIT(0)
@@ -103,6 +104,7 @@ struct cqspi_st {
 	bool			apb_ahb_hazard;
 
 	bool			is_jh7110; /* Flag for StarFive JH7110 SoC */
+	bool			disable_stig_mode;
 
 	const struct cqspi_driver_platdata *ddata;
 };
@@ -1416,7 +1418,8 @@ static int cqspi_mem_process(struct spi_mem *mem, const struct spi_mem_op *op)
 	 * reads, prefer STIG mode for such small reads.
 	 */
 		if (!op->addr.nbytes ||
-		    op->data.nbytes <= CQSPI_STIG_DATA_LEN_MAX)
+		    (op->data.nbytes <= CQSPI_STIG_DATA_LEN_MAX &&
+		     !cqspi->disable_stig_mode))
 			return cqspi_command_read(f_pdata, op);
 
 		return cqspi_read(f_pdata, op);
@@ -1880,6 +1883,8 @@ static int cqspi_probe(struct platform_device *pdev)
 			if (ret)
 				goto probe_reset_failed;
 		}
+		if (ddata->quirks & CQSPI_DISABLE_STIG_MODE)
+			cqspi->disable_stig_mode = true;
 
 		if (of_device_is_compatible(pdev->dev.of_node,
 					    "xlnx,versal-ospi-1.0")) {
@@ -2043,7 +2048,8 @@ static const struct cqspi_driver_platdata intel_lgm_qspi = {
 static const struct cqspi_driver_platdata socfpga_qspi = {
 	.quirks = CQSPI_DISABLE_DAC_MODE
 			| CQSPI_NO_SUPPORT_WR_COMPLETION
-			| CQSPI_SLOW_SRAM,
+			| CQSPI_SLOW_SRAM
+			| CQSPI_DISABLE_STIG_MODE,
 };
 
 static const struct cqspi_driver_platdata versal_ospi = {
-- 
2.39.5



