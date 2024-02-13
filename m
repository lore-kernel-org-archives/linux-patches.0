Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE1A381A0;
	Tue, 13 Feb 2024 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707823221; cv=none; b=NvcNflJM5RAU5x7IlNtusldQrd38ehSDwzV6Vg4gL1/gkLfE4hulWm8n6+W6atIwIZyPx1ui0Wxu1pjrklsHcCCeJWLbbOPxKWZf1sYWQ9XhyygkgOFhntoTmjYDLDM5UAUKTPpbSfKRL8r9PQJcib5KRoWnv1+lLpucECnv+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707823221; c=relaxed/simple;
	bh=OBqVJC0Sb2klbh4axOYTY3Oo23HaXmEF6nu0XHPIbuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poxsTqyvvBZ6XtTwJqJeKucHcFLFefv7OY1+FVrp5VEYwT+e9U3FeC2bBdAG5z6381wAJtDD72yJRmPvSqONq60NtThXHwEZ+BGKufhOgX6xpWvE5hFNFsQ9gKk4J8UOIelUCyNZwA4Fj9pUU6ecMT/ppGb0QLFDFXGHrMjVbks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sc2h6tHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sc2h6tHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24826C433F1;
	Tue, 13 Feb 2024 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707823220;
	bh=OBqVJC0Sb2klbh4axOYTY3Oo23HaXmEF6nu0XHPIbuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sc2h6tHe+OJP6LB6CPm4cOgwikiGtHW8YPoLlC590oqJNAS/mmj5YWQCLjeh7hdnM
	 R9ZHWoP1WlGCq930SXB7nYyf4k6MVVxaHmdjZ0eEDm54HwhbbLCSRU5226iIkhT3Gc
	 oKOtXiPaA9fK6oF7sMN7Q/GhKKnppKmubccRc+0qsYPyLLWcXgoEd3oloEfcriimhU
	 cj3ke4Do8Jjlh+DWmOD3zIrasJiZR/dMcdYSddrND1AuOiIW4Y/6b/STCOGLJU0nFG
	 E1mrNKSoAn5shQcRjgns5ggv9jHinxWTvPQwJ+AgRDGWouvKQ425jsZuv9CwVhWKGc
	 4Eq/b1oT8XxLQ==
Date: Tue, 13 Feb 2024 11:20:15 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240213112015.GB28517@willie-the-truck>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208142729.GH10476@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Thu, Feb 08, 2024 at 10:27:29AM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 08, 2024 at 12:58:47PM +0000, Will Deacon wrote:
> > On Fri, Feb 02, 2024 at 10:28:05AM -0400, Jason Gunthorpe wrote:
> > > If the SMMU is configured to use a two level CD table then
> > > arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> > > GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> > > iterate over the device list - thus it will trigger a sleeping while
> > > atomic warning:
> > > 
> > >   arm_smmu_sva_set_dev_pasid()
> > >     mutex_lock(&sva_lock);
> > >     __arm_smmu_sva_bind()
> > >      arm_smmu_mmu_notifier_get()
> > >       spin_lock_irqsave()
> > >       arm_smmu_write_ctx_desc()
> > > 	arm_smmu_get_cd_ptr()
> > >          arm_smmu_alloc_cd_leaf_table()
> > > 	  dmam_alloc_coherent(GFP_KERNEL)
> > > 
> > > This is a 64K high order allocation and really should not be done
> > > atomically.
> > > 
> > > The proper answer is to sequence CD programming in a way that does not
> > > require the device list or a spinlock. Part two of my lager series does
> > > this and already solves this bug.
> > > 
> > > In the mean time we can solve the functional issue by preallocating the CD
> > > entry outside any locking. CD leafs are effectively never freed so this
> > > guarantees the arm_smmu_write_ctx_desc() inside the lock will not take the
> > > allocation path.
> > > 
> > > Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
> > > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 5 +++++
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 2 +-
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 ++
> > >  3 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > index 05722121f00e70..068d60732e6481 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > @@ -588,6 +588,11 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> > >  {
> > >  	int ret = 0;
> > >  	struct mm_struct *mm = domain->mm;
> > > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > > +
> > > +	/* Preallocate the required leafs outside locks */
> > > +	if (!arm_smmu_get_cd_ptr(master, id))
> > > +		return -ENOMEM;
> > 
> > What guarantees that all the masters in the domain share the same l2 CD
> > table?
> 
> Nothing, in fact they don't.
> 
> However, a multi-master RID domain is something that doesn't fully
> work with SVA today. This code is functionally/security wrong to
> install the PASID into all the masters that share the RID domain.
> 
> In practice that doesn't happen because the iommu group size when
> PASID is enabled is restricted to 1 and the DMA API is the thing that
> has created a unique per-group domain to be able to turn SVA on at
> all.
> 
> So, the RID domain's list has one master entry that is the same as the
> set_dev_pasid's master.
> 
> Which is why this patch works, it prealloctes the only master that
> matters for the only configuration where SVA works and is used today.
> 
> iommufd could violate these assumptions which is part of why I'm
> fixing all of this in preparation to enable PASID support for all
> drivers in iommufd.

Damn, all the surrounding rework has really left this poor code in a bit
of a state. Could you please respin your fix, but with an additional change
to arm_smmu_mmu_notifier_get() so that it returns an error if there is
more than one device in the domain, with some of the above in a comment?

Cheers,

Will
