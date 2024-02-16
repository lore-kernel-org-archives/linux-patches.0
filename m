Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFEF77F0B;
	Fri, 16 Feb 2024 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708085118; cv=none; b=HD/nL8N2Lx7jxnSkH8o5vwwmMhJpVDEIETZx+HMQvPlIJTTTuvaFM8bWlol2pXqg9KG1AS67ZKCqBmiMwOlt5/CEm9t2W71TNxTU11zjmPrIRjWgrufxQ+h0xDIRerlxCyYDK7hZyylkRqr8ZOnIOFi2hiu8fUDBZD5gIsIo/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708085118; c=relaxed/simple;
	bh=vL+vbsgg8KG4BovEieOdK28c94kfdv3eTijdDi7zRok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVRoqwsHL6X0woOm7ALJzajVeuG3qLlPN3hNNfvs2W4KMaP+YrFNxbb3XSt35hovN9cCo0oGzVD/h7eQBC5RddZtTS4rNCajf4zfIo5aFxhQ4zE4OaUNwBYTV0OpqAzV0bIQJKgctJDEa70hLPO/uVAjAKZ0cQIT6hS2UR9HYCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6BjzzkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6BjzzkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A1BC43390;
	Fri, 16 Feb 2024 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708085118;
	bh=vL+vbsgg8KG4BovEieOdK28c94kfdv3eTijdDi7zRok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I6BjzzkSKHxvcdWqcbhND47HDiTU2fwjccLM/3fApUpzOqZOcARDo1JfFMPhflmnB
	 ETEF2QCsq8G1gTlGgSJQgKWAfzSkcC/v4Ahg87aFuqOdKfmaXmv2zVTIVd9Wl7YY8T
	 7Md2wi+Jc+eQIJbUSoDu6K4tu1t8G2sfuIc06QMZn9HtsOb2LPYIXDPKyQbisNPqcd
	 L3WQJISPK6/1mGNd8b6FMHATRJBJQsWxipG4wCCINH5SHknqUHMB4EQGyGlV9Ix/u1
	 eiEBGDQRzDcnB4XXfTyIBtPpvw4b9BN7QrAH6HLsCwjQLxqOx5aF7cPWsTpya3tWYF
	 12feHrdbkvUiA==
Date: Fri, 16 Feb 2024 12:05:12 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240216120512.GA1841@willie-the-truck>
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 15, 2024 at 10:56:57AM -0400, Jason Gunthorpe wrote:
> If the SMMU is configured to use a two level CD table then
> arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> iterate over the device list - thus it will trigger a sleeping while
> atomic warning:
> 
>   arm_smmu_sva_set_dev_pasid()
>     mutex_lock(&sva_lock);
>     __arm_smmu_sva_bind()
>      arm_smmu_mmu_notifier_get()
>       spin_lock_irqsave()
>       arm_smmu_write_ctx_desc()
> 	arm_smmu_get_cd_ptr()
>          arm_smmu_alloc_cd_leaf_table()
> 	  dmam_alloc_coherent(GFP_KERNEL)
> 
> This is a 64K high order allocation and really should not be done
> atomically.
> 
> At the moment the rework of the SVA to follow the new API is half
> finished. Recently the CD table memory was moved from the domain to the
> master, however we have the confusing situation where the SVA code is
> wrongly using the RID domains device's list to track which CD tables the
> SVA is installed in.
> 
> Remove the logic to replicate the CD across all the domain's masters
> during attach. We know which master and which CD table the PASID should be
> installed in.
> 
> At the moment SVA is only invoked when dma-iommu.c is in control of the
> RID translation, which means we have a single iommu_domain shared across
> the entire group and that iommu_domain is not shared outside the group.
> 
> For PCI cases the core code also insists on singleton groups so there is
> only ever one entry in the smmu_domain->domains list that is equal to the
> master being passed in to arm_smmu_sva_set_dev_pasid().
> 
> Only non-PCI cases may have multi-device groups. However, the core code it
> self will replicate the calls to arm_smmu_sva_set_dev_pasid() across the
> entire group so we will still correctly install the CD into each group
> members master.

Are you sure about this paragraph? arm_smmu_mmu_notifier_get() will return
early if it finds an existing notifier in the 'mmu_notifiers' list for the
domain, so I don't think we'll actually get as far as installing the CD,
will we?

Will
