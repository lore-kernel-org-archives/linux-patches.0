Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C991714AE;
	Thu, 15 Aug 2024 13:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728965; cv=none; b=XmKxT2bjqoDEleITg3E3Xogz5deeOB3UwOlvacXf6iLXnCfVRAB/gaPlhxBWGGlrFKQVEZdkjl7Ouvx/vBUUZZdyEl8OQNpQmVAKQF0lyXz5e5umVcSyWuhpJoXiNXNgpwA+KqTLDmKH0yhlbKSYjUfKUUY0wF2JKgE3IcXAQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728965; c=relaxed/simple;
	bh=lwQunaQb4HiyWSOQl6pzj9i1rPmpcD3bsp/mQOE8ySk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsWZCQ6BOozG/7aKiJOwklHuygwwiTzpPuYcBypn/vXKvSp5vaz2K402Fr6Loq0R8/JHeRGODk3K7WUFHTquiXCAipl54HxiP3BybpEVT8sRQP/k2s1F+0+E3m+lqEcpE/xlnZ+AxJTtZX8E5GpZERyRdy9p3SIAZ58uxHMo8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmVhCVIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmVhCVIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51F1C4AF0A;
	Thu, 15 Aug 2024 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728965;
	bh=lwQunaQb4HiyWSOQl6pzj9i1rPmpcD3bsp/mQOE8ySk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmVhCVIevbmPDrRyqrkDghbgsbLHipIvcN2D+PkCd1UU9wQ4vw/ZMy3SQ4m/EzC+5
	 YgOy1TzIXc3+OXyEZZN7X4asBwZQX100DmYW2Aa6TRWqoYZ7u2EqDIIwTXozrAi7o7
	 u7MHFUrMiB5Ubs28RVRFiNbk2edTVDdro+OfZj1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/196] spi: lpspi: Let watermark change with send data length
Date: Thu, 15 Aug 2024 15:24:44 +0200
Message-ID: <20240815131858.462580237@linuxfoundation.org>
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

[ Upstream commit cf86874bb9bdb99ba3620428b59b0408fbc703d0 ]

Configure watermark to change with the length of the sent data.
Support LPSPI sending message shorter than tx/rxfifosize.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 730bbfaf7d48 ("spi: spi-fsl-lpspi: Fix scldiv calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index cbf165e7bd17b..08dcc3c22e883 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -89,6 +89,7 @@ struct fsl_lpspi_data {
 	void (*rx)(struct fsl_lpspi_data *);
 
 	u32 remain;
+	u8 watermark;
 	u8 txfifosize;
 	u8 rxfifosize;
 
@@ -235,7 +236,7 @@ static void fsl_lpspi_set_watermark(struct fsl_lpspi_data *fsl_lpspi)
 {
 	u32 temp;
 
-	temp = fsl_lpspi->txfifosize >> 1 | (fsl_lpspi->rxfifosize >> 1) << 16;
+	temp = fsl_lpspi->watermark >> 1 | (fsl_lpspi->watermark >> 1) << 16;
 
 	writel(temp, fsl_lpspi->base + IMX7ULP_FCR);
 
@@ -261,7 +262,8 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	if (prescale == 8 && scldiv >= 256)
 		return -EINVAL;
 
-	writel(scldiv, fsl_lpspi->base + IMX7ULP_CCR);
+	writel(scldiv | (scldiv << 8) | ((scldiv >> 1) << 16),
+					fsl_lpspi->base + IMX7ULP_CCR);
 
 	dev_dbg(fsl_lpspi->dev, "perclk=%d, speed=%d, prescale =%d, scldiv=%d\n",
 		perclk_rate, config.speed_hz, prescale, scldiv);
@@ -329,6 +331,11 @@ static void fsl_lpspi_setup_transfer(struct spi_device *spi,
 		fsl_lpspi->tx = fsl_lpspi_buf_tx_u32;
 	}
 
+	if (t->len <= fsl_lpspi->txfifosize)
+		fsl_lpspi->watermark = t->len;
+	else
+		fsl_lpspi->watermark = fsl_lpspi->txfifosize;
+
 	fsl_lpspi_config(fsl_lpspi);
 }
 
-- 
2.43.0



