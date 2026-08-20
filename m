Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E0B442FDA;
	Thu, 20 Aug 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247780; cv=none; b=Bg+tqpJyNzfVLmcq6temi2F257u7P9jOZ0xO+14OmGT0ITP4NY0uSTx3t6B2HnelO+2h/x5gU1eSe8X0vtZ1YdiL0mKSXtdvtVhiK9VysN11x2Vr4lrhXpDXxpNPlH5Io8x1ec7ZL6kyQPrn1AnRkAhnmnz0/xUaSxC0oUgp4kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247780; c=relaxed/simple;
	bh=Eg8Abph8vNSTpSjTKSJUMYFAlmY2GZC/i2dBodzdJg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRiar6mRZGI8y0o2L3BJQGP/Q/4LM0H9uQUkxr/QjIxbnE/UsSfcq7iC5ubSOYd1bFP7IRl3ffC5/Bt8grrqHmBIjQlXDvSb4vjyG+YZsBY3+5uB7tMx4DsZOwyC0i0S0pd63lUB2znaZ4oVP2yn0psV74oExOIrDA/SJ6vRvDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DybCcbWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DybCcbWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7458B1F000E9;
	Thu, 20 Aug 2026 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247779;
	bh=Y/93l6dkhPfAmBeoFuYh+9Vl2rUZPRvr7Rza+ZUEtbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DybCcbWt4+0kNCs7IK0TeHNpaWFWLZFYap1wITXADoULn2CbbLz7g01jI9S6abxFL
	 Rh3coBuZ8LFMimEAQDhaMp66aEeiSNTGR6I8vgC7B4ZRYO3alUVxiAk3IzkwcVuYN2
	 BTZd01P4t+Sf4Bt+M2U13nm+RclBn8MyvujBdmas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/166] m68k: use the coherent DMA code for coldfire without data cache
Date: Thu, 20 Aug 2026 16:56:58 +0200
Message-ID: <20260820145215.947553483@linuxfoundation.org>
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

[ Upstream commit 9e28bf8bdf2177a88bd6648fc741bc0280e08af8 ]

Coldfire cores configured without a data cache are DMA coherent and
should thus simply use the simple coherent version of dma-direct.

Introduce a new COLDFIRE_COHERENT_DMA Kconfig symbol as a convenient
short hand for such configurations, and a M68K_NONCOHERENT_DMA symbol
for all cases where we need to build non-coherent DMA infrastructure
to simplify the Kconfig and code conditionals.

Not building the non-coherent DMA code slightly reduces the code
size for such configurations.

Numers for m5249evb_defconfig below:

  text	   data	    bss	    dec	    hex	filename
2896158	 401052	  65392	3362602	 334f2a	vmlinux.before
2895166	 400988	  65392	3361546	 334b0a	vmlinux.after

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Greg Ungerer <gerg@linux-m68k.org>
Stable-dep-of: 1fd495ef09ee ("m68k: Define NR_CPUS to 1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig         |  8 ++++----
 arch/m68k/Kconfig.cpu     | 12 ++++++++++++
 arch/m68k/kernel/Makefile |  2 +-
 arch/m68k/kernel/dma.c    |  2 +-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 4f3e7dec2171c..50ada24dfbbad 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,16 +6,16 @@ config M68K
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
-	select ARCH_HAS_DMA_ALLOC if !MMU || COLDFIRE
-	select ARCH_HAS_DMA_PREP_COHERENT if HAS_DMA && MMU && !COLDFIRE
-	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if HAS_DMA
+	select ARCH_HAS_DMA_ALLOC if M68K_NONCOHERENT_DMA && COLDFIRE
+	select ARCH_HAS_DMA_PREP_COHERENT if M68K_NONCOHERENT_DMA && !COLDFIRE
+	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if M68K_NONCOHERENT_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
 	select ARCH_NO_PREEMPT if !COLDFIRE
 	select ARCH_USE_MEMTEST if MMU_MOTOROLA
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BINFMT_FLAT_ARGVP_ENVP_ON_STACK
-	select DMA_DIRECT_REMAP if HAS_DMA && MMU && !COLDFIRE
+	select DMA_DIRECT_REMAP if M68K_NONCOHERENT_DMA && !COLDFIRE
 	select GENERIC_ATOMIC64
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IOMAP
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index b826e9c677b2a..ad69b466a08bd 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -535,3 +535,15 @@ config CACHE_COPYBACK
 	  The ColdFire CPU cache is set into Copy-back mode.
 endchoice
 endif # HAVE_CACHE_CB
+
+# Coldfire cores that do not have a data cache configured can do coherent DMA.
+config COLDFIRE_COHERENT_DMA
+	bool
+	default y
+	depends on COLDFIRE
+	depends on !HAVE_CACHE_CB && !CACHE_D && !CACHE_BOTH
+
+config M68K_NONCOHERENT_DMA
+	bool
+	default y
+	depends on HAS_DMA && !COLDFIRE_COHERENT_DMA
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index af015447dfb4c..01fb69a5095f4 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_MMU_MOTOROLA) += ints.o vectors.o
 obj-$(CONFIG_MMU_SUN3) += ints.o vectors.o
 obj-$(CONFIG_PCI) += pcibios.o
 
-obj-$(CONFIG_HAS_DMA)	+= dma.o
+obj-$(CONFIG_M68K_NONCOHERENT_DMA) += dma.o
 
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_BOOTINFO_PROC)	+= bootinfo_proc.o
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 2e192a5df949b..f83870cfa79b3 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -17,7 +17,7 @@
 
 #include <asm/cacheflush.h>
 
-#if defined(CONFIG_MMU) && !defined(CONFIG_COLDFIRE)
+#ifndef CONFIG_COLDFIRE
 void arch_dma_prep_coherent(struct page *page, size_t size)
 {
 	cache_push(page_to_phys(page), size);
-- 
2.53.0



