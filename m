Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963B12C525;
	Tue, 23 Jan 2024 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971433; cv=none; b=AID5l/g1Kb3RmEQp6qV0DiwJvUaBqh9h+4BL+RdQdJ62akJZaQ4DBnQaVKYnE1p+LrCN5kYb8VTVJS1r5AAnbTfr4wtIIU6AAraMr00WW+FQ7ewO1aZx6a/y8PKt9Su/PjeFJ5Dp1CBNflgrSSEYm7qtbn74mLMyH073qg5tDXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971433; c=relaxed/simple;
	bh=c79XDCiAo+vA/Kd1qILf1Y7n7ydazvZuTnejby+6650=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC7a2sXbJTwoGMXUKdppg9zDijUwE6F6cQGPa995Xzx3bwU/Z+2bJJssxcoYhOem7hgIYWnzRz5Wo6BwrMHuSGtyrAi7z6G8+uWgLnlT/Lil2TXkkFQSP1ImXeqXDOMj/tuu5N1r644hTz46YyIPijcUzFnQa8s88HbD0y6ebXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6F2uu2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6F2uu2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5713BC43390;
	Tue, 23 Jan 2024 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971432;
	bh=c79XDCiAo+vA/Kd1qILf1Y7n7ydazvZuTnejby+6650=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6F2uu2aKPUO/R71+OVkrsWJ9ZpWAHEdHzttEFJVPWtpoAXu4OjTH4kvKzMPaY2+u
	 VnfLdtYCVmj+ZbuyiauJQBMggWHJ7r/CfyyD9CDUOx438eoT46+2ucRXGE00RuXdmE
	 9gvkRh89oHWv4UFN+4noAX8CeQnsuw53EFUKxZm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Christoph Hellwig <hch@lst.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/286] dma-mapping: Add dma_release_coherent_memory to DMA API
Date: Mon, 22 Jan 2024 15:57:14 -0800
Message-ID: <20240122235737.069915124@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

[ Upstream commit e61c451476e61450f6771ce03bbc01210a09be16 ]

Add dma_release_coherent_memory to DMA API to allow dma
user call it to release dev->dma_mem when the device is
removed.

Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220422062436.14384-2-mark-pk.tsai@mediatek.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: b07bc2347672 ("dma-mapping: clear dev->dma_mem to NULL after freeing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-map-ops.h |  3 +++
 kernel/dma/coherent.c       | 10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index a5f89fc4d6df..22e3bfebdc34 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -165,6 +165,7 @@ static inline void dma_pernuma_cma_reserve(void) { }
 #ifdef CONFIG_DMA_DECLARE_COHERENT
 int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		dma_addr_t device_addr, size_t size);
+void dma_release_coherent_memory(struct device *dev);
 int dma_alloc_from_dev_coherent(struct device *dev, ssize_t size,
 		dma_addr_t *dma_handle, void **ret);
 int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr);
@@ -183,6 +184,8 @@ static inline int dma_declare_coherent_memory(struct device *dev,
 {
 	return -ENOSYS;
 }
+
+#define dma_release_coherent_memory(dev) (0)
 #define dma_alloc_from_dev_coherent(dev, size, handle, ret) (0)
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 5b5b6c7ec7f2..b79d8d0433dd 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -84,7 +84,7 @@ static int dma_init_coherent_memory(phys_addr_t phys_addr,
 	return ret;
 }
 
-static void dma_release_coherent_memory(struct dma_coherent_mem *mem)
+static void _dma_release_coherent_memory(struct dma_coherent_mem *mem)
 {
 	if (!mem)
 		return;
@@ -136,10 +136,16 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
 	ret = dma_assign_coherent_memory(dev, mem);
 	if (ret)
-		dma_release_coherent_memory(mem);
+		_dma_release_coherent_memory(mem);
 	return ret;
 }
 
+void dma_release_coherent_memory(struct device *dev)
+{
+	if (dev)
+		_dma_release_coherent_memory(dev->dma_mem);
+}
+
 static void *__dma_alloc_from_coherent(struct device *dev,
 				       struct dma_coherent_mem *mem,
 				       ssize_t size, dma_addr_t *dma_handle)
-- 
2.43.0



