Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E7A25C6F9;
	Tue, 11 Mar 2025 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707395; cv=none; b=KXsS3XRW73K3j2S4PPRdN7OqDoky68U4ChVacUfiSLd9Ho+Ug+RMmE3cWus+V4yJZEBS17viC/BBQSu0PKz9mXxuOuQv+mMKwW79AgNj9IQqLZ+5nfqWQcc5v/7b82/rb5nV42k2l0v5n/paX3AfAnvVAvVYZRAsDlDN2gFzKns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707395; c=relaxed/simple;
	bh=m0/p2BcFXyaHGIhtI8tFVkOqqxalv5aq1klAL4S67ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc7LuJ77RNEefaCMhNv+Jg5P2A7fULAt8fFuFmpsGgE0BXWt0bHc47fPSolPhekn34zQHz9fU9sBpmExbuGMljn2bQs2h8Vx4KHV08CnWaoVHuk87gBOJirwAuG+9Gk3eLODQTCKWJoJF0YhYi/V2wDfW3ujIfG/UrnB39Oocvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYq8pSQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYq8pSQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3193C4CEE9;
	Tue, 11 Mar 2025 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707395;
	bh=m0/p2BcFXyaHGIhtI8tFVkOqqxalv5aq1klAL4S67ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYq8pSQJtXKeTeNsXhiFBHq09z0PC/7l9p8fD4i1f0EtqcX+fWlUzAp0h4Tg/vDDx
	 dmopMWW6CAgwaLGQLcEpGxQG5xno41PTqVaeapPxOVg5NZGUQaqohAV2SGnHyubiSh
	 B7oeTZbg1WDt2OaviHUjgurQI3rlXfomwYqAaAGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 347/462] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Tue, 11 Mar 2025 16:00:13 +0100
Message-ID: <20250311145812.069558238@linuxfoundation.org>
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


