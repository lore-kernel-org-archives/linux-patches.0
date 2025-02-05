Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE2F1FF7B3;
	Wed,  5 Feb 2025 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738783737; cv=none; b=GfXmEt2iV7GWgRq4SSAFo6vjpSy4SSddFW9PndXBeyPFPsZzgW5URaDvkn15OmlQ01agytFlVN3/vKYCxeFRTpFpkpeylNUWz6zZTYWZGBagkXpdMqEv/Egy6ohA+0Tah7yvIcUuVp8zkhLiYfPaYB8zEuNFBnsDU3MuBF0RwWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738783737; c=relaxed/simple;
	bh=CVSmvf4JDPuVGxBFx/HwVVb29l+JTKh8ULy8blTX1DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZXrgSS0WKoKdH3nuPUCcuRIg6rThqguiI2Xaf9q8YjWOhQq5Unxl9IjgxGgaZG4vjOxeGbxAKNXrQEyztp7lQVQ/xTVKHeu0PILc+JSxrO98vBQdi5C8AViwa67u2b4CFrD289knoEnIAH/kVzbeo83G9rn6RyruT3I5zv5EBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6FFB1063;
	Wed,  5 Feb 2025 11:29:16 -0800 (PST)
Received: from [10.57.35.21] (unknown [10.57.35.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6D0C3F5A1;
	Wed,  5 Feb 2025 11:28:38 -0800 (PST)
Message-ID: <be153973-550c-4ea8-bf65-35b5ce28ac22@arm.com>
Date: Wed, 5 Feb 2025 19:28:37 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] iommu/tegra: Do not use struct page as the handle
 for pts
To: Jason Gunthorpe <jgg@nvidia.com>, Alim Akhtar <alim.akhtar@samsung.com>,
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
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <2-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <2-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
> Instead use the virtual address and dma_map_single() like as->pd
> uses. Introduce a small struct tegra_pt instead of void * to have some
> clarity what is using this API and add compile safety during the
> conversion.

Hmm, I'm not sure it's all that clear to have a major discrepancy 
between how different levels of pagetable are referenced - I'd say 
either use an explicit type for both, or just rework this as a u32** 
along the same lines as the current patch #1.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/tegra-smmu.c | 68 ++++++++++++++++++++------------------
>   1 file changed, 36 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 717bcd3b8de7dc..1e85141c80548d 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -51,13 +51,15 @@ struct tegra_smmu {
>   	struct iommu_device iommu;	/* IOMMU Core code handle */
>   };
>   
> +struct tegra_pt;
> +
>   struct tegra_smmu_as {
>   	struct iommu_domain domain;
>   	struct tegra_smmu *smmu;
>   	unsigned int use_count;
>   	spinlock_t lock;
>   	u32 *count;
> -	struct page **pts;
> +	struct tegra_pt **pts;
>   	u32 *pd;
>   	dma_addr_t pd_dma;
>   	unsigned id;
> @@ -155,6 +157,10 @@ static inline u32 smmu_readl(struct tegra_smmu *smmu, unsigned long offset)
>   #define SMMU_PDE_ATTR		(SMMU_PDE_READABLE | SMMU_PDE_WRITABLE | \
>   				 SMMU_PDE_NONSECURE)
>   
> +struct tegra_pt {
> +	u32 val[SMMU_NUM_PTE];
> +};
> +
>   static unsigned int iova_pd_index(unsigned long iova)
>   {
>   	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
> @@ -564,11 +570,9 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
>   	smmu_flush(smmu);
>   }
>   
> -static u32 *tegra_smmu_pte_offset(struct page *pt_page, unsigned long iova)
> +static u32 *tegra_smmu_pte_offset(struct tegra_pt *pt, unsigned long iova)
>   {
> -	u32 *pt = page_address(pt_page);
> -
> -	return pt + iova_pt_index(iova);
> +	return &pt->val[iova_pt_index(iova)];
>   }
>   
>   static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
> @@ -576,19 +580,19 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
>   {
>   	unsigned int pd_index = iova_pd_index(iova);
>   	struct tegra_smmu *smmu = as->smmu;
> -	struct page *pt_page;
> +	struct tegra_pt *pt;
>   
> -	pt_page = as->pts[pd_index];
> -	if (!pt_page)
> +	pt = as->pts[pd_index];
> +	if (!pt)
>   		return NULL;
>   
>   	*dmap = smmu_pde_to_dma(smmu, as->pd[pd_index]);
>   
> -	return tegra_smmu_pte_offset(pt_page, iova);
> +	return tegra_smmu_pte_offset(pt, iova);
>   }
>   
>   static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
> -		       dma_addr_t *dmap, struct page *page)
> +		       dma_addr_t *dmap, struct tegra_pt *pt)
>   {
>   	unsigned int pde = iova_pd_index(iova);
>   	struct tegra_smmu *smmu = as->smmu;
> @@ -596,21 +600,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
>   	if (!as->pts[pde]) {
>   		dma_addr_t dma;
>   
> -		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
> -				   DMA_TO_DEVICE);
> +		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PD,

SMMU_SIZE_PT (yeah they're numerically the same, but still...)

> +				     DMA_TO_DEVICE);
>   		if (dma_mapping_error(smmu->dev, dma)) {
> -			__iommu_free_pages(page, 0);
> +			iommu_free_page(pt);
>   			return NULL;
>   		}
>   
>   		if (!smmu_dma_addr_valid(smmu, dma)) {
>   			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
>   				       DMA_TO_DEVICE);

All the unmaps should be converted to _single as well (and in patch #1) 
- the APIs are not officially interchangeable.

Thanks,
Robin.

> -			__iommu_free_pages(page, 0);
> +			iommu_free_page(pt);
>   			return NULL;
>   		}
>   
> -		as->pts[pde] = page;
> +		as->pts[pde] = pt;
>   
>   		tegra_smmu_set_pde(as, iova, SMMU_MK_PDE(dma, SMMU_PDE_ATTR |
>   							      SMMU_PDE_NEXT));
> @@ -633,7 +637,7 @@ static void tegra_smmu_pte_get_use(struct tegra_smmu_as *as, unsigned long iova)
>   static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
>   {
>   	unsigned int pde = iova_pd_index(iova);
> -	struct page *page = as->pts[pde];
> +	struct tegra_pt *pt = as->pts[pde];
>   
>   	/*
>   	 * When no entries in this page table are used anymore, return the
> @@ -646,7 +650,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
>   		tegra_smmu_set_pde(as, iova, 0);
>   
>   		dma_unmap_page(smmu->dev, pte_dma, SMMU_SIZE_PT, DMA_TO_DEVICE);
> -		__iommu_free_pages(page, 0);
> +		iommu_free_page(pt);
>   		as->pts[pde] = NULL;
>   	}
>   }
> @@ -666,16 +670,16 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
>   	smmu_flush(smmu);
>   }
>   
> -static struct page *as_get_pde_page(struct tegra_smmu_as *as,
> -				    unsigned long iova, gfp_t gfp,
> -				    unsigned long *flags)
> +static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
> +					unsigned long iova, gfp_t gfp,
> +					unsigned long *flags)
>   {
>   	unsigned int pde = iova_pd_index(iova);
> -	struct page *page = as->pts[pde];
> +	struct tegra_pt *pt = as->pts[pde];
>   
>   	/* at first check whether allocation needs to be done at all */
> -	if (page)
> -		return page;
> +	if (pt)
> +		return pt;
>   
>   	/*
>   	 * In order to prevent exhaustion of the atomic memory pool, we
> @@ -685,7 +689,7 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
>   	if (gfpflags_allow_blocking(gfp))
>   		spin_unlock_irqrestore(&as->lock, *flags);
>   
> -	page = __iommu_alloc_pages(gfp | __GFP_DMA, 0);
> +	pt = iommu_alloc_page(gfp | __GFP_DMA);
>   
>   	if (gfpflags_allow_blocking(gfp))
>   		spin_lock_irqsave(&as->lock, *flags);
> @@ -696,13 +700,13 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
>   	 * if allocation succeeded and the allocation failure isn't fatal.
>   	 */
>   	if (as->pts[pde]) {
> -		if (page)
> -			__iommu_free_pages(page, 0);
> +		if (pt)
> +			iommu_free_page(pt);
>   
> -		page = as->pts[pde];
> +		pt = as->pts[pde];
>   	}
>   
> -	return page;
> +	return pt;
>   }
>   
>   static int
> @@ -712,15 +716,15 @@ __tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
>   {
>   	struct tegra_smmu_as *as = to_smmu_as(domain);
>   	dma_addr_t pte_dma;
> -	struct page *page;
> +	struct tegra_pt *pt;
>   	u32 pte_attrs;
>   	u32 *pte;
>   
> -	page = as_get_pde_page(as, iova, gfp, flags);
> -	if (!page)
> +	pt = as_get_pde_page(as, iova, gfp, flags);
> +	if (!pt)
>   		return -ENOMEM;
>   
> -	pte = as_get_pte(as, iova, &pte_dma, page);
> +	pte = as_get_pte(as, iova, &pte_dma, pt);
>   	if (!pte)
>   		return -ENOMEM;
>   

