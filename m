Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86798296BD1;
	Thu, 27 Nov 2025 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255163; cv=none; b=d3B6OLOkgf+yDRSZCBSAIMmtvJuwqDop1mQO/jNTkJ1SJx5keLx+SHFpQbVtlcA/3krGNp9/zCZxPAXHJ+gM6FIuiad3uBPG0sXDDF1dUaF84wBQixmUU9VLPo6DCSyZwZxfBfeEJUpY2p1OkMOgjnMPzdVVDeSR3OBhtwnGiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255163; c=relaxed/simple;
	bh=tAEDfNE2/h0clKtpWAM7SGmIWrd8oMqLcJ18agMMZkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iznCb/z2FNaioPYeYbOa2ojAjEbQ0KQ6fO2jhfNdHvVR1F4Vw694Gr/cJW4jzW4IpOUdoZI/9PnV6VpG2rDWcDYzx1w/boIKOMYKiF8SNs7Pj6t001ffakqVNigEhAYnR3SumOf4qJ5+x0GIJNfdgcgPFwl8oxBieMOr0Yni1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oC/ZlI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oC/ZlI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F27C4CEF8;
	Thu, 27 Nov 2025 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255163;
	bh=tAEDfNE2/h0clKtpWAM7SGmIWrd8oMqLcJ18agMMZkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oC/ZlI5pKXSszpYxitmt2505LxiA4sigFppkSFw4UZolV7dAdOVP1wMHzC08Bk3Y
	 TSyhJelmdzBTYbVIvuvbCslO4u13Mz9h7+KMC+sxHXb0pcn8a4amzdtAXF5FMYb0li
	 jipqaNGqYtsJT+r0nLgjq4532Gd3esyU71XTLejI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 009/112] mtd: rawnand: cadence: fix DMA device NULL pointer dereference
Date: Thu, 27 Nov 2025 15:45:11 +0100
Message-ID: <20251127144033.059222498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2871,7 +2871,7 @@ cadence_nand_irq_cleanup(int irqnum, str
 static int cadence_nand_init(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	dma_cap_mask_t mask;
-	struct dma_device *dma_dev = cdns_ctrl->dmac->device;
+	struct dma_device *dma_dev;
 	int ret;
 
 	cdns_ctrl->cdma_desc = dma_alloc_coherent(cdns_ctrl->dev,
@@ -2915,6 +2915,7 @@ static int cadence_nand_init(struct cdns
 		}
 	}
 
+	dma_dev = cdns_ctrl->dmac->device;
 	cdns_ctrl->io.iova_dma = dma_map_resource(dma_dev->dev, cdns_ctrl->io.dma,
 						  cdns_ctrl->io.size,
 						  DMA_BIDIRECTIONAL, 0);


