Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D77135A71;
	Tue, 27 Feb 2024 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709037806; cv=none; b=tuFK4o2u4Bc6bQdekDCN6sRdQtaljNno+RjVaiQGJBTt+fXaiq3gSr3v/rml1DiQu+5firHNPeQQUGlQ8WWZwgaV07zRB/FHSfAOuez6F+WYjQUVYq5EGiiONthia4Uztyssz9V0WEFtb3kOZGal/TioWz3erUt7vf89qNcBB0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709037806; c=relaxed/simple;
	bh=Gdt77ksnx11y5DS0VA+3N+NAJ38/cUuc0MumnJGbAs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYU5Cp/9bOZLk5CY1IrVGmTvZvah/lcSzsSpCX7Xg/c33XiJ6701fxfFcOfsyka+j5ieUvH9rKHyhvw8J1gSW3SQ/6acxXPvoqVwLF2gPGUUeJZLoBNoHwBWLNiBjFtEGbbMYKZwN6D8bcrUAAbfpbF3LduAzv3auT+uq05/NB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIhDQNRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIhDQNRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B72EC433F1;
	Tue, 27 Feb 2024 12:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709037805;
	bh=Gdt77ksnx11y5DS0VA+3N+NAJ38/cUuc0MumnJGbAs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CIhDQNRyhsuk12fqmDhRrBXuSjcniVMPQPDRa6jNCYpJ/iGkiW+Esxopeq0PjOh+T
	 H46XCwmJUMFYcNhvxqxN9ImZOcxqq/oKlYqSnWmI11XDPOC7zadLmtGKko7KIthAsl
	 y3d9wZnQJu5BnHPGucjL6e6Xz2m/X/9YYi7zmBhigkI5Nhk6KuysEobc0IAfirczce
	 XR7P5GMomohVwtJaCg0px+ccRlI8lLDp7d3gpcZWFv9WOxPOMgRscee3TailKEt7Aq
	 1jHIklenbdRc1cWt8rz/4k2ZOWg/OvuGTbG4TNYDE+9z76Jh7/aLIXadu1XwYIUKDb
	 u++P2Rsp58R2A==
Date: Tue, 27 Feb 2024 12:43:18 +0000
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
Message-ID: <20240227124318.GA14089@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
 <20240222174346.GB9488@willie-the-truck>
 <20240223151841.GH13330@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223151841.GH13330@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 23, 2024 at 11:18:41AM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 22, 2024 at 05:43:46PM +0000, Will Deacon wrote:
> > On Wed, Feb 21, 2024 at 10:08:18AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
> > > 
> > > > Very roughly, yes, although I'd go further and just return a bitmap of
> > > > used qwords instead of tracking these bits. Basically, we could have some
> > > > #defines saying which qwords are used by which configs, 
> > > 
> > > I don't think this will work well for CD's EPD0 case..
> > > 
> > > static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > > {
> > > 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > > 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > > 		return;
> > > 	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > > 
> > > 	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> > > 	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> > > 		used_bits[0] &= ~cpu_to_le64(
> > > 			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> > > 			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> > > 			CTXDESC_CD_0_TCR_SH0);
> > > 		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> > > 	}
> > > }
> > 
> > Please can you explain more about the issue here? I know what EPDx are,
> > but I'm not understanding why they're problematic. This presumably
> > involves a hitless transition to/from an aborting CD?
> 
> When a process using SVA exits uncleanly the MM is released so the
> SMMU HW must stop chasing the page table pointers since all that
> memory will be freed.
> 
> However, in an unclean exit we can't control the order of shutdown so
> something like uacce or RDMA may not have quieted the DMA device yet.
> 
> So there is a period during shutdown where the mm has been released
> and the device is doing DMA, the desire is that the DMA continue to be
> handled as a PRI and the SW will return failure for all PRI requests.
> 
> Specifically we do not want to trigger any dmesg log events during
> this condition.

Curious, but why is it problematic to log events? As you say, it's an
"unclean" exit, so it doesn't seem that unreasonable to me.

> Jean-Philippe came up with this solution where we hitlessly use EPD0
> in release to allow the mm to release the page table while continuing
> to use the PRI flow.
>
> So it is going from a "SVA domain with a page table" to a "SVA domain
> without a page table but EPD0 set", hitlessly.

Ok, and so the reason this adds complexity is because the set of used
bits/qwords changes based on something other than the cfg? I think it's
a pretty weak argument for field vs qwords, but it's a good
counter-example to my naive approach of per-config masks, so thanks.

> BTW Michael's self test won't be in part 1 because it needs the ops to
> be restored in order to work (now done in part 2), and has a few other
> more minor dependencies on part 2 and 3.

That's a pity, but fair enough.

Will
