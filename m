Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6071C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FCFC433D6;
	Wed, 23 Nov 2022 09:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196650;
	bh=90aVWfwcPrhXzSwRmUFwqeSi/8RLZIehIt37+0iqUnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHX/COIxJpAa1xwCWwhpPMLJMQfK0lKkiMzfI3jBLzlfUTAKO8+kIsKRcLeob5fPL
	 cCXVCpiuaH46hDx8zQzdoWfUWf0XblBAhgP+lM0lisfpkDd5ootEOZZheOyEOaqvVB
	 xcjoRdOyLhuoOy3In/tGYw8ANnmTH40WzoADpVU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Zanders <maarten.zanders@mind.be>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 089/314] ASoC: fsl_asrc fsl_esai fsl_sai: allow CONFIG_PM=N
Date: Wed, 23 Nov 2022 09:48:54 +0100
Message-Id: <20221123084629.514642398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maarten Zanders <maarten.zanders@mind.be>

[ Upstream commit 6a564338a23cefcfc29c4a535b98402d13efdda6 ]

When CONFIG_PM=N, pm_runtime_put_sync() returns -ENOSYS
which breaks the probe function of these drivers.

Other users of pm_runtime_put_sync() typically don't check
the return value. In order to keep the program flow as
intended, check for -ENOSYS.

This commit is similar to commit 0434d3f (omap-mailbox.c).

Fixes: cab04ab5900f ("ASoC: fsl_asrc: Don't use devm_regmap_init_mmio_clk")
Fixes: 203773e39347 ("ASoC: fsl_esai: Don't use devm_regmap_init_mmio_clk")
Fixes: 2277e7e36b4b ("ASoC: fsl_sai: Don't use devm_regmap_init_mmio_clk")
Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20221028141129.100702-1-maarten.zanders@mind.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 2 +-
 sound/soc/fsl/fsl_esai.c | 2 +-
 sound/soc/fsl/fsl_sai.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index aa5edf32d988..d90adb6ee43d 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1224,7 +1224,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_asrc_component,
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 5c21fc490fce..17fefd27ec90 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -1069,7 +1069,7 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	regmap_write(esai_priv->regmap, REG_ESAI_RSMB, 0);
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index d430eece1d6b..887063f9cbea 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1415,7 +1415,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
-- 
2.35.1



