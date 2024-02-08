Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD4E762EE;
	Thu,  8 Feb 2024 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397133; cv=none; b=uspuBLJhDyz7nxWIWPzcdeaZJLDldG58Dfa4zWmzD5HdQlkWAvZRX9Bwy42Xgy8yvSpIE0FU8elI0ZUIPkCSJ1BFy0RR6nKLjWAcDOQjc/oFBfPHZKF1qOF4oKSyneLwdQoB85juyMHYCyFa5p7eGcLRnH5GFOW1dC5s/0Q1p/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397133; c=relaxed/simple;
	bh=IwwgKB7tYdekT+iNHzkuQbYapoZnavHlyQ33Pz9V20k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fv2USHl9upaLt8U/j2/og00HjTJ/wnTND48rav+yWT4XI9aOdOgnWL45by7Kxu/rT8qYLGLmd9p3hUPeqTwUuTXL/kqCHhF6B+RY9e8baLzZTqSDHSeOfK7RpO09QA4YNTTY6CEKAvOGwOphu5n3wbOgPRrrLlSkYVNeJEfjMAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pt4MhOcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pt4MhOcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5468C433C7;
	Thu,  8 Feb 2024 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707397132;
	bh=IwwgKB7tYdekT+iNHzkuQbYapoZnavHlyQ33Pz9V20k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pt4MhOcLLH2oROKKPGQ6DB0WgFlFLnt7F2ZqUQTDhzRL0N1wXvRwu4ZxsdQrjcpi+
	 11l70uBXJJRC31xArdqurdhXOvtgPQ7UJaCyW4Hy1rSSkpTDSNncSAfkriu3YLhu76
	 EIYkowIrqVAd4ZQXTyxw1m5oZwCjfK/QGgVyTh5ra/4ZJWZ9k1I0BlRCRpsQdXeOPO
	 /ciqNGM3vDTUV1fkVKCoBGm0LQ0s87CDfioytfUYJCub3b+Gtxp1VzefQGc7AWH2I3
	 T0dGIfpB4e7dR3KyKXvvfKmwE/LatXtu43rxcc5vvBeG2zboAd82JGgNWj6f6l0NYf
	 fbAkrvdgR7egw==
Date: Thu, 8 Feb 2024 12:58:47 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240208125846.GA23290@willie-the-truck>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 02, 2024 at 10:28:05AM -0400, Jason Gunthorpe wrote:
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
> The proper answer is to sequence CD programming in a way that does not
> require the device list or a spinlock. Part two of my lager series does
> this and already solves this bug.
> 
> In the mean time we can solve the functional issue by preallocating the CD
> entry outside any locking. CD leafs are effectively never freed so this
> guarantees the arm_smmu_write_ctx_desc() inside the lock will not take the
> allocation path.
> 
> Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 5 +++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 ++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 05722121f00e70..068d60732e6481 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -588,6 +588,11 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>  {
>  	int ret = 0;
>  	struct mm_struct *mm = domain->mm;
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +
> +	/* Preallocate the required leafs outside locks */
> +	if (!arm_smmu_get_cd_ptr(master, id))
> +		return -ENOMEM;

What guarantees that all the masters in the domain share the same l2 CD
table? The only reason we need the spinlock is to walk over the device
list, so if that's not necessary then we could push this down into
arm_smmu_mmu_notifier_get().

Will
