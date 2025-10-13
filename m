Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14885307AD6;
	Mon, 13 Oct 2025 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368367; cv=none; b=bHqDXpVBq/k8SjIUtxGgurSNXN25XIzNT+es8/Iq1HqNfv2mGQUcn59b/r3H2sp4bgVpk/9NCKREumZkPbZANyyAOjj8fMb+x77sGc43XZaqfy3cAaMSllcyxm5xFWeiKF0HxTHdoDDSOV9ELXvkXlbLHZNMdWjYXTSkwm/EiO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368367; c=relaxed/simple;
	bh=ukiSuYPl8EocKfPRyM4339Os2NlnEEfpDfHK9Upd2YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4OWo+rfOpixb3B2jLpPa8P+CzFxCLw45mU6OjWz630hiLROkEhiWKEJFuvF9bKPMbPzJUapwXml6NYKJgpmWKGhadGcWYvjE34bSp1fibitA3QGMUTdgl3pQc4SAW6gcQZamJ+bS1gWBM2MFH1Tkk41ryXTRSw1dlycSafU+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUJrNGFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUJrNGFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4982FC4CEE7;
	Mon, 13 Oct 2025 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368366;
	bh=ukiSuYPl8EocKfPRyM4339Os2NlnEEfpDfHK9Upd2YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUJrNGFmSZfCfHJMPtYWAYtOGWiYXzqb1RA2gbZjnFx9k7ou9aj4CJpQezcalVFrZ
	 bsOyA4gb539p3+F4ZgFB8Z/Ru2iuDL9Lkj0x3aSxqOkIfJMso2eq9i+UwiDC/myqHi
	 9VrusfNDApYblhYCMXbyFBv+75y+94JhLfU6qI04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/262] ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping
Date: Mon, 13 Oct 2025 16:44:37 +0200
Message-ID: <20251013144330.985781579@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6434b4731261..d6991864c5a49 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -68,7 +68,8 @@ enum {
 	BYT_RT5640_OVCD_SF_1P5		= (RT5640_OVCD_SF_1P5 << 13),
 };
 
-#define BYT_RT5640_MAP(quirk)		((quirk) &  GENMASK(3, 0))
+#define BYT_RT5640_MAP_MASK		GENMASK(3, 0)
+#define BYT_RT5640_MAP(quirk)		((quirk) & BYT_RT5640_MAP_MASK)
 #define BYT_RT5640_JDSRC(quirk)		(((quirk) & GENMASK(7, 4)) >> 4)
 #define BYT_RT5640_OVCD_TH(quirk)	(((quirk) & GENMASK(12, 8)) >> 8)
 #define BYT_RT5640_OVCD_SF(quirk)	(((quirk) & GENMASK(14, 13)) >> 13)
@@ -140,7 +141,9 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk NO_INTERNAL_MIC_MAP enabled\n");
 		break;
 	default:
-		dev_err(dev, "quirk map 0x%x is not supported, microphone input will not work\n", map);
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to DMIC1_MAP\n", map);
+		byt_rt5640_quirk &= ~BYT_RT5640_MAP_MASK;
+		byt_rt5640_quirk |= BYT_RT5640_DMIC1_MAP;
 		break;
 	}
 	if (byt_rt5640_quirk & BYT_RT5640_HSMIC2_ON_IN1)
-- 
2.51.0



