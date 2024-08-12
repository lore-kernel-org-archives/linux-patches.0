Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69594187342;
	Mon, 12 Aug 2024 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478954; cv=none; b=UUaEqDPy1od5qzpLKbfSgx6KoaI+U6hZc+wU0vK9cAfRYa0P8k639p4zuQF3r88NHStb2Ffg1qTpz2lKC46WR+q63dsAgECGU1T9u08WhWwpENqhhU+kpG+09IDgih/iSQvdeQmJaGc559rqoMeeGl+a38xmmvEmST8/PdCUZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478954; c=relaxed/simple;
	bh=gR02txtKUEOGgAYKOU0bckIGLycbraU4pr5U+ZPIbQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0mzGcBL6W+YVBCXpSsyl+WW9tOlL5Nrm4ffFgkOgiMR2C+YoInWrqulb1KWN7jZKO/0VzmeOoi/GZ7673jUPDrJ8N49yGmkaXXJHw+rM18mR4gk450XhE6ros2n1+b9M32QJDFwQrP7F7IlQNmzSkp6708cC6I/PBt64CxyDCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc3NbRGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc3NbRGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D0BC32782;
	Mon, 12 Aug 2024 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478954;
	bh=gR02txtKUEOGgAYKOU0bckIGLycbraU4pr5U+ZPIbQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc3NbRGhX/RWyVGgmhJ2OA1HAASsNxEVnJBiMzHxFcEorlryFFB3nmfjm9d7yt1fH
	 b/TI8ZjqY3IBWWPJGUyVyjzCrHQuAeolcZl69DGrmq9a0FEWht43Tg5dta+Cy7/FBz
	 qGwmGmyGZlgbI8WwiiQV03PTScHwLWWuWN/jADwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/150] ASoC: meson: axg-fifo: fix irq scheduling issue with PREEMPT_RT
Date: Mon, 12 Aug 2024 18:02:47 +0200
Message-ID: <20240812160128.488532264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 5003d0ce5c7da3a02c0aff771f516f99731e7390 ]

With PREEMPT_RT enabled a spinlock_t becomes a sleeping lock.

This is usually not a problem with spinlocks used in IRQ context since
IRQ handlers get threaded. However, if IRQF_ONESHOT is set, the primary
handler won't be force-threaded and runs always in hardirq context. This is
a problem because spinlock_t requires a preemptible context on PREEMPT_RT.

In this particular instance, regmap mmio uses spinlock_t to protect the
register access and IRQF_ONESHOT is set on the IRQ. In this case, it is
actually better to do everything in threaded handler and it solves the
problem with PREEMPT_RT.

Reported-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Closes: https://lore.kernel.org/linux-amlogic/20240729131652.3012327-1-avkrasnov@salutedevices.com
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: b11d26660dff ("ASoC: meson: axg-fifo: use threaded irq to check periods")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20240807162705.4024136-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-fifo.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
index 94b169a5493b5..5218e40aeb1bb 100644
--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -207,25 +207,18 @@ static irqreturn_t axg_fifo_pcm_irq_block(int irq, void *dev_id)
 	status = FIELD_GET(STATUS1_INT_STS, status);
 	axg_fifo_ack_irq(fifo, status);
 
-	/* Use the thread to call period elapsed on nonatomic links */
-	if (status & FIFO_INT_COUNT_REPEAT)
-		return IRQ_WAKE_THREAD;
+	if (status & ~FIFO_INT_COUNT_REPEAT)
+		dev_dbg(axg_fifo_dev(ss), "unexpected irq - STS 0x%02x\n",
+			status);
 
-	dev_dbg(axg_fifo_dev(ss), "unexpected irq - STS 0x%02x\n",
-		status);
+	if (status & FIFO_INT_COUNT_REPEAT) {
+		snd_pcm_period_elapsed(ss);
+		return IRQ_HANDLED;
+	}
 
 	return IRQ_NONE;
 }
 
-static irqreturn_t axg_fifo_pcm_irq_block_thread(int irq, void *dev_id)
-{
-	struct snd_pcm_substream *ss = dev_id;
-
-	snd_pcm_period_elapsed(ss);
-
-	return IRQ_HANDLED;
-}
-
 int axg_fifo_pcm_open(struct snd_soc_component *component,
 		      struct snd_pcm_substream *ss)
 {
@@ -251,8 +244,9 @@ int axg_fifo_pcm_open(struct snd_soc_component *component,
 	if (ret)
 		return ret;
 
-	ret = request_threaded_irq(fifo->irq, axg_fifo_pcm_irq_block,
-				   axg_fifo_pcm_irq_block_thread,
+	/* Use the threaded irq handler only with non-atomic links */
+	ret = request_threaded_irq(fifo->irq, NULL,
+				   axg_fifo_pcm_irq_block,
 				   IRQF_ONESHOT, dev_name(dev), ss);
 	if (ret)
 		return ret;
-- 
2.43.0



