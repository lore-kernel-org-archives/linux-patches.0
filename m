Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABA337CD32;
	Sat, 12 Sep 2026 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200913; cv=none; b=V5PXiF/lebbN7GWdx3niaX9Lw1a0vR8HS/iVCxSoXqvEz6ng1PGbgvImJ6xNLMcADXXeBBAwwoI0vywi+dWp7oeNbLGX1tYtSyIw1PDXWxDI9aI/Ex0egcPgaEXhDQuHBxiiOvzJDfkQafeMNAbPiVl4fo7KegFkmcp80MJYc38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200913; c=relaxed/simple;
	bh=RprkXGOQVXGUNWd8izwt465VsKnKYw07NzXuX6uFl9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIwZ2D/56aYq5hek9JLm+MKubdZ1Tlk0E7hhVhquRFS85Jk0f+TD2Xo7FNgkWd378jzUgtiQf4xOZuWMkd0FNWrOwOjyNIbOOgcNdYPIa+rd2W7EsqbeBNSaiV0wjQQMEPZqzLRwYsycOF9kXhPQOYbmq0jVfnuxZuYA5r6zptc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCrSMCcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCrSMCcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886811F000FF;
	Sat, 12 Sep 2026 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200912;
	bh=E8WbA9att5549s9yv9iYsTxsz5EUttKt+6nn1nimIYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCrSMCcIjBBHEEx35JVE/6zFxN7rJf+5x0Waf2XBkjXnvWpm7I7CEZi/JgAul+dbD
	 DqyhvTh/NGsU2XO47fue8C5rm7gBdUTCn9xNBzmGKagdoMfcUPlVXE6/4xSjKs1KNm
	 gR27LgT2rZIi5dC0630g+ebJaZ/M4TH3FpWyKPcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0888/1815] wifi: mt76: fix uninitialised RXDMAD_C descriptor info
Date: Sat, 12 Sep 2026 08:43:58 +0200
Message-ID: <20260912065709.766818686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d3ecac68f73b11828e72eaf7952a9beb5caea12b ]

Unlike other WED-RRO queues, RXDMAD_C frames continue into the skb build
path, but mt76_dma_get_buf() skips the desc->info read for RRO queues, so
the uninitialised on-stack info was stored into skb->cb and passed to
rx_skb(); initialise it to zero.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Link: https://patch.msgid.link/20260722082610.2699628-16-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1bbb40d6197de..8a9087427231a 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1002,7 +1002,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 
 	while (done < budget) {
 		bool drop = false;
-		u32 info;
+		u32 info = 0;
 
 		if (check_ddone) {
 			if (q->tail == dma_idx)
-- 
2.53.0



