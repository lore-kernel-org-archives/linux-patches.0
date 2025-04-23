Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2E6269B07;
	Wed, 23 Apr 2025 15:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421966; cv=none; b=FZdqtXMU85JwREuidyIrOqGGbsCqrX4ha2jOrkaBy29lWJmilYN1FoyskL2aZjuGl8FEUNFuQxwlLCKHnMD78+JwaKbZN+EG/044r+YDfcuvJuukr2Sb05Hk1TJrB19cQGM08pwvA2GpcMwfWXmgAxDC/LwCjFNvwvCLMDJ/8TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421966; c=relaxed/simple;
	bh=bpoNs3S5+H40kM6qWOgBY0AINKKEiGFrT7fBKjWPYPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEo0VuXe/oA2VtIxI1czmSG1IiE40ANDC1z3rb6nryWsCuPAJ1VKYoEso11BhCQP2KKXTeWkRHmZ/44La0yaukByQYxg2OE2c5fIBKknDz+igCbuh3+s0yIn/UJ/Q76Nm9dbREs5VI6MQ6zAmGnF2mDdMkIHzzw6r2cpDq3LYMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grgjwzu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grgjwzu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC0DC4CEE2;
	Wed, 23 Apr 2025 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421966;
	bh=bpoNs3S5+H40kM6qWOgBY0AINKKEiGFrT7fBKjWPYPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grgjwzu1wO78aPNB8hYR99OGNslboxEzZBAt6WQI6daZC60mixm+S4j27tCKIVD88
	 hlhjHIgDMRHf480qlc9aYivLwS3AL4rPpS9HUC4YmMYBk0oqC6tZqPKpTQY6DewGd+
	 uT0EIRgPzRpl/PkVNuWLsSastzyntDI0y2Dzr2uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/393] ASoC: cs42l43: Reset clamp override on jack removal
Date: Wed, 23 Apr 2025 16:42:29 +0200
Message-ID: <20250423142653.821116753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index 9f5f1a92561d1..0b8e88b19888e 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -690,6 +690,9 @@ static void cs42l43_clear_jack(struct cs42l43_codec *priv)
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



