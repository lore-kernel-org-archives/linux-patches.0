Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E66198A0D;
	Wed,  5 Mar 2025 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197016; cv=none; b=Oj25AnpX0CC2l8v6AkcskhoJsUpoDbWdkGE3ladphabHt/5RSiwFyYGk7EZstr3TJxg0GQZpz6uKbf2GmDgUMIl9TnvTO8ol9X90xD7AUxc7+UUQfYBXA8pWLgL9jZK1W0Z8SJ4RrTAcH7HiPTnKXCtC3GoZbCV+7DuJNZo6Nyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197016; c=relaxed/simple;
	bh=YqPmyFs4L3nM1pEkI8IzJEF6edvqRBu5e9q+FgG0VRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H98RBlhwuidN1kT4yFS+4w5dr8q/a4Yf4q10csK3zXIezgSHEcDR6fYSxNnSRiI/J4t4yDjFWl9OtMEnvqM0Yx3YEMMWB8RvtMHMMq08yU2anoA7rqzldCA5qgSdX5GV2t61pWQ2dDEid87Vf2iPWR32EgkyBSpLG3k4Icih6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSmCTuBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSmCTuBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D286C4CED1;
	Wed,  5 Mar 2025 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197016;
	bh=YqPmyFs4L3nM1pEkI8IzJEF6edvqRBu5e9q+FgG0VRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSmCTuByLr7SeOWNh0Ra8nHsjGugCmvDWJyJyAx+55taz0WezMtRBOO0jZO4oR+HS
	 7p3BmDfQnimIyg+kw5MOUPwUkVejAQGi7hAjEdZPE5DypSYHZ/2FftcEFDchJDDlXa
	 V4uUyDfsc7thhBF6djFklIB8BxQJ9DuqMZ4skCzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/176] spi: atmel-quadspi: Add support for configuring CS timing
Date: Wed,  5 Mar 2025 18:46:20 +0100
Message-ID: <20250305174505.911046285@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit f732646d0ccd22f42ed7de5e59c0abb7a848e034 ]

The at91 QSPI IP uses a default value of half of the period of the QSPI
clock period for the cs-setup time, which is not always enough, an example
being the sst26vf064b SPI NOR flash which requires a minimum cs-setup time
of 5 ns. It was observed that none of the at91 SoCs can fulfill the
minimum CS setup time for the aforementioned flash, as they operate at
high frequencies and half a period does not suffice for the required CS
setup time. Add support for configuring the CS timing in the controller.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20221117105249.115649-5-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: be92ab2de0ee ("spi: atmel-qspi: Memory barriers after memory-mapped I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index b5afe5790b1d2..58d5336b954d9 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -510,6 +510,39 @@ static int atmel_qspi_setup(struct spi_device *spi)
 	return 0;
 }
 
+static int atmel_qspi_set_cs_timing(struct spi_device *spi)
+{
+	struct spi_controller *ctrl = spi->master;
+	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
+	unsigned long clk_rate;
+	u32 cs_setup;
+	int delay;
+	int ret;
+
+	delay = spi_delay_to_ns(&spi->cs_setup, NULL);
+	if (delay <= 0)
+		return delay;
+
+	clk_rate = clk_get_rate(aq->pclk);
+	if (!clk_rate)
+		return -EINVAL;
+
+	cs_setup = DIV_ROUND_UP((delay * DIV_ROUND_UP(clk_rate, 1000000)),
+				1000);
+
+	ret = pm_runtime_resume_and_get(ctrl->dev.parent);
+	if (ret < 0)
+		return ret;
+
+	aq->scr |= QSPI_SCR_DLYBS(cs_setup);
+	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
+
+	pm_runtime_mark_last_busy(ctrl->dev.parent);
+	pm_runtime_put_autosuspend(ctrl->dev.parent);
+
+	return 0;
+}
+
 static void atmel_qspi_init(struct atmel_qspi *aq)
 {
 	/* Reset the QSPI controller */
@@ -555,6 +588,7 @@ static int atmel_qspi_probe(struct platform_device *pdev)
 
 	ctrl->mode_bits = SPI_RX_DUAL | SPI_RX_QUAD | SPI_TX_DUAL | SPI_TX_QUAD;
 	ctrl->setup = atmel_qspi_setup;
+	ctrl->set_cs_timing = atmel_qspi_set_cs_timing;
 	ctrl->bus_num = -1;
 	ctrl->mem_ops = &atmel_qspi_mem_ops;
 	ctrl->num_chipselect = 1;
-- 
2.39.5



