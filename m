Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228032AAB7;
	Wed,  3 Dec 2025 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778228; cv=none; b=smjvImaWiGEWKb+Y39197HSAsPL/9P0EFYh7Xcla7f/RBfPgZVOX4zf7xcS2Q5JKS1r3S8Xarhjciknl1AYuj9yEm4l8hRlCxSXogIQPaZtrZzTwWwHgthfY23Prh4IHTGFWDd2VXT5b5gnaPLJP0PI32EtafEUZSl7L853JKGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778228; c=relaxed/simple;
	bh=aj2mGbvBSmaWNO29pElpBfJ0dgA0hOcj3Rnt22OuU+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V94ozAHCuaqpaQ2ieugPtxSxFsncK9B4wwAupIKo2Hf7PmP1o3IWTwYZ33D7c3uiY59QEoUiaagaIgx/OIhwSwFtBDLXwQruy9uDsEcdyTMkcwGI/fvNXu8Y8EzZ7yt1BgnCdUq9x5q+V4H1ezpPe4v8kmKuneXLGjBFQ878gj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrNHMwD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrNHMwD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27394C4CEF5;
	Wed,  3 Dec 2025 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778228;
	bh=aj2mGbvBSmaWNO29pElpBfJ0dgA0hOcj3Rnt22OuU+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrNHMwD42Z9qoUu6a29PXtr1KySyV5Vj0q4IgvkQmAVzYRQVASW55DZQUl1D/2JEM
	 hgYHn+E47+k4r1fyz5mkwHPnuFfc26JIpbJ0h1YvJ+7L0jjZIQoP//+AMbJu/jqtnG
	 hB5LfyW4X722rcQAjVggBruaWOoUIvQHCbqzl4SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 283/392] mtd: rawnand: cadence: fix DMA device NULL pointer dereference
Date: Wed,  3 Dec 2025 16:27:13 +0100
Message-ID: <20251203152424.572651627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2833,7 +2833,7 @@ cadence_nand_irq_cleanup(int irqnum, str
 static int cadence_nand_init(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	dma_cap_mask_t mask;
-	struct dma_device *dma_dev = cdns_ctrl->dmac->device;
+	struct dma_device *dma_dev;
 	int ret;
 
 	cdns_ctrl->cdma_desc = dma_alloc_coherent(cdns_ctrl->dev,
@@ -2877,6 +2877,7 @@ static int cadence_nand_init(struct cdns
 		}
 	}
 
+	dma_dev = cdns_ctrl->dmac->device;
 	cdns_ctrl->io.iova_dma = dma_map_resource(dma_dev->dev, cdns_ctrl->io.dma,
 						  cdns_ctrl->io.size,
 						  DMA_BIDIRECTIONAL, 0);


