Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C103AE1BD;
	Wed, 30 Sep 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791342; cv=none; b=UqHi8rN+Ejo1Yr+nFs13autglRrn4dIWz5BldOVd+/o9CzqgfYC42ujT+dQFcbNrrKOXVd++NudrN4CuJWIr1rtWUBciUL84qsBZI41dnmrdlYrBDSyAWgJvlDiHuP/hHh9Sfd1md88jMB1aVW/EMAb+m0utzgVN8yIOqu5ZyeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791342; c=relaxed/simple;
	bh=uO5iHRL1vR+HVx6KroUQhdsh3QisC9ZtZ506B2kT6TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5kch+4nciD8gE25p1LnDgyVU2HAv7Hdi3ZAKjm3F3njWmdpdyw8rPg48XA4byOgLQqNohKoHzk15Izd5lhtcJjFQ3InPaUMhpoNI82ILOUtHa94G59JXd0eFLWW6qnF1TKeqD+PeKkGZs1M4UicjlfSBbvHFvhr2ibKujgls3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg+N9z+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg+N9z+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75E1F000FF;
	Wed, 30 Sep 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791340;
	bh=qfq3SdrftJzFQxjALxQiRoWD8n7fyMDrDvZYrBjDcag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg+N9z+80ESspNrh3udNve703X7wD9rc1ya2esMrcF4DVQqRsJr5Rpqr0phQbN8pI
	 keRT1SVo5Oh9vETblZrPOC5TmrH/bfrO7oDLMkh/OCL5ACoYTAa6dLSJMlMLBjBbJd
	 TNDQpiaVbu6GX0MMdThnPFsihzPXdfKEFjyLNgao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/752] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Wed, 30 Sep 2026 17:22:16 +0200
Message-ID: <20260930152404.037890266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 0c06c4ce0206290c9a934a1e7196aaa86adfe018 ]

disable_pdm_interrupts() uses |= ~PDM_DMA_INTR_MASK which sets all
bits except the PDM DMA interrupt bit instead of clearing only the
PDM DMA interrupt bit. Use &= ~PDM_DMA_INTR_MASK to clear only the
target bit.

Fixes: f621a3676d3f ("ASoC: amd: add ACP3x PDM platform driver")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260824063507.483784-1-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 6b0f90e88a926..6f4953a758013 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -98,7 +98,7 @@ static void disable_pdm_interrupts(void __iomem *acp_base)
 	u32 ext_int_ctrl;
 
 	ext_int_ctrl = rn_readl(acp_base + ACP_EXTERNAL_INTR_CNTL);
-	ext_int_ctrl |= ~PDM_DMA_INTR_MASK;
+	ext_int_ctrl &= ~PDM_DMA_INTR_MASK;
 	rn_writel(ext_int_ctrl, acp_base + ACP_EXTERNAL_INTR_CNTL);
 }
 
-- 
2.53.0



