Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CC21B905;
	Sun,  7 Sep 2025 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277902; cv=none; b=bbzMuQQriDlqz55CGPG2u+yFmKNf/CLVoQ32C6UqYEyW6JSgLRrqrnAdwEjBqFkvVf566zCMcUdqmeWPpYpKEiyFYdS1zUuOcNKBfElphKKUk9JUWNP7VLZJEEdlEpSaJkpIOo7cpGlzvFOZPhreed/oL4g/7MhbVgVeRTpPW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277902; c=relaxed/simple;
	bh=v5jlp5pkQ8asctmQHXfRDYJ5KyMFP/8UOg85uj2z5vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRpN/E0q/UaL/s54WBN+5HX+oZhBUwe5BINtp18gPro16gfIy+EN4Xn7SXLvyRSP5c5WInIQGkg0va82P5RNgAtRnLYt+yunZzq60FZzP4PO/9vcfEOk6OJ90Pb8sECWidNv/wwHqniz98FwF/15eqbegof9b805eWe0Jm7Owbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGSmfR1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGSmfR1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43108C4CEF0;
	Sun,  7 Sep 2025 20:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277902;
	bh=v5jlp5pkQ8asctmQHXfRDYJ5KyMFP/8UOg85uj2z5vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGSmfR1mxsEeKTtcI7e7Gi8OFst4dlOKSN7n2H+XeDKxXH6iW4z+dq2XbScL8kxbi
	 ZnnWQ0kVUi8YIFBUZXy11moM3PJPUAZjQ+9YeC1uXrEI18TavDetzMat6OtEtTaW90
	 QyQRpnHwPwMX0Qok8Gs8Ub6mk8XzRQX+CXmXZWiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 157/183] spi: spi-fsl-lpspi: Fix transmissions when using CONT
Date: Sun,  7 Sep 2025 21:59:44 +0200
Message-ID: <20250907195619.548521098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit 782a7c73078e1301c0c427f21c06377d77dfa541 ]

Commit 6a130448498c ("spi: lpspi: Fix wrong transmission when don't use
CONT") breaks transmissions when CONT is used. The TDIE interrupt should
not be disabled in all cases. If CONT is used and the TX transfer is not
yet completed yet, but the interrupt handler is called because there are
characters to be received, TDIE is replaced with FCIE. When the transfer
is finally completed, SR_TDF is set but the interrupt handler isn't
called again.

Fixes: 6a130448498c ("spi: lpspi: Fix wrong transmission when don't use CONT")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-1-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 1a22d356a73d9..fbe58cbf33864 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -3,7 +3,7 @@
 // Freescale i.MX7ULP LPSPI driver
 //
 // Copyright 2016 Freescale Semiconductor, Inc.
-// Copyright 2018 NXP Semiconductors
+// Copyright 2018, 2023, 2025 NXP
 
 #include <linux/clk.h>
 #include <linux/completion.h>
@@ -786,7 +786,7 @@ static irqreturn_t fsl_lpspi_isr(int irq, void *dev_id)
 	if (temp_SR & SR_MBF ||
 	    readl(fsl_lpspi->base + IMX7ULP_FSR) & FSR_TXCOUNT) {
 		writel(SR_FCF, fsl_lpspi->base + IMX7ULP_SR);
-		fsl_lpspi_intctrl(fsl_lpspi, IER_FCIE);
+		fsl_lpspi_intctrl(fsl_lpspi, IER_FCIE | (temp_IER & IER_TDIE));
 		return IRQ_HANDLED;
 	}
 
-- 
2.51.0



