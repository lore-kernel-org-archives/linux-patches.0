Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF5446AA71;
	Tue, 21 Jul 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648371; cv=none; b=XDhz1VthDIU7KIxgRFJGxeJJJ2qetK6MzNlymbZYijtjvmLF0XMxf7mXL0l/+Es901+rPYRlfJo0TA/M5uvdA7+/BdtBYzcwDUtvtanMsHylWEXR2oRAK/z9k+jr4mHqZLGo+u2PKt5uHTZDicmXyhLrE7OUex9BbyGLNaX8Ba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648371; c=relaxed/simple;
	bh=iYwQLbURkuwChCYD6mdS26cF9xraXQ8/aU5q6Mt+eTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQKevFc8qoIlLHtMcVR/H+4pQcS350I0QEiFVLsfOYUZIq77EtVm0TwB80TOUrOaLVUctC0ujvMzS+bEPaTL8N3kRGSs/eEydLN+FPZL9HtAdNE3MfKN2cGGkZLIJTCv/icD8S4JZpoLkgHgzX408jENpNlqwXLdJVvhUs9VUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7mRiOTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7mRiOTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB181F00A3A;
	Tue, 21 Jul 2026 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648370;
	bh=jloW3RTjtTXobyJf6MWiJQXexlMNXOZyGvGVRRCK9v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7mRiOTEnJchruB9K3H5gWL5xkWAugLoRy1mhv3OxGt0vuecJoDDmiLvYioe6tqxd
	 DKWCuu/SuCWrnZOvVyfUodxQCmw7fb0AfYJ2WLa+ptN5to/JTl1AIZT37CGHsaPSvu
	 tdiDImiy7RH7Qqxi8J7baB9MMlxUDP/EaM588h94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0172/2077] ntb: Store original DMA address for future release
Date: Tue, 21 Jul 2026 16:57:25 +0200
Message-ID: <20260721152556.743830457@linuxfoundation.org>
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
index 7cabc82305d6b1..771eb7d9f43560 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -223,6 +223,7 @@ struct ntb_transport_mw {
 	void *alloc_addr;
 	void *virt_addr;
 	dma_addr_t dma_addr;
+	dma_addr_t original_dma_addr;
 };
 
 struct ntb_transport_client_dev {
@@ -766,7 +767,7 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
 	dma_free_coherent(dma_dev, mw->alloc_size,
-			  mw->alloc_addr, mw->dma_addr);
+			  mw->alloc_addr, mw->original_dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
 	mw->alloc_size = 0;
@@ -802,6 +803,7 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 		return -ENOMEM;
 	}
 	virt_addr = alloc_addr;
+	mw->original_dma_addr = dma_addr;
 
 	/*
 	 * we must ensure that the memory address allocated is BAR size
-- 
2.53.0



