Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8DD262D33;
	Wed, 12 Feb 2025 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739388159; cv=none; b=o9qs60mzEDAWeQLpRT3Iyla84MKFed7o6UIvQOBFdCJCdWExFraGMurilecFt9+ZnyeAiYpcInP5GxYj8YAopLqVkZzFR1xjGVlrgz7gUBuwIfpfcd7iUz0ujCq0KteW3TjB7ubbZ7m5n9vUfuvvN34HrOgJKGACAveoIohh6ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739388159; c=relaxed/simple;
	bh=Z2GXWLajfC3wrkFzOHapQxWQinMH3NXa7ktcbqzBvTI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRtkiFONX8XQmOBdgO+E4KN3Lf8uIUXus09TkptmaQBb56vxx4FPtT+ZkE/TGf8cUm5+1ZvEvDaglOLcWxb8jg91MamUoZ4meEB83NCRMEXLXm9FAl7QxHu297yU9m1ZnvTwnrvpadXlR1f7KP7OhVbJDeMct2z2WzWyoPlfmUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TF99BrkW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TF99BrkW"
Received: from DESKTOP-0403QTC. (unknown [20.236.10.120])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0B07A203F3C3;
	Wed, 12 Feb 2025 11:22:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B07A203F3C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739388157;
	bh=KQCyiSAgCqDWvrpS9KGoat/0RCvw9JqYBPo2Wxnl7lg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=TF99BrkWYRcqJuZu395dKYPZ7AVUYq/GWaFsgIeCD6wq1wyhasKH2dPGWfp/ed1p2
	 5ROnpRYI3LWwsovHJAoV9pCCprEBo0qmMAZjsEKHMpQUc6dFvaCmZRXUmQXnl7V2vY
	 WZYRQcIRm+3pCYqwfg8CTmbNZPssdMhpP3cfWZLo=
Date: Wed, 12 Feb 2025 11:22:35 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250212112235.714b0a14@DESKTOP-0403QTC.>
In-Reply-To: <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
	<3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
Reply-To: jacob.pan@linux.microsoft.com
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Jason,

On Fri,  7 Feb 2025 10:46:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> virtio has the complication that it sometimes wants to return a paging
> domain for IDENTITY which makes this conversion a little different
> than other drivers.
> 
> Add a viommu_domain_alloc_paging() that combines
> viommu_domain_alloc() and viommu_domain_finalise() to always return a
> fully initialized and finalized paging domain.
> 
Slightly off the topic, still related to paging domain.

virtio spec for page table extension was introduced a while ago[1],
which adds support for guest owned page tables for paging domains.

Do you foresee the implementation can leverage your generic iommu_pt
work? i.e. for building guest IO page tables. It will add a new flavor
(page table based in addition to map/unmap) to
viommu_domain_alloc_paging() i think.

[1]
https://lore.kernel.org/all/20231006160947.2227396-8-jean-philippe@linaro.org/T/


