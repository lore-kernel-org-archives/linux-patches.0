Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738C72D613;
	Wed, 23 Apr 2025 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419668; cv=none; b=YkTNtYw4AkrrCilbOa0b41XJWT09F9zOhzfVa81ijpMGUXbkmyA1dpNJfg4gfrcvbCjbu81XJDKEebFQ4Qzzyyqf2XT2dPKANAuAxxHwvgpylEhB0aAm0EprCS9cFse+IEGhK4sM7WTrXJNVVfRtTVJAXym21QFuRXeF6kzG4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419668; c=relaxed/simple;
	bh=TcdNewgQNsMOUOJR6PaOVRrVne0yuUb66a8cBZ6/C9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqfmSpZkft9QLaLAFxNx/K0rWLCq8qe/RNsGmBysFQZvYvT+M8IIyTqjhxfwxUXzYSdO8mIy/U4LZAD7ObNotJ8EuBs+2wHki0FVjrzit3RoiEY1csrNqArAwUzUOMozYRFFg3tk5jXuXBwDPJf79MnIALuXHB6S8dTfpTQXkyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOw0er2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOw0er2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0944FC4CEE2;
	Wed, 23 Apr 2025 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419668;
	bh=TcdNewgQNsMOUOJR6PaOVRrVne0yuUb66a8cBZ6/C9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOw0er2cVBffbmnrmgabDrWgbhFEBVIkZG5DCuW8HuA55VQc03pqL+/IVQZBEvsXs
	 LRofRm/DZVyHNacUqSHMFINnTk23ZDaVaCIAaBcqGUm7Kob2giXWAeJGLGPgJn1V1y
	 MPmS0wCG7HAKuM/CpAuDqfnfyFLXwKS+l6v+CbRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brady Norander <bradynorander@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/223] ASoC: dwc: always enable/disable i2s irqs
Date: Wed, 23 Apr 2025 16:41:25 +0200
Message-ID: <20250423142617.660654000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Brady Norander <bradynorander@gmail.com>

[ Upstream commit 2b727b3f8a04fe52f55316ccb8792cfd9b2dd05d ]

Commit a42e988 ("ASoC: dwc: add DMA handshake control") changed the
behavior of the driver to not enable or disable i2s irqs if using DMA. This
breaks platforms such as AMD ACP. Audio playback appears to work but no
audio can be heard. Revert to the old behavior by always enabling and
disabling i2s irqs while keeping DMA handshake control.

Fixes: a42e988b626 ("ASoC: dwc: add DMA handshake control")
Signed-off-by: Brady Norander <bradynorander@gmail.com>
Link: https://patch.msgid.link/20250330130852.37881-3-bradynorander@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/dwc/dwc-i2s.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 57b789d7fbedd..5b4f20dbf7bba 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -199,12 +199,10 @@ static void i2s_start(struct dw_i2s_dev *dev,
 	else
 		i2s_write_reg(dev->i2s_base, IRER, 1);
 
-	/* I2S needs to enable IRQ to make a handshake with DMAC on the JH7110 SoC */
-	if (dev->use_pio || dev->is_jh7110)
-		i2s_enable_irqs(dev, substream->stream, config->chan_nr);
-	else
+	if (!(dev->use_pio || dev->is_jh7110))
 		i2s_enable_dma(dev, substream->stream);
 
+	i2s_enable_irqs(dev, substream->stream, config->chan_nr);
 	i2s_write_reg(dev->i2s_base, CER, 1);
 }
 
@@ -218,11 +216,12 @@ static void i2s_stop(struct dw_i2s_dev *dev,
 	else
 		i2s_write_reg(dev->i2s_base, IRER, 0);
 
-	if (dev->use_pio || dev->is_jh7110)
-		i2s_disable_irqs(dev, substream->stream, 8);
-	else
+	if (!(dev->use_pio || dev->is_jh7110))
 		i2s_disable_dma(dev, substream->stream);
 
+	i2s_disable_irqs(dev, substream->stream, 8);
+
+
 	if (!dev->active) {
 		i2s_write_reg(dev->i2s_base, CER, 0);
 		i2s_write_reg(dev->i2s_base, IER, 0);
-- 
2.39.5



