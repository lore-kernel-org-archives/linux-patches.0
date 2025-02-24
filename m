Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96106156F44;
	Mon, 24 Feb 2025 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409202; cv=none; b=TUMrT9m9ixXdZqXVJWwNva8oBu6hJRs7FqCNufb2L41y2hdQgEi9aRd9lXOtbzVaGgi+GTiYZsfd5QDjWKne48uSOPdTrrBcwYtXknxnCuobylwj5rrbAz0aA0ZTjWGMQbYxP3KkqCt7YEdpqa7YkIyCf5kNwy9sI2GjNn4xbfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409202; c=relaxed/simple;
	bh=xlbtDdxVpXzIfTnrWBDjC64jl+1fMZvP+HTNJtLv+Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLW5DoUjemhxy0miW49wUzd7dDXpK3bNHqQyf9XF/vEFjK0GQXst8GvMbvbcgHI8zSeAewPWnTPek2A1xMvsXZEcEu29NFSacnxAonJXwMUzSQyCjiKKksbhQCus0QgCTBO4PxAElNDlkb9c2Kah5bkKdDZPd0tC7sJtqMR7cbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEaX3CoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEaX3CoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C08C4CED6;
	Mon, 24 Feb 2025 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409202;
	bh=xlbtDdxVpXzIfTnrWBDjC64jl+1fMZvP+HTNJtLv+Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEaX3CoQTilL6zmvRB1V+B9D7bduq1ggr8bQmd6wzdBSjDDMbEdfFoGG7htvc+5ik
	 4XqHXvxgBDrHbbvQRV9Dp+G9IyoeXFsaNKzrEhkC/KxzqNb8Q2NK22rR6zccmfQY2f
	 8qQe7LdJNG1Us3tLvlitGOtylhmcIySc2OnreIb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 125/138] mtd: rawnand: cadence: use dma_map_resource for sdma address
Date: Mon, 24 Feb 2025 15:35:55 +0100
Message-ID: <20250224142609.384844721@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit d76d22b5096c5b05208fd982b153b3f182350b19 upstream.

Remap the slave DMA I/O resources to enhance driver portability.
Using a physical address causes DMA translation failure when the
ARM SMMU is enabled.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |   29 +++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -471,6 +471,8 @@ struct cdns_nand_ctrl {
 	struct {
 		void __iomem *virt;
 		dma_addr_t dma;
+		dma_addr_t iova_dma;
+		u32 size;
 	} io;
 
 	int irq;
@@ -1835,11 +1837,11 @@ static int cadence_nand_slave_dma_transf
 	}
 
 	if (dir == DMA_FROM_DEVICE) {
-		src_dma = cdns_ctrl->io.dma;
+		src_dma = cdns_ctrl->io.iova_dma;
 		dst_dma = buf_dma;
 	} else {
 		src_dma = buf_dma;
-		dst_dma = cdns_ctrl->io.dma;
+		dst_dma = cdns_ctrl->io.iova_dma;
 	}
 
 	tx = dmaengine_prep_dma_memcpy(cdns_ctrl->dmac, dst_dma, src_dma, len,
@@ -2869,6 +2871,7 @@ cadence_nand_irq_cleanup(int irqnum, str
 static int cadence_nand_init(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	dma_cap_mask_t mask;
+	struct dma_device *dma_dev = cdns_ctrl->dmac->device;
 	int ret;
 
 	cdns_ctrl->cdma_desc = dma_alloc_coherent(cdns_ctrl->dev,
@@ -2912,6 +2915,16 @@ static int cadence_nand_init(struct cdns
 		}
 	}
 
+	cdns_ctrl->io.iova_dma = dma_map_resource(dma_dev->dev, cdns_ctrl->io.dma,
+						  cdns_ctrl->io.size,
+						  DMA_BIDIRECTIONAL, 0);
+
+	ret = dma_mapping_error(dma_dev->dev, cdns_ctrl->io.iova_dma);
+	if (ret) {
+		dev_err(cdns_ctrl->dev, "Failed to map I/O resource to DMA\n");
+		goto dma_release_chnl;
+	}
+
 	nand_controller_init(&cdns_ctrl->controller);
 	INIT_LIST_HEAD(&cdns_ctrl->chips);
 
@@ -2922,18 +2935,22 @@ static int cadence_nand_init(struct cdns
 	if (ret) {
 		dev_err(cdns_ctrl->dev, "Failed to register MTD: %d\n",
 			ret);
-		goto dma_release_chnl;
+		goto unmap_dma_resource;
 	}
 
 	kfree(cdns_ctrl->buf);
 	cdns_ctrl->buf = kzalloc(cdns_ctrl->buf_size, GFP_KERNEL);
 	if (!cdns_ctrl->buf) {
 		ret = -ENOMEM;
-		goto dma_release_chnl;
+		goto unmap_dma_resource;
 	}
 
 	return 0;
 
+unmap_dma_resource:
+	dma_unmap_resource(dma_dev->dev, cdns_ctrl->io.iova_dma,
+			   cdns_ctrl->io.size, DMA_BIDIRECTIONAL, 0);
+
 dma_release_chnl:
 	if (cdns_ctrl->dmac)
 		dma_release_channel(cdns_ctrl->dmac);
@@ -2955,6 +2972,8 @@ free_buf_desc:
 static void cadence_nand_remove(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	cadence_nand_chips_cleanup(cdns_ctrl);
+	dma_unmap_resource(cdns_ctrl->dmac->device->dev, cdns_ctrl->io.iova_dma,
+			   cdns_ctrl->io.size, DMA_BIDIRECTIONAL, 0);
 	cadence_nand_irq_cleanup(cdns_ctrl->irq, cdns_ctrl);
 	kfree(cdns_ctrl->buf);
 	dma_free_coherent(cdns_ctrl->dev, sizeof(struct cadence_nand_cdma_desc),
@@ -3019,7 +3038,9 @@ static int cadence_nand_dt_probe(struct
 	cdns_ctrl->io.virt = devm_platform_get_and_ioremap_resource(ofdev, 1, &res);
 	if (IS_ERR(cdns_ctrl->io.virt))
 		return PTR_ERR(cdns_ctrl->io.virt);
+
 	cdns_ctrl->io.dma = res->start;
+	cdns_ctrl->io.size = resource_size(res);
 
 	dt->clk = devm_clk_get(cdns_ctrl->dev, "nf_clk");
 	if (IS_ERR(dt->clk))


