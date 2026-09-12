Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FCF369990;
	Sat, 12 Sep 2026 08:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203464; cv=none; b=dv1riizuZZxGkr8+IUOvc3e+nUdWhPb3JhwlJWQ4VM7s9hkrUaLrJ/wgSDUV/fhk8K/UdplQfV2jc0lGwK/2HVBogYEeVyx/gqGv6ZAoZMm2ROVDHimjYJoLTD0h2GQCupWbiyVUVaLlvpoEuONSB2pe/AwcPyfmYc4EzA8T+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203464; c=relaxed/simple;
	bh=q/uVnt9g3nqxDbWDexAf5oER99Sz9MET/E7Im/PSJzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkhPXH1vlGaGxXHJX2siKtYdBnI2MZm8tUUefFLPHmvcNQ6i7ym52CYQz7oRztTMmDz5Mb9adi6GYCVBle2z1ksnOtY4ImMEaixx+WidG+uW4rqSggiJt1zjHuCqq/zJ7fRFp8s/WQvVxOJVV1qUa6NhFRdSs4BFtzp2DV7kGpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5CqmRdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5CqmRdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66001F000FF;
	Sat, 12 Sep 2026 08:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203463;
	bh=JmKQJTHJDUzfPPCeJyEhoIKcR9ZONT1FrBHgTjkoELs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5CqmRdYeYDFM2Oa2pU6NFpswTT9C0kzSlSeraEd58RClym+meF94x3yPtdr7IWcA
	 H/R3plTrf4/U0eXtTKrhVi3poZOAXM6BDz6Op8G7ALt0EwVvjznh+rv29SVauQE1pc
	 8DWQYHeO2up6GL7AGuPI6QumjIkfBk2d3QFMGrDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1411/1815] spi: img-spfi: dont disable runtime PM on DMA deferred probe
Date: Sat, 12 Sep 2026 08:52:41 +0200
Message-ID: <20260912065722.147790561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 923e41ed59511cffe98357c7d58d0294a1c157ee ]

When dma_request_chan() returns -EPROBE_DEFER, the error path jumps to
disable_pm and calls pm_runtime_disable() even though pm_runtime_enable()
was never called, leaving disable_depth unbalanced and the device
permanently PM-disabled.

Route the defer path through free_dma to skip pm_runtime_disable().

Fixes: 6bfbf4d0aa0c ("spi: img-spfi: Use dma_request_chan() instead dma_request_slave_channel()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260808-spfi-v1-1-6bc4345be430@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-img-spfi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index aec724e3f8246..a9310a1b0354f 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -611,7 +611,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->tx_ch);
 		spfi->tx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	spfi->rx_ch = dma_request_chan(spfi->dev, "rx");
@@ -619,7 +619,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->rx_ch);
 		spfi->rx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	if (!spfi->tx_ch || !spfi->rx_ch) {
@@ -647,6 +647,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_disable(spfi->dev);
+free_dma:
 	if (spfi->rx_ch)
 		dma_release_channel(spfi->rx_ch);
 	if (spfi->tx_ch)
-- 
2.53.0



