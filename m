Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57475C9C;
	Tue, 23 Jan 2024 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974066; cv=none; b=CPGzdXncTcVowD74ERp1olpIJ1c256Yv7eIBhDnu502O9/QGoRtfd3buODQ3sxDyYknThzlvVvujK5G8vcmN6dvhKt+8REKZLRIQdCQUP46c0ZYZLXNBbADQYxy2DNS6caBPolWhaVUaErjmbusHkIg9PlcDOf3AfdLAjeCD/uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974066; c=relaxed/simple;
	bh=WvitrPZD9HncNLuOnlxiZsd/k+zOyw6OfX1h6csrS+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opukA4Pc028x2NYr102dQbDdmSOz2S+Pa7wkDnHBW0DRDjwyeeTp2yxrSUhaxjfXcEuVFvkEa+SuZlO/mhTq/t6lBxwecRmL3wbKwYW/MUXonhZjreM6IoiUeGfC2uzfw6x7lGiOane/wvLRwtArp1To6R3KWJqE1IIwmpyWV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdfELa5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdfELa5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82583C43390;
	Tue, 23 Jan 2024 01:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974066;
	bh=WvitrPZD9HncNLuOnlxiZsd/k+zOyw6OfX1h6csrS+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdfELa5YYXoPIHNH0viStc2IU4r+O4xZ0dZ/1Buh2giViTih7LUFXARp3gNizynAc
	 jt6i4dQTAobgIVB163Lx6KjbVczg4RAoBZ8DVgMV2YOPa1jzMyUKiNc5fWMr2L3PUQ
	 x2Kk7/L7qb+DKqGL4kisWNLB3BFMWM8iZejTtg/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Christoph Hellwig <hch@lst.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/374] dma-mapping: Add dma_release_coherent_memory to DMA API
Date: Mon, 22 Jan 2024 15:56:45 -0800
Message-ID: <20240122235749.817518755@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 0d5b06b3a4a6..53db9655efe9 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -166,6 +166,7 @@ static inline void dma_pernuma_cma_reserve(void) { }
 #ifdef CONFIG_DMA_DECLARE_COHERENT
 int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		dma_addr_t device_addr, size_t size);
+void dma_release_coherent_memory(struct device *dev);
 int dma_alloc_from_dev_coherent(struct device *dev, ssize_t size,
 		dma_addr_t *dma_handle, void **ret);
 int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr);
@@ -177,6 +178,8 @@ static inline int dma_declare_coherent_memory(struct device *dev,
 {
 	return -ENOSYS;
 }
+
+#define dma_release_coherent_memory(dev) (0)
 #define dma_alloc_from_dev_coherent(dev, size, handle, ret) (0)
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 25fc85a7aebe..ca05989d9901 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -75,7 +75,7 @@ static struct dma_coherent_mem *dma_init_coherent_memory(phys_addr_t phys_addr,
 	return ERR_PTR(-ENOMEM);
 }
 
-static void dma_release_coherent_memory(struct dma_coherent_mem *mem)
+static void _dma_release_coherent_memory(struct dma_coherent_mem *mem)
 {
 	if (!mem)
 		return;
@@ -127,10 +127,16 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
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



