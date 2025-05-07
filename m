Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14DD1FF5EC;
	Wed,  7 May 2025 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643986; cv=none; b=Mj8v5yy0l1McARUiIH4NhkSAYXixkAuPzcK4yCMV1SpOjJVC5HD3lZfP1Fov6smo72whuRhwOvuyRTPxQvzxqc/DRego9DnX6gpTLkQfBnRdUpzQuHUM0n3Sm5OxFO+PAgZum1fIvY6g2t7nSKp4I6+l+qDS8fEW1ELWiN6qOhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643986; c=relaxed/simple;
	bh=lxW+RcMt76uT49lEtuLBqAdZAAF16FaqpcvPWq0Odo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2KUYH539PGfoAkMAoUk76bBPQSoR1VCTe87e7A5LD2mEIJXZ+PS8hOe/qtQKVpyKgy+Kv17I2Va1u/dr9zGPqTU4YJnH4MueDWrzsTL8XSoXR+2Qk7kMW6YyppA9VgE6HHHYsmNcKUrZ3yt5sG7ry5c3D6qDfHdDkk3OUHyknw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOeVP9q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOeVP9q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32954C4CEE2;
	Wed,  7 May 2025 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643986;
	bh=lxW+RcMt76uT49lEtuLBqAdZAAF16FaqpcvPWq0Odo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOeVP9q2KvBTiaDVizVjcL2+BXAOg5SgkGarkLvYAHY9gpi8Pw/NaYQJFZixzTVyN
	 uJW8IPQzvdUy7eIjh9wVsKOqdsZgldNh3UkosA52/tol91Y4pOv/SZRNqh15eWcUP9
	 4QwrQ5/oAG+KdLjELBspe5F6YSdpNwp8RilbfppM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 053/183] book3s64/radix : Align section vmemmap start address to PAGE_SIZE
Date: Wed,  7 May 2025 20:38:18 +0200
Message-ID: <20250507183826.838178384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 9cf7e13fecbab0894f6986fc6986ab2eba8de52e ]

A vmemmap altmap is a device-provided region used to provide
backing storage for struct pages. For each namespace, the altmap
should belong to that same namespace. If the namespaces are
created unaligned, there is a chance that the section vmemmap
start address could also be unaligned. If the section vmemmap
start address is unaligned, the altmap page allocated from the
current namespace might be used by the previous namespace also.
During the free operation, since the altmap is shared between two
namespaces, the previous namespace may detect that the page does
not belong to its altmap and incorrectly assume that the page is a
normal page. It then attempts to free the normal page, which leads
to a kernel crash.

