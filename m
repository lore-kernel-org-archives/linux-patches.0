Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622344;
	b=4Ae9DfiZtGjwtMFqale2uhym64o237hXqM83TVSstxc2eA6+TqWYY/4BvWkROA3NkeVc
	 8P70i8+mY+iCdXUgCy8NvTuJ/a/buLyk1xhO2oQVxy9QhimF4AmBsYZGA746XMx8VqW5a
	 iT/1DO1z8BrWzykHt8Db9nmFKYKxMd8m5PsN+0S/T9qofDT5+QvySipxXDfFqnSRIqLKV
	 mxnAcdFW2g7iXgvtMv2YmNk55bqpAcN9rOPE8ncb4HZ6xStv9uBzV3tTKdYUsNdFtItw/
	 5rYoVV2B8FwjfWCrx5W4u/IPmtatNNtkjyvyCuhnHYBTKQK+ZF0SZQ+oq3Ov2Nd42Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGMFlejvTuZrwmW2DusVJjwQvy5b+V9yyl/hHxbfd8s=;
	b=Ki03AFtXHaOprqs4+BwezNU3+0+VL0MrrunYyMetnTNejl/johFspsVnNtUxPpNij1rk
	 qKpogiof1MBeKK39hAUh+qSl1TvHbWy0VIrJL8cs7SsupmfxOLj/R3RK1GUk9aFS/ApgW
	 0/wKgxzxDdBwygIEHflx8wCiWnnd05W7XyUeJB7bRpdg5p1zC4XDLNESppRdsJuemcC4l
	 IMYCurzbdsZVfJ0S49BClt3YgL+JmPESe4QBdqK++ns0Bo9wTi9C+0bjN3JYcnXidJnMf
	 rIJ6/QjiyxBLU9oney8dxTy3BXxzrgXmYjR721dJH9C5RYLTVrjEc1uEvIvifdjA8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POx75jUl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA92606A334;
	Wed, 25 Nov 2026 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POx75jUl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFA91F00ADE;
	Wed, 25 Nov 2026 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622344;
	bh=gGMFlejvTuZrwmW2DusVJjwQvy5b+V9yyl/hHxbfd8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POx75jUliXdTW3npsQV9M/TPh0PNoR6y2BpJ+wyillCyf2teZixyM4CvHb9wqnDZM
	 YLJqr6lPildo5+H43xuAPIeKNbynxL7Oir7wra7H8XMzu2CpR6v09HXn9FopIVjeyl
	 8z43+QNNAISL8ozuUa7Tc/9+THk4+5ez8NHtiHcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/990] dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure
Date: Wed, 25 Nov 2026 15:31:16 +0100
Message-ID: <20261125143834.021759853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit 4ea99b14b3bd955d768666941e2e03ba186b52f5 ]

In zynqmp_dma_alloc_chan_resources(), sw_desc_pool is allocated before
desc_pool_v. If dma_alloc_coherent() for desc_pool_v fails, the function
currently exits through the runtime PM rollback path but leaves the
already allocated sw_desc_pool behind.

Add a dedicated err_free_sw_desc_pool label for the desc_pool_v failure
path, free sw_desc_pool there, then fall through to err_pm for
pm_runtime_put_autosuspend().

This keeps the error unwind symmetric and avoids leaking the software
descriptor pool on coherent descriptor allocation failure.

Fixes: b0cc417c1637 ("dmaengine: Add Xilinx zynqmp dma engine driver support")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-3-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 7cc5079511188..17bd0cce6833a 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -505,8 +505,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 					       (2 * ZYNQMP_DMA_DESC_SIZE(chan) *
 					       ZYNQMP_DMA_NUM_DESCS),
 					       &chan->desc_pool_p, GFP_KERNEL);
-	if (!chan->desc_pool_v)
-		return -ENOMEM;
+	if (!chan->desc_pool_v) {
+		ret = -ENOMEM;
+		goto err_free_sw_desc_pool;
+	}
 
 	for (i = 0; i < ZYNQMP_DMA_NUM_DESCS; i++) {
 		desc = chan->sw_desc_pool + i;
@@ -520,6 +522,9 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	return ZYNQMP_DMA_NUM_DESCS;
 
+err_free_sw_desc_pool:
+	kfree(chan->sw_desc_pool);
+	chan->sw_desc_pool = NULL;
 err_pm:
 	pm_runtime_put_autosuspend(chan->dev);
 	return ret;
-- 
2.53.0



