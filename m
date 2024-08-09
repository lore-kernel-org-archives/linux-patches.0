Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99691953A2;
	Fri,  9 Aug 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215991; cv=none; b=jH/Sz0aa7Pek92xVE4Ys5H9kHUXPlP3XXGPgkU2fBvRxa9/FMm/uxCoudf7p3+jv6lv6cb3LEI8A/IlcQFKUfeRwSVU9zGKm7mtUfF5VydZ850JBxrF1iMJUsn6vEISPkCA0mmPItdXLU74vsX3ND2/xv/dxoefs/T+wreLt8zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215991; c=relaxed/simple;
	bh=qJLpcmJL5MiVhs4WhWQq98pLwY/iHNAfWKPrXRL/4HE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qYc7LLiKgixMC5GV8xSLRjpQhaC20laZDuYULucnOp6OJk3rwFq6/QiDoPP+ba12pdug6rABK+RaQLGufEQw0MljIOL7ncliKRM1O4d7h6hoB0ljt4CNfdxeFnKuFDHl5TTeDsjIkywj151xTYe/5uKSVn9Mvizab4elvTeoMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A36B013D5;
	Fri,  9 Aug 2024 08:06:53 -0700 (PDT)
Received: from [10.57.46.232] (unknown [10.57.46.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAB073F71E;
	Fri,  9 Aug 2024 08:06:23 -0700 (PDT)
Message-ID: <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
Date: Fri, 9 Aug 2024 16:06:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
To: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev,
 Alex Williamson <alex.williamson@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
> 
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6bbe4aa7b9511c..5faaccef707ef1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   			   const struct iommu_user_data *user_data)
>   {
>   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
>   	struct arm_smmu_domain *smmu_domain;
>   	int ret;
>   
> @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   	if (!smmu_domain)
>   		return ERR_PTR(-ENOMEM);
>   
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> +		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {

Nope, nesting needs to rely on FEAT_NESTING, that's why it exists. S2 
alone isn't sufficient - without S1 there's nothing to expose to 
userspace, so zero point in having a "nested" domain with nothing to 
nest into it - but furthermore we need S2 *without* unsafe broken TLBs.

Thanks,
Robin.

> +			ret = -EOPNOTSUPP;
> +			goto err_free;
> +		}
> +		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +	}
> +
>   	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
>   	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
>   	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
