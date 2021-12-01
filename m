Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DA968
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 19:54:35 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D03413D5;
	Wed,  1 Dec 2021 11:45:59 -0800 (PST)
Received: from [10.57.34.58] (unknown [10.57.34.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFB1E3F766;
	Wed,  1 Dec 2021 11:45:56 -0800 (PST)
Message-ID: <70fbdc70-6838-0740-43e3-ed20caff47bf@arm.com>
Date: Wed, 1 Dec 2021 19:45:52 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 29/33] iommu: Use put_pages_list
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 patches@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux-foundation.org
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-30-vbabka@suse.cz>
 <YafH2YT+uxn/y4sV@casper.infradead.org>
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YafH2YT+uxn/y4sV@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2021-12-01 19:07, Matthew Wilcox wrote:
> On Wed, Dec 01, 2021 at 07:15:06PM +0100, Vlastimil Babka wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> page->freelist is for the use of slab.  We already have the ability
>> to free a list of pages in the core mm, but it requires the use of a
>> list_head and for the pages to be chained together through page->lru.
>> Switch the iommu code over to using put_pages_list().
> 
> FYI, this is going to have conflicts with
> https://lore.kernel.org/lkml/cover.1637671820.git.robin.murphy@arm.com/
> 
> I'm not sure what the appropriate resolution is going to be here;
> maybe hold back part of this patch series to the following merge
> window to give the iommu people time to merge their own patches?

More than that, this version is subtly but catastrophically broken - we 
can't simply pass &gather->freelist through the current IOVA entry_dtor 
machinery, since gather is a stack variable from a few call frames up so 
the actual list head will be long gone by the time 
iommu_dma_entry_dtor() tries to dereference it. It took until I was 
elbow-deep in refactoring the RFC to notice that one :)

Thanks,
Robin.
