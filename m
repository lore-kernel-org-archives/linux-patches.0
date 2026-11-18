Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029367;
	b=TMsZxqOHp8UF9nMqXhwekRbRzhNC+svC7EuEbqY7+O8sLpY+5E1uOyuvVUzbKPub+j6c
	 iFsd/kN3ONwxT/pZxFN4tuhLhqnf564pgfplVoL7Wu1TdsknUuO8i52JKWAG2oDGZgZFB
	 2qtd0urzWbgbveXTX058tALjb5uFlmG20Cba+mKiMUblDktGxorBoq8X37qNlPGh06sGm
	 jRqO4fp9/uIfUYih0iUo5Hnma7FT4H75negyy6ROGrmnplh69Fn2BjUGSRJq8JX9UQj0k
	 W+64Stls1YApzx2MalZx3cjpxnBXfe8y6RUr76XiMMSP6yLWl1br2Ql2FmcNGZeR5ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2hWRF1vFqrE6IwWjoGCzY4ut/5zL+bVe/RL7RzWhtXU=;
	b=aMpzVXW0JGKwoEtivToi3cPk8I//mjfUR/b2PdmnUz0+3DE7tCeSSxhpa+P1XAdTCh7+
	 x5J8biajIeob6SIpdbDeu72yB2MSoA/E4RVI+2tDyJWlKVcInPA/pSKTNDkizg+aiThby
	 2O7XtBJPlm5b/ryKJCOdaijJIoNIl+fF1hsKfgv1w8ZwoxiclMvczjPxCfwHbykajkM+y
	 s/h3rTU6YViZEy7ODASPzbLGuTqEP/WZWASzwqGaYS3bHAsvdk+ZHhcREyPJWCFpjMiWX
	 ZS33gWN6cERnxBxUJ0BUN/WdqVpUHnBwbckD//XBK4vz8zehICFLJgF7j7bdbiy0/Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHq6+43v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EB606A31C;
	Wed, 18 Nov 2026 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHq6+43v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BBE1F000C6;
	Wed, 18 Nov 2026 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029367;
	bh=2hWRF1vFqrE6IwWjoGCzY4ut/5zL+bVe/RL7RzWhtXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHq6+43vSx5aT6kLyoOiBrnPlFfivTTBGKyu3kgJWYOWA0BGsikz18cRDOfDXCkJq
	 kbbBh9Z82Vr8l/Afn6y/deSCQWRwd/SPl/y7OB737MATo/glNugxdBH4Q5e6Mgcer8
	 yUjdszU3tKlO/ejhv86cZD5quRegWySjbFNqxdWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0275/1756] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:40:02 +0100
Message-ID: <20261118150019.375351795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 4a1a2d8b8529cc569b769b92fcd71c53805cbeb2 ]

pm_runtime_get_sync() leaves the IMG MDC device's usage counter
incremented when runtime resume fails. mdc_alloc_chan_resources() returns
that error to the DMA core, so the channel's client count is not
incremented and mdc_free_chan_resources() is not called to drop the
reference. Repeated allocation attempts can therefore accumulate usage
references and prevent runtime suspend.

Use pm_runtime_resume_and_get() so a failed resume does not retain a
usage reference while successful allocations remain paired with
mdc_free_chan_resources(). DMA core only treats negative return values as
allocation failures, so the helper's zero success return preserves
behavior.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 56d355e6f586 ("dmaengine: img-mdc: Add runtime PM")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260813153143.3953303-1-ruoyuw560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/img-mdc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/img-mdc-dma.c b/drivers/dma/img-mdc-dma.c
index 0532dd2640dce..9dbceb9904e28 100644
--- a/drivers/dma/img-mdc-dma.c
+++ b/drivers/dma/img-mdc-dma.c
@@ -738,7 +738,7 @@ static int mdc_alloc_chan_resources(struct dma_chan *chan)
 	struct mdc_chan *mchan = to_mdc_chan(chan);
 	struct device *dev = mdma2dev(mchan->mdma);
 
-	return pm_runtime_get_sync(dev);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void mdc_free_chan_resources(struct dma_chan *chan)
-- 
2.53.0



