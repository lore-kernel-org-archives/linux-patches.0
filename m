Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08692BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F6BC433C8;
	Mon, 19 Jun 2023 10:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171855;
	bh=tmfu4rqs8B0jAXCGsPRU3/ZTp9QbsXePOjb3YSjC15M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxS9ziaKZbjNpgqCdPLl/65u8MzMEIx2Kr6fixtjD3ssksmGjZuD5fwyoQYjnOUJi
	 sfaMHqHRc0X3WkQqrTbB4Ag5uX+kmM3GaPBno3jntgYQUKZahs1LSfRvl7E9eCW//z
	 fyCHLUEa4nZPzeR3RbI/jdD8lV5d9YtZ1Txc36nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/64] parisc: Improve cache flushing for PCXL in arch_sync_dma_for_cpu()
Date: Mon, 19 Jun 2023 12:30:11 +0200
Message-ID: <20230619102133.646084086@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 59fa12646d9f56c842b4d5b6418ed77af625c588 ]

Add comment in arch_sync_dma_for_device() and handle the direction flag in
arch_sync_dma_for_cpu().

When receiving data from the device (DMA_FROM_DEVICE) unconditionally
purge the data cache in arch_sync_dma_for_cpu().

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/pci-dma.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index a60d47fd4d55f..1621f678aa05b 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -442,13 +442,29 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
 		enum dma_data_direction dir)
 {
+	/*
+	 * fdc: The data cache line is written back to memory, if and only if
+	 * it is dirty, and then invalidated from the data cache.
+	 */
 	flush_kernel_dcache_range((unsigned long)phys_to_virt(paddr), size);
 }
 
 void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
 		enum dma_data_direction dir)
 {
-	flush_kernel_dcache_range((unsigned long)phys_to_virt(paddr), size);
+	unsigned long addr = (unsigned long) phys_to_virt(paddr);
+
+	switch (dir) {
+	case DMA_TO_DEVICE:
+	case DMA_BIDIRECTIONAL:
+		flush_kernel_dcache_range(addr, size);
+		return;
+	case DMA_FROM_DEVICE:
+		purge_kernel_dcache_range_asm(addr, addr + size);
+		return;
+	default:
+		BUG();
+	}
 }
 
 void arch_dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-- 
2.39.2



