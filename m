Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D401222D72;
	Thu, 12 Dec 2024 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022641; cv=none; b=ORho0IkY3dqcsKlwwRv8c5MEOhWlfZ/P6tiHugyKdyppSWdwsMObJH8s5CG4QnkzAXd3k0K8LsX/49+814L71sQEKHtZYZGhsVp1iYJJJUyRIFfZz9aTtPH52Qzc7JLb0rs50/czPb90H1sxrM5K0AyZlZDK40ccIrnsqAcBVA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022641; c=relaxed/simple;
	bh=hgdmElRG8eb2rSYzLsvKD5aK3wQz1qJLapz+pGN3iSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnN7Bq1yOdFvVK2J9aD7B+RM9WNlqijvrcg79UJmlSaQiJVPObcHRWUwBht4RpRLZqZzUiV/LrRf5z9cdBCpAWgw1mihjbveeQ5hgBYC44BvLUzV63qOk4Q1ZgwKYW8IrmM5dNpGKcmZaagog6H6uXbGvLitnBPa/ooMZlWYsh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HebiCY56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HebiCY56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19049C4CECE;
	Thu, 12 Dec 2024 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022637;
	bh=hgdmElRG8eb2rSYzLsvKD5aK3wQz1qJLapz+pGN3iSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HebiCY56JglDUoK+wYqRPvsC/IEBFchBJEFtGpv143ZjVEM5xst8ayv8cIAX3Hb+M
	 3tDzlVishBy6SI17L7q6y0pESUsWCQICr4/Zl3SpF3cxCrRTBVvsNmqRSQN/1kYhZZ
	 57hr/vMlLO73y3R7BDmhujxp74onp+puIlBTznYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Mingli Yu <mingli.yu@windriver.com>
Subject: [PATCH 5.15 295/565] parisc: fix a possible DMA corruption
Date: Thu, 12 Dec 2024 15:58:10 +0100
Message-ID: <20241212144323.124874687@linuxfoundation.org>
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
Signed-off-by: Mingli Yu <mingli.yu@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig             |    1 +
 arch/parisc/include/asm/cache.h |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,6 +15,7 @@ config PARISC
 	select ARCH_SPLIT_ARG64 if !64BIT
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
+	select ARCH_HAS_CACHE_LINE_SIZE
 	select DMA_OPS
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
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
 


