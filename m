Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4569B1714AE;
	Thu, 15 Aug 2024 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728971; cv=none; b=nVUNpnVJrJOSaYg3biZsYRx379+ZXymRVXP8sJhZB3IT21Nq+Uw7JDh5iP9/CmRojVJKBc4tQlW7iryhNUSAjoBrq/c1H+Aoi796qb9JBkiWcPAfrshEFEp8uekV4Y37kQdFmjl40IwAB1g7ew5bgpxaQh/0wMvE4hhZR5tgULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728971; c=relaxed/simple;
	bh=s0CMQjUiaJ+GfRkv2/1QIHH4SxmvwpSiz/bM9XqjxJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvPHPcU2liJFzdMVF1UH3DUNZLi51R+NHmwnSFcqCACmPMjPv0VA3CZ/k/jjFIfXm8byh39Ty+DM27vMS1dkgQ7QPp+rlfBPQPZgpTF0FfQVTol0Pyg4HFli0xdjo8N7ZltFOBrRvEB071dD3XYP10uVyCt5uSim8wEYhayS0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aasf5l2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aasf5l2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3112C32786;
	Thu, 15 Aug 2024 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728971;
	bh=s0CMQjUiaJ+GfRkv2/1QIHH4SxmvwpSiz/bM9XqjxJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aasf5l2AKJDlMBKYrUs+so8ulsIMm1yXQPJPtDc2/NH8qcr14jir/RDV9rlwQy4Xk
	 qjqSOskvrj+WrkqkE6jCNSdOzLMJEtosn64xPRmO5SN+4LFXqDhVom4zb3XVgKJTH7
	 O0LiScUAIUM7f8hcWtzGeneE4dBVCwyLKpeKUkAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/196] spi: lpspi: add the error info of transfer speed setting
Date: Thu, 15 Aug 2024 15:24:46 +0200
Message-ID: <20240815131858.537741172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 77736a98b859e2c64aebbd0f90b2ce4b17682396 ]

Add a error info when set a speed which greater than half of per-clk of
spi module.

The minimum SCK period is 2 cycles(CCR[SCKDIV]). So the maximum transfer
speed is half of spi per-clk.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 730bbfaf7d48 ("spi: spi-fsl-lpspi: Fix scldiv calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 5802f188051b8..8e1f6ee0a7993 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -263,6 +263,13 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	u8 prescale;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
+
+	if (config.speed_hz > perclk_rate / 2) {
+		dev_err(fsl_lpspi->dev,
+		      "per-clk should be at least two times of transfer speed");
+		return -EINVAL;
+	}
+
 	for (prescale = 0; prescale < 8; prescale++) {
 		scldiv = perclk_rate /
 			 (clkdivs[prescale] * config.speed_hz) - 2;
@@ -316,7 +323,7 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
 	return 0;
 }
 
-static void fsl_lpspi_setup_transfer(struct spi_device *spi,
+static int fsl_lpspi_setup_transfer(struct spi_device *spi,
 				     struct spi_transfer *t)
 {
 	struct fsl_lpspi_data *fsl_lpspi =
@@ -349,7 +356,7 @@ static void fsl_lpspi_setup_transfer(struct spi_device *spi,
 	else
 		fsl_lpspi->watermark = fsl_lpspi->txfifosize;
 
-	fsl_lpspi_config(fsl_lpspi);
+	return fsl_lpspi_config(fsl_lpspi);
 }
 
 static int fsl_lpspi_slave_abort(struct spi_controller *controller)
@@ -428,7 +435,10 @@ static int fsl_lpspi_transfer_one_msg(struct spi_controller *controller,
 	msg->actual_length = 0;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		fsl_lpspi_setup_transfer(spi, xfer);
+		ret = fsl_lpspi_setup_transfer(spi, xfer);
+		if (ret < 0)
+			goto complete;
+
 		fsl_lpspi_set_cmd(fsl_lpspi, is_first_xfer);
 
 		is_first_xfer = false;
-- 
2.43.0



