Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDD20C02D;
	Tue,  3 Dec 2024 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240102; cv=none; b=jZ+VIX8iPBPcbGY52/RtEFFr0+M2iqwosgfgzJNMg320INGKbCrJGqfTHTLHL3KZk7jpDVwWEeVVHqLchBzXgFC2aaRoOC0jcIqAhq+CR0Ztcyd8Q1F8pyblL8QtsCNoKussu7k3BKMyy8/rgYPx9p7JLg56YTNLzAqYMJXODro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240102; c=relaxed/simple;
	bh=yzCwDnmSn1AtDP4YyUZcbsn93mSA93qLs9zhhBvnNIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2PKIX7tZRmTGiuQjbYfYdBEaWyqGto6Lw/BCPk8syowxn3p7wtBAmldEkLVsxyKd+aaBVrGAtnNOIUwL+dePISHmtIlTNJ9vtO2x++fijFhEElQTdy7JOJYOf9gEpV7Zax/MbxHlxOQlgkbSBPuNwKBWFXsLj1QbO5Hq4HHoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScvLg73r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScvLg73r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA7BC4CED9;
	Tue,  3 Dec 2024 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240102;
	bh=yzCwDnmSn1AtDP4YyUZcbsn93mSA93qLs9zhhBvnNIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScvLg73rw1UGc4DUxVV1x/5tmnL3AYBdLRJwwOqxXaygU7gJtb0YJky3IixO6i/HW
	 Icj8yb+Xm3nct5gbjnKUIiLcZ/561KtZUeGbN6oTKL9X/i9SADv+kvRXpWouyEivCL
	 L2kAoVtPP6rdW7WX11Jbt0X4OTZcsoXnt9Y/1AGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/826] nvme-pci: fix freeing of the HMB descriptor table
Date: Tue,  3 Dec 2024 15:35:50 +0100
Message-ID: <20241203144744.363419169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3c2fb1ca8086eb139b2a551358137525ae8e0d7a ]

The HMB descriptor table is sized to the maximum number of descriptors
that could be used for a given device, but __nvme_alloc_host_mem could
break out of the loop earlier on memory allocation failure and end up
using less descriptors than planned for, which leads to an incorrect
size passed to dma_free_coherent.

In practice this was not showing up because the number of descriptors
tends to be low and the dma coherent allocator always allocates and
frees at least a page.

Fixes: 87ad72a59a38 ("nvme-pci: implement host memory buffer support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4b9fda0b1d9a3..34daf6d8db07b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -153,6 +153,7 @@ struct nvme_dev {
 	/* host memory buffer support: */
 	u64 host_mem_size;
 	u32 nr_host_mem_descs;
+	u32 host_mem_descs_size;
 	dma_addr_t host_mem_descs_dma;
 	struct nvme_host_mem_buf_desc *host_mem_descs;
 	void **host_mem_desc_bufs;
@@ -1966,10 +1967,10 @@ static void nvme_free_host_mem(struct nvme_dev *dev)
 
 	kfree(dev->host_mem_desc_bufs);
 	dev->host_mem_desc_bufs = NULL;
-	dma_free_coherent(dev->dev,
-			dev->nr_host_mem_descs * sizeof(*dev->host_mem_descs),
+	dma_free_coherent(dev->dev, dev->host_mem_descs_size,
 			dev->host_mem_descs, dev->host_mem_descs_dma);
 	dev->host_mem_descs = NULL;
+	dev->host_mem_descs_size = 0;
 	dev->nr_host_mem_descs = 0;
 }
 
@@ -1977,7 +1978,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 		u32 chunk_size)
 {
 	struct nvme_host_mem_buf_desc *descs;
-	u32 max_entries, len;
+	u32 max_entries, len, descs_size;
 	dma_addr_t descs_dma;
 	int i = 0;
 	void **bufs;
@@ -1990,8 +1991,9 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	if (dev->ctrl.hmmaxd && dev->ctrl.hmmaxd < max_entries)
 		max_entries = dev->ctrl.hmmaxd;
 
-	descs = dma_alloc_coherent(dev->dev, max_entries * sizeof(*descs),
-				   &descs_dma, GFP_KERNEL);
+	descs_size = max_entries * sizeof(*descs);
+	descs = dma_alloc_coherent(dev->dev, descs_size, &descs_dma,
+			GFP_KERNEL);
 	if (!descs)
 		goto out;
 
@@ -2020,6 +2022,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	dev->host_mem_size = size;
 	dev->host_mem_descs = descs;
 	dev->host_mem_descs_dma = descs_dma;
+	dev->host_mem_descs_size = descs_size;
 	dev->host_mem_desc_bufs = bufs;
 	return 0;
 
@@ -2034,8 +2037,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 
 	kfree(bufs);
 out_free_descs:
-	dma_free_coherent(dev->dev, max_entries * sizeof(*descs), descs,
-			descs_dma);
+	dma_free_coherent(dev->dev, descs_size, descs, descs_dma);
 out:
 	dev->host_mem_descs = NULL;
 	return -ENOMEM;
-- 
2.43.0



