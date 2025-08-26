Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1727707;
	Tue, 26 Aug 2025 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214042; cv=none; b=o9deSuseenzc4/NB0OuBkIpJgs/psZx14XO5jNTMRTIoQTd3RxN7Ov/z9UgQ/a5qYZHr2NRQVEHamy7nDxBc6rN52HDAAY5o2lsdOr46HuvkSO8Z/VSQO1IBVkKb+ursX/HKqaWgFlw24bWPEYUIVs5tlUyrdPHL+RT7z16y3Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214042; c=relaxed/simple;
	bh=s8swVv3WIBSg39D4bNzBU/mDr6GvxI2PfvplPtitx1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGfn628FhmsEb4xp0O6YymjK47PoYS5zLqU0xzZ55rKIwtIhLAZlCVpSKPITpiER+vUPxG1kuvFtVWCztXb+6wc/6RMhXNZkyqDrN2xTXO6xzMmKyXi6R7YiQ4rr0XeTp9sJMXpHKjXICV3+aZpxOFnIQX48YDPRmkTH3gkmFv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dlTL3yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dlTL3yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3778C4CEF1;
	Tue, 26 Aug 2025 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214042;
	bh=s8swVv3WIBSg39D4bNzBU/mDr6GvxI2PfvplPtitx1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dlTL3yc8dn89dnC2PSPJeQB14YZHs8aTn9C75Pe5iwKMC9kZXYEev/v7OpkqnPTr
	 cAT473hdJZ8dApxRvuElREdspzPYS3p6NwPri+5AD0IY92V7VBeWtX2Vo7iv4lD7vC
	 aRunZeyyOhBV/e3syCcBP03ft/dgbD0qaaMJ6Mdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 548/587] spi: spi-fsl-lpspi: Clamp too high speed_hz
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826111006.960062862@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit af357a6a3b7d685e7aa621c6fb1d4ed6c349ec9e ]

Currently the driver is not able to handle the case that a SPI device
specifies a higher spi-max-frequency than half of per-clk:

    per-clk should be at least two times of transfer speed

Fix this by clamping to the max possible value and use the minimum SCK
period of 2 cycles.

Fixes: 77736a98b859 ("spi: lpspi: add the error info of transfer speed setting")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20250807100742.9917-1-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 9e2541dee56e..fa899ab2014c 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -330,13 +330,11 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	}
 
 	if (config.speed_hz > perclk_rate / 2) {
-		dev_err(fsl_lpspi->dev,
-		      "per-clk should be at least two times of transfer speed");
-		return -EINVAL;
+		div = 2;
+	} else {
+		div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
 	}
 
-	div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
-
 	for (prescale = 0; prescale <= prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
 		if (scldiv >= 0 && scldiv < 256) {
-- 
2.50.1



