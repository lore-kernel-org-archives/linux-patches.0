Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5027342521;
	Tue, 16 Dec 2025 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884939; cv=none; b=Auxc+PbVl6WytPnYWqFztzY8DPr1iCjcOVqlzg3Sp5Sh8qek33a8aFOKVeNJtGd7su9h0CCE0ssscnzpMzCk+Q9mWo5t37lyxqA4o6ll602EbcjoLbyJukVfzVei1yAMegvuiwL37rCDwGfuJqqelUef+/T78kEvZ4LBtO8exE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884939; c=relaxed/simple;
	bh=3NHuBdquzmqBYkszDplX5GiTQ5G6aIfeFFFmJwacqSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5vdSVeY7irq1QUdRFKrUqc4bNWi/2tHL28QDwhhipK0/PR6Db4CwznWexJujGxAwLlnHNFRIxMBg8dHiVz93pi9wTbRpg1EzJEM7TmKbHySdTdiKP31nuEnjN8nXEbDiEZWigTMeggxbTv4hEr+NYxwR5r3I/+GBfYE/UPe3Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYNZyrCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYNZyrCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E305EC4CEF1;
	Tue, 16 Dec 2025 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884939;
	bh=3NHuBdquzmqBYkszDplX5GiTQ5G6aIfeFFFmJwacqSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYNZyrCM2GtATIUaC++5E6vuDlfJQLJz5jTKbRRtQucCdgavEmXoyilxaGh8V6Q5A
	 T9+AhbD3fsJVD3dL8pB6pqSoMoYK05waUR8oO9V8Rp9jn6D/S4LSsKxR25mE6/uW2D
	 ptjqz1U8PiPbPZAfhWns4vWhqxJ3i8CVxNmGwrzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/354] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Tue, 16 Dec 2025 12:14:44 +0100
Message-ID: <20251216111332.394957851@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 018f2372e892c..3fd7a03f1edaa 100644
--- a/sound/soc/bcm/bcm63xx-pcm-whistler.c
+++ b/sound/soc/bcm/bcm63xx-pcm-whistler.c
@@ -354,7 +354,9 @@ static int bcm63xx_soc_pcm_new(struct snd_soc_component *component,
 
 	i2s_priv = dev_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0)->dev);
 
-	of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	ret = of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	if (ret)
+		return ret;
 
 	ret = dma_coerce_mask_and_coherent(pcm->card->dev, DMA_BIT_MASK(32));
 	if (ret)
-- 
2.51.0



