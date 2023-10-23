Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B7912B7A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rc8z+TWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7AFC433C9;
	Mon, 23 Oct 2023 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059504;
	bh=SMqiwe/R0W1qufEzAd3AfelQbfqR0+GlAYO6R4GGduA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc8z+TWAbW+cvfvFH7MacEpiaJLgReMR4yHfO+xnR89CFfjc4Pddlm0B3oH5heO88
	 e8bj/l90CeKiIUV8veT3+KIvQWUH5mH5kgPWZ4FkvcKqkzVHTnq1zcIzYtbaJRxghM
	 jADkecFCll8c4ZPelmJvFBMmH1OZM++nxNZUrXKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.5 199/241] s390/pci: fix iommu bitmap allocation
Date: Mon, 23 Oct 2023 12:56:25 +0200
Message-ID: <20231023104838.716164201@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit c1ae1c59c8c6e0b66a718308c623e0cb394dab6b upstream.

Since the fixed commits both zdev->iommu_bitmap and zdev->lazy_bitmap
are allocated as vzalloc(zdev->iommu_pages / 8). The problem is that
zdev->iommu_bitmap is a pointer to unsigned long but the above only
yields an allocation that is a multiple of sizeof(unsigned long) which
is 8 on s390x if the number of IOMMU pages is a multiple of 64.
This in turn is the case only if the effective IOMMU aperture is
a multiple of 64 * 4K = 256K. This is usually the case and so didn't
cause visible issues since both the virt_to_phys(high_memory) reduced
limit and hardware limits use nice numbers.

Under KVM, and in particular with QEMU limiting the IOMMU aperture to
the vfio DMA limit (default 65535), it is possible for the reported
aperture not to be a multiple of 256K however. In this case we end up
with an iommu_bitmap whose allocation is not a multiple of
8 causing bitmap operations to access it out of bounds.

Sadly we can't just fix this in the obvious way and use bitmap_zalloc()
because for large RAM systems (tested on 8 TiB) the zdev->iommu_bitmap
grows too large for kmalloc(). So add our own bitmap_vzalloc() wrapper.
This might be a candidate for common code, but this area of code will
be replaced by the upcoming conversion to use the common code DMA API on
s390 so just add a local routine.

Fixes: 224593215525 ("s390/pci: use virtual memory for iommu bitmap")
Fixes: 13954fd6913a ("s390/pci_dma: improve lazy flush for unmap")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_dma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -564,6 +564,17 @@ static void s390_dma_unmap_sg(struct dev
 		s->dma_length = 0;
 	}
 }
+
+static unsigned long *bitmap_vzalloc(size_t bits, gfp_t flags)
+{
+	size_t n = BITS_TO_LONGS(bits);
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, sizeof(unsigned long), &bytes)))
+		return NULL;
+
+	return vzalloc(bytes);
+}
 	
 int zpci_dma_init_device(struct zpci_dev *zdev)
 {
@@ -604,13 +615,13 @@ int zpci_dma_init_device(struct zpci_dev
 				zdev->end_dma - zdev->start_dma + 1);
 	zdev->end_dma = zdev->start_dma + zdev->iommu_size - 1;
 	zdev->iommu_pages = zdev->iommu_size >> PAGE_SHIFT;
-	zdev->iommu_bitmap = vzalloc(zdev->iommu_pages / 8);
+	zdev->iommu_bitmap = bitmap_vzalloc(zdev->iommu_pages, GFP_KERNEL);
 	if (!zdev->iommu_bitmap) {
 		rc = -ENOMEM;
 		goto free_dma_table;
 	}
 	if (!s390_iommu_strict) {
-		zdev->lazy_bitmap = vzalloc(zdev->iommu_pages / 8);
+		zdev->lazy_bitmap = bitmap_vzalloc(zdev->iommu_pages, GFP_KERNEL);
 		if (!zdev->lazy_bitmap) {
 			rc = -ENOMEM;
 			goto free_bitmap;


