Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEF01FF7D7;
	Wed, 12 Feb 2025 20:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739391009; cv=none; b=D8g5zogpVJRitFAR3jyEzNnRtN503stSgIbnZ2YHnrxZr2wipHmYwnW2uG8/aYklh3hsqdKMbN3CD2+qeNKHpfsoM5kVxwYWPBTOw3Sf14XdC5JA7uCkR1Fb54H7pcjGi8+s6BBDtrUjfqmuZNtJGTriKyTJkyqxyf/QwN5RUbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739391009; c=relaxed/simple;
	bh=l5eSBuS2I6fUIdtWwROVq+z2Iausji44DHYc5d9v2jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VaGT8o8apiDywpaRG3oo81FexiV5DS4tMy8VwJJWWVfBVVllSshVAoG/V0vj9kpAQTUjOoIpK5+LsUBbQBA5GucPCQT+uYGK85yg6Q4GU4xZhq4oJQH+R0iYVQaJiROEwGfahFL9sK+MsEAd+LMVwK2JRFOViYV3JWyYRe5cpF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5FBF12FC;
	Wed, 12 Feb 2025 12:10:25 -0800 (PST)
Received: from [10.57.36.235] (unknown [10.57.36.235])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78CB23F5A1;
	Wed, 12 Feb 2025 12:10:03 -0800 (PST)
Message-ID: <756bf70b-f931-4ab4-bfa9-3621d2394987@arm.com>
Date: Wed, 12 Feb 2025 20:10:01 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
To: jacob.pan@linux.microsoft.com, Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, virtualization@lists.linux.dev,
 Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
 patches@lists.linux.dev
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250211164151.723cfce0@DESKTOP-0403QTC.>
 <20250212125007.GP3754072@nvidia.com>
 <20250212105008.3d35ee43@DESKTOP-0403QTC.>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20250212105008.3d35ee43@DESKTOP-0403QTC.>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-12 6:50 pm, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 12 Feb 2025 08:50:07 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:
>>
>>> I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.
>>
>> Huh, I figured it worked on ARM..
>>
>> There is no requirement that an iommu driver implement identity, this
>> is all an optimization. If it doesn't work in alot of cases can we
>> just remove it? It would simplfy a lot..
>>
> Currently, identity domain type can be set via sysfs. To prevent that,
> maybe we need this?
> 
> +static int viommu_def_domain_type(struct device *dev)
> +{
> +  	return IOMMU_DOMAIN_DMA;

Ugh, please no more of that.


Yes, a user can *request* to set an identity domain via sysfs, and if 
the driver does not support identity domains then:

iommu_group_store_type()
     iommu_setup_default_domain()
         iommu_group_alloc_default_domain()
             __iommu_group_alloc_default_domain()
                 __iommu_alloc_identity_domain()

will return failure, and everything will remain fine (well, except on 
apple-dart for now...) Find an s390 system and try it yourself* ;)

Thanks,
Robin.



*quickly, before the patches land and that gains identity support too!

> +}
> +
>   static struct iommu_ops viommu_ops = {
>          .identity_domain        = &viommu_identity_domain.domain,
>          .capable                = viommu_capable,
> @@ -1096,6 +1106,7 @@ static struct iommu_ops viommu_ops = {
>          .device_group           = viommu_device_group,
>          .get_resv_regions       = viommu_get_resv_regions,
>          .of_xlate               = viommu_of_xlate,
> +       .def_domain_type = viommu_def_domain_type,
>          .owner                  = THIS_MODULE,
> 

