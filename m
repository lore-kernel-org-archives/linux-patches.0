Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D81839F4;
	Tue,  2 Jul 2024 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945973; cv=none; b=upVz5EFzjn/GkFB0z2iHDmnvcU1ydWbKsLk1PWigFEZk6iza2cw7oOScN1VFRc9KUTWDpGOAOWtnCHy6l3kMQY/2j6BpIZdxqytwr3HtM/8IRtPtAW5Vlr73PdGESGPyU4j5Uv3zMJljTm9Ztae9O2tGi8cx7E5gXzrpWwnapgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945973; c=relaxed/simple;
	bh=zKcboGopUpXZcEqm/6bvui8A4l4YrPWn3D7EUVQHDI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lS74U547it9hqXWgp4BFCo8xgJ2X2nWUSTTlt9QtClVSG6vUc3Zqr6yJn1e5oYutUMX+BByNmji5QAb1xgTX2ZBtM/QQSvCKrGpOdpFpBfua9FGLavMZ0vV2wSxPPIoYuPP0k+W10vVB813mt7NZTfJJS/m+psMHHCjxnxfCNGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek+obUwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek+obUwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A65FC116B1;
	Tue,  2 Jul 2024 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719945972;
	bh=zKcboGopUpXZcEqm/6bvui8A4l4YrPWn3D7EUVQHDI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ek+obUwfMgeFNdm7h0lPQDt8ViEifkiA2t2tWuvrQWP2L84R025E7XrgPCX1126re
	 ITajgc3dHVwNxRTKD+SMnsrir8sPyNmDvccNyWchpBPtlhQD53wb68HrwqpQ0pDHl8
	 o21B518BT73bZR+jNfWowMjcx8kdMJKslzilUVMKabpVYIdyH+RIgdHfZXChfosODg
	 PCPe9s4uMIUsrDqcHnLa1blkzoXEG68cUIxJD+F3yKcGovHp+BPTBL7Yrsm6HyEWBL
	 MPk6KoUqUfk3qq+LtcOlQSYgzNHavVrfJyw02C4YqdNe/QMsTVNCRGUJCxkiv4XqHW
	 S4pY5PcjXYzDg==
Date: Tue, 2 Jul 2024 19:46:07 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 08/10] iommu/arm-smmu-v3: Shrink the cdtab l1_desc
 array
Message-ID: <20240702184607.GB5167@willie-the-truck>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 10, 2024 at 09:31:17PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level CD table is (at most) 1024 entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
> CPU pointer (16k).
> 
> There are two copies of the l2ptr_dma, one is stored in the struct
> arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
> use. Instead of storing two copies just decode the value from the __le64.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>  2 files changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6245e2558e6a6a..dd65e27aebafd4 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1167,31 +1167,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
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
> +	return le64_to_cpu(src) & CTXDESC_L1_DESC_L2PTR_MASK;
> +}

I'm assuming this is supposed to be *src, in which case this could be
accessing non-cacheable memory if the SMMU isn't coherent. That's why we
shadow everything.

If the current code isn't causing you any problems, please can we leave
it as-is?

Will
