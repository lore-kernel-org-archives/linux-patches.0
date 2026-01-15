Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F621CC5A;
	Thu, 15 Jan 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497731; cv=none; b=AxenI6ukVW9ncbm0N5Pkz+4y9xFnSvJcSW3MR6rIt34zcGDzb9aTYDbDTQ542x6Zml6TTIZ5G8JVCe1DxU9Np5ZI1p7avoLNaeOsLG4Qh5IRvy6OtlJQlTvP4nb4mtv7z5rQ9t4XW8EqbzJEL+wMdY5PCklGNoqEfh81MhIQUYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497731; c=relaxed/simple;
	bh=jvTwUufVTw9dQuNhs4Osul5PIGp1A8femj9Y5plT4Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4+PXXi9SiYECE0yWr+0gKdAFyjtjSrrBTnNlv95VH+eyFO7w5Inb7eH0fi1Hu25uf7z+7coqTMsdE9YcXSt9tDV+lXvzod0WSqGy1BGGaL6X7ylTtv/4YITGCZ5l/tqZ52WfM0dPpnCBhWBiljUqSVcMKRTknJq0uieG2eRZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/UQAhYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/UQAhYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE2DC116D0;
	Thu, 15 Jan 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497730;
	bh=jvTwUufVTw9dQuNhs4Osul5PIGp1A8femj9Y5plT4Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/UQAhYQUEQyrQNR29USNKhY/SkYEcDB6LX0FL76bM+xWvmgDq2BvoaKCU36HBO6S
	 1D7Ti8zBYTP4xx/KLadekwJlIHxhhgrCuai5Zgt6wZ9W2E8RbkCfeGH1apYKHVy8VZ
	 KTwmlO2U563gg1zvM8yb2FS178W8+575AcKe5mcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/554] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Thu, 15 Jan 2026 17:44:10 +0100
Message-ID: <20260115164252.922356428@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5096f64c576e..456aacc59e507 100644
--- a/sound/soc/bcm/bcm63xx-pcm-whistler.c
+++ b/sound/soc/bcm/bcm63xx-pcm-whistler.c
@@ -353,7 +353,9 @@ static int bcm63xx_soc_pcm_new(struct snd_soc_component *component,
 
 	i2s_priv = dev_get_drvdata(asoc_rtd_to_cpu(rtd, 0)->dev);
 
-	of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	ret = of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	if (ret)
+		return ret;
 
 	ret = dma_coerce_mask_and_coherent(pcm->card->dev, DMA_BIT_MASK(32));
 	if (ret)
-- 
2.51.0



