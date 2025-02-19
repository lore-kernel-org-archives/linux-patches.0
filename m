Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E1B1DF733;
	Wed, 19 Feb 2025 09:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956508; cv=none; b=cMIvZ4g2HjuB8UXMPY/cul8UaM4Muu6P+0BUzXUMsSLHl09daeCdxcT0JGu6zmPIe7kI0DwyQIM7cNPga9WbcX5xnhUJ7JH0n2f7SzdlkhRpJMlPmpMEvd4dZ50W9ivsWbBl6A4e64Md0ERWqUDWOgx7/SpRGJuE7T+dERLyK0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956508; c=relaxed/simple;
	bh=0w/cqrbppXSlOg/FPB5ua0T0Ka7rvPdSy9tPKa4xFEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQwnK2/OjIjDPc4pldUDwSIWyY0hDhvWLa+3rjIyGtt+Wuj3VT6LQ8FMdHp5SzqrkJmDoEjDq1E1qII4nqvHaXp4vI+k6kwOaSLX9DQbCV9g1eBYzw7qoRAFuoTap6XjYHunRiyF0nC+LWgFA/8Y1ZAz5UBUlYwW+a6c4OD7o1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B16SC6NN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B16SC6NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620BFC4CEE6;
	Wed, 19 Feb 2025 09:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956508;
	bh=0w/cqrbppXSlOg/FPB5ua0T0Ka7rvPdSy9tPKa4xFEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B16SC6NN6/LLT/B3pyqcX7sKIDOR+eHCB7Fpj+CcjpAI+GxokpDnDhTLdTpqJ/cIV
	 gdWwDS2A3HOOQ+yPdwx0M+2vWdkYJgnMhU6dkQrX3r3SnDp3X7ejcqdJiYfErS1c0C
	 w2ZBSs5tt4hlZcZh2AbHwIi/F+DQgpYoPOFh5tbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/578] PCI: epf-test: Simplify DMA support checks
Date: Wed, 19 Feb 2025 09:23:26 +0100
Message-ID: <20250219082700.908684317@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 2566cbea69ab8dad4996ab4b4840fd952e62e5b4 ]

There is no need to have each read, write and copy test functions check
for the FLAG_USE_DMA flag against the DMA support status indicated by
epf_test->dma_supported. Move this test to the command handler function
pci_epf_test_cmd_handler() to check once for all cases.

Link: https://lore.kernel.org/r/20230415023542.77601-13-dlemoal@kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Stable-dep-of: 235c2b197a8d ("PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 45 +++++++------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index be10d7b976e94..950fe67f2d3cc 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -328,7 +328,6 @@ static void pci_epf_test_print_rate(const char *ops, u64 size,
 static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 {
 	int ret;
-	bool use_dma;
 	void __iomem *src_addr;
 	void __iomem *dst_addr;
 	phys_addr_t src_phys_addr;
@@ -373,14 +372,7 @@ static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 	}
 
 	ktime_get_ts64(&start);
-	use_dma = !!(reg->flags & FLAG_USE_DMA);
-	if (use_dma) {
-		if (!epf_test->dma_supported) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
-			ret = -EINVAL;
-			goto err_map_addr;
-		}
-
+	if (reg->flags & FLAG_USE_DMA) {
 		if (epf_test->dma_private) {
 			dev_err(dev, "Cannot transfer data using DMA\n");
 			ret = -EINVAL;
@@ -406,7 +398,8 @@ static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 		kfree(buf);
 	}
 	ktime_get_ts64(&end);
-	pci_epf_test_print_rate("COPY", reg->size, &start, &end, use_dma);
+	pci_epf_test_print_rate("COPY", reg->size, &start, &end,
+				reg->flags & FLAG_USE_DMA);
 
 err_map_addr:
 	pci_epc_unmap_addr(epc, epf->func_no, epf->vfunc_no, dst_phys_addr);
@@ -430,7 +423,6 @@ static int pci_epf_test_read(struct pci_epf_test *epf_test)
 	void __iomem *src_addr;
 	void *buf;
 	u32 crc32;
-	bool use_dma;
 	phys_addr_t phys_addr;
 	phys_addr_t dst_phys_addr;
 	struct timespec64 start, end;
@@ -463,14 +455,7 @@ static int pci_epf_test_read(struct pci_epf_test *epf_test)
 		goto err_map_addr;
 	}
 
-	use_dma = !!(reg->flags & FLAG_USE_DMA);
-	if (use_dma) {
-		if (!epf_test->dma_supported) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
-			ret = -EINVAL;
-			goto err_dma_map;
-		}
-
+	if (reg->flags & FLAG_USE_DMA) {
 		dst_phys_addr = dma_map_single(dma_dev, buf, reg->size,
 					       DMA_FROM_DEVICE);
 		if (dma_mapping_error(dma_dev, dst_phys_addr)) {
@@ -495,7 +480,8 @@ static int pci_epf_test_read(struct pci_epf_test *epf_test)
 		ktime_get_ts64(&end);
 	}
 
-	pci_epf_test_print_rate("READ", reg->size, &start, &end, use_dma);
+	pci_epf_test_print_rate("READ", reg->size, &start, &end,
+				reg->flags & FLAG_USE_DMA);
 
 	crc32 = crc32_le(~0, buf, reg->size);
 	if (crc32 != reg->checksum)
@@ -519,7 +505,6 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 	int ret;
 	void __iomem *dst_addr;
 	void *buf;
-	bool use_dma;
 	phys_addr_t phys_addr;
 	phys_addr_t src_phys_addr;
 	struct timespec64 start, end;
@@ -555,14 +540,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 	get_random_bytes(buf, reg->size);
 	reg->checksum = crc32_le(~0, buf, reg->size);
 
-	use_dma = !!(reg->flags & FLAG_USE_DMA);
-	if (use_dma) {
-		if (!epf_test->dma_supported) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
-			ret = -EINVAL;
-			goto err_dma_map;
-		}
-
+	if (reg->flags & FLAG_USE_DMA) {
 		src_phys_addr = dma_map_single(dma_dev, buf, reg->size,
 					       DMA_TO_DEVICE);
 		if (dma_mapping_error(dma_dev, src_phys_addr)) {
@@ -589,7 +567,8 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 		ktime_get_ts64(&end);
 	}
 
-	pci_epf_test_print_rate("WRITE", reg->size, &start, &end, use_dma);
+	pci_epf_test_print_rate("WRITE", reg->size, &start, &end,
+				reg->flags & FLAG_USE_DMA);
 
 	/*
 	 * wait 1ms inorder for the write to complete. Without this delay L3
@@ -660,6 +639,12 @@ static void pci_epf_test_cmd_handler(struct work_struct *work)
 	reg->command = 0;
 	reg->status = 0;
 
+	if ((READ_ONCE(reg->flags) & FLAG_USE_DMA) &&
+	    !epf_test->dma_supported) {
+		dev_err(dev, "Cannot transfer data using DMA\n");
+		goto reset_handler;
+	}
+
 	if (reg->irq_type > IRQ_TYPE_MSIX) {
 		dev_err(dev, "Failed to detect IRQ type\n");
 		goto reset_handler;
-- 
2.39.5



