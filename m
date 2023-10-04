Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD220B02
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtVwUIFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB70C433C8;
	Wed,  4 Oct 2023 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444205;
	bh=IgEx5HamdR60w5BstmZ6AGr/LgHCJ0N9E6JMcy2JMOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtVwUIFhHu5RlDq96YviJszKiwCJRxz5GWIHE8/pdte4G5hO98/eFVK1r0Qn0mxr5
	 iRHSfYVqd6tfIFXdGjVpM5YppLNyR1+lQ5TXx/N6bRhE2v3GrubTgRsXZlgo7J9iJV
	 MHAjG4mYT+ZjyeVrvzZJF9xX+2I5Xt/gdurE8vHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 167/321] parisc: sba-iommu: Fix sparse warnigs
Date: Wed,  4 Oct 2023 19:55:12 +0200
Message-ID: <20231004175237.001743290@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit c1ebb94071cb4455177bafa619423acb3494d15d ]

Fix sparse warnings, as pdir is __le64 *.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/ropes.h |  4 ++--
 drivers/parisc/iommu-helpers.h  |  4 ++--
 drivers/parisc/sba_iommu.c      | 28 ++++++++++++++--------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/parisc/include/asm/ropes.h b/arch/parisc/include/asm/ropes.h
index 62399c7ea94a1..c46ad399a74f2 100644
--- a/arch/parisc/include/asm/ropes.h
+++ b/arch/parisc/include/asm/ropes.h
@@ -29,7 +29,7 @@
 struct ioc {
 	void __iomem	*ioc_hpa;	/* I/O MMU base address */
 	char		*res_map;	/* resource map, bit == pdir entry */
-	u64		*pdir_base;	/* physical base address */
+	__le64		*pdir_base;	/* physical base address */
 	unsigned long	ibase;		/* pdir IOV Space base - shared w/lba_pci */
 	unsigned long	imask;		/* pdir IOV Space mask - shared w/lba_pci */
 #ifdef ZX1_SUPPORT
@@ -113,7 +113,7 @@ static inline int IS_PLUTO(struct parisc_device *d) {
 
 #define SBA_PDIR_VALID_BIT	0x8000000000000000ULL
 
-#define SBA_AGPGART_COOKIE	0x0000badbadc0ffeeULL
+#define SBA_AGPGART_COOKIE	(__force __le64) 0x0000badbadc0ffeeULL
 
 #define SBA_FUNC_ID	0x0000	/* function id */
 #define SBA_FCLASS	0x0008	/* function class, bist, header, rev... */
diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index 0905be256de08..a00c38b6224ab 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -14,13 +14,13 @@
 static inline unsigned int
 iommu_fill_pdir(struct ioc *ioc, struct scatterlist *startsg, int nents, 
 		unsigned long hint,
-		void (*iommu_io_pdir_entry)(u64 *, space_t, unsigned long,
+		void (*iommu_io_pdir_entry)(__le64 *, space_t, unsigned long,
 					    unsigned long))
 {
 	struct scatterlist *dma_sg = startsg;	/* pointer to current DMA */
 	unsigned int n_mappings = 0;
 	unsigned long dma_offset = 0, dma_len = 0;
-	u64 *pdirp = NULL;
+	__le64 *pdirp = NULL;
 
 	/* Horrible hack.  For efficiency's sake, dma_sg starts one 
 	 * entry below the true start (it is immediately incremented
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index b8e91cbb60567..780ea219cd8d4 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -202,7 +202,7 @@ static void
 sba_dump_pdir_entry(struct ioc *ioc, char *msg, uint pide)
 {
 	/* start printing from lowest pde in rval */
-	u64 *ptr = &(ioc->pdir_base[pide & (~0U * BITS_PER_LONG)]);
+	__le64 *ptr = &(ioc->pdir_base[pide & (~0U * BITS_PER_LONG)]);
 	unsigned long *rptr = (unsigned long *) &(ioc->res_map[(pide >>3) & ~(sizeof(unsigned long) - 1)]);
 	uint rcnt;
 
@@ -569,7 +569,7 @@ typedef unsigned long space_t;
  */
 
 static void
-sba_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
+sba_io_pdir_entry(__le64 *pdir_ptr, space_t sid, unsigned long vba,
 		  unsigned long hint)
 {
 	u64 pa; /* physical address */
@@ -613,7 +613,7 @@ static void
 sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
 {
 	u32 iovp = (u32) SBA_IOVP(ioc,iova);
-	u64 *pdir_ptr = &ioc->pdir_base[PDIR_INDEX(iovp)];
+	__le64 *pdir_ptr = &ioc->pdir_base[PDIR_INDEX(iovp)];
 
 #ifdef ASSERT_PDIR_SANITY
 	/* Assert first pdir entry is set.
@@ -714,7 +714,7 @@ sba_map_single(struct device *dev, void *addr, size_t size,
 	unsigned long flags; 
 	dma_addr_t iovp;
 	dma_addr_t offset;
-	u64 *pdir_start;
+	__le64 *pdir_start;
 	int pide;
 
 	ioc = GET_IOC(dev);
@@ -1432,7 +1432,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 
 	ioc->pdir_size = pdir_size = (iova_space_size/IOVP_SIZE) * sizeof(u64);
 
-	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
+	DBG_INIT("%s() hpa %px mem %ldMB IOV %dMB (%d bits)\n",
 			__func__,
 			ioc->ioc_hpa,
 			(unsigned long) totalram_pages() >> (20 - PAGE_SHIFT),
@@ -1469,7 +1469,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	ioc->iovp_mask = ~(iova_space_mask + PAGE_SIZE - 1);
 #endif
 
-	DBG_INIT("%s() IOV base 0x%lx mask 0x%0lx\n",
+	DBG_INIT("%s() IOV base %#lx mask %#0lx\n",
 		__func__, ioc->ibase, ioc->imask);
 
 	/*
@@ -1581,7 +1581,7 @@ printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.hpa,
 
 	if (!IS_PLUTO(sba_dev->dev)) {
 		ioc_ctl = READ_REG(sba_dev->sba_hpa+IOC_CTRL);
-		DBG_INIT("%s() hpa 0x%lx ioc_ctl 0x%Lx ->",
+		DBG_INIT("%s() hpa %px ioc_ctl 0x%Lx ->",
 			__func__, sba_dev->sba_hpa, ioc_ctl);
 		ioc_ctl &= ~(IOC_CTRL_RM | IOC_CTRL_NC | IOC_CTRL_CE);
 		ioc_ctl |= IOC_CTRL_DD | IOC_CTRL_D4 | IOC_CTRL_TC;
@@ -1666,14 +1666,14 @@ printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.hpa,
 		/* flush out the last writes */
 		READ_REG(sba_dev->ioc[i].ioc_hpa + ROPE7_CTL);
 
-		DBG_INIT("	ioc[%d] ROPE_CFG 0x%Lx  ROPE_DBG 0x%Lx\n",
+		DBG_INIT("	ioc[%d] ROPE_CFG %#lx  ROPE_DBG %lx\n",
 				i,
-				READ_REG(sba_dev->ioc[i].ioc_hpa + 0x40),
-				READ_REG(sba_dev->ioc[i].ioc_hpa + 0x50)
+				(unsigned long) READ_REG(sba_dev->ioc[i].ioc_hpa + 0x40),
+				(unsigned long) READ_REG(sba_dev->ioc[i].ioc_hpa + 0x50)
 			);
-		DBG_INIT("	STATUS_CONTROL 0x%Lx  FLUSH_CTRL 0x%Lx\n",
-				READ_REG(sba_dev->ioc[i].ioc_hpa + 0x108),
-				READ_REG(sba_dev->ioc[i].ioc_hpa + 0x400)
+		DBG_INIT("	STATUS_CONTROL %#lx  FLUSH_CTRL %#lx\n",
+				(unsigned long) READ_REG(sba_dev->ioc[i].ioc_hpa + 0x108),
+				(unsigned long) READ_REG(sba_dev->ioc[i].ioc_hpa + 0x400)
 			);
 
 		if (IS_PLUTO(sba_dev->dev)) {
@@ -1737,7 +1737,7 @@ sba_common_init(struct sba_device *sba_dev)
 #ifdef ASSERT_PDIR_SANITY
 		/* Mark first bit busy - ie no IOVA 0 */
 		sba_dev->ioc[i].res_map[0] = 0x80;
-		sba_dev->ioc[i].pdir_base[0] = 0xeeffc0addbba0080ULL;
+		sba_dev->ioc[i].pdir_base[0] = (__force __le64) 0xeeffc0addbba0080ULL;
 #endif
 
 		/* Third (and last) part of PIRANHA BUG */
-- 
2.40.1



