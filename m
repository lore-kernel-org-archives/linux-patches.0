Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6C531A60;
	Thu, 15 Feb 2024 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708023725; cv=none; b=Dxkgm2MK+p2ncAcsV6pyxs1iQKsszWKs0ECKnt44LHYA9l7787A0xdVAUYY6uW8jStYKuAp3NzYh/uxVE8v8hqShT5Pq/MV6oSvp7lzJwKYaWA546Qko7vmxxH5FqGG3pTPa/1aw7o11D4KNIRUsOcd64eN+dWrfBcxqKgDCg8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708023725; c=relaxed/simple;
	bh=Gq+9otg48EtAqkWkOwmSQ6VY9muDxfSYXKED946yWpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvmcnqKzlXdO7dNy9H/cnxo8lZs09Kut4q7yw3/emdh76Pj8xAoQTZLksSgDtY9MRzeFsci4oh2y6M4FCxWFH1Mx4Yo7J21KyznvV7ns1/YZeYwe53/NxXGcnhnCr5u6UMukNrBn9cS5kjyjvy5nRiYvcrIyMq2QToWPOQcRvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81AE61FB;
	Thu, 15 Feb 2024 11:02:43 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A46043F762;
	Thu, 15 Feb 2024 11:02:00 -0800 (PST)
Message-ID: <a9d10aaa-e6b1-44bd-8d7e-9e1abedf03d1@arm.com>
Date: Thu, 15 Feb 2024 19:01:59 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/17] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Content-Language: en-GB
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
 Moritz Fischer <moritzf@google.com>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Zhangfei Gao <zhangfei.gao@linaro.org>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuMx0w6MDWpkLne@google.com>
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZcuMx0w6MDWpkLne@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/02/2024 3:37 pm, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Feb 06, 2024 at 11:12:40AM -0400, Jason Gunthorpe wrote:
>> Logically arm_smmu_init_strtab() is the function that allocates and
>> populates the stream table with the initial value of the STEs. After this
>> function returns the stream table should be fully ready.
>>
>> arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
>> any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
>> ensures there is no disruption to the identity mapping during boot.
>>
>> Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
>> already executes immediately after arm_smmu_init_strtab().
>>
>> No functional change intended.
> 
> I think arm_smmu_init_strtab is quite low level to abstract FW configuration in it.
> For example in KVM[1] we'd re-use a big part of this driver and rely on similar
> low-level functions. But no strong opinion.

Right, the fact that RMR handling is currently based on bypass STEs is 
an implementation detail; if we ever get round to doing the strict 
version with full-on temporary pagetables, that would obviously not 
belong in init_strtab, thus I would prefer to leave the "handle RMRs" 
step in its appropriate place in the higher-level flow regardless of how 
it happens to be named and implemented today.

Thanks,
Robin.

> 
> [1] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/
> 
> 
> Thanks,
> Mostafa
> 
>> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
>> Tested-by: Moritz Fischer <moritzf@google.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 6123e5ad95822c..2ab36dcf7c61f5 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -101,6 +101,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
>>   	{ 0, NULL},
>>   };
>>   
>> +static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
>> +
>>   static void parse_driver_options(struct arm_smmu_device *smmu)
>>   {
>>   	int i = 0;
>> @@ -3256,6 +3258,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>>   	cfg->strtab_base_cfg = reg;
>>   
>>   	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -3279,6 +3282,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
>>   
>>   	ida_init(&smmu->vmid_map);
>>   
>> +	/* Check for RMRs and install bypass STEs if any */
>> +	arm_smmu_rmr_install_bypass_ste(smmu);
>>   	return 0;
>>   }
>>   
>> @@ -4073,9 +4078,6 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
>>   	/* Record our private device structure */
>>   	platform_set_drvdata(pdev, smmu);
>>   
>> -	/* Check for RMRs and install bypass STEs if any */
>> -	arm_smmu_rmr_install_bypass_ste(smmu);
>> -
>>   	/* Reset the device */
>>   	ret = arm_smmu_device_reset(smmu, bypass);
>>   	if (ret)
>> -- 
>> 2.43.0
>>
