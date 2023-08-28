Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D6F611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961B3C433C7;
	Mon, 28 Aug 2023 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219210;
	bh=VRvjz2FU5r0sHR4HHw2WhLNSYFPt3cP774XNGKKJaGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kENzfoAlTDP2y8D1Xl1wkskCj0lar9SYJPBNBQhph0HZttlhIkqlvUoWhmALGjbY
	 HyyOqnFSPpls9Dy/JogeESH2+UWq8QSM08eNwnoiMESkTgi1fvTycrOZQF3pfrbY/b
	 M6BMBzpdvQz9fthy+nWXdYM3ynTxKODOpm47+y30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Nicolin Chen <nicoleotsuka@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/158] ASoC: fsl_sai: Refine enable/disable TE/RE sequence in trigger()
Date: Mon, 28 Aug 2023 12:13:30 +0200
Message-ID: <20230828101201.110348399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 94741eba63c23b0f1527b0ae0125e6b553bde10e ]

Current code enables TCSR.TE and RCSR.RE together, and disable
TCSR.TE and RCSR.RE together in trigger(), which only supports
one operation mode：
1. Rx synchronous with Tx: TE is last enabled and first disabled

Other operation mode need to be considered also:
2. Tx synchronous with Rx: RE is last enabled and first disabled.
3. Asynchronous mode: Tx and Rx are independent.

So the enable TCSR.TE and RCSR.RE sequence and the disable
sequence need to be refined accordingly for #2 and #3.

There is slightly against what RM recommennds with this change.
For example in Rx synchronous with Tx mode, case "aplay 1.wav;
arecord 2.wav" enable TE before RE. But it should be safe to
do so, judging by years of testing results.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20200805063413.4610-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 269f399dc19f ("ASoC: fsl_sai: Disable bit clock with transmitter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 126 +++++++++++++++++++++++++++-------------
 1 file changed, 85 insertions(+), 41 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index f8445231ad782..23f0b5ee000c3 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -37,6 +37,24 @@ static const struct snd_pcm_hw_constraint_list fsl_sai_rate_constraints = {
 	.list = fsl_sai_rates,
 };
 
+/**
+ * fsl_sai_dir_is_synced - Check if stream is synced by the opposite stream
+ *
+ * SAI supports synchronous mode using bit/frame clocks of either Transmitter's
+ * or Receiver's for both streams. This function is used to check if clocks of
+ * the stream's are synced by the opposite stream.
+ *
+ * @sai: SAI context
+ * @dir: stream direction
+ */
+static inline bool fsl_sai_dir_is_synced(struct fsl_sai *sai, int dir)
+{
+	int adir = (dir == TX) ? RX : TX;
+
+	/* current dir in async mode while opposite dir in sync mode */
+	return !sai->synchronous[dir] && sai->synchronous[adir];
+}
+
 static irqreturn_t fsl_sai_isr(int irq, void *devid)
 {
 	struct fsl_sai *sai = (struct fsl_sai *)devid;
@@ -523,6 +541,38 @@ static int fsl_sai_hw_free(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+static void fsl_sai_config_disable(struct fsl_sai *sai, int dir)
+{
+	unsigned int ofs = sai->soc_data->reg_offset;
+	bool tx = dir == TX;
+	u32 xcsr, count = 100;
+
+	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
+			   FSL_SAI_CSR_TERE, 0);
+
+	/* TERE will remain set till the end of current frame */
+	do {
+		udelay(10);
+		regmap_read(sai->regmap, FSL_SAI_xCSR(tx, ofs), &xcsr);
+	} while (--count && xcsr & FSL_SAI_CSR_TERE);
+
+	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
+			   FSL_SAI_CSR_FR, FSL_SAI_CSR_FR);
+
+	/*
+	 * For sai master mode, after several open/close sai,
+	 * there will be no frame clock, and can't recover
+	 * anymore. Add software reset to fix this issue.
+	 * This is a hardware bug, and will be fix in the
+	 * next sai version.
+	 */
+	if (!sai->is_slave_mode) {
+		/* Software Reset */
+		regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR);
+		/* Clear SR bit to finish the reset */
+		regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), 0);
+	}
+}
 
 static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		struct snd_soc_dai *cpu_dai)
