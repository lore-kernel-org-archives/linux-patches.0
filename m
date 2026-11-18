Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048118;
	b=M8pl3FhylU23ZSQtu+Q2paVqZZkfeIT5J+BSxJAAGSeUP7G80+GJggRGIegnbB+BPyt/
	 OGPu285U0CxANQjUEDCSOdHO8bCM/EhXNiiFyG172wD21t/yAHHaTyU7eqsUb6+MhevgB
	 8xQbMoAZbkeyUPe8lF6kLuQNqkZV5zKrgZMarE4FPHWSAR2acQgYlBprKtMxLlFwq3pbK
	 C5LCz1A4Xep19x2SxudAxBywiEG1daBcjz95MY/SqMNFcA5qY+d1SbubjSIHaANJuCcMa
	 yxi9Q3uZQpmIo7S3TyWen9hBsvTn80l/c3jcHTsEhtQi11jC+mXBgMmCYZLtzqHPpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hqopx9IjjMS71nK/L6zTOKXJxdImr59BHMagstdfZW8=;
	b=tFvCmRt7dAqS2zGITQ8U6I5HU2K/+pjjHtfP+g5gWGqvw67jGllXmnFzQBNQ/b70YmJI
	 tyOBUyZmrprd9sxJbKGNO4bHWzdh2mq1s4VqkGKxYETPh6PIjaiVQrSeqSFjPfJNu9sYW
	 ZNf5UtHPwyRlDnlwTF9en8zbJ+a/U/2neyd6U6o9NmhfEJTDmJOPLqRbZoXQDIXixfLTN
	 R8J8riiJu7LW6vWaPr96hR4KWwJmTY0ndnjemNyAzWkudpkBzm54A+584Pwv6PjlShC1G
	 nrHbz0DqrH/0zv20Cx01fwGVVpTxCK9rt9Qzz+1SKJA0raDFVQvKNn1Fo8RrrJfGnTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6OAdHUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F0606A31C;
	Thu, 19 Nov 2026 00:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6OAdHUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B491F000C6;
	Thu, 19 Nov 2026 00:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048118;
	bh=hqopx9IjjMS71nK/L6zTOKXJxdImr59BHMagstdfZW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6OAdHUKnmLiJNLJ/r5LKlR/AryWxDemEj4hr5ZUyQIT19jMXxdrVfeNXceSpY216
	 wfsboG5nNxDC2JYJpEg71NHVhEEIvz/ttWbUDCS37ar9B6kFlOIr6gdCEpVlw1c34x
	 PBUVxZnpIZUuDaOYT3K4Nw1ybUaW4nOb1Wg7F9SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1881/2857] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118150308.960995819@linuxfoundation.org>
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
index c9571c248f4a6..73e8754342a08 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -661,7 +661,7 @@ static int dw_axi_dma_set_hw_desc(struct axi_dma_chan *chan,
 	ctlhi = CH_CTL_H_LLI_VALID;
 
 	if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-		burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+		burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 		ctlhi |= CH_CTL_H_ARLEN_EN | CH_CTL_H_AWLEN_EN |
 			 burst_len << CH_CTL_H_ARLEN_POS |
 			 burst_len << CH_CTL_H_AWLEN_POS;
@@ -932,7 +932,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



