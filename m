Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D961DFFC;
	Tue,  2 Jul 2024 14:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719932232; cv=none; b=BTrzdAXOZyFziMdQu/Fulvj7IsJrzUHQ6f+ueWOnxMnv+foS7WjmbsKI6W7Ae88IJViBmPWdBmigE9qpQx58iZll9oRuN+TD8rrrWeJ76vG99zQl1Uz3AGjQhEbTOmBwpScLRuUpHfJz6AftxIk4XjvmgmfdOxvxNzVcOaWR8qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719932232; c=relaxed/simple;
	bh=tJJ5oDpsdhd4yOJL5nnPQ6va4IfZoOj+e5qS1B/EmZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Blr7Qg/dDDsGXYAmX50exOg3NRU5lXORdRsZg9kppfyvbIOAd0j1pugQLk+wsuYElXeguac1kKYiJpcjfurxxHCpeb4L4SXJjUCBj4g4muDkQtBmn3YJ7s7KQWh6sK3wDU5b2cu9YCLYx1Q82nvz1H6sEDAJV4SXRbAPnm6/xCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7DJoo8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7DJoo8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E95DC116B1;
	Tue,  2 Jul 2024 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719932231;
	bh=tJJ5oDpsdhd4yOJL5nnPQ6va4IfZoOj+e5qS1B/EmZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7DJoo8C3IhVv5Jpg+hODp1pXKtpwYyq719rETqMdrxyi4/yEM4dM5GAOX0gRv8uk
	 9R1f4p6ZJ4zLqPjG4Ycp/OcWO/JHO+FIpgg4HG9uCUSd8q/+GExkH95t+qxAM8nVhr
	 2ap+ooyJ0YAzb+Nk7MKLMbAP8loSe5sUcNGfFH4FystXJVGRoiWIn3JhbD8usDJlHl
	 6ytNK2RRy45FxddMQXE0YR6evC4iDFFHyJjPAGMmHnkH5Dvj7fT6kQFLPBFNvMr1nB
	 obsC9lmOspEdEHuBiawqpZpTAkZ7r5XU/KqQ0kb9Hv6m/poM1Ns8BQWEM2pIUS35yN
	 fjolOC4/73sIw==
Date: Tue, 2 Jul 2024 15:57:05 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <20240702145705.GA4135@willie-the-truck>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 25, 2024 at 09:37:33AM -0300, Jason Gunthorpe wrote:
> Add arm_smmu_set_pasid()/arm_smmu_remove_pasid() which are to be used by
> callers that already constructed the arm_smmu_cd they wish to program.
> 
> These functions will encapsulate the shared logic to setup a CD entry that
> will be shared by SVA and S1 domain cases.
> 
> Prior fixes had already moved most of this logic up into
> __arm_smmu_sva_bind(), move it to it's final home.
> 
> Following patches will relieve some of the remaining SVA restrictions:
> 
>  - The RID domain is a S1 domain and has already setup the STE to point to
>    the CD table
>  - The programmed PASID is the mm_get_enqcmd_pasid()
>  - Nothing changes while SVA is running (sva_enable)
> 
> SVA invalidation will still iterate over the S1 domain's master list,
> later patches will resolve that.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 57 ++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 32 ++++++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 ++-
>  3 files changed, 67 insertions(+), 31 deletions(-)

[...]

> @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>  	struct arm_smmu_bond *bond = NULL, *t;
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>  
> +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> +
>  	mutex_lock(&sva_lock);
> -
> -	arm_smmu_clear_cd(master, id);

This looks a bit alarming, as you're effectively moving the CD
modification outside of the critical section. I assume we're relying on
the iommu group mutex to serialise this in the caller? I can't see any
consistent locking in the driver for arm_smmu_clear_cd().

As an additional patch, perhaps we should consider documenting what each
lock in the driver protects and the lock ordering requirements they
have? We've got a few global locks with generic names and after a few
rounds of refactoring it's really hard to know who's responsible for
what, especially now that we have stale comments referring to
arm_smmu_share_asid(). We've also grown a number of places where we
drop a lock in the callee and immediately re-take it in the caller,
which tends to be a source of bugs.

Thanks,

Will
