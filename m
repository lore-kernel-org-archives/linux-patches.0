Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B624422967A;
	Thu, 12 Dec 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021862; cv=none; b=r7nfi5ZIX9Q4D8LcmbULjgGLKnQqhw0hE7cYzu4UQ2CDcWukzwGh4j1IGfx9qDuh09h3I9A9YpTMhKh0Bc64NyzTcYnUszUVYkHS7u0pkaeP0AOvabuJZweOZoyLnxykjw/kcryGqwtHSWmnQka11VTUYBP0tB/Zp/t66QtGTPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021862; c=relaxed/simple;
	bh=tvJjj228dAfBT0AlyaxxIPAWuRWpszFOmteapFD/Drg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meCDysFqeAf1fZntd9hRicKXfwuj4QB1bUQWX52sWmy0VKs2FT9S9WoXYBhWOkp0b4LMMs8tP4mF2avnJq9kFGspJOpnSiJ3yomOnycIoXh/pBthiiqshl+MWeJBEzYARvBZvTvD8EM35QDB6c4AMGCTyR5SWhAJg8KS5UpxFWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUMdHyxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUMdHyxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210C5C4CECE;
	Thu, 12 Dec 2024 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021862;
	bh=tvJjj228dAfBT0AlyaxxIPAWuRWpszFOmteapFD/Drg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUMdHyxB51CCxjfghlXLWZd6guYwtxQclK8KvuoibdrPgls4QSTJio0/BUcx1X49m
	 zpQdnBbvkN5vCzJYGrzWlm60va6ux3iULyg2bCprO8au+5XMX45Wf1F1EDWlWIgXMF
	 Jnrg3KmOtCeVKqpJAGLqnIusGxyKafK/AHisCEZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/565] nvme-pci: fix freeing of the HMB descriptor table
Date: Thu, 12 Dec 2024 15:54:38 +0100
Message-ID: <20241212144314.770264221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9e80e238954ca..04fedb27e35ad 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -150,6 +150,7 @@ struct nvme_dev {
 	/* host memory buffer support: */
 	u64 host_mem_size;
 	u32 nr_host_mem_descs;
+	u32 host_mem_descs_size;
 	dma_addr_t host_mem_descs_dma;
 	struct nvme_host_mem_buf_desc *host_mem_descs;
 	void **host_mem_desc_bufs;
@@ -1921,10 +1922,10 @@ static void nvme_free_host_mem(struct nvme_dev *dev)
 
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
 
@@ -1932,7 +1933,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 		u32 chunk_size)
 {
 	struct nvme_host_mem_buf_desc *descs;
-	u32 max_entries, len;
+	u32 max_entries, len, descs_size;
 	dma_addr_t descs_dma;
 	int i = 0;
 	void **bufs;
@@ -1945,8 +1946,9 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	if (dev->ctrl.hmmaxd && dev->ctrl.hmmaxd < max_entries)
 		max_entries = dev->ctrl.hmmaxd;
 
-	descs = dma_alloc_coherent(dev->dev, max_entries * sizeof(*descs),
-				   &descs_dma, GFP_KERNEL);
+	descs_size = max_entries * sizeof(*descs);
+	descs = dma_alloc_coherent(dev->dev, descs_size, &descs_dma,
+			GFP_KERNEL);
 	if (!descs)
 		goto out;
 
@@ -1975,6 +1977,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	dev->host_mem_size = size;
 	dev->host_mem_descs = descs;
 	dev->host_mem_descs_dma = descs_dma;
+	dev->host_mem_descs_size = descs_size;
 	dev->host_mem_desc_bufs = bufs;
 	return 0;
 
@@ -1989,8 +1992,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 
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



