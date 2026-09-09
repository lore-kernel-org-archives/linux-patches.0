Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2ED584972;
	Wed,  9 Sep 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963795; cv=none; b=Cd9yCLvf8Qe0JNElbRRNJHfpVwTlMyC0y48RGjlTKl6tHVYfdaW7q2AAwAn06K2q640iyqVXiswaKvIxgZsB0PbFAiZ/LhrQkdDnPxdjyhxEL2BCn83AC882FuvkW8p5nyUdcNkEsDpOlWL37gpYCfPdq9Rk1MaI/tWu6kUxodc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963795; c=relaxed/simple;
	bh=rFTFLq5Hmxx0J76nlJuXrW2FTNhXYXWsfE8GTiNGreE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFuhPO+eVXoY4SPVz9c6H+CiEe5pgc+SXwkyTzZV1R5BI1Ci18sKyk7WGBi+1LoJFVe+dHxF6wrdcpVE53dButrNCO1zU5dGV8Wq0Bwbadd+L8HujNqinGGJdcMrkNgspjamd9m/YjkkJRKv/Z2Pi8KYyfzy2QatDVqqYHAjNkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=By/fySyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="By/fySyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DBC1F00A3F;
	Wed,  9 Sep 2026 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963793;
	bh=23lkKNdKSLO5dX2nZJ+ujiNDpz5PQu19dyCHH6g6cZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=By/fySyzdZTC9Oxf9t/CG0LixACpvK/mqUwcvU63MyXk+74+GYJB26FpPxw278nb9
	 xw6YHN0o5m78EDoiAbie3N3xcjC4v0Kx/PAKJyS5eCQqJEFe40m6Ci3QeqEqq/Az0R
	 1qzK1i4olYgN3L3AdsmyAUa7npeZ9fyJyQQ/rFAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 200/583] ASoC: tegra: Fix the MIXER enable default value
Date: Wed,  9 Sep 2026 15:38:05 +0200
Message-ID: <20260909134245.081375953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

commit 5442b8093a2f94ecd4696b3875194be09e2676c5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_mixer.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/sound/soc/tegra/tegra210_mixer.c
+++ b/sound/soc/tegra/tegra210_mixer.c
@@ -57,7 +57,7 @@ static const struct reg_default tegra210
 	MIXER_TX_REG_DEFAULTS(3),
 	MIXER_TX_REG_DEFAULTS(4),
 
-	{ TEGRA210_MIXER_ENABLE, 0x1 },
+	{ TEGRA210_MIXER_ENABLE, 0x0 },
 	{ TEGRA210_MIXER_CG, 0x00000001},
 	{ TEGRA210_MIXER_GAIN_CFG_RAM_CTRL, 0x00004000},
 	{ TEGRA210_MIXER_PEAKM_RAM_CTRL, 0x00004000},
@@ -86,11 +86,15 @@ static int tegra210_mixer_runtime_suspen
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


