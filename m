Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5E633A003;
	Tue,  6 Jan 2026 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721975; cv=none; b=EzvppAydrE1PssIZhjISPlfszj9FwxC3fQvzX9Wm4lxjX8zWzShJzcZ3sm8Cg15FDsWJlDBsm09QrbFOCwsrrMls6hjRkTxxBb7pdwZDZlMhIXYNzoa0gbba/UIPJxkgAsJI0WC0PpnBLPGAVWU7lIeW8YQ8kSvQtE7z/pKhVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721975; c=relaxed/simple;
	bh=hRXKmCs+vcMbOecwxmPRiES8aLY4lE7bSJeWAs6nfdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D16jjJQhca7jS73owQ+5yJRQr7K58ewGs5SGN3OVY5frMOq6N5ou2FUq7UXSwyOXdLAX2+npC5cO2rp6j+bVg+hphnaqq4a2pAbyR1SmTEU1FdP+YWqbz2X/YKckan1hiDIS3xDp4amsIYsjuJ+Pm5YTne/XzdZ8GJq+9Q0Dsl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg7Im4aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg7Im4aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73404C116C6;
	Tue,  6 Jan 2026 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721974;
	bh=hRXKmCs+vcMbOecwxmPRiES8aLY4lE7bSJeWAs6nfdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg7Im4aIOG63il0CXnNiBR9Ky9FgLGLfFB/IoWJ5giSIvWej1YQjQ3X6ybfjxq06F
	 X6+pbJrYyCfPEzZ9Sj0lVz/OQ+eSKQRdfjQoEt0CpnDYvYYbVa/nozv+zvJyav2bv3
	 ABaukCNiUnKSmG4FvRY2RX8SCyV5LMJr6SygXnjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tony Tang <tony.tang.ks@renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 095/312] ASoC: renesas: rz-ssi: Fix channel swap issue in full duplex mode
Date: Tue,  6 Jan 2026 18:02:49 +0100
Message-ID: <20260106170551.277840190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 52a525011cb8e293799a085436f026f2958403f9 upstream.

The full duplex audio starts with half duplex mode and then switch to
full duplex mode (another FIFO reset) when both playback/capture
streams available leading to random audio left/right channel swap
issue. Fix this channel swap issue by detecting the full duplex
condition by populating struct dup variable in startup() callback
and synchronize starting both the play and capture at the same time
in rz_ssi_start().

Cc: stable@kernel.org
Fixes: 4f8cd05a4305 ("ASoC: sh: rz-ssi: Add full duplex support")
Co-developed-by: Tony Tang <tony.tang.ks@renesas.com>
Signed-off-by: Tony Tang <tony.tang.ks@renesas.com>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251114073709.4376-2-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/renesas/rz-ssi.c |   51 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

--- a/sound/soc/renesas/rz-ssi.c
+++ b/sound/soc/renesas/rz-ssi.c
@@ -133,6 +133,12 @@ struct rz_ssi_priv {
 	bool bckp_rise;	/* Bit clock polarity (SSICR.BCKP) */
 	bool dma_rt;
 
+	struct {
+		bool tx_active;
+		bool rx_active;
+		bool one_stream_triggered;
+	} dup;
+
 	/* Full duplex communication support */
 	struct {
 		unsigned int rate;
@@ -332,13 +338,12 @@ static int rz_ssi_start(struct rz_ssi_pr
 	bool is_full_duplex;
 	u32 ssicr, ssifcr;
 
-	is_full_duplex = rz_ssi_is_stream_running(&ssi->playback) ||
-		rz_ssi_is_stream_running(&ssi->capture);
+	is_full_duplex = ssi->dup.tx_active && ssi->dup.rx_active;
 	ssicr = rz_ssi_reg_readl(ssi, SSICR);
 	ssifcr = rz_ssi_reg_readl(ssi, SSIFCR);
 	if (!is_full_duplex) {
 		ssifcr &= ~0xF;
-	} else {
+	} else if (ssi->dup.one_stream_triggered) {
 		rz_ssi_reg_mask_setl(ssi, SSICR, SSICR_TEN | SSICR_REN, 0);
 		rz_ssi_set_idle(ssi);
 		ssifcr &= ~SSIFCR_FIFO_RST;
@@ -374,12 +379,16 @@ static int rz_ssi_start(struct rz_ssi_pr
 			      SSISR_RUIRQ), 0);
 
 	strm->running = 1;
-	if (is_full_duplex)
-		ssicr |= SSICR_TEN | SSICR_REN;
-	else
+	if (!is_full_duplex) {
 		ssicr |= is_play ? SSICR_TEN : SSICR_REN;
-
-	rz_ssi_reg_writel(ssi, SSICR, ssicr);
+		rz_ssi_reg_writel(ssi, SSICR, ssicr);
+	} else if (ssi->dup.one_stream_triggered) {
+		ssicr |= SSICR_TEN | SSICR_REN;
+		rz_ssi_reg_writel(ssi, SSICR, ssicr);
+		ssi->dup.one_stream_triggered = false;
+	} else {
+		ssi->dup.one_stream_triggered = true;
+	}
 
 	return 0;
 }
@@ -915,6 +924,30 @@ static int rz_ssi_dai_set_fmt(struct snd
 	return 0;
 }
 
+static int rz_ssi_startup(struct snd_pcm_substream *substream,
+			  struct snd_soc_dai *dai)
+{
+	struct rz_ssi_priv *ssi = snd_soc_dai_get_drvdata(dai);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		ssi->dup.tx_active = true;
+	else
+		ssi->dup.rx_active = true;
+
+	return 0;
+}
+
+static void rz_ssi_shutdown(struct snd_pcm_substream *substream,
+			    struct snd_soc_dai *dai)
+{
+	struct rz_ssi_priv *ssi = snd_soc_dai_get_drvdata(dai);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		ssi->dup.tx_active = false;
+	else
+		ssi->dup.rx_active = false;
+}
+
 static bool rz_ssi_is_valid_hw_params(struct rz_ssi_priv *ssi, unsigned int rate,
 				      unsigned int channels,
 				      unsigned int sample_width,
@@ -985,6 +1018,8 @@ static int rz_ssi_dai_hw_params(struct s
 }
 
 static const struct snd_soc_dai_ops rz_ssi_dai_ops = {
+	.startup	= rz_ssi_startup,
+	.shutdown	= rz_ssi_shutdown,
 	.trigger	= rz_ssi_dai_trigger,
 	.set_fmt	= rz_ssi_dai_set_fmt,
 	.hw_params	= rz_ssi_dai_hw_params,


