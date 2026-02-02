Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3B4369993;
	Mon,  2 Feb 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770040816; cv=none; b=UK0yLsKbIZvwYaB2+ocH25rvHHmBsLDydA69kctkkgCstu3MHF4ZPUcaFO433RBf8sDnTnOQ3tixoOYyHTzKnuAiOl3T8++kMcgHn5NwybdE8e2PAh/0PZsMco7FnmEEB/9p9OVhD/gVaQzGs4YgMuj7DmMrGVytMu6Sf/o09VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770040816; c=relaxed/simple;
	bh=TonoDG9UaR+k+QdMYkm3TmPt7vICrzPayXdTgoljcSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+fddW487kAlEaOPksJn5OD8uaUKyEo+Wt2E6QNnNxXqGZIyVpCEc53RcO2cvyM8j/tdNsp+YoKi90CKzdfVBwmgGdEtCHcGRbIuTTHuy2r7c7rzKkzuUF1reqlzjWOIyAtjM1mGZ+FiAgRUMnJZ9iTqrhAAKafXYRihdUM//EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054EF339;
	Mon,  2 Feb 2026 06:00:06 -0800 (PST)
Received: from [10.57.54.50] (unknown [10.57.54.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B759E3F7A6;
	Mon,  2 Feb 2026 06:00:09 -0800 (PST)
Message-ID: <8c46864e-4625-49f4-90b3-a7467cec8b7b@arm.com>
Date: Mon, 2 Feb 2026 14:00:07 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vincent Chen <vincent.chen@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>,
 lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>,
 patches@lists.linux.dev, xieyongji@bytedance.com
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
 <20260122153134.GO1134360@nvidia.com>
 <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
 <CABvJ_xhY_4ADOsVVbjhkBm8U1mKVOSwzKMfBw5mUsJe=kkUiLg@mail.gmail.com>
 <20260123135234.GW1134360@nvidia.com>
 <b1b220be-fd5e-4f83-8f5e-7d5282be39f9@arm.com>
 <20260131002728.GM2223369@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260131002728.GM2223369@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-01-31 12:27 am, Jason Gunthorpe wrote:
> On Thu, Jan 29, 2026 at 11:21:53AM +0000, Robin Murphy wrote:
> 
>> The driver does not advertise IOMMU_CAP_DEFERRED_FLUSH, as the existing
>> pagetable code has never implemented the conditional TLB maintenance
>> optimisation that makes it meaningful. Mind you, I don't see any reference
>> to iommu_iotlb_gather_queued() in generic_pt either, so I have no idea how
>> that's trying to do it :/
> 
> Well, correct me if I've got it wrong..
> 
> DMA-FQ always does flush all, so the goal is to eliminate redundant
> flushes from within the page table logic itself.
> 
> DMA-FQ requires two functionalites from the page table:
> 1) use gather->freelist to avoid a HW UAF (iommupt always does this)

Nope, correct DMA API usage would almost never unmap an entire table, so 
synchronous non-leaf maintenance in that path still doesn't hurt DMA-FQ 
either (e.g. io-pgtable-arm).

If a pagetable implementation wanted to refcount and eagerly free empty 
tables upon leaf unmaps, then yes it would need deferred freeing, but 
frankly it would be better off just not doing that at all for DMA-FQ 
anyway (as IOVA caching would make it likely to need to repopulate the 
same level of table soon.)

> 2) avoid internal calls to iommu_iotlb_sync()

More like avoid issuing any kind of inline TLB maintenance at all, e.g. 
for SMMUv2 the significant work is done up-front in 
io_pgtable_tlb_add_page(), so only skipping iommu_iotlb_sync() would 
have very little benefit.

> When the gather reaches __iommu_dma_unmap() it discards any iova range
> inside it, queues the freelist, and queues a flush all. So any flush
> implied by the gather is removed by the core code.

Pretty much - the freelist is handed off to the FQ, which will only 
release the IOVA range and free any pages after completion of a 
flush_iotlb_all() at some point in future (iommu-dma still knows the 
whole IOVA range it unmapped - gather->iova is only for the actual 
gathering of TLB ops by the IOMMU implementation itself)

> iommu_iotlb_gather_queued() should be used in the page table to
> supress any internal flushes.

Yes.

> iommupt doesn't have any calls because it doesn't have any internal
> flushes. It calls iommu_iotlb_gather_add_range() which blindly updates
> the iova and never flushes.

For PT_FEAT_FLUSH_RANGE, I guess so.

> The one call to iommu_iotlb_sync() is only for the para-virtualization
> optimization of narrowing invalidations. It would be nonsensical for a
> driver to enable this optimization and offer IOMMU_CAP_DEFERRED_FLUSH.

Not necessarily - in the PV case it can be desirable to minimise 
over-invalidation *if* you're trapping for targeted invalidations in 
strict mode. However, depending on the usage pattern it may also be 
beneficial to have non-strict let the FQ mechanism batch up work to 
minimise the number of traps taken - e.g. s390 is in this situation, and 
is precisely why we added IOMMU_DMA_OPTS_SINGLE_QUEUE to help optimise 
for that.

> But it is a good point that riscv pagetable may not have supported it
> before, but it does now, so we should probably add
> IOMMU_CAP_DEFERRED_FLUSH. I'll send a patch next cycle.

Sounds good.

Thanks,
Robin.
