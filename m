Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61237313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301053; cv=none; b=WAxSPTHBpbJyUouomXvQ2yAtv+/jMuG24uN0O+QBFgGL3GUPBRYe+xLhgW7TRbwFZRGA4FkKFgVHucDHcNx36sYWKfuZBDK2Z/NK58lVguNntGJChCCS3y6DDZMDlMo9aduz9wABIU4w69I2W91IQpfheH8W4K511U9BLb9JQgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301053; c=relaxed/simple;
	bh=sFevBPOD0FvGwnUb71/WuTM6PzXGWNrtXGQFKoOiJQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uo8SL8Ts9ZqNGGgdkC1WTzoohYrF6dsCL3weFrq+CprViVLmm5C5OD2tlr+AWKBAxJOXUsWgqTNzFgIjTNX4SH5+qeFlDg9IO4CtgABSQHug7DXIuLC/tOYK85LNEgXx4+AVenobgp1mY4SwhLDAH6XnDMrSIxZWMfTDf/Jd1a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLluG4ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLluG4ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C365C19423;
	Sat, 28 Feb 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301053;
	bh=sFevBPOD0FvGwnUb71/WuTM6PzXGWNrtXGQFKoOiJQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLluG4ffypnxAxQ13rh6vVWjlGC5VfVZ9qzmpdAlFtvMv4GVPTxBoTGCQSNR6/a2S
	 EqouL1giD5iLq4h9O5c7eocAjfU/T1VbxceBgI1YwnyMa67wXmMEq3XIn5+1T/262w
	 bekqJ2tRZpUHHP9itxWGd28644vyrfqJ+QTjZVqDJjc+jijNA+Z+Fg2lBEZOq5pU1g
	 UYbRzW+tKXA1rVW2Bt0+DErryuEWgIJEsrI8gLfWgej27OpwLb1ME9AcUYk7EU8YYT
	 Y7obNak4DKvrvxsoDFgvlcxbLKun2amg2wfMk5v1m8vDcdhc0oE0pzVmYCmNKhJ3ea
	 D1F4LDgjzTo1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/752] spi: cadence-qspi: Try hard to disable the clocks
Date: Sat, 28 Feb 2026 12:38:24 -0500
Message-ID: <20260228174750.1542406-193-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>

[ Upstream commit 612227b392eed94a3398dc03334a84a699a82276 ]

In the remove path, we should try hard to perform all steps as we simply
cannot fail.

The "no runtime PM" quirk must only alter the state of the RPM core, but
the clocks should still be disabled if that is possible. Move the
disable call outside of the RPM quirk.

Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Tested-by: Santhosh Kumar K <s-k6@ti.com>
Link: https://patch.msgid.link/20260122-schneider-6-19-rc1-qspi-v4-9-f9c21419a3e6@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 3689e38ebe56f..b3e4dd72d8b8a 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2044,6 +2044,7 @@ static void cqspi_remove(struct platform_device *pdev)
 	const struct cqspi_driver_platdata *ddata;
 	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
+	int ret = 0;
 
 	ddata = of_device_get_match_data(dev);
 
@@ -2059,8 +2060,10 @@ static void cqspi_remove(struct platform_device *pdev)
 		dma_release_channel(cqspi->rx_chan);
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
-		if (pm_runtime_get_sync(&pdev->dev) >= 0)
-			clk_disable(cqspi->clk);
+		ret = pm_runtime_get_sync(&pdev->dev);
+
+	if (ret >= 0)
+		clk_disable(cqspi->clk);
 
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-- 
2.51.0

