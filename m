Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F041FCCF6;
	Wed,  5 Feb 2025 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778644; cv=none; b=D+vSZqWEE2qymgQ5fkrCCXUQjtSCG4Xe05hasoVFGYmrWCJrNVbnkg7psqSZjIicHekwR0Xkx6+FZiK8HdKCp+dmaJjpVqUYt9NDfqqy3VPg9W2N/h/Wj86EUo2al8d2t+QuD1w+SL1sPT5g2RQ8E/Agbjo/vOmpzIjtcfs0yJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778644; c=relaxed/simple;
	bh=KyGZvGppSU4/aJv9b+VonZvjddolAucDUUwDpodjDBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Om3JgVdi2XS1QGLahvjQwrPOYU7mI3vmzdMOnAjkFzZv/Li5D7BKEcao6gqJ7vVMxm3T23Moi3dP24u48fRWPNPlC1HQrbpWE7LrLmonVttIxacsZAspV1AwoQtfQw8bhq80bojs3bNrbzHbPjdwsJFpjl1gSliYrPJdR7x1yWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C4451063;
	Wed,  5 Feb 2025 10:04:25 -0800 (PST)
Received: from [10.57.35.21] (unknown [10.57.35.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3023B3F58B;
	Wed,  5 Feb 2025 10:03:56 -0800 (PST)
Message-ID: <78707443-7525-42d4-a538-cb0c67cbeb55@arm.com>
Date: Wed, 5 Feb 2025 18:03:54 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/19] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 David Woodhouse <dwmw2@infradead.org>, Heiko Stuebner <heiko@sntech.de>,
 iommu@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <18-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <23d4c47e-a00c-4f15-ab42-303bd2aca032@arm.com>
 <20250205161017.GB2960738@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20250205161017.GB2960738@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-05 4:10 pm, Jason Gunthorpe wrote:
> On Wed, Feb 05, 2025 at 03:47:03PM +0000, Robin Murphy wrote:
>> On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
>>> Convert most of the places calling get_order() as an argument to the
>>> iommu-pages allocator into order_base_2() or the _sz flavour
>>> instead. These places already have an exact size, there is no particular
>>> reason to use order here.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>> [...]
>>> @@ -826,7 +825,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
>>>    				  size_t size)
>>>    {
>>>    	int order = get_order(size);
>>> -	void *buf = iommu_alloc_pages(gfp, order);
>>> +	void *buf = iommu_alloc_pages_lg2(gfp, order + PAGE_SHIFT);
>>
>> This is a size, really - it's right there above.
> 
> I didn't want to make major surgery to this thing, but yes it
> could be:
> 
> void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
> 				  size_t size)
> {
> 	void *buf;
> 
> 	size = PAGE_ALIGN(size);
> 	buf = iommu_alloc_pages_sz(gfp, size);
> 	if (buf &&
> 	    check_feature(FEATURE_SNP) &&
> 	    set_memory_4k((unsigned long)buf, size / PAGE_SIZE )) {
> 		iommu_free_page(buf);
> 		buf = NULL;
> 	}
> 
> 	return buf;
> }
> 
>> (although alloc_cwwb_sem() passing 1 looks highly suspicious - judging by
>> other cmd_sem references that probably should be PAGE_SIZE...)
> 
> Indeed, amd folks?
> 
>>>    	if (buf &&
>>>    	    check_feature(FEATURE_SNP) &&
>> [...]
>>> @@ -1702,8 +1701,10 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>>>    	 * Need two pages to accommodate 256 descriptors of 256 bits each
>>>    	 * if the remapping hardware supports scalable mode translation.
>>>    	 */
>>> -	order = ecap_smts(iommu->ecap) ? 1 : 0;
>>> -	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
>>> +	desc = iommu_alloc_pages_node_lg2(iommu->node, GFP_ATOMIC,
>>> +					  ecap_smts(iommu->ecap) ?
>>> +						  order_base_2(SZ_8K) :
>>> +						  order_base_2(SZ_4K));
>>
>> These are also clearly sizes.
> 
> I didn't make a size wrapper version of the _node_ variation because
> there are only three callers.
> 
>> I don't see any need to have the log2 stuff at all, I think we just
>> switch iommu_alloc_pages{_node}() to take a size and keep things
>> simple.
> 
> Ok it is easy to remove lg2 calls from the drivers, but I would keep
> the internal function like this because most of the size callers have
> constants and the order_base_2() will become a constexpr when
> inlined. Only a few places are not like that.

But what's the benefit of having extra stuff capable of turning a 
constant into a different constant that doesn't represent anything we 
actually want? We still end up doing more runtime arithmetic on lg2sz 
within the allocation function itself to turn it into the order we 
ultimately still need, so that arithmetic could just as well be 
get_order(size) and have nothing to inline at all (other than NUMA_NO_NODE).

Thanks,
Robin.
