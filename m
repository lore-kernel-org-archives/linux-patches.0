Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21962805;
	Tue, 23 Jan 2024 01:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975030; cv=none; b=MG9Snx8poMYh0JeopSjNEJOqHqNY8+UlVgTzqa7XLX6uTHxGjC2fkM52d1IC+5DjEsO38KeI39PPZafmKM4et4nTsrq/d+QoKjNsYvslndgO6Q0Vj+v0ltYnLBPYYayCP2aHVWB2D+ZJGZJnrDDzZlZEMra1KQlnbcpOA9MPW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975030; c=relaxed/simple;
	bh=yngeG27X1LEPyYXjilx9C9syLaph6erDp/iy0kZR7wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6K7JQGJ83XLn2u4YP6sUmkmn/mv49zLqe38bIzFUm63sI4VMXSD6m9h3HYEoSin+e87JBSGyCuCQKEeZoOd+PsytVHyeCv7QQtU5GvEF9qljQo4zeTG+qhxGyiskQS5EW7x7BUMgCwFEMFVbTMEWDxoGoKOb2rkpbxbJVsel0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMLvIsDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMLvIsDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E3AC43394;
	Tue, 23 Jan 2024 01:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975029;
	bh=yngeG27X1LEPyYXjilx9C9syLaph6erDp/iy0kZR7wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMLvIsDyIqMgERdvjFrFxxNAT1ep9ZvE/dN83Nanrs1xJcKzD7lQZosagzmRyz8Y3
	 biKpZo5rxDPP92VjQjiMfq3+12K7WZlEtYcmiLfsVNcS/kcYYudTQ/C9bsH3rKaZlM
	 dXlc4or46XSZ7Zxwyl1n1DRjkHPM2Qwqg9Zw0UPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/374] s390/pci: fix max size calculation in zpci_memcpy_toio()
Date: Mon, 22 Jan 2024 15:59:47 -0800
Message-ID: <20240122235756.410172765@linuxfoundation.org>
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
index b94163ee5632..7e4cb95a431c 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -96,9 +96,9 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
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
@@ -241,9 +241,9 @@ static inline int __memcpy_fromio_inuser(void __user *dst,
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



