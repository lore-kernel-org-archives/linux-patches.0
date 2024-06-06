Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F831A2578;
	Thu,  6 Jun 2024 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683760; cv=none; b=MTATL2UtEvV+1NFf1PBVx+hMNgrtZf0PjhB/gLgObeymHxlbkqT2nkdH/kpCu+Dz7GqOhKeIfED4+FeSVfZ+y30/TPzCnwYxOIkiGqcNGJWgrYs2lEXzjafF6Myj/zVMUuK2ehjAKJeiQ1wUlJjnVT2dqp5dQHejdJSwBXgyHfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683760; c=relaxed/simple;
	bh=/+YGM8nM9My9H2PdxICFyphUC0rjYKqW6gD0sV0X60Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQxQt6AHCkQFC3o2DAJaIIxoPoIzJ8TjQwopIDv26hrYRXDVRzGxrVy6GN+Pgv8vs3eh16T+i0vxbUWJFbF5xr1EZG09VkR4cHvuDejB71JgY30o1TzkfNFNumUXrpsLh+/7XUU9XtePCRK8KEj4sAGlE4KDDlN4WeTNbwzuQjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtWPWYVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtWPWYVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E3DC2BD10;
	Thu,  6 Jun 2024 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683760;
	bh=/+YGM8nM9My9H2PdxICFyphUC0rjYKqW6gD0sV0X60Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtWPWYVJ62CEkjUnoj7T9yeIfclKp66Q9S7oln/wvs4T9ibIogWbmjUvX8F77Y/ZH
	 H+BzT824GImcrCUdFPiujZl35FvAVimmyAsDU2jJujazJnvQteDSEERj782ScuprMG
	 QSQYbTw4yLUB+O1lED9BZJrAz5XFfo26V9a6D1zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 701/744] ASoC: cs42l43: Only restrict 44.1kHz for the ASP
Date: Thu,  6 Jun 2024 16:06:13 +0200
Message-ID: <20240606131754.961101311@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8015f4b7a5b32..1443eb1dc0b17 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -220,8 +220,9 @@ static int cs42l43_startup(struct snd_pcm_substream *substream, struct snd_soc_d
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