> Use viommu_domain_alloc_identity() to implement the special non-bypass
> IDENTITY flow by calling viommu_domain_alloc_paging() then
> viommu_domain_map_identity().
> 
> Remove support for deferred finalize and the vdomain->mutex.
> 
> Remove core support for domain_alloc() IDENTITY as virtio was the last
> driver using it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommu.c        |   6 --
>  drivers/iommu/virtio-iommu.c | 114
> ++++++++++++++++------------------- 2 files changed, 53
> insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ee33d26dfcd40d..73a05b34de4768 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1599,12 +1599,6 @@ static struct iommu_domain
> *__iommu_alloc_identity_domain(struct device *dev) domain =
> ops->domain_alloc_identity(dev); if (IS_ERR(domain))
>  			return domain;
> -	} else if (ops->domain_alloc) {
> -		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
> -		if (!domain)
> -			return ERR_PTR(-ENOMEM);
> -		if (IS_ERR(domain))
> -			return domain;
>  	} else {
>  		return ERR_PTR(-EOPNOTSUPP);
>  	}
> diff --git a/drivers/iommu/virtio-iommu.c
> b/drivers/iommu/virtio-iommu.c index c71a996760bddb..79b471c03b6ee4
> 100644 --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -63,7 +63,6 @@ struct viommu_mapping {
>  struct viommu_domain {
>  	struct iommu_domain		domain;
>  	struct viommu_dev		*viommu;
> -	struct mutex			mutex; /* protects
> viommu pointer */ unsigned int			id;
>  	u32				map_flags;
>  
> @@ -97,6 +96,8 @@ struct viommu_event {
>  	};
>  };
>  
> +static struct viommu_domain viommu_identity_domain;
> +
>  #define to_viommu_domain(domain)	\
>  	container_of(domain, struct viommu_domain, domain)
>  
> @@ -653,65 +654,45 @@ static void viommu_event_handler(struct
> virtqueue *vq) 
>  /* IOMMU API */
>  
> -static struct iommu_domain *viommu_domain_alloc(unsigned type)
> +static struct iommu_domain *viommu_domain_alloc_paging(struct device
> *dev) {
> -	struct viommu_domain *vdomain;
> -
> -	if (type != IOMMU_DOMAIN_UNMANAGED &&
> -	    type != IOMMU_DOMAIN_DMA &&
> -	    type != IOMMU_DOMAIN_IDENTITY)
> -		return NULL;
> -
> -	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
> -	if (!vdomain)
> -		return NULL;
> -
> -	mutex_init(&vdomain->mutex);
> -	spin_lock_init(&vdomain->mappings_lock);
> -	vdomain->mappings = RB_ROOT_CACHED;
> -
> -	return &vdomain->domain;
> -}
> -
> -static int viommu_domain_finalise(struct viommu_endpoint *vdev,
> -				  struct iommu_domain *domain)
> -{
> -	int ret;
> -	unsigned long viommu_page_size;
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
>  	struct viommu_dev *viommu = vdev->viommu;
> -	struct viommu_domain *vdomain = to_viommu_domain(domain);
> +	unsigned long viommu_page_size;
> +	struct viommu_domain *vdomain;
> +	int ret;
>  
>  	viommu_page_size = 1UL << __ffs(viommu->pgsize_bitmap);
>  	if (viommu_page_size > PAGE_SIZE) {
>  		dev_err(vdev->dev,
>  			"granule 0x%lx larger than system page size
> 0x%lx\n", viommu_page_size, PAGE_SIZE);
> -		return -ENODEV;
> +		return ERR_PTR(-ENODEV);
>  	}
>  
> +	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
> +	if (!vdomain)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&vdomain->mappings_lock);
> +	vdomain->mappings = RB_ROOT_CACHED;
> +
>  	ret = ida_alloc_range(&viommu->domain_ids,
> viommu->first_domain, viommu->last_domain, GFP_KERNEL);
> -	if (ret < 0)
> -		return ret;
> -
> -	vdomain->id		= (unsigned int)ret;
> -
> -	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
> -	domain->geometry	= viommu->geometry;
> -
> -	vdomain->map_flags	= viommu->map_flags;
> -	vdomain->viommu		= viommu;
> -
> -	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
> -		ret = viommu_domain_map_identity(vdev, vdomain);
> -		if (ret) {
> -			ida_free(&viommu->domain_ids, vdomain->id);
> -			vdomain->viommu = NULL;
> -			return ret;
> -		}
> +	if (ret < 0) {
> +		kfree(vdomain);
> +		return ERR_PTR(ret);
>  	}
>  
> -	return 0;
> +	vdomain->id = (unsigned int)ret;
> +
> +	vdomain->domain.pgsize_bitmap = viommu->pgsize_bitmap;
> +	vdomain->domain.geometry = viommu->geometry;
> +
> +	vdomain->map_flags = viommu->map_flags;
> +	vdomain->viommu = viommu;
> +
> +	return &vdomain->domain;
>  }
>  
>  static void viommu_domain_free(struct iommu_domain *domain)
> @@ -727,6 +708,28 @@ static void viommu_domain_free(struct
> iommu_domain *domain) kfree(vdomain);
>  }
>  
> +static struct iommu_domain *viommu_domain_alloc_identity(struct
> device *dev) +{
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	if (virtio_has_feature(vdev->viommu->vdev,
> +			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
> +		return &viommu_identity_domain.domain;
> +
> +	domain = viommu_domain_alloc_paging(dev);
> +	if (IS_ERR(domain))
> +		return domain;
> +
> +	ret = viommu_domain_map_identity(vdev,
> to_viommu_domain(domain));
> +	if (ret) {
> +		viommu_domain_free(domain);
> +		return ERR_PTR(ret);
> +	}
> +	return domain;
> +}
> +
>  static int viommu_attach_dev(struct iommu_domain *domain, struct
> device *dev) {
>  	int ret = 0;
> @@ -734,20 +737,8 @@ static int viommu_attach_dev(struct iommu_domain
> *domain, struct device *dev) struct viommu_endpoint *vdev =
> dev_iommu_priv_get(dev); struct viommu_domain *vdomain =
> to_viommu_domain(domain); 
> -	mutex_lock(&vdomain->mutex);
> -	if (!vdomain->viommu) {
> -		/*
> -		 * Properly initialize the domain now that we know
> which viommu
> -		 * owns it.
> -		 */
> -		ret = viommu_domain_finalise(vdev, domain);
> -	} else if (vdomain->viommu != vdev->viommu) {
> -		ret = -EINVAL;
> -	}
> -	mutex_unlock(&vdomain->mutex);
> -
> -	if (ret)
> -		return ret;
> +	if (vdomain->viommu != vdev->viommu)
> +		return -EINVAL;
>  
>  	/*
>  	 * In the virtio-iommu device, when attaching the endpoint
> to a new @@ -1098,7 +1089,8 @@ static bool viommu_capable(struct
> device *dev, enum iommu_cap cap) static struct iommu_ops viommu_ops =
> { .identity_domain	= &viommu_identity_domain.domain,
>  	.capable		= viommu_capable,
> -	.domain_alloc		= viommu_domain_alloc,
> +	.domain_alloc_identity	= viommu_domain_alloc_identity,
> +	.domain_alloc_paging	= viommu_domain_alloc_paging,
>  	.probe_device		= viommu_probe_device,
>  	.release_device		= viommu_release_device,
>  	.device_group		= viommu_device_group,

