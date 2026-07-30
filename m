Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5593D441600;
	Thu, 30 Jul 2026 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428107; cv=none; b=WyVj/qik/PyBsU1VH29rcAIRnuY0Kf0Y0cwRNaLPJdTW2fYZOsJsBOXBo5oDyFuTiH4wzH737SAfwhYAx0k4+ly/wSzVIM3tBw4eXPgrvAR4TkyKk4PYp1qzuec/oWTFRU8b7EuvsAjqamZlt2Zdjex+K/uj1WUA1LJGs3ydXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428107; c=relaxed/simple;
	bh=M84XjLIz9x6PCHIT1ImHcFcZzdGYcdbPC98EwEkK2sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tqv2URF9mLGwrAduw7usaKIOvGtjSBP2aWNRqLf4r9kA+gl7hzzDCzPtK8RDRPyYfXHZrOZCLESK7dfRIrKBGpOWxsN7Lmp5H188pnvc6I3FDyYPeJk+efuaWggBT7hJwjf5sA5wX1VDlXpRISu5+ob3o/n7TVeSfKtmR1LMNTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI4HF76y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI4HF76y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ACB1F00A3D;
	Thu, 30 Jul 2026 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428105;
	bh=DKChAEeXIVGb+uHjTvy1k47I3q3YX++7VXjr0zb21mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wI4HF76ydGQOwu5ZfyML1upYkwCu69lC/tmraFk6q8hiCWwetqWjqROpXnsko5DHX
	 htcgVWX0EVc/V3laGI+EumrBB1mUhhxOk1g9+MKrB2Pmkg/XfNc0Hux/zEin0JNgiU
	 WIkkb2sCfHvu+pfYoZqu8bVBW64Bj2mLXNRB+4ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/484] ASoC: mediatek: mt8183: Check runtime resume during probe
Date: Thu, 30 Jul 2026 16:15:01 +0200
Message-ID: <20260730141432.250721999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit f0334fbfd107682d0c95f3f71e25f6127038e2b9 ]

The MT8183 AFE probe uses pm_runtime_get_sync() before reading hardware
defaults into the regmap cache, but does not check whether runtime resume
failed. If regmap_reinit_cache() then fails, the temporary runtime PM
usage count is also not released.

Use pm_runtime_resume_and_get() so resume failures abort probe without
leaking a usage count, and release the temporary reference before
handling the regmap cache result.

Fixes: a94aec035a12 ("ASoC: mediatek: mt8183: add platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-mt8183-probe-cleanup-v1-2-4f4f5593c8d1@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -1149,17 +1149,21 @@ static int mt8183_afe_pcm_dev_probe(stru
 
 	/* enable clock for regcache get default value from hw */
 	afe_priv->pm_runtime_bypass_reg_ctl = true;
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret) {
+		afe_priv->pm_runtime_bypass_reg_ctl = false;
+		goto err_pm_disable;
+	}
 
 	ret = regmap_reinit_cache(afe->regmap, &mt8183_afe_regmap_config);
+	pm_runtime_put_sync(dev);
+	afe_priv->pm_runtime_bypass_reg_ctl = false;
+
 	if (ret) {
 		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
 		goto err_pm_disable;
 	}
 
-	pm_runtime_put_sync(&pdev->dev);
-	afe_priv->pm_runtime_bypass_reg_ctl = false;
-
 	regcache_cache_only(afe->regmap, true);
 	regcache_mark_dirty(afe->regmap);
 


