Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E369E359F98;
	Fri,  9 Jan 2026 12:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960332; cv=none; b=hVx3imNrIPy/ErGjuWRIhrRrR6xVSlKJFx6v1pBWApulheMig7s71DJnvycJKcCWL6d5sFHGY/SHvn7YFcOhWS+s0CcGoPWLiU5zfRpRWHt+2zJx9Kl/op88+gJJS4cRnugKRsCrpludV9DcLI7OZKkkzX8RQsp9B87deaJ8wpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960332; c=relaxed/simple;
	bh=9a4yQRaLNWxEUZ/8cMWCjhvNd6c5Zmpf8lq5+X4jFLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMzSdm+x/jMsjP8iIglxkawyJF1U0+nzlci1c/jS4gcinv4tFmNhgST0Jnzhk+k5rHtt1kozW1Xv/shYZcYASPPdo8/eApbmVoElBqeAV2n20Qc1qtKhTGPKdM61kBlPnVMQzIr2+Jbmx1WHlvmhge0hHKKshliE8bP2FOU72j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlwDt+7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlwDt+7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE29C4CEF1;
	Fri,  9 Jan 2026 12:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960331;
	bh=9a4yQRaLNWxEUZ/8cMWCjhvNd6c5Zmpf8lq5+X4jFLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlwDt+7u0p/Vy8XLGT5yicKVXIQ60fj0lzEbLQ8B5t6aM78VB+b11JvofsGs98emX
	 nccKYU5TPZeZbDCT7wAfpXOgXCAXN1yiJgQYk0FNG7b7Ana60NjTpIa/WNqcDZRHn0
	 z3UxJpGclpeXcjvHCdRvet3byBZIsnbCfzZ0UP3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/737] spi: cadence-quadspi: Fix clock disable on probe failure path
Date: Fri,  9 Jan 2026 12:38:26 +0100
Message-ID: <20260109112147.801963633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit 1889dd2081975ce1f6275b06cdebaa8d154847a9 ]

When cqspi_request_mmap_dma() returns -EPROBE_DEFER after runtime PM
is enabled, the error path calls clk_disable_unprepare() on an already
disabled clock, causing an imbalance.

Use pm_runtime_get_sync() to increment the usage counter and resume the
device. This prevents runtime_suspend() from being invoked and causing
a double clock disable.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
Link: https://patch.msgid.link/20251212072312.2711806-3-a-dutta@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 7b809644436e..eed88aba2cfe 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1885,7 +1885,9 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-	clk_disable_unprepare(cqspi->clk);
+
+	if (pm_runtime_get_sync(&pdev->dev) >= 0)
+		clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	pm_runtime_put_sync(dev);
 probe_pm_failed:
-- 
2.51.0



