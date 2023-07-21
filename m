Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A0A20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DA5C433C7;
	Fri, 21 Jul 2023 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966515;
	bh=/qWJng5jEq1NWC8v/HXTW4fqXz0ACcuIAK+LqHxErho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD1AUui+KtLInMWZ2VXyObMW5Y+xUz/9SxieqV0YuN8Db0R70m+X5PeRYWrRATzKl
	 LYm44N0Tp08+SNDIcY3iqe4ug11gP1NvUx620pA3mSEa0XCcHH+fWrVJTy3YqqNE9L
	 8Uy+HPl4tsmawEep4TpK5Zl04lUvL/IbylXpnD2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	stable@kernel.org,
	Ricardo Ribalda Delgado <ribalda@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 371/532] ASoC: mediatek: mt8173: Fix irq error path
Date: Fri, 21 Jul 2023 18:04:35 +0200
Message-ID: <20230721160634.606691897@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda Delgado <ribalda@chromium.org>

commit f9c058d14f4fe23ef523a7ff73734d51c151683c upstream.

After reordering the irq probe, the error path was not properly done.
Lets fix it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@kernel.org
Fixes: 4cbb264d4e91 ("ASoC: mediatek: mt8173: Enable IRQ when pdata is ready")
Signed-off-by: Ricardo Ribalda Delgado <ribalda@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230612-mt8173-fixup-v2-2-432aa99ce24d@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
+++ b/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
@@ -1072,6 +1072,10 @@ static int mt8173_afe_pcm_dev_probe(stru
 
 	afe->dev = &pdev->dev;
 
+	irq_id = platform_get_irq(pdev, 0);
+	if (irq_id <= 0)
+		return irq_id < 0 ? irq_id : -ENXIO;
+
 	afe->base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(afe->base_addr))
 		return PTR_ERR(afe->base_addr);
@@ -1177,14 +1181,11 @@ static int mt8173_afe_pcm_dev_probe(stru
 	if (ret)
 		goto err_cleanup_components;
 
-	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id <= 0)
-		return irq_id < 0 ? irq_id : -ENXIO;
 	ret = devm_request_irq(afe->dev, irq_id, mt8173_afe_irq_handler,
 			       0, "Afe_ISR_Handle", (void *)afe);
 	if (ret) {
 		dev_err(afe->dev, "could not request_irq\n");
-		goto err_pm_disable;
+		goto err_cleanup_components;
 	}
 
 	dev_info(&pdev->dev, "MT8173 AFE driver initialized.\n");


