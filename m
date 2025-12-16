Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59A35F8D6;
	Tue, 16 Dec 2025 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888509; cv=none; b=UBEh9rBtRdYiocAy01ogxcL1C80V+uf2fCeePa1tsjyPtZTWwhYcW0A8dgk7+V/w7dIJRJli/Bo1723WfTsisMJciQeJe0bfy6X54OQDtPIxTB4v6UPIE637k2uU1FFvY0jFnOucDLodazPV2FnoYM2Zo0eMFslFQerpffH2iz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888509; c=relaxed/simple;
	bh=jcVEhGkXa3jcpK3W3zAVLP9Mq4+lIm3rPdW7SlURg7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsaNfi0wnhZS6FFvu4oyVeNe7ShZne0o66Drn15A/VvYxaYpcNxIdf6Sd7+ecfwSuA39jmsDOsGpuPNcbVIPIP6EUT9bmmSMFxBSX6oXmYa14UteZd0VfqsJHvw0aS0yUumY/gn670r/K1u3p0WXXUFTFIcsfm8jSawTGomn2Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hA5NCcAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hA5NCcAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68CAC4CEF1;
	Tue, 16 Dec 2025 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888509;
	bh=jcVEhGkXa3jcpK3W3zAVLP9Mq4+lIm3rPdW7SlURg7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA5NCcAmlFp+90k4KXmG/iqHcO7WbmQrUTiUF7TX0Qv9rSrJdUuFBg7QWZ0UCuUqj
	 en+31cWj2N4c5UNnLU9wbZ94kXVjSR8izmpB1oa6X9RQhZITC0dFIEo/5dioE7l5cK
	 jGjlwawbGzIPH9OBILAmAKkcUVGIp+4x1lFq0nLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 554/614] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Tue, 16 Dec 2025 12:15:21 +0100
Message-ID: <20251216111421.451515963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 0ebbd45c33d0049ebf5a22c1434567f0c420b333 ]

bcm63xx_soc_pcm_new() does not check the return value of
of_dma_configure(), which may fail with -EPROBE_DEFER or
other errors, allowing PCM setup to continue with incomplete
DMA configuration.

Add error checking for of_dma_configure() and return on failure.

Fixes: 88eb404ccc3e ("ASoC: brcm: Add DSL/PON SoC audio driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251202101642.492-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/bcm/bcm63xx-pcm-whistler.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/bcm/bcm63xx-pcm-whistler.c b/sound/soc/bcm/bcm63xx-pcm-whistler.c
index e3a4fcc63a56d..efeb06ddabeb3 100644
--- a/sound/soc/bcm/bcm63xx-pcm-whistler.c
+++ b/sound/soc/bcm/bcm63xx-pcm-whistler.c
@@ -358,7 +358,9 @@ static int bcm63xx_soc_pcm_new(struct snd_soc_component *component,
 
 	i2s_priv = dev_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0)->dev);
 
-	of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	ret = of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	if (ret)
+		return ret;
 
 	ret = dma_coerce_mask_and_coherent(pcm->card->dev, DMA_BIT_MASK(32));
 	if (ret)
-- 
2.51.0



