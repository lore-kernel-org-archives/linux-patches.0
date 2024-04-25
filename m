Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112CD3BBE6
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714057271; cv=none; b=btqqRDvsW0hpOtOfQPWu0TwhOs77eLzoK8NmhL+S2R8RSm+PU7tNKEat0OLYSL5L4GrmOgqdd4czVYxyI7Ve5XY6uZk37Fn9orvSKYZGp/fHTZ4JrfJnZlETrUz2p9XX41JNsE3eQf6b5435k2g1psSoFTXzIpEOWXJ7KcEMyiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714057271; c=relaxed/simple;
	bh=NVwRECnrVwS6dImQ6/t48TBCeF5r7XV0lPZl8u1LZhw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=D/HQpPZuDAu/MFX9AWgpPeDUijgIHqPRklucuHVxdPH/Ez0t7jedDSvupNRNwly4Y1Q2LNnULygObW64gfwukEoelcSEigXL+gKTp7ZnWJYsoRVagW/nwvZqHwnAl3amjyrae3Qet+qelj81gB8vP9JxK5QkUllmpw9h0yl2CY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B26FA61E5FE06;
	Thu, 25 Apr 2024 17:00:36 +0200 (CEST)
Message-ID: <75d0a0ca-3780-4840-ad45-61a02419605e@molgen.mpg.de>
Date: Thu, 25 Apr 2024 17:00:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 108/476] mm/sparsemem: fix race in accessing
 memory_section->usage
From: Donald Buczek <buczek@molgen.mpg.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Charan Teja Kalla <quic_charante@quicinc.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, David Hildenbrand
 <david@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>,
 it+linux@molgen.mpg.de
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130011.965182720@linuxfoundation.org>
 <d3adab65-b962-4530-886a-631f0faf1107@molgen.mpg.de>
