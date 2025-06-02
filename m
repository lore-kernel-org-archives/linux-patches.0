Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349F20E6E3;
	Mon,  2 Jun 2025 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873972; cv=none; b=S0A4EuDS7bj0YGHrPwFa4PD5bnru7zGN3/yADVnKcE7Y3nSPDnuJ9HtLESwNf9y2vbTvGSB2yBhLzlPN/vSD4TGSo4AQ5XDPdyXBPKbnYm+Ox1UHFUR9ababw5sa1hyUqLaYFtL5dEH/z/S3AtOj38o+/JjXZ5CIlL++VkFRfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873972; c=relaxed/simple;
	bh=oRUEcTz3TuySHAV1cjRB5hwLPtrRYs+nGwMGC9+WWGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3jbec2eFxZzlnOJ9aAvL2phf8E8NS0CiTTQ+tgZfXhY4ICbd/3PhFWbX1VbqFzAAFW7XKt33yFwbFvaw8SvqcqzQabjTFuWnINvcvX/fmlovRKrLn5r91WrFyp8+yTOfLVTg2o5J4ZdcrBiBa/NuOPuhZRU6XeftIvoI73SJcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmOGptQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmOGptQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E46C4CEEB;
	Mon,  2 Jun 2025 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873972;
	bh=oRUEcTz3TuySHAV1cjRB5hwLPtrRYs+nGwMGC9+WWGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmOGptQPaexYnNF05WSbX6FqiM0HUuJ+DXJpsFKSmJ3VHDUi2/mNdsFibjIa6IJsb
	 X5sQBUltMQR03AofN9g8PhLIZGp+hIfoAGqH+CSqKnboVrFxJbz4B5BVc9tkc4ZCqy
	 F1xrzzmgl/25D6rr4UZVeyCCkfTlHa851MiBfQCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/444] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Mon,  2 Jun 2025 15:46:19 +0200
Message-ID: <20250602134353.723469514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index 0b8e88b19888e..6d8455c1bee6d 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -642,6 +642,10 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 
 	reinit_completion(&priv->type_detect);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK);
+
 	cs42l43_start_hs_bias(priv, true);
 	regmap_update_bits(cs42l43->regmap, CS42L43_HS2,
 			   CS42L43_HSDET_MODE_MASK, 0x3 << CS42L43_HSDET_MODE_SHIFT);
@@ -653,6 +657,9 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 			   CS42L43_HSDET_MODE_MASK, 0x2 << CS42L43_HSDET_MODE_SHIFT);
 	cs42l43_stop_hs_bias(priv);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK, 0);
+
 	if (!time_left)
 		return -ETIMEDOUT;
 
-- 
2.39.5



