Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16523093A6;
	Sat, 12 Sep 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225424; cv=none; b=Tuwji3y3786ea5+NClUeP/XYEwWVlBG0/4oNlkJjPFxzSAKgrQXUud9w7Jw/k4VWH+PpXII1ZxLJHB71Okp3hh0ntqO4BWuF8FJYggdjFwTMUEuctWY85HIOWZPPWcsXkg3uqd3fdvzTEbsb+bMT7awJMnIw3WvaYu9uiCYFFN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225424; c=relaxed/simple;
	bh=y6fY1P1pU9SsNe53flUV41l0zJ9tk/QO0qd+YY9qWTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8zdZUUTsfTBH0G9q108yjzukH99RWKbvzUNc/8bgf4rObsZXGOJWz90q7sg26kvCUuAFHX9BAOxdtZDGBj1LLCKZBfpm1KKlkkUDbR0vGskUn7gJGyHIPLXCVuRxrx5b8+KtIDJ1u7y2N9D9VIv21yO4xxdxTvbiPQTwQ45Y4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQkV51JU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQkV51JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FCF1F000FF;
	Sat, 12 Sep 2026 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225423;
	bh=RaabOj3QfBovSkFvE2rX+pY+NhlXQedrbfeIs2+pXY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQkV51JUSQYb55KaBMRBBe/+z8gialG3UvbeD/BODNJKN5RoEFmLx8Id1ozozFRzR
	 s0DMYAhACSv2Gy8AE8Ugd4g9kFhxCZmHOaHvZeye+V55Qb++j781lg3/yCG/4WN+lE
	 LgAS+ci2felGsPH6FNXp1GIdYpDae2QtZAw0y0F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1196/1424] spi: img-spfi: dont disable runtime PM on DMA deferred probe
Date: Sat, 12 Sep 2026 09:00:28 +0200
Message-ID: <20260912065634.069339173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 1e2a8cf9290fa..07fd38ae959e5 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -616,7 +616,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->tx_ch);
 		spfi->tx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	spfi->rx_ch = dma_request_chan(spfi->dev, "rx");
@@ -624,7 +624,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->rx_ch);
 		spfi->rx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	if (!spfi->tx_ch || !spfi->rx_ch) {
@@ -652,6 +652,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_disable(spfi->dev);
+free_dma:
 	if (spfi->rx_ch)
 		dma_release_channel(spfi->rx_ch);
 	if (spfi->tx_ch)
-- 
2.53.0



