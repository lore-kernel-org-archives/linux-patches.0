Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C76F14A622;
	Tue, 25 Jun 2024 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309317; cv=none; b=i7+c/2phbREVm/r6fq1RQpflVk0dDUCvWpXcJV9meRIOF8QopHOFdIkSPfQWve1CYJjLnSEPE4awj7pQt1ojtlWqCFUUClQ0z6QcZDvxaYPQ3DwMVCvRbKjfOWxPDq6A8BiGmzdPI6LXazCH28L/K8Ou5n5MHRamwCvrGcHLkVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309317; c=relaxed/simple;
	bh=bcFZDsoLmIRZH3fg1SC889xtlVVpN1WHJu6+g+xIzlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY0Jwb408Mz+wR0TZ8rgiOfNiIGStWkr1iTH8VGCZZblYwUU0TSlF0RJb48rl/JjTaNyTgf4Kl5WPkU0bOC1auMbegvlOQTtHRfRLMAipMyubYX8e+z83c39a2oSAdceRX6jBCOlcz5olVTWP5STXp/OsCLlpGBRM/r2arfbvc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYR29uB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYR29uB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210AAC4AF0A;
	Tue, 25 Jun 2024 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309317;
	bh=bcFZDsoLmIRZH3fg1SC889xtlVVpN1WHJu6+g+xIzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYR29uB2W/mM7A1YobNqT4lTzZMMN3awvjOjlbORCW4swqFZ1dhfFvzjKmsNe4qTO
	 pMzckzqeKliuWQUgCOhXOzIiYsq15KLpboLYrUYd+3GpcWxFPZOBraB4K6Eahufq2E
	 Y93CGx1PTLKUd8vyvXTnaoUeWQICdvAsgQD9NODA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 168/192] spi: stm32: qspi: Fix dual flash mode sanity test in stm32_qspi_setup()
Date: Tue, 25 Jun 2024 11:34:00 +0200
Message-ID: <20240625085543.609459401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit c2bd0791c5f02e964402624dfff45ca8995f5397 upstream.

Misplaced parenthesis make test of mode wrong in case mode is equal to
SPI_TX_OCTAL or SPI_RX_OCTAL.

Simplify this sanity test, if one of this bit is set, property
cs-gpio must be present in DT.

Fixes: a557fca630cc ("spi: stm32_qspi: Add transfer_one_message() spi callback")
Cc: stable@vger.kernel.org
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://msgid.link/r/20240618132951.2743935-2-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -653,9 +653,7 @@ static int stm32_qspi_setup(struct spi_d
 		return -EINVAL;
 
 	mode = spi->mode & (SPI_TX_OCTAL | SPI_RX_OCTAL);
-	if ((mode == SPI_TX_OCTAL || mode == SPI_RX_OCTAL) ||
-	    ((mode == (SPI_TX_OCTAL | SPI_RX_OCTAL)) &&
-	    gpiod_count(qspi->dev, "cs") == -ENOENT)) {
+	if (mode && gpiod_count(qspi->dev, "cs") == -ENOENT) {
 		dev_err(qspi->dev, "spi-rx-bus-width\\/spi-tx-bus-width\\/cs-gpios\n");
 		dev_err(qspi->dev, "configuration not supported\n");
 
@@ -676,10 +674,10 @@ static int stm32_qspi_setup(struct spi_d
 	qspi->cr_reg = CR_APMS | 3 << CR_FTHRES_SHIFT | CR_SSHIFT | CR_EN;
 
 	/*
-	 * Dual flash mode is only enable in case SPI_TX_OCTAL and SPI_TX_OCTAL
-	 * are both set in spi->mode and "cs-gpios" properties is found in DT
+	 * Dual flash mode is only enable in case SPI_TX_OCTAL or SPI_RX_OCTAL
+	 * is set in spi->mode and "cs-gpios" properties is found in DT
 	 */
-	if (mode == (SPI_TX_OCTAL | SPI_RX_OCTAL)) {
+	if (mode) {
 		qspi->cr_reg |= CR_DFM;
 		dev_dbg(qspi->dev, "Dual flash mode enable");
 	}


