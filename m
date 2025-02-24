Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92CE156F44;
	Mon, 24 Feb 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408709; cv=none; b=YcR5zJSjEA9/4LqTIK1k2LjGKZ3DE6zL8RmHbVRqceAdnAGqQUJkJt6ZzWLpB2h2B3C2XWqbVYfOVIOSC/ceKuaND05jeNy7h5fr3UvJoO3NqB0BTBu//uMr2tFIUZ7fWiOrchQrEumV9MWT3M2099uv0FTyaQW9Wylk91fhnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408709; c=relaxed/simple;
	bh=w4rqf41Ipxpgk//fTQLZB/+ipX34Zvyngrwpp8lF9jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fcll0D5eqq973Ewo+IeY3pxMA1kSRMp/poVveKrKfnv6YbSvvRYiJy6UaCweNiuJqFwlpoEK2+9CLBveBjXw2Evh8hR2AwogzM97pyg5PsMktlXDP5Iizbcs2zxoaHu9ocTAQChM77DQazatM+FSH2fUeTkmd1nT6hhOrkNPaEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdDeMWrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdDeMWrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA2C4CED6;
	Mon, 24 Feb 2025 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408709;
	bh=w4rqf41Ipxpgk//fTQLZB/+ipX34Zvyngrwpp8lF9jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdDeMWrvcmYaP+P96QU41YmZEV/lhT3GgpucUZ7a82n8Y/rqDws2pSPG7DSX5ebBc
	 xwpv/B4I15FatkGu8OAjvPAo2tWuxx4it1L9epnoo3D30AkLA9AVHb8H+kHKnbKLJh
	 +o8ZEZP4E4PMLwtxO1+0upktD5IhpUHeJoA+jH3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 138/154] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Mon, 24 Feb 2025 15:35:37 +0100
Message-ID: <20250224142612.452886952@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit 2b9df00cded911e2ca2cfae5c45082166b24f8aa upstream.

Replace dma_request_channel() with dma_request_chan_by_mask() and use
helper functions to return proper error code instead of fixed -EBUSY.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2904,11 +2904,10 @@ static int cadence_nand_init(struct cdns
 	dma_cap_set(DMA_MEMCPY, mask);
 
 	if (cdns_ctrl->caps1->has_dma) {
-		cdns_ctrl->dmac = dma_request_channel(mask, NULL, NULL);
-		if (!cdns_ctrl->dmac) {
-			dev_err(cdns_ctrl->dev,
-				"Unable to get a DMA channel\n");
-			ret = -EBUSY;
+		cdns_ctrl->dmac = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(cdns_ctrl->dmac)) {
+			ret = dev_err_probe(cdns_ctrl->dev, PTR_ERR(cdns_ctrl->dmac),
+					    "%d: Failed to get a DMA channel\n", ret);
 			goto disable_irq;
 		}
 	}


