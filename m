Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798F820FA9D;
	Wed, 12 Feb 2025 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368624; cv=none; b=PQSVeXg8WPt1O0E2HubN6xJS45pN7JMkHgfsGvTjt3uJUF+a7Eru+xom+QPpMJZaz1dwdGEayyD6I7hgzpLrg3g+sZNgMo9p1P+OCkAlynumeKwFE2SXzsx9wIGmCI7Zo24AANm9943RU6fRl9ab5RkhltvrVW2eh+v5iGePiqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368624; c=relaxed/simple;
	bh=OB5vXZ1GKOnlg3but9VlSqGKAid8F3wmDoHtAJlX7Kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p15nIl7YgqedSAAg/50GG17+7hfaO6+UdYU0rals65XkEM5XpuMtMjlTZ2EnTa+R2GnxQSMo9kxmhnDwMCfAoqEuF/b6cSY2K1OxOLdn+f4HR/QV1k9+FzFgivUNGQnKkOU4RaI0XKkulb0RScEuOftDbflImwoRHToGGiHbjwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EF3312FC;
	Wed, 12 Feb 2025 05:57:22 -0800 (PST)
Received: from [10.57.36.235] (unknown [10.57.36.235])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 492233F6A8;
	Wed, 12 Feb 2025 05:56:58 -0800 (PST)
Message-ID: <f0164c18-9ded-4c41-a8c5-c225a978973d@arm.com>
Date: Wed, 12 Feb 2025 13:56:55 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] iommu: Add domain_alloc_identity()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, virtualization@lists.linux.dev,
 Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Janne Grunau <j@jannau.net>
References: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-07 2:46 pm, Jason Gunthorpe wrote:
> virtio-iommu has a mode where the IDENTITY domain is actually a paging
> domain with an identity mapping covering some of the system address
> space manually created.
> 
> To support this add a new domain_alloc_identity() op that accepts
> the struct device so that virtio can allocate and fully finalize a
> paging domain to return.

Oh, I'd already managed to forget this idea - this could be convenient 
for DART to implement per-instance identity domain support as well.

Robin.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 20 ++++++++++++--------
>   include/linux/iommu.h |  4 ++++
>   2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 870c3cdbd0f622..ee33d26dfcd40d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1595,15 +1595,19 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
>   	if (ops->identity_domain)
>   		return ops->identity_domain;
>   
> -	/* Older drivers create the identity domain via ops->domain_alloc() */
> -	if (!ops->domain_alloc)
> +	if (ops->domain_alloc_identity) {
> +		domain = ops->domain_alloc_identity(dev);
> +		if (IS_ERR(domain))
> +			return domain;
> +	} else if (ops->domain_alloc) {
> +		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
> +		if (!domain)
> +			return ERR_PTR(-ENOMEM);
> +		if (IS_ERR(domain))
> +			return domain;
> +	} else {
>   		return ERR_PTR(-EOPNOTSUPP);
> -
> -	domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
> -	if (IS_ERR(domain))
> -		return domain;
> -	if (!domain)
> -		return ERR_PTR(-ENOMEM);
> +	}
>   
>   	iommu_domain_init(domain, IOMMU_DOMAIN_IDENTITY, ops);
>   	return domain;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 38c65e92ecd091..6389d59178ba3f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -557,6 +557,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
>    * @domain_alloc: allocate and return an iommu domain if success. Otherwise
>    *                NULL is returned. The domain is not fully initialized until
>    *                the caller iommu_domain_alloc() returns.
> + * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
> + *                         use identity_domain instead. This should only be used
> + *                         if dynamic logic is necessary.
>    * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
>    *                     input parameters as defined in
>    *                     include/uapi/linux/iommufd.h. The @user_data can be
> @@ -615,6 +618,7 @@ struct iommu_ops {
>   
>   	/* Domain allocation and freeing by the iommu driver */
>   	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
> +	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
>   	struct iommu_domain *(*domain_alloc_paging_flags)(
>   		struct device *dev, u32 flags,
>   		const struct iommu_user_data *user_data);

