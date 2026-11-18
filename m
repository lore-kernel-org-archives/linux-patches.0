Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039590;
	b=uPdcI8TjqrXjEIaRovBjgQtTadnJxskT5GCe3gp6QwXdt9hXQoN+9hzOonSHR1HeElz3
	 Jhdo+U4fxtC2KWiGrFzn8FdDLtD1cL4CyHGYWRi0IZmWLTZvmr8aA4wARFPvoa6128XR5
	 AzjJZ9Tm1OH40Tacxgh0WUnuc5nJQOg8pHtGjgrnjo0h8T43WkP71/j08wz+kn8Rl4tF6
	 dRxJ+xBVySehoTieVedtmhGcbj+Fzd1gHRAt4FSqvtXSmC/CkKKmjpqPqMy0Iw2CuyNHN
	 0Ig+UNNkmValZZ4Z2bV4FVeDuo00RYn4IL5eUHHCP/WTzaclGUWDY09Tto9ol9XQ1uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zor8DF827ed04iVg0CS7qHupkreB5sn7DauwWSqQRv8=;
	b=S5dImyjE3Cx93XTd6ahNWS1ZTOJFLdhWcZUZ1gT7zxP20nnTafE6w6/mlkkttrwd42hN
	 ZO0ssoxI6HG1rXcgUO3dnmxjfvYtm9t2s4oW/2ta1UU91yKPZATO9v+JBmJSUgDxUvf8l
	 aNfqmc4w4LnvNvc9ow7ZcoCDNTKgPefKUfmx7bo5oSho3yFRidoXchVEorjcRpsR2cKD5
	 FKsk/F9eELObKPRPxISBWFLFicpOZ4TLZrPLjYjDY0qCYDE4NWLnWnAvnVEvEqcy/ya7v
	 5ljHMbwjXos3hvF3orMTgBkP36/1fEP6UD5CJ0aIkuLqcFdH+SASaUVJH7Ubgc7YOdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo6Aghfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915A6606A31C;
	Wed, 18 Nov 2026 22:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo6Aghfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3101F000C4;
	Wed, 18 Nov 2026 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039590;
	bh=Zor8DF827ed04iVg0CS7qHupkreB5sn7DauwWSqQRv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xo6AghfgNO/Rx1urg+Exy88Bh3Lwhr5e13gqeJPArc3WrYAPOBAt71kVNyrtvYkvl
	 l5Hj11G0AzjqgGhtWRtcASE8+mw4WWdelmeY9SAMac1pruG6E3x7i33E9+eEBuF6ZY
	 SOGLTcR/Odj/9+5xCHhATO+JYKpA+4QjdMjsyQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2156/3318] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118150426.705975710@linuxfoundation.org>
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
index 87c005855f96b..ac3d7600c3af7 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -660,7 +660,7 @@ static int dw_axi_dma_set_hw_desc(struct axi_dma_chan *chan,
 	ctlhi = CH_CTL_H_LLI_VALID;
 
 	if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-		burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+		burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 		ctlhi |= CH_CTL_H_ARLEN_EN | CH_CTL_H_AWLEN_EN |
 			 burst_len << CH_CTL_H_ARLEN_POS |
 			 burst_len << CH_CTL_H_AWLEN_POS;
@@ -931,7 +931,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



