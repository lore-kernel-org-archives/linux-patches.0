Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EB36607D;
	Thu, 30 Jul 2026 15:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426383; cv=none; b=JN+dktR3EYYborxcpONE2RVnmmQvyihuOYMAc9R5oYg+bKNsmoVKwtpc2GVP5oEhaN+MBwmb/mf/6YxIL1AJ3h2RJz7j2Gn8Xqt56ZyP5sKb5L3ClgQ7A8RYDSLBD7Ar/0a90bGo9bIABz2VMdPqVbvTeUDkbQfRH4HXlgGbQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426383; c=relaxed/simple;
	bh=vb0MZ8CTeH8bwYf/V4LuuXTBGQMBluSz3pEAUp/e4U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYyLzzERFnj3OVwcSA64oRkMgFZHoHw5K4gUFEnBrbpXXDszZJiES2b8UDGMivk4U9rb4U1dvaq8XEx8wIBAS6nKn66t7w63m6DvHcWKwq7Nn5tvckjlTrHFzD0PGvNFzRznbMkoCgs3nS9fuWfPmRXtSeV11fAqfZqWap/iFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEbnKfKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEbnKfKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374961F000E9;
	Thu, 30 Jul 2026 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426382;
	bh=XCqnNJ/TL6KTjHnJ5KOdl9i73fzQ902Vc7Ui5tgLG+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEbnKfKFB62woiSF0SJJM7NIUEJQmnPJeOrhS+UWm41iH10iIuXqxSI97/opztNgZ
	 4Frp/zQ5FglDjE9ilH/vD6nSVPduzx15T9oSHH0eUIaCgaucPwM5muICl30D5Zjr1n
	 XLFQHc0/FkvEkc3esSDOs6waEPmIU/EcXYumht2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 400/602] ASoC: fsl_sai: Fix spurious BCLK on resume by clearing BYP
Date: Thu, 30 Jul 2026 16:13:12 +0200
Message-ID: <20260730141444.366888579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chancel Liu <chancel.liu@nxp.com>

commit d091132889c1378dd0944a72f86eae3e4da1e4fa upstream.

When the BCLK divider ratio is 1:1, fsl_sai_set_bclk() enables bypass
mode by setting BYP, but never clears the bit. The BYP=1 value remains
in the regcache, and is restored by regcache_sync() on the next runtime
resume.

Since BYP=1 combined with BCD=1 immediately outputs the ungated MCLK
as BCLK without waiting for BCE/TE/RE to be enabled, the clock is
driven prematurely before the stream is fully configured, causing
noise on some codecs.

Fix this by clearing BYP and BCI in fsl_sai_hw_free() taking into
account sync mode and the opposite stream's state, so that the regcache
holds BYP=0 before runtime suspend and regcache_sync() on resume will
not restore bypass mode prematurely.

Fixes: a50b7926d015 ("ASoC: fsl_sai: implement 1:1 bclk:mclk ratio support")
Cc: stable@vger.kernel.org
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Reviewed-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20260710070835.3749817-1-chancel.liu@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -725,6 +725,8 @@ static int fsl_sai_hw_free(struct snd_pc
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	unsigned int ofs = sai->soc_data->reg_offset;
+	int adir = tx ? RX : TX;
+	int dir  = tx ? TX : RX;
 
 	/* Clear xMR to avoid channel swap with mclk_with_tere enabled case */
 	regmap_write(sai->regmap, FSL_SAI_xMR(tx), 0);
@@ -732,10 +734,29 @@ static int fsl_sai_hw_free(struct snd_pc
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR3(tx, ofs),
 			   FSL_SAI_CR3_TRCE_MASK, 0);
 
-	if (!sai->is_consumer_mode[tx] &&
-	    sai->mclk_streams & BIT(substream->stream)) {
-		clk_disable_unprepare(sai->mclk_clk[sai->mclk_id[tx]]);
-		sai->mclk_streams &= ~BIT(substream->stream);
+	if (!sai->is_consumer_mode[tx]) {
+		bool adir_active = !!(sai->mclk_streams & BIT(!substream->stream));
+		/*
+		 * If opposite stream provides clocks for synchronous mode and
+		 * it is inactive, Clear BYP and BCI
+		 */
+		if (fsl_sai_dir_is_synced(sai, adir) && !adir_active)
+			regmap_update_bits(sai->regmap, FSL_SAI_xCR2(!tx, ofs),
+					   FSL_SAI_CR2_BCI | FSL_SAI_CR2_BYP, 0);
+		/*
+		 * Clear BYP and BCI of current stream if either of:
+		 * 1. current stream doesn't provide clocks for synchronous mode
+		 * 2. current stream provides clocks for synchronous mode but no
+		 *    more stream is active.
+		 */
+		if (!fsl_sai_dir_is_synced(sai, dir) || !adir_active)
+			regmap_update_bits(sai->regmap, FSL_SAI_xCR2(tx, ofs),
+					   FSL_SAI_CR2_BCI | FSL_SAI_CR2_BYP, 0);
+
+		if (sai->mclk_streams & BIT(substream->stream)) {
+			clk_disable_unprepare(sai->mclk_clk[sai->mclk_id[tx]]);
+			sai->mclk_streams &= ~BIT(substream->stream);
+		}
 	}
 
 	return 0;


