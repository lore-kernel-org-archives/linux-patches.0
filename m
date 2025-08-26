Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92395285CA9;
	Tue, 26 Aug 2025 11:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208289; cv=none; b=J31y8TJ2O61xvqEHO0y9zznAtYUyKi8L7iUwfAaJ+w8/6XZ1YKuZT8ONap1Tx4PY/vmCKMvXL7uBPFW/nBPjY0ImLNxH3jzrz2oaCN5ESt3UdQsF/8gu8O9BfVYgOJzaYQbBzvhZY4WWs/mNT0Q54Tuqf6nYAIulkUabppjntTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208289; c=relaxed/simple;
	bh=hXqLF+aL/OW2i9sO3BswqfplI5EbxnHLR+mlj8qWqj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfGOhvEuRZjDJyc+8ZcD1W2N3UyFYr3fGZG0uG+Rc92hwPsHeJb6yiRJS61kaFE/wNErdmiC0yvYLMzLryRABmpsBlwOEamv8u2V9Oo3SfkW7WPGJts5pY6jrwlJtb/h50ex81AEH2gxRN8BMoh0/fM2qNP305sbJggj8VUMjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ7GCieB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ7GCieB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27763C4CEF1;
	Tue, 26 Aug 2025 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208289;
	bh=hXqLF+aL/OW2i9sO3BswqfplI5EbxnHLR+mlj8qWqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ7GCieBLKdHxiu6nwtrD5pGaIgrFOCbn3NGhOj6b2sQiqy4ICPw31X5CZFMAhD1d
	 d4Owo8XBrfUoer61x+daE/ZhQsFdSr1gdNxpnshj6HHrWxsXWweFGU6er1ymjSwMHv
	 kBTQk6N0406NLgMW/6sDhSG3l6tLVkbEg0cPTSmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.12 055/322] zynq_fpga: use sgtable-based scatterlist wrappers
Date: Tue, 26 Aug 2025 13:07:50 +0200
Message-ID: <20250826110916.869102940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 37e00703228ab44d0aacc32a97809a4f6f58df1b upstream.

Use common wrappers operating directly on the struct sg_table objects to
fix incorrect use of statterlists related calls. dma_unmap_sg() function
has to be called with the number of elements originally passed to the
dma_map_sg() function, not the one returned in sgtable's nents.

CC: stable@vger.kernel.org
Fixes: 425902f5c8e3 ("fpga zynq: Use the scatterlist interface")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20250616120932.1090614-1-m.szyprowski@samsung.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/zynq-fpga.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/fpga/zynq-fpga.c
+++ b/drivers/fpga/zynq-fpga.c
@@ -406,7 +406,7 @@ static int zynq_fpga_ops_write(struct fp
 	}
 
 	priv->dma_nelms =
-	    dma_map_sg(mgr->dev.parent, sgt->sgl, sgt->nents, DMA_TO_DEVICE);
+	    dma_map_sgtable(mgr->dev.parent, sgt, DMA_TO_DEVICE, 0);
 	if (priv->dma_nelms == 0) {
 		dev_err(&mgr->dev, "Unable to DMA map (TO_DEVICE)\n");
 		return -ENOMEM;
@@ -478,7 +478,7 @@ out_clk:
 	clk_disable(priv->clk);
 
 out_free:
-	dma_unmap_sg(mgr->dev.parent, sgt->sgl, sgt->nents, DMA_TO_DEVICE);
+	dma_unmap_sgtable(mgr->dev.parent, sgt, DMA_TO_DEVICE, 0);
 	return err;
 }
 


