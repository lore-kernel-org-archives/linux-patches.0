Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14337446AC;
	Mon,  1 Apr 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987346; cv=none; b=Fk44apQOD7uV0Wsrq/yBgomZ09fNV3y2UrCJY/kRHjd/MpSxHH0lThmm1iPnk9cTXEwgz20SbaUa/4ULqOORG3MjOWxZ97aMPwXKmBXQOuVZXp+SQWIKTeloLXXR70a1o6h2oVHhajAnppvAuoWbCplf78gEhiAS68IxLFkQgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987346; c=relaxed/simple;
	bh=vLVn6p/Xyc8KHgsWK1c7sfNnLTVGFcpg3yzPIr+ZG5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHy2Y4OTJbI7vAHjW6zHhuY7mJ0Gj4mXje9SLSWEZJYiwdNdQE8ecWBH3OXnaXZrdAeKzZpjYtIsivf7rHO11XUerQYQpmLe5e/Hmp0NEFy/KqdfCVfjwwRkgFg/1KCHRyOR3WdcMUDobry2EWNR40nQ403o40tuvIMunzOcer4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSRnmdyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSRnmdyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC07C433C7;
	Mon,  1 Apr 2024 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987345;
	bh=vLVn6p/Xyc8KHgsWK1c7sfNnLTVGFcpg3yzPIr+ZG5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSRnmdywt/dO2ckOKbKKmcFo+GGjHEGOFP4NvzOtmcINuTj0XSA+7q6nyZ2Xplh3a
	 FCDAxRC3D1LoJKKrqg2VwlsmADxn4ikJSubqvyXQlFzZj7fq9XBH/fCtu/pB+Qwq5r
	 r6w5G/6K4qPZ6Iym4QdKswXD8///L0jDKfE5jftU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 258/399] swiotlb: Honour dma_alloc_coherent() alignment in swiotlb_alloc()
Date: Mon,  1 Apr 2024 17:43:44 +0200
Message-ID: <20240401152556.874784606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit cbf53074a528191df82b4dba1e3d21191102255e ]

core-api/dma-api-howto.rst states the following properties of
dma_alloc_coherent():

  | The CPU virtual address and the DMA address are both guaranteed to
  | be aligned to the smallest PAGE_SIZE order which is greater than or
  | equal to the requested size.

However, swiotlb_alloc() passes zero for the 'alloc_align_mask'
parameter of swiotlb_find_slots() and so this property is not upheld.
Instead, allocations larger than a page are aligned to PAGE_SIZE,

Calculate the mask corresponding to the page order suitable for holding
the allocation and pass that to swiotlb_find_slots().

Fixes: e81e99bacc9f ("swiotlb: Support aligned swiotlb buffers")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2ec2cc81f1a27..a619e22fecbf7 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1633,12 +1633,14 @@ struct page *swiotlb_alloc(struct device *dev, size_t size)
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	struct io_tlb_pool *pool;
 	phys_addr_t tlb_addr;
+	unsigned int align;
 	int index;
 
 	if (!mem)
 		return NULL;
 
-	index = swiotlb_find_slots(dev, 0, size, 0, &pool);
+	align = (1 << (get_order(size) + PAGE_SHIFT)) - 1;
+	index = swiotlb_find_slots(dev, 0, size, align, &pool);
 	if (index == -1)
 		return NULL;
 
-- 
2.43.0



