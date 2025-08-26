Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B180E3375DC;
	Tue, 26 Aug 2025 11:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208071; cv=none; b=H4GzPk/ce+/Ta3F4AVpesgLtkpb8JaAK9tH8pH3Hr3lPAm7b02mCN7IvQdFV37wIagXTUOLsBdcMEBd90fDVxaiIDcGNZCUjTGNamGLY2PYGaduNOOMZ8JCSVUBvugr/4/t+brEpDaiLXTFmBQNqtrwuQqJD1ZmMcxlBv1+cAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208071; c=relaxed/simple;
	bh=khHUBhAuhNZdLu5uXGDt1NJ1qZ3fkL0alQy//bVQ5RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6Uk7s0aJbxhB2sgy8lzjD8E80tH/815VI7Mr/+0hlXZJ5106uPKtTkbTaeI5quFWGFJtsvE5KTu+/TOL4gmlhB45EZHArUSoWyCFT3U0WikT6gMm2XliokCDrlF1D/vbcYb5LJMSYREVqWb9nW/qSkPcQT8nimrE+lDLba/9/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+N+SNg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+N+SNg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B6C19421;
	Tue, 26 Aug 2025 11:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208071;
	bh=khHUBhAuhNZdLu5uXGDt1NJ1qZ3fkL0alQy//bVQ5RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+N+SNg6uewuSoWV+4sr8mfbqEPaRnGbpZ/ApbWbVsqkKuybemifAlgsLGpuzXTgx
	 MhjwMZr7giQfTwEPOXzo/neNozy1Tv8cHDEw5YTfuF2I+Y83rrdOQYS+N6/d1u8R2Y
	 OR8Dmce+dRDPVTOXLMn7/BBGyJQw+tLKNfROrMo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 427/457] ASoC: cs35l56: Remove SoundWire Clock Divider workaround for CS35L63
Date: Tue, 26 Aug 2025 13:11:51 +0200
Message-ID: <20250826110947.842003226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 8d13d1bdb59d0a2c526869ee571ec51a3a887463 ]

Production silicon for CS36L63 has some small differences compared to
pre-production silicon. Remove soundwire clock workaround as no
longer necessary. We don't want to do tricks with low-level clocking
controls if we don't need to.

Fixes: 978858791ced ("ASoC: cs35l56: Add initial support for CS35L63 for I2C and SoundWire")

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250820142209.127575-4-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-sdw.c | 69 ----------------------------------
 sound/soc/codecs/cs35l56.h     |  3 --
 2 files changed, 72 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index fa9693af3722..d7fa12d287e0 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -394,74 +394,6 @@ static int cs35l56_sdw_update_status(struct sdw_slave *peripheral,
 	return 0;
 }
 
-static int cs35l63_sdw_kick_divider(struct cs35l56_private *cs35l56,
-				    struct sdw_slave *peripheral)
-{
-	unsigned int curr_scale_reg, next_scale_reg;
-	int curr_scale, next_scale, ret;
-
-	if (!cs35l56->base.init_done)
-		return 0;
-
-	if (peripheral->bus->params.curr_bank) {
-		curr_scale_reg = SDW_SCP_BUSCLOCK_SCALE_B1;
-		next_scale_reg = SDW_SCP_BUSCLOCK_SCALE_B0;
-	} else {
-		curr_scale_reg = SDW_SCP_BUSCLOCK_SCALE_B0;
-		next_scale_reg = SDW_SCP_BUSCLOCK_SCALE_B1;
-	}
-
-	/*
-	 * Current clock scale value must be different to new value.
-	 * Modify current to guarantee this. If next still has the dummy
-	 * value we wrote when it was current, the core code has not set
-	 * a new scale so restore its original good value
-	 */
-	curr_scale = sdw_read_no_pm(peripheral, curr_scale_reg);
-	if (curr_scale < 0) {
-		dev_err(cs35l56->base.dev, "Failed to read current clock scale: %d\n", curr_scale);
-		return curr_scale;
-	}
-
-	next_scale = sdw_read_no_pm(peripheral, next_scale_reg);
-	if (next_scale < 0) {
-		dev_err(cs35l56->base.dev, "Failed to read next clock scale: %d\n", next_scale);
-		return next_scale;
-	}
-
-	if (next_scale == CS35L56_SDW_INVALID_BUS_SCALE) {
-		next_scale = cs35l56->old_sdw_clock_scale;
-		ret = sdw_write_no_pm(peripheral, next_scale_reg, next_scale);
-		if (ret < 0) {
-			dev_err(cs35l56->base.dev, "Failed to modify current clock scale: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	cs35l56->old_sdw_clock_scale = curr_scale;
-	ret = sdw_write_no_pm(peripheral, curr_scale_reg, CS35L56_SDW_INVALID_BUS_SCALE);
-	if (ret < 0) {
-		dev_err(cs35l56->base.dev, "Failed to modify current clock scale: %d\n", ret);
-		return ret;
-	}
-
-	dev_dbg(cs35l56->base.dev, "Next bus scale: %#x\n", next_scale);
-
-	return 0;
-}
-
-static int cs35l56_sdw_bus_config(struct sdw_slave *peripheral,
-				  struct sdw_bus_params *params)
-{
-	struct cs35l56_private *cs35l56 = dev_get_drvdata(&peripheral->dev);
-
-	if ((cs35l56->base.type == 0x63) && (cs35l56->base.rev < 0xa1))
-		return cs35l63_sdw_kick_divider(cs35l56, peripheral);
-
-	return 0;
-}
-
 static int __maybe_unused cs35l56_sdw_clk_stop(struct sdw_slave *peripheral,
 					       enum sdw_clk_stop_mode mode,
 					       enum sdw_clk_stop_type type)
@@ -477,7 +409,6 @@ static const struct sdw_slave_ops cs35l56_sdw_ops = {
 	.read_prop = cs35l56_sdw_read_prop,
 	.interrupt_callback = cs35l56_sdw_interrupt,
 	.update_status = cs35l56_sdw_update_status,
-	.bus_config = cs35l56_sdw_bus_config,
 #ifdef DEBUG
 	.clk_stop = cs35l56_sdw_clk_stop,
 #endif
diff --git a/sound/soc/codecs/cs35l56.h b/sound/soc/codecs/cs35l56.h
index bd77a57249d7..40a1800a4585 100644
--- a/sound/soc/codecs/cs35l56.h
+++ b/sound/soc/codecs/cs35l56.h
@@ -20,8 +20,6 @@
 #define CS35L56_SDW_GEN_INT_MASK_1	0xc1
 #define CS35L56_SDW_INT_MASK_CODEC_IRQ	BIT(0)
 
-#define CS35L56_SDW_INVALID_BUS_SCALE	0xf
-
 #define CS35L56_RX_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE)
 #define CS35L56_TX_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE \
 			    | SNDRV_PCM_FMTBIT_S32_LE)
@@ -52,7 +50,6 @@ struct cs35l56_private {
 	u8 asp_slot_count;
 	bool tdm_mode;
 	bool sysclk_set;
-	u8 old_sdw_clock_scale;
 	u8 sdw_link_num;
 	u8 sdw_unique_id;
 };
-- 
2.50.1



