Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C677442F;
	Tue,  2 Jul 2024 18:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945982; cv=none; b=lxWlpZrUofp+MiQq2rN/Q84f+P1wOgkn/S9NBcr6cCqjp7a0UBCRBIJ49zAobs68Lbf2bqoukeZejAuwKAeNPNODgqVEK0LOTfXC+Vkxf7jqlRddUMqVX5Q/ef99HTHbFOV5Z0dcjyXShXiaQRYcnmJL3I5/+6Mxw27PPJoLXJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945982; c=relaxed/simple;
	bh=RpD6ZPn6psYDerzh/SZr6lJyji3dy9debma6JB0B/CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNBFszKgn3SflAvyzQSXAF+PPPZicCIZOfpuj6jY4As5ClD4pF3Bz0OqRU3Pv4H07za8yNssDLqiCR4mhkk+7iq3GHdA8aOc30wf3anJpAqIGgdaNsRBRi7ctH6ViIIoH6ONekh4nyq0d7TGXE/hJ41kPvv9DqYazSw0CNmB6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8HD7801; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8HD7801"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A519C116B1;
	Tue,  2 Jul 2024 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719945982;
	bh=RpD6ZPn6psYDerzh/SZr6lJyji3dy9debma6JB0B/CM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P8HD7801Q11KzevNRpwxUdAid4HNF6dnBsY/KQXVHfJtzZwxGhoMTsYrz0Z2Clm1J
	 t64As/tnMknmm8q4SC0lrDgG8fWSm8M2mUGrEu5psUUxYPxbTGPboabKqP9+u9KKtz
	 YgMOjl2oFRHvlVVEvq0PSF1ng5jT/i/rFssYElmdeIktGw/mPqlLGcMCtaJtL0Fb1u
	 6g6AipSrmI3SKK0/UhpJ0/z6wPSccBiwn1IaEfAVR9Ios/NLBRmm9p0UnjS2sFpnJ3
	 xnEgZfWSHbbbLrsf7Ji/JMEAfTVZjE5+5xUdGbLGxZLeAXQ+cNrDOX0npRmpIjxOFU
	 w56f5vmTQTB9A==
Date: Tue, 2 Jul 2024 19:46:16 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_strtab_cfg
Message-ID: <20240702184616.GC5167@willie-the-truck>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 10, 2024 at 09:31:14PM -0300, Jason Gunthorpe wrote:
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
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 79 ++++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 26 +++----
>  2 files changed, 51 insertions(+), 54 deletions(-)

[...]

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 1418f21f5db6a0..8b58a30ebeb06b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -204,10 +204,8 @@
>  #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
>  #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
>  
> -#define STRTAB_STE_DWORDS		8
> -
>  struct arm_smmu_ste {
> -	__le64 data[STRTAB_STE_DWORDS];
> +	__le64 data[8];
>  };

I'm not seeing the improvement here.

Will
