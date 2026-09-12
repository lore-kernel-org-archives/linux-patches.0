Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B75472F66;
	Sat, 12 Sep 2026 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218140; cv=none; b=aWYSvAyHJtMrC3kz1y1nLLMJECGfrJYR5dnK5aPiNnB7npBI0GTCV1VYbcOLR1fmDoJiF/1rASvjaZEJvNVrBSL7cFu1VNbP3QtkR3ZAd8k41VFBBH6jvHPpHn8WqPE9j4OKT6+ruYbLSi45JyVCuFpxUU81tADp9i23thVGFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218140; c=relaxed/simple;
	bh=vT5hALr3J0laegr2U2ntpUWRTEvEeewdOI6OCVZpibY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPpn5XP6X0xn6k8dRuWoQORp5MHtOTPb+JZKaLiyHJn0qUsJQM9LngiiLwhtQw5RxMxzQXguTgT6/OODz0O534NczpUs2nR17XdOLG8qpVv/rpocc69SbuOPPgEiIEBE//xARPN8Pq2W87ApPqy+z8I1uqMsWOswPrDf8FDLSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUIYYdup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUIYYdup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C91F000FF;
	Sat, 12 Sep 2026 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218138;
	bh=AqOv7l0bJ/egvZRw8d4anMvtnyQPKV79YDUgyTKXYe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUIYYdups19VAP1jFaR2Nxx54M9rgI1k78Sjmfxq1UuXsaRvWBh8CT3dcetOeCok3
	 ABNff+PGasoyTHGe3rhQ6UClgmfWdB5zFo8bJ8x4ySpGikHEwQHJouYvWV0qOkJdYx
	 hURCqnROFg3A9lJkm8hcs9xYMDSwaKrmFFa7s5IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1083/1376] ASoC: xilinx: formatter_pcm: fix stream_data leak on open error
Date: Sat, 12 Sep 2026 08:58:29 +0200
Message-ID: <20260912065631.700267064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b992511180e126150c6ad3580a6fd568c385f4c6 ]

In xlnx_formatter_pcm_open(), stream_data is allocated and
adata->play_stream or adata->capture_stream is assigned early.  If a
later step, such as snd_pcm_hw_constraint_step() or
snd_pcm_hw_constraint_integer(), fails, the function returns the error
immediately.  ALSA does not call the close callback when open fails, so
stream_data is leaked and the stream pointer is left dangling, pointing
to a substream that ALSA frees.  A later interrupt would then call
snd_pcm_period_elapsed() on the freed substream.

Free stream_data and clear the stream pointer on the error paths.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260811185140.27149-1-rosenp@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index 45b178148b98b..4d90e96a677c9 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -384,7 +384,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err) {
 		dev_err(component->dev,
 			"Unable to set constraint on period bytes\n");
-		return err;
+		goto error;
 	}
 
 	/* Resize the buffer bytes as divisible by 64 */
@@ -394,7 +394,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err) {
 		dev_err(component->dev,
 			"Unable to set constraint on buffer bytes\n");
-		return err;
+		goto error;
 	}
 
 	/* Set periods as integer multiple */
@@ -403,7 +403,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err < 0) {
 		dev_err(component->dev,
 			"Unable to set constraint on periods to be integer\n");
-		return err;
+		goto error;
 	}
 
 	/* enable DMA IOC irq */
@@ -412,6 +412,14 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	writel(val, stream_data->mmio + XLNX_AUD_CTRL);
 
 	return 0;
+
+error:
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		adata->play_stream = NULL;
+	else
+		adata->capture_stream = NULL;
+	kfree(stream_data);
+	return err;
 }
 
 static int xlnx_formatter_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



