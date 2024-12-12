Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34CC2185A8;
	Thu, 12 Dec 2024 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018200; cv=none; b=Mh979I6ovJjzTDZ6aHrEqZ/u3qg6290O6ZqTNXjpe8jjyce0fWJiYCvXsJEh10858lbO3abve45nsYXJIyPqgH6PQimfCvf6wFWIP9EZmT9L/6kp1KGaIZbbwhgStKjNIq9XnZNWpj+arfnaBm+QsulA+6I0UiKQkCssflbEHqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018200; c=relaxed/simple;
	bh=LdLm1OfITKhkodrSSeYJ72j1Hv20X3s3gPoG+UUePpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WevfzUvdjUuPUlezF/ARtaTIujr8X5pgTCYj0pWnx5qB+1YPc/yjY9F9W9Zb+RryKOD9tqT2Mcorv0j29JVV2VPiO5/RnhXaZkU+07XhkMw/lnYQongDGA7taRfAkZqb4f73vsUEkPDLKRPl/NHqrOpW5V34gxOy59Nk5fVePfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaGuauF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaGuauF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416C3C4CECE;
	Thu, 12 Dec 2024 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018200;
	bh=LdLm1OfITKhkodrSSeYJ72j1Hv20X3s3gPoG+UUePpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaGuauF52xYWQ4YEAdjYSL57ZPlDj0viLFagTUpwI6uig8NXolP3i90WqmLODSP2y
	 1k/HNloiXTFvIO9gDbbbplhAH8IPGEg4c26LUfKTGoXBYj3NQ+2XBZtnyhT9/Oln+/
	 sKo3qSnnxsr7FxMzgD1kXuVccf1s24q9LF5IQq5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/356] spi: spi-fsl-lpspi: Adjust type of scldiv
Date: Thu, 12 Dec 2024 15:58:34 +0100
Message-ID: <20241212144252.329932320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit fa8ecda9876ac1e7b29257aa82af1fd0695496e2 ]

The target value of scldiv is just a byte, but its calculation in
fsl_lpspi_set_bitrate could be negative. So use an adequate type to store
the result and avoid overflows. After that this needs range check
adjustments, but this should make the code less opaque.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240930093056.93418-2-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 514a2c5c84226..9e2541dee56e5 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -315,9 +315,10 @@ static void fsl_lpspi_set_watermark(struct fsl_lpspi_data *fsl_lpspi)
 static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
-	unsigned int perclk_rate, scldiv, div;
+	unsigned int perclk_rate, div;
 	u8 prescale_max;
 	u8 prescale;
+	int scldiv;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
 	prescale_max = fsl_lpspi->devtype_data->prescale_max;
@@ -338,13 +339,13 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 
 	for (prescale = 0; prescale <= prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
-		if (scldiv < 256) {
+		if (scldiv >= 0 && scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;
 			break;
 		}
 	}
 
-	if (scldiv >= 256)
+	if (scldiv < 0 || scldiv >= 256)
 		return -EINVAL;
 
 	writel(scldiv | (scldiv << 8) | ((scldiv >> 1) << 16),
-- 
2.43.0



