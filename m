Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5592336EDA;
	Fri,  9 Jan 2026 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961975; cv=none; b=mLgPoc6Qp+UwqyhwqOpFtKzmqNKaMm88RiBmeOg0VEOPp7k70LUBoAZeHopWJjZ850X53q/5MaMusv9tk/sYNWbJk+PktpHo3EV20mRv79uJjMzERGbrE2hOJqeMbsg+V/4hfQtA/hr3YxEkonMcPXEw1dFn2tGFVDsFGcmYdnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961975; c=relaxed/simple;
	bh=PZTT+6F8Mmx9ktoaloB2Zxw1nnqVCF4gkKGuNpp/iZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyTjtK7dhLe5hnEUx2vGatS4DtzcfIZc+Cwqd47AH8A9qFikBS+aVYiKEtq86G5fvTuuaVL8g3SG+edUXvbcJJIYFcQvA+xLBtu/x+By3dAWuoRqVBdAHOmHjbiNdG/urRcXCfOtSelpsK7GS2SjysmC3vI8IDYv4zHuJS5SuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fplulZw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fplulZw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29439C19423;
	Fri,  9 Jan 2026 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961975;
	bh=PZTT+6F8Mmx9ktoaloB2Zxw1nnqVCF4gkKGuNpp/iZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fplulZw0Ckk/dn+e+DZpXzPp7eo+dUNPXrP7cThPIp2CnKSVA338kSSnQYk2c7SJ5
	 msvkr79YzGakkMXwRKTaE5C5y3wawIDpLwKweuASgnPnWU8wzL+8DFV5Bwsedryz/z
	 rDpFeTJF5hhvnLmMuxNVUszTVBlK3jVYbvcuUTYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/634] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Fri,  9 Jan 2026 12:37:59 +0100
Message-ID: <20260109112124.996778491@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c600b017524f..760cb18870908 100644
--- a/sound/soc/bcm/bcm63xx-pcm-whistler.c
+++ b/sound/soc/bcm/bcm63xx-pcm-whistler.c
@@ -354,7 +354,9 @@ static int bcm63xx_soc_pcm_new(struct snd_soc_component *component,
 
 	i2s_priv = dev_get_drvdata(asoc_rtd_to_cpu(rtd, 0)->dev);
 
-	of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	ret = of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	if (ret)
+		return ret;
 
 	ret = dma_coerce_mask_and_coherent(pcm->card->dev, DMA_BIT_MASK(32));
 	if (ret)
-- 
2.51.0



