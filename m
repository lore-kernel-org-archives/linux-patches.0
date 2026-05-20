Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49AE3FC5C1;
	Wed, 20 May 2026 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302728; cv=none; b=mwARfO+eSFLaVesyNGCGGUTGOfANr0FeiKHvov0qeoag7NibRgIxlgafL7Caj/1k6KQabZit9P3IqCVeVRkzAioDLu6/qMyS6+2Z+j46hqtKrbq6WilWT0Fm8zOzEqZvgqq20fR58OzqhSydyyqIl7XjnGw0J79WWAZSFFZ5hCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302728; c=relaxed/simple;
	bh=mmDHLVQATxXaUUBemVFIlDTAXbgGe26w07vGcZxAVLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0nHpREqE223WyEJnsASBnBur/qj8eTD65ZDxnO4G2taV4IXp5nFdiX51v615oZs0hMMfcN6tkaCnT0XxH8C0wXx9udt5pwb6Ks+FHv+mSz4R0S6kyeDqHvmyMqA9Vc0uyvofwAux5eescPY6toF+PfIuOoWDeD/JZH436nO7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pnsMgMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pnsMgMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBE81F000E9;
	Wed, 20 May 2026 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302727;
	bh=lb1il2AJhRROtrJr6jsIBAM0wGHyFXH/rIq34Nhb33g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pnsMgMR2kNq0rzDXM7Rd1g46SCF5GsFYlk4Cc44d8iixrkNFtsB2Hw0rBhTrlBiu
	 pj62Ky3rS8aD7do74MirTbFBS6YvCyEanHxwJfWqeMp+NFm313YVrhbyLnEKWHFzwX
	 0VW7XAIAzsYjq2Z2mx6HFsgfnlSquJBS3QNp3WGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 376/508] spi: rockchip: Read ISR, not IMR, to detect cs-inactive IRQ
Date: Wed, 20 May 2026 18:23:19 +0200
Message-ID: <20260520162106.770356465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: John Madieu <john.madieu@gmail.com>

[ Upstream commit b4683a239a409d65f88052f5630c748a8ba070cd ]

rockchip_spi_isr() decides whether the current interrupt was the
cs-inactive event by reading IMR:

	if (rs->cs_inactive &&
	    readl_relaxed(rs->regs + ROCKCHIP_SPI_IMR) & INT_CS_INACTIVE)
		ctlr->target_abort(ctlr);

IMR is the interrupt mask register: it tells which sources are enabled,
not which one fired. In the PIO path, rockchip_spi_prepare_irq() enables
both INT_RF_FULL and INT_CS_INACTIVE in IMR when rs->cs_inactive is true:

	if (rs->cs_inactive)
		writel_relaxed(INT_RF_FULL | INT_CS_INACTIVE,
			       rs->regs + ROCKCHIP_SPI_IMR);

so the IMR check is always true once cs_inactive is enabled, and every
PIO interrupt - including normal RF_FULL completions - is dispatched to
ctlr->target_abort(), aborting the transfer. The bug is reachable on
ROCKCHIP_SPI_VER2_TYPE2 in target mode with a DMA-capable controller
when the transfer is short enough to fall back to PIO
(rockchip_spi_can_dma() returns false below fifo_len).

Read ISR (which is RISR masked by IMR) so the check actually reflects
which interrupt fired, and parenthesise the expression for clarity while
at it.

Fixes: 869f2c94db92 ("spi: rockchip: Stop spi slave dma receiver when cs inactive")
Signed-off-by: John Madieu <john.madieu@gmail.com>
Link: https://patch.msgid.link/20260425092936.2590132-2-john.madieu@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 9e160cba1ff37..03a11aed055ee 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -352,7 +352,8 @@ static irqreturn_t rockchip_spi_isr(int irq, void *dev_id)
 	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 
 	/* When int_cs_inactive comes, spi target abort */
-	if (rs->cs_inactive && readl_relaxed(rs->regs + ROCKCHIP_SPI_IMR) & INT_CS_INACTIVE) {
+	if (rs->cs_inactive &&
+	    (readl_relaxed(rs->regs + ROCKCHIP_SPI_ISR) & INT_CS_INACTIVE)) {
 		ctlr->target_abort(ctlr);
 		writel_relaxed(0, rs->regs + ROCKCHIP_SPI_IMR);
 		writel_relaxed(0xffffffff, rs->regs + ROCKCHIP_SPI_ICR);
-- 
2.53.0



