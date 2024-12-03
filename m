Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA19E1FA240;
	Tue,  3 Dec 2024 15:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240461; cv=none; b=ClNEK7fRX7yvC/AwOI5dGMYJ1aYMz1xpOm9wZXoGT6AZDx2sXdJOCm/4WKTQnx0zXHcvsIde/7IfgtUsczcfebqiB+W9Cim4GDOvs1d/yYqVOA1DkPQpLH0ZANOzJcjHyq5hZZabt4+LoL4Uyd83OhFkdDjYyPYlZuL3jR0MHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240461; c=relaxed/simple;
	bh=byJSuX5boShDdOdMGGrCTIlF5r+PbfqwWH5/p5qjpgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO4CexFXHzwUfjwz21p4i7WKKYBnzE7h3SmtUcsJIRRX9K1aU/tJmqE1TNAAI3+UPRtd92pcOXUomQkILZCgXU6LbikkVeXpufTjJsR9vrimAlmA5gkyTNqhTi/xUTMGdfvzbUnqMYkuO6du2Mlx5RXvQivbc6Gwq7Zrl0uisBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pB7F+l3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pB7F+l3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B60C4CED6;
	Tue,  3 Dec 2024 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240461;
	bh=byJSuX5boShDdOdMGGrCTIlF5r+PbfqwWH5/p5qjpgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pB7F+l3UB8VYGnn+OT5z2fGHAsj3O1jMBTwmBAi/p170i/r4iIpzlao+7Hn+WDprU
	 95iSpko70QWL62qW2Tl42ZArAcqtQC32VyrR5xDRIf0v9po/sKbwkG7Yy/NU9FMBIO
	 hTvCDLzy24q0cuGseZ09RZyqtI1LDUW49OxQ6yrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/826] spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:37:07 +0100
Message-ID: <20241203144747.633988959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 003c7e01916c5e2af95add9b0cbda2e6163873e8 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 9728fb3ce117 ("spi: lpspi: disable lpspi module irq in DMA mode")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240906022828.891812-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 977e8b55c82b7..9573b8fa4fbfc 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -891,7 +891,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, 0,
+	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, IRQF_NO_AUTOEN,
 			       dev_name(&pdev->dev), fsl_lpspi);
 	if (ret) {
 		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, ret);
@@ -948,14 +948,10 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	ret = fsl_lpspi_dma_init(&pdev->dev, fsl_lpspi, controller);
 	if (ret == -EPROBE_DEFER)
 		goto out_pm_get;
-	if (ret < 0)
+	if (ret < 0) {
 		dev_warn(&pdev->dev, "dma setup error %d, use pio\n", ret);
-	else
-		/*
-		 * disable LPSPI module IRQ when enable DMA mode successfully,
-		 * to prevent the unexpected LPSPI module IRQ events.
-		 */
-		disable_irq(irq);
+		enable_irq(irq);
+	}
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
-- 
2.43.0



