Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A583168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991D4C4339B;
	Mon,  8 May 2023 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545174;
	bh=Hdmkbnf/jdowcnlptG+4+LQmXkMcWyObXBQjB5EIiSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htwNIKhnsShMS6jof9HQ5WGNrKG5AMtAUOWPyCX3tCkUGXXiRlISKwj0zn3hkrksS
	 dePWiogecuOQ2BKI7A98VeifvDFv/Po0wT5T5NYES3qnYoHyHqBacDrVfxja2WL00W
	 XcYzIOHiX9eAzd5o3vlsH4pQe7Z2YWETqRRBKXoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 618/694] swiotlb: relocate PageHighMem test away from rmem_swiotlb_setup
Date: Mon,  8 May 2023 11:47:33 +0200
Message-Id: <20230508094455.562242747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a90922fa25370902322e9de6640e58737d459a50 ]

The reservedmem_of_init_fn's are invoked very early at boot before the
memory zones have even been defined. This makes it inappropriate to test
whether the page corresponding to a PFN is in ZONE_HIGHMEM from within
one.

Removing the check allows an ARM 32-bit kernel with SPARSEMEM enabled to
boot properly since otherwise we would be de-referencing an
uninitialized sparsemem map to perform pfn_to_page() check.

The arm64 architecture happens to work (and also has no high memory) but
other 32-bit architectures could also be having similar issues.

While it would be nice to provide early feedback about a reserved DMA
pool residing in highmem, it is not possible to do that until the first
time we try to use it, which is where the check is moved to.

Fixes: 0b84e4f8b793 ("swiotlb: Add restricted DMA pool initialization")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index dac42a2ad5883..2bb9e3b023802 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -998,6 +998,11 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 	/* Set Per-device io tlb area to one */
 	unsigned int nareas = 1;
 
+	if (PageHighMem(pfn_to_page(PHYS_PFN(rmem->base)))) {
+		dev_err(dev, "Restricted DMA pool must be accessible within the linear mapping.");
+		return -EINVAL;
+	}
+
 	/*
 	 * Since multiple devices can share the same pool, the private data,
 	 * io_tlb_mem struct, will be initialized by the first device attached
@@ -1059,11 +1064,6 @@ static int __init rmem_swiotlb_setup(struct reserved_mem *rmem)
 	    of_get_flat_dt_prop(node, "no-map", NULL))
 		return -EINVAL;
 
-	if (PageHighMem(pfn_to_page(PHYS_PFN(rmem->base)))) {
-		pr_err("Restricted DMA pool must be accessible within the linear mapping.");
-		return -EINVAL;
-	}
-
 	rmem->ops = &rmem_swiotlb_ops;
 	pr_info("Reserved memory: created restricted DMA pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.39.2



