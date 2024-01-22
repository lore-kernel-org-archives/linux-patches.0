Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E165BC5;
	Tue, 23 Jan 2024 01:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971673; cv=none; b=bKk3n58RTNLNmgOaEGNLrnpwB1QqqqSz4no5XCDFnEiblDw4gwxvVAgc5hnx0LDG4VCh6bNI7/Nd6AzB5mXtvuxwZbvSxAowvuItO8r1yeCv0PH6rWAD7QCHYjQk5/e7KZXOJ1e3JoFMh0a6ftM4RrFUVTM26J33I0gOgY/csjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971673; c=relaxed/simple;
	bh=LQy6MIR6KBFgrFgOterXrh53yfdvMqBqYBIqMK36Bo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgiwZsKFnvfQhkz4Z95SaE7YIZhLtazXbKnl+/R/sIpcxt3A0ygh8JFZj3HpN3dnMvNZ4l2T3BX35c1EXG5fpIzyQgAtNIxr6OGmkQrExji/dSJecVQELOUEXO82Ync4PojjHiqpL3I3uudQGgunm45d3c6CJzLEMphzY44zwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWDwA1Sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWDwA1Sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA3EC433C7;
	Tue, 23 Jan 2024 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971673;
	bh=LQy6MIR6KBFgrFgOterXrh53yfdvMqBqYBIqMK36Bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWDwA1Sa3TwLPd9wyll4qypEBH2U8R+uwZA6QqplUR6Fo0n44bWKs/H+ZREMRbv4n
	 xslSI0UahB+h9zrjNS1Tgur6dSPs4j0mQ7APJOLVYw7NQDHXks+pE10zIxspvE6IO4
	 nWnB8ilrQj+nrjiLHyCMAw3LsXZ9FdRErmErbHrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Ren Zhijie <renzhijie2@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 202/286] dma-mapping: Fix build error unused-value
Date: Mon, 22 Jan 2024 15:58:28 -0800
Message-ID: <20240122235739.900667315@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Zhijie <renzhijie2@huawei.com>

commit 50d6281ce9b8412f7ef02d1bc9d23aa62ae0cf98 upstream.

If CONFIG_DMA_DECLARE_COHERENT is not set,
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- will be failed, like this:

drivers/remoteproc/remoteproc_core.c: In function ‘rproc_rvdev_release’:
./include/linux/dma-map-ops.h:182:42: error: statement with no effect [-Werror=unused-value]
 #define dma_release_coherent_memory(dev) (0)
                                          ^
drivers/remoteproc/remoteproc_core.c:464:2: note: in expansion of macro ‘dma_release_coherent_memory’
  dma_release_coherent_memory(dev);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

The return type of function dma_release_coherent_memory in CONFIG_DMA_DECLARE_COHERENT area is void, so in !CONFIG_DMA_DECLARE_COHERENT area it should neither return any value nor be defined as zero.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e61c451476e6 ("dma-mapping: Add dma_release_coherent_memory to DMA API")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220630123528.251181-1-renzhijie2@huawei.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dma-map-ops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -185,10 +185,10 @@ static inline int dma_declare_coherent_m
 	return -ENOSYS;
 }
 
-#define dma_release_coherent_memory(dev) (0)
 #define dma_alloc_from_dev_coherent(dev, size, handle, ret) (0)
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
+static inline void dma_release_coherent_memory(struct device *dev) { }
 
 static inline void *dma_alloc_from_global_coherent(struct device *dev,
 		ssize_t size, dma_addr_t *dma_handle)


