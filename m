Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350C81D1300;
	Wed,  2 Oct 2024 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878367; cv=none; b=mHBx6FrwVg4nwQ3fqWl/jfhaBlO06IzkQwCmerwFAr85I/AruIiU3SZeD+2iSjKWElUhnqNJiOUHlbwcw2OYz7E4Es0RaVrMmNHKVj31nTjPfbfkaLwHC1R5RwznuODR8bHCeAus1IK/NxZhkTbj/IexMwY9xAqoRPYVRlZjeP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878367; c=relaxed/simple;
	bh=HIHax+0ku9WWJ0NZGXbUdbyqhLdvyP+MCXigoncU2r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzWqaMMg63Rxc5rOshklGn1nT/T6axvt2nI38QrcunsC23HCDi9Fh+7iTrj9IwuQARFUYTjQZfOTip9xxTdT97iewAFU/dfO7JVWyh4y+2wy1U2EewRGQ65SRA6E3YYg0Z4QGrPk8e68ObMv6Fv5Dc3XQ2rpCZHHlGtIaKEcvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyGpM6Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyGpM6Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE554C4CEC2;
	Wed,  2 Oct 2024 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878367;
	bh=HIHax+0ku9WWJ0NZGXbUdbyqhLdvyP+MCXigoncU2r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyGpM6KuPwwemMmIKZdPcAYGp/i+/TBRBFornUV66MmJkp3pYabVWxUyLZCK6ottj
	 kL9CC1mR5SdPsyVewPWkHws2Pk/nAgPv5FX3fJ9N12pUSVJgc0ppte3+7sCYNK+mJH
	 gaBPpGzc7bB7nwXK6cIa7vMDKks2UX9r+viPGUJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Dai <jerry.dai@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 389/634] ntb: Force physically contiguous allocation of rx ring buffers
Date: Wed,  2 Oct 2024 14:58:09 +0200
Message-ID: <20241002125826.458798726@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 061a785a114f159e990ea8ed8d1b7dca4b41120f ]

Physical addresses under IOVA on x86 platform are mapped contiguously
as a side effect before the patch that removed CONFIG_DMA_REMAP. The
NTB rx buffer ring is a single chunk DMA buffer that is allocated
against the NTB PCI device. If the receive side is using a DMA device,
then the buffers are remapped against the DMA device before being
submitted via the dmaengine API. This scheme becomes a problem when
the physical memory is discontiguous. When dma_map_page() is called
on the kernel virtual address from the dma_alloc_coherent() call, the
new IOVA mapping no longer points to all the physical memory allocated
due to being discontiguous. Change dma_alloc_coherent() to dma_alloc_attrs()
in order to force DMA_ATTR_FORCE_CONTIGUOUS attribute. This is the best
fix for the circumstance. A potential future solution may be having the DMA
mapping API providing a way to alias an existing IOVA mapping to a new
device perhaps.

This fix is not to fix the patch pointed to by the fixes tag, but to fix
the issue arised in the ntb_transport driver on x86 platforms after the
said patch is applied.

Reported-by: Jerry Dai <jerry.dai@intel.com>
Fixes: f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP")
Tested-by: Jerry Dai <jerry.dai@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index f9e7847a378e7..c84fadfc63c52 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -807,16 +807,29 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 }
 
 static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
-			       struct device *dma_dev, size_t align)
+			       struct device *ntb_dev, size_t align)
 {
 	dma_addr_t dma_addr;
 	void *alloc_addr, *virt_addr;
 	int rc;
 
-	alloc_addr = dma_alloc_coherent(dma_dev, mw->alloc_size,
-					&dma_addr, GFP_KERNEL);
+	/*
+	 * The buffer here is allocated against the NTB device. The reason to
+	 * use dma_alloc_*() call is to allocate a large IOVA contiguous buffer
+	 * backing the NTB BAR for the remote host to write to. During receive
+	 * processing, the data is being copied out of the receive buffer to
+	 * the kernel skbuff. When a DMA device is being used, dma_map_page()
+	 * is called on the kvaddr of the receive buffer (from dma_alloc_*())
+	 * and remapped against the DMA device. It appears to be a double
+	 * DMA mapping of buffers, but first is mapped to the NTB device and
+	 * second is to the DMA device. DMA_ATTR_FORCE_CONTIGUOUS is necessary
+	 * in order for the later dma_map_page() to not fail.
+	 */
+	alloc_addr = dma_alloc_attrs(ntb_dev, mw->alloc_size,
+				     &dma_addr, GFP_KERNEL,
+				     DMA_ATTR_FORCE_CONTIGUOUS);
 	if (!alloc_addr) {
-		dev_err(dma_dev, "Unable to alloc MW buff of size %zu\n",
+		dev_err(ntb_dev, "Unable to alloc MW buff of size %zu\n",
 			mw->alloc_size);
 		return -ENOMEM;
 	}
@@ -845,7 +858,7 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 	return 0;
 
 err:
-	dma_free_coherent(dma_dev, mw->alloc_size, alloc_addr, dma_addr);
+	dma_free_coherent(ntb_dev, mw->alloc_size, alloc_addr, dma_addr);
 
 	return rc;
 }
-- 
2.43.0



