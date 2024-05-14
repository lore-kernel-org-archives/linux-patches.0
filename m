Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B19A58AC4;
	Tue, 14 May 2024 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686272; cv=none; b=sAYHfptaPDH/m0miAS58jPrO2ns4LEj6YZubnJlvb+ZkdhjhDt4Bi8bl39ZbDvwinMFip4d1Bv6S8YEGdvJsp4kgK8Hh2kftIJRkixFRXaeCQgcmdn+6D8/oCFf0s8tRa1tPC55/Iu3dt603k+NmpsjURPM4JYJFdOxDiU8Z06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686272; c=relaxed/simple;
	bh=yXtCoBiRF1dFN/hFz4jqEhMy9YXxumIzMzg9k67odpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju4vS1sj86dVntUxUXB+mQkI8oRC8fFeLBV+0KBRd2JonY5+TI6QwdlvJftqbkug1q0e8X0afLksvOvGjjUfAy1CRl1e+eeAoVchaiWCzT07dgGuTWCnxIP7VfnBtc+N3yQL5NHbHfnX6kx01QzjME6YJDRvim5eSDMn7yqbxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkbGCrhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkbGCrhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2153CC2BD10;
	Tue, 14 May 2024 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686272;
	bh=yXtCoBiRF1dFN/hFz4jqEhMy9YXxumIzMzg9k67odpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkbGCrhZhq2yEreXg49tANRcEL6+PoNaFjCKHZwdTKjSITftROtUmi+KFXoS3PPYC
	 C3yE+vEaXJ3rAxt+tPz8fGjaBnLPMOAxzPdpJQVqtwiJ0AwXzUbZndwgaNlWRMnhy5
	 cdw+U7Ps87ExTpf0d20qvQ4V9Y6WxfDN2qd6OO7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/236] spi: axi-spi-engine: simplify driver data allocation
Date: Tue, 14 May 2024 12:16:50 +0200
Message-ID: <20240514101022.167753156@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 9e4ce5220eedea2cc440f3961dec1b5122e815b2 ]

This simplifies the private data allocation in the AXI SPI Engine driver
by making use of the feature built into the spi_alloc_host() function
instead of doing it manually.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20231117-axi-spi-engine-series-1-v1-3-cc59db999b87@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 861578aa6ea12..492882213bb2f 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -473,15 +473,11 @@ static int spi_engine_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		return -ENXIO;
 
-	spi_engine = devm_kzalloc(&pdev->dev, sizeof(*spi_engine), GFP_KERNEL);
-	if (!spi_engine)
-		return -ENOMEM;
-
-	host = spi_alloc_host(&pdev->dev, 0);
+	host = spi_alloc_host(&pdev->dev, sizeof(*spi_engine));
 	if (!host)
 		return -ENOMEM;
 
-	spi_controller_set_devdata(host, spi_engine);
+	spi_engine = spi_controller_get_devdata(host);
 
 	spin_lock_init(&spi_engine->lock);
 
-- 
2.43.0



