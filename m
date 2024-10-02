Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49251D079D;
	Wed,  2 Oct 2024 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876479; cv=none; b=GKRlsDr1+sT18unSeQx74QevIUmcZ6UP89MS1ImcoRHY/fM6S+q0OndliMZt5VYpIfVe+ktUFnnizkqSPsCLTyPqmdB5ojeeFwub6w3MV9jBM0JLWj4i1q++5cZdcTgQUpLjfM5YAd9hUDzyYtTlJZk60S1dWwBjOgiIXJXPsxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876479; c=relaxed/simple;
	bh=An30xeWiMWpHB+qdZv7fCaxE2Gx+5nQbGuDJ7mJeOmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t82gYMJl5xHvRpuUpiLVYlO1ebIe5oHrhhFVjBY1vIV4CGofYsAxGbxinWYwfL6xyBQ7JqkpNrRF/vCmPacdEhcnvT0JWOzGnE7uks6YAm/2wbVOA+zwknKUqbS8bQqddfgbuOGroJjZm/py1zb/3SwUOvTH8EtCFLA7HW7DZL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pn8ldw6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pn8ldw6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E457C4CEC5;
	Wed,  2 Oct 2024 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876479;
	bh=An30xeWiMWpHB+qdZv7fCaxE2Gx+5nQbGuDJ7mJeOmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn8ldw6TOOUN09aDh8nrFbvFZr/tydfTR2brfXy4IqUQH4GOvA3hcxcJdt71nkWxO
	 oKMaju/yTemCAxerQpyifiEW8fXxAgyyt13Pc5ealKgMMwozVRoIFSd/DxUkBjWyW4
	 o4LikTfTa9/pjXD6aNlVS+OWB00+mIYWk33xje3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Dai <jerry.dai@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 427/695] ntb: Force physically contiguous allocation of rx ring buffers
Date: Wed,  2 Oct 2024 14:57:05 +0200
Message-ID: <20241002125839.504929984@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index 77e55debeed61..ef2855946a992 100644
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



