Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4731B122;
	Mon, 27 Oct 2025 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590439; cv=none; b=KhEE0xN8UYsAYF/NylHklV+g1uaPa/J3uekAhDoTTWhNpMwkyUwAdZr1HNxf+kh/ltSJXTXAP/iRn+4hjOybiJ7drixqME4ESWhLcmCyDQXztrapHmiWi902oJ+JVxNNULQOCI2HzzvlU8EorPfi3cSIdndBIHYIsZAa+hDwxtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590439; c=relaxed/simple;
	bh=hBVtfjOQEOg44vf6zm8J3688hcwVt6i2yf+v2DFFZwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sid+F176bI09k8w+hirm3eGB6T954euvmqd+OG1FsNEbvj6tg8JUXestuYYCW7iV+9rymqPFe/e7bwWuxaqVp2Z3uTDS8efKoxKV3KVy7lC0bcZDp+w7DkkNgUQBvvoxg7+WV82xJFwrQXZ0pbOQP4euClRJLzUtndg8g3rdC9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/A9Pof/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/A9Pof/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB54DC4CEF1;
	Mon, 27 Oct 2025 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590439;
	bh=hBVtfjOQEOg44vf6zm8J3688hcwVt6i2yf+v2DFFZwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/A9Pof/1tHxZ1wldYxrWbVYwmsoSkKSJiDKqCwr5gPjSH5e6rau55RFo06HRWmhB
	 csNDDmxSpgoQljr/SJUywQzHdUT052tAPUOUbuSvoczpGmRbPpp7Rlc2dRvgUa4TYA
	 baIXKZRK0p3P4sA63vazjS4WNhKCxgp5pK9ivevg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/224] ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping
Date: Mon, 27 Oct 2025 19:33:12 +0100
Message-ID: <20251027183510.235779409@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fba404e4b4af4f4f747bb0e41e9fff7d03c7bcc0 ]

When an invalid value is passed via quirk option, currently
bytcr_rt5640 driver only shows an error message but leaves as is.
This may lead to unepxected results like OOB access.

This patch corrects the input mapping to the certain default value if
an invalid value is passed.

Fixes: 063422ca2a9d ("ASoC: Intel: bytcr_rt5640: Set card long_name based on quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20250902171826.27329-3-tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 5a8e86ba29004..88e84415d5a4b 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -60,7 +60,8 @@ enum {
 	BYT_RT5640_OVCD_SF_1P5		= (RT5640_OVCD_SF_1P5 << 13),
 };
 
-#define BYT_RT5640_MAP(quirk)		((quirk) &  GENMASK(3, 0))
+#define BYT_RT5640_MAP_MASK		GENMASK(3, 0)
+#define BYT_RT5640_MAP(quirk)		((quirk) & BYT_RT5640_MAP_MASK)
 #define BYT_RT5640_JDSRC(quirk)		(((quirk) & GENMASK(7, 4)) >> 4)
 #define BYT_RT5640_OVCD_TH(quirk)	(((quirk) & GENMASK(12, 8)) >> 8)
 #define BYT_RT5640_OVCD_SF(quirk)	(((quirk) & GENMASK(14, 13)) >> 13)
@@ -118,7 +119,9 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk IN3_MAP enabled\n");
 		break;
 	default:
-		dev_err(dev, "quirk map 0x%x is not supported, microphone input will not work\n", map);
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to DMIC1_MAP\n", map);
+		byt_rt5640_quirk &= ~BYT_RT5640_MAP_MASK;
+		byt_rt5640_quirk |= BYT_RT5640_DMIC1_MAP;
 		break;
 	}
 	if (BYT_RT5640_JDSRC(byt_rt5640_quirk)) {
-- 
2.51.0



