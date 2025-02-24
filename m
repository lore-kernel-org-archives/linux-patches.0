Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD762571CB;
	Mon, 24 Feb 2025 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409199; cv=none; b=l1smOE/z9f7Q3BXuq8Rxs8dhCuNlG5PbWL/52C8uL559EywqQYVVKPRGCfozydyGanSQ8XvublKtVw9y24usQErx4sqtYr7vDAFWuhkGCcqgJZML43ZHNHKQQQXQyiG44oKCNED/KAyK8+mCKM5agWA0rJ7lt4PlHgBfusZxzTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409199; c=relaxed/simple;
	bh=GJO1+gHKZiqoG9gasoqjbgmiemLX5rf1UiFiC+Ehtkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9kYGu5D0xG2xMPWafr3F58RAFr/zhiM5DBd8VeOuH4UvIrEn/Y9+PZU+bSMFI9OTKNMJ+we1VPCnnyrruMhbSZlU+cYA+GtUHGbYNxJv+CrOUS2OOsaKqhTrXMvl+rgt6aQhAPjYPtECYRh+MBPQVyMyclrBWm5pPxwMORE+Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUx3nzaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUx3nzaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0EDC4CED6;
	Mon, 24 Feb 2025 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409198;
	bh=GJO1+gHKZiqoG9gasoqjbgmiemLX5rf1UiFiC+Ehtkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUx3nzaqKV6QJVVgfhx5b2mxOFncBY69eHoQQ0OlOJVViYFbbAwO8R9Ez+IZ+j2w9
	 1z/qLrp2KvHt3z3al1zK5GZpxV46ZZOk7/B4fzIXwsa8xXAeiYCnG4EBHA3oP9CcWA
	 KWj4lL1Qz9qc0DM6csgtxB/s5EATR7OUHMmAATPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 124/138] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Mon, 24 Feb 2025 15:35:54 +0100
Message-ID: <20250224142609.345497894@linuxfoundation.org>
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


