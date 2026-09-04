Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937E83515D2;
	Fri,  4 Sep 2026 05:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498364; cv=none; b=EUFggOX0XdaF0z117faWaaV+RH+N79sWYN7ZDkyzTQ/hH6BcwvHaEG6r3qA3P4N1DP+FkMnJO5YcrMrVzaAn4fBrq/3HriNsjH6tq4SNvlRuLnh6IxOzZVcOdaNcb5JKv8oklQ6vNpjzsXQJVUlZJjTGOxbt3LpC7c4ANvAfkn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498364; c=relaxed/simple;
	bh=Mr5iUff1ElxNHciB/H5xbGvf7Y2bPEjcxiBRX3JaW+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvXwngAHiwLxS4SGcpiBt+A//iUE3GpL6N8v/4xsXxUq2G0zH0N7B8HDG4uVHc2vIfRhRl2YQT/xTIP1pDtAyLElUL0uI1TY9ZL6MFFKk0dl5vrxlmupzM1Lxlr07WAg6g9uAb3dSgUPYd1U/8rn2sjXm/R9Hv+dphUxOu4JfQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyziUWuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyziUWuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE54A1F00A3D;
	Fri,  4 Sep 2026 05:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498363;
	bh=qP/QhIaeVYQ01i3R2vHOVnp7kaMltW5rCyzdhaXgO6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyziUWuIW1HeHYZ2ets1AYWZiWUTAJn7FI8FNEGZY57Qx+rykqbYgd9lajEU2mG07
	 fOEtNoIffucTBcSE85eLTMASdmFPlMsCgbokjEvQ/PoOIqP0CMmeDneMp2gK0g3lhI
	 fWYaY8ItwEjQj9n1WMjV9lRBRbEZGE94RX39sLQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 006/713] ASoC: tegra: Fix the MIXER enable default value
Date: Fri,  4 Sep 2026 06:49:34 +0200
Message-ID: <20260904045803.960222834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 5442b8093a2f94ecd4696b3875194be09e2676c5 ]

Commit 4b05ccb17f92 ("regcache: Sort the local copy of an unsorted
reg_defaults array") exposed an issue in the Tegra MIXER driver where
the register default for the TEGRA210_MIXER_ENABLE is specified as 1,
but the hardware default is actually 0. After this commit was added the
MIXER driver is no longer working and so fix this by correcting the
default value for this register and explicitly configuring the
MIXER_ENABLE register when runtime resuming the MIXER device.

Fixes: 05bb3d5ec64a ("ASoC: tegra: Add Tegra210 based Mixer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260821153734.158426-3-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_mixer.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/tegra/tegra210_mixer.c b/sound/soc/tegra/tegra210_mixer.c
index 8eb4e54b954b1..96259a6cbc59b 100644
--- a/sound/soc/tegra/tegra210_mixer.c
+++ b/sound/soc/tegra/tegra210_mixer.c
@@ -57,7 +57,7 @@ static const struct reg_default tegra210_mixer_reg_defaults[] = {
 	MIXER_TX_REG_DEFAULTS(3),
 	MIXER_TX_REG_DEFAULTS(4),
 
-	{ TEGRA210_MIXER_ENABLE, 0x1 },
+	{ TEGRA210_MIXER_ENABLE, 0x0 },
 	{ TEGRA210_MIXER_CG, 0x00000001},
 	{ TEGRA210_MIXER_GAIN_CFG_RAM_CTRL, 0x00004000},
 	{ TEGRA210_MIXER_PEAKM_RAM_CTRL, 0x00004000},
@@ -86,11 +86,15 @@ static int tegra210_mixer_runtime_suspend(struct device *dev)
 static int tegra210_mixer_runtime_resume(struct device *dev)
 {
 	struct tegra210_mixer *mixer = dev_get_drvdata(dev);
+	int err;
 
 	regcache_cache_only(mixer->regmap, false);
-	regcache_sync(mixer->regmap);
+	err = regcache_sync(mixer->regmap);
+	if (err)
+		return err;
 
-	return 0;
+	return regmap_write(mixer->regmap, TEGRA210_MIXER_ENABLE,
+			    TEGRA210_MIXER_EN);
 }
 
 static int tegra210_mixer_write_ram(struct tegra210_mixer *mixer,
-- 
2.53.0



