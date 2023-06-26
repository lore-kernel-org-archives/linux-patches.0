Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53439134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FD2C433C9;
	Mon, 26 Jun 2023 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803762;
	bh=pT6Kk/bbYFJi3YjFoIFdzBdBxD8HJ/mXykEx2UzWtU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0AfPD11aWODTKmXUUX6twUTwjWG2hyUxJe0o5t33VM+qcQ00Nknx3g9wLL5EVX8R
	 6yjNh7g9m4u7NWkX6aPkNG9M/YE6/EWjPLnomeHa27C31mbdYN7m0J67ymfkXLgkJF
	 wZyxyn7ByMvgX+Pi8yD5ifcwZDCIYP2FhjRvcv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 169/199] spi: lpspi: disable lpspi module irq in DMA mode
Date: Mon, 26 Jun 2023 20:11:15 +0200
Message-ID: <20230626180813.110882188@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 9728fb3ce11729aa8c276825ddf504edeb00611d ]

When all bits of IER are set to 0, we still can observe the lpspi irq events
when using DMA mode to transfer data.

So disable irq to avoid the too much irq events.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Link: https://lore.kernel.org/r/20230505063557.3962220-1-xiaoning.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 34488de555871..457fe6bc7e41e 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -910,9 +910,14 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	ret = fsl_lpspi_dma_init(&pdev->dev, fsl_lpspi, controller);
 	if (ret == -EPROBE_DEFER)
 		goto out_pm_get;
-
 	if (ret < 0)
 		dev_err(&pdev->dev, "dma setup error %d, use pio\n", ret);
+	else
+		/*
+		 * disable LPSPI module IRQ when enable DMA mode successfully,
+		 * to prevent the unexpected LPSPI module IRQ events.
+		 */
+		disable_irq(irq);
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
-- 
2.39.2



