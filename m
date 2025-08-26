Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D034A32D;
	Tue, 26 Aug 2025 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217054; cv=none; b=fYp/IvEX6xlp8I44nAEiAx20kBjyCMqXL9pXDbNJwf9bOZrnbSxIXlbdZb3daFbMpSzbCzkjWXrzZMX8EB0qsM3BZ9ETPnsNq4W70qUS7qHSIfpVba375UvSHKiMfTAoWanM07OZeHes91rcToARGHnZZ4gmD4i8vIinnABjh9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217054; c=relaxed/simple;
	bh=xVQqc7a0Nhyr/AxlYeBNtH09zNWh1q5C2LJ6eAWAzv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwhqzlQzg6oeX+tGCNOXVnVxnmO2O9ApJoshKgqKIk3PIBZULSEjs4GIqCtZp2fyFJo1h4WGxUZbRxOFBBTn59tihf1Kl9i5hO4PySIPOI9HahSHzsV2YN+R1UzjJvn2ZUBA3o6GNHuvQ5BpeRmJkUfSH7bXP5z80gZev83FuWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqfV+Q1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqfV+Q1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526B6C4CEF1;
	Tue, 26 Aug 2025 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217054;
	bh=xVQqc7a0Nhyr/AxlYeBNtH09zNWh1q5C2LJ6eAWAzv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqfV+Q1d04y1KvbTUeBDUUA5nHO8XHtWBNFvfu+eozrny/mwtsDGQr3CU1/DrkR02
	 9HuMqB9tnqrkWXYntaSXTsIvTButUqT24BkNSDM8u9Sqj9qc+v2XJNTANKrKJOMvWN
	 /UosYRWK+b5IM3oRx3LDNY/IInbCSTvRt1iTlwMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Marco Elver <elver@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 601/644] asm-generic: Add memory barrier dma_mb()
Date: Tue, 26 Aug 2025 13:11:32 +0200
Message-ID: <20250826111001.440298952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit ed59dfd9509d172e4920994ed9cbebf93b0050cc ]

The memory barrier dma_mb() is introduced by commit a76a37777f2c
("iommu/arm-smmu-v3: Ensure queue is read after updating prod pointer"),
which is used to ensure that prior (both reads and writes) accesses
to memory by a CPU are ordered w.r.t. a subsequent MMIO write.

Reviewed-by: Arnd Bergmann <arnd@arndb.de> # for asm-generic
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20220523113126.171714-2-wangkefeng.wang@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: aa6956150f82 ("wifi: ath11k: fix dest ring-buffer corruption when ring is full")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/memory-barriers.txt |   11 ++++++-----
 include/asm-generic/barrier.h     |    8 ++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1894,6 +1894,7 @@ There are some more advanced barrier fun
 
  (*) dma_wmb();
  (*) dma_rmb();
+ (*) dma_mb();
 
      These are for use with consistent memory to guarantee the ordering
      of writes or reads of shared memory accessible to both the CPU and a
@@ -1925,11 +1926,11 @@ There are some more advanced barrier fun
      The dma_rmb() allows us guarantee the device has released ownership
      before we read the data from the descriptor, and the dma_wmb() allows
      us to guarantee the data is written to the descriptor before the device
-     can see it now has ownership.  Note that, when using writel(), a prior
-     wmb() is not needed to guarantee that the cache coherent memory writes
-     have completed before writing to the MMIO region.  The cheaper
-     writel_relaxed() does not provide this guarantee and must not be used
-     here.
+     can see it now has ownership.  The dma_mb() implies both a dma_rmb() and
+     a dma_wmb().  Note that, when using writel(), a prior wmb() is not needed
+     to guarantee that the cache coherent memory writes have completed before
+     writing to the MMIO region.  The cheaper writel_relaxed() does not provide
+     this guarantee and must not be used here.
 
      See the subsection "Kernel I/O barrier effects" for more information on
      relaxed I/O accessors and the Documentation/core-api/dma-api.rst file for
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -37,6 +37,10 @@
 #define wmb()	do { kcsan_wmb(); __wmb(); } while (0)
 #endif
 
+#ifdef __dma_mb
+#define dma_mb()	do { kcsan_mb(); __dma_mb(); } while (0)
+#endif
+
 #ifdef __dma_rmb
 #define dma_rmb()	do { kcsan_rmb(); __dma_rmb(); } while (0)
 #endif
@@ -64,6 +68,10 @@
 #define wmb()	mb()
 #endif
 
+#ifndef dma_mb
+#define dma_mb()	mb()
+#endif
+
 #ifndef dma_rmb
 #define dma_rmb()	rmb()
 #endif


