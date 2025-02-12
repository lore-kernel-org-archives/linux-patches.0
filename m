Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E5BB665;
	Wed, 12 Feb 2025 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739321038; cv=none; b=i9JXHT+aDXf5d9+pUhPUussDy+ZQIXQNur556unFtjTrj/lNGk3qNQMxlHJOqmjDGD27OoVVCRRSTjVFFkmcT5UducIFeOhSbGRCgKpV9aAOqqYsGkzJ3+W/1C6T3vOps9aFmb0Maq/f3n4hOLQLc+BCyg+9FrqvCv6GM0gjIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739321038; c=relaxed/simple;
	bh=QzU9ddI/RxkMzmG60R93vS+PJSGE/413INfnWtXmn/w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVbEPWT9HLUHlFtunzOnOcGNudsazWfQxLcacpnVzli8ehnAnrnm0n50/Ry7AlNDvAJzJSer2kXzUiLLPExt1XALHB33rvqtb/BdRdGfQGzInO7VwMCc3dO0B4/A9D2NALDjaJx+RY8zOVdU3U7rgIVkzsZE5qIIquwVxTf7B7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=O1qlXhUy; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="O1qlXhUy"
Received: from DESKTOP-0403QTC. (unknown [20.236.10.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5B1142107AB2;
	Tue, 11 Feb 2025 16:43:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B1142107AB2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739321036;
	bh=sfhNP2zwy3L/x2MoYp9ApQFHl8JFG6RrQ0ndfVcdPOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=O1qlXhUyZJyouU6jqy7z6y0DLjXO1Wo/VC9QO3xOq4xOuJH9DotirO/yIrh94QMBs
	 WOPdtx/E0SD/EjQx1F+D5HY05daHSR7a33xznQUATlmSL35A/q2L919bnmRqCxBL1o
	 oDSEPq0W3teOlDKgrR9JYhk2FguKChOfn0UmSzvI=
Date: Tue, 11 Feb 2025 16:43:55 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 1/5] iommu/virtio: Break out bypass identity support
 into a global static
Message-ID: <20250211164355.5a1c1647@DESKTOP-0403QTC.>
In-Reply-To: <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
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

On Fri,  7 Feb 2025 10:46:01 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> To make way for a domain_alloc_paging conversion add the typical
> global static IDENTITY domain. This supports VMMs that have a
> VIRTIO_IOMMU_F_BYPASS_CONFIG config.
> 
> If the VMM does not have support then the domain_alloc path is still
> used, which creates an IDENTITY domain out of a paging domain.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/virtio-iommu.c | 86
> ++++++++++++++++++++++++++++-------- 1 file changed, 67
> insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/iommu/virtio-iommu.c
> b/drivers/iommu/virtio-iommu.c index b85ce6310ddbda..c71a996760bddb
> 100644 --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -48,6 +48,7 @@ struct viommu_dev {
>  	u64				pgsize_bitmap;
>  	u32				first_domain;
>  	u32				last_domain;
> +	u32				identity_domain_id;
>  	/* Supported MAP flags */
>  	u32				map_flags;
>  	u32				probe_size;
> @@ -70,7 +71,6 @@ struct viommu_domain {
>  	struct rb_root_cached		mappings;
>  
>  	unsigned long			nr_endpoints;
> -	bool				bypass;
>  };
>  
>  struct viommu_endpoint {
> @@ -305,6 +305,22 @@ static int viommu_send_req_sync(struct
> viommu_dev *viommu, void *buf, return ret;
>  }
>  
> +static int viommu_send_attach_req(struct viommu_dev *viommu, struct
> device *dev,
> +				  struct virtio_iommu_req_attach
> *req) +{
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +	int ret;
> +	int i;
nit: coding style inconsistent within this patch. Inverted xmas tree
here.

> +	for (i = 0; i < fwspec->num_ids; i++) {
> +		req->endpoint = cpu_to_le32(fwspec->ids[i]);
> +		ret = viommu_send_req_sync(viommu, req,
> sizeof(*req));
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * viommu_add_mapping - add a mapping to the internal tree
>   *
> @@ -687,12 +703,6 @@ static int viommu_domain_finalise(struct
> viommu_endpoint *vdev, vdomain->viommu		= viommu;
>  
>  	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
> -		if (virtio_has_feature(viommu->vdev,
> -
> VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> -			vdomain->bypass = true;
> -			return 0;
> -		}
> -
>  		ret = viommu_domain_map_identity(vdev, vdomain);
>  		if (ret) {
>  			ida_free(&viommu->domain_ids, vdomain->id);
> @@ -719,10 +729,8 @@ static void viommu_domain_free(struct
> iommu_domain *domain) 
>  static int viommu_attach_dev(struct iommu_domain *domain, struct
> device *dev) {
> -	int i;
>  	int ret = 0;
>  	struct virtio_iommu_req_attach req;
> -	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
>  	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
>  	struct viommu_domain *vdomain = to_viommu_domain(domain);
>  
> @@ -761,16 +769,9 @@ static int viommu_attach_dev(struct iommu_domain
> *domain, struct device *dev) .domain		=
> cpu_to_le32(vdomain->id), };
>  
> -	if (vdomain->bypass)
> -		req.flags |=
> cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS); -
> -	for (i = 0; i < fwspec->num_ids; i++) {
> -		req.endpoint = cpu_to_le32(fwspec->ids[i]);
> -
> -		ret = viommu_send_req_sync(vdomain->viommu, &req,
> sizeof(req));
> -		if (ret)
> -			return ret;
> -	}
> +	ret = viommu_send_attach_req(vdomain->viommu, dev, &req);
> +	if (ret)
> +		return ret;
>  
>  	if (!vdomain->nr_endpoints) {
>  		/*
> @@ -788,6 +789,40 @@ static int viommu_attach_dev(struct iommu_domain
> *domain, struct device *dev) return 0;
>  }
>  
> +static int viommu_attach_identity_domain(struct iommu_domain *domain,
> +					 struct device *dev)
> +{
> +	int ret = 0;
> +	struct virtio_iommu_req_attach req;
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
> +
> +	req = (struct virtio_iommu_req_attach) {
> +		.head.type	= VIRTIO_IOMMU_T_ATTACH,
> +		.domain		=
> cpu_to_le32(vdev->viommu->identity_domain_id),
> +		.flags          =
> cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS),
> +	};
> +
> +	ret = viommu_send_attach_req(vdev->viommu, dev, &req);
> +	if (ret)
> +		return ret;
> +
> +	if (vdev->vdomain) {
> +		vdev->vdomain->nr_endpoints--;
> +		vdomain->nr_endpoints++;
> +		vdev->vdomain = vdomain;
> +	}
> +	return 0;
> +}
> +
> +static struct viommu_domain viommu_identity_domain = {
> +	.domain = { .type = IOMMU_DOMAIN_IDENTITY,
> +		    .ops =
> +			    &(const struct iommu_domain_ops){
> +				    .attach_dev =
> viommu_attach_identity_domain,
> +			    } }
> +};
> +
>  static void viommu_detach_dev(struct viommu_endpoint *vdev)
>  {
>  	int i;
> @@ -1061,6 +1096,7 @@ static bool viommu_capable(struct device *dev,
> enum iommu_cap cap) }
>  
>  static struct iommu_ops viommu_ops = {
> +	.identity_domain	= &viommu_identity_domain.domain,
>  	.capable		= viommu_capable,
>  	.domain_alloc		= viommu_domain_alloc,
>  	.probe_device		= viommu_probe_device,
> @@ -1184,6 +1220,18 @@ static int viommu_probe(struct virtio_device
> *vdev) if (virtio_has_feature(vdev, VIRTIO_IOMMU_F_MMIO))
>  		viommu->map_flags |= VIRTIO_IOMMU_MAP_F_MMIO;
>  
> +	/* Reserve an ID to use as the bypass domain */
> +	if (virtio_has_feature(viommu->vdev,
> VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> +		viommu->identity_domain_id = viommu->first_domain;
> +		viommu->first_domain++;
Could also use ida_alloc() instead of special treatment, it would be
consistent with the paging identity domain ID.

> +	} else {
> +		/*
> +		 * Assume the VMM is sensible and it either supports
> bypass on
> +		 * all instances or no instances.
> +		 */
> +		viommu_ops.identity_domain = NULL;
> +	}
> +
>  	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
>  
>  	virtio_device_ready(vdev);

