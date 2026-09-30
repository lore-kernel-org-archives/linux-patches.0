Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4744C651B;
	Wed, 30 Sep 2026 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784375; cv=none; b=mFuekJmweHVcYj9GIVcT+k6+oTnvBZAIx25/mlqc7VIF+gbyAGgjvATEfGG6kpD7/nsk0m2baEU+/3PG1yfdRHvg92nP+f6zaUSfI0V+CqzaWBevn6KmhKuZtDFpQYGgPkrDGRFGs7omro+MpEzuN3m3sVfwa+C1LkgEMj0X3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784375; c=relaxed/simple;
	bh=5hoKGIa6kCuyeuK1b4bbfUiR55hLAoE9JqgHfiEQr2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2lSaYUHtMfmSwPo3JYp/xE9dtvw7OCC/FdySoj0Y64EaDwytyEvXnm0EZ9+4V/oWvxXiRqeIJwU5iEv8DDvlhnbkxygO6NgC829W7PTxiTbcgM9wLnpYOp48arEGoaxaw65pFwXCGTtUjeLIl0KZtiGrKrhHuXaZRizICY3QxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgrIivbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgrIivbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A9C1F00898;
	Wed, 30 Sep 2026 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784371;
	bh=tKbs1spoyGJl+BysBlltts38oEkdMP09x0CF4LizAW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgrIivbzcgunEGDGIs8M5hRfJJmORLL5bGgor0PYwNB15EFcIdS5sBVFXC/c1kc2S
	 0Tsse54q1Pd6ImiGY4nVp4SJcrQSrTjEPelATg08SySV9VQ6PshsZVJEPkDLsbsmNn
	 m6YQEAbcOTyKZ9sSsUZEV8PSrANqeHvHdd/hnRGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/982] ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive
Date: Wed, 30 Sep 2026 17:14:29 +0200
Message-ID: <20260930152419.672024687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit eb7107264da8545ba7381a76818bae553e1fd1e4 ]

Revert changes done in commit 489db5d94150 ("ASoC: pcm3168a:
Don't disable pcm3168a when CONFIG_PM defined") and add
pm_runtime_status_suspended() check.

The suspended-check addresses regulator's "unbalanced disables"
warning during driver removal even when CONFIG_PM is enabled.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260525201801.1336936-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 329549936bd5c..e5ac1146588cc 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -820,15 +820,6 @@ int pcm3168a_probe(struct device *dev, struct regmap *regmap)
 }
 EXPORT_SYMBOL_GPL(pcm3168a_probe);
 
-static void pcm3168a_disable(struct device *dev)
-{
-	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
-
-	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies),
-			       pcm3168a->supplies);
-	clk_disable_unprepare(pcm3168a->scki);
-}
-
 void pcm3168a_remove(struct device *dev)
 {
 	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
@@ -840,10 +831,12 @@ void pcm3168a_remove(struct device *dev)
 	 * The asserted level of GPIO_ACTIVE_LOW is LOW.
 	 */
 	gpiod_set_value_cansleep(pcm3168a->gpio_rst, 1);
+
 	pm_runtime_disable(dev);
-#ifndef CONFIG_PM
-	pcm3168a_disable(dev);
-#endif
+	if (!pm_runtime_status_suspended(dev)) {
+		regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+		clk_disable_unprepare(pcm3168a->scki);
+	}
 }
 EXPORT_SYMBOL_GPL(pcm3168a_remove);
 
@@ -899,7 +892,8 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 	regcache_cache_only(pcm3168a->regmap, true);
 
-	pcm3168a_disable(dev);
+	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+	clk_disable_unprepare(pcm3168a->scki);
 
 	return 0;
 }
-- 
2.53.0



