Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A52153DD;
	Thu, 12 Dec 2024 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021688; cv=none; b=f6NioEpcfC4jyeK+70kWst5jfod8y6XRIiwrBn6jvUUcAgJF8UiLMHUBcR1KDarFUfdZ3wLUEkxVsP+a0A52QSzU+J32m3NL8rxK7m1pF4/TzBkklxLSn7NdXTfUIUaTDrVcbXLVhKLO0cqzfmmbB0fpwSFNKJJg2e3YIgPUXEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021688; c=relaxed/simple;
	bh=dVSZ4e14Qa49MivuvhtviMt1GtqQhMaht4bFLQgSeLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qh4/XQKPdiSoun+29gjVhZI5/8gpllAwPPhbcPTtRw1jurBp858XShn8UzgIjiE01Y/x8K1wPTL1+9YCa8w14u2imioAETEaEKEzbFwnkyPkrDqWbGShdSU0waA3oEcDLx8X/k7+gO8Vno++bnsM1+zcV+QYvSHdbwDUEcNZ6co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyUkEDCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyUkEDCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC83C4CECE;
	Thu, 12 Dec 2024 16:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021688;
	bh=dVSZ4e14Qa49MivuvhtviMt1GtqQhMaht4bFLQgSeLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyUkEDCvC2dFHZWhhtQVi+Y1W69XknldYDjpHlUKZV/dyziA5NQeLfxeYYheL8LPp
	 atv1Ep695nA1aWcCRa2UXanMhyljVeCsXJt2yVhCU3A4cEUGekE+SaqFx9dAV3mtTF
	 CO1b4purfAYfzODakp9Uo8I87p3uSIyojME1NhpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/565] mmc: sunxi-mmc: Add D1 MMC variant
Date: Thu, 12 Dec 2024 15:53:50 +0100
Message-ID: <20241212144312.841008733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 75a2f412d0aed4a4a80ab2a2d96d040b17acb6d6 ]

D1's MMC controllers are unique in that they have the DMA address shift
(like A100) with a 13-bit descriptor size field (like sun4i). Add the
compatible and parameters for this new variant.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220203015112.12008-2-samuel@sholland.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 85b580afc2c2 ("mmc: sunxi-mmc: Fix A100 compatible description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sunxi-mmc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 3c213816db786..cd81f9a79169e 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1168,6 +1168,14 @@ static const struct sunxi_mmc_cfg sun9i_a80_cfg = {
 	.can_calibrate = false,
 };
 
+static const struct sunxi_mmc_cfg sun20i_d1_cfg = {
+	.idma_des_size_bits = 13,
+	.idma_des_shift = 2,
+	.can_calibrate = true,
+	.mask_data0 = true,
+	.needs_new_timings = true,
+};
+
 static const struct sunxi_mmc_cfg sun50i_a64_cfg = {
 	.idma_des_size_bits = 16,
 	.clk_delays = NULL,
@@ -1206,6 +1214,7 @@ static const struct of_device_id sunxi_mmc_of_match[] = {
 	{ .compatible = "allwinner,sun7i-a20-mmc", .data = &sun7i_a20_cfg },
 	{ .compatible = "allwinner,sun8i-a83t-emmc", .data = &sun8i_a83t_emmc_cfg },
 	{ .compatible = "allwinner,sun9i-a80-mmc", .data = &sun9i_a80_cfg },
+	{ .compatible = "allwinner,sun20i-d1-mmc", .data = &sun20i_d1_cfg },
 	{ .compatible = "allwinner,sun50i-a64-mmc", .data = &sun50i_a64_cfg },
 	{ .compatible = "allwinner,sun50i-a64-emmc", .data = &sun50i_a64_emmc_cfg },
 	{ .compatible = "allwinner,sun50i-a100-mmc", .data = &sun50i_a100_cfg },
-- 
2.43.0



