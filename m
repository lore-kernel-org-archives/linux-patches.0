Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BAB4F4736;
	Tue, 13 Oct 2026 12:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893865; cv=none; b=iZF3SdJVgLO9qPXh2uKv/agQaLyWCyE4NhFJSWCYfUbHRTHihFzbLEC29mvyGCbrxMq/jehqCVdQ1sufBpDDP5hQgqUOoY5sPOz5cxMpJIOQLMRKOwytaxmboXWQDTo8bQdJMqxrBjX173nqq30TqEiIGulm/sMu/mE6j5SNE/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893865; c=relaxed/simple;
	bh=1dybX1Tgg5sSYvI0EBVLMbZSHTfJxC96qQfxTbAJAHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPIM3PboT5JnarDBfQUNVFPgxlk5xJvY640qZDtB61EL8+8FY1YIIlBSF+8c8kVbwA/gT2gXcY7692BZBq2lcsGDx/Gd/UWQ6vyKkjFxrxP8JRRbsJDaStm9RSiiAGYJCnpkR5MTXVijGiiIovr4mkmYaY23yfu+0JlGCPo/OjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGP3EIEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGP3EIEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118A31F000FF;
	Tue, 13 Oct 2026 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893863;
	bh=llSp+q+5faGNAPbTKZs+ApviwSwpfQeWAJt3PDvomXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGP3EIEzYhtcqvW5ui4UhusKa8mAMabL7NATQuodU+Nd157JAPsgwpzZ2KePzUIkO
	 Zln7SPbV/tmEYg7kCHHE2sIIKV5gwo66bghj9Luc8sAxwb4hom0a5jP+Nhu6oeAWZF
	 gjbuL4fN0haK4RR9ugXHybWo0fdqKABj8yiWHLtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/621] ntb: Store original DMA address for future release
Date: Tue, 13 Oct 2026 13:36:03 +0200
Message-ID: <20261013112929.582908346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8f78f553d9f31..4cba659a657d6 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -212,6 +212,7 @@ struct ntb_transport_mw {
 	void *alloc_addr;
 	void *virt_addr;
 	dma_addr_t dma_addr;
+	dma_addr_t original_dma_addr;
 };
 
 struct ntb_transport_client_dev {
@@ -804,7 +805,7 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
 	dma_free_coherent(dma_dev, mw->alloc_size,
-			  mw->alloc_addr, mw->dma_addr);
+			  mw->alloc_addr, mw->original_dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
 	mw->alloc_size = 0;
@@ -840,6 +841,7 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 		return -ENOMEM;
 	}
 	virt_addr = alloc_addr;
+	mw->original_dma_addr = dma_addr;
 
 	/*
 	 * we must ensure that the memory address allocated is BAR size
-- 
2.53.0



