Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD6255797;
	Tue, 23 Jan 2024 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970100; cv=none; b=C51AezAgfp2E0bCwvisrYGR5NHnI1NNRqeAUpyaaWlur27JikGb4np9NBttJkgZ18orLhfTfLarp15NCKbVDpdR1Gy71OBHGPUv382xJhNtN8sBDVp1YmfiY2DgVkX7tT1hwWwknCrzKsmu0VXb1+/0BzS+vKjQzIyqatrEg/4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970100; c=relaxed/simple;
	bh=f51o+7MsNEyFDIbIlmNucRAxm2jKdXrJ8bElYzbH8rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1X8ZhApMpDuZSIKflOYTpnAQM3/jLEqyw0Y1C/ioNCAwSLcnIAMsXYXM9bDkSEaMGdACiNiHkDRgT/5o8c/YRP/xozkddOXnkPfYvR9NzVJY98kjLHcxGjdJCIRB9vm1zJsExSPaV/DMRKuBcUPysr/ZvGPiV1wCXyOXHj8r98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIua29Ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIua29Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7C6C433C7;
	Tue, 23 Jan 2024 00:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970100;
	bh=f51o+7MsNEyFDIbIlmNucRAxm2jKdXrJ8bElYzbH8rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIua29AePbg9JjKei3bOv5DHsP3m4WbPaIfcdKBYOCS9Tnm+MgXlq4w41aDfItRtN
	 YHnz3P9h7fEItuGYcf7Az7m7ZrXfcKJmyZoDPbCdYT8DhK2v6DblSN0HxwGZsQSSOH
	 NqE3pg3rLGXLHAQhkz3XG6zuL58rpmDuP82hogec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 580/641] s390/pci: fix max size calculation in zpci_memcpy_toio()
Date: Mon, 22 Jan 2024 15:58:04 -0800
Message-ID: <20240122235836.333450013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 80df7d6af7f6d229b34cf237b2cc9024c07111cd ]

The zpci_get_max_write_size() helper is used to determine the maximum
size a PCI store or load can use at a given __iomem address.

For the PCI block store the following restrictions apply:

1. The dst + len must not cross a 4K boundary in the (pseudo-)MMIO space
2. len must not exceed ZPCI_MAX_WRITE_SIZE
3. len must be a multiple of 8 bytes
4. The src address must be double word (8 byte) aligned
5. The dst address must be double word (8 byte) aligned

Otherwise only a normal PCI store which takes its src value from
a register can be used. For these PCI store restriction 1 still applies.
Similarly 1 also applies to PCI loads.

It turns out zpci_max_write_size() instead implements stricter
conditions which prevents PCI block stores from being used where they
can and should be used. In particular instead of conditions 4 and 5 it
wrongly enforces both dst and src to be size aligned. This indirectly
covers condition 1 but also prevents many legal PCI block stores.

On top of the functional shortcomings the zpci_get_max_write_size() is
misnamed as it is used for both read and write size calculations. Rename
it to zpci_get_max_io_size() and implement the listed conditions
explicitly.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: cd24834130ac ("s390/pci: base support")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
[agordeev@linux.ibm.com replaced spaces with tabs]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pci_io.h | 32 ++++++++++++++++++--------------
 arch/s390/pci/pci_mmio.c       | 12 ++++++------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
index 287bb88f7698..2686bee800e3 100644
--- a/arch/s390/include/asm/pci_io.h
+++ b/arch/s390/include/asm/pci_io.h
@@ -11,6 +11,8 @@
 /* I/O size constraints */
 #define ZPCI_MAX_READ_SIZE	8
 #define ZPCI_MAX_WRITE_SIZE	128
+#define ZPCI_BOUNDARY_SIZE	(1 << 12)
+#define ZPCI_BOUNDARY_MASK	(ZPCI_BOUNDARY_SIZE - 1)
 
 /* I/O Map */
 #define ZPCI_IOMAP_SHIFT		48
@@ -125,16 +127,18 @@ static inline int zpci_read_single(void *dst, const volatile void __iomem *src,
 int zpci_write_block(volatile void __iomem *dst, const void *src,
 		     unsigned long len);
 
-static inline u8 zpci_get_max_write_size(u64 src, u64 dst, int len, int max)
+static inline int zpci_get_max_io_size(u64 src, u64 dst, int len, int max)
 {
-	int count = len > max ? max : len, size = 1;
+	int offset = dst & ZPCI_BOUNDARY_MASK;
+	int size;
 
-	while (!(src & 0x1) && !(dst & 0x1) && ((size << 1) <= count)) {
-		dst = dst >> 1;
-		src = src >> 1;
-		size = size << 1;
-	}
-	return size;
+	size = min3(len, ZPCI_BOUNDARY_SIZE - offset, max);
+	if (IS_ALIGNED(src, 8) && IS_ALIGNED(dst, 8) && IS_ALIGNED(size, 8))
+		return size;
+
+	if (size >= 8)
+		return 8;
+	return rounddown_pow_of_two(size);
 }
 
 static inline int zpci_memcpy_fromio(void *dst,
@@ -144,9 +148,9 @@ static inline int zpci_memcpy_fromio(void *dst,
 	int size, rc = 0;
 
 	while (n > 0) {
-		size = zpci_get_max_write_size((u64 __force) src,
-					       (u64) dst, n,
-					       ZPCI_MAX_READ_SIZE);
+		size = zpci_get_max_io_size((u64 __force) src,
+					    (u64) dst, n,
+					    ZPCI_MAX_READ_SIZE);
 		rc = zpci_read_single(dst, src, size);
 		if (rc)
 			break;
@@ -166,9 +170,9 @@ static inline int zpci_memcpy_toio(volatile void __iomem *dst,
 		return -EINVAL;
 
 	while (n > 0) {
-		size = zpci_get_max_write_size((u64 __force) dst,
-					       (u64) src, n,
-					       ZPCI_MAX_WRITE_SIZE);
+		size = zpci_get_max_io_size((u64 __force) dst,
+					    (u64) src, n,
+					    ZPCI_MAX_WRITE_SIZE);
 		if (size > 8) /* main path */
 			rc = zpci_write_block(dst, src, size);
 		else
diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 588089332931..a90499c087f0 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -97,9 +97,9 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
 		return -EINVAL;
 
 	while (n > 0) {
-		size = zpci_get_max_write_size((u64 __force) dst,
-					       (u64 __force) src, n,
-					       ZPCI_MAX_WRITE_SIZE);
+		size = zpci_get_max_io_size((u64 __force) dst,
+					    (u64 __force) src, n,
+					    ZPCI_MAX_WRITE_SIZE);
 		if (size > 8) /* main path */
 			rc = __pcistb_mio_inuser(dst, src, size, &status);
 		else
@@ -242,9 +242,9 @@ static inline int __memcpy_fromio_inuser(void __user *dst,
 	u8 status;
 
 	while (n > 0) {
-		size = zpci_get_max_write_size((u64 __force) src,
-					       (u64 __force) dst, n,
-					       ZPCI_MAX_READ_SIZE);
+		size = zpci_get_max_io_size((u64 __force) src,
+					    (u64 __force) dst, n,
+					    ZPCI_MAX_READ_SIZE);
 		rc = __pcilg_mio_inuser(dst, src, size, &status);
 		if (rc)
 			break;
-- 
2.43.0