Content-Language: en-US
In-Reply-To: <d3adab65-b962-4530-886a-631f0faf1107@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/24 16:55, Donald Buczek wrote:
> On 2/21/24 14:02, Greg Kroah-Hartman wrote:
>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Charan Teja Kalla <quic_charante@quicinc.com>
>>
>> [ Upstream commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 ]
>>
>> The below race is observed on a PFN which falls into the device memory
>> region with the system memory configuration where PFN's are such that
>> [ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL].  Since normal zone start and end
>> pfn contains the device memory PFN's as well, the compaction triggered
>> will try on the device memory PFN's too though they end up in NOP(because
>> pfn_to_online_page() returns NULL for ZONE_DEVICE memory sections).  When
>> from other core, the section mappings are being removed for the
>> ZONE_DEVICE region, that the PFN in question belongs to, on which
>> compaction is currently being operated is resulting into the kernel crash
>> with CONFIG_SPASEMEM_VMEMAP enabled.  The crash logs can be seen at [1].
>>
>> compact_zone()			memunmap_pages
>> -------------			---------------
>> __pageblock_pfn_to_page
>>    ......
>>  (a)pfn_valid():
>>      valid_section()//return true
>> 			      (b)__remove_pages()->
>> 				  sparse_remove_section()->
>> 				    section_deactivate():
>> 				    [Free the array ms->usage and set
>> 				     ms->usage = NULL]
>>      pfn_section_valid()
>>      [Access ms->usage which
>>      is NULL]
>>
>> NOTE: From the above it can be said that the race is reduced to between
>> the pfn_valid()/pfn_section_valid() and the section deactivate with
>> SPASEMEM_VMEMAP enabled.
>>
>> The commit b943f045a9af("mm/sparse: fix kernel crash with
>> pfn_section_valid check") tried to address the same problem by clearing
>> the SECTION_HAS_MEM_MAP with the expectation of valid_section() returns
>> false thus ms->usage is not accessed.
>>
>> Fix this issue by the below steps:
>>
>> a) Clear SECTION_HAS_MEM_MAP before freeing the ->usage.
>>
>> b) RCU protected read side critical section will either return NULL
>>    when SECTION_HAS_MEM_MAP is cleared or can successfully access ->usage.
>>
>> c) Free the ->usage with kfree_rcu() and set ms->usage = NULL.  No
>>    attempt will be made to access ->usage after this as the
>>    SECTION_HAS_MEM_MAP is cleared thus valid_section() return false.
>>
>> Thanks to David/Pavan for their inputs on this patch.
>>
>> [1] https://lore.kernel.org/linux-mm/994410bb-89aa-d987-1f50-f514903c55aa@quicinc.com/
>>
>> On Snapdragon SoC, with the mentioned memory configuration of PFN's as
>> [ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL], we are able to see bunch of
>> issues daily while testing on a device farm.
>>
>> For this particular issue below is the log.  Though the below log is
>> not directly pointing to the pfn_section_valid(){ ms->usage;}, when we
>> loaded this dump on T32 lauterbach tool, it is pointing.
>>
>> [  540.578056] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000000000000000
>> [  540.578068] Mem abort info:
>> [  540.578070]   ESR = 0x0000000096000005
>> [  540.578073]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [  540.578077]   SET = 0, FnV = 0
>> [  540.578080]   EA = 0, S1PTW = 0
>> [  540.578082]   FSC = 0x05: level 1 translation fault
>> [  540.578085] Data abort info:
>> [  540.578086]   ISV = 0, ISS = 0x00000005
>> [  540.578088]   CM = 0, WnR = 0
>> [  540.579431] pstate: 82400005 (Nzcv daif +PAN -UAO +TCO -DIT -SSBSBTYPE=--)
>> [  540.579436] pc : __pageblock_pfn_to_page+0x6c/0x14c
>> [  540.579454] lr : compact_zone+0x994/0x1058
>> [  540.579460] sp : ffffffc03579b510
>> [  540.579463] x29: ffffffc03579b510 x28: 0000000000235800 x27:000000000000000c
>> [  540.579470] x26: 0000000000235c00 x25: 0000000000000068 x24:ffffffc03579b640
>> [  540.579477] x23: 0000000000000001 x22: ffffffc03579b660 x21:0000000000000000
>> [  540.579483] x20: 0000000000235bff x19: ffffffdebf7e3940 x18:ffffffdebf66d140
>> [  540.579489] x17: 00000000739ba063 x16: 00000000739ba063 x15:00000000009f4bff
>> [  540.579495] x14: 0000008000000000 x13: 0000000000000000 x12:0000000000000001
>> [  540.579501] x11: 0000000000000000 x10: 0000000000000000 x9 :ffffff897d2cd440
>> [  540.579507] x8 : 0000000000000000 x7 : 0000000000000000 x6 :ffffffc03579b5b4
>> [  540.579512] x5 : 0000000000027f25 x4 : ffffffc03579b5b8 x3 :0000000000000001
>> [  540.579518] x2 : ffffffdebf7e3940 x1 : 0000000000235c00 x0 :0000000000235800
>> [  540.579524] Call trace:
>> [  540.579527]  __pageblock_pfn_to_page+0x6c/0x14c
>> [  540.579533]  compact_zone+0x994/0x1058
>> [  540.579536]  try_to_compact_pages+0x128/0x378
>> [  540.579540]  __alloc_pages_direct_compact+0x80/0x2b0
>> [  540.579544]  __alloc_pages_slowpath+0x5c0/0xe10
>> [  540.579547]  __alloc_pages+0x250/0x2d0
>> [  540.579550]  __iommu_dma_alloc_noncontiguous+0x13c/0x3fc
>> [  540.579561]  iommu_dma_alloc+0xa0/0x320
>> [  540.579565]  dma_alloc_attrs+0xd4/0x108
>>
>> [quic_charante@quicinc.com: use kfree_rcu() in place of synchronize_rcu(), per David]
>>   Link: https://lkml.kernel.org/r/1698403778-20938-1-git-send-email-quic_charante@quicinc.com
>> Link: https://lkml.kernel.org/r/1697202267-23600-1-git-send-email-quic_charante@quicinc.com
>> Fixes: f46edbd1b151 ("mm/sparsemem: add helpers track active portions of a section at boot")
>> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/linux/mmzone.h | 14 +++++++++++---
>>  mm/sparse.c            | 17 +++++++++--------
>>  2 files changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 9e1485083398..8b8349ffa1cd 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1287,6 +1287,7 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
>>  #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
>>  
>>  struct mem_section_usage {
>> +	struct rcu_head rcu;
>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>  	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
>>  #endif
>> @@ -1457,7 +1458,7 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>>  {
>>  	int idx = subsection_map_index(pfn);
>>  
>> -	return test_bit(idx, ms->usage->subsection_map);
>> +	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
>>  }
>>  #else
>>  static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>> @@ -1481,6 +1482,7 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>>  static inline int pfn_valid(unsigned long pfn)
>>  {
>>  	struct mem_section *ms;
>> +	int ret;
>>  
>>  	/*
>>  	 * Ensure the upper PAGE_SHIFT bits are clear in the
>> @@ -1494,13 +1496,19 @@ static inline int pfn_valid(unsigned long pfn)
>>  	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
>>  		return 0;
>>  	ms = __pfn_to_section(pfn);
>> -	if (!valid_section(ms))
>> +	rcu_read_lock();
>> +	if (!valid_section(ms)) {
>> +		rcu_read_unlock();
>>  		return 0;
>> +	}
>>  	/*
>>  	 * Traditionally early sections always returned pfn_valid() for
>>  	 * the entire section-sized span.
>>  	 */
>> -	return early_section(ms) || pfn_section_valid(ms, pfn);
>> +	ret = early_section(ms) || pfn_section_valid(ms, pfn);
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>>  }
>>  #endif
>>  
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 120bc8ea5293..27092badd15b 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -789,6 +789,13 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>>  	if (empty) {
>>  		unsigned long section_nr = pfn_to_section_nr(pfn);
>>  
>> +		/*
>> +		 * Mark the section invalid so that valid_section()
>> +		 * return false. This prevents code from dereferencing
>> +		 * ms->usage array.
>> +		 */
>> +		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
>> +
>>  		/*
>>  		 * When removing an early section, the usage map is kept (as the
>>  		 * usage maps of other sections fall into the same page). It
>> @@ -797,16 +804,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>>  		 * was allocated during boot.
>>  		 */
>>  		if (!PageReserved(virt_to_page(ms->usage))) {
>> -			kfree(ms->usage);
>> -			ms->usage = NULL;
>> +			kfree_rcu(ms->usage, rcu);
>> +			WRITE_ONCE(ms->usage, NULL);
>>  		}
>>  		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
>> -		/*
>> -		 * Mark the section invalid so that valid_section()
>> -		 * return false. This prevents code from dereferencing
>> -		 * ms->usage array.
>> -		 */
>> -		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
>>  	}
>>  
>>  	/*
> 
> Maybe this is already known, but just FYI I wanted to drop the note that for some
> reasons I don't understand, this patch prevents me from compiling the proprietary
> Nvidia Unix driver with versions 510.108.03 and 535.104.05 in the 5.15 series.
> No problems with the 6.5 series, although the patch is included there as well.
> 
> linux-5.15.155 , nvidia 535.104.05 :
> 
>     make -j $(nproc) CC=gcc SYSSRC=/scratch/local/linux clean && make -j $(nproc) CC=gcc SYSSRC=/scratch/local/linux V=2 modules
>     [...]
>     MODPOST /scratch/local/bee-buczek/nvidia/test_535-104-05/kernel/Module.symvers - due to target missing
>     ERROR: modpost: GPL-incompatible module nvidia.ko uses GPL-only symbol 'rcu_read_unlock_strict'
>     make[2]: *** [scripts/Makefile.modpost:133: /scratch/local/bee-buczek/nvidia/test_535-104-05/kernel/Module.symvers] Error 1
>     make[2]: *** Deleting file '/scratch/local/bee-buczek/nvidia/test_535-104-05/kernel/Module.symvers'
>     make[1]: *** [Makefile:1826: modules] Error 2
>     make[1]: Leaving directory '/scratch/local/linux'
>     make: *** [Makefile:82: modules] Error 2
> 
> 
> With fd117d03cefd15 ("mm/sparsemem: fix race in accessing memory_section->usage") reverted,
> the build completes.

Sorry, that was my revert patch. Its b448de2459b6d6 ("mm/sparsemem: fix race in accessing memory_section->usage").

D.

> 
> Best
>   Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

