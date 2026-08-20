Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4226D47ACC3;
	Thu, 20 Aug 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247777; cv=none; b=m3/Pg6whLtmuuzAfX/xMOj5NL3OhjfpTraN2+OECDpfa7XZt+updesA1xJ9Y02/fXPqIKEf63piS8J6i/xtB9zYUQ1ZtY+EezdvLEONVnxfo42caekueTSk20T664k7z6ZyJZwWYXjyEbFWPHP6mrdM8XV7Xu1IJDsWSsfru9sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247777; c=relaxed/simple;
	bh=yNjAHWAzT7IThr5T77CQn1GTfss5ZRBSRquoef5Vci8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BORHlkeBkYsaOnfDv94gTkrdbBSfJRl6dWtfoGzn/lTfTAkQEb9sauUOUXiT+bwwTR6HMFoGrB13Gq7jbkB/mSL2HnN2ch7ZQ3w/M8LGTKCvKUK/2x8dtxc4XVx8lZUqTh24k4sCsp7kFWEN4d1gW/169RrIpUlTb0MP9/ENUJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fycYFtO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fycYFtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E841F000E9;
	Thu, 20 Aug 2026 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247776;
	bh=lc72t3TqAoRAh8RNh0vgQ5TS9L7WRGe5rc1kSI08Fls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fycYFtOd0fzQObMeMlaQNWtpsFT5V9lfAgEiLBUA8Mqc0g0MSnI9y5R54A/7krO5
	 ypTTVIRoMv1P+BAPOOUttJSRujdhNpqhUFNFLhSgxRC7Pgl+ANXOQ7T5X4JrCinP9Q
	 oa7HOlmsR73r6Lzg4Ivhs/v+TJEGoQSpT63qhzCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/166] dma-direct: add a CONFIG_ARCH_HAS_DMA_ALLOC symbol
Date: Thu, 20 Aug 2026 16:56:57 +0200
Message-ID: <20260820145215.918312893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 2c8ed1b960fb97c82ede5afc974329bfdb457f5f ]

Instead of using arch_dma_alloc if none of the generic coherent
allocators are used, require the architectures to explicitly opt into
providing it.  This will used to deal with the case of m68knommu and
coldfire where we can't do any coherent allocations whatsoever, and
also makes it clear that arch_dma_alloc is a last resort.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Greg Ungerer <gerg@linux-m68k.org>
Tested-by: Greg Ungerer <gerg@linux-m68k.org>
Stable-dep-of: 1fd495ef09ee ("m68k: Define NR_CPUS to 1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig    |  1 +
 arch/m68k/Kconfig   |  1 +
 arch/parisc/Kconfig |  1 +
 kernel/dma/Kconfig  |  9 +++++++++
 kernel/dma/direct.c | 12 ++----------
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index be3b0f83eee57..f254900f0ddd4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -8,6 +8,7 @@ config ARM
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
+	select ARCH_HAS_DMA_ALLOC if MMU
 	select ARCH_HAS_DMA_WRITE_COMBINE if !ARM_DMA_MEM_BUFFERABLE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FORTIFY_SOURCE
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 3e318bf9504c5..4f3e7dec2171c 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
+	select ARCH_HAS_DMA_ALLOC if !MMU || COLDFIRE
 	select ARCH_HAS_DMA_PREP_COHERENT if HAS_DMA && MMU && !COLDFIRE
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if HAS_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index a077e6bf9475f..536d76f9f7e28 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -8,6 +8,7 @@ config PARISC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_HAS_DMA_ALLOC if PA11
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index f488997b07171..66f036eeeb18b 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -142,6 +142,15 @@ config DMA_DIRECT_REMAP
 	select DMA_COHERENT_POOL
 	select DMA_NONCOHERENT_MMAP
 
+#
+# Fallback to arch code for DMA allocations.  This should eventually go away.
+#
+config ARCH_HAS_DMA_ALLOC
+	depends on !ARCH_HAS_DMA_SET_UNCACHED
+	depends on !DMA_DIRECT_REMAP
+	depends on !DMA_GLOBAL_POOL
+	bool
+
 config DMA_CMA
 	bool "DMA Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && CMA
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index fc2d10b2aca6f..91915d351e123 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -220,13 +220,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
 	if (!dev_is_dma_coherent(dev)) {
-		/*
-		 * Fallback to the arch handler if it exists.  This should
-		 * eventually go away.
-		 */
-		if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
-		    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-		    !IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
+		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
 		    !is_swiotlb_for_alloc(dev))
 			return arch_dma_alloc(dev, size, dma_handle, gfp,
 					      attrs);
@@ -332,9 +326,7 @@ void dma_direct_free(struct device *dev, size_t size,
 		return;
 	}
 
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
-	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    !IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
 	    !dev_is_dma_coherent(dev) &&
 	    !is_swiotlb_for_alloc(dev)) {
 		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
-- 
2.53.0



