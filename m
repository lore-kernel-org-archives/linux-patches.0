Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC97A14AA9;
	Mon, 14 Oct 2024 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920139; cv=none; b=f4/oiUk2aEFYPadJpVHSRSOCo3jewjVqZXxR0YGv2OlYP4R0a56osEnuXKCCQagTblJYuEEkyzrjbsa2R11jaESkjd7w/nJPrBk84rIxKNqP7YHg9cPgudj7HC9WhWpPecdvfft4MmcdgayxX1jdHfmifXB+6PzmK/QxzYDqu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920139; c=relaxed/simple;
	bh=isl9Pr3ONaP2RdEbpHq7+ypu2m+gM+nc1phOqKd9EK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIBECIx//1HxrwhwkKBJdwDT4Tbpo+YC6SsRDrT5FQHms7NxQWt2tpRmUHp1UUM5kKVqG8zEZb4LeItUYfkbLOmZ5/nar0vgBBW7hQSD1APlWDXubqrg76BQYMzOFQKmbi1caQitacWskivWyvHVK9Pw8kwIFrJuVgPtM7iB3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRANtplL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRANtplL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9395C4CEC3;
	Mon, 14 Oct 2024 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920139;
	bh=isl9Pr3ONaP2RdEbpHq7+ypu2m+gM+nc1phOqKd9EK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRANtplLHycTAOn9YpTkaYhjPTZiwT4IRS67lkTJq67uotPTZxCJHsWbtArDCGdpi
	 u9OUSDW60yBPmChL6cUWnxFDy0/9x8byE79guTD4+DQTRAGE3ta2mxxuWAQmg5j78R
	 WFlo7T0IH1nBXKus/pqDwBJAG8lMpEBiaw40mYYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 6.1 798/798] Revert "iommu/vt-d: Retrieve IOMMU perfmon capability information"
Date: Mon, 14 Oct 2024 16:22:32 +0200
Message-ID: <20241014141249.421708591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

This reverts commit 586e19c88a0cb58b6ff45ae085b3dd200d862153 which is
commit a6a5006dad572a53b5df3f47e1471d207ae9ba49 upstream.

This commit is pulled in due to dependency for:
8c91a4bfc7f8 ("iommu: Fix compilation without CONFIG_IOMMU_INTEL")

But the patch itself is part of a patchset, should not only include one,
and it lead to boot hang on on Kernel 6.1.83+ with Dell PowerEdge R770
and Intel Xeon 6710E, so revert it for stable 6.1.112

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/Kconfig   |   11 --
 drivers/iommu/intel/Makefile  |    1 
 drivers/iommu/intel/dmar.c    |    7 -
 drivers/iommu/intel/iommu.h   |   43 ----------
 drivers/iommu/intel/perfmon.c |  172 ------------------------------------------
 drivers/iommu/intel/perfmon.h |   40 ---------
 6 files changed, 1 insertion(+), 273 deletions(-)
 delete mode 100644 drivers/iommu/intel/perfmon.c
 delete mode 100644 drivers/iommu/intel/perfmon.h

--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -96,15 +96,4 @@ config INTEL_IOMMU_SCALABLE_MODE_DEFAULT
 	  passing intel_iommu=sm_on to the kernel. If not sure, please use
 	  the default value.
 
-config INTEL_IOMMU_PERF_EVENTS
-	def_bool y
-	bool "Intel IOMMU performance events"
-	depends on INTEL_IOMMU && PERF_EVENTS
-	help
-	  Selecting this option will enable the performance monitoring
-	  infrastructure in the Intel IOMMU. It collects information about
-	  key events occurring during operation of the remapping hardware,
-	  to aid performance tuning and debug. These are available on modern
-	  processors which support Intel VT-d 4.0 and later.
-
 endif # INTEL_IOMMU
--- a/drivers/iommu/intel/Makefile
+++ b/drivers/iommu/intel/Makefile
@@ -8,4 +8,3 @@ obj-$(CONFIG_INTEL_IOMMU_SVM) += svm.o
 ifdef CONFIG_INTEL_IOMMU
 obj-$(CONFIG_IRQ_REMAP) += irq_remapping.o
 endif
-obj-$(CONFIG_INTEL_IOMMU_PERF_EVENTS) += perfmon.o
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -34,7 +34,6 @@
 #include "../irq_remapping.h"
 #include "perf.h"
 #include "trace.h"
