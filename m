Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63472309B0;
	Mon, 10 Mar 2025 18:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630999; cv=none; b=O4ffjbpjt5+SDvUTTslFlJkrpkecIm24O7LkY+4DA0O+ef6QCaIZlLvt0x6kCJKWFnbeimT23+zi2z03zeSPhdKspySQH14JaRgkdQ9eWrHGK/r/bsmtynbJT2QW12JLfHgrGVBa1AJH5zmtNjl6Bb+fXzlq3G9Xgn1BwhzLbSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630999; c=relaxed/simple;
	bh=8G6CWdWBASiZfj32eYMKas5ENan6TKcDWfaU2inrC6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdbLwZzPJqx1n9f2YO3bT200PhkEJFJerSebemn+eCqEcKi8p0bJo87ahKcu5rmK25FKgO9fcqOZSk7dRAc/fH057gu3Ar0qUfGl4nM8/TmlEnOvl30bafA4EJppvR4RMZg24CBdgkYG+LMEdxlJYSeYhQkr6S223nAbC2LEtCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty5OKpem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty5OKpem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF22C4CEE5;
	Mon, 10 Mar 2025 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630999;
	bh=8G6CWdWBASiZfj32eYMKas5ENan6TKcDWfaU2inrC6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty5OKpemikTPWp0oLhO4S09jBlrfprrC4Ukymw+tqJhj9s2Bn3WnGbLOZxKQwhHvb
	 CIamKTaRgrT+2VO6fL9DAIokFktJDB3B0D4dzt8K1iULRrx6YfTO9P4RmdmlYml+ys
	 Ke4+qZsKEt0Hi7JaoXBvjjzhqjpOt0bWWp5egPEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 608/620] mtd: rawnand: cadence: fix unchecked dereference
Date: Mon, 10 Mar 2025 18:07:34 +0100
Message-ID: <20250310170609.535436947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit 60255f3704fde70ed3c4d62f919aa4b46f841f70 upstream.

Add NULL check before variable dereference to fix static checker warning.

Fixes: d76d22b5096c ("mtd: rawnand: cadence: use dma_map_resource for sdma address")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/e448a22c-bada-448d-9167-7af71305130d@stanley.mountain/
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2934,8 +2934,10 @@ free_buf_desc:
 static void cadence_nand_remove(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	cadence_nand_chips_cleanup(cdns_ctrl);
-	dma_unmap_resource(cdns_ctrl->dmac->device->dev, cdns_ctrl->io.iova_dma,
-			   cdns_ctrl->io.size, DMA_BIDIRECTIONAL, 0);
+	if (cdns_ctrl->dmac)
+		dma_unmap_resource(cdns_ctrl->dmac->device->dev,
+				   cdns_ctrl->io.iova_dma, cdns_ctrl->io.size,
+				   DMA_BIDIRECTIONAL, 0);
 	cadence_nand_irq_cleanup(cdns_ctrl->irq, cdns_ctrl);
 	kfree(cdns_ctrl->buf);
 	dma_free_coherent(cdns_ctrl->dev, sizeof(struct cadence_nand_cdma_desc),


