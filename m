Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323F35BDAA;
	Thu, 30 Jul 2026 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426668; cv=none; b=BNjbF+Ni8RXIIdT7aVk0HOj/dSFlPJ45Rz3rB/ifGiQi4RzbjHlBc4E8GEc6QBdzGAAaa08JT3EnqinGJs76k5q90SbQGGABJHOcRQSSAyng6zjMxFAK29Ne1k17hsno3xRz3ZBzQ2ltKNVxmk7Wet+OpcPMnklbl5ftArSMnIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426668; c=relaxed/simple;
	bh=SUmfPp3ToF3rfXvvkwXd0b7/CnSPq0QTCDGqhsOOPd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AduQWzO/w/xR1vQ3omRugHLaok7P7nWBHIFYqEZlwjd0UJtEHx2xWAzUHySqXoU/AKoZb3+U6iYf8gRZpcnPUjnnBuz1bgbNhmQL01hYJRKtd2tz2UmlbW+RdDM0AY6QwE8oeDeRCXmnWu+1NsrAAx9lwfGublIYupbTcVTCn+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pJrkgbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pJrkgbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8BE1F000E9;
	Thu, 30 Jul 2026 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426667;
	bh=icMv/CN4T28fDAGp3lgmAm8bGIpsxtV/pm3QKtGZoog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pJrkgbYRkaPnHp2a5oGnWM+69gngSG4+bwKDjvSRtyOoUPR5HaOQp++q7eyu0h+g
	 diTblcS4Qfg2jk2bJA8a1fuuCix54J6FiCNl/CTReFWqjCp1y5YIloGpCb0YaYQn6W
	 5jBmqAQa/BhIWMSbUA07EKd8lW0z8olsvA9wOs8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/602] ASoC: mediatek: mt8192: Check runtime resume during probe
Date: Thu, 30 Jul 2026 16:14:51 +0200
Message-ID: <20260730141446.466549497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


