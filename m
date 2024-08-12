Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC81494B8;
	Mon, 12 Aug 2024 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480504; cv=none; b=cSRIJT1BC/j7nv0iIOoiRvxRfWKAURo1us2MbebWW8b7aUpFORm12Aactu5Z24i2dvadrMvDgGesRySnOi2HRCr84l5boyiLtPQtX/O97I1JAlkXreqMZWIbTywvqDmszVQlYwnDwziyHkjN4TB1Q/M2KO+xGPet66976vm9SjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480504; c=relaxed/simple;
	bh=Kxiyg6k5nTwK+tUvJoGkws7w9XnHxM/6xz+8hfnywIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAXY96SfRcq+Wz9KD4MZlTgTWu965JwTbZSPsJAZ2wsSzVjR8EwOUypvRxq3ArrryMpqrk6c9uR51+oK/rSjHVxOc/ZmtkL4+TEmdCZWxC7L6QFTl1ttAQZWuek0HxKGxocJIT6xb1BtvsZGUFDcmcoplTd9XJJQ/Kzb6HeY034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gb36B6uT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gb36B6uT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D1C32782;
	Mon, 12 Aug 2024 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480504;
	bh=Kxiyg6k5nTwK+tUvJoGkws7w9XnHxM/6xz+8hfnywIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb36B6uT0E45dMlRsUvoudUPuuxSMaQILY8ez1ejN+fify7Z6M6uuOr/xtl4zQDgY
	 jALH11cNGpTbeAB26HHz7hldnSbLoryGnPeBFlQMCaIlO/gsAcF2TSOUu08hcnDQda
	 SgZ29e+1cbNbyBAeU5qKG5eWSVCDsX5qVRuWuj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.10 215/263] parisc: fix a possible DMA corruption
Date: Mon, 12 Aug 2024 18:03:36 +0200
Message-ID: <20240812160154.774541840@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7ae04ba36b381bffe2471eff3a93edced843240f upstream.

ARCH_DMA_MINALIGN was defined as 16 - this is too small - it may be
possible that two unrelated 16-byte allocations share a cache line. If
one of these allocations is written using DMA and the other is written
using cached write, the value that was written with DMA may be
corrupted.

This commit changes ARCH_DMA_MINALIGN to be 128 on PA20 and 32 on PA1.1 -
that's the largest possible cache line size.

As different parisc microarchitectures have different cache line size, we
define arch_slab_minalign(), cache_line_size() and
dma_get_cache_alignment() so that the kernel may tune slab cache
parameters dynamically, based on the detected cache line size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig             |    1 +
 arch/parisc/include/asm/cache.h |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -20,6 +20,7 @@ config PARISC
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_STACKWALK
+	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select HAVE_RELIABLE_STACKTRACE
 	select DMA_OPS
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -20,7 +20,16 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#ifdef CONFIG_PA20
+#define ARCH_DMA_MINALIGN	128
+#else
+#define ARCH_DMA_MINALIGN	32
+#endif
+#define ARCH_KMALLOC_MINALIGN	16	/* ldcw requires 16-byte alignment */
+
+#define arch_slab_minalign()	((unsigned)dcache_stride)
+#define cache_line_size()	dcache_stride
+#define dma_get_cache_alignment cache_line_size
 
 #define __read_mostly __section(".data..read_mostly")
 


