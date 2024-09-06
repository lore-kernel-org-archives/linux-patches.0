Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A7512F5A5;
	Fri,  6 Sep 2024 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725628948; cv=none; b=APwWoLfQBV3mKISLem2uuvtGMj7Cl3me1Etz7tDZHFzo2HwJDdCdHu4Fx/sEhfL+FglRc1+CullgtYt5ZGn8FZ4Bkbis3169eivbHHcZIilJuVodOzlfHXeYc0QUHWXwiFDy6qOKjjYNeuRJG4WICzGGwHlad/jhg1To/B9bkmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725628948; c=relaxed/simple;
	bh=eG+K9U2FPeMI2cKAx5U5Lhi1CeOmU3bujeYYMdm/q6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWzk4/eiqnTH6PN1MoSQZPNKwpkRqoDtmvtTn7BfC3cGZAOE38Kh29eSG4iyAPS6LL/sXkgZ6s40cB7bGXYlRyCSn6vDUF9K5h1lpMmYiD9sme8t0UbrUntuDbS2H+/p32I7lCFPJJVyyJwwy4+m1c4jE07gXWFqi/da226Hrtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AU8L3ybY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AU8L3ybY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECEC4CEC4;
	Fri,  6 Sep 2024 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725628948;
	bh=eG+K9U2FPeMI2cKAx5U5Lhi1CeOmU3bujeYYMdm/q6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AU8L3ybYUfNUEZduNf/LmtCvO8PERSS1csPoSJxkkvRp/kuT4s6F6FpF6hf2iB0Bn
	 nSjli2BsAxUFaUv7CUmKNgoejuQpBNiAFFczsR5tb2AI+FxZBqPscrfEfcFJbTR8ST
	 fjsO9n916x5oIVFyEc8AbbWY7Z1oOywHv8qKphuCSnDeXyy/+A1IXrM9nOTpUwtwX9
	 bH7TpNQ56NJWIBCX2h94o8dnW0nqlsdpjNe3JFpSLJddTqcP6l6lo+RShqj1cUrVUn
	 Z45mfZjy88TBC7JjgaiPTRBWNkOGb+5RuBfLrrDaFy0PoAJ2iEEzPU63JTlqxbOiyW
	 O083wHyUd6Ebg==
Date: Fri, 6 Sep 2024 14:22:22 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 9/9] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_ctx_desc_cfg
Message-ID: <20240906132222.GD16959@willie-the-truck>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <9-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2024 at 08:31:23PM -0300, Jason Gunthorpe wrote:
> @@ -1373,8 +1368,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
>  
>  static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  {
> -	int ret;
> -	size_t l1size;
>  	size_t max_contexts;
>  	struct arm_smmu_device *smmu = master->smmu;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> @@ -1385,71 +1378,67 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB) ||
>  	    max_contexts <= CTXDESC_L2_ENTRIES) {
>  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
> -		cd_table->num_l1_ents = max_contexts;
> +		cd_table->linear.num_ents = max_contexts;
>  
> -		l1size = max_contexts * sizeof(struct arm_smmu_cd);
> +		cd_table->linear.table = dma_alloc_coherent(
> +			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
> +			&cd_table->cdtab_dma, GFP_KERNEL);
> +		if (!cd_table->linear.table)
> +			return -ENOMEM;
>  	} else {
>  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
> -		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
> -						  CTXDESC_L2_ENTRIES);
> +		cd_table->l2.num_l1_ents =
> +			DIV_ROUND_UP(max_contexts, CTXDESC_L2_ENTRIES);
>  
> -		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
> -					    sizeof(*cd_table->l1_desc),
> -					    GFP_KERNEL);
> -		if (!cd_table->l1_desc)
> +		cd_table->l2.l2ptrs = kcalloc(cd_table->l2.num_l1_ents,
> +					     sizeof(*cd_table->l2.l2ptrs),
> +					     GFP_KERNEL);
> +		if (!cd_table->l2.l2ptrs)
>  			return -ENOMEM;
>  
> -		l1size = cd_table->num_l1_ents *
> -			 sizeof(struct arm_smmu_cdtab_l1);
> +		cd_table->l2.l1tab = dma_alloc_coherent(
> +			smmu->dev,
> +			cd_table->l2.num_l1_ents *
> +				sizeof(struct arm_smmu_cdtab_l1),
> +			&cd_table->cdtab_dma, GFP_KERNEL);
> +		if (!cd_table->l2.l1tab) {
> +			kfree(cd_table->l2.l2ptrs);
> +			cd_table->l2.l2ptrs = NULL;
> +			return -ENOMEM;
> +		}
>  	}
> -
> -	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
> -					     &cd_table->cdtab_dma, GFP_KERNEL);
> -	if (!cd_table->cdtab) {
> -		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
> -		ret = -ENOMEM;
> -		goto err_free_l1;
> -	}
> -
>  	return 0;
> -
> -err_free_l1:
> -	if (cd_table->l1_desc) {
> -		kfree(cd_table->l1_desc);
> -		cd_table->l1_desc = NULL;
> -	}
> -	return ret;

Why inline the error path here? Sure, I get that it works both ways, but
it seems a little gratuitous to me.

Will
