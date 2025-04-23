Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB029008C;
	Wed, 23 Apr 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421936; cv=none; b=CM8HhL+fEHUogSfytHcpAwbbAABwttQ+ZABPKAHZsez+9QXxRwCx4NLVsxkcuG7M/9SSIT3HHTofvO/EBvyHbWneBIu/NKxNyCiNks0XIBMacoVv33cjCuB8izRLiEI6i341uVJF5p+ya1Qs94aabHHhbAw8RpbpeUxbhB2NU7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421936; c=relaxed/simple;
	bh=Ov8nMAE0xJOCeZMVZNSNcGtaEINL8E898ohRwIssse4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N11sxWawsaSitk4CYlGB8ShdXqWtkE9WtqADtwkTXoxTn6MdzowyOqyTWMI2F2/ya5BtmYbo4Potpq1uu8G/iasUCL2V8bC4xngDMjFB5WMIXzebepPQ/Cda04WnsYAyhoxhpCtWMeasnlfeE9+oFZsrWThB9KsI/ISADz0XCHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8+D7LNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8+D7LNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6574AC4CEEC;
	Wed, 23 Apr 2025 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421936;
	bh=Ov8nMAE0xJOCeZMVZNSNcGtaEINL8E898ohRwIssse4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8+D7LNgrWq9nKWLOwlSHKoCHtSwrqCg84fIKoQh2tsH/BClPbAKpK6K5lnlBTnTD
	 1cy2UcNUp7IGjoYSggf1ppaQpz5YXumzTT0iElOPN4bxiUZi1MFC/9AkJVNcJ2t83V
	 ajrKKjNWXCi8pkNLo9iVn0rPSblfSCHykUtJ3P4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brady Norander <bradynorander@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/393] ASoC: dwc: always enable/disable i2s irqs
Date: Wed, 23 Apr 2025 16:42:24 +0200
Message-ID: <20250423142653.621407247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ea4be56d3b70..43edad6c887dc 100644
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



