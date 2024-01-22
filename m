Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A46560274;
	Tue, 23 Jan 2024 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970841; cv=none; b=hOyBqqD5/hY/2z10U8XsJij+UnSN0SALY1UCLsUBu83cc/GbjiFiSTqi3tzNIe0utgqsQZKGbn2rUV8zsETSWXz33V4DV4xGTvWyRLEnjlRMDNfCqDzOkecne/s2Q/yC7SHju8AsGjN5TZnRcmG0b7z3TN19E3HYHo/LXaZKW+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970841; c=relaxed/simple;
	bh=7V3/Y51cDklvX0CtTRpsHWmxgvsWB2WvQwfESe/K61M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pymsfnmlrlxoSPeWtf+iIX7Nrf+javz6WBi1RNMIvqfssHZqiyee2ZGamWv89BK1BgcFSHTP36YKBvGadVqzfhoaCf+48/uVtP5bBGyqIuveps1GvrRhsLXnjIJYVDQtf745oWUbZT6K+VwQdlffCfhb3yDeZ4Bstj83IStDXHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ktJrUpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ktJrUpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3ACC43390;
	Tue, 23 Jan 2024 00:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970841;
	bh=7V3/Y51cDklvX0CtTRpsHWmxgvsWB2WvQwfESe/K61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ktJrUpqc1z7i7SDwt9l2X2/doV+wP13lmZHzTLgTsLk8UhPwFuJ1gs81Fukw1R0s
	 JugawNBmHYOaxSLilyGIQxHjovUViMRBZ/5f/SESRJL33ey8htxxIFNaPMY9Cq354w
	 NNPcRt/poQMAyFncVpEA40JIeYo4XMxeicjpwQ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/417] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:54:51 -0800
Message-ID: <20240122235756.060040401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Zhang <joakim.zhang@cixtech.com>

[ Upstream commit b07bc2347672cc8c7293c64499f1488278c5ca3d ]

Reproduced with below sequence:
dma_declare_coherent_memory()->dma_release_coherent_memory()
->dma_declare_coherent_memory()->"return -EBUSY" error

It will return -EBUSY from the dma_assign_coherent_memory()
in dma_declare_coherent_memory(), the reason is that dev->dma_mem
pointer has not been set to NULL after it's freed.

Fixes: cf65a0f6f6ff ("dma-mapping: move all DMA mapping code to kernel/dma")
Signed-off-by: Joakim Zhang <joakim.zhang@cixtech.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index c21abc77c53e..ff5683a57f77 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -132,8 +132,10 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
 void dma_release_coherent_memory(struct device *dev)
 {
-	if (dev)
+	if (dev) {
 		_dma_release_coherent_memory(dev->dma_mem);
+		dev->dma_mem = NULL;
+	}
 }
 
 static void *__dma_alloc_from_coherent(struct device *dev,
-- 
2.43.0



