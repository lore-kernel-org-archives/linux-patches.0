Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048347;
	b=wqVOyhpY+rsigRf+BnE7J7vL0Uz+f65cRwSsFwcZfOz80yXrW/9tEqDjSw2ZOoViBIjg
	 uMxU5qolFLSegU0sxSoAHAUqy9pgeSTT6Qym7pQM+MdM1BenXvPhwGFman+SuHlvEoUTM
	 kdpd6TAsDTYAJ3BobVIhXax5tPMyZi+6XO9+il+2GZxLiClFzxekVXEoo/HjCbX1XzdOB
	 pnd9dovow+IiSdc70Jp6M33PANuwXCuGGnN+cERk3xYIsgB4jcTrEZ9XOUD68jf4AbJYR
	 HmO7aYFlVBQMgeH+UvOa3CIxItArdsdaJgXF4aMuEDtz0FJFGFkHwDo2WPHgFoRpwUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afEqa6L0Q5x8YSl609+TW3+7loAzpveVGhElqfnM30Q=;
	b=HJu/v80VY0EcmcxculNj4Rf2qkUKvyvd0PdZwC+iq51SEdLHNRANomz7cyK2kETsulDp
	 rnx/9GpaPS5OILCrJZGOc8XxEuQydPc4FMC3RnOoT1m8TS+UxrdqTf6bAINBYd7Hegvhm
	 NjokbTxQC7klkZu3VHU5nfCpxkNjXQwcFFJHRBCHLMyVxDsIMPPmyhDtevdELYEioqIGu
	 UafpElvgInAN+pT4TssAu9KUXahzRr5824dq6/FxceAI2+f1LnTcGCCRTsbiNbZri6ADL
	 ILo+MWaKjyVSBLE29AaLFTk3Y9B5lwVp2Z5801IKaHzvJHnxYHwNJmG8ke0NR97XSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZidofRp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA1A606A320;
	Thu, 19 Nov 2026 00:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZidofRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D22C1F000C5;
	Thu, 19 Nov 2026 00:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048347;
	bh=afEqa6L0Q5x8YSl609+TW3+7loAzpveVGhElqfnM30Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZidofRpI3cBTUOn+VHEglOh+mE8C7FLGPrXmEYqIsyFD+uJgM22NfVslhl7WE1MS
	 OXhrma03ThXODlGNOVamJgoF/KYCA6YQFmW0rDBYX6pYebQc1vKXCtHvj1uQLR94hK
	 x2NMtzsnCeaGJl2ATTBBomXWMpSs/MqVX0D8vYyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1945/2857] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150311.252021504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bcb4d469b19d53dc21e4a1da12d4438e7489e150 ]

If request_irq() succeeds but a later step (self-test or device
registration) fails, the error path at err_free_irq frees the IRQ
but does not kill the tasklet.  A previously scheduled tasklet can
still run after the channel is freed, accessing freed memory.

Add tasklet_kill() after free_irq() on the error path.

Fixes: ff7b04796d98 ("dmaengine: DMA engine driver for Marvell XOR engine")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260909234601.101883-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 8b215cbca1186..7c1fdb2c91ce1 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1162,6 +1162,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
+	tasklet_kill(&mv_chan->irq_tasklet);
 err_free_dma:
 	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
-- 
2.53.0



