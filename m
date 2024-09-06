Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5748C14AD3D;
	Fri,  6 Sep 2024 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725628704; cv=none; b=YJSNYYnUbHhVvxdEEKay2mq/U9F8Vp6MUtAeZ64j//lqcZzikaW5g3p1T4FRa4QlpWcu7c1h+Bn1dRpAOwXeL82w+5NF7dBuxyfsTkz5rP0zFt0tCxhNmKbw40AbhWtCTLAK9uEC9TytPc8nynQd/lhtREflvjaj6AjQ2k2uWHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725628704; c=relaxed/simple;
	bh=UV7AeImDlAj/Nwu2dy05FVBBdDBkx3fFbJyDrO+5LC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sv6kVH425ZXHB4QWA5bebymQcikj0DZHdu5tQvAgEkZxaOUZIZbw1laQ6IHi1dXGJYYBwy9KnPwLRXTrJholU7jfjFQ2Bvmc+CaEg9peB49CB9ahylfcnA8ul1RUH9CxM4li2Gx6a3tQn8EUsUA/uCOx72UjSkYKB3kQMMOnJ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpmHjSDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpmHjSDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FD6C4CEC4;
	Fri,  6 Sep 2024 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725628704;
	bh=UV7AeImDlAj/Nwu2dy05FVBBdDBkx3fFbJyDrO+5LC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FpmHjSDgm+77T40+tsAbosjA78FZ/fQJdHeYBeXkcJJJmUfvRb+D1/OhfR551dh70
	 ZGT6eIaSHp473R7saEZwWOLfAXFAgEYLejSz98u69G/HlutLC7xXYV082iCtCiiitl
	 kGtAJ6slDjYhlgbLhjAAV8o5FMT1s2VSxPw7u4VuaNfCSr387jVSNtdYku0jIx/OAf
	 lpysEFYCsXQILsUViOf8NBv34VNxrFTvgBAmBpN8ZuCqwNwCDo2JucnGvHgk8g8ZIX
	 lO/OdBJGybHlC0+119jQpEPhvTh0W/J1m/wSpzFEy6DhG6BuEKQmW6ZdMefVeOrBls
	 glJ4eDnRadg+Q==
Date: Fri, 6 Sep 2024 14:18:18 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 2/9] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
Message-ID: <20240906131818.GA16959@willie-the-truck>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <2-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2024 at 08:31:16PM -0300, Jason Gunthorpe wrote:
> Don't open code the calculations of the indexes for each level, provide
> two functions to do that math and call them in all the places. Update all
> the places computing indexes.
> 
> Calculate the L1 table size directly based on the max required index from
> the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.
> 
> Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 51 +++++++++------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 14 +++++-
>  2 files changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b80f3359a8d12b..a695e5f8fc2880 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1670,20 +1670,17 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
>  
>  static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  {
> -	size_t size;
> -	void *strtab;
>  	dma_addr_t l2ptr_dma;
>  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
> +	struct arm_smmu_strtab_l1_desc *desc =
> +		&cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
>  
>  	if (desc->l2ptr)
>  		return 0;
>  
> -	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> -	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
> -
> -	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
> -					  GFP_KERNEL);
> +	desc->l2ptr = dmam_alloc_coherent(
> +		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
> +		&l2ptr_dma, GFP_KERNEL);

Since this series is mainly about clean-up, please can you be consistent
with the indentation style that the driver currently uses for multi-line
function invocations? I applied the whole series, but I struggled looking
at the resulting code (of course, there's no "right" way, but the driver
is written with whatever I'm used to so I'd really like to keep the
consistency).

Will
