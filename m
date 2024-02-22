Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B228154BE3;
	Thu, 22 Feb 2024 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708623833; cv=none; b=YNLrfqS1Fj1T0Nasd9DAUNhowe2X+mFkGfgz2yNPiOwWfu9ozleUIbK/NzRhuyDq3dfyUrLhJSzXcV2gkR3WVKA25aRZ3aRL3zHKhWJeXNmTd8Oiyo/Db9/tZkrTFCj/K1VeDKN7B74HoEw7DRy/DY/AtrfY+GKaerIcF+7AH40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708623833; c=relaxed/simple;
	bh=D/1aTN13/bWJOpLGxdCcIkLv73lS6q2iymhT+29Sb6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XByVJvjQvBIT+njQxmCa8h9H5TzC8dMlMfyI9QIdvE8J923bx6n2SPaOxpmENP67UrpZlTEdNydJuWb17BqP3KssQqtsOs5/k9NPSNp8QPYhnwVuX9DHI44wdQbLnf0rEQ9KY13/BAvP0PhXnNTdapcwPz6n9bsVD7y74Jy2/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CgKAcGmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgKAcGmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F03C433F1;
	Thu, 22 Feb 2024 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708623832;
	bh=D/1aTN13/bWJOpLGxdCcIkLv73lS6q2iymhT+29Sb6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgKAcGmE6DsOWj8/oa8UJBCBIQM0ZOWjvmXyhWXOP8OCPDdEbVbHTvCyLmSaMWSw7
	 F6c7skVMWaZXiqrVdvOzBI4FnXHPoBLplK4WHINw9wdTRnmTX6KkQFW6hTSXQgzDwa
	 92uwgjPY99BS7ckGsXzgyhirbWDq25jr+UJ3xm4gA6D97LuMaSanaYdNoVENHWKLGm
	 sPjTz2W3wKc95/XIl8d/4SmFoOsHm6bmKCzM5jg74qzXWPd0hUqKpBJ4KX+LEilLL3
	 N4jmTDF/4EzTAAC1RixL6RVQ/WkGfJ6UdJl6RtIbwUUwLKVXpOeD2mr4IgJmosXF+z
	 UvEbtOcFqgh5A==
Date: Thu, 22 Feb 2024 17:43:46 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240222174346.GB9488@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221140818.GA2635804@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 21, 2024 at 10:08:18AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
> 
> > Very roughly, yes, although I'd go further and just return a bitmap of
> > used qwords instead of tracking these bits. Basically, we could have some
> > #defines saying which qwords are used by which configs, 
> 
> I don't think this will work well for CD's EPD0 case..
> 
> static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> {
> 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> 		return;
> 	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> 
> 	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> 	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> 		used_bits[0] &= ~cpu_to_le64(
> 			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> 			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> 			CTXDESC_CD_0_TCR_SH0);
> 		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> 	}
> }

Please can you explain more about the issue here? I know what EPDx are,
but I'm not understanding why they're problematic. This presumably
involves a hitless transition to/from an aborting CD?

> > and then we can
> > simplify the algorithm while retaining the ability to reject updates
> > to qwords which we're not expecting.
> 
> It is not much simplification. arm_smmu_entry_qword_diff() gets a bit
> shorter (not that it is complex anyhow) and other stuff gets worse.
> 
> > > We'd have to really start doing really hacky things like remove the
> > > SHCFG as a used field entirely - but I think if you do that you break
> > > the entire logic of the design and also go backwards to having
> > > programming that only works if STEs are constructed in certain ways.
> > 
> > I would actually like to remove SHCFG as a used field. If the encoding
> > was less whacky (i.e. if 0b00 always meant "use incoming"), then it would
> > be easy, but it shouldn't be too hard to work around that.
> 
> But why?
> 
> You throw away the entire logic of the design, go back to subtly
> coupling the two parts, and *for what*? Exactly what are we trying to
> achieve in return? You haven't explained why we are still discussing
> this afer 7 months. It really isn't worthwhile.

I'm just trying to avoid introducing dynamic behaviours to the driver
which aren't actually used, and per-qword tracking feels like an easier
way to maintain the hitless updates for the cases you care about. It's
really not about throwing away the entire logic of the design -- as I
said, I think this is looking pretty good. I'm also absolutely open to
being convinced that per-field makes more sense and per-qword is terrible,
so I'd really like to understand the E0PD case more.

As an aside: is this per-field/per-qword discussion the only thing holding
up a v6? With the rest of the feedback addressed and a version of Michael's
selftest that exercises stage-2 translating domains, I'd like to think
we could get it queued up soon.

Cheers,

Will
