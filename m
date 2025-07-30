Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7920E6;
	Wed, 30 Jul 2025 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868412; cv=none; b=FU+q6Ksv/QNLnOvMqVjPcSZ3VXsmuK4fC/hj9u/66kt8X+gvHAjlowYZcQolc9VCVkcvlEz5gar7NF4QIXTbF1NBcHwtKeY5+18k+m+UTpOpxzytoFe3XLcDqVNBrReoMW3zkp2r+RYxZO/51lMbeB+ip1xqO+b5814As8pU+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868412; c=relaxed/simple;
	bh=cHqABianXIWEePGaHvLYLqLxV7rLTZCMsn58jXLZaK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJFMFgCncfkZdpUKzF/41M6vX5JXfIEwXAdgqfv5QEJbzzUJ+3ikvZ9LDQWcnGhB7qgfDrpRaogYRGC+b5a0EE7cJAPEcDXfT8i2cFCqGEqVYGmxkL6qZV+ZVdu+vRTmLtsqF0UgGWZ92ggm+tk8MFlmXSfiCiG6fbIQxtxdepY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsUvmc5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsUvmc5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5D6C4CEE7;
	Wed, 30 Jul 2025 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868411;
	bh=cHqABianXIWEePGaHvLYLqLxV7rLTZCMsn58jXLZaK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsUvmc5qv9YZk6LLAvPbebIdfHr8ajOWJZ2FmlttndpnxJtYb8KPxr2r2RTdAVr9v
	 c8kjzlSGXyLUJ01NLsg4WhG6FU5dY4/rnQsE5u2gZ2lnar/3UqDCcr4A2dko+osDwB
	 5DZ3D5hCFPd39iYm5k6IItitK3z6YB2HVm86MHz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohan Kumar D <mkumard@nvidia.com>,
	Sheetal <sheetal@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 55/76] ALSA: hda/tegra: Add Tegra264 support
Date: Wed, 30 Jul 2025 11:35:48 +0200
Message-ID: <20250730093228.973813516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohan Kumar D <mkumard@nvidia.com>

commit 1c4193917eb3279788968639f24d72ffeebdec6b upstream.

Update HDA driver to support Tegra264 differences from legacy HDA,
which includes: clocks/resets, always power on, and hardware-managed
FPCI/IPFS initialization. The driver retrieves this chip-specific
information from soc_data.

