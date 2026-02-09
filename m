Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212223D291;
	Mon,  9 Feb 2026 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647678; cv=none; b=tr1mQSJdHxfUrHGOrkvyAuCi9vC338R+blSj+Rz7BmqIg0OilQCp9z62dNu4siLXvuoEM+kA/ydQppSfP8zEn/c6sSC6NZGVEjxJKjRcYAV6FtWMOx9LyYeto1e2gCHqkB5fsU15jW5lVcoeHSyNQfjiWCRgNkvWLkeE1qELfA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647678; c=relaxed/simple;
	bh=sWBgqQDa2o+/soA+xoQi8bICUeFEKozLm153+v84W7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCyPz/thjAl4C4Xo6Y2lCr6m7I1KdRF52yvyQZK+BzMWotGF2+JZf6veontVzb1O2CTZ867lDgtJgSYGJ6wxZiWnoDq8GpHaHIljoUDdLmwI2hTBnH7TzTMQFACTqQp8JiRH/TGnl2GVf64Qp60CJ1eHS4aGUVs4r6BUmDue1Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIDX1mR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIDX1mR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2AEC116C6;
	Mon,  9 Feb 2026 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647678;
	bh=sWBgqQDa2o+/soA+xoQi8bICUeFEKozLm153+v84W7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIDX1mR9/KzVa2WMrvEMWhOXxDssxTwzk7iqiKU8L3XU0aKNgxF+yvTMEzWQzjMWe
	 wAdUvCI5VRUtY0k0ydiDkjNs9+MstrQwm8pLgLLei0p+YOw8aJ26rzBY93HgCYoKLn
	 H4LVdJYztk1NL7D9j8eSagMVVnGnfiyOHve7TdvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/175] spi: tegra114: Preserve SPI mode bits in def_command1_reg
Date: Mon,  9 Feb 2026 15:24:05 +0100
Message-ID: <20260209142326.666665098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 795a8482c2c70..48fb11fea55f2 100644
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



