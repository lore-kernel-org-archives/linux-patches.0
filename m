Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A25D13665D;
	Tue, 14 May 2024 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684393; cv=none; b=qA88WYmzrFwzsjNHZvkjq3/DvK9h7uMr+ObrZzcF12rXpohrR53BdjhJGOgNaouvCqyaqq/BT3cDznQsGORcAqH4vZVe5dbAx5voEP44Py1Oi9u/MoITF/mAxc8NmVTVkPO+WUtUMBnXJ/z0Jz0MazN82YAAMup4d9SHPeySluk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684393; c=relaxed/simple;
	bh=sjS28HOXZ7NVcxGw/4qiaxAZ9fpYrXGDx/RjhuXvjf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaWuL4JOf7Sn16UNDZwnNd+uaGQjx+HFWZmFna8P4ifxhqV2bx54/FRmm6J5Knllw17dir1h/ldo0sGVCmJubbJX8r5j8wTRXJOvnTmrv3pp71geXsquLO6ij8iYN1j/08bqfPNhDfV5P7vmRWhSRffjCFSNqNibJkNJbZbhx3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pki99w5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pki99w5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8E4C2BD10;
	Tue, 14 May 2024 10:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684393;
	bh=sjS28HOXZ7NVcxGw/4qiaxAZ9fpYrXGDx/RjhuXvjf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pki99w5LyLzTFBOx435V8esRgEIDmOl+0gECvQTLUCR9lfEKyZsXjt6cGQHs+pdt8
	 H/IHxNvbyAd5umRw/JpGhEQ6tHMFUtaJqQBWWoU3488p7IZKHkvDRZcY5UUDuW12UK
	 QOIo6l2Mryc0cKWAnRaFspCOZf5gT/1kNC0Bk8Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/301] spi: axi-spi-engine: simplify driver data allocation
Date: Tue, 14 May 2024 12:15:07 +0200
Message-ID: <20240514101033.609118597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b96e55f59d1a9..bdf0aa4ceb1df 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -473,15 +473,11 @@ static int spi_engine_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
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



