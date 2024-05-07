Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A844156678;
	Tue,  7 May 2024 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715091774; cv=none; b=Th1wYQSKa6IFPLvFxVkZvFmwWJohrjY7ZxxyHUkhq8VuW4Rd8z0pFwZyIUGonk0Z+6nPna4k6pqyqq/rEi9sN9TUzOAy8vr7Zz1LD7CzRVX5HZ10HAQ3n/6lv8PCtzuVLyL1ahISQmOnIHmvj3Pxi3TOMiPwtwrEEVo2GIo/P1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715091774; c=relaxed/simple;
	bh=iOvTdSSAQ+2FIMaKPkpaKrooakpoATMhxMC/c+34AKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6aVXeaHrA1bdoUcct5QCBjq2KxVoU7cb7Je2P1UlJQNnrbHt19SEvctgqN5dLMoplFYfQKIcGJov/SQh30j460hLR5zXX2V1lrkLlr/BWsL4HSLAWJeXWwGhQaY5ZJLF1MDqquPFfuzNhyX0/GC3ZVAZEf6tPk9ok4bSTKhFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqPItACH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqPItACH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33262C4AF18;
	Tue,  7 May 2024 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715091774;
	bh=iOvTdSSAQ+2FIMaKPkpaKrooakpoATMhxMC/c+34AKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FqPItACH8cMRoCDKYgWj9Dm1f5Q2BuGOOd0Y2c3fctsg4IX34oaZwJXCQQKQRuyCK
	 +RdRixFLC6m1S+1Y7TOloO99pD73NWWHiVephN96ejLeOephfDKB7jamn1eeKMNjX2
	 /z5HlltUWXICxYwKhH/LfB1GnLHpaptJ79JMqrcIEEqv1mlPol3RFFwduj/fqY15yL
	 mGuM3GbbHtKxed818X7wVRHpwwV7e8TUqjHXbRwR9XCxgF8iwt3G9xHYUTzK56kMuZ
	 FNABr3ooLfgdMqf66JUbS5X+qLyxiDJTDU3z9Gap/m8ixdtLrYgu4pQCWaXcxiWDa5
	 QwsxigNgCrlBQ==
Date: Tue, 7 May 2024 15:22:48 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240507142248.GA22453@willie-the-truck>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507140946.GO3341011@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> > > It turns out kconfig has problems ensuring the SMMU module and the KUNIT
> > > module are consistently y/m to allow linking. It will permit KUNIT to be a
> > > module while SMMU is built in.
> > > 
> > > Also, Fedora apparently enables kunit on production kernels.
> > > 
> > > So, put the entire kunit in its own module using the
> > > VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
> > > vmlinus on Fedora and makes the kconfig work in the normal way. There is
> > > no cost if kunit is disabled.
> > > 
> > > Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
> > > Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> > > Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/Kconfig                            | 2 +-
> > >  drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
> > >  5 files changed, 15 insertions(+), 2 deletions(-)
> > > 
> > > Joerg, can you pick this to solve the linux-next issue for Thorsten?
> > > 
> > > Thanks,
> > > Jason
> > > 
> > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > index 66325210c8c986..c04584be30893f 100644
> > > --- a/drivers/iommu/Kconfig
> > > +++ b/drivers/iommu/Kconfig
> > > @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
> > >  	  and PRI.
> > >  
> > >  config ARM_SMMU_V3_KUNIT_TEST
> > > -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > >  	depends on KUNIT
> > >  	depends on ARM_SMMU_V3_SVA
> > >  	default KUNIT_ALL_TESTS
> > 
> > Would it work to leave this as 'bool' and have something like:
> > 
> > 	depends on KUNIT=y
> 
> Yes, there is a version like this (depends on KUNIT = ARM_SMMU_V3),
> but it made kconfig act a little weird and hide the symbols.

Which symbols were hidden in which cases? Having ARM_SMMU_V3_KUNIT_TEST
disappear from menuconfig when the dependency isn't satisifed sounds
fine to me, but you make it sound like it was something else.

> > instead? That would be a lot simpler and avoids all the conditional
> > symbol exports.
> 
> But then Fedora is linking this code into their production kernel
> which doesn't seem right.

Well, only if they select CONFIG_ARM_SMMU_V3_KUNIT_TEST, right? There
also seems to be precedence for that if I grep around:

drivers/base/Kconfig:	depends on KUNIT=y
drivers/fpga/tests/Kconfig:	depends on FPGA=y && FPGA_REGION=y && FPGA_BRIDGE=y && KUNIT=y && MODULES=n
drivers/gpu/drm/xe/Kconfig:	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
drivers/mmc/host/Kconfig:	depends on (MMC_SDHCI_OF_ASPEED=m || KUNIT=y)
drivers/net/ethernet/microchip/vcap/Kconfig:	depends on KUNIT=y && VCAP=y && y
drivers/thunderbolt/Kconfig:	depends on USB4 && KUNIT=y
drivers/virt/nitro_enclaves/Kconfig:	depends on NITRO_ENCLAVES && KUNIT=y
fs/Kconfig.binfmt:	depends on KUNIT=y && BINFMT_ELF=y
lib/Kconfig.debug:	depends on KUNIT=y
lib/Kconfig.debug:	depends on KUNIT=y
lib/Kconfig.debug:	depends on RUST && KUNIT=y
mm/damon/Kconfig:	depends on DAMON && KUNIT=y
mm/damon/Kconfig:	depends on DAMON_VADDR && KUNIT=y
mm/damon/Kconfig:	depends on DAMON_SYSFS && KUNIT=y
mm/damon/Kconfig:	depends on DAMON_DBGFS && KUNIT=y
net/mctp/Kconfig:        depends on MCTP=y && KUNIT=y
security/landlock/Kconfig:	depends on KUNIT=y

Will