-#include "perfmon.h"
 
 typedef int (*dmar_res_handler_t)(struct acpi_dmar_header *, void *);
 struct dmar_res_callback {
@@ -1105,9 +1104,6 @@ static int alloc_iommu(struct dmar_drhd_
 	if (sts & DMA_GSTS_QIES)
 		iommu->gcmd |= DMA_GCMD_QIE;
 
-	if (alloc_iommu_pmu(iommu))
-		pr_debug("Cannot alloc PMU for iommu (seq_id = %d)\n", iommu->seq_id);
-
 	raw_spin_lock_init(&iommu->register_lock);
 
 	/*
@@ -1135,7 +1131,6 @@ static int alloc_iommu(struct dmar_drhd_
 err_sysfs:
 	iommu_device_sysfs_remove(&iommu->iommu);
 err_unmap:
-	free_iommu_pmu(iommu);
 	unmap_iommu(iommu);
 error_free_seq_id:
 	ida_free(&dmar_seq_ids, iommu->seq_id);
@@ -1151,8 +1146,6 @@ static void free_iommu(struct intel_iomm
 		iommu_device_sysfs_remove(&iommu->iommu);
 	}
 
-	free_iommu_pmu(iommu);
-
 	if (iommu->irq) {
 		if (iommu->pr_irq) {
 			free_irq(iommu->pr_irq, iommu);
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -125,11 +125,6 @@
 #define DMAR_MTRR_PHYSMASK8_REG 0x208
 #define DMAR_MTRR_PHYSBASE9_REG 0x210
 #define DMAR_MTRR_PHYSMASK9_REG 0x218
-#define DMAR_PERFCAP_REG	0x300
-#define DMAR_PERFCFGOFF_REG	0x310
-#define DMAR_PERFOVFOFF_REG	0x318
-#define DMAR_PERFCNTROFF_REG	0x31c
-#define DMAR_PERFEVNTCAP_REG	0x380
 #define DMAR_VCCAP_REG		0xe30 /* Virtual command capability register */
 #define DMAR_VCMD_REG		0xe00 /* Virtual command register */
 #define DMAR_VCRSP_REG		0xe10 /* Virtual command response register */
@@ -153,7 +148,6 @@
  */
 #define cap_esrtps(c)		(((c) >> 63) & 1)
 #define cap_esirtps(c)		(((c) >> 62) & 1)
-#define cap_ecmds(c)		(((c) >> 61) & 1)
 #define cap_fl5lp_support(c)	(((c) >> 60) & 1)
 #define cap_pi_support(c)	(((c) >> 59) & 1)
 #define cap_fl1gp_support(c)	(((c) >> 56) & 1)
@@ -185,8 +179,7 @@
  * Extended Capability Register
  */
 
-#define ecap_pms(e)		(((e) >> 51) & 0x1)
-#define ecap_rps(e)		(((e) >> 49) & 0x1)
+#define	ecap_rps(e)		(((e) >> 49) & 0x1)
 #define ecap_smpwc(e)		(((e) >> 48) & 0x1)
 #define ecap_flts(e)		(((e) >> 47) & 0x1)
 #define ecap_slts(e)		(((e) >> 46) & 0x1)
@@ -217,22 +210,6 @@
 #define ecap_max_handle_mask(e) (((e) >> 20) & 0xf)
 #define ecap_sc_support(e)	(((e) >> 7) & 0x1) /* Snooping Control */
 
-/*
- * Decoding Perf Capability Register
- */
-#define pcap_num_cntr(p)	((p) & 0xffff)
-#define pcap_cntr_width(p)	(((p) >> 16) & 0x7f)
-#define pcap_num_event_group(p)	(((p) >> 24) & 0x1f)
-#define pcap_filters_mask(p)	(((p) >> 32) & 0x1f)
-#define pcap_interrupt(p)	(((p) >> 50) & 0x1)
-/* The counter stride is calculated as 2 ^ (x+10) bytes */
-#define pcap_cntr_stride(p)	(1ULL << ((((p) >> 52) & 0x7) + 10))
-
-/*
- * Decoding Perf Event Capability Register
- */
-#define pecap_es(p)		((p) & 0xfffffff)
-
 /* Virtual command interface capability */
 #define vccap_pasid(v)		(((v) & DMA_VCS_PAS)) /* PASID allocation */
 
@@ -584,22 +561,6 @@ struct dmar_domain {
 					   iommu core */
 };
 
-struct iommu_pmu {
-	struct intel_iommu	*iommu;
-	u32			num_cntr;	/* Number of counters */
-	u32			num_eg;		/* Number of event group */
-	u32			cntr_width;	/* Counter width */
-	u32			cntr_stride;	/* Counter Stride */
-	u32			filter;		/* Bitmask of filter support */
-	void __iomem		*base;		/* the PerfMon base address */
-	void __iomem		*cfg_reg;	/* counter configuration base address */
-	void __iomem		*cntr_reg;	/* counter 0 address*/
-	void __iomem		*overflow;	/* overflow status register */
-
-	u64			*evcap;		/* Indicates all supported events */
-	u32			**cntr_evcap;	/* Supported events of each counter. */
-};
-
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64 		reg_phys; /* physical address of hw register set */
@@ -647,8 +608,6 @@ struct intel_iommu {
 
 	struct dmar_drhd_unit *drhd;
 	void *perf_statistic;
-
-	struct iommu_pmu *pmu;
 };
 
 /* PCI domain-device relationship */
--- a/drivers/iommu/intel/perfmon.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Support Intel IOMMU PerfMon
- * Copyright(c) 2023 Intel Corporation.
- */
-#define pr_fmt(fmt)	"DMAR: " fmt
-#define dev_fmt(fmt)	pr_fmt(fmt)
-
-#include <linux/dmar.h>
-#include "iommu.h"
-#include "perfmon.h"
-
-static inline void __iomem *
-get_perf_reg_address(struct intel_iommu *iommu, u32 offset)
-{
-	u32 off = dmar_readl(iommu->reg + offset);
-
-	return iommu->reg + off;
-}
-
-int alloc_iommu_pmu(struct intel_iommu *iommu)
-{
-	struct iommu_pmu *iommu_pmu;
-	int i, j, ret;
-	u64 perfcap;
-	u32 cap;
-
-	if (!ecap_pms(iommu->ecap))
-		return 0;
-
-	/* The IOMMU PMU requires the ECMD support as well */
-	if (!cap_ecmds(iommu->cap))
-		return -ENODEV;
-
-	perfcap = dmar_readq(iommu->reg + DMAR_PERFCAP_REG);
-	/* The performance monitoring is not supported. */
-	if (!perfcap)
-		return -ENODEV;
-
-	/* Sanity check for the number of the counters and event groups */
-	if (!pcap_num_cntr(perfcap) || !pcap_num_event_group(perfcap))
-		return -ENODEV;
-
-	/* The interrupt on overflow is required */
-	if (!pcap_interrupt(perfcap))
-		return -ENODEV;
-
-	iommu_pmu = kzalloc(sizeof(*iommu_pmu), GFP_KERNEL);
-	if (!iommu_pmu)
-		return -ENOMEM;
-
-	iommu_pmu->num_cntr = pcap_num_cntr(perfcap);
-	iommu_pmu->cntr_width = pcap_cntr_width(perfcap);
-	iommu_pmu->filter = pcap_filters_mask(perfcap);
-	iommu_pmu->cntr_stride = pcap_cntr_stride(perfcap);
-	iommu_pmu->num_eg = pcap_num_event_group(perfcap);
-
-	iommu_pmu->evcap = kcalloc(iommu_pmu->num_eg, sizeof(u64), GFP_KERNEL);
-	if (!iommu_pmu->evcap) {
-		ret = -ENOMEM;
-		goto free_pmu;
-	}
-
-	/* Parse event group capabilities */
-	for (i = 0; i < iommu_pmu->num_eg; i++) {
-		u64 pcap;
-
-		pcap = dmar_readq(iommu->reg + DMAR_PERFEVNTCAP_REG +
-				  i * IOMMU_PMU_CAP_REGS_STEP);
-		iommu_pmu->evcap[i] = pecap_es(pcap);
-	}
-
-	iommu_pmu->cntr_evcap = kcalloc(iommu_pmu->num_cntr, sizeof(u32 *), GFP_KERNEL);
-	if (!iommu_pmu->cntr_evcap) {
-		ret = -ENOMEM;
-		goto free_pmu_evcap;
-	}
-	for (i = 0; i < iommu_pmu->num_cntr; i++) {
-		iommu_pmu->cntr_evcap[i] = kcalloc(iommu_pmu->num_eg, sizeof(u32), GFP_KERNEL);
-		if (!iommu_pmu->cntr_evcap[i]) {
-			ret = -ENOMEM;
-			goto free_pmu_cntr_evcap;
-		}
-		/*
-		 * Set to the global capabilities, will adjust according
-		 * to per-counter capabilities later.
-		 */
-		for (j = 0; j < iommu_pmu->num_eg; j++)
-			iommu_pmu->cntr_evcap[i][j] = (u32)iommu_pmu->evcap[j];
-	}
-
-	iommu_pmu->cfg_reg = get_perf_reg_address(iommu, DMAR_PERFCFGOFF_REG);
-	iommu_pmu->cntr_reg = get_perf_reg_address(iommu, DMAR_PERFCNTROFF_REG);
-	iommu_pmu->overflow = get_perf_reg_address(iommu, DMAR_PERFOVFOFF_REG);
-
-	/*
-	 * Check per-counter capabilities. All counters should have the
-	 * same capabilities on Interrupt on Overflow Support and Counter
-	 * Width.
-	 */
-	for (i = 0; i < iommu_pmu->num_cntr; i++) {
-		cap = dmar_readl(iommu_pmu->cfg_reg +
-				 i * IOMMU_PMU_CFG_OFFSET +
-				 IOMMU_PMU_CFG_CNTRCAP_OFFSET);
-		if (!iommu_cntrcap_pcc(cap))
-			continue;
-
-		/*
-		 * It's possible that some counters have a different
-		 * capability because of e.g., HW bug. Check the corner
-		 * case here and simply drop those counters.
-		 */
-		if ((iommu_cntrcap_cw(cap) != iommu_pmu->cntr_width) ||
-		    !iommu_cntrcap_ios(cap)) {
-			iommu_pmu->num_cntr = i;
-			pr_warn("PMU counter capability inconsistent, counter number reduced to %d\n",
-				iommu_pmu->num_cntr);
-		}
-
-		/* Clear the pre-defined events group */
-		for (j = 0; j < iommu_pmu->num_eg; j++)
-			iommu_pmu->cntr_evcap[i][j] = 0;
-
-		/* Override with per-counter event capabilities */
-		for (j = 0; j < iommu_cntrcap_egcnt(cap); j++) {
-			cap = dmar_readl(iommu_pmu->cfg_reg + i * IOMMU_PMU_CFG_OFFSET +
-					 IOMMU_PMU_CFG_CNTREVCAP_OFFSET +
-					 (j * IOMMU_PMU_OFF_REGS_STEP));
-			iommu_pmu->cntr_evcap[i][iommu_event_group(cap)] = iommu_event_select(cap);
-			/*
-			 * Some events may only be supported by a specific counter.
-			 * Track them in the evcap as well.
-			 */
-			iommu_pmu->evcap[iommu_event_group(cap)] |= iommu_event_select(cap);
-		}
-	}
-
-	iommu_pmu->iommu = iommu;
-	iommu->pmu = iommu_pmu;
-
-	return 0;
-
-free_pmu_cntr_evcap:
-	for (i = 0; i < iommu_pmu->num_cntr; i++)
-		kfree(iommu_pmu->cntr_evcap[i]);
-	kfree(iommu_pmu->cntr_evcap);
-free_pmu_evcap:
-	kfree(iommu_pmu->evcap);
-free_pmu:
-	kfree(iommu_pmu);
-
-	return ret;
-}
-
-void free_iommu_pmu(struct intel_iommu *iommu)
-{
-	struct iommu_pmu *iommu_pmu = iommu->pmu;
-
-	if (!iommu_pmu)
-		return;
-
-	if (iommu_pmu->evcap) {
-		int i;
-
-		for (i = 0; i < iommu_pmu->num_cntr; i++)
-			kfree(iommu_pmu->cntr_evcap[i]);
-		kfree(iommu_pmu->cntr_evcap);
-	}
-	kfree(iommu_pmu->evcap);
-	kfree(iommu_pmu);
-	iommu->pmu = NULL;
-}
--- a/drivers/iommu/intel/perfmon.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-/*
- * PERFCFGOFF_REG, PERFFRZOFF_REG
- * PERFOVFOFF_REG, PERFCNTROFF_REG
- */
-#define IOMMU_PMU_NUM_OFF_REGS			4
-#define IOMMU_PMU_OFF_REGS_STEP			4
-
-#define IOMMU_PMU_CFG_OFFSET			0x100
-#define IOMMU_PMU_CFG_CNTRCAP_OFFSET		0x80
-#define IOMMU_PMU_CFG_CNTREVCAP_OFFSET		0x84
-#define IOMMU_PMU_CFG_SIZE			0x8
-#define IOMMU_PMU_CFG_FILTERS_OFFSET		0x4
-
-#define IOMMU_PMU_CAP_REGS_STEP			8
-
-#define iommu_cntrcap_pcc(p)			((p) & 0x1)
-#define iommu_cntrcap_cw(p)			(((p) >> 8) & 0xff)
-#define iommu_cntrcap_ios(p)			(((p) >> 16) & 0x1)
-#define iommu_cntrcap_egcnt(p)			(((p) >> 28) & 0xf)
-
-#define iommu_event_select(p)			((p) & 0xfffffff)
-#define iommu_event_group(p)			(((p) >> 28) & 0xf)
-
-#ifdef CONFIG_INTEL_IOMMU_PERF_EVENTS
-int alloc_iommu_pmu(struct intel_iommu *iommu);
-void free_iommu_pmu(struct intel_iommu *iommu);
-#else
-static inline int
-alloc_iommu_pmu(struct intel_iommu *iommu)
-{
-	return 0;
-}
-
-static inline void
-free_iommu_pmu(struct intel_iommu *iommu)
-{
-}
-#endif /* CONFIG_INTEL_IOMMU_PERF_EVENTS */


