Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EC330F80B;
	Mon, 13 Oct 2025 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369677; cv=none; b=ESfeWj0S81nWMSbIHdU0fgBGgnXtxAB8fcs5WNDEXPSVqik27ZGCioO7TpFF0NRtjLjBcDuZqw70A0NUW5yXGHb2Vk4p9CJ0fqs0QKIeTW+hhFVQXLoFXgCD90TzSyPphk6xezChIyUOSeY4YZ7vfH6lWFW00vA+Q0Z5y0yxPl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369677; c=relaxed/simple;
	bh=gXZkSW4DJnYHMJwj6zM87ZXi+Z7f6XT1ZLqA3D1pNK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH19Jdawvfu/LNBqY/RW2RyJlxFEwbQNP9VmzQyyRtw65UWfi94lkzzhI+76knbHgea1hIXDTOuD+ed7o+TL4HVZGMes7x2kpLOdDA/v1Fu4DHqkQ8PVONf78L4C4lCcIyUakicbwcfWAAiggm2uBIQ1W3ai5JYsVxHE9Fz9fXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIKo1jWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIKo1jWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AB1C116B1;
	Mon, 13 Oct 2025 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369677;
	bh=gXZkSW4DJnYHMJwj6zM87ZXi+Z7f6XT1ZLqA3D1pNK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIKo1jWbHYYvOoH1qm/m5tCEN5YfCTOOQneQRPX+PBh0NQWPYwTpWoqEUVTiuuHTE
	 /5Y9p+PeXXz9dcRdo6SopxbcCJtEeaaZfZyu/v0LzmKuVPV6YiSwKg6xNsfzPgYrkU
	 V7Xg1aVfu8NtTpQTNCEfwEs0PMs68a9rC+EiTmaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 330/563] ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping
Date: Mon, 13 Oct 2025 16:43:11 +0200
Message-ID: <20251013144423.215829564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b20eb0e8de383116f1e1470d74da2a3c83c4e345 ]

When an invalid value is passed via quirk option, currently
bytcht_es8316 driver just ignores and leaves as is, which may lead to
unepxected results like OOB access.

This patch adds the sanity check and corrects the input mapping to the
certain default value if an invalid value is passed.

Fixes: 249d2fc9e55c ("ASoC: Intel: bytcht_es8316: Set card long_name based on quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20250902171826.27329-2-tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 62594e7966ab0..b384d38654e65 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -47,7 +47,8 @@ enum {
 	BYT_CHT_ES8316_INTMIC_IN2_MAP,
 };
 
-#define BYT_CHT_ES8316_MAP(quirk)		((quirk) & GENMASK(3, 0))
+#define BYT_CHT_ES8316_MAP_MASK			GENMASK(3, 0)
+#define BYT_CHT_ES8316_MAP(quirk)		((quirk) & BYT_CHT_ES8316_MAP_MASK)
 #define BYT_CHT_ES8316_SSP0			BIT(16)
 #define BYT_CHT_ES8316_MONO_SPEAKER		BIT(17)
 #define BYT_CHT_ES8316_JD_INVERTED		BIT(18)
@@ -60,10 +61,23 @@ MODULE_PARM_DESC(quirk, "Board-specific quirk override");
 
 static void log_quirks(struct device *dev)
 {
-	if (BYT_CHT_ES8316_MAP(quirk) == BYT_CHT_ES8316_INTMIC_IN1_MAP)
+	int map;
+
+	map = BYT_CHT_ES8316_MAP(quirk);
+	switch (map) {
+	case BYT_CHT_ES8316_INTMIC_IN1_MAP:
 		dev_info(dev, "quirk IN1_MAP enabled");
-	if (BYT_CHT_ES8316_MAP(quirk) == BYT_CHT_ES8316_INTMIC_IN2_MAP)
+		break;
+	case BYT_CHT_ES8316_INTMIC_IN2_MAP:
 		dev_info(dev, "quirk IN2_MAP enabled");
+		break;
+	default:
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to INTMIC_IN1_MAP\n", map);
+		quirk &= ~BYT_CHT_ES8316_MAP_MASK;
+		quirk |= BYT_CHT_ES8316_INTMIC_IN1_MAP;
+		break;
+	}
+
 	if (quirk & BYT_CHT_ES8316_SSP0)
 		dev_info(dev, "quirk SSP0 enabled");
 	if (quirk & BYT_CHT_ES8316_MONO_SPEAKER)
-- 
2.51.0



