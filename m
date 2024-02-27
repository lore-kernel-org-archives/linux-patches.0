Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FC2138480;
	Tue, 27 Feb 2024 10:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709031014; cv=none; b=WmAA8j2T4G8xX9EpWQ4yMpiKYB89LZKb8puOXbVkxAkhYXfMyxLTiHKwAy0aHJwZj3gUtdYgtf3Lyi66i0R8TvVuEsbDVztSjlVU4ZWvgMtkk5vOzJiIk+Z9jCjib5/Ru6Oak80jXlq7F7wkyamEHObA9NNl9xlyHHlP+27URtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709031014; c=relaxed/simple;
	bh=h/XPnR9/Of74e57QRgQwK4utsjer1UJrLhZg11kJf9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhniqNj0pU1PVjcrKwCaPrxNCJNIxFX6BNYl4RbYyaY7QRjxwTH4BMct3cofe5fs/9xLHo3RgsGxYR9FwhLZTbim2m7VwNvjgbVOdWmItS8txipAT6wEDy8fJKBZ0KsWuqYTLqB6Mi0naIquFMGS3NtIBBFKy2MzugT8V2cwr1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArRbrzzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArRbrzzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE34C433C7;
	Tue, 27 Feb 2024 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709031014;
	bh=h/XPnR9/Of74e57QRgQwK4utsjer1UJrLhZg11kJf9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ArRbrzzkRv2DPl31GDKc2bQzlz9XV2Kd3q/cN28EQDl0wb7IzkqVYnFqoZoTOH0R9
	 6cTKAjWYxCnZw6gvXOHoOeHhbCq/ZYghidbOW06ryrO8KV4f/Yi4vJskd20OFf0utH
	 GqzyNgqXtvcYh7sqsveTNby6WAa6VLT1nMxjkdvbid7p1xBBqQY7AizQQW8Zl1TER/
	 Qd01DP7+og2GkcmzD5HDreBYLD1DmCFGq8cdaS6N0o2/4HAzh2BiU+riEg311Rvr3h
	 v0wNZ5UEzsDSwIG7K34Jsamx5tli3V72And1hL/IuskBJ1hsUkB7ooDt8O1Ks7F+7e
	 mk/3N614ouRxw==
Date: Tue, 27 Feb 2024 10:50:08 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 02/17] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <20240227105007.GA13859@willie-the-truck>
References: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
 <20240223185358.GA791502@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223185358.GA791502@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 23, 2024 at 02:53:58PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 15, 2024 at 05:27:09PM +0000, Robin Murphy wrote:
> > > @@ -1583,22 +1595,20 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
> > >   	arm_smmu_write_ste(master, sid, dst, &target);
> > >   }
> > > +/*
> > > + * This can safely directly manipulate the STE memory without a sync sequence
> > > + * because the STE table has not been installed in the SMMU yet.
> > > + */
> > >   static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> > 
> > This name is long out-of-date - if we're refreshing this area, please rename
> > to something relevant to what it actually does, e.g. s/bypass/initial/.
> 
> Done
> 
> > Although frankly I also think that at this point we should just get rid of
> > the disable_bypass parameter altogether - it's been almost entirely
> > meaningless since default domain support was added, and any tenuous cases
> > for wanting inital STEs to be bypass should probably be using RMRs now
> > anyway.
> 
> I can write the patch for this if you and Will agree

Yes, please! I'll be glad to see the back of that option. Since you just
posted v6 of your "part 1", feel free to send a patch which applies on top
of that (rather than having to rebase the whole shebang).

Will
