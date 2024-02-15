Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C769C41A81;
	Thu, 15 Feb 2024 20:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027906; cv=none; b=lpcBjvTMq3pdUtHBurqAhPRDqKqC8RmZSK7AOHX+N/ZK444WfSFGANXjx9Iredul3nt3OvdgseXBHxNL+9F7unTPEBqEmePTweqNg9vW0rKDf9poCyfbFFwIaxGSWlpA8VHIJbOKVwk9qLGRCZ7WRb5Mu1dQvGIVi/SqzyBKfBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027906; c=relaxed/simple;
	bh=w0L/MOA/fkr556Qg1RcbmrCGeoN0/E/yyfJjAdS4C9c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SvVY2rdXOakH118abzy34Ww9MmFrxBdivAvFycyhLGawcMwO7Y+sfREdPm4tZ7muWnMmhRqq/34oTYoWUPCm4xkeVTVhle+I+ihBisJ24zZo9cmCyhIS8nUaVLotxFlmt4LhfqAydsqiN8iXkjEoc+7I99oKWKwRY+if0StL+LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE9041FB;
	Thu, 15 Feb 2024 12:12:23 -0800 (PST)
Received: from [10.57.50.88] (unknown [10.57.50.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DC893F766;
	Thu, 15 Feb 2024 12:11:40 -0800 (PST)
Message-ID: <a0c62629-999f-4aa1-86c7-3104811f84d0@arm.com>
Date: Thu, 15 Feb 2024 20:11:38 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Content-Language: en-GB
From: Robin Murphy <robin.murphy@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Lu Baolu <baolu.lu@linux.intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
 Moritz Fischer <moritzf@google.com>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck> <20240215160135.GL1088888@nvidia.com>
 <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
In-Reply-To: <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-02-15 6:42 pm, Robin Murphy wrote:
[...]
>>>> +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 
>>>> *used_bits)
>>>>   {
>>>> +    unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, 
>>>> le64_to_cpu(ent[0]));
>>>> +
>>>> +    used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
>>>> +    if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
>>>> +        return;
>>>> +
>>>> +    /*
>>>> +     * See 13.5 Summary of attribute/permission configuration 
>>>> fields for the
>>>> +     * SHCFG behavior. It is only used for BYPASS, including S1DSS 
>>>> BYPASS,
>>>> +     * and S2 only.
>>>> +     */
>>>> +    if (cfg == STRTAB_STE_0_CFG_BYPASS ||
>>>> +        cfg == STRTAB_STE_0_CFG_S2_TRANS ||
>>>> +        (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
>>>> +         FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
>>>> +             STRTAB_STE_1_S1DSS_BYPASS))
>>>> +        used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
>>>
>>> Huh, SHCFG is really getting in the way here, isn't it?
>>
>> I wouldn't say that.. It is just a complicated bit of the spec. One of
>> the things we recently did was to audit all the cache settings and, at
>> least, we then realized that SHCFG was being subtly used by S2 as
>> well..
> 
> Yeah, that really shouldn't be subtle; incoming attributes are replaced 
> by S1 translation, thus they are relevant to not-S1 configs.

That said, in this specific case I don't understand why we're worrying 
about SHCFG here at all - we're never going to make use of any value 
other than "use incoming" because we can't rely on it being implemented 
in the first place, and even if it is, we really don't want to start 
getting into the forced-coherency notion that the DMA layer can'#t 
understand and devicetree can't describe.

We're still unconditionally setting the "use incoming" value for MTCFG, 
ALLOCCFG, PRIVCFG and INSTCFG without checking them, so there's no logic 
in pretending SHCFG is any different from its peers simply because its 
encoding is slightly less convenient. If the micro-optimisation of not 
setting it when we know it's going to be ignored anyway starts getting 
in the way, just drop that.

Thanks,
Robin.
