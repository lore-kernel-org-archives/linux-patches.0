Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F8386C01;
	Thu, 12 Mar 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773335490; cv=none; b=Z4K8et2DI57IrjR6VRsRsFQdqkalUn25kqxbGTB8NuoJ195LfBv9tBmOGQxmSVDnv7/VpYS8xRj3ymaPKcDY0StoaT9RgRrfYUjJCj+ola6A8Zjvq5xekwGcpMWLHKgGjEgywpwsye9uje3Bx0+v0EmkNef/96MuqVCC9nr5AGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773335490; c=relaxed/simple;
	bh=R19cNSvvuXB++GaxtAyG234DNoeZyrWhzsKTxzSM4uA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMad4+qmz1BT/w4metxtiWco33AGw5g7IWCJ1Hd+5u/ekc9P/H9TQyzILzBKQBkVK2b5K48GZMu32yfk9pVzsOMSihYJPne7tebeK9RlrDJxF9Oe2PArV5eHdz/bdW10Lc4t6zblqvI+uJib3aUC27NFlkGqD3jFN88VvEQTiRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWvKD2vbxzHnGhc;
	Fri, 13 Mar 2026 01:11:12 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C9D340584;
	Fri, 13 Mar 2026 01:11:22 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 12 Mar
 2026 17:11:21 +0000
Date: Thu, 12 Mar 2026 17:11:20 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>,
	<joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v3 08/10] iommu/arm-smmu-v3: Allocate
 INV_TYPE_S2_VMID_VSMMU in arm_vsmmu_init
Message-ID: <20260312171120.00002356@huawei.com>
In-Reply-To: <71438f280adcf17dc76d56810e336445fb4bf85d.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
	<71438f280adcf17dc76d56810e336445fb4bf85d.1771877893.git.nicolinc@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 23 Feb 2026 12:27:44 -0800
Nicolin Chen <nicolinc@nvidia.com> wrote:

> VMID owned by a vSMMU should be allocated in the viommu_init callback for
>  - a straightforward lifecycle for a VMID used by a vSMMU
>  - HW like tegra241-cmdqv needs to setup VINTF with the VMID
> 
> Allocate/free a VMID in arm_vsmmu_init/destroy(). This decouples the VMID
> owned by vSMMU from the VMID living in the S2 parent domain (s2_cfg.vmid).
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Hi Nicolin,

Not a proper review as I'd need to do a bunch of catch up on how
this stuff all works. So just one query inline.

> ---

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index a77c60321203c..dc638c38515e4 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -406,7 +406,20 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
>  	return ret;
>  }
>  
> +void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
> +{
> +	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> +
> +	guard(mutex)(&arm_smmu_asid_lock);
> +	/*
> +	 * arm_smmu_iotlb_tag_free() must have flushed the IOTLB with the VMID,
> +	 * but it did not free the VMID to align its lifecycle with the vSMMU.
> +	 */
> +	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);

I'm being slow today, but why do you need the lock?
The ida itself doesn't need it according to the docs.
(it's using the xarray lock underneath)

Likewise of the ida_alloc_range()


> +}
> +
>  static const struct iommufd_viommu_ops arm_vsmmu_ops = {
> +	.destroy = arm_vsmmu_destroy,
>  	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
>  	.cache_invalidate = arm_vsmmu_cache_invalidate,
>  };
> @@ -456,14 +469,21 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
>  	struct arm_smmu_device *smmu =
>  		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
>  	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
> +	int id;
>  
>  	if (s2_parent->smmu != smmu)
>  		return -EINVAL;
>  
> +	mutex_lock(&arm_smmu_asid_lock);
> +	id = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
> +			     GFP_KERNEL);
> +	mutex_unlock(&arm_smmu_asid_lock);


