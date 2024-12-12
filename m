Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F2235C26;
	Thu, 12 Dec 2024 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019075; cv=none; b=f6kSeM48FvgpUx7xXQsKhyP6LIvXz7uxxQF6sz4q3hfAeOwNyJ89hWpgX/zX71B0RbzsvItkLDDTwIj0PjuXbr4liJIaA1GjlvjrvaIonqV3yk0XQmDiOTF2lxDNXX6KkLWTDlojsz+o1t8NqrtLGGGPUbKdR1MGH6l0MKM+FUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019075; c=relaxed/simple;
	bh=ySOlUiaMRYuqv2si610PpyMyFU4AoqNCdDYH9ycYRdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It+ARO3A8M7SlA0FPGZVrlnI3fbalemSl62pC6R8gKLz6Zri3byiIAVVEC3n+Ys5hY6whgDNlaO+rvURbCeXZ9RYa4Iwx3h+lU9yQcq7Egm2m5ZRzFL0bxf33CXfGztLLoWOD9n+RZhop6ef8it4JyDhjmhS60uicRjmIQFUaGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzA6c5lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzA6c5lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27891C4CECE;
	Thu, 12 Dec 2024 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019074;
	bh=ySOlUiaMRYuqv2si610PpyMyFU4AoqNCdDYH9ycYRdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzA6c5lmE7+f+GlC067HUhgB/YwnanAtRKbVp1+6mKAFXimNGX1aVz8Mf9UZOoQ3x
	 UHrOEI7VpUlK1Uo8ugGPlKiAnRQh5qcdNCW9L+y/Z+/MnRkSKnzaEYXRz62vfVw6F/
	 JWAPCvnu32sl4IOpPETx3VECaFkXOXOKURnGt0Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/772] spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:50:38 +0100
Message-ID: <20241212144353.783930942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index b9e602447eca5..246d133238822 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -870,7 +870,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		goto out_controller_put;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, 0,
+	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, IRQF_NO_AUTOEN,
 			       dev_name(&pdev->dev), fsl_lpspi);
 	if (ret) {
 		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, ret);
@@ -907,14 +907,10 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
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



