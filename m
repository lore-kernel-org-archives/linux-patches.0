Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB27F2629F;
	Mon, 24 Feb 2025 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408187; cv=none; b=slHXYFax2ilHdafyQGYBt3HBMwP18DWiVJDDOqtVjVFZFvx35uaC2G0tZJXRrZiBax9zjsv45F09nxyZqALWwgvQ17J6K8jrBDRN16nx1Q9c3DlChwTyPuJvPeh+sVmP6+w2DO+pUnJZO/nukDBCGOJeunlrzo5Rrp7qb7rfoQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408187; c=relaxed/simple;
	bh=+M5YfdWEhXlsurBmpzciMDYSOMRfCi6+dtbrpybF62g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD8h03eROx1MDR4JwW4OqyWGISHMK0YHYZT3PHfYaoWpOdkbjvXPl4Zs1veY5mkd+RsBk4OJVRaklgwdctQ+xyFeDkDaxL0RSCAIg4Ok6nJQABCBGu+eibJMvzAzD5czSPakHPr/RP4t+6qQjrNRLpuIEexqj3L9nbKls1Y7CBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aSoAxfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aSoAxfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2E4C4CEF0;
	Mon, 24 Feb 2025 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408187;
	bh=+M5YfdWEhXlsurBmpzciMDYSOMRfCi6+dtbrpybF62g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aSoAxfQhkvhSewJdwI9SX67BAwYG9Y7Z+dE7ep1Xt9KFWNDZQqNrFH2mBW7Yfvn9
	 zW/QxpD2RT/edEkIIBenJsc9/n6rlNfBzhfKKKle22ILQpcdm4E6jmZ1QVySNRJOIm
	 OWvURVbTX9csHnQ6wZuAjdGy1nxZlljyIjhoo1vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 125/140] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Mon, 24 Feb 2025 15:35:24 +0100
Message-ID: <20250224142607.921139132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
@@ -2909,11 +2909,10 @@ static int cadence_nand_init(struct cdns
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


