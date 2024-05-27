Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25591168C4;
	Mon, 27 May 2024 19:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837613; cv=none; b=gMpQe74zRb4X9nSGAxCW8/Os/dPj20+orRCxvHGQjxSkf/MABWCBMrIgMOiG98ayes59wLObVDkRydwLkkfsYvGHEXvwQ8tPxBvAcHVJPuEt/eLH9dypEBWRZvK8LIpnZpsxTt624t1UeNRNdERkN7XKwMiOwzAlhmXPh8eDGPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837613; c=relaxed/simple;
	bh=uDw2Zxca3nWD3Hv+BCHr5llUYh86lh9QjSbL60fyt58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAJyHOWasu6KXXeYF6NOO1NN6Mo5sBx+0FP0r5zSLknx19/KWwHFzvL/Qerk3GQx0v8DTpLUD18y6vtqi1EVCJm2nvzZDjG0ggcLkNHs7CzDUW0PfTbM6sN8j8g1VNVbRQloDXk5DU7PHGwcBCkzrgGFR0ZS6IvpXCL0tlUmCtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKvASyhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKvASyhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D200C2BBFC;
	Mon, 27 May 2024 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837613;
	bh=uDw2Zxca3nWD3Hv+BCHr5llUYh86lh9QjSbL60fyt58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKvASyhMEpshMpjz7qLbQj9XOCAehupgQr9YJWz6K6cGScUemUIg04Mk69s13Qbsh
	 ou5Qu+2e4IbwwalUSrXzbBKMJq3JyEzHaikKz4t4ozBcXlAk5fniL+G1/L7358Hy3X
	 wf/w0MXLtu1YU6ecNMHpNkX0Kg3kcOrfvgaBszY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 076/493] ASoC: cs35l41: Update DSP1RX5/6 Sources for DSP config
Date: Mon, 27 May 2024 20:51:18 +0200
Message-ID: <20240527185632.496421558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit eefb831d2e4dd58d58002a2ef75ff989e073230d ]

Currently, all ASoC systems are set to use VPMON for DSP1RX5_SRC,
however, this is required only for internal boost systems.
External boost systems require VBSTMON instead of VPMON to be the
input to DSP1RX5_SRC.
Shared Boost Active acts like Internal boost (requires VPMON).
Shared Boost Passive acts like External boost (requires VBSTMON)
All systems require DSP1RX6_SRC to be set to VBSTMON.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://msgid.link/r/20240411142648.650921-1-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index dfb4ce53491bb..f8e57a2fc3e32 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -1094,6 +1094,7 @@ static int cs35l41_handle_pdata(struct device *dev, struct cs35l41_hw_cfg *hw_cf
 static int cs35l41_dsp_init(struct cs35l41_private *cs35l41)
 {
 	struct wm_adsp *dsp;
+	uint32_t dsp1rx5_src;
 	int ret;
 
 	dsp = &cs35l41->dsp;
@@ -1113,16 +1114,29 @@ static int cs35l41_dsp_init(struct cs35l41_private *cs35l41)
 		return ret;
 	}
 
-	ret = regmap_write(cs35l41->regmap, CS35L41_DSP1_RX5_SRC,
-			   CS35L41_INPUT_SRC_VPMON);
+	switch (cs35l41->hw_cfg.bst_type) {
+	case CS35L41_INT_BOOST:
+	case CS35L41_SHD_BOOST_ACTV:
+		dsp1rx5_src = CS35L41_INPUT_SRC_VPMON;
+		break;
+	case CS35L41_EXT_BOOST:
+	case CS35L41_SHD_BOOST_PASS:
+		dsp1rx5_src = CS35L41_INPUT_SRC_VBSTMON;
+		break;
+	default:
+		dev_err(cs35l41->dev, "wm_halo_init failed - Invalid Boost Type: %d\n",
+			cs35l41->hw_cfg.bst_type);
+		goto err_dsp;
+	}
+
+	ret = regmap_write(cs35l41->regmap, CS35L41_DSP1_RX5_SRC, dsp1rx5_src);
 	if (ret < 0) {
-		dev_err(cs35l41->dev, "Write INPUT_SRC_VPMON failed: %d\n", ret);
+		dev_err(cs35l41->dev, "Write DSP1RX5_SRC: %d failed: %d\n", dsp1rx5_src, ret);
 		goto err_dsp;
 	}
-	ret = regmap_write(cs35l41->regmap, CS35L41_DSP1_RX6_SRC,
-			   CS35L41_INPUT_SRC_CLASSH);
+	ret = regmap_write(cs35l41->regmap, CS35L41_DSP1_RX6_SRC, CS35L41_INPUT_SRC_VBSTMON);
 	if (ret < 0) {
-		dev_err(cs35l41->dev, "Write INPUT_SRC_CLASSH failed: %d\n", ret);
+		dev_err(cs35l41->dev, "Write CS35L41_INPUT_SRC_VBSTMON failed: %d\n", ret);
 		goto err_dsp;
 	}
 	ret = regmap_write(cs35l41->regmap, CS35L41_DSP1_RX7_SRC,
-- 
2.43.0



