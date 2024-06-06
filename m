Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E1E198E7E;
	Thu,  6 Jun 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683087; cv=none; b=fXg+4kHKJ4WGf+H48wPYQT3Ig6ztNvnsAQW3lPkocp75rK6CI9u8GfHQHDJbsdwdzrLnWxcF8Lj3JpXnmfov/0Kp9PrepY6d9akgDKedbDkgiCGbbDcfB9vFh66IvPhEdykt/iHdr6Nl7MaPabqP/PIJnb6lA0DjkixqVXZ5aQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683087; c=relaxed/simple;
	bh=FbZWwZCorWbEAGQvBtD+Rq/umFJAv+4DcAJk4vkRma0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFUVM6gvyTI5GGjv4fqHDM43karoLTeoiHXjVCI5iVJWENNpMX7zLb2yxTWXdxmAwvUw3m+jGrOxl8ZWzkVS3nV8sAXVd8iIv3/81xcIM475z3Rn1/eN0P/amq7jHFj6ugC6mVqkHrd6rOBk+Sspj5vRSnaHSqwChjDLgLjCZnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Prp2mpIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Prp2mpIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BE8C2BD10;
	Thu,  6 Jun 2024 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683087;
	bh=FbZWwZCorWbEAGQvBtD+Rq/umFJAv+4DcAJk4vkRma0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Prp2mpIQVEJBmprAIFybqU691MenwTBsGcPZCdNgrY6GFEv+Fife4jLuKIdKDyqcb
	 kmqUe8qu5fc7D+SU1jTRtpy/XfuDpAr8khuMnIEK8eQ4thgbU8Ew4FRpa246nFtYHm
	 0NSo2+fXdt3PxsvFbgpvvcDANaSmC2igULQWl5TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 314/374] ASoC: cs42l43: Only restrict 44.1kHz for the ASP
Date: Thu,  6 Jun 2024 16:04:53 +0200
Message-ID: <20240606131702.397039144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 797c525e85d1e44cf0e6f338890e8e0c661f524a ]

The SoundWire interface can always support 44.1kHz using flow controlled
mode, and whether the ASP is in master mode should obviously only affect
the ASP. Update cs42l43_startup() to only restrict the rates for the ASP
DAI.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240527100840.439832-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index 94685449f0f48..92674314227c4 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -310,8 +310,9 @@ static int cs42l43_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 	struct snd_soc_component *component = dai->component;
 	struct cs42l43_codec *priv = snd_soc_component_get_drvdata(component);
 	struct cs42l43 *cs42l43 = priv->core;
-	int provider = !!regmap_test_bits(cs42l43->regmap, CS42L43_ASP_CLK_CONFIG2,
-					  CS42L43_ASP_MASTER_MODE_MASK);
+	int provider = !dai->id || !!regmap_test_bits(cs42l43->regmap,
+						      CS42L43_ASP_CLK_CONFIG2,
+						      CS42L43_ASP_MASTER_MODE_MASK);
 
 	if (provider)
 		priv->constraint.mask = CS42L43_PROVIDER_RATE_MASK;
-- 
2.43.0



