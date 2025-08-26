Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FE6227E82;
	Tue, 26 Aug 2025 13:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213617; cv=none; b=oS8w1cDDiRIIRd4v8eRoiylwzHjj0zLMlwELYBF9arMtcynMlvUSDS0BD8DbllG/D0o/Mw6UIJisPGftonjnvuKnHwml4trQ5unWcx5m9UCyB/mBAPVBUfX5Z0w5Al8ilkTvaiETY6hXi01DXiujykYRd/lWjirvFlfUb3PfSuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213617; c=relaxed/simple;
	bh=a2OTygTNzWHovHMGC0wX5Yi4C/duJ2j76HuH420FCHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvZVSBNJ0+S6CIyO2QXgZedqIYuHP4rgir0ICwO+nt6WOUhUg69xzUSMyo9lbqDdDjdReqP2g2SKkPMN/XGhkfYmCVWSAuY86HhPVoUS/0OK5iWkclP4AyzRBsvnYsIL5y00GjvixJZD5axfnHZ+hMqNULusXYwujTiToyn2dJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsTAsfuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsTAsfuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A22C4CEF1;
	Tue, 26 Aug 2025 13:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213617;
	bh=a2OTygTNzWHovHMGC0wX5Yi4C/duJ2j76HuH420FCHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsTAsfuk12a4DD6LnqysHea+TomRmgmNdYEAWoK2Zl7YwhisD0O1QzsRDK7ecEFcj
	 IJC5FzSCsH1V0C903QhR5bwhj3WGrZVsTZNObSmlUd1wKTOT3SuNTWkIiYTdI2RONu
	 hF9snOGW4dVcqZpGwupmg+/DC4akQMFaVRvTJUjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 382/587] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:08:51 +0200
Message-ID: <20250826111002.621564232@linuxfoundation.org>
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
@@ -503,6 +503,8 @@ static int dma_xfer(struct fsmc_nand_dat
 
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
+	if (dma_mapping_error(dma_dev->dev, dma_addr))
+		return -EINVAL;
 
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;


