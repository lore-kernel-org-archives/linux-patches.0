Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B44F16DEB5;
	Fri, 10 May 2024 11:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715339116; cv=none; b=P8vDOhU2diIqhGz//WSTopj78kJ4CVXLQ2MbHRXyqRjMj1E59LerNyuVWeBiaPXxMrP+eUYkegyG8Qh7FkMVI4K7Rr0MNNFmkdmRuje0s3Gz64Guzlsxl3BqEyquGuCHEwGJnn05XcB2xu048V+Q457FHW00mBwwWa3tnwfCWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715339116; c=relaxed/simple;
	bh=4lTKnRjo2e38dgUhatGnS7hfWdH5Ih8roNpbCZlt87Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gr6SarZTzWlzGxE0aLHMQZs9QHxZbH7fGjLxTw4sJJWcXPWe3iNoVgPVeJBxZkMEvSj7BGw5HL5DqXdUXoc3euMITI6DyGuRgCLycqXcHHOJRMm9Qubj53tGTPqpldI7yEiLTWDlS2cr0MVS9I802Crh6moRV5vGffCyDq3ixUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3CFpesb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3CFpesb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19228C32781;
	Fri, 10 May 2024 11:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715339115;
	bh=4lTKnRjo2e38dgUhatGnS7hfWdH5Ih8roNpbCZlt87Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T3CFpesbX8JM3T/qMFBkavuwXrLJ1YZr5pDnBfVw3dKYDBuk78rCREZaXvxCipIBa
	 3WRTguZg7N+MFFGr7rDwqH4xY+mRsLbzSSm0Dtcs8wPMzCZFrTgEGtYXOD432wotxi
	 xvdiECwKbMUC+R4Wd3mXEt5q8FaFJVISKATp2sUCQbLh08f5oCG7FeZf3fhueS6bK+
	 DoD3wohWnQgr3TU5Sf3LXo6+tm8HvLg1M+kTB2BsGBs+iCMFIwoMwyGYmvyg/IHg5O
	 61KO+0bhZqymHrYg0JenZ3lLmsu7x7fF1k6X6cDn82P0gDJW/4d5++/0BdeWJivr9l
	 JaJuXXcAVPojQ==
Date: Fri, 10 May 2024 12:05:10 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240510110510.GA25675@willie-the-truck>
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

The one-liner Kconfig change didn't surface, so:

Acked-by: Will Deacon <will@kernel.org>

Will
