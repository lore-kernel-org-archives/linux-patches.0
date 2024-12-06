Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC232C8B;
	Fri,  6 Dec 2024 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496635; cv=none; b=ma6sx1T/qPDIKwQwLuVOA+oY8o60Cle1bwFrwAod6hMMuVTnB4+OQw89T3QfWXq/FrAL0pSulBjL3ygxxVMxb7oWrn7H8V3wGo5DuKvuDaNsUL3Jga59tJN6RMIE12IqeLbFcH9jzyd5t+hGx2IIbwuCcg7C8hJ2bF+JxF+eTEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496635; c=relaxed/simple;
	bh=ltukdhrYyj14UxnbfT4sa4ruB4IKUeyey8479Vn0yV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk7g17kNnBMcHihwsiLRunPB2T/yaTwtXcTlQJALumHUf9NkpikbuKVFF1Qwra/5i7hTi7dMWL6MH9u64+5Pu4D4vq8U/V64xlslT+tHoQdTlPyS9KyEUtacCs5FFci30IRZDOSFYGgqT6O6tI8UYAnAYqD1qJ6ySx4Rh5L5nNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIkEHb5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIkEHb5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAC1C4CED1;
	Fri,  6 Dec 2024 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496633;
	bh=ltukdhrYyj14UxnbfT4sa4ruB4IKUeyey8479Vn0yV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIkEHb5ex8e7F0iLXGjd1Q2rUxZg+o4wxevhiNlnP6cwoy7UnsWow4ZCSaMxWAAgg
	 pKHVJ3P1Tf+Q9PypaYoj2z2S0xSvWwR9AXU/L2XQ/GgBAORBgiQS9Bdthrlgp7OIlv
	 5+Des9PRp1W/sc6cdtLM544rBkJkl0Zz2yjVrwk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/676] nvme-pci: fix freeing of the HMB descriptor table
Date: Fri,  6 Dec 2024 15:27:59 +0100
Message-ID: <20241206143655.708744919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index b701969cf1c2a..e0b502573b427 100644
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
@@ -1929,10 +1930,10 @@ static void nvme_free_host_mem(struct nvme_dev *dev)
 
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
 
@@ -1940,7 +1941,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 		u32 chunk_size)
 {
 	struct nvme_host_mem_buf_desc *descs;
-	u32 max_entries, len;
+	u32 max_entries, len, descs_size;
 	dma_addr_t descs_dma;
 	int i = 0;
 	void **bufs;
@@ -1953,8 +1954,9 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	if (dev->ctrl.hmmaxd && dev->ctrl.hmmaxd < max_entries)
 		max_entries = dev->ctrl.hmmaxd;
 
-	descs = dma_alloc_coherent(dev->dev, max_entries * sizeof(*descs),
-				   &descs_dma, GFP_KERNEL);
+	descs_size = max_entries * sizeof(*descs);
+	descs = dma_alloc_coherent(dev->dev, descs_size, &descs_dma,
+			GFP_KERNEL);
 	if (!descs)
 		goto out;
 
@@ -1983,6 +1985,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 	dev->host_mem_size = size;
 	dev->host_mem_descs = descs;
 	dev->host_mem_descs_dma = descs_dma;
+	dev->host_mem_descs_size = descs_size;
 	dev->host_mem_desc_bufs = bufs;
 	return 0;
 
@@ -1997,8 +2000,7 @@ static int __nvme_alloc_host_mem(struct nvme_dev *dev, u64 preferred,
 
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



