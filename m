Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702F727701;
	Mon, 24 Feb 2025 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408716; cv=none; b=aZC5d0fyUaeXgFIp/xlkbMuE4nPWbaUSjvDkmE83/TfAnTSSSbGuEGEnrX9Ny0I9ZTotQ96OUgfG1rjqW88m+rBGeft6vl3ZeMbzE/j/id0z4C5t/dj9kzA8Jw1G9wnJvwUoEXlyv5imxVUpyo3PmaKqhmscPho4kZ4YyACIDhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408716; c=relaxed/simple;
	bh=PS5FNoRdgw71CPGyt8QWFJEKbRAGnq3y+7TT3QWlq1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUX7nuE0EwYvDp0U7Lqx9qk331ZVYFsdlXPCRDrLuKhc8UpJZc3eVQKUQnH0U9ODHgK/qql289VUkiTMvnvE9N/h/fjvVozuan2Qjta8qgimOY12/JRlqz+9ysDzmZepBa9m9JBDnehIBU1ngAngC68MGU7oEe6chv0ODkTLaTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alq/R17t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alq/R17t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F85C4CED6;
	Mon, 24 Feb 2025 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408716;
	bh=PS5FNoRdgw71CPGyt8QWFJEKbRAGnq3y+7TT3QWlq1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alq/R17t5Z7y7JH+3SBw9+igUz3iAyTQA9KDZTUgp+QTCgHpro5EvR9cY+EkXrphU
	 Jc9UtBvqrAYmFvL89PbKBakXAHmUqlSTacnNwnEHePhsrEfnuUqISX6RUog0Uybgw1
	 HtIIR1aHAP2ddIQhgZRatWSE8fUGG/Kc73Cwg2WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 140/154] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Mon, 24 Feb 2025 15:35:39 +0100
Message-ID: <20250224142612.531891436@linuxfoundation.org>
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

commit f37d135b42cb484bdecee93f56b9f483214ede78 upstream.

dma_map_single is using physical/bus device (DMA) but dma_unmap_single
is using framework device(NAND controller), which is incorrect.
Fixed dma_unmap_single to use correct physical/bus device.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1863,12 +1863,12 @@ static int cadence_nand_slave_dma_transf
 	dma_async_issue_pending(cdns_ctrl->dmac);
 	wait_for_completion(&finished);
 
-	dma_unmap_single(cdns_ctrl->dev, buf_dma, len, dir);
+	dma_unmap_single(dma_dev->dev, buf_dma, len, dir);
 
 	return 0;
 
 err_unmap:
-	dma_unmap_single(cdns_ctrl->dev, buf_dma, len, dir);
+	dma_unmap_single(dma_dev->dev, buf_dma, len, dir);
 
 err:
 	dev_dbg(cdns_ctrl->dev, "Fall back to CPU I/O\n");


