Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9105E2D780A;
	Thu, 15 Jan 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497407; cv=none; b=DxCc41MLQ5bGL6ua0HFNX+G2jFZQkyF26wSukMqcabqk4GglnnVlQlCdK0POL8k6EZ3nyE55/Q4ILlzHarqG4x+WXc9fRMQ1VJwH6bnsAT5fkY73q7blbrIRtnS3yK6NcowNkspMvFora4gaNvZOIkbHmi+1eFKAEHSJ+gMa4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497407; c=relaxed/simple;
	bh=o1wvYI8nzdN1V7HJACL3w3wW5CGhMYkLwaWzfbjlHbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKaZKi81o8jfIFEY9y18BpbrPs/VyCOX2sAFEo7fF3kBYSImx5Cpjn54pBsaEAt6zm2zEhk3N/YHYAj5GmjsVDw+FpzykP5qfish7eucPUh62eB7STpxSfCltD8C869iprAjX5eHsW7E/WawWjZnf7uIZz94lGhs+2O1sq59ui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKQvch7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKQvch7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A782C116D0;
	Thu, 15 Jan 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497407;
	bh=o1wvYI8nzdN1V7HJACL3w3wW5CGhMYkLwaWzfbjlHbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKQvch7ZD7XDZDxmKoLh/FyYrjWpZ0fZqWBmYln+MqTMy3zL/ClxxJS8LHNBf6sxL
	 M8mgrgjpl2DeK7fz7oKxVZAPNS8oNgCTSCRve7bHTsMQCIirw6yAaeel0xQXgFH8n7
	 d1MSYc/3Wl37HuhOPYNoDxUZR8zAErbDOTn1Hrbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/554] spi: tegra210-quad: use device_reset method
Date: Thu, 15 Jan 2026 17:42:17 +0100
Message-ID: <20260115164248.812935333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit ac982578e7d340dc4f4fd243f4a4b24787d28c3f ]

Use device_reset api to replace duplicate code in driver to call
reset_control_get api with reset handle.

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20220222175611.58051-2-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 3432058b0a7bd..c3867c70c61d4 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -137,7 +137,6 @@ struct tegra_qspi {
 	spinlock_t				lock;
 
 	struct clk				*clk;
-	struct reset_control			*rst;
 	void __iomem				*base;
 	phys_addr_t				phys;
 	unsigned int				irq;
@@ -956,9 +955,8 @@ static void tegra_qspi_handle_error(struct tegra_qspi *tqspi)
 	dev_err(tqspi->dev, "error in transfer, fifo status 0x%08x\n", tqspi->status_reg);
 	tegra_qspi_dump_regs(tqspi);
 	tegra_qspi_flush_fifos(tqspi, true);
-	reset_control_assert(tqspi->rst);
-	udelay(2);
-	reset_control_deassert(tqspi->rst);
+	if (device_reset(tqspi->dev) < 0)
+		dev_warn_once(tqspi->dev, "device reset failed\n");
 }
 
 static void tegra_qspi_transfer_end(struct spi_device *spi)
@@ -1260,13 +1258,6 @@ static int tegra_qspi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	tqspi->rst = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-	if (IS_ERR(tqspi->rst)) {
-		ret = PTR_ERR(tqspi->rst);
-		dev_err(&pdev->dev, "failed to get reset control: %d\n", ret);
-		return ret;
-	}
-
 	tqspi->max_buf_size = QSPI_FIFO_DEPTH << 2;
 	tqspi->dma_buf_size = DEFAULT_QSPI_DMA_BUF_LEN;
 
@@ -1288,9 +1279,8 @@ static int tegra_qspi_probe(struct platform_device *pdev)
 		goto exit_pm_disable;
 	}
 
-	reset_control_assert(tqspi->rst);
-	udelay(2);
-	reset_control_deassert(tqspi->rst);
+	if (device_reset(tqspi->dev) < 0)
+		dev_warn_once(tqspi->dev, "device reset failed\n");
 
 	tqspi->def_command1_reg = QSPI_M_S | QSPI_CS_SW_HW |  QSPI_CS_SW_VAL;
 	tegra_qspi_writel(tqspi, tqspi->def_command1_reg, QSPI_COMMAND1);
-- 
2.51.0



