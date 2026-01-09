Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED75D335561;
	Fri,  9 Jan 2026 12:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960065; cv=none; b=RWE8X17dfhidkXxO5FqRN/XJPV5tIMJLIgFdxViXHkZe9tnZEjmfupvmrHHBocXAt2fmH8a1hT/6vdwUJ2DQAvfFL1lgzmQJq/b/fd3wxWC5cA4AiDHxZMButcLBM5RcxwdzapjBGRbNsdHGLiy6fRVwX9jqUKfas0RRwhkUZJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960065; c=relaxed/simple;
	bh=v3IBwyJXk0QD/BF6EN6J4AoGaO/x4iJXsicAHxu/NB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDLYSQhxPC4CZgdgvmgdWsdvfbzPmML9tvnhQobeVSE0QR0jOFxpS7frKZNEag0xQOIOtTXbsMeTrDkCOYVnGrgGqK8iA2W83aKP47LIyryVerlWq+ASmYcG3QjPOT4+mbaRLYxgPng5+Nn7Re/3qeFR/BAfCt/4uH/BoRbAYM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNyBQlPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNyBQlPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E686FC4CEF1;
	Fri,  9 Jan 2026 12:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960064;
	bh=v3IBwyJXk0QD/BF6EN6J4AoGaO/x4iJXsicAHxu/NB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNyBQlPsG4gIFDwN6c+XamU0OeTpHx9mX0fXZNws4Ft/BJFAxF6OXvsLhAh1zzpBh
	 Q2mm0C9oTpwBsNFWrH5vSZXfUWA7lwjxwBHDE+Dmr1I6lZqUSrJUIwmonqJWLA4q9i
	 lk3Cg2TVMt3GCz9qIHIUrr3tZlDrGQs2festXKtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/737] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Fri,  9 Jan 2026 12:36:51 +0100
Message-ID: <20260109112144.231395063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



