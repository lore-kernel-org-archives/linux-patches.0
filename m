Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CD81487CD;
	Thu, 12 Dec 2024 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023785; cv=none; b=Qov74YBk/atTtymsKGwe2D3TLsU8ea1kCSOfB3NPGLrHTwrB87GeKv0tMeBLKEZtZQbsFsjp/7iVvy2qAE27dr/rJGBxWxdpp5xZuX06M3KNo3GndOx1z+p7tAeSd9JAYrodStygN6J0QcErWqATFaQpXHcvbJJoEFjnGxJdaGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023785; c=relaxed/simple;
	bh=bxh71BEwAUiZH5nFUPM6MMsN0ZkVUo8omJhRN6yh8FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWnnK6mJrZ0BvL5LZTOJwdgTXBmM/9R1hr9Dxo0GIhHK0M2cJZhxCrLfY6bZrhPLhK/mz0/dNyfumQrjZcS92J+ZQXAsWavYwCYFV+tYL/tksfJ0QxY+AFx0wmCjZROp37jgyJio0kiSktgFyGulQ2/5wwyIsc8hG005L7VDx0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4NHtO8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4NHtO8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F62C4CECE;
	Thu, 12 Dec 2024 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023785;
	bh=bxh71BEwAUiZH5nFUPM6MMsN0ZkVUo8omJhRN6yh8FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4NHtO8G72JcgoecRLoq7o/AhXZAbRCmYzDjA2CjCCCCgfFypzGjIMJNIvNjYrCkq
	 Wq2KIM/7RATokIraBnGH+ukJI53Jt7G8BEhmChUOHykUXmQmgo8x2oqSKmtTshJpVs
	 4xm7os/WR23gwSCdJZuo3szpwHvwQrzt9ChcjPKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/459] spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:56:59 +0100
Message-ID: <20241212144256.719621770@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index efd2a9b6a9b26..bf3f600bdd2c8 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -871,7 +871,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		goto out_controller_put;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, 0,
+	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, IRQF_NO_AUTOEN,
 			       dev_name(&pdev->dev), fsl_lpspi);
 	if (ret) {
 		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, ret);
@@ -908,14 +908,10 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
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