Signed-off-by: Mohan Kumar D <mkumard@nvidia.com>
Signed-off-by: Sheetal <sheetal@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250512064258.1028331-4-sheetal@nvidia.com
Stable-dep-of: e0a911ac8685 ("ALSA: hda: Add missing NVIDIA HDA codec IDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_tegra.c  |   51 +++++++++++++++++++++++++++++++++++++++------
 sound/pci/hda/patch_hdmi.c |    1 
 2 files changed, 46 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -72,6 +72,10 @@
 struct hda_tegra_soc {
 	bool has_hda2codec_2x_reset;
 	bool has_hda2hdmi;
+	bool has_hda2codec_2x;
+	bool input_stream;
+	bool always_on;
+	bool requires_init;
 };
 
 struct hda_tegra {
@@ -187,7 +191,9 @@ static int __maybe_unused hda_tegra_runt
 	if (rc != 0)
 		return rc;
 	if (chip->running) {
-		hda_tegra_init(hda);
+		if (hda->soc->requires_init)
+			hda_tegra_init(hda);
+
 		azx_init_chip(chip, 1);
 		/* disable controller wake up event*/
 		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
@@ -252,7 +258,8 @@ static int hda_tegra_init_chip(struct az
 	bus->remap_addr = hda->regs + HDA_BAR0;
 	bus->addr = res->start + HDA_BAR0;
 
-	hda_tegra_init(hda);
+	if (hda->soc->requires_init)
+		hda_tegra_init(hda);
 
 	return 0;
 }
@@ -325,7 +332,7 @@ static int hda_tegra_first_init(struct a
 	 * starts with offset 0 which is wrong as HW register for output stream
 	 * offset starts with 4.
 	 */
-	if (of_device_is_compatible(np, "nvidia,tegra234-hda"))
+	if (!hda->soc->input_stream)
 		chip->capture_streams = 4;
 
 	chip->playback_streams = (gcap >> 12) & 0x0f;
@@ -421,7 +428,6 @@ static int hda_tegra_create(struct snd_c
 	chip->driver_caps = driver_caps;
 	chip->driver_type = driver_caps & 0xff;
 	chip->dev_index = 0;
-	chip->jackpoll_interval = msecs_to_jiffies(5000);
 	INIT_LIST_HEAD(&chip->pcm_list);
 
 	chip->codec_probe_mask = -1;
@@ -438,7 +444,16 @@ static int hda_tegra_create(struct snd_c
 	chip->bus.core.sync_write = 0;
 	chip->bus.core.needs_damn_long_delay = 1;
 	chip->bus.core.aligned_mmio = 1;
-	chip->bus.jackpoll_in_suspend = 1;
+
+	/*
+	 * HDA power domain and clocks are always on for Tegra264 and
+	 * the jack detection logic would work always, so no need of
+	 * jack polling mechanism running.
+	 */
+	if (!hda->soc->always_on) {
+		chip->jackpoll_interval = msecs_to_jiffies(5000);
+		chip->bus.jackpoll_in_suspend = 1;
+	}
 
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {
@@ -452,22 +467,44 @@ static int hda_tegra_create(struct snd_c
 static const struct hda_tegra_soc tegra30_data = {
 	.has_hda2codec_2x_reset = true,
 	.has_hda2hdmi = true,
+	.has_hda2codec_2x = true,
+	.input_stream = true,
+	.always_on = false,
+	.requires_init = true,
 };
 
 static const struct hda_tegra_soc tegra194_data = {
 	.has_hda2codec_2x_reset = false,
 	.has_hda2hdmi = true,
+	.has_hda2codec_2x = true,
+	.input_stream = true,
+	.always_on = false,
+	.requires_init = true,
 };
 
 static const struct hda_tegra_soc tegra234_data = {
 	.has_hda2codec_2x_reset = true,
 	.has_hda2hdmi = false,
+	.has_hda2codec_2x = true,
+	.input_stream = false,
+	.always_on = false,
+	.requires_init = true,
+};
+
+static const struct hda_tegra_soc tegra264_data = {
+	.has_hda2codec_2x_reset = true,
+	.has_hda2hdmi = false,
+	.has_hda2codec_2x = false,
+	.input_stream = false,
+	.always_on = true,
+	.requires_init = false,
 };
 
 static const struct of_device_id hda_tegra_match[] = {
 	{ .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
 	{ .compatible = "nvidia,tegra194-hda", .data = &tegra194_data },
 	{ .compatible = "nvidia,tegra234-hda", .data = &tegra234_data },
+	{ .compatible = "nvidia,tegra264-hda", .data = &tegra264_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, hda_tegra_match);
@@ -522,7 +559,9 @@ static int hda_tegra_probe(struct platfo
 	hda->clocks[hda->nclocks++].id = "hda";
 	if (hda->soc->has_hda2hdmi)
 		hda->clocks[hda->nclocks++].id = "hda2hdmi";
-	hda->clocks[hda->nclocks++].id = "hda2codec_2x";
+
+	if (hda->soc->has_hda2codec_2x)
+		hda->clocks[hda->nclocks++].id = "hda2codec_2x";
 
 	err = devm_clk_bulk_get(&pdev->dev, hda->nclocks, hda->clocks);
 	if (err < 0)
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4559,6 +4559,7 @@ HDA_CODEC_ENTRY(0x10de002e, "Tegra186 HD
 HDA_CODEC_ENTRY(0x10de002f, "Tegra194 HDMI/DP2", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0030, "Tegra194 HDMI/DP3", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0031, "Tegra234 HDMI/DP", patch_tegra234_hdmi),
+HDA_CODEC_ENTRY(0x10de0034, "Tegra264 HDMI/DP",	patch_tegra234_hdmi),
 HDA_CODEC_ENTRY(0x10de0040, "GPU 40 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0041, "GPU 41 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0042, "GPU 42 HDMI/DP",	patch_nvhdmi),


