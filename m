Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C711321B9DA;
	Tue, 26 Aug 2025 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213490; cv=none; b=OjoLqugVpUB4jZ+54K7IuJ3M9Nb7qjwUvtoqEyavpz/VogPIVe3sD8TaQsq7N1YCybSkEn22A+EwJBY206GwqEBaHhl860gkF7hSDyux6kZua0QbKA5LXkOIl+jeVeGeYLqgEFb+LXbZmNqmpWgfMce7QM0C6q1dIdCdQ2YRk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213490; c=relaxed/simple;
	bh=MU+AoZITi4ydetixTzAtbNgVije3EWdRHBb2F4jW1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYLsXORWi2VpKJ0akzVAt2mrvznOTQWUZYSd8sAq8rPLhYuZnWGCbddvxVIrnOJvQ7Z9P9jGqwZWtb3W8iNifwm93jMfCh6ydBDVhawRYIAZW3QuMuRAbI41l4iIML18Agp1kwxgaM/AqqeL22sEQaMDNg6wodFvjlvkQZV9Eq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BT7mJSw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BT7mJSw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F6CC4CEF1;
	Tue, 26 Aug 2025 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213490;
	bh=MU+AoZITi4ydetixTzAtbNgVije3EWdRHBb2F4jW1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT7mJSw5Rl+wlTlW4PALg1iPC4WEVgddsejXKl71Tc6uzxhtaXSSNxC3Ehf5TGHCz
	 f5CrryImAFW6mJc9IPUZoZG2mA+ctUxqMdSHEF8Cs1E3UeTLuYwK6evW7iNaC6ZzsT
	 SUAuqr2vJu1+IjoNawrUyi2/SbuoDJqzgupkVDOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.6 366/587] zynq_fpga: use sgtable-based scatterlist wrappers
Date: Tue, 26 Aug 2025 13:08:35 +0200
Message-ID: <20250826111002.221123711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


