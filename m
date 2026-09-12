Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250B43859E6;
	Sat, 12 Sep 2026 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231405; cv=none; b=ooVcVCEEwAnK1yM+K/I6v9i4WmjB141HSoF520tzrqHpikY3zvd0ZAxFq3CSOxYlljMQpbnYBomzoAuu2zOqtzk75e0zpxuRH78nNY2Xgkqz0hE/oG6ClQ6W+BKrDyWzQ1r6dBo+mL8mkmmZEn8+YynG7FC+xXOWY+6IFlCubEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231405; c=relaxed/simple;
	bh=L9/30GQGseFK1u+lWzi3CuigtfpJKoZ5l3Ci3DUt7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFVdT1WHiFsQqfs3aohr5vpMR6s7ARCOKStTzE8Cdw1OJBmNuUACAMFzncYOVi5zKWTlXZUftuA2sKY6jJypqUY3mV/icx37H2DqGcGI2cfzlMTWJmZv16UyHSCJccc1j6F2lc+yiAPxJmCA1FJKCnm05Oh64bHA6t6Fc0XpQ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNQ/ABfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNQ/ABfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6571F000FF;
	Sat, 12 Sep 2026 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231404;
	bh=Xk30b5NZHYG4/MpRXUPdnmjJ8ySTuzuTj0V2m2P5rAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNQ/ABfsr6XcxpU/26k5dtFVS+OqZ8Nr9Og6H9wWuwDRmSJdNCiwdXHS+hA2EM5aP
	 V6EZMdPrXWnKKf1daWPh5o5O3/uS79ibYjjIOTywUrefQ1ojXZ8uSaz0eifrdRJP8e
	 ZEGFOJ3kZbZ+RIaAbR6GwDDh/wB7r3w+7Ikr3+LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0992/1191] spi: img-spfi: dont disable runtime PM on DMA deferred probe
Date: Sat, 12 Sep 2026 09:02:00 +0200
Message-ID: <20260912065610.484186351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bfd12247f1734..13c93cede8fb2 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -617,7 +617,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->tx_ch);
 		spfi->tx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	spfi->rx_ch = dma_request_chan(spfi->dev, "rx");
@@ -625,7 +625,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->rx_ch);
 		spfi->rx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	if (!spfi->tx_ch || !spfi->rx_ch) {
@@ -653,6 +653,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_disable(spfi->dev);
+free_dma:
 	if (spfi->rx_ch)
 		dma_release_channel(spfi->rx_ch);
 	if (spfi->tx_ch)
-- 
2.53.0



