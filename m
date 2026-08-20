Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8114E47F78D;
	Thu, 20 Aug 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248139; cv=none; b=iB9EV9Jdx/TY5R8sL7xueRiu6CE5FguDqFlZ3OkxAQPBlOfq+9OrHfQxCGaJNuV0J7fQEPX7KB2u1LECKOsS3dYneGnHcnFyMXuf/S9hw36VwxSnRdISFz1rhScfWE/+qODeIDjmXTAMBLqOMx+GQ+OgZCwI8vbVO3NexyGrMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248139; c=relaxed/simple;
	bh=cznscAtyfl8PJYR4/GTtio26JR4Ond98aC6Mf3b9Onk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+gB0vFZbcxkLeyHp50wynyiu/VBpg4xfd8/usnxIbRqyUgbFm9Vl0phL5QAOLZbqA6TSxUUWDs/PsnYLJDvLxNjtsvWS4wfKkUWgQvp/rtuGRUHwd7ULlOaomlRBBRg5PUc+nnEuAJtDKV0jNXH6vXcA1sj2kyczzb3jyqI8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8GZi4Dx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8GZi4Dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCA61F000E9;
	Thu, 20 Aug 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248137;
	bh=QqiH3qy8jm5ND+TQA8kv3sYZFlX27oOqv1fUZCipSP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8GZi4DxaVdFbaB50C/6KouEz2nOO2X/lOzMoyjOK815uaBibRkdClEI1t3E0BUB7
	 r5eW7/+MiemmAK0p4YnerYkZB6le7gMHxtSzEM0DN3ay/QE7bnRFCDRL9dFcaWX7Qg
	 0Y0PfHjz07sJ1F+Nek55fg43emTXIMIVCY1tLJA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Tarun Sahu <tsahu@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/303] mm/vmemmap/devdax: fix kernel crash when probing devdax devices
Date: Thu, 20 Aug 2026 16:54:19 +0200
Message-ID: <20260820145256.976960339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 87a7ae75d7383afa998f57656d1d14e2a730cc47 ]

commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for
compound devmaps") added support for using optimized vmmemap for devdax
devices.  But how vmemmap mappings are created are architecture specific.
For example, powerpc with hash translation doesn't have vmemmap mappings
in init_mm page table instead they are bolted table entries in the
hardware page table

vmemmap_populate_compound_pages() used by vmemmap optimization code is not
aware of these architecture-specific mapping.  Hence allow architecture to
opt for this feature.  I selected architectures supporting
HUGETLB_PAGE_OPTIMIZE_VMEMMAP option as also supporting this feature.

This patch fixes the below crash on ppc64.

