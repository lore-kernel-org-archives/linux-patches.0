Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DD323A6;
	Mon,  4 Nov 2024 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730750034; cv=none; b=RprpiC8L8yUtzQwu04jE6/ZHACIVRvq2ay0BBsve/NYLCDZw3EmyRwGy7q54RfbugtwfsOiIkKTXjfsj+REuNVrJiwSlF01yYOfHcNMa2Kjqwy0GxnsRWQ4z7VQp0AfoDohnFA3OIsYIXxnikGuhuVKQ+DdYOIsRjdU6cQs5Ejw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730750034; c=relaxed/simple;
	bh=fz3hhPc+y6oCcMNLG3Ku8n7eMV/lIjjbbG/oXoklxQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UdTqiyiev65eF7Bi4TDF0cxKvIcA6Xse25ebY1BCrHDbRcb4nEnhMzBT7KDYXMMQ8H3SlbOFf3TxrGD0q4Oohnzwp6dwBwpkIC6S4FtIzVGfzYUAggPYvOSXyXTu+jO8KeyCEZ5ChaFk2x/8nGp7+B471pJhG+MAklLX4vrbFpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90044FEC;
	Mon,  4 Nov 2024 11:54:20 -0800 (PST)
Received: from [10.57.88.110] (unknown [10.57.88.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 805503F66E;
	Mon,  4 Nov 2024 11:53:48 -0800 (PST)
Message-ID: <cf17dc41-f72a-4d90-a78d-2d90fa0ac243@arm.com>
Date: Mon, 4 Nov 2024 19:53:46 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap
 behavior
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
 patches@lists.linux.dev, Steven Price <steven.price@arm.com>
References: <2-v2-fd55d00a60b2+c69-arm_no_split_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <2-v2-fd55d00a60b2+c69-arm_no_split_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-11-04 5:41 pm, Jason Gunthorpe wrote:
> A minority of page table implementations (arm_lpae, armv7) are unique in
> how they handle partial unmap of large IOPTEs.
> 
> Other implementations will unmap the large IOPTE and return it's
> length. For example if a 2M IOPTE is present and the first 4K is requested
> to be unmapped then unmap will remove the whole 2M and report 2M as the
> result.
> 
> armv7 instead will break up contiguous entries and replace an entry with a
> whole table so it can unmap the requested 4k.
> 
> This seems copied from the arm_lpae implementation, which was analyzed
> here:
> 
>   https://lore.kernel.org/all/20241024134411.GA6956@nvidia.com/
> 
> Bring consistency to the implementations and remove this unused
> functionality.
> 
> There are no uses outside iommu, this effects the ARM_V7S drivers
> msm_iommu, mtk_iommu, and arm-smmmu.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/io-pgtable-arm-v7s.c | 125 +----------------------------
>   1 file changed, 4 insertions(+), 121 deletions(-)

Yikes, I'd forgotten quite how much horribleness was devoted to this, 
despite it being the "simpler" non-recursive one...

However, there are also "partial unmap" cases in both sets of selftests, 
so I think there's still a bit more to remove yet :)

Thanks,
Robin.

> diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
> index 06ffc683b28fee..7e37459cd28332 100644
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -166,7 +166,6 @@ struct arm_v7s_io_pgtable {
>   
>   	arm_v7s_iopte		*pgd;
>   	struct kmem_cache	*l2_tables;
> -	spinlock_t		split_lock;
>   };
>   
>   static bool arm_v7s_pte_is_cont(arm_v7s_iopte pte, int lvl);
> @@ -363,25 +362,6 @@ static arm_v7s_iopte arm_v7s_prot_to_pte(int prot, int lvl,
>   	return pte;
>   }
>   
> -static int arm_v7s_pte_to_prot(arm_v7s_iopte pte, int lvl)
> -{
> -	int prot = IOMMU_READ;
> -	arm_v7s_iopte attr = pte >> ARM_V7S_ATTR_SHIFT(lvl);
> -
> -	if (!(attr & ARM_V7S_PTE_AP_RDONLY))
> -		prot |= IOMMU_WRITE;
> -	if (!(attr & ARM_V7S_PTE_AP_UNPRIV))
> -		prot |= IOMMU_PRIV;
> -	if ((attr & (ARM_V7S_TEX_MASK << ARM_V7S_TEX_SHIFT)) == 0)
> -		prot |= IOMMU_MMIO;
> -	else if (pte & ARM_V7S_ATTR_C)
> -		prot |= IOMMU_CACHE;
> -	if (pte & ARM_V7S_ATTR_XN(lvl))
> -		prot |= IOMMU_NOEXEC;
> -
> -	return prot;
> -}
> -
>   static arm_v7s_iopte arm_v7s_pte_to_cont(arm_v7s_iopte pte, int lvl)
>   {
>   	if (lvl == 1) {
> @@ -398,23 +378,6 @@ static arm_v7s_iopte arm_v7s_pte_to_cont(arm_v7s_iopte pte, int lvl)
>   	return pte;
>   }
>   
> -static arm_v7s_iopte arm_v7s_cont_to_pte(arm_v7s_iopte pte, int lvl)
> -{
> -	if (lvl == 1) {
> -		pte &= ~ARM_V7S_CONT_SECTION;
> -	} else if (lvl == 2) {
> -		arm_v7s_iopte xn = pte & BIT(ARM_V7S_CONT_PAGE_XN_SHIFT);
> -		arm_v7s_iopte tex = pte & (ARM_V7S_CONT_PAGE_TEX_MASK <<
> -					   ARM_V7S_CONT_PAGE_TEX_SHIFT);
> -
> -		pte ^= xn | tex | ARM_V7S_PTE_TYPE_CONT_PAGE;
> -		pte |= (xn >> ARM_V7S_CONT_PAGE_XN_SHIFT) |
> -		       (tex >> ARM_V7S_CONT_PAGE_TEX_SHIFT) |
> -		       ARM_V7S_PTE_TYPE_PAGE;
> -	}
> -	return pte;
> -}
> -
>   static bool arm_v7s_pte_is_cont(arm_v7s_iopte pte, int lvl)
>   {
>   	if (lvl == 1 && !ARM_V7S_PTE_IS_TABLE(pte, lvl))
> @@ -591,77 +554,6 @@ static void arm_v7s_free_pgtable(struct io_pgtable *iop)
>   	kfree(data);
>   }
>   
> -static arm_v7s_iopte arm_v7s_split_cont(struct arm_v7s_io_pgtable *data,
> -					unsigned long iova, int idx, int lvl,
> -					arm_v7s_iopte *ptep)
> -{
> -	struct io_pgtable *iop = &data->iop;
> -	arm_v7s_iopte pte;
> -	size_t size = ARM_V7S_BLOCK_SIZE(lvl);
> -	int i;
> -
> -	/* Check that we didn't lose a race to get the lock */
> -	pte = *ptep;
> -	if (!arm_v7s_pte_is_cont(pte, lvl))
> -		return pte;
> -
> -	ptep -= idx & (ARM_V7S_CONT_PAGES - 1);
> -	pte = arm_v7s_cont_to_pte(pte, lvl);
> -	for (i = 0; i < ARM_V7S_CONT_PAGES; i++)
> -		ptep[i] = pte + i * size;
> -
> -	__arm_v7s_pte_sync(ptep, ARM_V7S_CONT_PAGES, &iop->cfg);
> -
> -	size *= ARM_V7S_CONT_PAGES;
> -	io_pgtable_tlb_flush_walk(iop, iova, size, size);
> -	return pte;
> -}
> -
> -static size_t arm_v7s_split_blk_unmap(struct arm_v7s_io_pgtable *data,
> -				      struct iommu_iotlb_gather *gather,
> -				      unsigned long iova, size_t size,
> -				      arm_v7s_iopte blk_pte,
> -				      arm_v7s_iopte *ptep)
> -{
> -	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> -	arm_v7s_iopte pte, *tablep;
> -	int i, unmap_idx, num_entries, num_ptes;
> -
> -	tablep = __arm_v7s_alloc_table(2, GFP_ATOMIC, data);
> -	if (!tablep)
> -		return 0; /* Bytes unmapped */
> -
> -	num_ptes = ARM_V7S_PTES_PER_LVL(2, cfg);
> -	num_entries = size >> ARM_V7S_LVL_SHIFT(2);
> -	unmap_idx = ARM_V7S_LVL_IDX(iova, 2, cfg);
> -
> -	pte = arm_v7s_prot_to_pte(arm_v7s_pte_to_prot(blk_pte, 1), 2, cfg);
> -	if (num_entries > 1)
> -		pte = arm_v7s_pte_to_cont(pte, 2);
> -
> -	for (i = 0; i < num_ptes; i += num_entries, pte += size) {
> -		/* Unmap! */
> -		if (i == unmap_idx)
> -			continue;
> -
> -		__arm_v7s_set_pte(&tablep[i], pte, num_entries, cfg);
> -	}
> -
> -	pte = arm_v7s_install_table(tablep, ptep, blk_pte, cfg);
> -	if (pte != blk_pte) {
> -		__arm_v7s_free_table(tablep, 2, data);
> -
> -		if (!ARM_V7S_PTE_IS_TABLE(pte, 1))
> -			return 0;
> -
> -		tablep = iopte_deref(pte, 1, data);
> -		return __arm_v7s_unmap(data, gather, iova, size, 2, tablep);
> -	}
> -
> -	io_pgtable_tlb_add_page(&data->iop, gather, iova, size);
> -	return size;
> -}
> -
>   static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>   			      struct iommu_iotlb_gather *gather,
>   			      unsigned long iova, size_t size, int lvl,
> @@ -694,11 +586,8 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>   	 * case in a lock for the sake of correctness and be done with it.
>   	 */
>   	if (num_entries <= 1 && arm_v7s_pte_is_cont(pte[0], lvl)) {
> -		unsigned long flags;
> -
> -		spin_lock_irqsave(&data->split_lock, flags);
> -		pte[0] = arm_v7s_split_cont(data, iova, idx, lvl, ptep);
> -		spin_unlock_irqrestore(&data->split_lock, flags);
> +		WARN_ONCE(true, "Unmap of a partial large IOPTE is not allowed");
> +		return 0;
>   	}
>   
>   	/* If the size matches this level, we're in the right place */
> @@ -721,12 +610,8 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>   		}
>   		return size;
>   	} else if (lvl == 1 && !ARM_V7S_PTE_IS_TABLE(pte[0], lvl)) {
> -		/*
> -		 * Insert a table at the next level to map the old region,
> -		 * minus the part we want to unmap
> -		 */
> -		return arm_v7s_split_blk_unmap(data, gather, iova, size, pte[0],
> -					       ptep);
> +		WARN_ONCE(true, "Unmap of a partial large IOPTE is not allowed");
> +		return 0;
>   	}
>   
>   	/* Keep on walkin' */
> @@ -811,8 +696,6 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
>   	if (!data)
>   		return NULL;
>   
> -	spin_lock_init(&data->split_lock);
> -
>   	/*
>   	 * ARM_MTK_TTBR_EXT extend the translation table base support larger
>   	 * memory address.

