Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850D135F17E;
	Tue,  3 Mar 2026 12:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772542419; cv=none; b=rpUaux8rdB8Ljy3P3nxEmgCGA7SiR4o3j/pO7x0ZT4LD7BuVMJSPQfxNrlYgVLtHPjYsmjRC6jZhhpmzAGgFEa5gxdTg1zwEoo5k9rGdnt1iyW1q4mwSG985nqA5FPEzeDxDpwCDOa0OYP+//oNawzcCznFIIW1FSYV+djecIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772542419; c=relaxed/simple;
	bh=3VZUa3Z3I4IvtbEVs+gHsiaoPffVUCSkCeCxStE5bd8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKp9dBokDvDzt5iaCrwfSctcM97Y0LN3n/fraBqILe1XjmgNBneyqka6wvFe96m3y9KnLvbMpDxOgIzx3FpmwSikbaVAZOiF1vA1TQSRadbaCV+K+MKge6psRAdmnT8bCCUhKfk7Yp3p01uzFJLs8PmwhUv0t43o20DogEp7U5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 883E1497;
	Tue,  3 Mar 2026 04:53:30 -0800 (PST)
Received: from [10.57.56.165] (unknown [10.57.56.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C67CF3F7BD;
	Tue,  3 Mar 2026 04:53:34 -0800 (PST)
Message-ID: <13e28ac2-a4d6-466a-aef2-7b3d7d9167bd@arm.com>
Date: Tue, 3 Mar 2026 12:53:28 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-02 10:22 pm, Jason Gunthorpe wrote:
> An empty gather is coded with start=U64_MAX, end=0 and several drivers go
> on to convert that to a size with:
> 
>   end - start + 1
> 
> Which gives 2 for an empty gather. This then causes Weird Stuff to
> happen (for example an UBSAN splat in VT-d) that is hopefully harmless,
> but maybe not.
> 
> Prevent drivers from being called right in iommu_iotlb_sync().
> 
> Auditing shows that AMD, Intel, Mediatek and RSIC-V drivers all do things
> on these empty gathers.
> 
> Further, there are several callers that can trigger empty gathers,
> especially in unusual conditions. For example iommu_map_nosync() will call
> a 0 size unmap on some error paths. Also in VFIO, iommupt and other
> places.

My instinct is still to tidy up the 0-length unmap case(s), but I guess 
iommu_iotlb_sync() is itself also a public API where being more robust 
against erroneous usage is no bad thing. With one minor nit below,

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Cc: stable@vger.kernel.org
> Reported-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Closes: https://lore.kernel.org/r/11145826.aFP6jjVeTY@jkrzyszt-mobl2.ger.corp.intel.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/linux/iommu.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 54b8b48c762e88..555597b54083cd 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -980,7 +980,8 @@ static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
>   static inline void iommu_iotlb_sync(struct iommu_domain *domain,
>   				  struct iommu_iotlb_gather *iotlb_gather)
>   {
> -	if (domain->ops->iotlb_sync)
> +	if (domain->ops->iotlb_sync &&
> +	    likely(iotlb_gather->start < iotlb_gather->end))

Elsewhere we just use "gather->end != 0" as the "non-empty" condition; 
how concerned are we about defending against more-intentionally 
malformed gathers here?

Thanks,
Robin.

>   		domain->ops->iotlb_sync(domain, iotlb_gather);
>   
>   	iommu_iotlb_gather_init(iotlb_gather);

