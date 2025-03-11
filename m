Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D03C0B;
	Tue, 11 Mar 2025 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707412; cv=none; b=iHS784jlLYeliMM/p4zf6myGyup29SqurWC5DZYksprNI1Tz39qAsLXHWWs7Q1FI1heKMM2b6OmAjeUTWwWqSAC6/86m19EcL/NHbcTm8inNkeISLHBk/Ch/2gmZBolqafO8wIL4wcPEkDecsMyfwSJne8NFOV005chbP6Q5Uog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707412; c=relaxed/simple;
	bh=+jsU3C3OHtxnQ6tpIsQGWDUgeDpAuALKx944l9Auozk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs0stLeU3GXJHGBFlWnXxcuFXSVhlq1cCI8A6gNh/jeumh3F/z8F1ibYSCJDv0OgwuEpNsrkZFaLwoPxz7E8zl9Wj2s2ByJU43Y3gR8tBuZEuN9+OqFKlJBQTXdtpm8CQq5TrEvclGf/saqd6wBb5C3+I5hLUy42ahZ0YnkLPPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x53jUOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x53jUOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D515C4CEE9;
	Tue, 11 Mar 2025 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707412;
	bh=+jsU3C3OHtxnQ6tpIsQGWDUgeDpAuALKx944l9Auozk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x53jUOLZ8TxUbYEggTd/rt9PdPDiKoPtUizY8zDA365Y9e7KcAjZC4BS0z0Q8n38
	 LKGEDHTg9WGrQY6j98qyVkR0iSpSmjwXUHSDtntJU//5ZztMrGcPcJtJ4GZ85NI0mF
	 KREMajAU771F5FzHbu36cKIekw9jfu4tv59anT2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 349/462] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Tue, 11 Mar 2025 16:00:15 +0100
Message-ID: <20250311145812.146418189@linuxfoundation.org>
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
@@ -1858,12 +1858,12 @@ static int cadence_nand_slave_dma_transf
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


