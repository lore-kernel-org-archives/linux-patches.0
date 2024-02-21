Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296855E5E;
	Wed, 21 Feb 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523909; cv=none; b=OoskToCD0cJTyvo3qIq9omnKvgTOEtPMAxYzgcHTXBxI+wM4UAGjP7u70sZC9Q4oGipVI6c/cYI+2CnYBE0Zmrns0nSRzvNZSZ9YXVhN5cKMAMaxNtbeKxUOmfq/7Ig+VMshHouNhfypUNYKjxPe2O09OJ1yl5meDf7LEGb35Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523909; c=relaxed/simple;
	bh=W4IepGILQUw5kj+KZLJ7Ma+lL+yCcKOvi0nIhT/0l7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF5s/k5j1faRdPSs3i3oP5srHkQcrq4yGnuFSmQHVJqL+EQg5N7+CCJAHgr+8A5qwbWSlGVuT6F+IQajor6Ypb59KP3reMR8fSsHuSdfwDbjt8l6e4bTiYxH8IEzyunPOb/wHjFXCZJvQ0pvTI5YTDKTjfRk+ObskMBhixtbEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuf4x6hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuf4x6hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5371EC433C7;
	Wed, 21 Feb 2024 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523909;
	bh=W4IepGILQUw5kj+KZLJ7Ma+lL+yCcKOvi0nIhT/0l7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuf4x6hvFPHmMilDb0MoRTWEDua9eCuCsbHdyBtYEmQ3fZAmLr+qmRWAtONSNfm3k
	 hw3hwHIZI8r+EzaOKudrx6U0B+jfWF6WAW2MMP9JZxEZv1gjIlkwt2jR9ETzWqDNYY
	 k7sHffYev3z4wJsz50rK0LzVGgC7F6coILL5Hpqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/379] mm/sparsemem: fix race in accessing memory_section->usage
Date: Wed, 21 Feb 2024 14:04:27 +0100
Message-ID: <20240221125957.510048631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charan Teja Kalla <quic_charante@quicinc.com>

[ Upstream commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 ]

The below race is observed on a PFN which falls into the device memory
region with the system memory configuration where PFN's are such that
[ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL].  Since normal zone start and end
pfn contains the device memory PFN's as well, the compaction triggered
will try on the device memory PFN's too though they end up in NOP(because
pfn_to_online_page() returns NULL for ZONE_DEVICE memory sections).  When
from other core, the section mappings are being removed for the
ZONE_DEVICE region, that the PFN in question belongs to, on which
compaction is currently being operated is resulting into the kernel crash
with CONFIG_SPASEMEM_VMEMAP enabled.  The crash logs can be seen at [1].

compact_zone()			memunmap_pages
-------------			---------------
__pageblock_pfn_to_page
   ......
 (a)pfn_valid():
     valid_section()//return true
			      (b)__remove_pages()->
				  sparse_remove_section()->
				    section_deactivate():
				    [Free the array ms->usage and set
				     ms->usage = NULL]
     pfn_section_valid()
     [Access ms->usage which
     is NULL]

NOTE: From the above it can be said that the race is reduced to between
the pfn_valid()/pfn_section_valid() and the section deactivate with
SPASEMEM_VMEMAP enabled.

The commit b943f045a9af("mm/sparse: fix kernel crash with
pfn_section_valid check") tried to address the same problem by clearing
the SECTION_HAS_MEM_MAP with the expectation of valid_section() returns
false thus ms->usage is not accessed.

Fix this issue by the below steps:

a) Clear SECTION_HAS_MEM_MAP before freeing the ->usage.

b) RCU protected read side critical section will either return NULL
   when SECTION_HAS_MEM_MAP is cleared or can successfully access ->usage.

c) Free the ->usage with kfree_rcu() and set ms->usage = NULL.  No
   attempt will be made to access ->usage after this as the
   SECTION_HAS_MEM_MAP is cleared thus valid_section() return false.

Thanks to David/Pavan for their inputs on this patch.

[1] https://lore.kernel.org/linux-mm/994410bb-89aa-d987-1f50-f514903c55aa@quicinc.com/

On Snapdragon SoC, with the mentioned memory configuration of PFN's as
[ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL], we are able to see bunch of
issues daily while testing on a device farm.

For this particular issue below is the log.  Though the below log is
not directly pointing to the pfn_section_valid(){ ms->usage;}, when we
loaded this dump on T32 lauterbach tool, it is pointing.

