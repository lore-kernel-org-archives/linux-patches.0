Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D23BFE3B;
	Thu, 15 Jan 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499172; cv=none; b=Cj48uylveqXia9ubuYKFBAA5DGExenpbcrAITa9UOlt44SxOdogC3IzzMZ1MDoJoB/GY49Hc5pX9wU3VmM8W/Ec4ZY0AJrf+vMYtjUJvv1xkCMVN0vHxzMx1xrAWc3SAreMiQFcK8wjadMDCmb5foP0Pt4eQxsqaI5LYzLWuBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499172; c=relaxed/simple;
	bh=C7nkajF9pijbeVhFzO/DxUjPOVULOYruMOR3X1d+O4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n126E9DUncjkevYCXS08DEj56F0D3tlrk0gNsqr/ZSGjtIhAkteID0mFINcaDpQASFuv0TG9CtEragaDXcqzgDtvAAxqwNCWIgc7TmHj/o3kpnnXdBFFp25WVl18T0OavBfFvSE9B97eb1NY5sStPeDSmxb+xrVnFwzJQY1sSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtDm9dgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtDm9dgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBCC116D0;
	Thu, 15 Jan 2026 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499172;
	bh=C7nkajF9pijbeVhFzO/DxUjPOVULOYruMOR3X1d+O4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtDm9dgjwC8gyZHA4WKq33q9y5GtbV52fgpB1pmSDimGQpayx4W4Dwr8usxC1oMzY
	 ETVKNKpMONXY1vRdu+Gn63fl13zDkiWCoYe5RcysMIjM1/uV29fGgc9em4FBMgCYi7
	 ZaCxhlm6Rjs+mEc/llNNGtF2I92rAbEPLHv5Ao/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/451] ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()
Date: Thu, 15 Jan 2026 17:45:35 +0100
Message-ID: <20260115164235.768061861@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ec8559d53a2f..9bca508cd844b 100644
--- a/sound/soc/bcm/bcm63xx-pcm-whistler.c
+++ b/sound/soc/bcm/bcm63xx-pcm-whistler.c
@@ -390,7 +390,9 @@ static int bcm63xx_soc_pcm_new(struct snd_soc_component *component,
 
 	i2s_priv = dev_get_drvdata(asoc_rtd_to_cpu(rtd, 0)->dev);
 
-	of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	ret = of_dma_configure(pcm->card->dev, pcm->card->dev->of_node, 1);
+	if (ret)
+		return ret;
 
 	ret = dma_coerce_mask_and_coherent(pcm->card->dev, DMA_BIT_MASK(32));
 	if (ret)
-- 
2.51.0



