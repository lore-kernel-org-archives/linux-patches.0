Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215001;
	b=NQZsudIBk7nYNBI7xP9woQ/aB1+t3vt/HdzcwqYBRLsIDtL42aTGLmmgs1hpFctUL47U
	 ySkJM1+uAKfbperd36TFt0p+vgh3D5I/UFWFjzAOTiy0V+0ZWalLdTizbwgKcUpyWDXXq
	 OGuVdp6/JqIQcg1S89YEqqlhksMZhhV+mnbEMiXaqhDPYWOCsyooxUZYvviA5CL7RIuM7
	 fpZb/5pwPv+FVOGqLss6VAVLRCIL6rD9co7k6A0/MVxlLY2INOiBBFdsuyX4cA4XvBxIR
	 OATmTOW7lgnKX3OuH+1XXoJINze3ucZfBy0OI7t/962QY7s4v33j3a+ojUI+btM6Bfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KWehr2oqtQZN2XVxcbEb+xpSJD/D2R5Pdh/PmR6qBzw=;
	b=KldoNwU/vjIx6NoFyFDjlRHnhoUD47DKsaCP6Z5DTOAvboiV6+taML76BGMc1YkHbi5L
	 pi+gmqma6WVB+spWDO2dCLaQNxAFXwpHMmkjd1WfM35c6C4RxL6bIij5ApnOYodx5Pw6X
	 GNmm/aEN9TRYaDY+y4KGabw+oBm3vCIRzJTQeKx8E7B3Bf3DvfAf2M3Sc7hCtGlkgyELk
	 7WKJ8U1czfCHYZW6wSortwkpisMvmkTR4pBveRyseNExDHqM7u0wASTtSz1VdQ91DUd2e
	 u/bXzAL+rTPUU3VWjZK13Os/4fXBqWrdBoyeN+XdR7JVUjBPZBS5h+VZTBedLJYb06A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fwyXZkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3112606A31E;
	Wed, 28 Oct 2026 19:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fwyXZkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112E81F01825;
	Wed, 28 Oct 2026 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215000;
	bh=KWehr2oqtQZN2XVxcbEb+xpSJD/D2R5Pdh/PmR6qBzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fwyXZkqbRpoQlaWYOSOfDY+ph+fss1as+LtOrcQx5Bn3PmhKLAOTkp+cSROilXkn
	 ZlK9lsZMMjGNuBpR30wOFAi0k+QZdf6uEGgQuow8Bk476+c6hBekXGrr5Xg3pc4IQ7
	 IYzs2DTEWtLBOqkz+CTuMptGoBdDDohQNcL/rUo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1058/1887] spi: rspi: fix controller deregistration
Date: Wed, 28 Oct 2026 17:52:34 +0100
Message-ID: <20261028170523.482335516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9944fa6726afb1e6eb7e2212764e7da0c97f2dcc ]

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 9e03d05eee4c ("spi: rcar: Use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.14
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-11-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index f494c86bafea4..96b4037babbaf 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1176,8 +1176,14 @@ static void rspi_remove(struct platform_device *pdev)
 {
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
+	spi_controller_get(rspi->ctlr);
+
+	spi_unregister_controller(rspi->ctlr);
+
 	rspi_release_dma(rspi->ctlr);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(rspi->ctlr);
 }
 
 static const struct spi_ops rspi_ops = {
@@ -1388,9 +1394,9 @@ static int rspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		dev_warn(&pdev->dev, "DMA not available, using PIO\n");
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "devm_spi_register_controller error.\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto error3;
 	}
 
-- 
2.53.0



