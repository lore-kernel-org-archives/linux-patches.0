Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED9D3C73CC;
	Sat, 17 Oct 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259553; cv=none; b=AdBWO2JJxJ7O9SSwspl39GN0rD2Vlm7n9w1tgFs/FPRNdRs+rnYHqJOsay0d9BsFXNWoAXgZg4hlJzGUwQ8x+TbVOvVw45F+7XFClBS7TqWIDmK8rbICgTZHkn05RWhQtH4Yny3L7YiusL30tboEz350URp/OPh4k41YKGqc834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259553; c=relaxed/simple;
	bh=aFMasWXg+bi4Db3l7fxNUwZiFpq/QkJAwI78GfvpkJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVUSZwoMoYWQeVaKOPf9hIjy33CrnOnk/ERanqcgFVtSYrg8y7XaGmeC3Ka+bQ9SJJbrREGnH+kN/3T6RFNKaRCvLQGJS7foKNQieRzYbtvRJHT6ezyQy/eS1opZZyi/IKEPCun4IVN8Ab2DaH8xezlWvgdqjADR60uhcUW3k0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QwSf+LR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QwSf+LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC6D1F000C5;
	Sat, 17 Oct 2026 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259552;
	bh=anm1IytJp2oJyUWIfttNXCHMMzDPcB/WUv/ylEUdbpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QwSf+LRGZgF4Edy/gmXWTJeOr8dzc0HetB0t7D6qRIkaXczCDBkFEmC+9Ox7/lFa
	 1M4pHEwz10pfSHKWTDxQLZnckLjX2cWm2RZetPOuJtyjGXhnq81LlyP+WCG36eI+z6
	 xICFlyLrd55fPEKkS7+VbV8V89iy870y7r3qEFlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1252/1674] ntb: Store original DMA address for future release
Date: Sat, 17 Oct 2026 17:58:44 +0200
Message-ID: <20261017160503.278047272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit da6d997ac556479c112554ab5d95cbd04683eb11 ]

The DMA API requires that dma_free_attrs receive the exact dma_handle
originally returned by the allocation function. Do not modify it.

Fixes: fc5d1829f9bf ("NTB: transport: Try harder to alloc an aligned MW buffer")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260501-dma-attrs-debug-v2-1-8dbac75cd501@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index afefbe557f727..df86c99c554f1 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -211,6 +211,7 @@ struct ntb_transport_mw {
 	void *alloc_addr;
 	void *virt_addr;
 	dma_addr_t dma_addr;
+	dma_addr_t original_dma_addr;
 };
 
 struct ntb_transport_client_dev {
@@ -798,7 +799,7 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
 	dma_free_coherent(dma_dev, mw->alloc_size,
-			  mw->alloc_addr, mw->dma_addr);
+			  mw->alloc_addr, mw->original_dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
 	mw->alloc_size = 0;
@@ -834,6 +835,7 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 		return -ENOMEM;
 	}
 	virt_addr = alloc_addr;
+	mw->original_dma_addr = dma_addr;
 
 	/*
 	 * we must ensure that the memory address allocated is BAR size
-- 
2.53.0



