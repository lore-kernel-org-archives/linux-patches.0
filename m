Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B01514DC;
	Tue,  2 Jul 2024 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941273; cv=none; b=hRvGS8/FdaMQ61tT3OnjXFZ/YAulONeUHQfisCWk4lK/KZm6AtAA+CYqiHDwiuoDF8ig2+YkdATbe89VzWh8gDrRyfY27/G/3dvXglhCzwFCPntBT1NZdg+vduWsgXDN+OY07vrgVyEnRMlUa7LBjm1Ut908da65ECbbm+4D7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941273; c=relaxed/simple;
	bh=NqL3NZSuMHcEgknVSYLLWh2ZfZp+la461hk188aeYqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCPGQsropqlFhtFDhmNNS1s6a/k2qc5zrNQ4OWbuKCSiV+KO+0Itim6PxyNMs8pRwbqhM/2CJe57HoG+xwXvSrMBw2A71zBoXJRNhrkPDqZE7wxv7YPDyC8G86URbd2icNqYFaisRWZ7nyXv6frZkWj8vZK8Wp9KLB8kU56zxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Snu97psJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Snu97psJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87875C116B1;
	Tue,  2 Jul 2024 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941273;
	bh=NqL3NZSuMHcEgknVSYLLWh2ZfZp+la461hk188aeYqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snu97psJa4to1OiaRkkuAwyHl8drfrsU6Mq8H7kxFKoy3yXAWYkx6fgFtLoreMFq9
	 JiWsC7XVUATcxmfBePR5PPD1ykm1GE3bdlQq5qqpH56gy5KkBQ2AxVvrYY+ef/z1Wo
	 7kyT4uzB6G/PpHNpjnW1rowwjNEXZEULGaZvU0NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alibek Omarov <a1ba.omarov@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/128] ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk
Date: Tue,  2 Jul 2024 19:03:37 +0200
Message-ID: <20240702170226.847003196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e36a97077b99..bcea52fa45a50 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -651,8 +651,17 @@ static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
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



