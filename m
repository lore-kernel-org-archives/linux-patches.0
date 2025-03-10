Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6B1B395F;
	Mon, 10 Mar 2025 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630638; cv=none; b=Xu28fFLEk2R549k0LaH8cgerx8lDIfZWUtc1T2oZ4FGVZHQHeriClsT47VQRsSNsdNGA2lkRAdP13WDCTbu3vNa4Y0vdgcu16Dwy8cNiEf0j5HohiOvVmUjBxaBFO/RoGLfScR1njs8PgLxVDGaF3VZOZ4Q0ju/m5Ils9TLxjQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630638; c=relaxed/simple;
	bh=3IvJimSHoWp8bB0fEdY0rJWWhDy4REMKjdI1wRZKuGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTQwcyulmToM8cLJYelMH5eOlmTXwxcVT0OZlP27IYdy4sw5fShLV6l3ukdbcTZh/G9sccSTCCG4UDthXortj6IJoyC19pBSFds0Rv+OeNIPWayrpVi+AHrDjzwPaPxi2ed54iuLgDPbyqBKsUw4mfhuLmKHQ0PFXj03dlkbqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEtbk602; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEtbk602"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E35C4CEE5;
	Mon, 10 Mar 2025 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630638;
	bh=3IvJimSHoWp8bB0fEdY0rJWWhDy4REMKjdI1wRZKuGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEtbk6024rF1OGBh8q8kK8Haz6BUr/zjpozu2pvNrUCzgpMibx5PNAEUXwPkP6Rwv
	 rlmvcBQUsEwwUSgiWJ7MHkzeCNJfj+aj1uAOBkwzo+AYo/Io+3TDzwo1wMruMIqG8Z
	 1u0Vfv0TOD0EVgt1//AWldEdjD3AZP2pB9SeSris=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 482/620] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Mon, 10 Mar 2025 18:05:28 +0100
Message-ID: <20250310170604.598706516@linuxfoundation.org>
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
@@ -2866,11 +2866,10 @@ static int cadence_nand_init(struct cdns
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


