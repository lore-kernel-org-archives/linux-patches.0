Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7EF32ED21;
	Thu, 17 Sep 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659150; cv=none; b=WICQ+fkjSQgI3qLh20KzHXHMr5SoPjeLH0YnU9UdnBsWqkaVoF0FyekpZyVcrF0v2ycRRcWHcP5ZdAM1rxQLb3UhSzKdjYWrPVoE3RWQbyGQ7Bgf6UzO44ffbGh9DEU03WbBpzjWM0C5BrFZTFflNJvJ2TnpNNlWMqLnoUttKmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659150; c=relaxed/simple;
	bh=465K43QdrcDWWHymiZMvL2Fnjkl/ioTdkcD8ZccHLaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPOLHdKutgCfkw3rI50EliCulvnlHSDamuEP6GQqobyvmAj/xO3Z1teksOMd3AZ8u134EIXufjqPPFggG4XEOPRDMDfxDRMCX0oel0dv1ttPLVn2I3o4zD3r8rot7k9zGhNVxy0Scq99f81StE6SAl15B7WTz0qLR+R2p0F7dEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7XFNwdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7XFNwdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E11F000FF;
	Thu, 17 Sep 2026 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659141;
	bh=QIRivA4VGDvkTtRvhuwWQFqPFQgaPHdlE9hklv5aJ1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7XFNwdvaZeg0aNjLUk9buiDfhUjzuzA349vgCC9KxLHUxoXOe4pXjf7/z995L4ji
	 EBOsRYREut9NIjnEZfVrdH0v3HYrhMQvw5dgHS4HOEQCsdAtF59pPobe6xb83ObitW
	 LUoNPWD8gvTYQkksRIitmPlXPf07bULNmd739Lo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 156/733] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Thu, 17 Sep 2026 16:07:44 +0100
Message-ID: <20260917151354.954317520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e60e3821703cc..3f59b753243d5 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -104,7 +104,7 @@ static void disable_pdm_interrupts(void __iomem *acp_base)
 	u32 ext_int_ctrl;
 
 	ext_int_ctrl = rn_readl(acp_base + ACP_EXTERNAL_INTR_CNTL);
-	ext_int_ctrl |= ~PDM_DMA_INTR_MASK;
+	ext_int_ctrl &= ~PDM_DMA_INTR_MASK;
 	rn_writel(ext_int_ctrl, acp_base + ACP_EXTERNAL_INTR_CNTL);
 }
 
-- 
2.53.0



