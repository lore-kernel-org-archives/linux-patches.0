Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF6A5158A4;
	Wed, 30 Sep 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782575; cv=none; b=LsdSo9y9b5STtgOpBgYlo42FdiRiW0SpP+2k9koFepjyN2irMoZroOpb/CPxSUnnDhDoPgvEwJ+VSik3uDAXz1k//bggkO2Du7wJCejMfmzcsVxtIRvE1nlWJcq8agxG4FDpkhhQGlj3OA5S2QmiwStst363lcVqIj6jocxyZBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782575; c=relaxed/simple;
	bh=NNIxCsJEttwm7s5gDIcMBEsQuCEfQkJ5VEDen6VQs7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR4YXD6qoVvEWbMOJwwm9fn0frrxyp0VRi2SFCJvpOWkBbrof+jtUf10RjmfmDtx8y5GX5S9+cHVXbJuC8/kOU1oJN/7/oRvaI7P+tMwkmfbInTqLyL8v2+ADingOkUORoWPwuLAYc6LiO0WsOB4eESmXoQIFCRilKSgo/zmQew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/IXEHbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/IXEHbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C021F0089A;
	Wed, 30 Sep 2026 15:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782561;
	bh=7RXB1SOJnekXEoybbbq3e8fQnsHJX33uciGJvgbM4VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/IXEHbwbw+vzIs/Ajc0qi9xS9RChfqVqY4Lvq8pglP0d8MWqfvekF5Pl0Gzyzk6R
	 6Ykb3JpSMFWoSe3JGcmJTJRlm/qr+7lcelds364OxnwsVAFLIkY5TsnfmXOSjrF/+d
	 h/dV6lfCLbYZJXrcH5h21z5nm5oeF+680NZUC95o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/595] ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive
Date: Wed, 30 Sep 2026 17:19:43 +0200
Message-ID: <20260930152349.673995696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 821e7395f90f6..1056a38992cf1 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -813,15 +813,6 @@ int pcm3168a_probe(struct device *dev, struct regmap *regmap)
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
@@ -833,10 +824,12 @@ void pcm3168a_remove(struct device *dev)
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
 
@@ -892,7 +885,8 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 	regcache_cache_only(pcm3168a->regmap, true);
 
-	pcm3168a_disable(dev);
+	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+	clk_disable_unprepare(pcm3168a->scki);
 
 	return 0;
 }
-- 
2.53.0



