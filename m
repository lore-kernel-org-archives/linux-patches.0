Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB8816F900;
	Fri,  1 Nov 2024 11:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730462314; cv=none; b=VN4xW3ZFOLohUBo5JJ8EbM3jTetmf8D8+fqpoRT3vE0UfCDfAEccV1CK0E+pkCWbuilftE2CC2vbbcMwDi0lRCdYobu1M8992BrzTrmnDv6Jxi9uZHV2M8MWKcSpD/K6f3qLclZhKUdTIOI7B+ZdFFAVEIzuZMhQum+yq94i+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730462314; c=relaxed/simple;
	bh=wQJd1QeaY5fZACRK8ZUHBa2nukVJlXs5K5OJXkkqg1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAMIeDVEasUpAfAix2bOmP+3SOkKISr9RptmwXntAPgkcErzq8FZR1czGCgQckLWgQ9iKASJPC4O1Zj4PN2yl8fnWEX3p166lRXsgxxl7dAy572l9hTkAdKP7N/wJK8aH+3/RWtYL9FpEAdsa5ESdXExFxuOEYND0gUX1K4RnN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LcPIH2tV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LcPIH2tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AF2C4CECD;
	Fri,  1 Nov 2024 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730462314;
	bh=wQJd1QeaY5fZACRK8ZUHBa2nukVJlXs5K5OJXkkqg1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LcPIH2tVnxOVyM+MqcErAO1FrH3NGliUPH2ix6SZspJbwRQ8na/OibDZ7bPQXeY2C
	 wQNMZhW2B1UOQ7XXRd1N39J7f/fqMzo21s/DKvSmoYosGhseHaMde/KdQ49w40feG5
	 7/vk5ynrSBMsvynwbpysOJDxGY2aiUf45fbT8t3EkllFzThkRDM+RUtqRzm/al7O2N
	 7vKy6KL35pUoR0ywzEWmURuYc2qTdG1PKOAjv3daNRCEMG5e1xRPuVxsBnYpGQ0KYM
	 v9MQQPtnAGcL5OBZG9Gf51VITUR0tViQ2sBW0LC0g4jv3rVcol9qgBCh+DnPHqis3B
	 gVXUJlgKjHKEg==
Date: Fri, 1 Nov 2024 11:58:29 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
Message-ID: <20241101115828.GB8518@willie-the-truck>
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Oct 18, 2024 at 02:19:26PM -0300, Jason Gunthorpe wrote:
> Of the page table implementations (AMD v1/2, VT-D SS, ARM32, DART)
> arm_lpae is unique in how it handles partial unmap of large IOPTEs.
> 
> All other drivers will unmap the large IOPTE and return it's length.  For
> example if a 2M IOPTE is present and the first 4K is requested to be
> unmapped then unmap will remove the whole 2M and report 2M as the result.
> 
> arm_lpae instead replaces the IOPTE with a table of smaller IOPTEs, unmaps
> the 4K and returns 4k. This is actually an illegal/non-hitless operation
> on at least SMMUv3 because of the BBM level 0 rules.
> 
> Long ago VFIO could trigger a path like this, today I know of no user of
> this functionality.
> 
> Given it doesn't work fully correctly on SMMUv3 and would create
> portability problems if any user depends on it, remove the unique support
> in arm_lpae and align with the expected iommu interface.
> 
> Outside the iommu users, this will potentially effect io_pgtable users of
> ARM_32_LPAE_S1, ARM_32_LPAE_S2, ARM_64_LPAE_S1, ARM_64_LPAE_S2, and
> ARM_MALI_LPAE formats.
> 
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/io-pgtable-arm.c | 72 +++-------------------------------
>  1 file changed, 6 insertions(+), 66 deletions(-)
> 
> I don't know anything in the iommu space that needs this, and this is the only
> page table implementation in iommu that does it.

I think the v7s code does it as well, so please can you apply the same
treatment to arm_v7s_split_blk_unmap()?

> @@ -678,12 +618,12 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>  
>  		return i * size;
>  	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> -		/*
> -		 * Insert a table at the next level to map the old region,
> -		 * minus the part we want to unmap
> -		 */
> -		return arm_lpae_split_blk_unmap(data, gather, iova, size, pte,
> -						lvl + 1, ptep, pgcount);
> +		/* Unmap the entire large IOPTE and return its size */
> +		size = ARM_LPAE_BLOCK_SIZE(lvl, data);

If I understand your other message correctly, we shouldn't actually get
into this situation any more, right? In which case, can we WARN_ONCE()
and return 0 instead? Over-unmapping is filthy!

Will
