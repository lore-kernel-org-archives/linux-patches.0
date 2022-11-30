Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255CC79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4197DC433D6;
	Wed, 30 Nov 2022 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833810;
	bh=Towjjd0EAPoJybY2VIHs/VOxm8/bpYQWV6iv1wHKx9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DssvckmiJHyVWmzL9qpLQ2gTJ17Ljeo6zqI08qcOs2B5yCD/D4fmoh+3ZmCy4XVIA
	 QI3i6VeG+4w+maTgRyGK2ryhXAqj2O+uh4nydolXDBUNwhVg2/ewvuoIybBANc5rJa
	 S97lV6XGAGnFyUB8XwhEAu9CytgSfEuXpV+SIiPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 007/289] spi: tegra210-quad: Dont initialise DMA if not supported
Date: Wed, 30 Nov 2022 19:19:52 +0100
Message-Id: <20221130180544.287430592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit ae4b3c1252f0fd0951d2f072a02ba46cac8d6c92 ]

The following error messages are observed on boot for Tegra234 ...

 ERR KERN tegra-qspi 3270000.spi: cannot use DMA: -19
 ERR KERN tegra-qspi 3270000.spi: falling back to PIO

Tegra234 does not support DMA for the QSPI and so initialising the DMA
is expected to fail. The above error messages are misleading for devices
that don't support DMA and so fix this by skipping the DMA
initialisation for devices that don't support DMA.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221026155633.141792-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 904972606bd4..10f0c5a6e0dc 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -720,6 +720,9 @@ static int tegra_qspi_start_cpu_based_transfer(struct tegra_qspi *qspi, struct s
 
 static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 {
+	if (!tqspi->soc_data->has_dma)
+		return;
+
 	if (tqspi->tx_dma_buf) {
 		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
 				  tqspi->tx_dma_buf, tqspi->tx_dma_phys);
@@ -750,6 +753,9 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 	u32 *dma_buf;
 	int err;
 
+	if (!tqspi->soc_data->has_dma)
+		return 0;
+
 	dma_chan = dma_request_chan(tqspi->dev, "rx");
 	if (IS_ERR(dma_chan)) {
 		err = PTR_ERR(dma_chan);
-- 
2.35.1



