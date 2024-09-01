Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B803183CC4;
	Sun,  1 Sep 2024 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207992; cv=none; b=Ks/q/zTK46vLR9hEuGrStMtaRJofu/xIcKMA0/ouKczH2lYYP5O/4C+VbRQk/DW4/Q5P2VxGXM4J2KgHdruJHvoAGnZLsaz99+AmFV0ANKuQOb8LRhP/1Flvkkn1G0DawS+H5NxINr8Ks3Q4uRvUeHr3G3oAyE+Lv15wC4pnMFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207992; c=relaxed/simple;
	bh=84aHd2qO6C+6ZXSzKg0OQGFRxJ9gnx40ZfglbApCZHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qHkmm6dkZnCCwPeRf6Tvcp14pmEqhyFQuLpg7/Rp2VYaaT7wXLQvPCo6duDY5o0RMEWkFx6x4xr3UI3Zbwcl+8hn9upo4vB5F+6J/1OKG9NDeulr12WD1MMFYQZXZZtFoIkbKKG5sHxIMmjSLAQMzxSWtPNAXCABrqPOAlUmoS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeFzGpIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeFzGpIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75041C4CEC3;
	Sun,  1 Sep 2024 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207992;
	bh=84aHd2qO6C+6ZXSzKg0OQGFRxJ9gnx40ZfglbApCZHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeFzGpIAyfIGVGjutT+OdEMSYBbxRswIzdL+O9UCfGl8wzfG3vqs4vzoJnq8gFuHi
	 rfd0yJOupo6r7JUQA9IekXcCULF8I9Cikz60Oaw6e66HqbO2xWGrriBljidsmzLhcL
	 2o2iWxcBbu4KB/ByOl1Xbjsj6S2CiHZvhb3zAe/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <keescook@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Benno Lossin <benno.lossin@proton.me>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Christoph Lameter <cl@linux.com>,
	Dennis Zhou <dennis@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/93] Revert "change alloc_pages name in dma_map_ops to avoid name conflicts"
Date: Sun,  1 Sep 2024 18:16:28 +0200
Message-ID: <20240901160808.908613948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 983e6b2636f0099dbac1874c9e885bbe1cf2df05 which is
commit 8a2f11878771da65b8ac135c73b47dae13afbd62 upstream.

It wasn't needed and caused a build break on s390, so just revert it
entirely.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240830221217.GA3837758@thelio-3990X
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/pci_iommu.c           |    2 +-
 arch/mips/jazz/jazzdma.c                |    2 +-
 arch/powerpc/kernel/dma-iommu.c         |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
 arch/powerpc/platforms/pseries/vio.c    |    2 +-
 arch/x86/kernel/amd_gart_64.c           |    2 +-
 drivers/iommu/dma-iommu.c               |    2 +-
 drivers/parisc/ccio-dma.c               |    2 +-
 drivers/parisc/sba_iommu.c              |    2 +-
 drivers/xen/grant-dma-ops.c             |    2 +-
 drivers/xen/swiotlb-xen.c               |    2 +-
 include/linux/dma-map-ops.h             |    2 +-
 kernel/dma/mapping.c                    |    4 ++--
 13 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -929,7 +929,7 @@ const struct dma_map_ops alpha_pci_ops =
 	.dma_supported		= alpha_pci_supported,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages_op		= dma_common_alloc_pages,
+	.alloc_pages		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(alpha_pci_ops);
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -617,7 +617,7 @@ const struct dma_map_ops jazz_dma_ops =
 	.sync_sg_for_device	= jazz_dma_sync_sg_for_device,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages_op		= dma_common_alloc_pages,
+	.alloc_pages		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(jazz_dma_ops);
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -216,6 +216,6 @@ const struct dma_map_ops dma_iommu_ops =
 	.get_required_mask	= dma_iommu_get_required_mask,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages_op		= dma_common_alloc_pages,
