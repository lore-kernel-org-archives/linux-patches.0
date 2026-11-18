Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054957;
	b=j20iuc7iJUPRxahTxuYwN4c0RIcVw5NFdBIyfHdwJzhQiIP0Lrfm/7L87PxspKL/M/gK
	 l7QkKs4SuUcB4X3XA+G9PG+7Jq5f0TGCmNo856f+kb0kJPy+ls2rS5tH4s88DErEe6grt
	 7XrDFvR24OU+kW8OXDMD8B7JdLUYTkrQiaz1Rigmy2oJ7OLuscPrDWq9ez1N+L7Qeos7w
	 w2GSnJVMpXd0VD0ZxcOhGa6rqmWiYJyTreuFSHKnqeXI5MP6ikQyAoLMn+ARruo+DriwH
	 uhykKfLLhuz5RLS+ZtvDPd22MO7cI84/JRMBQvOjSaOduSgxIbQsBz2cTavqN+Sb17w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MrTJ6fbscxm/l2mcwPcjbGEKBQJ3hG3aOZtkjRxoBrE=;
	b=lhS4FVts/PvaaQR3M/n/9GkuqMGg1tso9oGDXN3u7P5qnn7N4E5JASu6zxHwL4iTxVLi
	 kVy0UV1lcwYpXNOuDXlvTSUpFGyxlG0Vx0knL0smr7dBmC7ln56X1bq8ReIZiG+IvC8HH
	 B+VGp6b6eh8i9FeZkXyEONYXJV2PibM+FKl0hs3VlDnAsLSc4fuIx7Z8U4s5BLH29gOlW
	 xo0//1+1+iDy6rSipstCOrJqKZmS33qszJTqBkp1LucpKzurTwMUAc75BACimhkW+6wpc
	 KdSaolQYdcPa99VTcuMJpdAM7mQqq6c2Uli4zWNyCm2DBQ1qkegx+Tnl46fnRDN44eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ishVmROB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB0606A320;
	Thu, 19 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ishVmROB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DF41F000C4;
	Thu, 19 Nov 2026 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054957;
	bh=MrTJ6fbscxm/l2mcwPcjbGEKBQJ3hG3aOZtkjRxoBrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ishVmROBnWd1+UWFWDyyyN3ruHG1oHR3m5oe4rOeYBi/HtThrJxj3zM6XQwrR4ZoH
	 AihuDr9kj9OWAWKxRa/Ya8wKyL2mxyRgBBPLaanps1DNGyvdR1O4sqccjZCt7a3ay+
	 GTzxw9JKy05IRNgEoBdsyeiTNFBIMqJL3nTmY5H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1458/2214] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:52:14 +0100
Message-ID: <20261118150109.391694042@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 0d59891c42e11c3840276d8a632dbc355d6ddc4f ]

The snps,axi-max-burst-len property describes the number of beats in an
AXI burst, while the ARLEN and AWLEN fields encode that value minus one.

The driver keeps axi_rw_burst_len as the actual burst length so that
dma_device.max_burst reports the correct value. However, it also programs
that unencoded value directly into the hardware fields. A value of 256
therefore overflows the 8-bit fields and can cause AXI decode errors.

Subtract one only when constructing hardware descriptors, while keeping
the actual value for dma_device.max_burst.

Fixes: c454d16a7d5a ("dmaengine: dw-axi-dmac: Burst length settings")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-1-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index e3d40b6cc723b..32faa698eab88 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -653,7 +653,7 @@ static int dw_axi_dma_set_hw_desc(struct axi_dma_chan *chan,
 	ctlhi = CH_CTL_H_LLI_VALID;
 
 	if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-		burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+		burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 		ctlhi |= CH_CTL_H_ARLEN_EN | CH_CTL_H_AWLEN_EN |
 			 burst_len << CH_CTL_H_ARLEN_POS |
 			 burst_len << CH_CTL_H_AWLEN_POS;
@@ -924,7 +924,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



