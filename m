Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495B8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B42C433C8;
	Sun, 16 Jul 2023 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539119;
	bh=uMQ8yDtOinReme1j9OS//mJ3N23L5KBZrMXQ31n0oLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xV16t6H0EhoI1oW+LeGc2iQXRDHkDRSiKeJ1Kx/7Jljcu7EIgc6u5SaQNGeGGielq
	 m52BRbqA2U0aqVzdGAPV8fXmtirNp27KerKjvhSBmPyO1cDXm/jpCFMgR4jEKSh9mH
	 eUXGvYJ99/iO7Pk2cZXgD0gaeS8eoV7MXQWDnrkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 665/800] spi: spi-geni-qcom: enable SPI_CONTROLLER_MUST_TX for GPI DMA mode
Date: Sun, 16 Jul 2023 21:48:38 +0200
Message-ID: <20230716195004.558660996@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d10005837be83906bbd2078c3b4f9dfcbd6c95b6 ]

The GPI DMA mode requires for TX DMA to be prepared. Force SPI core to
provide TX buffer even if the caller didn't provide one by setting the
SPI_CONTROLLER_MUST_TX flag.

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230629095847.3648597-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 26ce959d98dfa..1df9d4844a68d 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1097,6 +1097,12 @@ static int spi_geni_probe(struct platform_device *pdev)
 	if (mas->cur_xfer_mode == GENI_SE_FIFO)
 		spi->set_cs = spi_geni_set_cs;
 
+	/*
+	 * TX is required per GSI spec, see setup_gsi_xfer().
+	 */
+	if (mas->cur_xfer_mode == GENI_GPI_DMA)
+		spi->flags = SPI_CONTROLLER_MUST_TX;
+
 	ret = request_irq(mas->irq, geni_spi_isr, 0, dev_name(dev), spi);
 	if (ret)
 		goto spi_geni_release_dma;
-- 
2.39.2



