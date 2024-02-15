Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A4F1386B8;
	Thu, 15 Feb 2024 18:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708022572; cv=none; b=NpJsxZNsBQWvda5EYp1jntM1RWc1Ea+ENSik+LXDqiNiRNfEp05Ivs/JBILU38FhW8JmGQVtCMn/CO5cxiCINh1Z4dGFCVGNpCcx9GNbHdNpS/yrZPjElIPuP3mmhd5ESrUjzTXM/d4DYF8VVYjSgRgS/W6m5JBNvAT7mJ1Ripk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708022572; c=relaxed/simple;
	bh=yVRQ3ag9UVa0k4NtsTkrJMzHb7F4uZ0AJfhrbSLTVUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5u8vlHKfLJPsQvytDQ6zw7LhD/EV65JtIFJIj2bq5+6ZClWEjPjetqfmd6AfeoGhfV2patrNj7zr2fvauFs+aFgvkDERIyElmVm7F3290kn1IFc+gI2vpedqxdTx2uTca9DhfgThGRu+VhQf3rxuyaoE/qyfH9BmlL6OGUyHX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C1311FB;
	Thu, 15 Feb 2024 10:43:29 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 368023F762;
	Thu, 15 Feb 2024 10:42:38 -0800 (PST)
Message-ID: <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
Date: Thu, 15 Feb 2024 18:42:37 +0000
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
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20240215160135.GL1088888@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/02/2024 4:01 pm, Jason Gunthorpe wrote:
> On Thu, Feb 15, 2024 at 01:49:53PM +0000, Will Deacon wrote:
>> Hi Jason,
>>
>> On Tue, Feb 06, 2024 at 11:12:38AM -0400, Jason Gunthorpe wrote:
>>> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
>>> been limited to only work correctly in certain scenarios that the caller
>>> must ensure. Generally the caller must put the STE into ABORT or BYPASS
>>> before attempting to program it to something else.
>>
>> This is looking pretty good now, but I have a few comments inline.
> 
> Ok
> 
>>> @@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
>>>   	ARM_SMMU_MAX_MSIS,
>>>   };
>>>   
>>> +struct arm_smmu_entry_writer_ops;
>>> +struct arm_smmu_entry_writer {
>>> +	const struct arm_smmu_entry_writer_ops *ops;
>>> +	struct arm_smmu_master *master;
>>> +};
>>> +
>>> +struct arm_smmu_entry_writer_ops {
>>> +	unsigned int num_entry_qwords;
>>> +	__le64 v_bit;
>>> +	void (*get_used)(const __le64 *entry, __le64 *used);
>>> +	void (*sync)(struct arm_smmu_entry_writer *writer);
>>> +};
>>
>> Can we avoid the indirection for now, please? I'm sure we'll want it later
>> when you extend this to CDs, but for the initial support it just makes it
>> more difficult to follow the flow. Should be a trivial thing to drop, I
>> hope.
> 
> We can.

Ack, the abstraction is really hard to follow, and much of that seems 
entirely self-inflicted in the amount of recalculating information which 
was in-context in a previous step but then thrown away. And as best I 
can tell I think it will still end up doing more CFGIs than needed.

Keeping a single monolithic check-and-update function will be *so* much 
easier to understand and maintain. As far as CDs go, anything we might 
reasonably want to change in a live CD is all in the first word so I 
don't see any value in attempting to generalise further on that side of 
things. Maybe arm_smmu_write_ctx_desc() could stand to be a bit 
prettier, but honestly I don't think it's too bad as-is.

>>> +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>>>   {
>>> +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
>>> +
>>> +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
>>> +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
>>> +		return;
>>> +
>>> +	/*
>>> +	 * See 13.5 Summary of attribute/permission configuration fields for the
>>> +	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
>>> +	 * and S2 only.
>>> +	 */
>>> +	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
>>> +	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
>>> +	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
>>> +	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
>>> +		     STRTAB_STE_1_S1DSS_BYPASS))
>>> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
>>
>> Huh, SHCFG is really getting in the way here, isn't it?
> 
> I wouldn't say that.. It is just a complicated bit of the spec. One of
> the things we recently did was to audit all the cache settings and, at
> least, we then realized that SHCFG was being subtly used by S2 as
> well..

Yeah, that really shouldn't be subtle; incoming attributes are replaced 
by S1 translation, thus they are relevant to not-S1 configs.

I think it's likely to be significantly more straightforward to give up 
on the switch statement and jump straight into the more architectural 
paradigm at this level, e.g.

	// Stage 1
	if (cfg & BIT(0)) {
		...
	} else {
		...
	}
	// Stage 2
	if (cfg & BIT(1)) {
		...
	} else {
		...
	}

Thanks,
Robin.
