Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9A1CB152;
	Fri,  6 Sep 2024 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725628988; cv=none; b=E/ZBK84bL0oN6z4vQdF2LE1twhTw3EiCP19DfpajBBZmUfp4ah0gcpZu79Ow/GiIzmVW+keLfwnZN7B2NH0U2z7Uvs/IXm1IIJEhfT3hOMYznyNLOWBsQYtWMTh41wmVm7tBkw8Hav/sz0HevZM2bOLakeDRspsW/uc8OXys6dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725628988; c=relaxed/simple;
	bh=0ICkGPaSJ8PKUUlViOl/vnbbRoOfGiaWaGjBsh6isSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTLloBG3GigZ1rpyRMI0ZPnpLZ7g11FP+d3r+ipkeKif9XLrLwUWWUOQkj4Uo8x2UvBkLsyuMHMjgxr3NGz/4IuMdM4d6ssAmFPs/jNyyrMkuNM7Hb1CWHmUzNHx2LkV2KKxHBM4A25MVdiYDJatrSMLzcEfE421Z0qQrAPQuE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/Lmn7W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/Lmn7W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E2CC4CEC4;
	Fri,  6 Sep 2024 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725628988;
	bh=0ICkGPaSJ8PKUUlViOl/vnbbRoOfGiaWaGjBsh6isSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/Lmn7W1M/zjObjKVUZe9h4XUZrbt12c11W8Tsu7cnogfSwGTY6IF9ItlWEORdE2N
	 YTo97hoRgkfHTQXm9yH2PUwQ20FgaEkY2gaOYDDHrC1whRb2ZzOLpcQwX4vuoph8iI
	 Utdg/Qc/REDNsoqcD8Yotey2KmevgRTUgUPvT1w/5+c0+iQbohjrR0Hl63d4Gk2dGK
	 UYwiEDDBC/iWZr5C92NjsuCqtV2YSCsWffcO/XPWPh6EvTtI8Km6DgeHTLzMeBa7la
	 mYPJTMTybNeLc8Nr0H0Zg+rgIUvvreeNLfpkPVzv7ZY9iHbFLoKjabjc/sPxjTIQnu
	 BK1+5gGrNEp1Q==
Date: Fri, 6 Sep 2024 14:23:02 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 1/9] iommu/arm-smmu-v3: Use the new rb tree helpers
Message-ID: <20240906132302.GE16959@willie-the-truck>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <1-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2024 at 08:31:15PM -0300, Jason Gunthorpe wrote:
> Since v5.12 the rbtree has gained some simplifying helpers aimed at making
> rb tree users write less convoluted boiler plate code. Instead the caller
> provides a single comparison function and the helpers generate the prior
> open-coded stuff.
> 
> Update smmu->streams to use rb_find_add() and rb_find().
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 68 ++++++++++-----------
>  1 file changed, 31 insertions(+), 37 deletions(-)

Thanks, this is a lot better! I'll pick this one up.

Will
