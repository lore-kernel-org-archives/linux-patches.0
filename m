Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7627E7C8;
	Tue, 27 May 2025 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365942; cv=none; b=NY6vQwtXHNMOi7OEuoNYUKeQ7m74ttIROcMLY1GrPWwCkBx1upE0tpqr1prWqaxJb3lLlusm09EVEPONxjL5BdJUs9J4WK8F3vTC2USmrn8tEcqdV1wuplZfNWk+C41a4fvo+p5Wpr9F6ANAk7MPeorMCELVRHq4alXtyrkntw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365942; c=relaxed/simple;
	bh=UietwjkyltU6XH8jSHSxMlQZljLhq1ifxLW2jNdf+gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFnbVWfVEzYIaQrFotbX0RxE1Y/96aIqcK+MHzn5h5+a8wudljJEIcpQwv+QShm+gE+7l1OCmav7t0jpL61CkpthpRi8TJMQcO1B22nnBZXqxQaheRxdu/eZci19yMWSxj2rtiTiwjclz07ldm4FHw0X1LazfJAuBFrTOcqilXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQ1Vx12Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQ1Vx12Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FA4C4CEEB;
	Tue, 27 May 2025 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365941;
	bh=UietwjkyltU6XH8jSHSxMlQZljLhq1ifxLW2jNdf+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQ1Vx12Ztn7+YMJ+l1adDFl2ZOTsr8q0St64URceFIloEKoS3ijsw37lvyHgv4YUl
	 VzGrcTKBwNcoEhKzUui6sS+eVHA81ackVr0hch3CauQ70SxGGOxag99Pq+if5WutCj
	 mObm/dwBIeniOs6I/31gvsG+Eea0ePPttOXMtKYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 512/626] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Tue, 27 May 2025 18:26:45 +0200
Message-ID: <20250527162505.767124662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 73d764fc85392..984a7f470a31f 100644
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



