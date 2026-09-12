Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9706F27FB37;
	Sat, 12 Sep 2026 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228911; cv=none; b=gwwIA+uNy29r5woYLkqbt1LyGMEYDYRqJSpwKSXZ9FeA63wn/zDhg70j2NglXYxIOaqa6+RgMzkw7scGASgjyASZtDzjoacrTVoIR430T9GjQ3z8aJvvcuv/vO4dRzgvZyB9SIx9Oi3cYXLS91NXqL85ICVozqMQc8UxCW/tBEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228911; c=relaxed/simple;
	bh=lRWsC2v732BtwcNuB3UDD2MOk0IX2yQ0baw3zSaWMg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP0a37eDuM0YJNsLPCF897n89FW8FlBOECjiV/6M7FMPreY8FUrxa9jLkYEvZw9ILq+3w/L0x1U7B35fPnG47ei+7e/S6KVQIN+xgvq030nWn7UPiforimnJPGaM0AwBCEgNdBX1I5bIKFlR1YgcDfjPFll97u/3ngee4OkS7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EB7OlVE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EB7OlVE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE61F000FF;
	Sat, 12 Sep 2026 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228910;
	bh=DUqRQfrRu/4vZCV2VCjjIE80tJKqDa/VuV52TAc1G+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB7OlVE8fduktaAIZWkOxrePk5+ey+TjlegxyM+XIf0tljksC0koGorqBy/mWMB2t
	 h6rBCty7m+PpHb1d6OEU7f0sJvLx017NfiNNySDeMMYrmPG/gZAAxcPuxxGaaarOs0
	 erJGjNfVcK13nUHW7WPg+wqVqbOUqeM9romXS9Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0482/1191] ASoC: fsl_audmix: rework runtime PM handling in probe
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065559.058083409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 3359ba93d01a23b2e4249e9e44ccfe48eb9c5d71 ]

After pm_runtime_enable() the AUDMIX block is powered off and stays
suspended until the first runtime resume. Register writes issued between
probe() and the first resume (e.g. from DAPM or ALSA control paths)
target unpowered hardware and cause a system hang.

Fix this by calling pm_runtime_resume_and_get() immediately after
pm_runtime_enable() to power the hardware up and enable its clocks.
Release the reference afterwards with pm_runtime_put() to allow the
runtime PM framework to suspend the device and switch the regmap to
cache-only mode when idle.

When CONFIG_PM is disabled or runtime PM is not enabled, pm_runtime_*
calls are stubs that do not power up the hardware. Handle this case
explicitly by calling fsl_audmix_runtime_resume() directly so the
hardware is always initialised and its clocks are enabled, ensuring
register accesses succeed regardless of PM configuration.

Fixes: be1df61cf06ef ("ASoC: fsl: Add Audio Mixer CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260618023818.31618-1-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_audmix.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_audmix.c b/sound/soc/fsl/fsl_audmix.c
index f391fc95daa7f..7a4b01d493dbf 100644
--- a/sound/soc/fsl/fsl_audmix.c
+++ b/sound/soc/fsl/fsl_audmix.c
@@ -458,6 +458,9 @@ static const struct of_device_id fsl_audmix_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, fsl_audmix_ids);
 
+static int fsl_audmix_runtime_resume(struct device *dev);
+static int fsl_audmix_runtime_suspend(struct device *dev);
+
 static int fsl_audmix_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -489,13 +492,25 @@ static int fsl_audmix_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
 	pm_runtime_enable(dev);
+	if (!pm_runtime_enabled(dev)) {
+		ret = fsl_audmix_runtime_resume(dev);
+		if (ret)
+			goto err_disable_pm;
+	}
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		goto err_pm_get_sync;
+
+	/* To enable regmap cache only when runtime PM enabled */
+	pm_runtime_put(dev);
 
 	ret = devm_snd_soc_register_component(dev, &fsl_audmix_component,
 					      fsl_audmix_dai,
 					      ARRAY_SIZE(fsl_audmix_dai));
 	if (ret) {
 		dev_err(dev, "failed to register ASoC DAI\n");
-		goto err_disable_pm;
+		goto err_pm_get_sync;
 	}
 
 	/*
@@ -507,12 +522,15 @@ static int fsl_audmix_probe(struct platform_device *pdev)
 		if (IS_ERR(priv->pdev)) {
 			ret = PTR_ERR(priv->pdev);
 			dev_err(dev, "failed to register platform: %d\n", ret);
-			goto err_disable_pm;
+			goto err_pm_get_sync;
 		}
 	}
 
 	return 0;
 
+err_pm_get_sync:
+	if (!pm_runtime_status_suspended(dev))
+		fsl_audmix_runtime_suspend(dev);
 err_disable_pm:
 	pm_runtime_disable(dev);
 	return ret;
@@ -523,6 +541,8 @@ static int fsl_audmix_remove(struct platform_device *pdev)
 	struct fsl_audmix *priv = dev_get_drvdata(&pdev->dev);
 
 	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		fsl_audmix_runtime_suspend(&pdev->dev);
 
 	if (priv->pdev)
 		platform_device_unregister(priv->pdev);
-- 
2.53.0



