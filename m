Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF8343F8D3;
	Thu, 30 Jul 2026 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428103; cv=none; b=Mf2pM55TUe6yrXgxTt/qi6ezvvQFybs5EFbjqQPaB9dV1tT46rBy+sW1D6nCDXNgI05GXy2RAFyu8x9kJnttXCqot0sM9Ee0G0MOI/h97yn5Qx8A/x9XD+82UvgZ/9+cC7hIfCEQZkqFpnTTWVMrjjY91ppLQ2L1qN2Rx43JQ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428103; c=relaxed/simple;
	bh=gycNdUJPASEANXzCHWwbkDUAMbChf9LEiCYiF7klv1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c60kgd/LOTfSQxbR9JO9T0iN0NIjpR8BDxiiBOgo33iO3KMWiPPzomSb7Aqh1c4evmCjhxG/YF5+vcDIR5PA8g1PCAhxEMXJbyNkHStZb/wefMDRtRX4NwWusUlvqSzUSVvCw6p7tFaedU4jwurxo4DBioeIiAq6Mk4xJjhGOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awmPWHHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awmPWHHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B771F000E9;
	Thu, 30 Jul 2026 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428102;
	bh=nhl+TLlynF0FybPOWf34cr9DfGkHHJnYwBGX2Tm+ohM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awmPWHHtAVZing3RhVpPYx6XXHi15/+6+X0+cge3yGw8kbHeweix26nKSrulkI8M8
	 6p9zHVeoUMbh3AFgveyFE16NF+4MuP32ihoOZ7zsETlr1foEBXVrPanJBMu7xyptjw
	 +AiocWaZ8tECX65tijFXjWtuujdf001s+WOWJ668=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 403/484] ASoC: mediatek: mt8192: Check runtime resume during probe
Date: Thu, 30 Jul 2026 16:15:00 +0200
Message-ID: <20260730141432.229549671@linuxfoundation.org>
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

[ Upstream commit e24d5dde56a50946020b134fa8448869093db76a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2227,15 +2227,19 @@ static int mt8192_afe_pcm_dev_probe(stru
 
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
 


