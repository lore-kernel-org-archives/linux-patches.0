Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819E722A80F;
	Thu, 12 Dec 2024 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020143; cv=none; b=XpZGA20iBKzA6y7JjcST4Nx3desyWaLBLrSHg54y/3cDk3/b9p/L56dbwjWyNr463gfeBO8ssgGSue5NBlFPDKAXjZDzMOiDJScDRDRdfPPmk6L2TDv7nV1uqIT8dM0F8RY1fFwJwXcNETVHvsnWy4eEnt+0oXZyCMInswqPQVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020143; c=relaxed/simple;
	bh=KWmkr11jjkQaJWT9VJ8Q8YVRYRHhiey8MJdbN1OXmF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAe6zc3+/5mLKLIpO9/S57/Vkr6Mhj0IWanCcYWB7m1gLw0V93ww7eDeL8ON2MDemS1QaW+F+uYD9t7XMjyCTaCvbEwU/WucYfrqIV4YfVSSGsTA1Gjh08u7EHG/4LNyQwtaePFFaFAA5OQzaS2tKHcIymqYmBsI6b82Hrn5fmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQKSqy3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQKSqy3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA77C4CECE;
	Thu, 12 Dec 2024 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020143;
	bh=KWmkr11jjkQaJWT9VJ8Q8YVRYRHhiey8MJdbN1OXmF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQKSqy3onhTcLrqbQWFh9LbW4hFZeVi7k6+FeAPeXR/Tbg4pCt+DUqJJZ6Vis3YBb
	 DtLpp0oxnmmad+P9ePbRX2EDZwjbUkuowxyALUdWbIZcch6rkZ7r5TooBpH0AZGnFi
	 3OhsVHpMzinu7/9ddrLjkCQe/lt3QLhCaaQda6SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Alasdair Kergon <agk@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Will Deacon <will@kernel.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 358/772] mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN
Date: Thu, 12 Dec 2024 15:55:03 +0100
Message-ID: <20241212144404.705629014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 4ab5f8ec7d71aea5fe13a48248242130f84ac6bb upstream.

Patch series "mm, dma, arm64: Reduce ARCH_KMALLOC_MINALIGN to 8", v7.

A series reducing the kmalloc() minimum alignment on arm64 to 8 (from
128).


This patch (of 17):

In preparation for supporting a kmalloc() minimum alignment smaller than
the arch DMA alignment, decouple the two definitions.  This requires that
either the kmalloc() caches are aligned to a (run-time) cache-line size or
the DMA API bounces unaligned kmalloc() allocations.  Subsequent patches
will implement both options.

After this patch, ARCH_DMA_MINALIGN is expected to be used in static
alignment annotations and defined by an architecture to be the maximum
alignment for all supported configurations/SoCs in a single Image.
Architectures opting in to a smaller ARCH_KMALLOC_MINALIGN will need to
define its value in the arch headers.

Since ARCH_DMA_MINALIGN is now always defined, adjust the #ifdef in
dma_get_cache_alignment() so that there is no change for architectures not
requiring a minimum DMA alignment.

Link: https://lkml.kernel.org/r/20230612153201.554742-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20230612153201.554742-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cache.h       |    6 ++++++
 include/linux/dma-mapping.h |    3 ++-
 include/linux/slab.h        |   14 ++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -98,4 +98,10 @@ struct cacheline_padding {
 #define CACHELINE_PADDING(name)
 #endif
 
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_HAS_DMA_MINALIGN
+#else
+#define ARCH_DMA_MINALIGN __alignof__(unsigned long long)
+#endif
+
 #endif /* __LINUX_CACHE_H */
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/cache.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/device.h>
@@ -545,7 +546,7 @@ static inline int dma_set_min_align_mask
 
 static inline int dma_get_cache_alignment(void)
 {
-#ifdef ARCH_DMA_MINALIGN
+#ifdef ARCH_HAS_DMA_MINALIGN
 	return ARCH_DMA_MINALIGN;
 #endif
 	return 1;
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
+#include <linux/cache.h>
 #include <linux/gfp.h>
 #include <linux/overflow.h>
 #include <linux/types.h>
@@ -225,12 +226,17 @@ static inline bool kmem_dump_obj(void *o
  * alignment larger than the alignment of a 64-bit integer.
  * Setting ARCH_DMA_MINALIGN in arch headers allows that.
  */
-#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
+#ifdef ARCH_HAS_DMA_MINALIGN
+#if ARCH_DMA_MINALIGN > 8 && !defined(ARCH_KMALLOC_MINALIGN)
 #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
-#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
-#define KMALLOC_SHIFT_LOW ilog2(ARCH_DMA_MINALIGN)
-#else
+#endif
+#endif
+
+#ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
+#elif ARCH_KMALLOC_MINALIGN > 8
+#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
+#define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 #endif
 
 /*


