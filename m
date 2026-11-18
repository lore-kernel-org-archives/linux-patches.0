Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018725;
	b=RA/3daTgUN1LQsuI45j2AuN2FNG1SQtY7ICb6904DClKF+KiZ5cKV+7xVF8Mu0e9i4QK
	 spsrby+TDY/6c+SxaP/CPauCgUYM10T3L0rwc89Ii/U1VUjWTxBc/0VR6DVgJmKVT3r9i
	 v06Szaj+UBuqATbxVObC93WB8DJHqvw39sF2s0pjv4De5Anj6O9tF7E4ckfvlyOxB9zjp
	 QlZs2A7AvpolxAuS07xPKAOEIF4p73sj/Yml3KrRgzzRqzERJIIterV7LjkXJAw/nLIGt
	 bbs3/vh//rofAXJ/ADoWvN/CPp0v8GPXGVmKIxXCOO6SoicdXLAmfpI57gLcb4KaVwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A8PjOGZE/GTVV+Q4vtimCzs/gUXrRJez2VM5Xf9osp8=;
	b=Kiv4Odew6y6w9ZrBbAvfO7rX4d6/1utGe4d4uGazz3CbFPkhBSEpNKqfK7kGykpJ4K9A
	 6xjsvjg9wGv+4QfmsOjmnsveppBfGRM1BGNvLEOkSKyHN2UdCtSHq31PiCM/kVd/ZrWep
	 xw14aupiOnw+MQ/gTpEJgCoDwItfs31gsAbT88Daq4mhHxHzENDw/haZAyW9c/LfGEw6Z
	 ErYRYW9/ILTEcbk+WPBMOl+uEIy08HG9Fxg/0ipehrrGW1Xj57pOXboX48t7Iyuh2FZo7
	 Hxymqwynt2YEAhmtu9CkrLePZ0geXeuW+uRYoFnL5fi17xai51axSuHqJHrjJU8AhuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTa6LXD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF35606A32C;
	Wed, 18 Nov 2026 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTa6LXD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A891F000C4;
	Wed, 18 Nov 2026 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018725;
	bh=A8PjOGZE/GTVV+Q4vtimCzs/gUXrRJez2VM5Xf9osp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTa6LXD0AKrZJg/CtVphIrNwIyWbZWpMkYk3gY/1XVj5NmDRqlc57w4jizsAa6SQf
	 OJeUpOzUAGcaz6v6/O0W78ZMo3eVS9XHrWZ7/H3ekdArGVGk7k+seEMpQ7AkBXD9TK
	 oGsRB9QHTeH7fA1h4UJDIWpcWjKNy5bfdHLtXd3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1341/2651] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118150336.298402738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3bf89b057ccf0..4c545a9472642 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3846,18 +3846,20 @@ static int __init d40_probe(struct platform_device *pdev)
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



