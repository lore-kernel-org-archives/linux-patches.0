Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A77D15820C;
	Fri,  1 Nov 2024 11:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730462087; cv=none; b=LRGwBqznDq9JtJL1zS6KdXo2WfVRMNZv1V5IoFdVjAcQDedOZMNuZs0PGFbxniyJBeREzWrM0oHMhxveBOBSYseHgmHkN5oVMH83+ftJyjpjtbCpGArsCgWVbnzqmyc6THWmx5uPX8H8yILXrMwU5ndUJiXADjYxri/Z7sl4a4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730462087; c=relaxed/simple;
	bh=RKKjaRT+TZqTjTNYJpQRRQla0KpA6rUkiKLNa5Za6jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqm9yyH92jotfSMTsqbz6KAibF1yxEkBerI600v27t/W0/qB/ssg0GiRwTJc8gX9J6cAgVk9P3txur/pcoIrZ7V9/rI8mcvrqencs1zR1RSTo80P+i0c17c/HeAT4TygaFQGc+q4n5WbEPyjPfn3KLh2CqsUrFGsY5RnDKiPLpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fyl3yIsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fyl3yIsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1A3C4CECD;
	Fri,  1 Nov 2024 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730462086;
	bh=RKKjaRT+TZqTjTNYJpQRRQla0KpA6rUkiKLNa5Za6jM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fyl3yIsKzmdaDBfHqMByrFzmiPgh/aFJwAuRsQGSy7+4zPF3jWywWPOAxG0nus5CB
	 LJxMNeegqqs7xYA5fi8NkJh+eO9g2yTw2USFMDhF/PYJSAgxGDkmhPkPNZLu5ZDLDa
	 t7AdNvdn2Jg9M5XUZbR04fsBdsxxPVqdQ7Byw+GjK+UKM2oizoL3Zu9qpxRQp1BzR3
	 CgksJaAM7nKj8PzfhRNlqu/PEgFsKgHpPcUPlxFtp1RIbUJWXq1sbKE0rXdYnzcvQ1
	 uDWVH53Vi/4mSKlryP9ogtRQgTzsBEjGy+JEJIpEWuZ1WEm6ZGUrK/GvsqjIFuSz8t
	 TKmg0tPAHlLjA==
Date: Fri, 1 Nov 2024 11:54:40 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
Message-ID: <20241101115439.GA8518@willie-the-truck>
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
 <20241024130550.GE30704@willie-the-truck>
 <20241024134411.GA6956@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024134411.GA6956@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Thu, Oct 24, 2024 at 10:44:11AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 24, 2024 at 02:05:53PM +0100, Will Deacon wrote:
> 
> > My recollection is hazy, but I seem to remember VFIO using the largest
> > page sizes in the IOMMU 'pgsize_bitmap' for map() requests but then
> > using the smallest page size for unmap() requests, so you'd end up
> > cracking block mappings when tearing down a VM with assigne devices.
> >
> > Is this what you're referring to when you say?
> 
> Sounds like it, but I'm really hazy on the long ago history here.
> 
> >   > Long ago VFIO could trigger a path like this, today I know of no user of
> >   > this functionality.
> > 
> > If so, please can you provide a reference to the patch that moved VFIO
> > off that problematic behaviour?
> 
> Looking more deeply, I'm not really sure VFIO ever required this.
> 
> vfio commit 166fd7d94afd ("vfio: hugepage support for
> vfio_iommu_type1") is the thing that added the huge page support, and
> it called map like:
> 
> +               ret = iommu_map(iommu->domain, iova,
> +                               (phys_addr_t)pfn << PAGE_SHIFT,
> +                               npage << PAGE_SHIFT, prot);
> 
> But then the unmap path still looked like:
> 
> +               unmapped = iommu_unmap(iommu->domain, iova, PAGE_SIZE);
> +               unlocked += vfio_unpin_pages(phys >> PAGE_SHIFT,
> +                                            unmapped >> PAGE_SHIFT,
> +                                            dma->prot, false);
> 
> So at that time it was relying on the "unmap smaller gives the larger
> size" trick that we see Intel and AMD implementing today. No
> requirement for split, but the ARM split code could be triggered.

Urgh, I'm not sure I was ever fully aware of that "trick". That's really
horrible!

> Next came the introduction of VFIO_TYPE1v2_IOMMU which eliminated the
> ability for userspace to request splitting a mapping. Userspace can
> only unmap what userspace maps. commit 1ef3e2bc0422
> ("vfio/iommu_type1: Multi-IOMMU domain support")
> 
>     To do this, our DMA tracking needs to change.  We currently try to
>     coalesce user mappings into as few tracking entries as possible.  The
>     problem then becomes that we lose granularity of user mappings.  We've
>     never guaranteed that a user is able to unmap at a finer granularity
>     than the original mapping, but we must honor the granularity of the
>     original mapping.  This coalescing code is therefore removed, allowing
>     only unmaps covering complete maps.  The change in accounting is
>     fairly small here, a typical QEMU VM will start out with roughly a
>     dozen entries, so it's arguable if this coalescing was ever needed.
> 
> That blocked any requirement for splitting driven by the uAPI. Noting
> uAPI based splitting never worked right and AFAICT AMD didn't
> implement split at the time.
> 
> Finally, commit 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")
> changed the unmap loop to this:
> 
> -               unmapped = iommu_unmap(domain->domain, iova, PAGE_SIZE);
> +               /*
> +                * To optimize for fewer iommu_unmap() calls, each of which
> +                * may require hardware cache flushing, try to find the
> +                * largest contiguous physical memory chunk to unmap.
> +                */
> +               for (len = PAGE_SIZE;
> +                    !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> +                       next = iommu_iova_to_phys(domain->domain, iova + len);
> +                       if (next != phys + len)
> +                               break;
> +               }
> +
> +               unmapped = iommu_unmap(domain->domain, iova, len);
> 
> fgsp=true is only possible on AMD, and this loop effectively
> guarantees that the iommu driver will never see a partial huge page
> unmap as the size is discovered via iommu_iova_to_phys() before
> calling unmap.

Talking to Robin, he reminded me of:

7c6d90e2bb1a ("iommu/io-pgtable-arm: Fix iova_to_phys for block entries")

which looks like it fixes a bug which would've defeated the VFIO chunking
in your snippet above.

But we're all good now, so I'm in favour of dropping this. Let's just
cram some of this history into the commit message so we know why we're
happy to do so.

Lemme go look at the actual diff now...

Cheers,

Will