@@ -531,7 +581,9 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	unsigned int ofs = sai->soc_data->reg_offset;
 
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
-	u32 xcsr, count = 100;
+	int adir = tx ? RX : TX;
+	int dir = tx ? TX : RX;
+	u32 xcsr;
 
 	/*
 	 * Asynchronous mode: Clear SYNC for both Tx and Rx.
@@ -554,10 +606,22 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
 				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
 
-		regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs),
-				   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
-		regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs),
+		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
 				   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
+		/*
+		 * Enable the opposite direction for synchronous mode
+		 * 1. Tx sync with Rx: only set RE for Rx; set TE & RE for Tx
+		 * 2. Rx sync with Tx: only set TE for Tx; set RE & TE for Rx
+		 *
+		 * RM recommends to enable RE after TE for case 1 and to enable
+		 * TE after RE for case 2, but we here may not always guarantee
+		 * that happens: "arecord 1.wav; aplay 2.wav" in case 1 enables
+		 * TE after RE, which is against what RM recommends but should
+		 * be safe to do, judging by years of testing results.
+		 */
+		if (fsl_sai_dir_is_synced(sai, adir))
+			regmap_update_bits(sai->regmap, FSL_SAI_xCSR((!tx), ofs),
+					   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
 
 		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
 				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
@@ -572,43 +636,23 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		/* Check if the opposite FRDE is also disabled */
 		regmap_read(sai->regmap, FSL_SAI_xCSR(!tx, ofs), &xcsr);
-		if (!(xcsr & FSL_SAI_CSR_FRDE)) {
-			/* Disable both directions and reset their FIFOs */
-			regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs),
-					   FSL_SAI_CSR_TERE, 0);
-			regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs),
-					   FSL_SAI_CSR_TERE, 0);
-
-			/* TERE will remain set till the end of current frame */
-			do {
-				udelay(10);
-				regmap_read(sai->regmap,
-					    FSL_SAI_xCSR(tx, ofs), &xcsr);
-			} while (--count && xcsr & FSL_SAI_CSR_TERE);
-
-			regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs),
-					   FSL_SAI_CSR_FR, FSL_SAI_CSR_FR);
-			regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs),
-					   FSL_SAI_CSR_FR, FSL_SAI_CSR_FR);
-
-			/*
-			 * For sai master mode, after several open/close sai,
-			 * there will be no frame clock, and can't recover
-			 * anymore. Add software reset to fix this issue.
-			 * This is a hardware bug, and will be fix in the
-			 * next sai version.
-			 */
-			if (!sai->is_slave_mode) {
-				/* Software Reset for both Tx and Rx */
-				regmap_write(sai->regmap, FSL_SAI_TCSR(ofs),
-					     FSL_SAI_CSR_SR);
-				regmap_write(sai->regmap, FSL_SAI_RCSR(ofs),
-					     FSL_SAI_CSR_SR);
-				/* Clear SR bit to finish the reset */
-				regmap_write(sai->regmap, FSL_SAI_TCSR(ofs), 0);
-				regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), 0);
-			}
-		}
+
+		/*
+		 * If opposite stream provides clocks for synchronous mode and
+		 * it is inactive, disable it before disabling the current one
+		 */
+		if (fsl_sai_dir_is_synced(sai, adir) && !(xcsr & FSL_SAI_CSR_FRDE))
+			fsl_sai_config_disable(sai, adir);
+
+		/*
+		 * Disable current stream if either of:
+		 * 1. current stream doesn't provide clocks for synchronous mode
+		 * 2. current stream provides clocks for synchronous mode but no
+		 *    more stream is active.
+		 */
+		if (!fsl_sai_dir_is_synced(sai, dir) || !(xcsr & FSL_SAI_CSR_FRDE))
+			fsl_sai_config_disable(sai, dir);
+
 		break;
 	default:
 		return -EINVAL;
-- 
2.40.1