Kernel attempted to read user page (18) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x00000018
Faulting instruction address: 0xc000000000530c7c
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
CPU: 32 PID: 2104 Comm: ndctl Kdump: loaded Tainted: G        W
NIP:  c000000000530c7c LR: c000000000530e00 CTR: 0000000000007ffe
REGS: c000000015e57040 TRAP: 0300   Tainted: G        W
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 84482404
CFAR: c000000000530dfc DAR: 0000000000000018 DSISR: 40000000 IRQMASK: 0
GPR00: c000000000530e00 c000000015e572e0 c000000002c5cb00 c00c000101008040
GPR04: 0000000000000000 0000000000000007 0000000000000001 000000000000001f
GPR08: 0000000000000005 0000000000000000 0000000000000018 0000000000002000
GPR12: c0000000001d2fb0 c0000060de6b0080 0000000000000000 c0000060dbf90020
GPR16: c00c000101008000 0000000000000001 0000000000000000 c000000125b20f00
GPR20: 0000000000000001 0000000000000000 ffffffffffffffff c00c000101007fff
GPR24: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
GPR28: 0000000004040201 0000000000000001 0000000000000000 c00c000101008040
NIP [c000000000530c7c] get_pfnblock_flags_mask+0x7c/0xd0
LR [c000000000530e00] free_unref_page_prepare+0x130/0x4f0
Call Trace:
free_unref_page+0x50/0x1e0
free_reserved_page+0x40/0x68
free_vmemmap_pages+0x98/0xe0
remove_pte_table+0x164/0x1e8
remove_pmd_table+0x204/0x2c8
remove_pud_table+0x1c4/0x288
remove_pagetable+0x1c8/0x310
vmemmap_free+0x24/0x50
section_deactivate+0x28c/0x2a0
__remove_pages+0x84/0x110
arch_remove_memory+0x38/0x60
memunmap_pages+0x18c/0x3d0
devm_action_release+0x30/0x50
release_nodes+0x68/0x140
devres_release_group+0x100/0x190
dax_pmem_compat_release+0x44/0x80 [dax_pmem_compat]
device_for_each_child+0x8c/0x100
[dax_pmem_compat_remove+0x2c/0x50 [dax_pmem_compat]
nvdimm_bus_remove+0x78/0x140 [libnvdimm]
device_remove+0x70/0xd0

Another issue is that if there is no altmap, a PMD-sized vmemmap
page will be allocated from RAM, regardless of the alignment of
the section start address. If the section start address is not
aligned to the PMD size, a VM_BUG_ON will be triggered when
setting the PMD-sized page to page table.

In this patch, we are aligning the section vmemmap start address
to PAGE_SIZE. After alignment, the start address will not be
part of the current namespace, and a normal page will be allocated
for the vmemmap mapping of the current section. For the remaining
sections, altmaps will be allocated. During the free operation,
the normal page will be correctly freed.

In the same way, a PMD_SIZE vmemmap page will be allocated only if
the section start address is PMD_SIZE-aligned; otherwise, it will
fall back to a PAGE-sized vmemmap allocation.

Without this patch
==================
NS1 start               NS2 start
 _________________________________________________________
|         NS1               |            NS2              |
 ---------------------------------------------------------
| Altmap| Altmap | .....|Altmap| Altmap | ...........
|  NS1  |  NS1   |      | NS2  |  NS2   |

In the above scenario, NS1 and NS2 are two namespaces. The vmemmap
for NS1 comes from Altmap NS1, which belongs to NS1, and the
vmemmap for NS2 comes from Altmap NS2, which belongs to NS2.

The vmemmap start for NS2 is not aligned, so Altmap NS2 is shared
by both NS1 and NS2. During the free operation in NS1, Altmap NS2
is not part of NS1's altmap, causing it to attempt to free an
invalid page.

With this patch
===============
NS1 start               NS2 start
 _________________________________________________________
|         NS1               |            NS2              |
 ---------------------------------------------------------
| Altmap| Altmap | .....| Normal | Altmap | Altmap |.......
|  NS1  |  NS1   |      |  Page  |  NS2   |  NS2   |

If the vmemmap start for NS2 is not aligned then we are allocating
a normal page. NS1 and NS2 vmemmap will be freed correctly.

Fixes: 368a0590d954 ("powerpc/book3s64/vmemmap: switch radix to use a different vmemmap handling function")
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8f98ec2b442977c618f7256cec88eb17dde3f2b9.1741609795.git.donettom@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 311e2112d782e..128c011afc481 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1120,6 +1120,19 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pmd_t *pmd;
 	pte_t *pte;
 
+	/*
+	 * Make sure we align the start vmemmap addr so that we calculate
+	 * the correct start_pfn in altmap boundary check to decided whether
+	 * we should use altmap or RAM based backing memory allocation. Also
+	 * the address need to be aligned for set_pte operation.
+
+	 * If the start addr is already PMD_SIZE aligned we will try to use
+	 * a pmd mapping. We don't want to be too aggressive here beacause
+	 * that will cause more allocations in RAM. So only if the namespace
+	 * vmemmap start addr is PMD_SIZE aligned we will use PMD mapping.
+	 */
+
+	start = ALIGN_DOWN(start, PAGE_SIZE);
 	for (addr = start; addr < end; addr = next) {
 		next = pmd_addr_end(addr, end);
 
@@ -1145,8 +1158,8 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 			 * in altmap block allocation failures, in which case
 			 * we fallback to RAM for vmemmap allocation.
 			 */
-			if (altmap && (!IS_ALIGNED(addr, PMD_SIZE) ||
-				       altmap_cross_boundary(altmap, addr, PMD_SIZE))) {
+			if (!IS_ALIGNED(addr, PMD_SIZE) || (altmap &&
+			    altmap_cross_boundary(altmap, addr, PMD_SIZE))) {
 				/*
 				 * make sure we don't create altmap mappings
 				 * covering things outside the device.
-- 
2.39.5



