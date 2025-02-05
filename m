Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7F81DC9AF;
	Wed,  5 Feb 2025 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771871; cv=none; b=RvGFmaR9FP/xsm82zx/vRuibHdJedlDZOJ1X3r+knmS+ViLWHacmvK04+kxpGVJOzFYa72ywuWbAsjjUzilcr8an7yZB2VSngDEhz5zi67RGOIjMR01M9vByD50/4Ugq971RnXZOIl+NykBxq7YDdocFfAxGNCELdytUu1uL2bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771871; c=relaxed/simple;
	bh=d4LhsD3lA8sn51zkFNV/8GzLm09PHfYU4Wr+BwsY6hU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UH9NsC0rUhkOnm0Yzpu1ChreXV0DuiCVq+M+XgCNXzRGzmwPYPhJlRNtv6gC9lKs0IWQmkEKSnjTGjXjHwn0wP9FeiaLNPDyjmYiZOvHTSXl3/bURy7p+AMYVDGWdfGRp1bTZZBuqbICJV02NAn8F/8Pg4X5Fua2tUxO/srpJoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3605E1063;
	Wed,  5 Feb 2025 08:11:31 -0800 (PST)
Received: from [10.57.35.21] (unknown [10.57.35.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6F3C3F58B;
	Wed,  5 Feb 2025 08:11:01 -0800 (PST)
Message-ID: <f8d73cd3-f85c-49c3-8b37-4eaad0255860@arm.com>
Date: Wed, 5 Feb 2025 16:11:00 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/19] iommu/amd: Use roundup_pow_two() instead of
 get_order()
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
References: <16-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <16-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
>    1 << (get_order(x) + PAGE_SHIFT) ==  roundup_pow_two()

...unless x < 2048, which does seem possible here if last_bdf is 
sufficiently small. Not too significant in the cases where the result is 
only rounded back up again for an allocation or remap anyway, but I do 
wonder about the use of dev_table_size in iommu_set_device_table(), and 
whether this change might break it, or whether it's already wrong for 
that case and this might actually fix it...

Thanks,
Robin.

> Use the shorter version.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/init.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index f1c5041647173c..7d77929bc63af3 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -247,10 +247,7 @@ static void init_translation_status(struct amd_iommu *iommu)
>   
>   static inline unsigned long tbl_size(int entry_size, int last_bdf)
>   {
> -	unsigned shift = PAGE_SHIFT +
> -			 get_order((last_bdf + 1) * entry_size);
> -
> -	return 1UL << shift;
> +	return roundup_pow_of_two((last_bdf + 1) * entry_size);
>   }
>   
>   int amd_iommu_get_num_iommus(void)

