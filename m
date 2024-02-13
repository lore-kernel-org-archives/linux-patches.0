Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EEF56473;
	Tue, 13 Feb 2024 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707832594; cv=none; b=LfWUbBzAEvRtG9jGJ423ChtEP0DP13x9ypJLtxTdsUhN/XyIGC96GIaiMJu6qiBks8qGPQCD4fPGJkwY9PvwFlIi6CHP9S+ixMWUTK7tDrU4zziLZe8BKkskBzG8UudLpc21prxhrO42YWTABYMmcZItqcAZI3Swy3nzRANWOTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707832594; c=relaxed/simple;
	bh=W3a/3c1uZ0dj25E8PMQEE+CK/1eOWMi7BE9kh8dAIVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AryDSJYDeRt1yyC1iS9FAR/kYP8zxh7wfnmr+KBUYbYm8NOyL/i6VqIRDXlyef5gmaw/ylqW07QCk5gGja+OpVQZuOz73AzyNLiGHK6ylplAegcVfI66R6cJ99wOMETII05tPVNrZhEdvWGkLBZrIAwAL1Q3Id76rW3UKiNDe40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+mINGko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+mINGko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3023C433F1;
	Tue, 13 Feb 2024 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707832593;
	bh=W3a/3c1uZ0dj25E8PMQEE+CK/1eOWMi7BE9kh8dAIVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W+mINGkoTYj7/i90I8Q9kZW6d2ZhDmLQhesE6Ct7D9xzNCUpZX0Q6eABuRvu+3vva
	 ZilrA777zt1gWJ+Ph1S7ghC2VPHT3lRrN1Oz40uBq4BLwCBF1YT1L65bRK2puFWflW
	 NoKF7YWp0PLTnfqi046izmeVP1GgbrN2F5Gi+NsLDawgEO9dzQdMxvplXH9U8g8F6L
	 gbMLY1ENqrxHH/SxNoz7YwE1QfoaePN7K3buZWoc+zUJOHmyRy5aqh8GTj0Ktg+n1F
	 +lDsaW6aLcUyuHddFYouaXJyYOk+fjpi5lA1PFbj705AjUxWIel0m1ucHaUxkj84Xv
	 b7tO3cn5QvBIA==
Date: Tue, 13 Feb 2024 13:56:28 +0000
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
Message-ID: <20240213135627.GD28926@willie-the-truck>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
 <20240213133045.GA989297@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213133045.GA989297@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 13, 2024 at 09:30:45AM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2024 at 12:54:56PM +0000, Will Deacon wrote:
> > > Adding a check is not a comprehensive solution, there are still ways
> > > userspace can attack this code with iommufd's coming PASID support. It
> > > certainly doesn't belong in this patch which should be backported.
> > 
> > Ok, then how about avoiding the allocation entirely once the lock is
> > held?
> 
> We need to allocate because we can't assume anything already made the
> CD leaf present. Do you mean to do this additionally to this patch?

Yes, that's why I said "you'd call arm_smmu_init_cd_table() from
arm_smmu_sva_set_dev_pasid()" in the part of my reply that you trimmed.
The diff is just trying to explain an alternative approach, rather than
meant as a wholesale replacment to your patch. Crucially, it does _not_
allocate with the spinlock held.

I can write it as a full patch if you prefer (and I'll need your help to
test it), but I was really hoping to continue the discussion so you could
spin a v2.

> > > I can summarize some of these details in a comment for this patch.
> >
> > Alternatively, we can just revert the offending commits if we're not able
> > to agree on a simple fix for now. I'd prefer to avoid that though.
> 
> I feel we are not aligned here. We are trying to get the driver to
> work properly with iommufd and expose all the HW features. This has
> been fixed comprehensively and well-reviewed patches have been on the
> list for 7 months now. We want to move forward, not revert things.

I appreciate the effort you're putting in, but this specific patch is
fixing a regression so let's stabilise the base before we continue to
build on top of it.

Will
