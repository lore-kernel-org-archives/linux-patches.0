Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE5437C91C;
	Fri,  3 Apr 2026 09:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207799; cv=none; b=JbXFMUqRcKqNHkIvJHGffOFtBZBWczSkNxYaeWaA9+LaKjJ98Cv7wpCJBzYryapLkkGKWQritOkYq0rjzBn7sue62foZAKxyN5Gc9dS3kftkTyMvT61bhhfcbbBeCK6OqKO6nYB2HlbxSJ8dshnl3E2oxo9eMgmoQEvWSO0alHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207799; c=relaxed/simple;
	bh=BxMdH4H6NQznhqSvJN2VPxMMtMgaxABq3vFi1FG4kCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJcsxuqPvSfWre5zoEnCNJ7CyNR741vKz0LyWjezptD4m5WVtZd0rYEcKlSVG3ZJSp42MUU445TyoQMuA51hvHhF85o1QPzv4Zmwm9LZzlIjb67VEWkrGjzP5w96ey36OGgt0bWaOwQyrp4FQaUygbL+Rw+CuFC7gBwuGRKfSw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWdRIKp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWdRIKp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8E3C4CEF7;
	Fri,  3 Apr 2026 09:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775207799;
	bh=BxMdH4H6NQznhqSvJN2VPxMMtMgaxABq3vFi1FG4kCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWdRIKp8oBC6NRLvqKQdqy1gNAtj2UFl0ObT7uaQonkHNmQH+KolL+r4OlLDJWJ0x
	 Z2SKyigXJHO9ozFdSqbSrQqyDYFuNYdFDYIiDgpk30RkGS6AFOVCtMznGFUvopxD3X
	 BMqaepDBGxuUx01jC7VJ82s5IDhiFwtznHJ70YDJtB9S2qgWu63h99K8d4ACigbMqm
	 0e9h8RHHlhRaMsqXKWlQW+O8m5dZv1q+fI+qzy6waA4Wac+hxUq1BIsxr/1uKubtre
	 q8yFOpTaP//jxxNvC56DtczLa/Nfw+dNksevUnehQU0RsoQMzfEDczp2V7BXc/F2b4
	 vrjk5/9WZ/sdQ==
Date: Fri, 3 Apr 2026 10:16:34 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
Message-ID: <ac-FclRknG4bwipa@willie-the-truck>
References: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
 <ce5c6be3-0a59-498b-ac0d-eb0dbc1530f6@arm.com>
 <20260401131349.GA310919@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131349.GA310919@nvidia.com>

On Wed, Apr 01, 2026 at 10:13:49AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 01, 2026 at 01:53:05PM +0100, Robin Murphy wrote:
> > Note that IOMMU_CAP_CACHE_COHERENCY is also arguably a property of
> > generic_pt, in as much as all its users are default-coherent with
> > IOMMU_CACHE implied, but again RISC_V doesn't report that where AMD and
> > Intel do.
> 
> Hmm.. Currently generic_pt doesn't have any idea if IOMMU_CACHE is
> supported and working in HW. All the implemented formats ignore
> IOMMU_CACHE entirely, they use IOMMU_MMIO to build any any non-caching
> PTE.
> 
> SMMUv3 will be unlike the other three and needs
> IOMMU_CAP_CACHE_COHERENCY.  IDK if ARM should be writing non-caching
> PTEs for non-coherent DMA, it doesn't now..

Sorry, but I'm not sure I follow here. The driver just honours
IOMMU_CACHE when writing the ptes and dma_info_to_prot() sets that
according to whether or not the device is coherent. I'd prefer not to
have the SMMU driver second-guess the DMA API around what is best for
the endpoint.

Will
