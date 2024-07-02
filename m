Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F667178381;
	Tue,  2 Jul 2024 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940716; cv=none; b=nMrXUGCjek+Mv+pVRkMf0rfFyB99oFJ8fqsTruG2/mVQGv2tRS1iAbiGjW09KYJu5uK5T7gPn1dxlfSygcVtwy/jXWketsMfcL/ajLILLJjyjumPRraeemYV8AuefqmAg9PjyLf2N6QFVyEWZA3/tij8UUr0DVxvKNBZnkiGyfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940716; c=relaxed/simple;
	bh=5eCt+1Q6pyAeDGe7Yi6iJ6Hf2XyUKweOc3Agk9Jt0pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0FAWanvUNoFwS2pkaGuLCHDbtVAtLvlYgw0QDx5BtDXPdxeYBw0y5e6vp8r0mwBoGm2Ua35L7hFdpvGVSQ56C/9HPa18pOFy5EY8SQEc8e3Soi2+cXnifmSKWnmbSTTp4ztvwAl0JbuXjbe9TN33XD8i2P3S2oskoJxEr58S2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxjS/lCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxjS/lCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3573C116B1;
	Tue,  2 Jul 2024 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940716;
	bh=5eCt+1Q6pyAeDGe7Yi6iJ6Hf2XyUKweOc3Agk9Jt0pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxjS/lCKDP+xcC01ofVe9PlnsX0MMOFunRK3aLNLZ2PnLefRHomLEisOaEXF3Dagz
	 ewCYllu7DA3+cdci1tkWv7xB2euRGF6DHca7bRtoD0aHmzHdgcamQiuUxkq3W9gIDA
	 jQXvAvYC9gwowxH4z7/3noXJWUlGxKsaeZY1UXwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alibek Omarov <a1ba.omarov@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/163] ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk
Date: Tue,  2 Jul 2024 19:02:10 +0200
Message-ID: <20240702170233.672348444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 15f8919fd224a..e6a6eabc47e5b 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -657,8 +657,17 @@ static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
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



