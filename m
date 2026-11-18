Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025554;
	b=3h9gLEqxCuCeCmi/HPojrrXUvDMOnRXmWFrYmZm67FUT1409jSBAZs6qPSjRoQ4+Qxuw
	 mDbDrFKfCSLd53J3PkSH5cB2T3khjCGdOczJlYSHWNU2wxbPqjpMGrMKm9uzDjPrxoHGt
	 rJzvq8w5ZE2ArgNKyuH2nc3kuVihWxtolGizHS+7EhR8meVlbE046PqZFsKvoDFR3KZza
	 FMfw+uiZ5tcL2/LSWs9U0WcJzHE5LW34jytw2g7fpEr3MKgTPka6xyvLQB1BnVgPvGO9a
	 3onjgYV4q5aW6/S7NRH3HqhvY27SMIVE+B4taPmKdVzxYAr5OK55uc8i2iLdUbMfVKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5gk8QLJVzc4QOE2uMJ7Dey5TjYfS1YxmSR81xt4DtM=;
	b=Y4I8Wq7dBeJ8w/uxJAjWGQAD4Q1R3baH7gcyDW2Gli5mCqxRtSol1fot8jzHdV95FrNG
	 dj5vMuXTrMox/gxNjEce27UjtBJP/LCWaVMwqy7abvJ7Bkwdzn4YvnOKLKINCsokigR4w
	 r7DcaZeYTTauznyimVq6z6iHZYEs+StRi/BhgPTHDiNkGgR3EphzlRxaZ8/Hal2NM30hl
	 oA7eqDfE9Fo+3LvDQ52OJN9PtxychP4fGmyN923HJVOBcjZiLOaodpWpnS19+MJDvkJhq
	 SFABCbHnGqdpXWeOqV/1I4a0oySTAb+UdtFbvt8FvEkVmI9B08UUFMVKi08II9pmQsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDIYeekF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AE7606A31C;
	Wed, 18 Nov 2026 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDIYeekF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E661F000C5;
	Wed, 18 Nov 2026 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025553;
	bh=e5gk8QLJVzc4QOE2uMJ7Dey5TjYfS1YxmSR81xt4DtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDIYeekFjSA2hTv+5rwX7q0XAOOheFEOvIZPfp9VujE3RXWWZ5+WcNV9+jpxJw8JQ
	 rpwa8CyULvYtDia1Lc1kGLZOIAbvMZNVzmWbVRX0A3qDo9C7U8xC1tP02CQanrfl5p
	 kIjFdEEM8QYCknu4qfSkRroFm2quE0OJRyZvkhcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1121/2151] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:47:36 +0100
Message-ID: <20261118150203.044830472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c88de0dc7c6eb..1b833fa77fba9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3681,18 +3681,20 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto destroy_cache;
+		goto release_irq;
 
 	ret = of_dma_controller_register(np, d40_xlate, NULL);
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



