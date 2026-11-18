Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040859;
	b=muffTJFAFxw+MkSdzRi3i/qB/CnVKdLJuboTZlOZnm51HQ1a+iKVP4+ZEvW4I7EsYHGZ
	 +db1laQ/hSP6opmJvnNY2bIEO5YblE1BouFufjKuEC3ehczZudyUkXuKJ1uqUQQ+v1dsi
	 lzzkhLygKOe2GmiL4pay2e9tr5Yd28HN8temX0Xe5avgEy2M9CTqNcyo6pacc6RarI1GN
	 0AhFdxgEQWXByZ9tcC9TaDfphtzdXJuZXV5eMCAjudfWIGWB4+nbHnnybApedlel7hltS
	 NCjvjKKq25SDrB2YHPEnAECx12WjMxwBlV/0pgnuhxa7fgOFh5rysaz/8o/igGO285Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DYyzGPAuiHTYXG5O/FQ4jO+l5iB0LTV3Kn8VvKR13TE=;
	b=H2hpYAGQ1Bm+jFf7p4+Q3sfVigxHW+L87Rsz3H1Nhk86CwlJGeTcRJofw80+4krcvCJV
	 Vl5PjmlIKCI0FDB/HvCQJ+mIeTSRKxZcV7NE/9JkwQ43OKUWV+xWKUSY05C13yct1J7VN
	 qYXgWpE9tokn+C1HPF0FoJYtdZC7oeFBpyDxNW5xWPl/Kbg6rj1Oe1qd4FH6jDTRHwdok
	 cFJkgKdWqbccZS4G0vRFX+6ru+uP6HKAiyonRDuzWIMQ3aj94JwRaCwSOCHnGzddammG5
	 Vc6XxGiZyNlUYhXs1qFroPup9S0Dy1Wjj8wntCrUZCfuRV1JfsTbcUSpKf7UY7hQlMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THnQ73Sf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B8F606A31C;
	Wed, 18 Nov 2026 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THnQ73Sf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411131F000C4;
	Wed, 18 Nov 2026 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040858;
	bh=DYyzGPAuiHTYXG5O/FQ4jO+l5iB0LTV3Kn8VvKR13TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THnQ73SfZXP9z8HqfZyOIZPYlVNdtiPszl8URYR70b6l6wYpcFB1fodN94UV7RR8S
	 Qo6oG2k/t+BB8DvaUX9j6isUYGaJxi8iPdQ3ZMvhhfUorbh/tqbMjNi9XcwL02N+z7
	 BvuxG6eReWGF+uQ5nOybVGdsz3r6x6IfagZbjD+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2607/3318] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:53:49 +0100
Message-ID: <20261118150439.360283244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 7ca608cf6b842685bbbe131d4f7d638f7cdc2b5d ]

d40_probe() registers the hardware interrupt before several later probe
steps that can fail. Those error paths jump to destroy_cache without
freeing the IRQ, leaving the handler registered after probe resources have
been released.

Route failures after a successful IRQ request through a dedicated cleanup
label. Keep the request before DMAengine registration because that
registration publishes channels to clients.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-10-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d8d08c3259195..27c97d53de6f4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3680,7 +3680,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto destroy_cache;
+		goto release_irq;
 
 	ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
 	if (ret) {
@@ -3694,12 +3694,14 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev,
 			"could not register of_dma_controller\n");
-		goto destroy_cache;
+		goto release_irq;
 	}
 
 	dev_info(base->dev, "initialized\n");
 	return 0;
 
+ release_irq:
+	free_irq(base->irq, base);
  destroy_cache:
 	if (base->lcla_pool.dma_addr)
 		dma_unmap_single(base->dev, base->lcla_pool.dma_addr,
-- 
2.53.0



