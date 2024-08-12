Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE8C1862B4;
	Mon, 12 Aug 2024 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479028; cv=none; b=VgPM2UuUHYyQl19iBOAaCP4xh34Irne92ezZWqlu7zMAyctzpea8T0rDd6ErPfQfjJKbe4eWU3vsKZ4r6ZoiS5O9vjbm9PjPNNVuuNw9uXxm4LVzJGmDi7Zi5xvFgCPc/FMFM12jCxIT0zp54e3h9+9eNqjhRgPK4TEDdKUOMik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479028; c=relaxed/simple;
	bh=jQsflMVP6GB3vFlm0vt5RrLF1BkhtatIZObXBz+NR3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud8cuMkMhyKmd97CGr5mpiiFzIniQziJSxA+5sqLXpj1k+3Rjk5PVnZLx3THW5JmdY82lgfBR6pDlL0aj6ZUZsYgbh5l2qmc0Iub07lItBTV7khfd7D/UYbwtfO+jKB3vhwBdmJNY6BWegnzen4c6sCLd4Yp3aq7GPQiuOvMFt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/6cdsIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/6cdsIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44645C32782;
	Mon, 12 Aug 2024 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479028;
	bh=jQsflMVP6GB3vFlm0vt5RrLF1BkhtatIZObXBz+NR3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/6cdsIYr9sqKb+ug/uMoZjrV3lSySnZod2uXjnMZjI65YZwMewk2VUgbM6pSwSLG
	 ExFOqHWp0ZSdJ1O8tMfCcBxIAURO6kDZ+BbwQ4Rm5PkL5KUfz4wQzghHAeufEdkgUF
	 pZiqwZonxRPaV7jwUJBs9j0FW2Y397KnxEclX0OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 110/150] parisc: fix a possible DMA corruption
Date: Mon, 12 Aug 2024 18:03:11 +0200
Message-ID: <20240812160129.406601927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
@@ -18,6 +18,7 @@ config PARISC
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
 


