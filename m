Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9B346AA6B;
	Tue, 21 Jul 2026 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648374; cv=none; b=X+nhlDapQm9C4nkZbeIuWwXvWkffR/ShYSh4QEEipTZvF8RHadRxu6TASn/G0JyYg3Yu7DvUEaGW57ePgETwm9Diq59jDVugjVAc/kr9Pmz+7RHt1+h4ei5Q0hDp5D3OQtFWhNECxwu2206lJpyXEQIMptnh7ZDXYdMmnQoJ4rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648374; c=relaxed/simple;
	bh=oc+1SGshiQRuhVB2M3Kdcwg09gR9ALODWl/m/WpX3SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P06qQDQmkOcjjSZsp/U117dSDV8Wohocu/FrYI+OlOaKVQOBgk6g73RJm7Xxm/JmRFVMme1Eb9aMOl5GqCQTQedu35F4H5QuJkPZ3j7/IlRe1Mhg90YqVgAqFI20haPIUxiwm7dgYsA9+eBc34rJHOaiAl2WyFJFZeEhKLmW6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZIXlBiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZIXlBiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B496F1F000E9;
	Tue, 21 Jul 2026 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648373;
	bh=lcIZptcOvj4d9eipSUxfNNFLg4ntoDiFk6o1TUy8wxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZIXlBivPIYAfVWTSgAK2cBVuaHY/UX21dWbOLBHpp7TZ4IEK8UjnfEWS7CR8fGZI
	 5yL3LMmKqM06zvT+LW9LxALb0xM/biuVA18motika/E/v3WVaArEc3996G0Paf08yb
	 8G4NM4J8TkbinLfJGT9nz6D35MNWW2vrkDLi8Qws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0173/2077] ntb: Use consistent DMA attributes when freeing DMA mappings
Date: Tue, 21 Jul 2026 16:57:26 +0200
Message-ID: <20260721152556.766648143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 9d625aa2ebd445868955719e0abcf695b43f9318 ]

The counterpart of dma_alloc_attrs() is dma_free_attrs(), which must
receive the same DMA attributes used during allocation. The code
previously used dma_free_coherent(), which does not accept or apply any
DMA attributes.

Fixes: 061a785a114f ("ntb: Force physically contiguous allocation of rx ring buffers")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260501-dma-attrs-debug-v2-2-8dbac75cd501@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 771eb7d9f43560..f59f926d4bfaa9 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -766,8 +766,8 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 		return;
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
-	dma_free_coherent(dma_dev, mw->alloc_size,
-			  mw->alloc_addr, mw->original_dma_addr);
+	dma_free_attrs(dma_dev, mw->alloc_size, mw->alloc_addr,
+		       mw->original_dma_addr, DMA_ATTR_FORCE_CONTIGUOUS);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
 	mw->alloc_size = 0;
@@ -828,8 +828,8 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 	return 0;
 
 err:
-	dma_free_coherent(ntb_dev, mw->alloc_size, alloc_addr, dma_addr);
-
+	dma_free_attrs(ntb_dev, mw->alloc_size, alloc_addr, dma_addr,
+		       DMA_ATTR_FORCE_CONTIGUOUS);
 	return rc;
 }
 
-- 
2.53.0



