Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5EC352087;
	Tue, 26 Aug 2025 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218128; cv=none; b=LiIF4+MTy2GkXiE+BTseY6ih1Si7ehlvu7nFpXTM70k1w6pj3CwMTCUAR9RzCD8pozChFQCxzbr8itooeysiZ3YBRBmaH95D6W9ZrKXQwCCQq4GehCfNNK0pyq2FCK57fGfiFPjuM9KkxmEwPVMKU4vyX2Bm1AiOILD7aYZ7+pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218128; c=relaxed/simple;
	bh=TIioFO/Pv/U1feqgaSu3j3AmzntXSf0WdudFj0N77Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo88+yRwsjuik0GNfRcfC8/YLKOZaea4fLWIg+JBkUnpOEl6lBEmn9aVGvK6rrzPZZHuKYBdziOIxWUGFpnUjRvQ/SHHkWeV2AHwLvn0mmnueXVTKgVCLOILN8DSTyKKbe8W9gAk7iIWkO0oOozgH70sz1iNSsL1LqnCXYzQHcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbQPpL+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbQPpL+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656FCC4CEF1;
	Tue, 26 Aug 2025 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218127;
	bh=TIioFO/Pv/U1feqgaSu3j3AmzntXSf0WdudFj0N77Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbQPpL+1cI0+IhLsVyWt6ihnRGc8N/PG1Oz80uhhwAJddYGFuwsg2hJ2IWMtKBqD7
	 yXR/dTMZ8ZiP1p7TfcIP5UrRvTyvCLQpSE6LtSNSEmW32gKrMZEB9RCVjq7m7bAU1u
	 97BcXhzyF2C3nD7RSPXkfDoWaXsvXIUlVqmrjVMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 372/523] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:09:42 +0200
Message-ID: <20250826110933.642820950@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 6c4dab38431fee3d39a841d66ba6f2890b31b005 upstream.

The DMA map functions can fail and should be tested for errors.

Fixes: 4774fb0a48aa ("mtd: nand/fsmc: Add DMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702065806.20983-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -492,6 +492,8 @@ static int dma_xfer(struct fsmc_nand_dat
 
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
+	if (dma_mapping_error(dma_dev->dev, dma_addr))
+		return -EINVAL;
 
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;


