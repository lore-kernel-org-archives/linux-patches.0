Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447651519B1;
	Wed,  5 Feb 2025 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738770437; cv=none; b=X6yzGuVm+PzXy4RQ/c0w83HOtzLM1gR7tYEykCNULHBN3R+UCFBN37tNxzN6cqBGBVLrR+iwSxmxwf4bBujw7WAgq/JM1bu4mEQbwwiX6DKoNOQIQcpx9ydIuYSCMFackegWNB2ykNSYpZy4B9zdnpUeOq4tcw5ByQ++U7Z5PsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738770437; c=relaxed/simple;
	bh=ejHE1a8+aYs3y71VCzE1Ju3Quet9sFhTMD+pAmsBqF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pyyhhPF79rPzVhoPKveia3kJZY+UlaPW+z0adiONGdhXS3bjfbWtAXjAH2WtJWGvzb3U3ZbsAWwJDayDiG4yhUPCFxvPwXOWqvLLmvHJ0r8eFjOQX/IQXQYrGC0Z6my8uSCuDFdXC9mRKlCJuuLnk/Rm6adzm46Po9kvlYKTWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A8AF1063;
	Wed,  5 Feb 2025 07:47:37 -0800 (PST)
Received: from [10.57.35.21] (unknown [10.57.35.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03F493F5A1;
	Wed,  5 Feb 2025 07:47:05 -0800 (PST)
Message-ID: <23d4c47e-a00c-4f15-ab42-303bd2aca032@arm.com>
Date: Wed, 5 Feb 2025 15:47:03 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/19] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
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
References: <18-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <18-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
> Convert most of the places calling get_order() as an argument to the
> iommu-pages allocator into order_base_2() or the _sz flavour
> instead. These places already have an exact size, there is no particular
> reason to use order here.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
[...]
> @@ -826,7 +825,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
>   				  size_t size)
>   {
>   	int order = get_order(size);
> -	void *buf = iommu_alloc_pages(gfp, order);
> +	void *buf = iommu_alloc_pages_lg2(gfp, order + PAGE_SHIFT);

This is a size, really - it's right there above.

(although alloc_cwwb_sem() passing 1 looks highly suspicious - judging 
by other cmd_sem references that probably should be PAGE_SIZE...)

Furthermore even the set_memory_4k() call doesn't really want an order 
either, PAGE_ALIGN(size) >> PAGE_SHIFT would do.

>   
>   	if (buf &&
>   	    check_feature(FEATURE_SNP) &&
[...]
> @@ -1702,8 +1701,10 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>   	 * Need two pages to accommodate 256 descriptors of 256 bits each
>   	 * if the remapping hardware supports scalable mode translation.
>   	 */
> -	order = ecap_smts(iommu->ecap) ? 1 : 0;
> -	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
> +	desc = iommu_alloc_pages_node_lg2(iommu->node, GFP_ATOMIC,
> +					  ecap_smts(iommu->ecap) ?
> +						  order_base_2(SZ_8K) :
> +						  order_base_2(SZ_4K));

These are also clearly sizes.

>   	if (!desc) {
>   		kfree(qi);
>   		iommu->qi = NULL;
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 8727d8e1e02f45..0e1dd519c3b9b3 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -263,14 +263,14 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
>   				    void *cookie)
>   {
>   	struct device *dev = cfg->iommu_dev;
> -	int order = get_order(size);
>   	dma_addr_t dma;
>   	void *pages;
>   
>   	if (cfg->alloc)
>   		pages = cfg->alloc(cookie, size, gfp);
>   	else
> -		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
> +		pages = iommu_alloc_pages_node_lg2(dev_to_node(dev), gfp,
> +						   order_base_2(size));

Another size. Same thing in patch #17 too. I don't see any need to have 
the log2 stuff at all, I think we just switch iommu_alloc_pages{_node}() 
to take a size and keep things simple.

Thanks,
Robin.

>   
>   	if (!pages)
>   		return NULL;
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index a4cbd8a8a2976e..3b57d14baa9c1d 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -107,13 +107,6 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
>   	return paddr;
>   }
>   
> -static void *__dart_alloc_pages(size_t size, gfp_t gfp)
> -{
> -	int order = get_order(size);
> -
> -	return iommu_alloc_pages(gfp, order);
> -}
> -
>   static int dart_init_pte(struct dart_io_pgtable *data,
>   			     unsigned long iova, phys_addr_t paddr,
>   			     dart_iopte prot, int num_entries,
> @@ -255,7 +248,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>   
>   	/* no L2 table present */
>   	if (!pte) {
> -		cptep = __dart_alloc_pages(tblsz, gfp);
> +		cptep = iommu_alloc_pages_sz(gfp, tblsz);
>   		if (!cptep)
>   			return -ENOMEM;
>   
> @@ -412,7 +405,8 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
>   	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
>   
>   	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
> -		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL);
> +		data->pgd[i] =
> +			iommu_alloc_pages_sz(GFP_KERNEL, DART_GRANULE(data));
>   		if (!data->pgd[i])
>   			goto out_free_data;
>   		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index 3d77aed8507373..d0e515bf5dd1f6 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -690,8 +690,8 @@ sun50i_iommu_domain_alloc_paging(struct device *dev)
>   	if (!sun50i_domain)
>   		return NULL;
>   
> -	sun50i_domain->dt = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
> -					      get_order(DT_SIZE));
> +	sun50i_domain->dt =
> +		iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32, DT_SIZE);
>   	if (!sun50i_domain->dt)
>   		goto err_free_domain;
>   