BUG: Unable to handle kernel data access on write at 0xc00c000100400038
Faulting instruction address: 0xc000000001269d90
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in:
CPU: 7 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc5-150500.34-default+ #2 5c90a668b6bbd142599890245c2fb5de19d7d28a
Hardware name: IBM,9009-42G POWER9 (raw) 0x4e0202 0xf000005 of:IBM,FW950.40 (VL950_099) hv:phyp pSeries
NIP:  c000000001269d90 LR: c0000000004c57d4 CTR: 0000000000000000
REGS: c000000003632c30 TRAP: 0300   Not tainted  (6.3.0-rc5-150500.34-default+)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24842228  XER: 00000000
CFAR: c0000000004c57d0 DAR: c00c000100400038 DSISR: 42000000 IRQMASK: 0
....
NIP [c000000001269d90] __init_single_page.isra.74+0x14/0x4c
LR [c0000000004c57d4] __init_zone_device_page+0x44/0xd0
Call Trace:
[c000000003632ed0] [c000000003632f60] 0xc000000003632f60 (unreliable)
[c000000003632f10] [c0000000004c5ca0] memmap_init_zone_device+0x170/0x250
[c000000003632fe0] [c0000000005575f8] memremap_pages+0x2c8/0x7f0
[c0000000036330c0] [c000000000557b5c] devm_memremap_pages+0x3c/0xa0
[c000000003633100] [c000000000d458a8] dev_dax_probe+0x108/0x3e0
[c0000000036331a0] [c000000000d41430] dax_bus_probe+0xb0/0x140
[c0000000036331d0] [c000000000cef27c] really_probe+0x19c/0x520
[c000000003633260] [c000000000cef6b4] __driver_probe_device+0xb4/0x230
[c0000000036332e0] [c000000000cef888] driver_probe_device+0x58/0x120
[c000000003633320] [c000000000cefa6c] __device_attach_driver+0x11c/0x1e0
[c0000000036333a0] [c000000000cebc58] bus_for_each_drv+0xa8/0x130
[c000000003633400] [c000000000ceefcc] __device_attach+0x15c/0x250
[c0000000036334a0] [c000000000ced458] bus_probe_device+0x108/0x110
[c0000000036334f0] [c000000000ce92dc] device_add+0x7fc/0xa10
[c0000000036335b0] [c000000000d447c8] devm_create_dev_dax+0x1d8/0x530
[c000000003633640] [c000000000d46b60] __dax_pmem_probe+0x200/0x270
[c0000000036337b0] [c000000000d46bf0] dax_pmem_probe+0x20/0x70
[c0000000036337d0] [c000000000d2279c] nvdimm_bus_probe+0xac/0x2b0
[c000000003633860] [c000000000cef27c] really_probe+0x19c/0x520
[c0000000036338f0] [c000000000cef6b4] __driver_probe_device+0xb4/0x230
[c000000003633970] [c000000000cef888] driver_probe_device+0x58/0x120
[c0000000036339b0] [c000000000cefd08] __driver_attach+0x1d8/0x240
[c000000003633a30] [c000000000cebb04] bus_for_each_dev+0xb4/0x130
[c000000003633a90] [c000000000cee564] driver_attach+0x34/0x50
[c000000003633ab0] [c000000000ced878] bus_add_driver+0x218/0x300
[c000000003633b40] [c000000000cf1144] driver_register+0xa4/0x1b0
[c000000003633bb0] [c000000000d21a0c] __nd_driver_register+0x5c/0x100
[c000000003633c10] [c00000000206a2e8] dax_pmem_init+0x34/0x48
[c000000003633c30] [c0000000000132d0] do_one_initcall+0x60/0x320
[c000000003633d00] [c0000000020051b0] kernel_init_freeable+0x360/0x400
[c000000003633de0] [c000000000013764] kernel_init+0x34/0x1d0
[c000000003633e50] [c00000000000de14] ret_from_kernel_thread+0x5c/0x64

Link: https://lkml.kernel.org/r/20230411142214.64464-1-aneesh.kumar@linux.ibm.com
Fixes: 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for compound devmaps")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: cd681403a870 ("mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h  |   12 ++++++++++++
 mm/mm_init.c        |   11 -----------
 mm/sparse-vmemmap.c |    3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3405,6 +3405,18 @@ void vmemmap_populate_print_last(void);
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap);
 #endif
+
+#define VMEMMAP_RESERVE_NR	2
+#ifdef CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#define vmemmap_can_optimize(altmap, pgmap)				\
+	(is_power_of_2(sizeof(struct page)) && (pgmap) && !(altmap) &&	\
+	 (((pgmap_vmemmap_nr(pgmap) * sizeof(struct page)) >> PAGE_SHIFT) > \
+	  VMEMMAP_RESERVE_NR))
+#else
+#define vmemmap_can_optimize(altmap, pgmap)	\
+	((void)(altmap), (void)(pgmap), false)
+#endif
+
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long nr_pages);
 
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -241,17 +241,6 @@ static void __ref __init_zone_device_pag
 		set_page_count(page, 0);
 }
 
-#define VMEMMAP_RESERVE_NR	2
-#ifdef CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-#define vmemmap_can_optimize(altmap, pgmap)				\
-	(is_power_of_2(sizeof(struct page)) && !(altmap) &&		\
-	 (((pgmap_vmemmap_nr(pgmap) * sizeof(struct page)) >> PAGE_SHIFT) > \
-	  VMEMMAP_RESERVE_NR))
-#else
-#define vmemmap_can_optimize(altmap, pgmap)	\
-	((void)(altmap), (void)(pgmap), false)
-#endif
-
 #define pageblock_migratetype_init_range(start_pfn, nr_pages, migratetype) \
 do {									\
 	unsigned long __start = (start_pfn);				\
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -385,8 +385,7 @@ struct page * __meminit __populate_secti
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (is_power_of_2(sizeof(struct page)) &&
-	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+	if (vmemmap_can_optimize(altmap, pgmap))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);


