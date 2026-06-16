Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B3B34751B;
	Tue, 16 Jun 2026 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636560; cv=none; b=kj7terqpdel/8rd88v3mFCHMnYp+utqOTOm1sy+sKaNk0SY2Wi7uWHJt66DLEXs9Yu3eKwGD6kqFz0ktj+mvGPhU20NPgg0fbHpY7EEcbSxuQKAygvZuTDPrBhlnTpfJVwQ27mFDoAu8nQsn9DQputHNsh/JHSVuTWc0/j1qxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636560; c=relaxed/simple;
	bh=0bvZKuRaNu+M44H7sp9BQcczf0q0qGHqoF10usMXYIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUtkHAEV17zcheL9Q5Zdy/rHDLB+lqYBEbk7OePzkxqseQcLHiZEWKbTjy/RCcMXnp2uKnRsiJqbLam57PJcJGmozXHHranE+Hl4FDa5maOxnZpa4HTGQahoeXdR7IBY/wJ1LX4UOM52LkyAYZvmt4ccjPBw/a/R3xNbtaUJXyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKVC1tWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKVC1tWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E8E1F000E9;
	Tue, 16 Jun 2026 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636559;
	bh=Nw1h7g65ohoaiU2vYmSbNkWS959sGvuXEmEAFBQ5MyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKVC1tWkEYcotDeYopNaHgCSEbRUA0RBu7H+ca4PnEej4Zvb/FfJkKCBXEUDNAHqt
	 cm1DMtxB3nr+ltSO6f37tpNUDIOfBtEdefyb/uYhX+UnAgRhes0b2qfa4i66Fa00Cj
	 XlI7TwNKyhLGdzeqpG2jZXUcnquFiigm8udetwZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keiji Hayashibara <hayashibara.keiji@socionext.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/342] spi: uniphier: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:19 +0530
Message-ID: <20260616145100.518008142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0245435f777264ac45945ed2f325dd095a41d1af ]

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Note that clocks were also disabled before the recent commit
fdca270f8f87 ("spi: uniphier: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Cc: stable@vger.kernel.org	# 4.19
Cc: Keiji Hayashibara <hayashibara.keiji@socionext.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-25-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_*_controller/host APIs to spi_*_master/master aliases and kept the pre-existing clk_disable_unprepare() after unregister ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -751,7 +751,7 @@ static int uniphier_spi_probe(struct pla
 
 	master->max_dma_len = min(dma_tx_burst, dma_rx_burst);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret)
 		goto out_release_dma;
 
@@ -780,6 +780,10 @@ static int uniphier_spi_remove(struct pl
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct uniphier_spi_priv *priv = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	if (master->dma_tx)
 		dma_release_channel(master->dma_tx);
 	if (master->dma_rx)
@@ -787,6 +791,8 @@ static int uniphier_spi_remove(struct pl
 
 	clk_disable_unprepare(priv->clk);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


