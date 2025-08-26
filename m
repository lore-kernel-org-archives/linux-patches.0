Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC49246790;
	Tue, 26 Aug 2025 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213922; cv=none; b=qvgEdLpRW/Rj6Z3Ql7PNYddv+UnkpG6Tea+F+HFxYkSC+2eDoX2LmxRie0FvlURIk4Ddkxt29/75yqpkHHwgOte3nenmRek9X1cBUEgMvvytgvLv2JXpZGceW+XawcdmEB9gwEwGa1TgFLmPYrmjRSLdMDBBQ+unOt/SXOL/hgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213922; c=relaxed/simple;
	bh=cOHcZ/UL+xcAoC83s1t8fKLBb4HQpFlZ55rmHESO9gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtGRYdMUr/eyS/hgUD9d557/idZXA2p6Hh8ObrDvXLPRdv1Iiw/qXU97GCyPOtI7rp4+IslQQkbzpPkaAqd+dsgHKeAMkDknh4zfWDb7weXlIalYrbmqPi/JFyglA2xjmGawb85ny67q81JR2BwBB82LC4TCfieGTXnYWN2Qhjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyURPmyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyURPmyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C1C4CEF1;
	Tue, 26 Aug 2025 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213922;
	bh=cOHcZ/UL+xcAoC83s1t8fKLBb4HQpFlZ55rmHESO9gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyURPmylVMRrhlBAORFNBCR5qeRdIBq49bx3Ny3uz2EY/nirpL6eYUluDINevFjXZ
	 Czi0dkmQD/Cu9MVFZtgo2ibCQxadIneTSs7aj76PnNyCgBpv+ZBUM077ZQMJb6uul+
	 jAHFgqPKKurxTDE5XZ7UZX/OEiM5FTRgfLh1y9/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Pisa <pisa@fel.cvut.cz>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.6 513/587] fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()
Date: Tue, 26 Aug 2025 13:11:02 +0200
Message-ID: <20250826111006.047084346@linuxfoundation.org>
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

From: Xu Yilun <yilun.xu@linux.intel.com>

commit 1ca61060de92a4320d73adfe5dc8d335653907ac upstream.

dma_map_sgtable() returns only 0 or the error code. Read sgt->nents to
get the number of mapped segments.

Fixes: 37e00703228a ("zynq_fpga: use sgtable-based scatterlist wrappers")
Reported-by: Pavel Pisa <pisa@fel.cvut.cz>
Closes: https://lore.kernel.org/linux-fpga/202508041548.22955.pisa@fel.cvut.cz/
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Tested-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://lore.kernel.org/r/20250806070605.1920909-2-yilun.xu@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/zynq-fpga.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/fpga/zynq-fpga.c
+++ b/drivers/fpga/zynq-fpga.c
@@ -405,12 +405,12 @@ static int zynq_fpga_ops_write(struct fp
 		}
 	}
 
-	priv->dma_nelms =
-	    dma_map_sgtable(mgr->dev.parent, sgt, DMA_TO_DEVICE, 0);
-	if (priv->dma_nelms == 0) {
+	err = dma_map_sgtable(mgr->dev.parent, sgt, DMA_TO_DEVICE, 0);
+	if (err) {
 		dev_err(&mgr->dev, "Unable to DMA map (TO_DEVICE)\n");
-		return -ENOMEM;
+		return err;
 	}
+	priv->dma_nelms = sgt->nents;
 
 	/* enable clock */
 	err = clk_enable(priv->clk);


