Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B431E495;
	Tue, 14 May 2024 11:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684843; cv=none; b=Xb+IrrTu14D4iKzyGT4XWpENio2vWcGVWkqdUlrxJSmWB785POzYJTERqW8cL0PEDwm03hkddDJGjMDW/IXmg/dYWNjrt4JPyoy7I4j8plKJeLcAlLubCG9+3DU87cHMpxLQU39u7FCJBA4Hws9HOmTKO14NLQUgYSi36J/I+ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684843; c=relaxed/simple;
	bh=n+NNzJmwXybEGAFwtlezNDgoZwFRlHTIJuH6bxAyVOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgCRffvbG5B/RZEuPtHy+6gNnnfbHN75g3GXwCk3wj96LsZPb0XU/7mKGxRyFPj4D/gXt5gM9cdXoTCkuxADvn4k9oSZFAHCDBMm+fVMaGYhFf23RerBOGZYypa0iRQc0hquUVU+EAS+DuOoSVv5AvlBZFQoaHaZPBTUVf2LWQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxcPXnZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxcPXnZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0566C2BD10;
	Tue, 14 May 2024 11:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684843;
	bh=n+NNzJmwXybEGAFwtlezNDgoZwFRlHTIJuH6bxAyVOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxcPXnZTb7PUlv8gyl62TAyxJEX6HhVkFpkfwHzD9Dvo+668GNlNd3QbgEE5Tq11x
	 NBsKXGw6Z2DXT1hObNaVmdxbMJrR7eBdJYnvMbi2pLrWqhfmHTFW2yotq7HvGkrY4w
	 i22nxkQRrpZHYZtIbfGcaYNE/0zdVlTeLDqQJ2+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/301] ASoC: meson: axg-fifo: use threaded irq to check periods
Date: Tue, 14 May 2024 12:15:37 +0200
Message-ID: <20240514101034.734622891@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



