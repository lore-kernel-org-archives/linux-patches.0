Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611F018D65C;
	Mon, 28 Oct 2024 06:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098162; cv=none; b=Ixfn8zG1IpqxlkK7pYVUoSb7qIjuBB+cmvUfDhdG2KzUl5fwJaPOWbmBc2lp9W2RwAjSdq2yakim1XWTwhuoGjGXR3GJMxyAVOxp57sn42iwqpLhdZ0d3d6nyYlNTGFOfJiIjhD9xRdqelqvvk9kI/S+vZIafwMpz7KOia17onU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098162; c=relaxed/simple;
	bh=qmjJ6fL85vyaS8TjD1RbxAxQPRLG+ZEcpuG4GLnBkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC5Bc+aEgipluaHWYbW6Er24SnOODnF5BZyRKnOxUbQFyig5s+Zqgdn98ZReqofYzbpZpSupif+CKGkd3g7zurF1qG5dwctjm+tYINWbSXry8lQt7m69cQK0R4q92Klttxn1uJECQUT/O2faWiPLMJbyMUz7at9JbytS1+Rduic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGMFiOCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGMFiOCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A05C4CEC3;
	Mon, 28 Oct 2024 06:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098162;
	bh=qmjJ6fL85vyaS8TjD1RbxAxQPRLG+ZEcpuG4GLnBkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGMFiOCvwRfU7CsUI2flzPVHgWbYOowF+sdF9r0hjCZbQHg8b4NWyPHuoGdA3uUIl
	 flKlK6k1oEGe/NNfP0fkQldK9/ToyZpii3TTfK2/kSXjlNZhs21MQIv5ff/lq8oxdx
	 SeK7LqQHJwmMnCmOnAFXyX2D9EGnEQnIq5CBDayI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 097/261] net: ethernet: mtk_eth_soc: fix memory corruption during fq dma init
Date: Mon, 28 Oct 2024 07:23:59 +0100
Message-ID: <20241028062314.462056291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 88806efc034a9830f483963326b99930ad519af1 ]

The loop responsible for allocating up to MTK_FQ_DMA_LENGTH buffers must
only touch as many descriptors, otherwise it ends up corrupting unrelated
memory. Fix the loop iteration count accordingly.

Fixes: c57e55819443 ("net: ethernet: mtk_eth_soc: handle dma buffer size soc specific")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241015081755.31060-1-nbd@nbd.name
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 16ca427cf4c3f..ed7313c10a052 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1171,7 +1171,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 		if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr)))
 			return -ENOMEM;
 
-		for (i = 0; i < cnt; i++) {
+		for (i = 0; i < len; i++) {
 			struct mtk_tx_dma_v2 *txd;
 
 			txd = eth->scratch_ring + (j * MTK_FQ_DMA_LENGTH + i) * soc->tx.desc_size;
-- 
2.43.0



