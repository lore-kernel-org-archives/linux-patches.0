Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D82131C580;
	Mon, 27 Oct 2025 18:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591071; cv=none; b=s/rnVpJIqU4CCqJEfRPpueQ36AS/Oe5CkRtIqANzARClGGdnnEipHdYNHi/8oIKvQ6wD62QeOIDFkgKg5oGna3RFYaXecZn5e6msm1n8MB+v90Gf91ZvCeXiLXNwnZEc4CFo6QiCtUPW7631RK4G1lR5Qu5tYha7EV6Z1Wy5E9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591071; c=relaxed/simple;
	bh=y6+NSHmTzU9pOM0Tp49ZlGQPSEGohpNgC+bKHZ9aRac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozpHHLDZQ8gOFYFM6Jyge1GdfjulwNC7sEyX5hO//kLWCbSaKLGOW69LZPHVn/xdNJ/tWkepnn29ySsubq96K5FEha6womTwtVig86LdSHHT/L/kHhH2vzcwyLYaOe4+AVAl2OJ3K7CB50A71NzoyLWYbBGwPn0U2betJ6MqaKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge32D6A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge32D6A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CA0C4CEF1;
	Mon, 27 Oct 2025 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591070;
	bh=y6+NSHmTzU9pOM0Tp49ZlGQPSEGohpNgC+bKHZ9aRac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge32D6A2TIwwD+eYsC0LzWdk7EPPyNHDdsT31Ez3NIL9X7gIr/QBBFYlLX4l5ZebT
	 C4ts4O3PLwXWVqB1ntT8UD5EdPYdcfv1AqntiH3KyvybcN9zqH13hqoMdDfMBvw27e
	 R0FYgl64lL4sYdPh9xWV+Ly6ghoCr3xr7firKMb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/332] ASoC: Intel: bytcr_rt5651: Fix invalid quirk input mapping
Date: Mon, 27 Oct 2025 19:31:49 +0100
Message-ID: <20251027183526.099087924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
index a8289f74463e9..f5bcf68841c39 100644
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



