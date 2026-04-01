Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EC129405;
	Wed,  1 Apr 2026 12:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775047992; cv=none; b=MFroevjObSiONe50hpCpmnMTJxp/68uQd2ZjSK/4SgfoVRXz7dXn9HW7s+x3vvdc+KSr0GD/ytlkzNu/GeBwZz7IyjBzSbioXd4ByvIj2ox/MHeBfiOL5b4kHfb3eVoySjPrUq1RSsJI9Q/vy2iTPX4KoH2EiNEHmQLpZhHEflA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775047992; c=relaxed/simple;
	bh=VtqdUmaN6v0sUlDrZ1wh5acNDB4v7exfl0mPMNT/GRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXBkuwIitK9yudMzJlIscoQAcyHwD3hq+lZfUJsyJvMVbo9+USvSAkdsK+udx/UIzf61wybM4eoGCIt7GwhFA80PqbevowVjVPQaf+NwvUhxcwD5DGOG/ItzJbUjRoilT6IIsNT8Bau9iV6pEetQpKcrj6pnO21EcP7QnqvYUA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KnPQaqRi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KnPQaqRi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 761E11F91;
	Wed,  1 Apr 2026 05:53:03 -0700 (PDT)
Received: from [10.57.77.192] (unknown [10.57.77.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC26F3F915;
	Wed,  1 Apr 2026 05:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775047989; bh=VtqdUmaN6v0sUlDrZ1wh5acNDB4v7exfl0mPMNT/GRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KnPQaqRi0tCTRUB2d1G5ZWCeJmR+5w0WLKfS/DTDiUI87uUWvjLwaxuZVbYcF5Ey+
	 +AIqNj6TC53qgajaKP1Af96Yfc/0NvV4virwmGEimOqLAuulFL7dPDF6steMi7rO9T
	 hhNiiai2Vhbe7/cYk78O/xv6beFRRR/m4BEZDok4=
Message-ID: <ce5c6be3-0a59-498b-ac0d-eb0dbc1530f6@arm.com>
Date: Wed, 1 Apr 2026 13:53:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-26 7:30 pm, Jason Gunthorpe wrote:
> iommupt always supports the semantics required for DMA-FQ, when drivers
> are converted to use it they automatically get support.
> 
> Detect iommpt directly instead of using IOMMU_CAP_DEFERRED_FLUSH and
> remove IOMMU_CAP_DEFERRED_FLUSH from converted drivers.
> 
> This will also enable DMA-FQ on RISC-V.

I'd much prefer to just add the cap to the RISC-V driver so it's 
obvious, rather than deliberately introduce a fiddly inconsistency. 
Besides, having iommu-dma poke directly at driver-specific internal 
implementation details seems exactly the kind of layering violation 
you're normally the first to object to.

Note that IOMMU_CAP_CACHE_COHERENCY is also arguably a property of 
generic_pt, in as much as all its users are default-coherent with 
IOMMU_CACHE implied, but again RISC_V doesn't report that where AMD and 
Intel do.

Thanks,
Robin.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c   |  2 --
>   drivers/iommu/dma-iommu.c   | 13 ++++++++++++-
>   drivers/iommu/intel/iommu.c |  2 --
>   3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 528ebdd26d71c9..daa9eac1184748 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2991,8 +2991,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
>   		return amdr_ivrs_remap_support;
>   	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>   		return true;
> -	case IOMMU_CAP_DEFERRED_FLUSH:
> -		return true;
>   	case IOMMU_CAP_DIRTY_TRACKING: {
>   		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
>   
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 5dac64be61bb27..fbed93f8bf0adb 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -14,6 +14,7 @@
>   #include <linux/device.h>
>   #include <linux/dma-direct.h>
>   #include <linux/dma-map-ops.h>
> +#include <linux/generic_pt/iommu.h>
>   #include <linux/gfp.h>
>   #include <linux/huge_mm.h>
>   #include <linux/iommu.h>
> @@ -648,6 +649,15 @@ static void iommu_dma_init_options(struct iommu_dma_options *options,
>   	}
>   }
>   
> +static bool iommu_domain_supports_fq(struct device *dev,
> +				     struct iommu_domain *domain)
> +{
> +	/* iommupt always supports DMA-FQ */
> +	if (iommupt_from_domain(domain))
> +		return true;
> +	return device_iommu_capable(dev, IOMMU_CAP_DEFERRED_FLUSH);
> +}
> +
>   /**
>    * iommu_dma_init_domain - Initialise a DMA mapping domain
>    * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
> @@ -706,7 +716,8 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
>   
>   	/* If the FQ fails we can simply fall back to strict mode */
>   	if (domain->type == IOMMU_DOMAIN_DMA_FQ &&
> -	    (!device_iommu_capable(dev, IOMMU_CAP_DEFERRED_FLUSH) || iommu_dma_init_fq(domain)))
> +	    (!iommu_domain_supports_fq(dev, domain) ||
> +	     iommu_dma_init_fq(domain)))
>   		domain->type = IOMMU_DOMAIN_DMA;
>   
>   	return iova_reserve_iommu_regions(dev, domain);
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 5dca8e525c73c8..80b183e207e59b 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3212,8 +3212,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
>   
>   	switch (cap) {
>   	case IOMMU_CAP_CACHE_COHERENCY:
> -	case IOMMU_CAP_DEFERRED_FLUSH:
> -		return true;
>   	case IOMMU_CAP_PRE_BOOT_PROTECTION:
>   		return dmar_platform_optin();
>   	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
> 
> base-commit: 447597c362ec566082b75688f2a8883771c066d5