[  540.578056] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[  540.578068] Mem abort info:
[  540.578070]   ESR = 0x0000000096000005
[  540.578073]   EC = 0x25: DABT (current EL), IL = 32 bits
[  540.578077]   SET = 0, FnV = 0
[  540.578080]   EA = 0, S1PTW = 0
[  540.578082]   FSC = 0x05: level 1 translation fault
[  540.578085] Data abort info:
[  540.578086]   ISV = 0, ISS = 0x00000005
[  540.578088]   CM = 0, WnR = 0
[  540.579431] pstate: 82400005 (Nzcv daif +PAN -UAO +TCO -DIT -SSBSBTYPE=--)
[  540.579436] pc : __pageblock_pfn_to_page+0x6c/0x14c
[  540.579454] lr : compact_zone+0x994/0x1058
[  540.579460] sp : ffffffc03579b510
[  540.579463] x29: ffffffc03579b510 x28: 0000000000235800 x27:000000000000000c
[  540.579470] x26: 0000000000235c00 x25: 0000000000000068 x24:ffffffc03579b640
[  540.579477] x23: 0000000000000001 x22: ffffffc03579b660 x21:0000000000000000
[  540.579483] x20: 0000000000235bff x19: ffffffdebf7e3940 x18:ffffffdebf66d140
[  540.579489] x17: 00000000739ba063 x16: 00000000739ba063 x15:00000000009f4bff
[  540.579495] x14: 0000008000000000 x13: 0000000000000000 x12:0000000000000001
[  540.579501] x11: 0000000000000000 x10: 0000000000000000 x9 :ffffff897d2cd440
[  540.579507] x8 : 0000000000000000 x7 : 0000000000000000 x6 :ffffffc03579b5b4
[  540.579512] x5 : 0000000000027f25 x4 : ffffffc03579b5b8 x3 :0000000000000001
[  540.579518] x2 : ffffffdebf7e3940 x1 : 0000000000235c00 x0 :0000000000235800
[  540.579524] Call trace:
[  540.579527]  __pageblock_pfn_to_page+0x6c/0x14c
[  540.579533]  compact_zone+0x994/0x1058
[  540.579536]  try_to_compact_pages+0x128/0x378
[  540.579540]  __alloc_pages_direct_compact+0x80/0x2b0
[  540.579544]  __alloc_pages_slowpath+0x5c0/0xe10
[  540.579547]  __alloc_pages+0x250/0x2d0
[  540.579550]  __iommu_dma_alloc_noncontiguous+0x13c/0x3fc
[  540.579561]  iommu_dma_alloc+0xa0/0x320
[  540.579565]  dma_alloc_attrs+0xd4/0x108

[quic_charante@quicinc.com: use kfree_rcu() in place of synchronize_rcu(), per David]
  Link: https://lkml.kernel.org/r/1698403778-20938-1-git-send-email-quic_charante@quicinc.com
Link: https://lkml.kernel.org/r/1697202267-23600-1-git-send-email-quic_charante@quicinc.com
Fixes: f46edbd1b151 ("mm/sparsemem: add helpers track active portions of a section at boot")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h | 14 +++++++++++---
 mm/sparse.c            | 17 +++++++++--------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 11fa11c31fda..ffae2b330818 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1188,6 +1188,7 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
 #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
 
 struct mem_section_usage {
+	struct rcu_head rcu;
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
 #endif
@@ -1353,7 +1354,7 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
 
-	return test_bit(idx, ms->usage->subsection_map);
+	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
@@ -1366,17 +1367,24 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 static inline int pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
+	int ret;
 
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	ms = __pfn_to_section(pfn);
-	if (!valid_section(ms))
+	rcu_read_lock();
+	if (!valid_section(ms)) {
+		rcu_read_unlock();
 		return 0;
+	}
 	/*
 	 * Traditionally early sections always returned pfn_valid() for
 	 * the entire section-sized span.
 	 */
-	return early_section(ms) || pfn_section_valid(ms, pfn);
+	ret = early_section(ms) || pfn_section_valid(ms, pfn);
+	rcu_read_unlock();
+
+	return ret;
 }
 #endif
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 33406ea2ecc4..db0a7c53775b 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -809,6 +809,13 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	if (empty) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
+
 		/*
 		 * When removing an early section, the usage map is kept (as the
 		 * usage maps of other sections fall into the same page). It
@@ -817,16 +824,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		 * was allocated during boot.
 		 */
 		if (!PageReserved(virt_to_page(ms->usage))) {
-			kfree(ms->usage);
-			ms->usage = NULL;
+			kfree_rcu(ms->usage, rcu);
+			WRITE_ONCE(ms->usage, NULL);
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		/*
-		 * Mark the section invalid so that valid_section()
-		 * return false. This prevents code from dereferencing
-		 * ms->usage array.
-		 */
-		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
 	/*
-- 
2.43.0



