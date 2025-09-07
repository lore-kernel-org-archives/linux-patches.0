Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8322F74D;
	Sun,  7 Sep 2025 20:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276085; cv=none; b=gJyF8OA/iMKOeWsNTPCCXv5WnGWqLOa32FG9fq6j0y+VvazqrY7QpMdyiilCrCysj2iNP7qxZ03h6JirtMee5+a7lKg62ecniFak9LL4PoqxSA1FLY/m1PpIHbmrTWaq34WyXIQ2ehlobhRARAcnC2LBWYBFb6JGfKJAE9Yr9fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276085; c=relaxed/simple;
	bh=vRDv2LV+MFFfRnh2z3mvifir8gtnwLz6HRCdDRshJZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk96PQefCEpkMuMFJQZk1dB+dF6O/V/Zp5jwbsiOSd9i1wjSCKRHIXYCsq14FosPb/JgfNfKzPHIv7SbzzAyxaw3B1h5gEXPnKPrIwwazVpcA9EdWMc7HtyZ+So7c3cBWOX9WmZs52mbbpAd6Ik1jboUgKrnsZdcgX6Cz6DPd30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf8VhDmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf8VhDmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98A5C4CEF0;
	Sun,  7 Sep 2025 20:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276085;
	bh=vRDv2LV+MFFfRnh2z3mvifir8gtnwLz6HRCdDRshJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf8VhDmpSn8jJ/cIN/DfAg4rj/j0RgD3Av4Fcf2An+WWLdRcbqRa8XUfwTuBoN2Dq
	 DVWUuOyOHCIEO9cf8fKBS3A6dRJ9M/PNDKvK4YT41C0sbrhhU2MZu2LeJ6ceWa4+FB
	 dDl85uzRcfBciioSwbvP4hbfBCT6XF1Ky09EOqHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/64] spi: spi-fsl-lpspi: Fix transmissions when using CONT
Date: Sun,  7 Sep 2025 21:58:39 +0200
Message-ID: <20250907195604.991317966@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bf3f600bdd2c8..7ece48667f52d 100644
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
@@ -755,7 +755,7 @@ static irqreturn_t fsl_lpspi_isr(int irq, void *dev_id)
 	if (temp_SR & SR_MBF ||
 	    readl(fsl_lpspi->base + IMX7ULP_FSR) & FSR_TXCOUNT) {
 		writel(SR_FCF, fsl_lpspi->base + IMX7ULP_SR);
-		fsl_lpspi_intctrl(fsl_lpspi, IER_FCIE);
+		fsl_lpspi_intctrl(fsl_lpspi, IER_FCIE | (temp_IER & IER_TDIE));
 		return IRQ_HANDLED;
 	}
 
-- 
2.51.0



