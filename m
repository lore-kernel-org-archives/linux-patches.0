Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777C12F5A5;
	Fri,  6 Sep 2024 13:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725628875; cv=none; b=s+Z9lcnAUao9fV0/iM5w4qe4fwU7mB1gyYwf3ISZiJ2bkjY9gnOiMRLRe6fmSe8NSLFkoyxxWTsdMu2wRwcLFzeXZ5XGzdyEgSsDQEGvZ9P7V3x2yMG+FMjOE1fHX7WhH8m6Gc4q9MxV5uGjEJOTqSStZZlz7EiwEYAWDgXviKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725628875; c=relaxed/simple;
	bh=TPjrVKunEneNgtAAtoKraXxqecJdijK9NzoW/Ve/oRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIKWl/zmXR5rcDAUaGwUtgYTxHIv3N9RX9YRFU/mOkJC1Vuca6a8KofN2nkZeJC82gk9q1fZpz9zsMY9gNbi3OR2u9Pg0SG1Ay1jRfDSa6AxC2kqjGK/TNfLG6WLddjj4ggJ9xOMN44e6rt6yaBepafdV+vukRwDYGgQzyy9ipQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiODQgJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiODQgJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3A6C4CEC5;
	Fri,  6 Sep 2024 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725628875;
	bh=TPjrVKunEneNgtAAtoKraXxqecJdijK9NzoW/Ve/oRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZiODQgJKj2kJxHs5yYsoWV9IXFfPcGk752TnTbLS9gVVNM+U672am+yV2uxU+re5K
	 +rrE718l33rFBjgDHvTtsVxxHa82M6gT+efTtbPQxmKtVU75q5D3qZ88qvO0U9zIq+
	 luZfBC4QyRWrPmw4Vtsq7CPVW/UO4GnC3FqyQdiYsoNaaiBp0knnZDjzciw9Z6gfkW
	 dU5wGUp0+r2VkGRxod+7PFotioLgWiBMF4FHDfwX8YoPd28Pta+oaOkOy0AsJ5oWcK
	 33Id0KaEngMVZfjl1Dt/2/EQmgwMjy9O7t+Y6qqBgqrtlNH2hC9p8lTszWpfVknWxf
	 Oh8riSyEVi03Q==
Date: Fri, 6 Sep 2024 14:21:10 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 7/9] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Message-ID: <20240906132109.GC16959@willie-the-truck>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <7-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2024 at 08:31:21PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level CD table is (at most) 1024 entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
> CPU pointer (16k).
> 
> There are two copies of the l2ptr_dma, one is stored in the struct
> arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
> use. Instead of storing two copies just decode the value from the __le64.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>  2 files changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e6607d9d590c4d..d23a845ad82223 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1179,31 +1179,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  	arm_smmu_cmdq_batch_submit(smmu, &cmds);
>  }
>  
> -static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
> -					struct arm_smmu_l1_ctx_desc *l1_desc)
> +static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
>  {
> -	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
> -
> -	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
> -					    &l1_desc->l2ptr_dma, GFP_KERNEL);
> -	if (!l1_desc->l2ptr) {
> -		dev_warn(smmu->dev,
> -			 "failed to allocate context descriptor table\n");
> -		return -ENOMEM;
> -	}
> -	return 0;
> -}
> -
> -static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> -				      struct arm_smmu_l1_ctx_desc *l1_desc)
> -{
> -	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
> -		  CTXDESC_L1_DESC_V;
> +	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
>  
>  	/* The HW has 64 bit atomicity with stores to the L2 CD table */
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> +static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
> +{
> +	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
> +}
> +
>  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  					u32 ssid)
>  {
> @@ -1243,13 +1231,17 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
>  
>  		l1_desc = &cd_table->l1_desc[idx];
>  		if (!l1_desc->l2ptr) {
> -			__le64 *l1ptr;
> +			dma_addr_t l2ptr_dma;
>  
> -			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> +			l1_desc->l2ptr = dma_alloc_coherent(
> +				smmu->dev,
> +				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
> +				&l2ptr_dma, GFP_KERNEL);

Here's another example of the inconsistent indentation.

Will
