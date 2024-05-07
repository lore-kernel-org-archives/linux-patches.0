Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7004F158D9A;
	Tue,  7 May 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715090303; cv=none; b=r1zOIOOHCMJIP4T41gPOIJ/QVif6aUBvi7NvjjMMJrVP0bapmQkGQRjEQjkDrtVuMm/8f8ggQ7I3Tc9xQq0iznFXw4IfuUhRH7qfWNzuWMm9IfJYGXaYcb7AdOwhS2Hx4hnjNeisGOEmQ2TYFvqDlvS07r2sGZlX2RaAQIwtZ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715090303; c=relaxed/simple;
	bh=uP7qo0g1Cg3coZRrohfbLlTTRiWBkxI4Gjm4cjxTSk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSgCdWaiZqJPiRtDn7NAm6vQKQn+fHrGVsZD42ldJQQMEeFQDTWZ0l8n9HBdJvaQKEqS18cEMbT5E1QL1qv+2FHCLvXOHmmsUx/x96pDc9jd56GDPCgt42V+720LVgTXupsCx/bHPBYIGfNWXakgtYMN0l/IFqTKq6NPS5mV8kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwbVddny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwbVddny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30541C2BBFC;
	Tue,  7 May 2024 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715090303;
	bh=uP7qo0g1Cg3coZRrohfbLlTTRiWBkxI4Gjm4cjxTSk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QwbVddnyzk73tWOgrpKK7gquMxAYtEEZomiS2JVS2SnoIzEJGJspjv50YOI170XxU
	 pkGM5IGf1P1roCs4vXzTXq53rUwzisCQxaeIfjqCi4VeRxmpK9RY9+EoLRBTWNuktk
	 bZMiCQ7gPZEeQS7IqxMSoCOAhrlVfVN+wCOZNDPRvfPXGmwxLtbgmHEDvpOIVEkLWE
	 bhqiHMTjQCbFLE2rZc3iECx6GLrd9SrPxQT61xOwVOFg1DLgI2Lg4lS+gajSBAAuRc
	 BIuafYb8HP2cKKdl2QcJ2zksJsIhRC6vcoEhy+nKMqCYbHatFxx41+pl1i7wep1Zx6
	 QHCrwdaYKwBkA==
Date: Tue, 7 May 2024 14:58:17 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240507135817.GA22408@willie-the-truck>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> It turns out kconfig has problems ensuring the SMMU module and the KUNIT
> module are consistently y/m to allow linking. It will permit KUNIT to be a
> module while SMMU is built in.
> 
> Also, Fedora apparently enables kunit on production kernels.
> 
> So, put the entire kunit in its own module using the
> VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
> vmlinus on Fedora and makes the kconfig work in the normal way. There is
> no cost if kunit is disabled.
> 
> Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/Kconfig                            | 2 +-
>  drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
>  5 files changed, 15 insertions(+), 2 deletions(-)
> 
> Joerg, can you pick this to solve the linux-next issue for Thorsten?
> 
> Thanks,
> Jason
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 66325210c8c986..c04584be30893f 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
>  	  and PRI.
>  
>  config ARM_SMMU_V3_KUNIT_TEST
> -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
>  	depends on KUNIT
>  	depends on ARM_SMMU_V3_SVA
>  	default KUNIT_ALL_TESTS

Would it work to leave this as 'bool' and have something like:

	depends on KUNIT=y

instead? That would be a lot simpler and avoids all the conditional
symbol exports.

Will
