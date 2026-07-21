Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35093415F2C;
	Tue, 21 Jul 2026 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658528; cv=none; b=WDCPnMhVIz71KeC3p2f70MsRGPBGXjSABBM5gV0cQn/P8EWbAcmlThsgmFTZfS6jz0ot40z0RCBU4PuQHBJRjbETjsGCE4Ur/QVZUbvsjUEiRT/3Dl9Qy8DDcm9B3A/w1qEsNTQoEQ7prhZBeK+oLHNhrcJEZVas/aNc6JgNQfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658528; c=relaxed/simple;
	bh=FnMY+HVLo29ir41SOQNIcb4Knm7XOpnPD/UzwWOr0os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/Jhnn3A9xO2jgGLPynk7Yp10JrKmfPNc59oCQKlVAiuudZbwuI54P5VqG7lJFw6B8hTaxFrjme1dJ8IFTUGaXrILt4LVlRlYTU2pjFy6xCy5b0TpHHAduA0LriN9/53S4ks0hdznyC/fKsKU/KpWcf+NmF0aV1ESMUwkfEEibM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDkyqYTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDkyqYTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306AB1F000E9;
	Tue, 21 Jul 2026 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658526;
	bh=lwm5RAgjwLW0uL/lRB2B7doqe/CVsAqw2My3YciKe5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDkyqYTDFZWv3t1ZJRR+8agBN97bUUAU1srxRlyLg7HpHxzmM772f/E4IA+4pu/zk
	 VMCFcR7yukK6QIn2BYcQL9dxPsHrieKaEXKHD/V2Xyx/DPhvBlqrnAvnVecYer9aP8
	 gfBFmbvjpplY7Q+5GIWpKCcov9oN28mojAEZEjhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1160/1611] ASoC: mediatek: mt8192: Check runtime resume during probe
Date: Tue, 21 Jul 2026 17:21:16 +0200
Message-ID: <20260721152541.515722504@linuxfoundation.org>
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

commit e24d5dde56a50946020b134fa8448869093db76a upstream.

The MT8192 AFE probe enables runtime PM temporarily while reinitializing
the regmap cache from hardware, but it uses pm_runtime_get_sync()
without checking the return value. If runtime resume fails, probe keeps
going without the device necessarily being accessible, and
pm_runtime_get_sync() may leave the PM usage count incremented.

The regmap_reinit_cache() failure path also returns before dropping the
temporary PM reference and before clearing pm_runtime_bypass_reg_ctl.

Use pm_runtime_resume_and_get() so resume failures do not leak a usage
count, and clear the temporary bypass flag after dropping the probe PM
reference on all regmap_reinit_cache() outcomes.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-mt8192-probe-cleanup-v1-2-1bb834d05b72@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2218,15 +2218,19 @@ static int mt8192_afe_pcm_dev_probe(stru
 
 	/* enable clock for regcache get default value from hw */
 	afe_priv->pm_runtime_bypass_reg_ctl = true;
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret) {
+		afe_priv->pm_runtime_bypass_reg_ctl = false;
+		return dev_err_probe(dev, ret, "failed to resume device\n");
+	}
 
 	ret = regmap_reinit_cache(afe->regmap, &mt8192_afe_regmap_config);
-	if (ret)
-		return dev_err_probe(dev, ret, "regmap_reinit_cache fail\n");
-
 	pm_runtime_put_sync(dev);
 	afe_priv->pm_runtime_bypass_reg_ctl = false;
 
+	if (ret)
+		return dev_err_probe(dev, ret, "regmap_reinit_cache fail\n");
+
 	regcache_cache_only(afe->regmap, true);
 	regcache_mark_dirty(afe->regmap);
 


