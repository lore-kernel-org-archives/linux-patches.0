Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561212222B2;
	Mon,  9 Feb 2026 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648069; cv=none; b=iin6WcjWRqFYnOt4o96KEoEiJPa+IRhQYdQxXvg1DG11Xhm8GQfWMojWMJff4obzMX7Gv2l4xjPdIyAHlidkuuYaN0qNMr+JLB5rDzU+JPzSIbGPJThZQOHQX+xTZBmpgpaw33CH0ToUfi8LtxTO7t0XxqF3TPBgBQRNcHSQg6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648069; c=relaxed/simple;
	bh=ByQGG4KhYnnuXGcWn+zGQDYD8IbxzObdnkrIJeJCN1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVczUWO8JNShy/pTONK4hObpDAwgEucEUGVLp64KXxn7TaJAQ6Ud0MQ8HhXAEJuxUSalSwtHORP/Xr11/nHXDUeMSL+Ij3BKi4HVzLseIKqXd+alUWn+EjNO1oXLzi5W86uvEQ2JgVt4UAeVAEE48+0glHAGWbYhtNR+mSO+NiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGANrlId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGANrlId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63D1C116C6;
	Mon,  9 Feb 2026 14:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648069;
	bh=ByQGG4KhYnnuXGcWn+zGQDYD8IbxzObdnkrIJeJCN1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGANrlId8pB3tGpG8Y5W9PpSvM4GZqdO2QW/DkDKzOOrPkBMaBb6hadf/XhWKPZP2
	 ykf6jMsYdnBa821GSn206xuTLrfqjw3K10EG/28G8TFZD48e/XNoU6jvp3NGZOrB8K
	 otv0cmDmMHwbGVWqHgEgYUljqv57ttGijINxjCRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/113] spi: tegra114: Preserve SPI mode bits in def_command1_reg
Date: Mon,  9 Feb 2026 15:24:21 +0100
Message-ID: <20260209142314.195639062@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit a0a75b40c919b9f6d3a0b6c978e6ccf344c1be5a ]

The COMMAND1 register bits [29:28] set the SPI mode, which controls
the clock idle level. When a transfer ends, tegra_spi_transfer_end()
writes def_command1_reg back to restore the default state, but this
register value currently lacks the mode bits. This results in the
clock always being configured as idle low, breaking devices that
need it high.

Fix this by storing the mode bits in def_command1_reg during setup,
to prevent this field from always being cleared.

Fixes: f333a331adfa ("spi/tegra114: add spi driver")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20260204141212.1540382-1-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 11db703a0dde3..6aed6429358a2 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -978,11 +978,14 @@ static int tegra_spi_setup(struct spi_device *spi)
 	if (spi_get_csgpiod(spi, 0))
 		gpiod_set_value(spi_get_csgpiod(spi, 0), 0);
 
+	/* Update default register to include CS polarity and SPI mode */
 	val = tspi->def_command1_reg;
 	if (spi->mode & SPI_CS_HIGH)
 		val &= ~SPI_CS_POL_INACTIVE(spi_get_chipselect(spi, 0));
 	else
 		val |= SPI_CS_POL_INACTIVE(spi_get_chipselect(spi, 0));
+	val &= ~SPI_CONTROL_MODE_MASK;
+	val |= SPI_MODE_SEL(spi->mode & 0x3);
 	tspi->def_command1_reg = val;
 	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
 	spin_unlock_irqrestore(&tspi->lock, flags);
-- 
2.51.0



