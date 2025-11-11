Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559442E173B;
	Tue, 11 Nov 2025 01:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825054; cv=none; b=PEXO5UeH3KsXvFvwY7vKnvz7IXcJk3Rv+0nDOB+E3Rrx2rAiEz/HJ2nZGK8guG2+tVyRif7GUnoiEsY/+QerPQaFk6d1pCNhBnpUyLA6vf5m5szLqTtBx+mR7x5pAqfy7mP33lYQzejPdPWpjXgQr2mLL7GU0XnRdY4j8NWyat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825054; c=relaxed/simple;
	bh=GhecjbY0axHri7hWSWLD9/Dlxa+HpJeq2mBFrpzZMPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzRJtPNtk/PlZvd+qrgg5zRoZ7UtZu0VCF5A/cMxgKL+h1qNN1tl6wjHK1MwSVJTGlARFs5FzpdhluPpZE09DIoElm9MlLPsBun+duPPholak/1WodjsSOTl52rox/cGozBm++FtPj8oQjtHpHSw61nmkcDzG50Dr+npsWAR+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYHisdVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYHisdVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A7CC19422;
	Tue, 11 Nov 2025 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825054;
	bh=GhecjbY0axHri7hWSWLD9/Dlxa+HpJeq2mBFrpzZMPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYHisdVp8EfnhtDSeaohvPaKq9u9RYr+/YKP8worawTT0pWpEfMUtJuNLkoecdTAP
	 JFTlnCkeNYS8mhs/M6F/a0YbFJOk2vl7IjAAupiKIwvLOf38lwSkpDrX7i9rELvKEd
	 qQD1VJsAEb6zwlsYvFJfOYcyfvzD9lv83R1msRLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yusuke Goda <yusuke.goda.sx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 641/849] ASoC: renesas: msiof: use reset controller
Date: Tue, 11 Nov 2025 09:43:31 +0900
Message-ID: <20251111004551.927682469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 25226abc1affd4bf4f6dd415d475b76e7a273fa8 ]

MSIOF has TXRST/RXRST to reset FIFO, but it shouldn't be used during SYNC
signal was asserted, because it will be cause of HW issue.

When MSIOF is used as Sound driver, this driver is assuming it is used as
clock consumer mode (= Codec is clock provider). This means, it can't
control SYNC signal by itself.

We need to use SW reset (= reset_control_xxx()) instead of TXRST/RXRST.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Link: https://patch.msgid.link/87cy7fyuug.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/msiof.c | 39 +++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/msiof.c b/sound/soc/renesas/rcar/msiof.c
index 7a9ecc73231a8..3a1a6496637dd 100644
--- a/sound/soc/renesas/rcar/msiof.c
+++ b/sound/soc/renesas/rcar/msiof.c
@@ -24,12 +24,25 @@
  * Clock/Frame Consumer Mode.
  */
 
+/*
+ * [NOTE-RESET]
+ *
+ * MSIOF has TXRST/RXRST to reset FIFO, but it shouldn't be used during SYNC signal was asserted,
+ * because it will be cause of HW issue.
+ *
+ * When MSIOF is used as Sound driver, this driver is assuming it is used as clock consumer mode
+ * (= Codec is clock provider). This means, it can't control SYNC signal by itself.
+ *
+ * We need to use SW reset (= reset_control_xxx()) instead of TXRST/RXRST.
+ */
+
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_dma.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include <linux/spi/sh_msiof.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/soc.h>
@@ -61,10 +74,13 @@
 struct msiof_priv {
 	struct device *dev;
 	struct snd_pcm_substream *substream[SNDRV_PCM_STREAM_LAST + 1];
+	struct reset_control *reset;
 	spinlock_t lock;
 	void __iomem *base;
 	resource_size_t phy_addr;
 
+	int count;
+
 	/* for error */
 	int err_syc[SNDRV_PCM_STREAM_LAST + 1];
 	int err_ovf[SNDRV_PCM_STREAM_LAST + 1];
@@ -126,6 +142,16 @@ static int msiof_hw_start(struct snd_soc_component *component,
 	 *	RX: Fig 109.15
 	 */
 
+	/*
+	 * Use reset_control_xx() instead of TXRST/RXRST.
+	 * see
+	 *	[NOTE-RESET]
+	 */
+	if (!priv->count)
+		reset_control_deassert(priv->reset);
+
+	priv->count++;
+
 	/* reset errors */
 	priv->err_syc[substream->stream] =
 	priv->err_ovf[substream->stream] =
@@ -144,7 +170,6 @@ static int msiof_hw_start(struct snd_soc_component *component,
 		val = FIELD_PREP(SIMDR2_BITLEN1, width - 1);
 		msiof_write(priv, SITMDR2, val | FIELD_PREP(SIMDR2_GRP, 1));
 		msiof_write(priv, SITMDR3, val);
-
 	}
 	/* SIRMDRx */
 	else {
@@ -217,6 +242,11 @@ static int msiof_hw_stop(struct snd_soc_component *component,
 			 priv->err_ovf[substream->stream],
 			 priv->err_udf[substream->stream]);
 
+	priv->count--;
+
+	if (!priv->count)
+		reset_control_assert(priv->reset);
+
 	return 0;
 }
 
@@ -493,12 +523,19 @@ static int msiof_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
+	priv->reset = devm_reset_control_get_exclusive(dev, NULL);
+	if (IS_ERR(priv->reset))
+		return PTR_ERR(priv->reset);
+
+	reset_control_assert(priv->reset);
+
 	ret = devm_request_irq(dev, irq, msiof_interrupt, 0, dev_name(dev), priv);
 	if (ret)
 		return ret;
 
 	priv->dev	= dev;
 	priv->phy_addr	= res->start;
+	priv->count	= 0;
 
 	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
-- 
2.51.0



