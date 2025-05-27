Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434E2566;
	Tue, 27 May 2025 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368272; cv=none; b=dThf4POLusC1Gb8/y9jVfcCSrcRrlpbQnGuxFqrGuGlL7+upHl8UJmT5ZLYIj5b4ZxBzMH4QOWFuO4SqoN/psGPNUuGujAecHY0A7d+0kD2aZ393o9Sil1LTDYsjDIIxz3EhbjBelYT2jb+NL8CmFEs1ROOYCdvUKPKPUvYVmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368272; c=relaxed/simple;
	bh=rf3oyVftlhUFJRMagIb7YYSQt/QafeyodVo33u5RQnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCWpGNkObA4c0izfKdz/fs7Jt/uDVUgMgmFHe+Bv+PP/oM/Tw+fGtxWEeDw+5YnOl5aQiWo6bgML7t3DdHl2rMpiW7uZwBlO2h8jME1HfIyKjJf0B5mS0g9inWVTcxfXFVVyjCiVjPDHO/iBvb0OIqxTyqlpvSkkhjzQ7avHQ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4ZjBPe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4ZjBPe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ABFC4CEE9;
	Tue, 27 May 2025 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368270;
	bh=rf3oyVftlhUFJRMagIb7YYSQt/QafeyodVo33u5RQnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4ZjBPe2hEpjHzLdAGDGcD5JsA7L+7zSLImwVsnUgrQE0ZteKICLsjwkimskFGCVp
	 vDm2MB64OW0t5BueAUUFQkIdn2FRc6zhaIwQaAKbdaYSpx9vOnwXmw7e1+0s1Lf9bx
	 9vLW0vimE5eNdpN51a3C1Ng/GL4ZuZyaQYD4OoU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 654/783] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Tue, 27 May 2025 18:27:31 +0200
Message-ID: <20250527162539.760628293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 70ad2e6bd180f94be030aef56e59693e36d945f3 ]

The headphone clamps cause fairly loud pops during type detect
because they sink current from the detection process itself. Disable
the clamps whilst the type detect runs, to improve the detection
pop performance.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250423090944.1504538-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 20e6ab6f0d4ad..6165ac16c3a95 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -654,6 +654,10 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 
 	reinit_completion(&priv->type_detect);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK);
+
 	cs42l43_start_hs_bias(priv, true);
 	regmap_update_bits(cs42l43->regmap, CS42L43_HS2,
 			   CS42L43_HSDET_MODE_MASK, 0x3 << CS42L43_HSDET_MODE_SHIFT);
@@ -665,6 +669,9 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 			   CS42L43_HSDET_MODE_MASK, 0x2 << CS42L43_HSDET_MODE_SHIFT);
 	cs42l43_stop_hs_bias(priv);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK, 0);
+
 	if (!time_left)
 		return -ETIMEDOUT;
 
-- 
2.39.5



