Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A50144309;
	Tue, 23 Apr 2024 21:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908593; cv=none; b=V/TeNVUl8sfdqcYSfYAh62HyUCpiFh5cPSJnY7veq8EtXfnWrKyeMgzuPUIuNkSIzaNvgvlo5tHlx9nI/Tx5buv82UewHLxe7xPWUiWVyl070m/PceLz7CVOroiKSRzXf3kcq7U+DTRKQdJ3WYe3726QG9+anw0iWPPP+qpUk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908593; c=relaxed/simple;
	bh=CYB5wuLHj+78m9tgHq2LYbB+NA3OgoOEYDpukNdmo9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8ntquA8pAs5PBQmxEhozRGRE9s8Udyj62AM9uw/RluAvZGkVQk6eW790cgE4Yj6998Uel5Wt9A7SBUJalDonxvm4gFV1SZ51b8Tz+E3TvvaXcr6TW5JAJ5Y55ezZccBS/v4g/4Qj5girxO1FFcPrcmT8T4JceUllqV752RSvKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBq6euM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBq6euM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B9C4AF07;
	Tue, 23 Apr 2024 21:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908593;
	bh=CYB5wuLHj+78m9tgHq2LYbB+NA3OgoOEYDpukNdmo9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBq6euM9h4btyH5bvvCh67nKBaGWEGLlQjN3PZJYbUtVBxc9DJF36TLyKGp5LuKav
	 qfU+1zj5ae0exM/XLzQNweFShnomQ/LBJ9HFlSxvg63AiYxovsN3npepU0hfZq6hh3
	 tQmX9CC13ioVMETGyYLKAt6JH21ZPF30ZCKab0xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/158] s390/ism: Properly fix receive message buffer allocation
Date: Tue, 23 Apr 2024 14:38:12 -0700
Message-ID: <20240423213857.567117988@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 83781384a96b95e2b6403d3c8a002b2c89031770 ]

Since [1], dma_alloc_coherent() does not accept requests for GFP_COMP
anymore, even on archs that may be able to fulfill this. Functionality that
relied on the receive buffer being a compound page broke at that point:
The SMC-D protocol, that utilizes the ism device driver, passes receive
buffers to the splice processor in a struct splice_pipe_desc with a
single entry list of struct pages. As the buffer is no longer a compound
page, the splice processor now rejects requests to handle more than a
page worth of data.

Replace dma_alloc_coherent() and allocate a buffer with folio_alloc and
create a DMA map for it with dma_map_page(). Since only receive buffers
on ISM devices use DMA, qualify the mapping as FROM_DEVICE.
Since ISM devices are available on arch s390, only, and on that arch all
DMA is coherent, there is no need to introduce and export some kind of
dma_sync_to_cpu() method to be called by the SMC-D protocol layer.

Analogously, replace dma_free_coherent by a two step dma_unmap_page,
then folio_put to free the receive buffer.

[1] https://lore.kernel.org/all/20221113163535.884299-1-hch@lst.de/

Fixes: c08004eede4b ("s390/ism: don't pass bogus GFP_ flags to dma_alloc_coherent")
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 81aabbfbbe2ca..622a61f8a3b84 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -291,13 +291,16 @@ static int ism_read_local_gid(struct ism_dev *ism)
 static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
-	dma_free_coherent(&ism->pdev->dev, dmb->dmb_len,
-			  dmb->cpu_addr, dmb->dma_addr);
+	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
+		       DMA_FROM_DEVICE);
+	folio_put(virt_to_folio(dmb->cpu_addr));
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
+	struct folio *folio;
 	unsigned long bit;
+	int rc;
 
 	if (PAGE_ALIGN(dmb->dmb_len) > dma_get_max_seg_size(&ism->pdev->dev))
 		return -EINVAL;
@@ -314,14 +317,30 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	    test_and_set_bit(dmb->sba_idx, ism->sba_bitmap))
 		return -EINVAL;
 
-	dmb->cpu_addr = dma_alloc_coherent(&ism->pdev->dev, dmb->dmb_len,
-					   &dmb->dma_addr,
-					   GFP_KERNEL | __GFP_NOWARN |
-					   __GFP_NOMEMALLOC | __GFP_NORETRY);
-	if (!dmb->cpu_addr)
-		clear_bit(dmb->sba_idx, ism->sba_bitmap);
+	folio = folio_alloc(GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC |
+			    __GFP_NORETRY, get_order(dmb->dmb_len));
 
-	return dmb->cpu_addr ? 0 : -ENOMEM;
+	if (!folio) {
+		rc = -ENOMEM;
+		goto out_bit;
+	}
+
+	dmb->cpu_addr = folio_address(folio);
+	dmb->dma_addr = dma_map_page(&ism->pdev->dev,
+				     virt_to_page(dmb->cpu_addr), 0,
+				     dmb->dmb_len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ism->pdev->dev, dmb->dma_addr)) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	kfree(dmb->cpu_addr);
+out_bit:
+	clear_bit(dmb->sba_idx, ism->sba_bitmap);
+	return rc;
 }
 
 int ism_register_dmb(struct ism_dev *ism, struct ism_dmb *dmb,
-- 
2.43.0



