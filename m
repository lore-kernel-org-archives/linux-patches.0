Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA13D0D1;
	Tue, 14 May 2024 11:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687687; cv=none; b=f2CwJ5WNkeqTuCyT3Q0//eouctQtThuXSDly6zkwCCdJ0KDPejcvA93IR5W22+e9QerokxOEgT4XCdRnEVIPEY5T5BS9wUM+ZsUxycRzpB/IcuVBOTOjyHQ/PgV+sqUALcXO7vjdnz9Cf1MHa3zhKrzGfuPy/XoVxiApJrNfxMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687687; c=relaxed/simple;
	bh=YA7DM+TWTggd5TRiErOFv++/B4JLbCxGSaq4HFcIzQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPLyfyRTOPsb+eMyeMzgCPnyeJLOaV/LperqKuJF5CPrlJC2neMNvxbVzUsXhOsHmAIxkhV2hlShYy+yUNsuDh5HlPDVfsPP8P8HwJCEmTvbtCQh67wP/rpzZhGggSM0vJUbmxnXRbVMtfAtU9vnYO5KBLjDOjFA3zckex6EQsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN6j+kP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN6j+kP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3683AC2BD10;
	Tue, 14 May 2024 11:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687687;
	bh=YA7DM+TWTggd5TRiErOFv++/B4JLbCxGSaq4HFcIzQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN6j+kP5f0SEhrKJt/rW+PeRyPkbxKScey7NoDMB8QIFYsRuIo6LyW99fp2n7u+P/
	 KNOpY+VTYpgubtdoxrMw9oi8JPxJb6LrNT9+5XAzQvGznhL98DmPatTxVSmvWHdhiM
	 i4ZHdlcrW8hY8lxhqG5GadgFmuhQth+m3ZqEab40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/168] ASoC: meson: axg-fifo: use threaded irq to check periods
Date: Tue, 14 May 2024 12:19:01 +0200
Message-ID: <20240514101008.318494547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b11d26660dff8d7430892008616452dc8e5fb0f3 ]

With the AXG audio subsystem, there is a possible random channel shift on
TDM capture, when the slot number per lane is more than 2, and there is
more than one lane used.

The problem has been there since the introduction of the axg audio support
but such scenario is pretty uncommon. This is why there is no loud
complains about the problem.

Solving the problem require to make the links non-atomic and use the
trigger() callback to start FEs and BEs in the appropriate order.

This was tried in the past and reverted because it caused the block irq to
sleep while atomic. However, instead of reverting, the solution is to call
snd_pcm_period_elapsed() in a non atomic context.

Use the bottom half of a threaded IRQ to do so.

Fixes: 6dc4fa179fb8 ("ASoC: meson: add axg fifo base driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426152946.3078805-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-fifo.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
index bde7598750064..94b169a5493b5 100644
--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -204,18 +204,26 @@ static irqreturn_t axg_fifo_pcm_irq_block(int irq, void *dev_id)
 	unsigned int status;
 
 	regmap_read(fifo->map, FIFO_STATUS1, &status);
-
 	status = FIELD_GET(STATUS1_INT_STS, status);
+	axg_fifo_ack_irq(fifo, status);
+
+	/* Use the thread to call period elapsed on nonatomic links */
 	if (status & FIFO_INT_COUNT_REPEAT)
-		snd_pcm_period_elapsed(ss);
-	else
-		dev_dbg(axg_fifo_dev(ss), "unexpected irq - STS 0x%02x\n",
-			status);
+		return IRQ_WAKE_THREAD;
 
-	/* Ack irqs */
-	axg_fifo_ack_irq(fifo, status);
+	dev_dbg(axg_fifo_dev(ss), "unexpected irq - STS 0x%02x\n",
+		status);
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t axg_fifo_pcm_irq_block_thread(int irq, void *dev_id)
+{
+	struct snd_pcm_substream *ss = dev_id;
+
+	snd_pcm_period_elapsed(ss);
 
-	return IRQ_RETVAL(status);
+	return IRQ_HANDLED;
 }
 
 int axg_fifo_pcm_open(struct snd_soc_component *component,
@@ -243,8 +251,9 @@ int axg_fifo_pcm_open(struct snd_soc_component *component,
 	if (ret)
 		return ret;
 
-	ret = request_irq(fifo->irq, axg_fifo_pcm_irq_block, 0,
-			  dev_name(dev), ss);
+	ret = request_threaded_irq(fifo->irq, axg_fifo_pcm_irq_block,
+				   axg_fifo_pcm_irq_block_thread,
+				   IRQF_ONESHOT, dev_name(dev), ss);
 	if (ret)
 		return ret;
 
-- 
2.43.0



