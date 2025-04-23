Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCCA27FD49;
	Wed, 23 Apr 2025 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419626; cv=none; b=vFupmIjXrpRbqErgHmr9kFdaJgHk8UqyR+uE1Iv+v+73xpEHkquaqTsGNyPLQw4FI4qlziU36+NrCXUPP2qfLw/Xslj6kV2tMD3dBSTth5sDplmuAV0j/kYNK5Z0d1+70kQp0gxd0qujetyOCH/mKKDEIJFYTcatvANc40/89Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419626; c=relaxed/simple;
	bh=I+FzOgxUHY6AV4EzsFnfpjYKnQ9ETFvyCDajXMx6/8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/UR3fPr8C3k1UEGTyN1X5pA54TPtmfXyCkN+vARvLepoPKigM/MM6ROAZ1z/T7OzNtmSant/DV6lh831tnGNeVRCPCz5mAI2icM3L+w+nP9Q+XYcqRAYo6gUzj/J3eyqv/Wgzgx0UlVxOsqmO0GR6vARY5tK00lOtdygxmzqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1aKMwIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1aKMwIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE4AC4CEE2;
	Wed, 23 Apr 2025 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419626;
	bh=I+FzOgxUHY6AV4EzsFnfpjYKnQ9ETFvyCDajXMx6/8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1aKMwIaqhKL70bz+9W2+kExDHtV0njgdvrNRVg6V9Bfe/p8tugnkKKOM0SsELPZn
	 X6kSpdx/wCOW56LmfvPg5TwuadW4ua6Zdp6nH4AlLc5IHDxHg7YWp+DM0mp8rMp5Nd
	 /aP9OjGKbczNaJZNgewOmHxSgS0Y3g7SUFeenY1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/223] ASoC: cs42l43: Reset clamp override on jack removal
Date: Wed, 23 Apr 2025 16:41:37 +0200
Message-ID: <20250423142618.140005240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5fc7d2b5cab47f2ac712f689140b1fed978fb91c ]

Some of the manually selected jack configurations will disable the
headphone clamp override. Restore this on jack removal, such that
the state is consistent for a new insert.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250409120717.1294528-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index d9ab003e166bf..73d764fc85392 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -702,6 +702,9 @@ static void cs42l43_clear_jack(struct cs42l43_codec *priv)
 			   CS42L43_PGA_WIDESWING_MODE_EN_MASK, 0);
 	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CTRL,
 			   CS42L43_JACK_STEREO_CONFIG_MASK, 0);
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_MASK,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_MASK);
 	regmap_update_bits(cs42l43->regmap, CS42L43_HS2,
 			   CS42L43_HSDET_MODE_MASK | CS42L43_HSDET_MANUAL_MODE_MASK,
 			   0x2 << CS42L43_HSDET_MODE_SHIFT);
-- 
2.39.5



