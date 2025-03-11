Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C00725E805;
	Tue, 11 Mar 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707605; cv=none; b=ZL8nFEsgk9x/puXKHtXreR843t5DqXibCiGKHbdsLh8fCVeVT4o3oDD2H+hiQQyCPFgUEjo9FDV8DljhXuLZNtsQsW9Ti1OvLdlPvEMeKb0ril6nwuKlJMG89/FGOSAu7yMY1nG4fsyaEzxx+x6+iYsCI+mnZws0Uhw6cyTCyLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707605; c=relaxed/simple;
	bh=7fiCPQVtOxonMoY+fqHOBdWNYPfBxtd9gJ3mwKNriKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAw4u1HtD1OPrDFWn8n63hlecvbTAmbGRzm+x5Fpulabu3YHv8bH3657dK2pLFAxugfMWyL232bJyiG4/Gp/540G0U33LdJE0/w/pt93Y4Te0fu5bwJOSRSEs+aezXUT75mXjLrDpNMkovcalJoWc/R/h0HcDBJ3Eg0p2ZsNZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9AgPI7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9AgPI7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D04C4CEE9;
	Tue, 11 Mar 2025 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707604;
	bh=7fiCPQVtOxonMoY+fqHOBdWNYPfBxtd9gJ3mwKNriKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9AgPI7uGQwgYvjl6xKMekFj40Hw/b6ZRchXmKEAx9iwv3l7/lJ4+D03hLvu57Qip
	 vvhRui8TJCwx6bprt5gXqslI2GgX/Dv4vxrtJI876hVjRLvWy2q2gwfpHeeKl9VJla
	 tjHYa0dwWqemAdDYEB2WzLZi/lZOCCy72FCNJYBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 444/462] mtd: rawnand: cadence: fix unchecked dereference
Date: Tue, 11 Mar 2025 16:01:50 +0100
Message-ID: <20250311145815.868426768@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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


