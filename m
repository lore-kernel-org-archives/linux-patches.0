Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98E26F2A7;
	Thu, 27 Nov 2025 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254891; cv=none; b=R0xea9m/bbeSLsVjXM2Run8tCibQb/6W+9rbfXrdGBiGnWj2Uju/IaYCNY5nQJZ4tJvUcB2YPbyqcwvV48UIKC1MQHuS4WkVkC/2t6m8kDSmbZ0ejTaCRWn39Xw0OY9DTdd9bW222y6gZH5pzrgkbnknbhFx4v/1XImW/r+jcpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254891; c=relaxed/simple;
	bh=eeVjBxeO/iNBKme85sCP3RtYI9HBIIdYUX+uTf+wDdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd5MmRmPeyzI4hfy+aYBopjeRi8Il7NsZxD3MRPtuQqAGNYQYLX6dKMiLO8uUHl2KHUv0/VGJpTJB3Pte95pXc1FE15PSZJrOYuT4UKr8wMSekF3cEXdTQEZ5oN2eiquJd80/XHBwHx+PHgW0DOKWVzqL68LaExo0fGroCwXn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a02NKfr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a02NKfr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8947C4CEF8;
	Thu, 27 Nov 2025 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254891;
	bh=eeVjBxeO/iNBKme85sCP3RtYI9HBIIdYUX+uTf+wDdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a02NKfr7Iobe/UXh+YuBH1UXeumgiCvUzy6TLhNeIl9F82lTEkV8G4ARyanC0pcHC
	 T8LlgVzyRQGtHoTeiCNQCrpNL+cZasN71bAWuao2yrO82evSuwUuEoWKqF5KXJS0d0
	 7N8rZHJE+oF+oZ0ZvMKn3Quslk12wqcuA1wQTdrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 03/86] mtd: rawnand: cadence: fix DMA device NULL pointer dereference
Date: Thu, 27 Nov 2025 15:45:19 +0100
Message-ID: <20251127144027.931171201@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit 5c56bf214af85ca042bf97f8584aab2151035840 upstream.

The DMA device pointer `dma_dev` was being dereferenced before ensuring
that `cdns_ctrl->dmac` is properly initialized.

Move the assignment of `dma_dev` after successfully acquiring the DMA
channel to ensure the pointer is valid before use.

Fixes: d76d22b5096c ("mtd: rawnand: cadence: use dma_map_resource for sdma address")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2876,7 +2876,7 @@ cadence_nand_irq_cleanup(int irqnum, str
 static int cadence_nand_init(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	dma_cap_mask_t mask;
-	struct dma_device *dma_dev = cdns_ctrl->dmac->device;
+	struct dma_device *dma_dev;
 	int ret;
 
 	cdns_ctrl->cdma_desc = dma_alloc_coherent(cdns_ctrl->dev,
@@ -2920,6 +2920,7 @@ static int cadence_nand_init(struct cdns
 		}
 	}
 
+	dma_dev = cdns_ctrl->dmac->device;
 	cdns_ctrl->io.iova_dma = dma_map_resource(dma_dev->dev, cdns_ctrl->io.dma,
 						  cdns_ctrl->io.size,
 						  DMA_BIDIRECTIONAL, 0);


