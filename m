Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDA1BD51C;
	Tue,  2 Jul 2024 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940083; cv=none; b=foygGDd55FHOV5Qzzd4iN0dCwZ6fg1tRl2fy3IzBrvFo8BtqS5dDWTbfUphVsG3DOzzduuSpysmBqXeqbA3PnPrUdtOzhROIS2PQQ21VR4huPhJHUqERAPppauVmqUtDtDWyddBiWR51Ne4nEpoU9J6ev9iW7PpuiOeTqzaaZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940083; c=relaxed/simple;
	bh=MavLO+JB6mu0+csJifHF9M4Ddtsu1KqqTefARpV2ayE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6NmpJEav6SM+qPNmWMWuM+MTor4w21Ij0SLt7XNBHfMZq9EZW+6HFKCuVbI8oMv2TEZF0fv2EsCtxsU3x/MdaESZjrN4rqNSs+iNPyp3KCjHEUhOeRkP+CfMRN7K6/vcGTuHL6SMnc1co1BOiTPsLAcqxR7EML5bgdYxcl3hQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETNo/WR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETNo/WR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866FFC116B1;
	Tue,  2 Jul 2024 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940083;
	bh=MavLO+JB6mu0+csJifHF9M4Ddtsu1KqqTefARpV2ayE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETNo/WR9UkprXWL+22mVK5k9zi20TuehX0it+D2mrIPuPPgTgaX20R0Gi04LW4FWf
	 u+PXI5Tg9BQrbRSmz+62Efj0X6u9AIGcqBMcu7XYfNTl7JEIP/Tj5yoB/bK06Dn4f/
	 c0EhtWAg+7v/InDzNdqepmz6xta+LrxJ9O8Wyxus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alibek Omarov <a1ba.omarov@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 016/222] ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk
Date: Tue,  2 Jul 2024 19:00:54 +0200
Message-ID: <20240702170244.595124779@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Alibek Omarov <a1ba.omarov@gmail.com>

[ Upstream commit ccd8d753f0fe8f16745fa2b6be5946349731d901 ]

When TRCM mode is enabled, I2S RX and TX clocks are synchronized through
selected clock source. Without this fix BCLK and LRCK might get parented
to an uninitialized MCLK and the DAI will receive data at wrong pace.

However, unlike in original i2s-tdm driver, there is no need to manually
synchronize mclk_rx and mclk_tx, as only one gets used anyway.

Tested on a board with RK3568 SoC and Silergy SY24145S codec with enabled and
disabled TRCM mode.

Fixes: 9e2ab4b18ebd ("ASoC: rockchip: i2s-tdm: Fix inaccurate sampling rates")
Signed-off-by: Alibek Omarov <a1ba.omarov@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://msgid.link/r/20240604184752.697313-1-a1ba.omarov@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s_tdm.c b/sound/soc/rockchip/rockchip_i2s_tdm.c
index 9fa020ef7eab9..ee517d7b5b7bb 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -655,8 +655,17 @@ static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
 	int err;
 
 	if (i2s_tdm->is_master_mode) {
-		struct clk *mclk = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
-			i2s_tdm->mclk_tx : i2s_tdm->mclk_rx;
+		struct clk *mclk;
+
+		if (i2s_tdm->clk_trcm == TRCM_TX) {
+			mclk = i2s_tdm->mclk_tx;
+		} else if (i2s_tdm->clk_trcm == TRCM_RX) {
+			mclk = i2s_tdm->mclk_rx;
+		} else if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+			mclk = i2s_tdm->mclk_tx;
+		} else {
+			mclk = i2s_tdm->mclk_rx;
+		}
 
 		err = clk_set_rate(mclk, DEFAULT_MCLK_FS * params_rate(params));
 		if (err)
-- 
2.43.0



