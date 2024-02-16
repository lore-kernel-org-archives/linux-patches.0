Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB0254BD3;
	Fri, 16 Feb 2024 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105169; cv=none; b=IRbXVjCh9tqIzfookai6KChqcIwDoRKJG9x1I53pkBTWaX07+IzHU484jW8kIB/mZVso7ALA+MGqM9k64YHz9t54D6hDwZOesJGmeCgRAZUbgwYdB67wNNX/8feop7UWtAPU9I7vBIhDX9KGmK0fiWhl27tNYLN/Yzp7zvBtHCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105169; c=relaxed/simple;
	bh=DPU9Zwjkal+aJ4ptcimn6xl5HN5vYQ2C0O40BvPvhOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKZ7cdlhZ+arwCnvOvTGOOHx12/X6pgCAUXGb6nFEz4tSAxmm94SeuWBCW9NBJPtXX8eRs1xxkbpEz7wIYXoYNXyTl4LHs/yAjQGZ7I59KMjcRyij2AGOaDg8A3ldL6fV3GM6suToz425hSzSZnwSrtKRMdnAPkrFkotNtaNy9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIwVwUg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIwVwUg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D504AC433C7;
	Fri, 16 Feb 2024 17:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708105168;
	bh=DPU9Zwjkal+aJ4ptcimn6xl5HN5vYQ2C0O40BvPvhOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HIwVwUg69ftxaNTlulKpFZtJ4noBJEZK2MccrZ4OExg1mWYOWQDMioMNz2Pok+HMq
	 cu4JIa5XH17dKCbrkgLB3aDQeC5+8Ur1lFZzkFeRoPWTLTqAdRLPnFpwnOyCMdGl7c
	 QKlONVgU3uoU+ncJfRan/9Vwdwpr/lzGFW9bwSirxws6q3dFBVxnvBZLiFR7rSsga3
	 RQrfRVAGVZHDbK9f2bBtHy140hWPHp59dZ+vV8yyDnnKO10GpeNWyzgN7FKgwB8fmF
	 g/jRBpNz8oqB2EchxMqnSO86WPzzaAprcXWu8KxCJvqBUbTUYPjqXoSPxFqkNySuB/
	 /L41UnULh2psQ==
Date: Fri, 16 Feb 2024 17:39:22 +0000
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
Subject: Re: [PATCH v5 04/17] iommu/arm-smmu-v3: Move the STE generation for
 S1 and S2 domains into functions
Message-ID: <20240216173921.GA2374@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240216171217.GA102281@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216171217.GA102281@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 16, 2024 at 01:12:17PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 06, 2024 at 11:12:41AM -0400, Jason Gunthorpe wrote:
> > +static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> > +					struct arm_smmu_master *master,
> > +					struct arm_smmu_domain *smmu_domain)
> > +{
> > +	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
> > +
> > +	memset(target, 0, sizeof(*target));
> > +	target->data[0] = cpu_to_le64(
> > +		STRTAB_STE_0_V |
> > +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
> > +
> > +	target->data[1] = cpu_to_le64(
> > +		FIELD_PREP(STRTAB_STE_1_EATS,
> > +			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
> > +		FIELD_PREP(STRTAB_STE_1_SHCFG,
> > +			   STRTAB_STE_1_SHCFG_NON_SHARABLE));
> 
> Just so we are on the same page.. The above NON_SHARABLE is a mistake
> here since v1.
> 
> It is hard to follow arm_smmu_write_strtab_ent() so we all missed that
> the S2 ends up re-using the qword[1] that was installed by the
> bypass/abort STE that has to be in place prior to installing the S2.

Ah! I thought you were inheriting the existing behaviour, but yeah, it's
a straight-up bug which I think just makes life a little more difficult
than it needs to be. If we can keep SHCFG as "use incoming" in all
configurations, then I do think we can move to a per-qword rather than a
per-field approach, as mentioned in the other part of the thread. I'll
try to make some time next week to play with it.

Will
