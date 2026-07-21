Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2418746C4C0;
	Tue, 21 Jul 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658586; cv=none; b=bfQdfvPc1B5drBgsYi9545HwM5M6pkI+HXA5L2VHnQi3GE2ippN2JspDfAD5/c+nNOQGdEY+wLXSMQftIV6w5Mzf+jH7S4Im1FfkJIq/8Z6AuvZPsfmtuNm0YFdzflIdI+owBM4NLL6GCRwtcWFwohtv2hsGUoYp7lEiBgPK9yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658586; c=relaxed/simple;
	bh=SLTgopwXJQmTV43DZSxzIi5E7CI1kOIFb21g2aWDFQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8hdOZGU8l/Pmls2KfmYCiShKreF5KU85nfC67JqUXa/ppIahBOZvMTHeCSpkGXVd0nJL6oxX/WW4LyGMv5aPXmSJ+K9p8853T86sHBxN155wYhOxrhVSPK5VAY/UVrUV1XPKY2aEQnDQOscxsQ8C21VfSGlxtGjTDGZYIquM5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JylfBmFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JylfBmFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CFB1F000E9;
	Tue, 21 Jul 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658585;
	bh=scMPC2OkKyFRknW14o5txc3Q/u5hFlsr0n0dd/FdhOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JylfBmFSqy78A1P8REJZns4IQNwvFSYq69rEgxgJLdqzbGv+bdvo7BK/2qpyxqDni
	 zI1PYlnDuw26nIh7DuJKSjURsiIOtoDhT1DqAnuGrlBRi+O1qK7o45BRybykLgdoqD
	 JVh49YAl1+Jsscd6yE10qyu/ZuxEoqLrCB8k8rQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1162/1611] ASoC: mediatek: mt8183: Check runtime resume during probe
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152541.560347751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit f0334fbfd107682d0c95f3f71e25f6127038e2b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -833,17 +833,21 @@ static int mt8183_afe_pcm_dev_probe(stru
 
 	/* enable clock for regcache get default value from hw */
 	afe_priv->pm_runtime_bypass_reg_ctl = true;
-	pm_runtime_get_sync(dev);
-
-	ret = regmap_reinit_cache(afe->regmap, &mt8183_afe_regmap_config);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
+		afe_priv->pm_runtime_bypass_reg_ctl = false;
 		goto err_pm_disable;
 	}
 
+	ret = regmap_reinit_cache(afe->regmap, &mt8183_afe_regmap_config);
 	pm_runtime_put_sync(dev);
 	afe_priv->pm_runtime_bypass_reg_ctl = false;
 
+	if (ret) {
+		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
+		goto err_pm_disable;
+	}
+
 	regcache_cache_only(afe->regmap, true);
 	regcache_mark_dirty(afe->regmap);
 


