Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E0D12F5A5;
	Fri,  6 Sep 2024 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725628763; cv=none; b=DKv6V6G+zTzs1iubyRDz0afNyVlTkpubVrbr+2GnQlQoaAfFzVBwXPrbO8ERlWm0URqf45ApaoFhuK1yRaf4DRZLGwbH2+A67DIJDGZhlMHZiwZomCCBkdEKf87pIP0HnvLhi73eWtZH7wE3I/urtzv5aoK0yZLSsmoa8KLDd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725628763; c=relaxed/simple;
	bh=V2kNjQBVh/Pu3tP9fT62ju5F7S0dbAZWTF5dtwPsfFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJ9r3aT3DBARNAy+I6u95WndSSIWBRQDSNap6KCY0OkoEU8Ypcro8LbsPf/sgOlraq0HHK2oUzigpGfPY99wujAAJ5kQa2TBgUbtcG8Dr3ssA2f8zYdw1x2U7e6fPYOWxP0wntf7zA6QeIm3bmcwix+w36UyXnukmIpo1tnaRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgMfUTPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgMfUTPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDA0C4CEC4;
	Fri,  6 Sep 2024 13:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725628763;
	bh=V2kNjQBVh/Pu3tP9fT62ju5F7S0dbAZWTF5dtwPsfFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgMfUTPVaI8cjozcYtW5pV5ccOGNX6MfLwKoLu6j/H3EWenTF9Iw9uCxnrZY6hbVD
	 pEz/YBlCtVYSSc30oT1Txs0v2IfUeaoGx4n/MyZDe28MR8IDmSfbypCUeeL/GjAkri
	 xgVNiN7eYfguW/qEOMzTw9QtI625YWP3oiLz5Y6WVVThQ+IWG3qyNdPBte42FXs1q4
	 vVMPc+ivHB98jV7ePI1JuTPGEy0P92cSI51dxUntHRvrk/DvWJkQeh1tko6+mCpu1Z
	 DMv1z+13dn3KcO1O+T+Zypw2ANFwIMvK3UAdDOY53lNhHN3FPKYqUSsd3r9bU65toP
	 3aZgeJB2RALaA==
Date: Fri, 6 Sep 2024 14:19:17 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 4/9] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_strtab_cfg
Message-ID: <20240906131917.GB16959@willie-the-truck>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <4-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2024 at 08:31:18PM -0300, Jason Gunthorpe wrote:
> The members here are being used for both the linear and the 2 level case,
> with the meaning of each item slightly different in the two cases.
> 
> Split it into a clean union where both cases have their own struct with
> their own logical names and correct types.
> 
> Adjust all the users to detect linear/2lvl and use the right sub structure
> and types consistently.
> 
> Remove STRTAB_STE_DWORDS by changing the last places to use
> sizeof(struct arm_smmu_ste).
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 77 ++++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 26 +++----
>  2 files changed, 50 insertions(+), 53 deletions(-)

[...]

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 3a8a459f899fd8..18e85fc936876b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -207,10 +207,8 @@
>  #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
>  #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
>  
> -#define STRTAB_STE_DWORDS		8
> -
>  struct arm_smmu_ste {
> -	__le64 data[STRTAB_STE_DWORDS];
> +	__le64 data[8];
>  };

As discussed before, please keep this part as-is (i.e. __le64
data[STRTAB_STE_DWORDS])

Will