+	.alloc_pages		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -695,7 +695,7 @@ static const struct dma_map_ops ps3_sb_d
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages_op = dma_common_alloc_pages,
+	.alloc_pages = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 };
 
@@ -709,7 +709,7 @@ static const struct dma_map_ops ps3_ioc0
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages_op = dma_common_alloc_pages,
+	.alloc_pages = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 };
 
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -611,7 +611,7 @@ static const struct dma_map_ops vio_dma_
 	.get_required_mask = dma_iommu_get_required_mask,
 	.mmap		   = dma_common_mmap,
 	.get_sgtable	   = dma_common_get_sgtable,
-	.alloc_pages_op	   = dma_common_alloc_pages,
+	.alloc_pages	   = dma_common_alloc_pages,
 	.free_pages	   = dma_common_free_pages,
 };
 
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -676,7 +676,7 @@ static const struct dma_map_ops gart_dma
 	.get_sgtable			= dma_common_get_sgtable,
 	.dma_supported			= dma_direct_supported,
 	.get_required_mask		= dma_direct_get_required_mask,
-	.alloc_pages_op			= dma_direct_alloc_pages,
+	.alloc_pages			= dma_direct_alloc_pages,
 	.free_pages			= dma_direct_free_pages,
 };
 
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1614,7 +1614,7 @@ static const struct dma_map_ops iommu_dm
 	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
 	.alloc			= iommu_dma_alloc,
 	.free			= iommu_dma_free,
-	.alloc_pages_op		= dma_common_alloc_pages,
+	.alloc_pages		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
 	.free_noncontiguous	= iommu_dma_free_noncontiguous,
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1022,7 +1022,7 @@ static const struct dma_map_ops ccio_ops
 	.map_sg =		ccio_map_sg,
 	.unmap_sg =		ccio_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
-	.alloc_pages_op =	dma_common_alloc_pages,
+	.alloc_pages =		dma_common_alloc_pages,
 	.free_pages =		dma_common_free_pages,
 };
 
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1090,7 +1090,7 @@ static const struct dma_map_ops sba_ops
 	.map_sg =		sba_map_sg,
 	.unmap_sg =		sba_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
-	.alloc_pages_op =	dma_common_alloc_pages,
+	.alloc_pages =		dma_common_alloc_pages,
 	.free_pages =		dma_common_free_pages,
 };
 
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -282,7 +282,7 @@ static int xen_grant_dma_supported(struc
 static const struct dma_map_ops xen_grant_dma_ops = {
 	.alloc = xen_grant_dma_alloc,
 	.free = xen_grant_dma_free,
-	.alloc_pages_op = xen_grant_dma_alloc_pages,
+	.alloc_pages = xen_grant_dma_alloc_pages,
 	.free_pages = xen_grant_dma_free_pages,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -403,7 +403,7 @@ const struct dma_map_ops xen_swiotlb_dma
 	.dma_supported = xen_swiotlb_dma_supported,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages_op = dma_common_alloc_pages,
+	.alloc_pages = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
 };
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -28,7 +28,7 @@ struct dma_map_ops {
 			unsigned long attrs);
 	void (*free)(struct device *dev, size_t size, void *vaddr,
 			dma_addr_t dma_handle, unsigned long attrs);
-	struct page *(*alloc_pages_op)(struct device *dev, size_t size,
+	struct page *(*alloc_pages)(struct device *dev, size_t size,
 			dma_addr_t *dma_handle, enum dma_data_direction dir,
 			gfp_t gfp);
 	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -570,9 +570,9 @@ static struct page *__dma_alloc_pages(st
 	size = PAGE_ALIGN(size);
 	if (dma_alloc_direct(dev, ops))
 		return dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
-	if (!ops->alloc_pages_op)
+	if (!ops->alloc_pages)
 		return NULL;
-	return ops->alloc_pages_op(dev, size, dma_handle, dir, gfp);
+	return ops->alloc_pages(dev, size, dma_handle, dir, gfp);
 }
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,


