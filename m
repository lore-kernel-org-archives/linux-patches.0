Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF928330B1F;
	Fri, 17 Oct 2025 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716096; cv=none; b=nX7yCQg6hgP/O7RrbLhQgibgRSb4V3NOBOjQuuvra6lMUsUI8wh9Mde2WGlyW3TPTPNxmiSno8+rhUKicJ4LFUqLFBCvqh3ssZnFk+s+Up32FQ1su4G8J2bdwwmc9xAs/f9Rvb4/uDcKguRYLM9nhg7hhn8tJPElZQSvDuMb6zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716096; c=relaxed/simple;
	bh=+QBR/FgeydHqMwRMWSpZtkr591EqGbKpvcUycY9V9eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNC5e4UNES5c9Tby3tV2rejx+xCtdcoVVxHGlLr6HHvicIb6p2WgH/hqb/qSqSGEt0tQ/+udeh8rcU5cXyb4nA84y7KiAg6l+Ywan3Q8RNFJInOcrhMTymJ47Zy5yQqd57Mwi/pBcuUVhcuuRNe+vTI0KnjnVgtenX6UKStNH80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmdO/ZYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmdO/ZYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACEFC4CEFE;
	Fri, 17 Oct 2025 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716095;
	bh=+QBR/FgeydHqMwRMWSpZtkr591EqGbKpvcUycY9V9eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmdO/ZYOQESlu5tq2+SFYi8Lff2vn8EWSG4Ruhi4v5Of4Xa2E+ki4572JkLewb+SZ
	 WQZlCa7kO4fpbAUeum2qz+cPtAoTHhdrhmOoBBZOurGTwNvJHG5W6d6BRFyYuUU7ir
	 uWyZzrd+PQf/Nre6yyGTmFFEQ+dxx+PDP/ZLAy2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/276] ASoC: Intel: bytcr_rt5651: Fix invalid quirk input mapping
Date: Fri, 17 Oct 2025 16:52:43 +0200
Message-ID: <20251017145145.042338068@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4336efb59ef364e691ef829a73d9dbd4d5ed7c7b ]

When an invalid value is passed via quirk option, currently
bytcr_rt5640 driver just ignores and leaves as is, which may lead to
unepxected results like OOB access.

This patch adds the sanity check and corrects the input mapping to the
certain default value if an invalid value is passed.

Fixes: 64484ccee7af ("ASoC: Intel: bytcr_rt5651: Set card long_name based on quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20250902171826.27329-4-tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5651.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 93cec4d916273..b0b41a03c083e 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -58,7 +58,8 @@ enum {
 	BYT_RT5651_OVCD_SF_1P5	= (RT5651_OVCD_SF_1P5 << 13),
 };
 
-#define BYT_RT5651_MAP(quirk)		((quirk) & GENMASK(3, 0))
+#define BYT_RT5651_MAP_MASK		GENMASK(3, 0)
+#define BYT_RT5651_MAP(quirk)		((quirk) & BYT_RT5651_MAP_MASK)
 #define BYT_RT5651_JDSRC(quirk)		(((quirk) & GENMASK(7, 4)) >> 4)
 #define BYT_RT5651_OVCD_TH(quirk)	(((quirk) & GENMASK(12, 8)) >> 8)
 #define BYT_RT5651_OVCD_SF(quirk)	(((quirk) & GENMASK(14, 13)) >> 13)
@@ -100,14 +101,29 @@ MODULE_PARM_DESC(quirk, "Board-specific quirk override");
 
 static void log_quirks(struct device *dev)
 {
-	if (BYT_RT5651_MAP(byt_rt5651_quirk) == BYT_RT5651_DMIC_MAP)
+	int map;
+
+	map = BYT_RT5651_MAP(byt_rt5651_quirk);
+	switch (map) {
+	case BYT_RT5651_DMIC_MAP:
 		dev_info(dev, "quirk DMIC_MAP enabled");
-	if (BYT_RT5651_MAP(byt_rt5651_quirk) == BYT_RT5651_IN1_MAP)
+		break;
+	case BYT_RT5651_IN1_MAP:
 		dev_info(dev, "quirk IN1_MAP enabled");
-	if (BYT_RT5651_MAP(byt_rt5651_quirk) == BYT_RT5651_IN2_MAP)
+		break;
+	case BYT_RT5651_IN2_MAP:
 		dev_info(dev, "quirk IN2_MAP enabled");
-	if (BYT_RT5651_MAP(byt_rt5651_quirk) == BYT_RT5651_IN1_IN2_MAP)
+		break;
+	case BYT_RT5651_IN1_IN2_MAP:
 		dev_info(dev, "quirk IN1_IN2_MAP enabled");
+		break;
+	default:
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to DMIC_MAP\n", map);
+		byt_rt5651_quirk &= ~BYT_RT5651_MAP_MASK;
+		byt_rt5651_quirk |= BYT_RT5651_DMIC_MAP;
+		break;
+	}
+
 	if (BYT_RT5651_JDSRC(byt_rt5651_quirk)) {
 		dev_info(dev, "quirk realtek,jack-detect-source %ld\n",
 			 BYT_RT5651_JDSRC(byt_rt5651_quirk));
-- 
2.51.0



