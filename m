Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068CD3570C7;
	Tue, 26 Aug 2025 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218175; cv=none; b=En5wPh4Dk5u0cxTmh7qUe2KLsHZaYWSfWgiNfivq54LvSBOXVS+6kzFyHW5gSWUfYwNp+UH8ciqLi8UzCIyuP/xTcyhBoDEx3/rDoNyLFi37oFSBC8lblosthpTUTmc0C8/CIgIe5ey6B4fvbsOCgNxAhVhZj+XIclbDGrUkqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218175; c=relaxed/simple;
	bh=hhuawsx+Vr9wGxze5RH3unQRD9JX4GcgiDtQ/6pD3Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOsPvkC5Nfi86hxZaes1o5yaWmN91Cr2XwnIc20UJf39JFIV28S6tZptc/fVGjRPB/RUxmTZzRm+Vpz7wvt8sZSi4XM45c/ZH/elA4o+3yYwOFHNhJNSsOo87kVx56D7Zj+hUwfN4SeIwXnm6sKV8/Y+V51QtD7EMR74/VY9cwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdxQ5MTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdxQ5MTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D184C113CF;
	Tue, 26 Aug 2025 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218174;
	bh=hhuawsx+Vr9wGxze5RH3unQRD9JX4GcgiDtQ/6pD3Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdxQ5MTdfei0z1M9gWAMGJ8XEtIBOfr0PpJ7Kg03IBfeU8ks4mS3WJ3o8L0p38ehd
	 zytUeO1K98/KaBcP7IjgZt3Ihgb4zblvyHQTvOVrIe9lZzl58Md7SlNpnPoXnUpNz/
	 gbFL/ARwkvRpbxjeVifU5lU2I8p/PIC9uh4aDMhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Pisa <pisa@fel.cvut.cz>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 5.10 404/523] fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()
Date: Tue, 26 Aug 2025 13:10:14 +0200
Message-ID: <20250826110934.425661058@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


