Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055168;
	b=fdl5C8sGcHdKoIJx5fOBXIzCkVpL6nt/VkYDa4E5FCUADyGBoYmztE3rzS8S0Pa5vUgZ
	 EOstBnV1tQEELIZ9EoLhM3ZhDE5jXgraBk50KMiVYc30kILEcAemIkB3ukSHAN8VfQQ41
	 dcs9fE5UsetnbCQDSu+5NRumdM87/RfNNnp/7jw05yJ4QR5HiUnQPbvieV0HDXnEBGLOK
	 /ZCaITgiJUptuzgoULtKetp2ZOKGA3CQJD+mM51BYi0pbbJYXEsak5abmrT0nqDnKEENh
	 s22PREeyXaJjeWq4cq9ZCFoYtocpnH/d3dbxsUWkdtOGnKNeRfidrcFi3DUjsGlRntQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7d4C93pBzmYesmTCKDLgeLMC0pCIYKakWhyc2vz3JI8=;
	b=bXwQ9qwpqjdA3CML44g3TR9ijTMA/iD/TZQNX77KTkxkV2lUsAmuT+d+2Fl4lgh0YU1b
	 glBiB2UUPoWey724rduNToemuVEMRLUox869fUZtCCdmvI/nh3amEzj/q0wyuPI+gAv3y
	 cUxw03+PochTneJ9RoyzHoUVMcYD4mFilgPs1dsMK8AKYkWh/wuwLOPxPip+c28wmUaea
	 YbG6v+opa10SftAuKtKlZo/aQfVhmepI8n6DMIwD0LoniMU504FX8+Qb6islixjCq8hKn
	 Y3xM/tc5zCupdSvF1l9Bu5/bmwYo89bYvz+lxXlt0BYjBhMYtOpJF6SnP5eIAGR6Y7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Rr8QPLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F240606A32A;
	Thu, 19 Nov 2026 02:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Rr8QPLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D111F000C4;
	Thu, 19 Nov 2026 02:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055168;
	bh=7d4C93pBzmYesmTCKDLgeLMC0pCIYKakWhyc2vz3JI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Rr8QPLU1OTk5ZZniz2uGI7h8VUEZeyI6fyQYVoFcw2mHGigjzAI3joyNpCECsf6Q
	 ahnVNTQt6p5VpzbDKU2df4JgFpk3FC/EQVC8u+9kOiIP57pSu3pXUR1og7Ugc4ZV/Q
	 jQ63dgx+G/hshHjJy8MURUDE2hkIhJ0XFupLOaJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1508/2214] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150112.317808797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



