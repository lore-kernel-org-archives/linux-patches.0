Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56439DDB1;
	Wed,  8 May 2024 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715187219; cv=none; b=O02PSdi21XvWVLCuAkc4ut2j52otjVUMPLVtWVZJhAfQwBVm+7RMJuHQj5bUV03EIQFWA1biEsSmc98eZ2GjVGQ/ONjtNLUoUtJhJVR3DNWLf2uJCwu7bbVUEWjATElN6MEiLvbnTDguDSps0+TE3DV+WDP+UbGA1vtpftakZlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715187219; c=relaxed/simple;
	bh=/GO4GFZxrGOVPKQ52WpBbrFNKRc+hdxpgQtBpoj6F5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGOF304E4EAI88Xya+PLUO04UK3U2QF3tHttVTZVCbt9H17wZNuqOh382ZMqV2WX9u8tfM0wI759OmIrOePHMN7znjn/HMyD1nFsDcgeCZ+++RQNU/PkXtfY7YNDyqBh9QUZ8pMke5Ux6+ePeyPONI7MWLvO9wptjQ+ffOFnxEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAQ5BrVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAQ5BrVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD76C113CC;
	Wed,  8 May 2024 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715187218;
	bh=/GO4GFZxrGOVPKQ52WpBbrFNKRc+hdxpgQtBpoj6F5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LAQ5BrVXuGJf11Y2Afas5ya/r667FkHG3QLfCqJHrcBoL4NOW84KNO+eRnNcPAcHZ
	 3lgbhaFyyvHEESO/fbLGW7kBGWiR+iWOhzVP945HzDaVHx79Igff4uzufV4e/mCE9h
	 leG0kUffWSI0k/T/aEDBzHvyr0GPbwKccLJcUdTDqZJnOmm0yB+WfKQPpD0zhOS0aj
	 QgmfuKz+dNBupCMGxM/FgoBLhPQxBgjRBRcl55mjb1o9JFBZKt9sroUDiKu7QAMiQK
	 HrIaptWC3uCgkYKZoBcB/xIRJbOFvD+TT6221ESlm+6KSQybn9gz1+Psa0rQ9xScQ4
	 D9GqK1FPEipWg==
Date: Wed, 8 May 2024 17:53:33 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240508165333.GA23294@willie-the-truck>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
 <20240507142248.GA22453@willie-the-truck>
 <20240507143321.GP3341011@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507143321.GP3341011@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 07, 2024 at 11:33:21AM -0300, Jason Gunthorpe wrote:
> On Tue, May 07, 2024 at 03:22:48PM +0100, Will Deacon wrote:
> > On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> > > On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > > > On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> > > > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > > > index 66325210c8c986..c04584be30893f 100644
> > > > > --- a/drivers/iommu/Kconfig
> > > > > +++ b/drivers/iommu/Kconfig
> > > > > @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
> > > > >  	  and PRI.
> > > > >  
> > > > >  config ARM_SMMU_V3_KUNIT_TEST
> > > > > -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > > > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > > >  	depends on KUNIT
> > > > >  	depends on ARM_SMMU_V3_SVA
> > > > >  	default KUNIT_ALL_TESTS
> > > > 
> > > > Would it work to leave this as 'bool' and have something like:
> > > > 
> > > > 	depends on KUNIT=y
> > > 
> > > Yes, there is a version like this (depends on KUNIT = ARM_SMMU_V3),
> > > but it made kconfig act a little weird and hide the symbols.
> > 
> > Which symbols were hidden in which cases? Having ARM_SMMU_V3_KUNIT_TEST
> > disappear from menuconfig when the dependency isn't satisifed sounds
> > fine to me, but you make it sound like it was something else.
> 
> That isn't normal, it should show up as [ ] and be limited to M, not
> be hidden completely.

Sorry, but please can you explain a little more? I'm having to guess at
a lot of the details here. Are you saying that the option disappears
even when ARM_SMMU_V3=m?

> > > > instead? That would be a lot simpler and avoids all the conditional
> > > > symbol exports.
> > > 
> > > But then Fedora is linking this code into their production kernel
> > > which doesn't seem right.
> > 
> > Well, only if they select CONFIG_ARM_SMMU_V3_KUNIT_TEST, right? There
> > also seems to be precedence for that if I grep around:
> 
> Thorsten said they are selecting that..

I find that hard to believe given that the option didn't exist until
about week ago and isn't in any released kernels :/

> > drivers/base/Kconfig:	depends on KUNIT=y
> > drivers/fpga/tests/Kconfig:	depends on FPGA=y && FPGA_REGION=y && FPGA_BRIDGE=y && KUNIT=y && MODULES=n
> > drivers/gpu/drm/xe/Kconfig:	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
> > drivers/mmc/host/Kconfig:	depends on (MMC_SDHCI_OF_ASPEED=m || KUNIT=y)
> > drivers/net/ethernet/microchip/vcap/Kconfig:	depends on KUNIT=y && VCAP=y && y
> > drivers/thunderbolt/Kconfig:	depends on USB4 && KUNIT=y
> > drivers/virt/nitro_enclaves/Kconfig:	depends on NITRO_ENCLAVES && KUNIT=y
> > fs/Kconfig.binfmt:	depends on KUNIT=y && BINFMT_ELF=y
> > lib/Kconfig.debug:	depends on KUNIT=y
> > lib/Kconfig.debug:	depends on KUNIT=y
> > lib/Kconfig.debug:	depends on RUST && KUNIT=y
> > mm/damon/Kconfig:	depends on DAMON && KUNIT=y
> > mm/damon/Kconfig:	depends on DAMON_VADDR && KUNIT=y
> > mm/damon/Kconfig:	depends on DAMON_SYSFS && KUNIT=y
> > mm/damon/Kconfig:	depends on DAMON_DBGFS && KUNIT=y
> > net/mctp/Kconfig:        depends on MCTP=y && KUNIT=y
> > security/landlock/Kconfig:	depends on KUNIT=y
> 
> These cases don't seem to involve a module, eg BINFMT_ELF can't be a
> module.

The DRM_XE one is tristate and has this interesting variant:

	depends on ... && (m || (y && KUNIT=y))

> I see the majority of kunit setups have it put the test into its own
> module.
> 
> What's the issue here? This is the majority way to do kunit, I just
> made a mistake not doing it fully when Mostafa brought it up.

I just think that EXPORT_SYMBOL_IF_KUNIT looks like a pretty horrible
hack and it would be nice to avoid it entirely with a one-liner Kconfig
change, even if that slightly limits the configurations in which the
unit tests are available.

Will
