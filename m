Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E2C22FF40;
	Mon, 10 Mar 2025 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630644; cv=none; b=a5hx43DBTV1I4tTMFAkh5NN1vqENpdnGXnBq5YYWdPRhLRas5Yl9m39sEpo8ByGhgpovfvPmthKBnq8CduzaaZKRFdYPF/PDvCC3Tbhw0PSnX6pKAljybjOrDyz35b8oZI6briw5D7/yt9OKcq69aOmBJ2qpO6vQPV8+MfCB/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630644; c=relaxed/simple;
	bh=WCk8JG62K8dgjKlbA43qYoAc1FaTqdM3LtlUxip8Ui0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSltMDlp/5odxYOPqKvk5DdEsLReTcjHVlJvYkWjU+qbY7PjLVsyAZ8mhuPUpDB7FrF8aO5N7DwSj2KmxbBhbPXlqSk1rB+9a3xdzvsPIOhBbohJyCKygHS3N+LKeIbtqYPIcNBb8dH82Eo2gEv9DjI5wEfpka+4gXaGA/gu8Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyVCNFIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyVCNFIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693B0C4CEE5;
	Mon, 10 Mar 2025 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630643;
	bh=WCk8JG62K8dgjKlbA43qYoAc1FaTqdM3LtlUxip8Ui0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyVCNFIe08o1zzExi8/Jkz2MgxCydK6qleZSq0orfSNLankaLB/hL7smJvgs7qcXY
	 FofwNCwSFTjw23xELEVKDPy1xoDokOZfCkvr4vQaa0eW3wk7Jipofz45IguGSuHd5J
	 YHGwslTu+rIyCMZPbC4suLEXnvgn5p3uwNWsX9Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 484/620] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Mon, 10 Mar 2025 18:05:30 +0100
Message-ID: <20250310170604.676419104@linuxfoundation.org>
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


